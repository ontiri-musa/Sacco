codeunit 50065 "Procurement Charts Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        //ProcurementCharts: Record "Procurement Graphs";;
        ProcurementCharts: Record "Procurement Graphs";
        Employee: Record Employee;
        RequisitionHeader: Record "Requisition Header";

    procedure OnOpenPage(var ProcurementCharts: Record "Procurement Graphs")
    begin
        with ProcurementCharts do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Use Work Date as Base" := true;
                "Period Length" := "Period Length"::Month;
                "Chart Type" := "Chart Type"::"Stacked Column";
                "Primary Key" := UpdateKey();
                Insert;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        Employee: Record Employee;
        RequisitionHeader: Record "Requisition Header";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        ProcurementCharts.get(UserId);
        if Evaluate(RequisitionHeader.Status, BusChartBuf.GetMeasureValueString(Measure), 9) then
            RequisitionHeader.SetRange(Status, RequisitionHeader.Status);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        RequisitionHeader.SetRange("Requisition Date", 0D, ToDate);
        Page.Run(PAGE::"Requisitions List", RequisitionHeader);
        //Employee.SetRange("Employment Date", 0D, ToDate);
        //Page.Run(PAGE::"Employee List", Employee);
    end;

    procedure UpdateKey(): Integer
    var
        ProcurementCharts2: Record "Procurement Graphs";
    begin
        ProcurementCharts2.Reset();
        if ProcurementCharts2.FindLast() then begin
            exit(ProcurementCharts2."Primary Key" + 1);
        end else begin
            exit(1);
        end;

    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: array[6] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        RequisitionStatus: Integer;
    begin
        ProcurementCharts.get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := ProcurementCharts."Period Length";
            SetPeriodXAxis;

            CreateMap(ChartToStatusMap);
            for RequisitionStatus := 1 to ArrayLen(ChartToStatusMap) do begin
                RequisitionHeader.Status := ChartToStatusMap[RequisitionStatus];
                AddMeasure(Format(RequisitionHeader.Status), RequisitionHeader.Status, "Data Type"::Decimal, ProcurementCharts.GetChartType);
            end;

            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
                for RequisitionStatus := 1 to ArrayLen(ChartToStatusMap) do begin
                    TotalValue := 0;
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        Value := GetRequestValue(ChartToStatusMap[RequisitionStatus], FromDate[ColumnNo], ToDate[ColumnNo]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;
                        SetValueByIndex(RequisitionStatus - 1, ColumnNo - 1, TotalValue);
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
        ToDate[MaxPeriodNo] := ProcurementCharts.GetStartDate;
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

    local procedure GetRequestValue(Status: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        exit(GetRequestCount(Status, FromDate, ToDate));
    end;

    local procedure GetRequestCount(ReqStatus: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        RequisitionHeader.Reset();
        RequisitionHeader.SetRange(Status, ReqStatus);
        RequisitionHeader.SetRange("Requisition Date", FromDate, ToDate);
        exit(RequisitionHeader.Count);
    end;

    procedure CreateMap(var Map: array[6] of Integer)
    var
        //Employee: Record Employee;
        RequisitionHeader: Record "Requisition Header";
    begin
        /* Map[1] := Employee."Employee Status"::Active;
        Map[2] := Employee."Employee Status"::Confirmed;
        Map[3] := Employee."Employee Status"::Probation;
        Map[4] := Employee."Employee Status"::Terminated;
         */
        Map[1] := RequisitionHeader.Status::New;
        Map[2] := RequisitionHeader.Status::"Pending Approval";
        Map[3] := RequisitionHeader.Status::Released;
        Map[4] := RequisitionHeader.Status::Issued;
        Map[5] := RequisitionHeader.Status::"Pending Return";
        Map[6] := RequisitionHeader.Status::Returned;
    end;
}

