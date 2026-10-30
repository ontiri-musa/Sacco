report 50009 "Daily Cash Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/DailyCashAnalysis.rdl';
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = filter(1));
            column(CompPicture; CompInfo.Picture)
            {

            }
            column(CompName; CompInfo.Name)
            {

            }
            column(AmountIn_1; AmountIn[1])
            {


            }
            column(AmountIn_2; AmountIn[2])
            {


            }
            column(AmountIn_3; AmountIn[3])
            {


            }
            column(AmountIn_4; AmountIn[4])
            {


            }
            column(AmountIn_5; AmountIn[5])
            {


            }
            column(AmountIn_6; AmountIn[6])
            {


            }
            column(AmountIn_7; AmountIn[7])
            {


            }
            column(AmountIn_8; AmountIn[8])
            {


            }
            column(AmountIn_9; AmountIn[9])
            {


            }
            column(AmountIn_10; AmountIn[10])
            {


            }
            column(AmountIn_11; AmountIn[11])
            {


            }
            column(AmountIn_12; AmountIn[12])
            {


            }
            column(AmountIn_13; AmountIn[13])
            {


            }
            column(AmountIn_14; AmountIn[14])
            {


            }

            column(AmountOut_1; AmountOut[1])
            {


            }
            column(AmountOut_2; AmountOut[2])
            {


            }
            column(AmountOut_3; AmountOut[3])
            {


            }
            column(AmountOut_4; AmountOut[4])
            {


            }
            column(AmountOut_5; AmountOut[5])
            {


            }
            column(AmountOut_6; AmountOut[6])
            {


            }
            column(AmountOut_7; AmountOut[7])
            {


            }
            column(AmountOut_8; AmountOut[8])
            {


            }
            column(AmountOut_9; AmountOut[9])
            {


            }
            column(AmountOut_10; AmountOut[10])
            {


            }
            column(AmountOut_11; AmountOut[11])
            {


            }
            column(AmountOut_12; AmountOut[12])
            {


            }
            column(CalculationDate; CalculationDate)
            {


            }
            column(DayofWeek; DayofWeek)
            {


            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                CalculateCashAnalysis();
                DayofWeek := FORMAT(CalculationDate, 0, '<Weekday Text>')
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Calculation)
                {
                    field(CalculationDate; CalculationDate)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    var

    begin
        CompInfo.get();
        CompInfo.CalcFields(Picture);
    end;

    local procedure CalculateCashAnalysis()
    var
        DRAmount: Decimal;
        CRAmount: Decimal;
        TotalLoan: Decimal;
        TotalPrincipalPaid: Decimal;
        TotalInterestPaid: Decimal;
    begin
        //CASH IN
        CalculateBLE('CASH', 0D, CalculationDate - 1, DRAmount, CRAmount);
        AmountIn[1] := DRAmount + CRAmount;

        Vendor.Reset();
        Vendor.SetRange("Account Type", '002');
        if Vendor.FindSet() then begin
            repeat
                CalculateVLE(Vendor."No.", DRAmount, CRAmount);
                AmountIn[2] += CRAmount;
            until Vendor.Next() = 0;
        end;



        CalculateGLE('003', DRAmount, CRAmount);
        AmountIn[3] := CRAmount;
        CalculateGLE('007', DRAmount, CRAmount);
        AmountIn[4] := CRAmount;
        CalculateCLE('', TotalLoan, TotalPrincipalPaid, TotalInterestPaid);
        AmountIn[5] := abs(TotalPrincipalPaid);
        AmountIn[6] := abs(TotalInterestPaid);
        CalculateBLE('COOP', CalculationDate, CalculationDate, DRAmount, CRAmount);
        AmountIn[7] := DRAmount;
        CalculateGLE('005', DRAmount, CRAmount);
        AmountIn[8] := CRAmount;
        CalculateGLE('004', DRAmount, CRAmount);
        AmountIn[9] := CRAmount;
        CalculateGLE('132', DRAmount, CRAmount);
        AmountIn[10] := CRAmount;

        Vendor.Reset();
        Vendor.SetRange("Account Type", '001');
        if Vendor.FindSet() then begin
            repeat
                CalculateVLE(Vendor."No.", DRAmount, CRAmount);
                AmountIn[11] += CRAmount;
            until Vendor.Next() = 0;
        end;


        Vendor.Reset();
        Vendor.SetRange("Account Type", '003');
        if Vendor.FindSet() then begin
            repeat
                CalculateVLE(Vendor."No.", DRAmount, CRAmount);
                AmountIn[12] := CRAmount;
            until Vendor.Next() = 0;
        end;


        CalculateGLE('006', DRAmount, CRAmount);
        AmountIn[13] := CRAmount;

        CalculateGLE('06', DRAmount, CRAmount);
        AmountIn[14] := CRAmount;

        //CASH OUT
        LoanApplication.Reset();
        LoanApplication.SetRange(Posted, true);
        LoanApplication.SetRange("Disbursal Date", CalculationDate);
        LoanApplication.SetRange("Mode of Disbursement", LoanApplication."Mode of Disbursement"::"Bank Account");
        LoanApplication.SetRange("Disbursal Account No.", 'CASH');
        IF LoanApplication.FindSet() then begin
            repeat
                CalculateCLE(LoanApplication."No.", TotalLoan, TotalPrincipalPaid, TotalInterestPaid);
                AmountOut[1] += TotalLoan;
            UNTIL LoanApplication.Next() = 0;
        END;

        CalculateBLE('COOP', CalculationDate, CalculationDate, DRAmount, CRAmount);
        AmountOut[2] := CRAmount;
        CalculateGLE('146', DRAmount, CRAmount);
        AmountOut[3] := DRAmount;
        CalculateGLE('141', DRAmount, CRAmount);
        AmountOut[4] := DRAmount;
        CalculateGLE('140', DRAmount, CRAmount);
        AmountOut[5] := DRAmount;
        CalculateGLE('135', DRAmount, CRAmount);
        AmountOut[6] := DRAmount;


        Vendor.Reset();
        Vendor.SetRange("Account Type", '001');
        if Vendor.FindSet() then begin
            repeat
                CalculateVLE(Vendor."No.", DRAmount, CRAmount);
                AmountOut[8] += DRAmount;
            until Vendor.Next() = 0;
        end;

        CalculateBLE('TREASURY', CalculationDate, CalculationDate, DRAmount, CRAmount);
        AmountOut[9] := DRAmount;
        CalculateBLE('KCB', CalculationDate, CalculationDate, DRAmount, CRAmount);
        AmountOut[10] := DRAmount;

    end;

    local procedure CalculateVLE(AccountNo: Code[20]; var TotalDRAmount: Decimal; var TotalCRAmount: Decimal)
    var

    begin
        TotalDRAmount := 0;
        TotalCRAmount := 0;

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Vendor No.", AccountNo);
        VendorLedgerEntry.SetRange("Posting Date", CalculationDate);
        if VendorLedgerEntry.FindSet() then begin
            repeat
                VendorLedgerEntry.CalcFields("Debit Amount", "Credit Amount");
                TotalDRAmount += VendorLedgerEntry."Debit Amount";
                TotalCRAmount += VendorLedgerEntry."Credit Amount";
            until VendorLedgerEntry.Next() = 0;
        end;

    end;

    local procedure CalculateCLE(AccountNo: Code[20]; VAR TotalLoan: Decimal; VAR TotalPrincipalPaid: Decimal; VAR TotalInterestPaid: Decimal)
    var
    begin
        TotalPrincipalPaid := 0;
        TotalInterestPaid := 0;
        CustLedgerEntry.Reset();
        // CustLedgerEntry.SetRange("Vendor No.", AccountNo);
        CustLedgerEntry.SetRange("Posting Date", CalculationDate);
        if CustLedgerEntry.FindSet() then begin
            repeat
                CustLedgerEntry.CalcFields(Amount);
                if CustLedgerEntry."Source Code" = 'LOAN' then
                    TotalLoan += CustLedgerEntry.Amount;
                if CustLedgerEntry."Source Code" = 'PPAID' then
                    TotalPrincipalPaid += CustLedgerEntry.Amount;
                if CustLedgerEntry."Source Code" = 'IPAID' then
                    TotalInterestPaid += CustLedgerEntry.Amount;
            until CustLedgerEntry.Next() = 0;
        end;

    end;

    local procedure CalculateGLE(AccountNo: Code[20]; var TotalDRAmount: Decimal; var TotalCRAmount: Decimal)
    var

    begin
        TotalDRAmount := 0;
        TotalCRAmount := 0;
        GLEntry.Reset();
        GLEntry.SetRange("G/L Account No.", AccountNo);
        GLEntry.SetRange("Posting Date", CalculationDate);
        if GLEntry.FindSet() then begin
            repeat
                TotalDRAmount += GLEntry."Debit Amount";
                TotalCRAmount += GLEntry."Credit Amount";
            until GLEntry.Next() = 0;
        end;

    end;

    local procedure CalculateBLE(AccountNo: Code[20]; StartDate: Date; EndDate: Date; var TotalDRAmount: Decimal; var TotalCRAmount: Decimal)
    var

    begin
        TotalDRAmount := 0;
        TotalCRAmount := 0;

        BankAccountLedgerEntry.Reset();
        BankAccountLedgerEntry.SetRange("Bank Account No.", AccountNo);
        BankAccountLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
        if BankAccountLedgerEntry.FindSet() then begin
            repeat
                TotalDRAmount += BankAccountLedgerEntry."Debit Amount";
                TotalCRAmount += BankAccountLedgerEntry."Credit Amount";
            until BankAccountLedgerEntry.Next() = 0;
        end;
    end;

    var
        BankAccount: Record "Bank Account";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        CompInfo: Record "Company Information";
        AmountIn: array[20] of Decimal;
        AmountOut: array[20] of Decimal;
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
        LoanApplication: Record "Loan Application";
        CalculationDate: Date;
        DayofWeek: Text;
}