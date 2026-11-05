report 50017 "Revoke Fixed/Call Deposit"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Fixed/Call Deposit Summary"; "Fixed/Call Deposit Summary")
        {
            // DataItemTableView = WHERE(Posted = FILTER(true));
            RequestFilterFields = "FD Account No.";
            trigger OnPreDataItem()
            begin
                i := 0;
                TotalAccount := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "FD Account No.");
                    ProgressWindow.UPDATE(2, "Account Type");
                    ProgressWindow.UPDATE(3, "Member No.");
                    ProgressWindow.UPDATE(4, "Member Name");
                end;
                FOSAManagement.RevokeFixedCallDeposit("Fixed/Call Deposit Summary");
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(5, (i / TotalAccount * 10000) DIV 1);
                SLEEP(50);
            end;

            trigger OnPostDataItem()
            begin
                //GlobalManagement.PostJournal(GlobalSetup."General Template Name", GlobalSetup."General Batch Name");

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

    end;

    var
        Text000: Label 'Revoking Fixed/Call Deposits\';
        Text001: Label 'Vendor No.      #1#############################\';
        Text002: Label 'Vendor Name  #2#############################\';
        Text003: Label 'Memeber No.     #3#############################\\';
        Text004: Label 'Member Name #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        Text007: Label 'Posting failed';
        ProgressWindow: Dialog;
        i: Integer;
        TotalAccount: Integer;
        FOSAManagement: Codeunit "FOSA Management";
        GlobalManagement: Codeunit "Global Management";


}

