page 50818 "Purchase Req. Application Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Requisition Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Code"; "Employee Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("No of Approvals"; "No of Approvals")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field(Amount; Amount)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Requisition Date"; "Requisition Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Requested By"; "Requested By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    Editable = false;
                    Visible = SeeReleased;
                    ApplicationArea = All;
                }
                field("Procurement Method"; "Procurement Method")
                {
                    Editable = false;
                    Visible = SeeReleased;
                    ApplicationArea = All;
                }
                field("Procurement Process No."; "Procurement Process No.")
                {
                    Editable = false;
                    Visible = SeeProcessed;
                    ApplicationArea = All;
                }
            }
            part(page; "Requisition Line")
            {
                SubPageLink = "Requisition No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            //Caption = 'Request Approvals';
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeSendForApproval;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    ProcurementManagement.OnSendRequisitionsForApproval(Rec);
                    IF ApprovalsMgmtExt.CheckPurchaseRequisitionApprovalPossible(Rec) THEN
                        ApprovalsMgmtExt.OnSendPurchaseRequisitionForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeCancelForApproval;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelPurchaseRequisitionApprovalRequest(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Approval Entries")
            {
                Image = Approvals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD("No.");
                RunPageMode = View;
                ApplicationArea = All;
            }
            group(Approval)
            {
                Caption = 'Approval';
                Image = Alerts;
                Visible = IsApproveVisible;
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Approve the requested changes.';
                    Visible = IsApproveVisible;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        IF ApprovalEntry.FINDFIRST THEN
                            ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;

                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Reject the approval request.';
                    Visible = IsRejectVisible;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        IF ApprovalEntry.FINDFIRST THEN
                            ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;

                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = IsDelegateVisible;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        IF ApprovalEntry.FINDFIRST THEN
                            ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;

                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Visible = SeeApprovals;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Procurement Process")
            {
                Caption = 'Procurement Process';
                action("Select Procurement Method")
                {
                    Image = Purchasing;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = SeeInitiate;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ProcurementManagement.SelectProcurementMethod(Rec);
                        //CurrPage.CLOSE;
                    end;
                }
                action("Assign User")
                {
                    Image = PersonInCharge;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = SeeInitiate;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ProcurementManagement.AssignUser(Rec);
                        //CurrPage.CLOSE;
                    end;
                }
                action("Initiate Procurement Process")
                {
                    Image = NewToDo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = SeeInitiate;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ProcurementManagement.ValidateProcurementProcess(Rec);
                        CurrPage.CLOSE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        ManageIconVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        ManageIconVisibility;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ManageIconVisibility;
    end;

    trigger OnOpenPage();
    begin
        ManageIconVisibility;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //ApprovalsMgmtExt: Codeunit "Approvals Mgmt Ext";
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt Proc";
        ProcurementManagement: Codeunit "Procurement Management";
        SeeSendForApproval: Boolean;
        SeeCancelForApproval: Boolean;
        SeeApprovals: Boolean;
        RecVariant: Variant;
        SeeInitiate: Boolean;
        SeeProcessed: Boolean;
        SeeReleased: Boolean;
        IsApproveVisible: Boolean;
        IsRejectVisible: Boolean;
        IsDelegateVisible: Boolean;
    //ApprovalEntry: Record "Approval Entry";

    local procedure ManageIconVisibility();
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        SeeSendForApproval := TRUE;
        SeeCancelForApproval := FALSE;
        SeeApprovals := FALSE;
        SeeInitiate := FALSE;
        SeeReleased := FALSE;
        SeeProcessed := FALSE;
        IF Status = Status::New THEN BEGIN
            SeeSendForApproval := TRUE;
            SeeCancelForApproval := FALSE;
            SeeApprovals := FALSE;
        END ELSE
            IF Status = Status::"Pending Approval" THEN BEGIN
                SeeSendForApproval := FALSE;
                SeeCancelForApproval := TRUE;
                IsApproveVisible := TRUE;
                IsRejectVisible := TRUE;
                IsDelegateVisible := TRUE;
                IF ProcurementManagement.GetCurrentDocumentApprover("No.") <> USERID THEN
                    SeeApprovals := FALSE
                ELSE
                    SeeApprovals := TRUE;
                CurrPage.EDITABLE(FALSE);
            END ELSE
                IF (Status = Status::Released) AND ("Procurement Process Initiated" = FALSE) THEN BEGIN
                    SeeSendForApproval := FALSE;
                    SeeCancelForApproval := FALSE;
                    SeeApprovals := FALSE;
                    SeeInitiate := TRUE;
                    CurrPage.EDITABLE(FALSE);
                END ELSE BEGIN
                    SeeSendForApproval := FALSE;
                    SeeCancelForApproval := FALSE;
                    SeeApprovals := FALSE;
                    CurrPage.EDITABLE(FALSE);
                END;
        IF Status = Status::Released THEN
            SeeReleased := TRUE;
        IF "Procurement Process Initiated" = TRUE THEN
            SeeProcessed := TRUE;
        IF "Requested By" <> USERID THEN
            SeeCancelForApproval := FALSE;
    end;
}

