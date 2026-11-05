page 50065 "Teller Transactions-Rejected"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Transaction Header";
    SourceTableView = WHERE(Status = FILTER(Rejected), Posted = filter(false));
    CardPageId = 50060;
    layout
    {
        area(Content)
        {
            repeater(Teller)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;

                }
                field("Teller User ID"; "Teller User ID")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Total Line Amount"; "Total Line Amount")
                {
                    ApplicationArea = All;

                }
                field("Transaction Amount"; "Transaction Amount")
                {
                    ApplicationArea = All;

                }
                field("Transaction Date"; "Transaction Date")
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