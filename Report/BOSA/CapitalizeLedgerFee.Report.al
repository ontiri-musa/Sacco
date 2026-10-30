report 50460 "Capitalize Ledger Fee"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = where("Customer Type" = filter(Loan));
            RequestFilterFields = "No.", "Loan Product Type";
            trigger OnPreDataItem()
            begin
                LoanApplicationSetup.Get();
                LoanApplicationSetup.TestField("Ledger Fee Template Name");
                LoanApplicationSetup.TestField("Ledger Fee Batch Name");

                GlobalManagement.ClearJournal(LoanApplicationSetup."Ledger Fee Template Name", LoanApplicationSetup."Ledger Fee Batch Name");

                IF GUIALLOWED THEN
                    i := 0;
                TotalLoanAccount := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                CalcFields("Balance (LCY)");
                if "Balance (LCY)" <= 0 then
                    CurrReport.Skip();
                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "No.");
                    ProgressWindow.UPDATE(4, Name);
                end;
                BOSAManagement.CapitalizeLedgerFee(Customer);
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(5, (i / TotalLoanAccount * 10000) DIV 1);
                SLEEP(0);
            end;

            trigger OnPostDataItem()
            begin

            end;




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

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        IF GUIALLOWED THEN BEGIN
            IF GlobalManagement.PostJournal(LoanApplicationSetup."Ledger Fee Template Name", LoanApplicationSetup."Ledger Fee Batch Name") THEN BEGIN

            END ELSE
                ERROR(GETLASTERRORTEXT);
        end;
    end;

    var
        Text000: Label 'Capitalizing Ledger Fee...\';
        Text001: Label 'Member No.   #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.     #3#############################\\';
        Text004: Label 'Description  #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        Text007: Label 'Posting failed';
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoanAccount: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";


}

