page 50109 "ATM Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("ATM Application Nos."; "ATM Application Nos.")
                {
                    ApplicationArea = All;
                }
                field("ATM Collection Nos."; "ATM Collection Nos.")
                {
                    ApplicationArea = All;
                }
                field("ATM Activation Nos."; "ATM Activation Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("ATM Journal Template"; "ATM Journal Template")
                {
                    ApplicationArea = All;
                }
                field("ATM Batch Name"; "ATM Batch Name")
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