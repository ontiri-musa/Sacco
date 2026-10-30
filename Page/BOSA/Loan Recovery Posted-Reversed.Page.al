page 59643 "LoanRecov List-Posted-Reversed"
{
    // version TL2.0
    Caption = 'Reversed Loan Recovery';
    CardPageID = "Loan Recovery";
    PageType = List;
    SourceTable = "Loan Recovery Header";
    SourceTableView = WHERE(Posted = filter(true), Reversed = filter(true));
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;//
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Total Recovery Amount"; "Total Recovery Amount")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = All;
                }
                field("Posted Date"; "Posted Date")
                {
                    ApplicationArea = All;
                }
                field("Reversed By"; "Reversed By")
                {
                    ApplicationArea = All;
                }
                field("Reversed Date"; "Reversed Date")
                {
                    ApplicationArea = All;
                }
                field("Reversed Time"; "Reversed Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

