report 50129 "Check Dormancy"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                IF GUIALLOWED THEN
                    i := 0;
                TotalMembers := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN begin
                    ProgressWindow.UPDATE(1, "No.");
                    ProgressWindow.UPDATE(2, "Full Name");

                end;

                FOSAManagement.CheckDormancy(Member);
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(3, (i / TotalMembers * 10000) DIV 1);
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

    trigger OnPostReport()
    var
        myInt: Integer;
    begin

    end;

    var
        Text000: Label 'Checking Dormancy..\';
        Text001: Label 'Member No.   #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress     @3@@@@@@@@@@@@@@@@@@@@@@@\';
        ProgressWindow: Dialog;
        i: Integer;
        TotalMembers: Integer;
        FOSAManagement: Codeunit "FOSA Management";
        Vendor: Record Vendor;



}

