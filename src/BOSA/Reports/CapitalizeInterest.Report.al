report 50050 "Capitalize Interest"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where(Posted = Filter(true));


            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("No.");
                //DataItemTableView = where("Customer Type" = filter(Loan));
                RequestFilterFields = "No.", "Loan Product Type";
                trigger OnAfterGetRecord()
                begin
                    BOSAManagement.CapitalizeInterest(Customer, RunDate, PostingDate);
                end;

                trigger OnPostDataItem()
                begin

                end;
            }

            trigger OnPreDataItem()
            begin
                if PostingDate = 0D then
                    Error(Text008)
                else
                    RunDate := CalcDate('CM', CalcDate('-1M', PostingDate));

                LoanApplicationSetup.Get();
                LoanApplicationSetup.TestField("Penalty Template Name");
                LoanApplicationSetup.TestField("Penalty Batch Name");

                GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");

                IF GUIALLOWED THEN
                    i := 0;
                TotalLoanAccount := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                //CalcFields("Balance (LCY)");
                //if "Balance (LCY)" <= 0 then
                //CurrReport.Skip();
                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "No.");
                    ProgressWindow.UPDATE(4, Description);
                end;
                //Message('Loan No %1 Member Name %2', Customer."No.", Customer."Member Name");
                //BOSAManagement.CapitalizeInterest(Customer, RunDate);
                if "Loan Application"."Date of Completion" < RunDate then CurrReport.Skip();
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(5, (i / TotalLoanAccount * 10000) DIV 1);
                SLEEP(0);
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                /*  IF GUIALLOWED THEN BEGIN
                      IF GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name") THEN BEGIN

                      END ELSE
                          ERROR(GETLASTERRORTEXT);
                  end;*/
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        //IF GUIALLOWED THEN BEGIN
        //IF GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name") THEN BEGIN
        //UpdateNexDueDate(LoanApplication);
        //END ELSE
        //ERROR(GETLASTERRORTEXT);
        //end;
    end;

    var
        Text000: Label 'Capitalizing Interest..\';
        Text001: Label 'Member No.   #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.     #3#############################\\';
        Text004: Label 'Description  #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        Text007: Label 'Posting failed';
        Text008: Label 'Kindly indicate interest run date';
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoanAccount: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanApplication: Record "Loan Application";
        DateFormula: DateFormula;
        RunDate: Date;
        PostingDate: Date;


}

