page 50224 "Fund Transfer List-Posted"
{
    // version TL2.0

    Caption = 'Posted Fund Transfers';
    CardPageID = "Fund Transfer";
    PageType = List;
    SourceTable = "Fund Transfer";
    SourceTableView = WHERE(Status = FILTER(Approved),
                        Posted = FILTER(true));
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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Source Account No."; "Source Account No.")
                {
                    ApplicationArea = All;
                }
                field("Source Account Name"; "Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Destination Account No."; "Destination Account No.")
                {
                    ApplicationArea = All;
                }
                field("Destination Account Name"; "Destination Account Name")
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
                field("Amount to Transfer"; "Amount to Transfer")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    var
        GLEntry: Record "G/L Entry";
    begin
        IF ("Posting Date" = 0D) OR ("Posted By" = '') then begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            if GLEntry.FindFirst() then begin
                "Posting Date" := GLEntry."Posting Date";
                "Posted By" := GLEntry."User ID";
                Modify();
            end;
        end;
    end;
}

