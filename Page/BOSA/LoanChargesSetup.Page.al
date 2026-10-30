page 50216 "Loan Charge Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Charge Setup";
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
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Income G/L Account"; "Income G/L Account")
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

