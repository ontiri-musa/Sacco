page 51201 "Route Plan Lines"
{
    PageType = ListPart;
    SourceTable = "Route Plan Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Date)
                {
                    Editable = creator;
                }
                field(Day; Day)
                {
                }
                field(Description; Description)
                {
                    Editable = creator;
                }
                field(Comments; Comments)
                {
                    Editable = approve;
                }
                field(FeedBack; FeedBack)
                {
                    Editable = feedbackk;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        RoutePlan.RESET;
        RoutePlan.SETRANGE("No.", "Entry No.");
        IF RoutePlan.FINDSET THEN BEGIN
            IF RoutePlan.Status = RoutePlan.Status::New THEN BEGIN
                creator := TRUE;
                approve := FALSE;
                feedbackk := FALSE;
            END;
            IF RoutePlan.Status = RoutePlan.Status::"Pending Approval" THEN BEGIN
                creator := FALSE;
                approve := TRUE;
                feedbackk := FALSE;
            END;
            IF RoutePlan.Status = RoutePlan.Status::Approved THEN BEGIN
                creator := FALSE;
                approve := FALSE;
                feedbackk := TRUE;
            END;
        END;
    end;

    var
        creator: Boolean;
        approve: Boolean;
        feedbackk: Boolean;
        RoutePlan: Record "Route Plan";
}

