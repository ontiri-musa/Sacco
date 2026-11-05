codeunit 50048 "Trailing Payroll Summary Mgt."
{
    trigger OnRun()
    begin

    end;

    var
        TrailingPayrollSummarySetup: Record "Trailing Payroll Summary Setup";
        PayrollEntries: Record "Payroll Entries";

    procedure OnOpenPage(var TrailingPayrollSummarySetup: Record "Trailing Payroll Summary Setup")
    begin
        with TrailingPayrollSummarySetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Use Work Date as Base" := true;
                "Period Length" := "Period Length"::Month;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert();
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var

        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingPayrollSummarySetup.Get(UserId);
        if Evaluate(PayrollEntries.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            PayrollEntries.SetRange(Code, PayrollEntries.Code);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: array[3] of Integer;
        ToDate: array[4] of Date;
        FromDate: array[4] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        Payrolltatus: Integer;

    begin
        TrailingPayrollSummarySetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := TrailingPayrollSummarySetup."Period Length";
            SetPeriodXAxis;
            CreateMap(ChartToStatusMap);
            for Payrolltatus := 1 to ArrayLen(ChartToStatusMap) do begin
                TrailingPayrollSummarySetup."Show Payroll" := ChartToStatusMap[Payrolltatus];
                AddMeasure(Format(TrailingPayrollSummarySetup."Show Payroll"), TrailingPayrollSummarySetup."Show Payroll", "Data Type"::Decimal, TrailingPayrollSummarySetup.GetChartType);
            end;

            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
                for Payrolltatus := 1 to ArrayLen(ChartToStatusMap) do begin
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        TotalValue := 0;
                        Value := GetPayrollValue(ChartToStatusMap[Payrolltatus], FromDate[ColumnNo], ToDate[ColumnNo]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;
                        SetValueByIndex(Payrolltatus - 1, ColumnNo - 1, TotalValue);
                    end;
                end;
            end;
        end;
    end;

    local procedure CalcPeriods(var FromDate: array[4] of Date; var ToDate: array[4] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := TrailingPayrollSummarySetup.GetStartDate;
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

    local procedure GetPayrollValue(Status: Option; FromDate: Date; ToDate: Date): Decimal
    var
        NetSal: Decimal;
    begin
        if Status = 1 then begin
            exit(GetGrossAmount(FromDate, ToDate));
        end;
        if Status = 2 then begin
            exit(GetDeductionAmount(FromDate, ToDate));
        end;
        if Status = 3 then begin
            NetSal := 0;
            NetSal := GetGrossAmount(FromDate, ToDate) + GetDeductionAmount(FromDate, ToDate);
            exit(NetSal);
        end;

    end;

    local procedure GetGrossAmount(FromDate: Date; ToDate: Date): Decimal
    var
        GrossAmount: Decimal;
        EarningsSetup: Record "Earnings Setup";
    begin
        GrossAmount := 0;
        PayrollEntries.Reset();
        PayrollEntries.SetRange(Type, PayrollEntries.Type::Payment);
        PayrollEntries.SetRange("Non-Cash Benefit", false);
        PayrollEntries.SetRange("Payroll Period", FromDate, ToDate);
        if PayrollEntries.FindSet(true) then begin
            repeat
                EarningsSetup.Reset();
                if EarningsSetup.Get(PayrollEntries.Code) then begin
                    if EarningsSetup."Non-Cash Benefit" = false then
                        GrossAmount += PayrollEntries.Amount;
                end;
            until PayrollEntries.Next() = 0;
        end;
        exit(GrossAmount);
    end;

    local procedure GetDeductionAmount(FromDate: Date; ToDate: Date): Decimal
    var
        GrossDedAmount: Decimal;
    begin
        GrossDedAmount := 0;
        PayrollEntries.Reset();
        PayrollEntries.SetRange(Type, PayrollEntries.Type::Deduction);
        PayrollEntries.SetRange("Payroll Period", FromDate, ToDate);
        if PayrollEntries.FindSet(true) then begin
            repeat
                GrossDedAmount += PayrollEntries.Amount;
            until PayrollEntries.Next() = 0;
        end;
        exit(GrossDedAmount);
    end;

    procedure CreateMap(var Map: array[3] of Integer)
    var

    begin
        Map[1] := TrailingPayrollSummarySetup."Show Payroll"::"Gross Earnings";
        Map[2] := TrailingPayrollSummarySetup."Show Payroll"::"Gross Deductions";
        Map[3] := TrailingPayrollSummarySetup."Show Payroll"::"Net Pay";

    end;
}