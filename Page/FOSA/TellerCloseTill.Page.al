page 50363 "Teller Close Till"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Teller Close Till";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;

                }
            }
            /*    part("InterTeller Transfer Subform"; "InterTeller Transfer Subform")
               {
                   ApplicationArea = All;
                   SubPageLink = "Document No." = field("No.");

               } */
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