page 50112 "Treasury Return Bank Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Treasury Return Bank Line";
    RefreshOnActivate = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Treasury)
            {

                field("Treasury Account No."; "Treasury Account No.")
                {
                    ApplicationArea = All;

                }
                field("Treasury Account Name"; "Treasury Account Name")
                {
                    ApplicationArea = All;

                }
                field("Treasury Account Balance"; "Treasury Account Balance")
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