page 59662 "Loan Recovery List-New"
{
    // version TL2.0
    CardPageID = "Loan Recovery";
    PageType = List;
    SourceTable = "Loan Recovery Header";
    SourceTableView = WHERE(Status = FILTER(New),
                            Posted = filter(false));
    Editable = false;
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

            }
        }
    }
}

