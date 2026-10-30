page 59663 "Checkoff List-Posted-Reversed"
{
    // version TL2.0
    Caption = 'Posted Checkoffs';
    CardPageID = Checkoff;
    PageType = List;
    SourceTable = "Checkoff Header";
    SourceTableView = WHERE(Reversed = filter(true));
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

                field("Payment Method"; "Payment Method")
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
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
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
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        SetFilter("Created By", UserId);
    end;
}

