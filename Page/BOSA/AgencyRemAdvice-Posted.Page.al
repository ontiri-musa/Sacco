page 50345 "Agency Rem. Advice-Posted"
{
    // version TL2.0

    Caption = 'Posted Agency Remittance Advice';
    CardPageID = "Agency Remittance Advice";
    Editable = false;
    PageType = List;
    SourceTable = "Agency Remittance Header";
    SourceTableView = WHERE(Status = FILTER(Posted));
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
                field("Agent Code"; "Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Agent Name"; "Agent Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Period Month"; "Period Month")
                {
                    ApplicationArea = All;
                }
                field("Period Year"; "Period Year")
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
            }
        }
    }

    actions
    {
    }
}

