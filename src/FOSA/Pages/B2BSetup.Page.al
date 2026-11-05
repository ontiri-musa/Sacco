page 52000 "B2B Setup"
{
    PageType = List;
    SourceTable = "B2B setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("TL settlement AC"; "TL settlement AC")
                {
                    ApplicationArea = All;
                }
                field("Coop settlement AC"; "Coop settlement AC")
                {
                }
                field("Sacco settlement AC"; "Sacco settlement AC")
                {
                    ApplicationArea = All;
                }
                field("TL Commission"; "TL Commission")
                {
                    ApplicationArea = All;
                }
                field("Coop Commission"; "Coop Commission")
                {
                    ApplicationArea = All;
                }
                field("Sacco Commission"; "Sacco Commission")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax"; "Withholding Tax")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax AC"; "Withholding Tax AC")
                {
                    ApplicationArea = All;
                }
                field("Accounty Type"; "Accounty Type")
                {
                    ApplicationArea = All;
                }
                field("Account Code"; "Account Code")
                {
                    ApplicationArea = All;
                }
                field("B2B Bank"; "B2B Bank")
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

