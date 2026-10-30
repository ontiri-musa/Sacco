report 50114 "Overpayment Transfer"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = WHERE("Customer Type" = FILTER(Loan));
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                LoanApplicationSetup.Get();
                JournalTemplateName := LoanApplicationSetup."Loan Overpayment Template Name";
                JournalBatchName := LoanApplicationSetup."Loan Overpayment Batch Name";
                GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);

                i := 0;
                TotalLoanAccount := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;

                CalcFields("Balance (LCY)");
                if "Balance (LCY)" >= 0 then
                    CurrReport.Skip();
                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "No.");
                    ProgressWindow.UPDATE(2, Name);
                end;
                BOSAManagement.LoanOverpaymentTransfer(Customer);
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(3, (i / TotalLoanAccount * 10000) DIV 1);
                //SLEEP(5);
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

    begin
        ClearLastError();

        IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
            Message('Overpayment Transfer Completed');
        end else
            Message(GetLastErrorText);


    end;



    var
        Text000: Label 'Overpayment Transfer...\';
        Text001: Label 'Loan No.      #1#############################\';
        Text002: Label 'Description   #2#############################\';
        Text003: Label 'Progress      @3@@@@@@@@@@@@@@@@@@@@@@@\';

        ProgressWindow: Dialog;
        i: Integer;
        TotalLoanAccount: Integer;
        GlobalManagement: Codeunit "Global Management";
        BOSAManagement: Codeunit "BOSA Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        DateFormula: DateFormula;
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];


}

