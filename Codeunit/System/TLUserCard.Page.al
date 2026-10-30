page 70001 "TL User Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TL User";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("User Id"; "User Id")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Default Password"; "Default Password")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "User Security ID" := CreateGuid;
    end;


    var
}