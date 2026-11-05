page 50081 "Treasury Transaction Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Treasury Transaction Line";
    RefreshOnActivate = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Treasury)
            {

                field("Till No."; "Till No.")
                {
                    ApplicationArea = All;

                }
                field("Till Name"; "Till Name")
                {
                    ApplicationArea = All;

                }
                field("Teller User ID"; "Teller User ID")
                {
                    ApplicationArea = All;

                }

                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;

                }
            }
        }

    }

    /*  actions
     {
         area(Processing)
         {
             action(Post)
             {
                 ApplicationArea = All;

                 trigger OnAction();
                 begin

                 end;
             }
         }
     } */
}