page 50234 "Member Exit List-Approved"
{
    // version TL2.0

    Caption = 'Approved Member Exit';
    CardPageID = "Member Exit";
    Editable = false;
    PageType = List;
    SourceTable = "Member Exit Header";
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
                field("Reason for Exit"; "Reason for Exit")
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

