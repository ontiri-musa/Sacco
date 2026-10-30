page 50373 "Agent Applications-Approved"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Agent Application";
    SourceTableView = WHERE(Status = FILTER(Approved));
    CardPageId = 50370;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
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
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }

                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Device Phone No."; "Device Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Device Serial No."; "Device Serial No.")
                {
                    ApplicationArea = All;
                }
                field(Location; Location)
                {
                    ApplicationArea = All;
                }
                field("Business Name"; "Business Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}