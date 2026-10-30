page 50069 "Transaction Coinage Setup"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Transaction Coinage Setup";
    Caption = 'Transaction Coinage Setup';
    layout
    {
        area(Content)
        {
            repeater(TransactionCoinage)
            {
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;

                }
                field("Coinage Code"; "Coinage Code")
                {
                    ApplicationArea = All;

                }
                field("Coinage Value"; "Coinage Value")
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