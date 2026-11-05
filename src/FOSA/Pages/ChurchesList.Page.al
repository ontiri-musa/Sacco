page 51305 Churches
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Church;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;

                }
                field(Name; Name)
                {
                    ApplicationArea = All;

                }
                /*                 field("Church Section Code"; "Church Section Code")
                                {
                                    ApplicationArea = All;

                                } */
                field("Church District Code"; "Church District Code")
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