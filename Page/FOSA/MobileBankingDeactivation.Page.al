page 58151 "Mobile Banking Deactivation"
{
    // version TL2.0

    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Category5,Category6,Category7,Category8';
    SourceTable = "Mobile Banking Activ. Header";

    layout
    {
        area(content)
        {
            group(General)
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
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Importance = Additional;
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
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = IsVisibleSendApprovalRequest;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    IF ApprovalsMgmt.CheckMobileBankingActivationDeactivationApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendMobileBankingActivationDeactivationForApproval(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                Visible = IsVisibleCancelApprovalRequest;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmt.OnCancelMobileBankingActivationDeactivationApprovalRequest(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Application Option" := "Application Option"::Deactivation;
        Modify();
    end;

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
    end;

    var
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;

    local procedure SetVisible()
    begin
        IF Status = Status::New THEN
            IsVisibleSendApprovalRequest := TRUE
        ELSE
            IsVisibleSendApprovalRequest := FALSE
    end;

    local procedure SetEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE;
        IF Status = Status::"Pending Approval" THEN
            CurrPage.EDITABLE := FALSE;
        IF Status = Status::Approved THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

