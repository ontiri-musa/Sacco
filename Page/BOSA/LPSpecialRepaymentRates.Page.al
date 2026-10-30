page 50215 "LP Special Repayment Rates"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'Special Repayment Rates';
    PageType = List;
    SourceTable = "LP Special Repayment Rate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Amount"; "Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

