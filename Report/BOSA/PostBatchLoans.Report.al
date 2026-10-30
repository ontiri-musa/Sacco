report 50127 "Post Batch Loans"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = WHERE(Status = filter(Approved), Posted = filter(false));
            RequestFilterFields = "No.", "Loan Product Type";
            trigger OnPreDataItem()
            begin
                LoanApplicationSetup.Get();
                LoanApplicationSetup.TestField("Loan Disbursal Template Name");
                LoanApplicationSetup.TestField("Loan Disbursal Batch Name");

                GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");

                IF GUIALLOWED THEN
                    i := 0;
                TotalAccount := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "No.");
                    ProgressWindow.UPDATE(2, Description);
                    ProgressWindow.UPDATE(3, "Approved Amount");
                    ProgressWindow.UPDATE(4, Remarks);
                end;
                BOSAManagement.PostLoan("Loan Application");
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(5, (i / TotalAccount * 10000) DIV 1);
                IF GlobalManagement.PostJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name") THEN BEGIN
                    Posted := true;
                    Modify();
                END ELSE
                    ERROR(GETLASTERRORTEXT);
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



    var
        Text000: Label 'Posting Batch Loans\';
        Text001: Label 'Loan No.        #1#############################\';
        Text002: Label 'Description       #2#############################\';
        Text003: Label 'Approved Amount   #3#############################\\';
        Text004: Label 'Remarks  #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        Text007: Label 'Posting failed';
        ProgressWindow: Dialog;
        i: Integer;
        TotalAccount: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanApplication: Record "Loan Application";
        DateFormula: DateFormula;


}

