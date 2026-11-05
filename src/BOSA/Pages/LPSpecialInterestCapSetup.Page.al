page 51334 "LP Special Int. Cap. Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LP Special Int. Cap. Setup";
    AutoSplitKey = true;

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
                field("Capitalization Day"; "Capitalization Day")
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