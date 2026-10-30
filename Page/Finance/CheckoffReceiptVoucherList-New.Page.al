page 50632 "Checkoff Rct. Voucher List-New"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checkoff Receipt Header";
    CardPageId = 50630;
    SourceTableView = WHERE(Status = FILTER(New),
                            Posted = filter(false));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Agent Code"; "Agent Code")
                {
                    ApplicationArea = All;

                }
                field("Agent Name"; "Agent Name")
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
                field(Description; Description)
                {
                    ApplicationArea = All;

                }

                field(Amount; Amount)
                {
                    ApplicationArea = All;

                }
                field("Total Line Amount"; "Total Line Amount")
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