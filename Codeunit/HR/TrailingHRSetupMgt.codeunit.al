codeunit 50057 "Trailing HR Setup Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        TrailingHRSetup: Record "Trailing HR Setup";
        Employee: Record Employee;

    procedure OnOpenPage(var TrailingHRSetup: Record "Trailing HR Setup")
    begin
        with TrailingHRSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Use Work Date as Base" := true;
                "Period Length" := "Period Length"::Month;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        Employee: Record Employee;
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingHRSetup.Get(UserId);
        if Evaluate(Employee."Employee Status", BusChartBuf.GetMeasureValueString(Measure), 9) then
            Employee.SetRange("Employee Status", Employee."Employee Status");

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        Employee.SetRange("Employment Date", 0D, ToDate);
        Page.Run(PAGE::"Employee List", Employee);
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: array[4] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        EmployeeStatus: Integer;
    begin
        TrailingHRSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := TrailingHRSetup."Period Length";
            SetPeriodXAxis;

            CreateMap(ChartToStatusMap);
            for EmployeeStatus := 1 to ArrayLen(ChartToStatusMap) do begin
                Employee."Employee Status" := ChartToStatusMap[EmployeeStatus];
                AddMeasure(Format(Employee."Employee Status"), Employee."Employee Status", "Data Type"::Decimal, TrailingHRSetup.GetChartType);
            end;

            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);

                for EmployeeStatus := 1 to ArrayLen(ChartToStatusMap) do begin
                    TotalValue := 0;
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        Value := GetEmployeeValue(ChartToStatusMap[EmployeeStatus], FromDate[ColumnNo], ToDate[ColumnNo]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;

                        SetValueByIndex(EmployeeStatus - 1, ColumnNo - 1, TotalValue);
                    end;
                end;
            end;
        end;
    end;

    local procedure CalcPeriods(var FromDate: array[5] of Date; var ToDate: array[5] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := TrailingHRSetup.GetStartDate;
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

    local procedure GetEmployeeValue(Status: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        exit(GetEmployeeCount(Status, FromDate, ToDate));
    end;


    local procedure GetEmployeeCount(Status: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        Employee.SetRange("Employee Status", Status);
        Employee.SetRange("Employment Date", FromDate, ToDate);
        exit(Employee.Count);
    end;

    procedure CreateMap(var Map: array[4] of Integer)
    var
        Employee: Record Employee;
    begin
        Map[1] := Employee."Employee Status"::Active;
        Map[2] := Employee."Employee Status"::Confirmed;
        Map[3] := Employee."Employee Status"::Probation;
        Map[4] := Employee."Employee Status"::Terminated;
    end;
}

