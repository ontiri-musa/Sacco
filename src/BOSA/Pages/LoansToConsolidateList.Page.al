page 59211 "Loan Consolidation Entries"
{
    // version TL2.0

    Caption = 'Loans To Consolidate';
    PageType = List;
    SourceTable = "Loan Consolidation Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Loan To Consolidate"; "Loan To Consolidate")
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
            }
        }
    }

    actions
    {
    }
}

