page 59320 "BoreshaSavingsIntList-Posted"
{
    // version TL2.0

    Caption = 'Posted Boresha Savings Interest List';
    CardPageID = BoreshaSavingsInterest;
    PageType = List;
    SourceTable = "Dividend Header";
    SourceTableView = where("Dividend Type" = filter(Boresha), Posted = filter(False));
    UsageCategory = History;
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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Period Code"; "Period Code")
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
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
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

