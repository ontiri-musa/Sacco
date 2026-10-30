report 56889 "Reverse Attached Loan"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                LoanDef: Record "Loan Defaulter Entry";
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "No.");
                    ProgressWindow.UPDATE(4, Description);

                    LoanDef.Reset();
                    LoanDef.SetRange("Loan No.", DataItem1."No.");
                    if LoanDef.FindLast then begin
                        BOSAManagement.ReverseAttachedLoan(LoanDef);
                    end;

                    ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
                END;
                SLEEP(50);
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                i := 0;
                LoanDefaulterSetup.GET;
                // SETRANGE("Attach Status", "Attach Status"::" ");
                //  SETRANGE("Notice Category", LoanDefaulterSetup."Attach on");

                TotalLoan := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
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

    labels
    {
    }

    var
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        Text000: Label 'Attaching Loan to Guarantors\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        LoanDefaulterSetup: Record "Loan Defaulter Setup";
}

