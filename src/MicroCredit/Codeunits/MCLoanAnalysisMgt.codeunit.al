codeunit 50092 "Loan Analysis Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        LoanAnalysisSetup: Record "MC Loan Analysis Setup";
        ClassificationSetup: Record "Loan Classification Setup";
        ClassificationEntries: Record "Loan Classification Entry";

    procedure OnOpenPage(var LoanAnalysisSetup: Record "MC Loan Analysis Setup")
    begin
        with LoanAnalysisSetup do
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
        LoanAnalysisSetup.Get(UserId);
        if Evaluate(ClassificationSetup.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            ClassificationSetup.SetRange(Description, ClassificationSetup.Description);

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
        DimensionValue: Record "Dimension Value";
        TotalDV: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        LoanAnalysisSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            i := 0;
            if ClassificationSetup.FindSet() then begin
                repeat
                    i += 1;
                    AddMeasure(ClassificationSetup.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until ClassificationSetup.Next() = 0;
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
                        SetValueByIndex(k - 1, j - 1, GetAccountBalances(k, DimensionValue.Code));
                until DimensionValue.Next() = 0;
            end;
        end;
    end;

    local procedure GetAccountBalances(Index: Integer; BranchCode: Code[20]) OutstandingAmount: Decimal
    var
        ClassificationSetup2: Record "Loan Classification Setup";
        l: Integer;
    begin
        l := 0;
        if ClassificationSetup2.FindSet() then begin
            repeat
                l += 1;
                if l = Index then begin
                    OutstandingAmount := 0;
                    ClassificationEntries.Reset();
                    ClassificationEntries.SetRange("Classification Date", Today);
                    ClassificationEntries.SetRange("Class Description", ClassificationSetup2.Description);
                    ClassificationEntries.SetRange("Global Dimension 1 Code", BranchCode);
                    if ClassificationEntries.FindSet() then begin
                        repeat
                            OutstandingAmount += ClassificationEntries."Outstanding Balance";
                        until ClassificationEntries.Next() = 0;
                    end;
                end;
            until ClassificationSetup2.Next() = 0;
        end;
        exit(Abs(OutstandingAmount))
    end;
}
