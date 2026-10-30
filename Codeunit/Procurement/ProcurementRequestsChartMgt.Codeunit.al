codeunit 50066 "Procurement Req. Chart Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        //ProcurementCharts: Record "Procurement Graphs";;
        //ProcurementCharts: Record "Procurement Graphs";
        Employee: Record Employee;
        //RequisitionHeader: Record "Requisition Header";
        ProcurementRequest: Record "Procurement Request";
        ProcurementReqCharts: Record "Procurement Requests Charts";

    procedure OnOpenPage(var ProcurementReqCharts: Record "Procurement Requests Charts")
    begin
        with ProcurementReqCharts do
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
        //RequisitionHeader: Record "Requisition Header";
        ProcurementRequest: Record "Procurement Request";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        ProcurementReqCharts.get(UserId);
        if Evaluate(ProcurementRequest."Procurement Option", BusChartBuf.GetMeasureValueString(Measure), 9) then
            ProcurementRequest.SetRange("Procurement Option", ProcurementRequest."Procurement Option");
        /* if Evaluate(RequisitionHeader.Status, BusChartBuf.GetMeasureValueString(Measure), 9) then
            RequisitionHeader.SetRange(Status, RequisitionHeader.Status); */

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        //RequisitionHeader.SetRange("Requisition Date", 0D, ToDate);
        //Page.Run(PAGE::"Requisitions List", RequisitionHeader);
    end;

    procedure UpdateKey(): Integer
    var
        //ProcurementCharts2: Record "Procurement Graphs";
        ProcurementReqCharts: Record "Procurement Requests Charts";
    begin
        ProcurementReqCharts.Reset();
        if ProcurementReqCharts.FindLast() then begin
            exit(ProcurementReqCharts."Primary Key" + 1);
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
        ProcRequestStatus: Integer;
        ProcurementReqCharts: Record "Procurement Requests Charts";
    begin
        ProcurementReqCharts.get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := ProcurementReqCharts."Period Length";
            SetPeriodXAxis;

            CreateMap(ChartToStatusMap);
            for ProcRequestStatus := 1 to ArrayLen(ChartToStatusMap) do begin
                ProcurementRequest."Procurement Option" := ChartToStatusMap[ProcRequestStatus];
                AddMeasure(Format(ProcurementRequest."Procurement Option"), ProcurementRequest."Procurement Option", "Data Type"::Decimal, ProcurementReqCharts.GetChartType);
            end;

            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
                for ProcRequestStatus := 1 to ArrayLen(ChartToStatusMap) do begin
                    TotalValue := 0;
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        Value := GetRequestValue(ChartToStatusMap[ProcRequestStatus], FromDate[ColumnNo], ToDate[ColumnNo]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;
                        SetValueByIndex(ProcRequestStatus - 1, ColumnNo - 1, TotalValue);
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
        ToDate[MaxPeriodNo] := ProcurementReqCharts.GetStartDate;
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

    local procedure GetRequestValue(ReqOption: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        exit(GetRequestCount(ReqOption, FromDate, ToDate));
    end;

    local procedure GetRequestCount(ReqOption: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        ProcurementRequest.Reset();
        ProcurementRequest.SetRange("Procurement Option", ReqOption);
        ProcurementRequest.SetRange("Created On", FromDate, ToDate);
        exit(ProcurementRequest.Count);
    end;

    procedure CreateMap(var Map: array[6] of Integer)
    var
        //Employee: Record Employee;
        //RequisitionHeader: Record "Requisition Header";
        ProcurementRequest: Record "Procurement Request";
    begin
        /* Map[1] := Employee."Employee Status"::Active;
        Map[2] := Employee."Employee Status"::Confirmed;
        Map[3] := Employee."Employee Status"::Probation;
        Map[4] := Employee."Employee Status"::Terminated;
         */
        Map[1] := ProcurementRequest."Procurement Option"::Direct; //RequisitionHeader.Status::New;
        Map[2] := ProcurementRequest."Procurement Option"::"Low Value";
        Map[3] := ProcurementRequest."Procurement Option"::"Request For Quotation";
        Map[4] := ProcurementRequest."Procurement Option"::"Request For Proposal";
        Map[5] := ProcurementRequest."Procurement Option"::"Open Tender";
        Map[6] := ProcurementRequest."Procurement Option"::"Restricted Tender";
    end;
}


