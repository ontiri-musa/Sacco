page 51209 "Collateral Allocation List"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Collateral Substitution";
    UsageCategory = Lists;
    ApplicationArea = All;
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Guarantor Member No"; "Guarantor Member No")
                {
                    ApplicationArea = All;
                }
                field("Security Type Code"; "Security Type Code")
                {
                    ApplicationArea = All;
                }
                field("Security Register Code"; "Security Register Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Security Value"; "Security Value")
                {
                    ApplicationArea = All;
                }
                field("Security Factor"; "Security Factor")
                {
                    ApplicationArea = All;
                }
                field("Guaranteed Amount"; "Guaranteed Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Open Attachment")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }

    var
        filename: Text;
        filename2: Text;
        GlobalSetup: Record "Global Setup";
}

