codeunit 50022 "Trailing Loan Class. Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        LoanClassificationSetup: Record "Loan Classification Setup";
        TrailingClassificationSetup: Record "Trailing Classification Setup";

    procedure OnOpenPage(var TrailingClassificationSetup: Record "Trailing Classification Setup")
    begin
        with TrailingClassificationSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        LoanClassificationSetup: Record "Loan Classification Setup";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingClassificationSetup.Get(UserId);
        if Evaluate(LoanClassificationSetup.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            LoanClassificationSetup.SetRange(Code, LoanClassificationSetup.Code);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        //LoanProductType.SetRange("Created Date", 0D, ToDate);
        // PAGE.Run(PAGE::"LoanProductType List", LoanProductType);
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        DimensionValue: Record "Dimension Value";
        TotalDV: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        TrailingClassificationSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            i := 0;
            if LoanClassificationSetup.FindSet() then begin
                repeat
                    i += 1;
                    AddMeasure(LoanClassificationSetup.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until LoanClassificationSetup.Next() = 0;
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
                        SetValueByIndex(k - 1, j - 1, GetClassificationBalance(k, DimensionValue.Code));
                until DimensionValue.Next() = 0;
            end;
        end;
    end;

    local procedure GetClassificationBalance(Index: Integer; BranchCode: Code[20]) AccountBalance: Decimal
    var
        LoanClassifficationEntry: record "Loan Classification Entry";
        LoanClassificationSetup2: Record "Loan Classification Setup";
        l: Integer;
    begin
        l := 0;
        if LoanClassificationSetup2.FindSet() then begin
            repeat
                l += 1;
                if l = Index then begin
                    AccountBalance := 0;
                    LoanClassifficationEntry.Reset();
                    LoanClassifficationEntry.SetRange("Classification Code", LoanClassificationSetup2.Code);
                    if LoanClassifficationEntry.FindSet() then begin
                        repeat
                            AccountBalance += SumClassAmount(LoanClassifficationEntry."Classification Code", BranchCode);
                        until LoanClassifficationEntry.Next() = 0;
                    end;
                end;
            until LoanClassificationSetup2.Next() = 0;
        end;
        exit(Abs(AccountBalance))
    end;

    procedure SumClassAmount(ClassCode: Code[20]; BranchCode2: Code[20]) TotalAmount: Decimal
    var
        LoanClassificationEntry: Record "Loan Classification Entry";
    begin
        LoanClassificationEntry.Reset();
        LoanClassificationEntry.SetRange("Classification Code", ClassCode);
        LoanClassificationEntry.SetRange("Global Dimension 1 Code", BranchCode2);
        if LoanClassificationEntry.FindSet() then begin
            repeat
                //LoanClassificationEntry.CalcFields("Outstanding Balance");
                TotalAmount += LoanClassificationEntry."Outstanding Balance"
            until LoanClassificationEntry.Next() = 0;
        end;
        exit(Abs(TotalAmount))
    end;
}

