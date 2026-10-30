page 59159 "Recovery List-Posted"
{
    // version TL2.0
    Caption = 'Posted  Recoveries';
    CardPageID = Recovery;
    PageType = List;
    SourceTable = "Recovery Header";
    SourceTableView = WHERE(Status = FILTER(New),
                            Posted = filter(true), Reversed = filter(false));
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
                field("Destination G/L"; "Destination G/L")
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

