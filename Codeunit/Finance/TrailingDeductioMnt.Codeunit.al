codeunit 50047 "Trailing Deductions Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        TrailingDeductionsSetup: Record "Trailing Deductions Setup";
        DeductionsSetup: Record "Deductions Setup";

    procedure OnOpenPage(var TrailingDeductionsSetup: Record "Trailing Deductions Setup")
    begin
        with TrailingDeductionsSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Use Work Date as Base" := true;
                "Period Length" := "Period Length"::Month;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert();
            end;
        ;
        ;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        DeductionsSetup: Record "Deductions Setup";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;

        TrailingDeductionsSetup.Get(UserId);
        if Evaluate(DeductionsSetup.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            DeductionsSetup.SetRange(Code, DeductionsSetup.Code);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: Text;
        ToDate: array[4] of Date;
        FromDate: array[4] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        Deductions: Integer;
        DeductionsSetup: Record "Deductions Setup";
        PayrollPeriod: Record "Payroll Period";
        TotalMonths: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
        DeductionCode: array[100] of Code[20];
        TotalDeduction: Decimal;

    begin
        TrailingDeductionsSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := TrailingDeductionsSetup."Period Length";
            SetPeriodXAxis;
            i := 0;

            DeductionsSetup.Reset();
            if DeductionsSetup.FindSet() then begin
                repeat
                    i += 1;
                    DeductionCode[i] := DeductionsSetup.Code;
                    AddMeasure(DeductionsSetup.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until DeductionsSetup.Next() = 0;
            end;
            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
                for Deductions := 1 to i do begin
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        TotalValue := 0;
                        Value := GetTotalDeductions(FromDate[ColumnNo], ToDate[ColumnNo], DeductionCode[Deductions]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;
                        SetValueByIndex(Deductions - 1, ColumnNo - 1, TotalValue);
                    end;
                end;
            end;
        end;
    end;

    local procedure GetTotalDeductions(FromDate: Date; ToDate: Date; DeductionCode: Code[20]): Decimal
    var
        PayrollEntries: record "Payroll Entries";
        DeductionsSetup: Record "Deductions Setup";
        AccountBalance: Decimal;
    begin
        PayrollEntries.Reset();
        PayrollEntries.SetRange(Type, PayrollEntries.Type::Deduction);
        PayrollEntries.SetRange(code, DeductionCode);
        PayrollEntries.SetRange("Payroll Period", FromDate, ToDate);
        if PayrollEntries.FindSet() then begin
            repeat
                AccountBalance += PayrollEntries.Amount;
            until PayrollEntries.Next() = 0;
        end;
        exit(Abs(AccountBalance))
    end;

    local procedure CalcPeriods(var FromDate: array[4] of Date; var ToDate: array[4] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := TrailingDeductionsSetup.GetStartDate;
        if ToDate[MaxPeriodNo] = 0D then
            exit(false);
        for i := MaxPeriodNo downto 1 do begin
            if i > 1 then begin
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            end else
                FromDate[i] := 0D
        end;
        exit(true);
    end;
}