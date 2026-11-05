report 50051 "Run Standing Order"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Standing Order"; "Standing Order")
        {
            //DataItemTableView = WHERE(Running = FILTER(true));
            RequestFilterFields = "No.", "Next Run Date";

            trigger OnAfterGetRecord()
            begin
                i += 1;

                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, Description);
                    ProgressWindow.UPDATE(2, "Member No.");
                    ProgressWindow.UPDATE(3, "Member Name");
                    ProgressWindow.UPDATE(4, "Source Account No.");
                    ProgressWindow.UPDATE(5, "Source Account Name");
                END;

                BOSAManagement.PostStandingOrder("Standing Order");
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(6, (i / TotalSTO * 10000) DIV 1);
            end;

            trigger OnPostDataItem()
            begin
                IF GUIALLOWED THEN
                    ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                StandingOrderSetup.GET;
                GlobalManagement.ClearJournal(StandingOrderSetup."Standing Order Template Name", StandingOrderSetup."Standing Order Batch Name");
                SETRANGE("Next Run Date", TODAY);
                TotalSTO := COUNT;

                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005 + Text006);
                i := 0;
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
        ProgressWindow: Dialog;
        i: Integer;
        TotalSTO: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        StandingOrderSetup: Record "Standing Order Setup";
        Text000: Label 'Running Standing Orders...\';
        Text001: Label 'Description         #1#############################\';
        Text002: Label 'Member No.          #2#############################\';
        Text003: Label 'Member Name         #3#############################\';
        Text004: Label 'Source Account No.  #4#############################\\';
        Text005: Label 'Source Account Name #5#############################\';
        Text006: Label 'Progress            @6@@@@@@@@@@@@@@@@@@@@@@@\';
}

