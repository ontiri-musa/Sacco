page 50790 "Open Tender List- CEO Approved"
{
    // version TL2.0

    Caption = 'Open Tender List - CEO Approved';
    CardPageID = "Open Tender Card";
    PageType = List;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Procurement Request";
    SourceTableView = WHERE("Procurement Option" = FILTER('Open Tender'),
                            "Process Status" = FILTER(CEO),
                            Status = FILTER(Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Requisition No."; "Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan No."; "Procurement Plan No.")
                {
                    ApplicationArea = All;
                }
                field("Process Status"; "Process Status")
                {
                    ApplicationArea = All;
                }
                field("Assigned User"; "Assigned User")
                {
                    ApplicationArea = All;
                }
                field("Created On"; "Created On")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        ProcurementSetup.Get();
        UserSetup.Get(UserId);
        if UserSetup."User ID" <> ProcurementSetup."CEO's Account" then begin
            Error(CEOErrorTxt);
        end;
    end;

    var
        ProcurementSetup: Record "Procurement Setup";
        UserSetup: Record "User Setup";
        CEOErrorTxt: Label 'You are not Set up as the CEO';
}

