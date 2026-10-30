page 50107 "Treasury Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Treasury Setup";
    ;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Treasury Transaction Nos."; "Treasury Transaction Nos.")
                {
                    ApplicationArea = All;
                }
                field("Treasury Request Nos."; "Treasury Request Nos.")
                {
                    ApplicationArea = All;
                }
                field("Treasury Return Bank Nos."; "Treasury Return Bank Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Treasury Template Name"; "Treasury Template Name")
                {
                    ApplicationArea = All;
                }
                field("Treasury Batch Name"; "Treasury Batch Name")
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