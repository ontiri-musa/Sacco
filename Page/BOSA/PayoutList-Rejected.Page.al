page 50285 "Payout List-Rejected"
{
    // version TL2.0

    Caption = 'Rejected Payouts';
    CardPageID = Payout;
    PageType = List;
    SourceTable = "Payout Header";
    SourceTableView = WHERE(Status = FILTER(Rejected));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Payout Type"; "Payout Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Agent Code"; "Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Agent Name"; "Agent Name")
                {
                    ApplicationArea = All;
                }
                field("Total Payout Amount"; "Total Payout Amount")
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

