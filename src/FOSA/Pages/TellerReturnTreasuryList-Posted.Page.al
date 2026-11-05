page 50099 "Teller Ret. Treasury-Posted"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Return Treasury";
    SourceTableView = where(Status = filter(Approved), Posted = filter(true));
    CardPageId = 50094;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(TellerReturnTreasury)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;

                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = All;

                }
                field("Teller User ID"; "Teller User ID")
                {
                    ApplicationArea = All;

                }
                field("Till Balance"; "Till Balance")
                {
                    ApplicationArea = All;

                }
                field("Till Maximum Limit"; "Till Maximum Limit")
                {
                    ApplicationArea = All;

                }
                field("Till Return Amount"; "Till Return Amount")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}