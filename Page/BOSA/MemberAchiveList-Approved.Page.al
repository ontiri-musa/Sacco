page 59234 "Member Achive List-Approved"
{
    // version TL2.0

    Caption = 'Approved Member Archive';
    CardPageID = "Member Achive";
    Editable = false;
    PageType = List;
    SourceTable = "Member Achive Header";
    SourceTableView = WHERE(Status = FILTER(Approved), Posted = const(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reason for Achive"; "Reason for Achive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("No. Series"; "No. Series")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Approved Time"; "Approved Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

