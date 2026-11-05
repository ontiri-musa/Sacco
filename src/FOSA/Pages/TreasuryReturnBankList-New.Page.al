page 50113 "Treasury Return Bank List-New"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Treasury Return Bank Header";
    SourceTableView = where(Status = filter(New), Posted = filter(false));
    Editable = false;
    CardPageId = 50111;

    layout
    {
        area(Content)
        {
            repeater(TreasuryRetunBank)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;

                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = All;

                }
                field("Bank Account Balance"; "Bank Account Balance")
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