codeunit 50016 "Trailing Members Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        TrailingMemberSetup: Record "Trailing Member Setup";
        Member: Record Member;

    procedure OnOpenPage(var TrailingMemberSetup: Record "Trailing Member Setup")
    begin
        with TrailingMemberSetup do
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
        Member: Record Member;
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingMemberSetup.Get(UserId);
        if Evaluate(Member.Status, BusChartBuf.GetMeasureValueString(Measure), 9) then
            Member.SetRange(Status, Member.Status);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        Member.SetRange("Created Date", 0D, ToDate);
        PAGE.Run(PAGE::"Member List", Member);
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: array[4] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        Membertatus: Integer;
    begin
        TrailingMemberSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := TrailingMemberSetup."Period Length";
            SetPeriodXAxis;

            CreateMap(ChartToStatusMap);
            for Membertatus := 1 to ArrayLen(ChartToStatusMap) do begin
                Member.Status := ChartToStatusMap[Membertatus];
                AddMeasure(Format(Member.Status), Member.Status, "Data Type"::Decimal, TrailingMemberSetup.GetChartType);
            end;

            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);

                for Membertatus := 1 to ArrayLen(ChartToStatusMap) do begin
                    TotalValue := 0;
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        Value := GetMemberValue(ChartToStatusMap[Membertatus], FromDate[ColumnNo], ToDate[ColumnNo]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;

                        SetValueByIndex(Membertatus - 1, ColumnNo - 1, TotalValue);
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
        ToDate[MaxPeriodNo] := TrailingMemberSetup.GetStartDate;
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

    local procedure GetMemberValue(Status: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        exit(GetMemberCount(Status, FromDate, ToDate));
    end;


    local procedure GetMemberCount(Status: Option; FromDate: Date; ToDate: Date): Decimal
    begin
        Member.SetRange(Status, Status);
        Member.SetRange("Created Date", FromDate, ToDate);
        exit(Member.Count);
    end;

    procedure CreateMap(var Map: array[4] of Integer)
    var
        Member: Record Member;
    begin
        Map[1] := Member.Status::Active;
        Map[2] := Member.Status::Withdrawn;
        Map[3] := Member.Status::Suspended;
        Map[4] := Member.Status::Dormant;
    end;
}

