page 50040 "Member Bank Accounts List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Bank Account";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = All;

                }
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = All;

                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;

                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;

                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;

                }
                field(Default; Default)
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