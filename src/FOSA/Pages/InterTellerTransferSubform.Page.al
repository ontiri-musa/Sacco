page 50395 "InterTeller Transfer Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "InterTeller Transfer Line";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;

                }
                field("Teller User ID"; "Teller User ID")
                {
                    ApplicationArea = All;

                }
                field(Amount; Amount)
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
            /*    action(ActionName)
               {
                   ApplicationArea = All;

                   trigger OnAction();
                   begin

                   end;
               } */
        }
    }
}