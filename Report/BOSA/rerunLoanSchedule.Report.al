report 52253 "RerunSchedule"
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



            trigger OnAfterGetRecord()
            var
                Loan: Record "Loan Application";
            begin
                IF not Posted THEN BEGIN
                    TESTFIELD("Requested Amount");
                    BOSAManagement.CreateRepaymentSchedule("No.", "Requested Amount");
                    COMMIT;
                END else begin
                    BOSAManagement.CreateRepaymentSchedule("No.", "Approved Amount");
                    COMMIT;
                    //if "Loan Restructured" = true then
                    //BOSAManagement.CreateRepaymentScheduleRestructure("No.", "Approved Amount");
                END;
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
                        Visible = false;
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
        DateDiff: Decimal;
        EndDate: Date;
        i: Integer;
        TotalLoan: Integer;
        Loan2: Record "Loan Application";
        Text000: Label 'Generating Loan Classification\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name      #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        LoanClassificationEntry: Record "Loan Classification Entry";
        DCustL: Record "Detailed Cust. Ledg. Entry";
}

