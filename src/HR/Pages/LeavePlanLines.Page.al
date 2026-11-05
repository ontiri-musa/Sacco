page 50418 "Employee Plan Line"
{
    // version TL2.0

    Editable = true;
    PageType = ListPart;
    SourceTable = "Leave Plan Line";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Days; Days)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Reset Plan")
            {
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ResetLines(Rec."No.");
                end;
            }
        }
    }

    var
        LeavePlanLines: Record 50213;
}

