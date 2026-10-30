codeunit 50019 "BOSA Chart Management"
{
    trigger OnRun()
    begin
    end;

    var
        LoanProductType: Record "Loan Product Type";

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        LoanProductType: Record "Loan Product Type";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        if Evaluate(LoanProductType.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            LoanProductType.SetRange(Code, LoanProductType.Code);


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
                        SetValueByIndex(k - 1, j - 1, GetLoanProductTypeBalance(k, DimensionValue.Code));
                until DimensionValue.Next() = 0;
            end;
        end;
    end;

    local procedure GetLoanProductTypeBalance(Index: Integer; BranchCode: Code[20]) AccountBalance: Decimal
    var
        Customer: record Customer;
        LoanProductType2: Record "Loan Product Type";
        l: Integer;
    begin
        l := 0;
        if LoanProductType2.FindSet() then begin
            repeat
                l += 1;
                if l = Index then begin
                    AccountBalance := 0;
                    Customer.Reset();
                    Customer.SetRange("Customer Posting Group", LoanProductType2.Code);
                    if Customer.FindSet() then begin
                        repeat
                            AccountBalance += SumCLE(Customer."No.", BranchCode);
                        until Customer.Next() = 0;
                    end;
                end;
            until LoanProductType2.Next() = 0;
        end;
        exit(Abs(AccountBalance))
    end;

    procedure SumCLE(LoanProductCode: Code[20]; BranchCode2: Code[20]) TotalAmount: Decimal
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustomerLedgerEntry.Reset();
        CustomerLedgerEntry.SetRange("Customer No.", LoanProductCode);
        CustomerLedgerEntry.SetRange("Global Dimension 1 Code", BranchCode2);
        if CustomerLedgerEntry.FindSet() then begin
            repeat
                CustomerLedgerEntry.CalcFields("Amount (LCY)");
                TotalAmount += CustomerLedgerEntry.Amount;
            until CustomerLedgerEntry.Next() = 0;
        end;
        exit(Abs(TotalAmount))
    end;
}

