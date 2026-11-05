page 50067 "Teller User Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller User Setup";

    layout
    {
        area(Content)
        {
            repeater(TellerUser)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;

                }
                field("Till No."; "Till No.")
                {
                    ApplicationArea = All;

                }
                field("Treasury Account No."; "Treasury Account No.")
                {
                    ApplicationArea = All;

                }
                field("Maximum Withdrawal"; "Maximum Withdrawal")
                {
                    ApplicationArea = All;

                }
                field("Maximum Deposit"; "Maximum Deposit")
                {
                    ApplicationArea = All;

                }
                field("Withdrawal Allowed"; "Withdrawal Allowed")
                {
                    ApplicationArea = All;

                }
                field("Withdrawal Limit (Approval)"; "Withdrawal Limit (Approval)")
                {
                    ApplicationArea = All;

                }
                field("Deposit Limit (Approval)"; "Deposit Limit (Approval)")
                {
                    ApplicationArea = All;

                }
                field("Till Minimum Amount"; "Till Minimum Amount")
                {
                    ApplicationArea = All;

                }
                field("Till Maximum Amount"; "Till Maximum Amount")
                {
                    ApplicationArea = All;

                }
                field("Till Replenishment Level"; "Till Replenishment Level")
                {
                    ApplicationArea = All;

                }

                field("Deposit Allowed"; "Deposit Allowed")
                {
                    ApplicationArea = All;

                }
                field("Cheque Deposit Allowed"; "Cheque Deposit Allowed")
                {
                    ApplicationArea = All;

                }
                field(Active; Active)
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