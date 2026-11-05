report 50995 "correct Loan Restructures"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'correct Loan Restructures';



    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            PrintOnlyIfDetail = true;

            column(No_; "No.")
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(Loan_Product_Type; "Loan Product Type")
            {
            }
            column(Member_No_; "Member No.")
            {
            }
            trigger OnAfterGetRecord()
            begin
                //   if "No." = 'BLN02826' then begin
                LoanReschedulingSetup.Get();
                SourceCodeSetup.Get();
                GlobalSetup.Get();
                TransactionTypeCodeSetup.Get();

                LoanReschedulingSetup.TestField("Loan Resch. Template Name");
                LoanReschedulingSetup.TestField("Loan Resch. Batch Name");

                JournalTemplateName := LoanReschedulingSetup."Loan Resch. Template Name";
                JournalBatchName := LoanReschedulingSetup."Loan Resch. Batch Name";

                GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
                GlobalManagement.DeductLoanArrearsRestructuring(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, '' /*fnGetLoanRestructuringNO("No.")*/, /*fnGetLoanRestructuringNO("No.")*/'', fnGetLoanRestructuringApprovedDate("No."), "No.", fnGetLoanOutBalAsatApprvDate("No.", fnGetLoanRestructuringApprovedDate("No.")), "Global Dimension 1 Code");
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, ''/*fnGetLoanRestructuringNO("No.")*/, /*fnGetLoanRestructuringNO("No.")*/'', fnGetLoanRestructuringApprovedDate("No."), AccountTypeEnum::Customer, "No.", "Loan Product Type" + ' -' + 'Loan Restructure',
                fnGetLoanOutBalAsatApprvDate("No.", fnGetLoanRestructuringApprovedDate("No.")), '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, "Loan Application"."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

                //    GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName);



            end;
            // end;

        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {

    }

    trigger OnPreReport()
    begin

    end;

    local procedure fnGetLoanRestructuringApprovedDate(loanNo: Code[30]) apprvDate: Date
    var
        lnRestructuring: Record "Loan Restructuring";
    begin
        lnRestructuring.Reset();
        lnRestructuring.SetRange("Loan No.", loanNo);
        if lnRestructuring.Find('-') then begin
            apprvDate := lnRestructuring."Approved Date";
        end;
        exit(apprvDate);
    end;

    /* local procedure fnGetLoanRestructuringNO(loanNo: Code[30]) code: Code[35]
     var
         lnRestructuring: Record "Loan Restructuring";
     begin
         lnRestructuring.Reset();
         lnRestructuring.SetRange("Loan No.", loanNo);
         if lnRestructuring.Find('-') then begin
             code := lnRestructuring."No.";
         end;
         exit(code);
     end;*/

    local procedure fnGetLoanOutBalAsatApprvDate(loanNo: Code[50]; lnDate: Date) outbal: Decimal
    begin
        DetailedCustLedgEntry.Reset();
        DetailedCustLedgEntry.SetRange("Customer No.", loanNo);
        DetailedCustLedgEntry.SetFilter("Posting Date", '..%1', lnDate);
        if DetailedCustLedgEntry.FindSet() then begin
            repeat
                outbal += DetailedCustLedgEntry.Amount;
            until DetailedCustLedgEntry.Next() = 0;
        end;
        exit(outbal);
    end;

    var
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        SourceCodeSetup: Record "Source Code Setup";
        GlobalSetup: Record "Global Setup";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        GlobalManagement: Codeunit "Global Management";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";



}

