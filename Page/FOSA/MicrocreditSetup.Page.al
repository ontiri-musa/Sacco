page 50391 "Microcredit Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Microcredit Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Group Attendance Nos."; "Group Attendance Nos.")
                {
                    ApplicationArea = All;
                }
                field("Group Allocation Nos."; "Group Allocation Nos.")
                {
                    ApplicationArea = All;
                }
                field("Portfolio Transfer Nos."; "Portfolio Transfer Nos.")
                {
                    ApplicationArea = All;
                }

                field("Group In-Transit Account Type"; "Group In-Transit Account Type")
                {
                    ApplicationArea = All;
                }
                field("Group Allocation Report Code"; "Group Allocation Report Code")
                {
                    ApplicationArea = All;
                }
                field("Group Attendance Report Code"; "Group Attendance Report Code")
                {
                    ApplicationArea = All;
                }
                field("Group Collection Report Code"; "Group Collection Report Code")
                {
                    ApplicationArea = All;
                }

                field("Group Collection Control A/c"; "Group Collection Control A/c")
                {
                    ApplicationArea = All;
                }
                field("Group Paybill Nos."; "Group Paybill Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("GP Allocation Template Name"; "GP Allocation Template Name")
                {
                    ApplicationArea = All;
                }
                field("GP Allocation Batch Name"; "GP Allocation Batch Name")
                {
                    ApplicationArea = All;
                }
                field("GP Collection Template Name"; "GP Collection Template Name")
                {
                    ApplicationArea = All;
                }
                field("GP Collection Batch Name"; "GP Collection Batch Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            /* action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            } */
        }
    }

    var
        myInt: Integer;
}