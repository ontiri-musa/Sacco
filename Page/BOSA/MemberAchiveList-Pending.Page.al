page 59233 "Member Achive List-Pending"
{
    // version TL2.0

    Caption = 'Pending Member Archive';
    CardPageID = "Member Achive";
    Editable = false;
    PageType = List;
    SourceTable = "Member Achive Header";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"));
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
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Reason for Achive"; "Reason for Achive")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; "Approved Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

