page 50211 "Loan Refinancing Entries"
{
    // version TL2.0

    Caption = 'Loans To Refinance';
    PageType = List;
    SourceTable = "Loan Refinancing Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan To Refinance"; "Loan To Refinance")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field(Select; Select)
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

