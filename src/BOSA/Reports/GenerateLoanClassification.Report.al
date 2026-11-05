report 50053 "Generate Loan Classification"
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
                i := 0;
                LoanClassificationEntry.DELETEALL;
                if EndDate = 0D then
                    EndDate := Today;

                TotalLoan := COUNT;
                ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            end;

            trigger OnAfterGetRecord()
            var
                Loan: Record "Loan Application";
            begin
                i += 1;
                ProgressWindow.UPDATE(1, "Member No.");
                ProgressWindow.UPDATE(2, "Member Name");
                ProgressWindow.UPDATE(3, "No.");
                ProgressWindow.UPDATE(4, Description);

                Loan.Reset();
                Loan.SetRange("No.", "Loan Application"."No.");
                Loan.SetFilter("Disbursal Date", '<=%1', EndDate);
                Loan.SetFilter("Date Filter", '..%1', EndDate);
                if Loan.FindFirst() then begin

                    DCustL.Reset();
                    DCustL.SetRange("Customer No.", Loan."No.");
                    DCustL.SetFilter("Posting Date", '..%1', EndDate);
                    DCustL.SetRange("Entry Type", DCustL."Entry Type"::"Initial Entry");
                    if not DCustL.Find('-') then
                        CurrReport.Skip();

                    Loan.CalcFields("Outstanding Balance");
                    //If Loan."Outstanding Balance" > 0 Then
                    BOSAManagement.GenerateLoanClassification(Loan, EndDate);
                end;

                ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
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

