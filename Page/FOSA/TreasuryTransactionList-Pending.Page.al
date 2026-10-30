page 50083 "Treasury Transactions-Pending"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Treasury Transaction Header";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"), Posted = filter(false));
    CardPageId = 50080;
    layout
    {
        area(Content)
        {
            repeater(Treasury)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }

                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = All;

                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;

                }
                field("Created By"; "Created By")
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