page 50106 "Tellering Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Tellering Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Teller Transaction Nos."; "Teller Transaction Nos.")
                {
                    ApplicationArea = All;
                }
                field("Teller Return Treasury Nos."; "Teller Return Treasury Nos.")
                {
                    ApplicationArea = All;
                }
                field("Teller Close Till Nos."; "Teller Close Till Nos.")
                {
                    ApplicationArea = All;
                }

                field("Inter Teller Transfer Nos"; "Inter Teller Transfer Nos")
                {
                    ApplicationArea = All;
                }

            }
            group(Posting)
            {
                field("Teller Template Name"; "Teller Template Name")
                {
                    ApplicationArea = All;
                }
                field("Teller Batch Name"; "Teller Batch Name")
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
            /*   action(ActionName)
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