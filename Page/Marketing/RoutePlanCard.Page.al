page 51200 "Route Plan"
{
    DataCaptionFields = "Sales Person Code", "Sales Person Name";
    PageType = Card;
    SourceTable = "Route Plan";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                }
                field("Sales Person Name"; "Sales Person Name")
                {
                    Editable = false;
                }
                field(Supervisor; Supervisor)
                {
                }
                field(Description; Description)
                {
                }
                field("Budget Required"; "Budget Required")
                {
                }
                field("Date Created"; "Date Created")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
            }
            part("Route Plan Lines"; "Route Plan Lines")
            {
                SubPageLink = "Entry No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Submit Route Plan")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SubmitRoutePlan;

                trigger OnAction();
                begin
                    "Created By" := USERID;
                    IF CONFIRM('Are you sure you want to Submit your weekly route plan?') THEN BEGIN
                        IF Status = Status::New THEN BEGIN
                            Status := Status::"Pending Approval";
                            Modify();
                            MESSAGE('Route Plan submitted successfully.');
                        END;
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Send Weekly Feedback")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SendFeedback;

                trigger OnAction();
                begin
                    IF Status <> Status::Approved THEN
                        ERROR('Route plan must be approved.');

                    IF CONFIRM('Are you sure you want to submit your feedback for the week?') THEN BEGIN
                        IF Status = Status::Approved THEN BEGIN
                            MESSAGE('Feedback for the Route Plan submitted successfully.');
                        END;
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Approve Route Plan")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = Approve;

                trigger OnAction();
                begin
                    User.GET(USERID);
                    IF "Created By" = USERID THEN
                        ERROR('You cannot approve a route plan that you created.');

                    IF CONFIRM('Are you sure you want to approve the route plan?') THEN BEGIN
                        IF Status = Status::"Pending Approval" THEN BEGIN
                            Status := Status::Approved;
                            Modify();
                            MESSAGE('Route Plan approved successfully.');
                        END;
                    END;
                    CurrPage.CLOSE;
                end;
            }
            /*  action("Products Sold")
             {
                 Image = Bins;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 PromotedOnly = true;
                 RunObject = Page 74326;
                 RunPageLink = No.=FIELD(No.);
                 Visible = SendFeedback;
             } */
        }
    }

    trigger OnOpenPage();
    begin
        IF Status = Status::New THEN BEGIN
            SubmitRoutePlan := TRUE;
            SendFeedback := FALSE;
            WriteFeedback := FALSE;
            EditDetails := TRUE;
            Approve := FALSE;
        END;

        IF Status = Status::"Pending Approval" THEN BEGIN
            SendFeedback := FALSE;
            SubmitRoutePlan := FALSE;
            WriteFeedback := FALSE;
            EditDetails := FALSE;
            Approve := TRUE;
        END;

        IF Status = Status::Approved THEN BEGIN
            SendFeedback := TRUE;
            SubmitRoutePlan := FALSE;
            WriteFeedback := TRUE;
            EditDetails := TRUE;
            Approve := FALSE;
        END;

        User.GET(USERID);
    end;

    var
        SubmitRoutePlan: Boolean;
        SendFeedback: Boolean;
        WriteFeedback: Boolean;
        EditDetails: Boolean;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        User: Record "User Setup";
        Approve: Boolean;
}

