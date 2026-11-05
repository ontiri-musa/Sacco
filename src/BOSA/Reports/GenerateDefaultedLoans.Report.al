report 50054 "Generate Defaulted Loans"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));

            trigger OnPreDataItem()
            begin
                LoanDefaulterEntry.DELETEALL;
                if EndDate = 0D then
                    EndDate := Today;

                i := 0;
                TotalLoan := COUNT;
                //IF GUIALLOWED THEN
                ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            end;

            trigger OnAfterGetRecord()
            var
                Loan: Record "Loan Application";
            begin
                i += 1;
                //IF GUIALLOWED THEN BEGIN
                ProgressWindow.UPDATE(1, "Member No.");
                ProgressWindow.UPDATE(2, "Member Name");
                ProgressWindow.UPDATE(3, "No.");
                ProgressWindow.UPDATE(4, Description);
                Loan.Reset();
                Loan.SetRange("No.", "Loan Application"."No.");
                Loan.SetFilter("Disbursal Date", '<=%1', EndDate);
                if Loan.FindFirst() then begin
                    BOSAManagement.GenerateDefaultedLoans(Loan, EndDate);
                end;
                ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
                //END;
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(EndDate; EndDate)
                    {
                        Caption = 'As At Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {

        }
    }

    labels
    {
    }

    var
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        EndDate: Date;
        Text000: Label 'Generating Defaulted Loans\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        LoanDefaulterEntry: Record "Loan Defaulter Entry";
}

