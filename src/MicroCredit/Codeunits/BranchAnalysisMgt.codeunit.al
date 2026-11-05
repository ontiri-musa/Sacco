codeunit 50090 "Branch Analysis Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        BranchAnalysisSetup: Record "Branch Analysis Setup";
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";

    procedure OnOpenPage(var BranchAnalysisSetup: Record "Branch Analysis Setup")
    begin
        with BranchAnalysisSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert;
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
        BranchAnalysisSetup.Get(UserId);
        if Evaluate(LoanProductType.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            LoanProductType.SetRange(Description, LoanProductType.Description);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: Text;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        LoanProductTypeCode: code[20];
        DimensionValue: Record "Dimension Value";
        TotalDV: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        BranchAnalysisSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            i := 0;
            if LoanProductType.FindSet() then begin
                repeat
                    i += 1;
                    AddMeasure(LoanProductType.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until LoanProductType.Next() = 0;
            end;
            j := 0;
            SetXAxis('BranchCode', "Data Type"::String);
            DimensionValue.SetRange("Dimension Code", 'BRANCH');
            TotalDV := DimensionValue.Count;
            if DimensionValue.FindSet() then begin
                repeat
                    j += 1;
                    AddColumn(DimensionValue.Name);
                    FOR k := 1 TO i do
                        SetValueByIndex(k - 1, j - 1, GetDisbursedAmounts(k, DimensionValue.Code));
                until DimensionValue.Next() = 0;
            end;
        end;
    end;

    local procedure GetDisbursedAmounts(Index: Integer; BranchCode: Code[20]) AmountDisbursed: Decimal
    var
        LoanProductType2: Record "Loan Product Type";
        l: Integer;
    begin
        l := 0;
        if LoanProductType2.FindSet() then begin
            repeat
                l += 1;
                if l = Index then begin
                    AmountDisbursed := 0;
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Loan Product Type", LoanProductType2.Code);
                    LoanApplication.SetRange("Global Dimension 1 Code", BranchCode);
                    if LoanApplication.FindSet() then begin
                        repeat
                            AmountDisbursed += LoanApplication."Approved Amount";
                        until LoanApplication.Next() = 0;
                    end;
                end;
            until LoanProductType2.Next() = 0;
        end;
        exit(Abs(AmountDisbursed))
    end;
}
