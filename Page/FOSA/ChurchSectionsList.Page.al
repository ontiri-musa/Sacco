page 51304 "Church Sections"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Church Section";

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