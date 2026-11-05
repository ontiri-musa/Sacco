page 59236 "Achive Reasons"
{
    // version TL2.0

    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Setup,Related Information,Posting,Category7';
    SourceTable = "Achive Reason";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Fees Setup")
            {
                Image = Costs;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Exit Reason Fees";
                RunPageLink = "Reason Code" = FIELD(Code);
            }
        }
    }
}

