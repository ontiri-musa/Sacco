codeunit 50046 "Trailing Earnings Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        TrailingEarningsSetup: Record "Trailing Earnings Setup";
        EarningsSetup: Record "Earnings Setup";

    procedure OnOpenPage(var TrailingEarningSetup: Record "Trailing Earnings Setup")
    begin
        with TrailingEarningSetup do
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
        EarningsSetup: Record "Earnings Setup";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingEarningsSetup.Get(UserId);
        if Evaluate(EarningsSetup.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            EarningsSetup.SetRange(Code, EarningsSetup.Code);

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
        EarnNumber: Integer;
        EarningsSetup: Record "Earnings Setup";
        PayrollPeriod: Record "Payroll Period";
        TotalMonths: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
        EarningCode: array[100] of Code[20];
        TotalEarning: Decimal;

    begin
        TrailingEarningsSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := TrailingEarningsSetup."Period Length";
            SetPeriodXAxis;
            i := 0;
            EarningsSetup.Reset();
            EarningsSetup.SetRange("Non-Cash Benefit", false);
            if EarningsSetup.FindSet() then begin
                repeat
                    i += 1;
                    EarningCode[i] := EarningsSetup.Code;
                    AddMeasure(EarningsSetup.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until EarningsSetup.Next() = 0;
            end;
            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
                for EarnNumber := 1 to i do begin
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        TotalValue := 0;
                        Value := GetTotalEarnings(FromDate[ColumnNo], ToDate[ColumnNo], EarningCode[EarnNumber]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;
                        SetValueByIndex(EarnNumber - 1, ColumnNo - 1, TotalValue);
                    end;
                end;
            end;
        end;
    end;

    local procedure GetTotalEarnings(FromDate: Date; ToDate: Date; EarningCode: Code[20]): Decimal
    var
        PayrollEntries: record "Payroll Entries";
        EarningsSetup: Record "Earnings Setup";
        AccountBalance: Decimal;
    begin
        PayrollEntries.Reset();
        PayrollEntries.SetRange(Type, PayrollEntries.Type::Payment);
        PayrollEntries.SetRange(code, EarningCode);
        PayrollEntries.SetRange("Payroll Period", FromDate, ToDate);
        if PayrollEntries.FindSet() then begin
            repeat
                AccountBalance += PayrollEntries.Amount;
            until PayrollEntries.Next() = 0;
        end;
        exit(AccountBalance)
    end;

    local procedure CalcPeriods(var FromDate: array[4] of Date; var ToDate: array[4] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := TrailingEarningsSetup.GetStartDate;
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