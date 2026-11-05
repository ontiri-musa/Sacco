report 50128 "Recalculate Schedule"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = WHERE(Status = filter(Approved), Posted = filter(true));
            RequestFilterFields = "No.", "Loan Product Type";
            trigger OnPreDataItem()
            begin
                IF GUIALLOWED THEN
                    i := 0;
                TotalLoan := COUNT;
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
                BOSAManagement.CreateRepaymentSchedule("No.", "Approved Amount");
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);

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
        Text000: Label 'Recalculating Schedule ..\';
        Text001: Label 'Loan No.          #1#############################\';
        Text002: Label 'Description       #2#############################\';
        Text003: Label 'Approved Amount   #3#############################\\';
        Text004: Label 'Remarks           #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        LoanApplication: Record "Loan Application";
        DateFormula: DateFormula;


}

