report 50463 "Capitalize Penalty"
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
                if RunDate = 0D then
                    Error(Text008);

                LoanApplicationSetup.Get();
                LoanApplicationSetup.TestField("Penalty Template Name");
                LoanApplicationSetup.TestField("Penalty Batch Name");

                GlobalManagement.ClearJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name");

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

                LoanProductType.Get("Loan Product Type");
                if ("Balance (LCY)" <= 0) or (not LoanProductType."Charge Penalty on Defaulters") or (not IsLoanDefaulter("No.")) then
                    CurrReport.Skip();

                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "No.");
                    ProgressWindow.UPDATE(4, Name);
                end;
                //BOSAManagement.CapitalizePenalty(Customer, RunDate);
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
            area(Content)
            {
                field(RunDate; RunDate)
                {
                    ApplicationArea = All;
                    Caption = 'Penalty Run Date';
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
        IF GUIALLOWED THEN BEGIN
            IF GlobalManagement.PostJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name") THEN BEGIN

            END ELSE
                ERROR(GETLASTERRORTEXT);
        end;
    end;

    local procedure IsLoanDefaulter(LoanNo: Code[20]): Boolean
    var
        LoanDefaulterEntry: Record "Loan Defaulter Entry";
    begin
        LoanDefaulterEntry.Reset();
        LoanDefaulterEntry.SetRange("Loan No.", LoanNo);
        exit(LoanDefaulterEntry.FindFirst());
    end;

    var
        Text000: Label 'Capitalizing Penalty...\';
        Text001: Label 'Member No.   #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.     #3#############################\\';
        Text004: Label 'Description  #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        Text007: Label 'Posting failed';
        Text008: Label 'Kindly indicate penalty run date';
        ProgressWindow: Dialog;
        RunDate: Date;
        i: Integer;
        TotalLoanAccount: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanProductType: Record "Loan Product Type";

}

