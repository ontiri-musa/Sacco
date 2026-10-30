page 51333 "LP Special Recovery Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LP Special Recovery Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Disbursal Start Day"; "Disbursal Start Day")
                {
                    ApplicationArea = All;

                }
                field("Disbursal End Day"; "Disbursal End Day")
                {
                    ApplicationArea = All;

                }
                field("Recovery Day"; "Recovery Day")
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
            /*   action(ActionName)
              {
                  ApplicationArea = All;

                  trigger OnAction();
                  begin

                  end;
              } */
        }
    }
}