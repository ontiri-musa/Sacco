page 50380 "Bulk SMS Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bulk SMS Setup";

    layout
    {
        area(Content)
        {
            group(BulkSMS)
            {
                field("API Key"; "API Key")
                {
                    ApplicationArea = All;

                }
                field("Short Code"; "Short Code")
                {
                    ApplicationArea = All;

                }
                field("Partner ID"; "Partner ID")
                {
                    ApplicationArea = All;

                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;

                }
                field(Password; Password)
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
             action(ActionName)
             {
                 ApplicationArea = All;

                 trigger OnAction()
                 begin

                 end;
             }
         }
     } */
    trigger OnAfterGetRecord()
    begin


    end;

    var
        myInt: Integer;
}