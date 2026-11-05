page 50602 "Payment Voucher"
{
    // version TL2.0

    SourceTable = "Payment Header";
    PromotedActionCategories = 'New,Process,Reports,Approval,Reversal,Category 6,Category 7,Category 8';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                group(SingleVendor)
                {
                    Caption = '';
                    Visible = "Transaction Type" = 0;

                    field("Vendor No."; "Vendor No.")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("Vendor Name"; "Vendor Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Vendor Balance"; "Vendor Balance")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Payee Name"; "Payee Name")
                    {
                        ApplicationArea = All;
                    }
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Payment Method"; "Payment Method")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Pay';
                    ShowMandatory = true;
                }
                field("Total Line Amount"; "Total Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Total VAT Amount"; "Total VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Total W/Tax Amount"; "Total W/Tax Amount")
                {
                    ApplicationArea = All;
                }



                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }

            }

            part("Payment Voucher Subform"; "Payment Voucher Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

        }
    }

    actions
    {
        area(creation)
        {

            group(main)
            {
                action(Print)
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    Visible = Posted = true;
                    trigger OnAction();
                    begin
                        Rec.SETRANGE("No.", "No.");
                        REPORT.RUN(50447, TRUE, TRUE, Rec);
                    end;
                }

                action(Post)
                {
                    Image = Post;
                    //  Visible = not Posted;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = PostingPV;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        if Confirm(PostPaymentVoucherConfirmMsg, true, "No.") then
                            CashManagement.PostPaymentVoucher(Rec)
                        else
                            exit;
                    end;
                }
                action(Reverse)
                {
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = Posted = true;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        if Confirm(ReversePaymentVoucherConfirmMsg, true, "No.") then
                            CashManagement.ReversePaymentVoucher(Rec)
                        else
                            exit;
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = not Posted;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT NewApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext-Finance";
                    begin
                        ValidateFields();
                        IF ApprovalsMgmt.CheckPaymentVoucherApprovalPossible(Rec) THEN BEGIN
                            ApprovalsMgmt.OnSendPaymentVoucherForApproval(Rec);
                        END;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext-Finance";
                        WorkflowWebhookMgt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelPaymentVoucherApprovalRequest(Rec);
                    end;
                }
            }
        }
        area(processing)
        {

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = IsApproveVisible;

                    trigger OnAction()
                    var
                        ApprovalEntry: Record "Approval Entry";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        IF ApprovalEntry.FINDFIRST THEN BEGIN
                            ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                            CurrPage.CLOSE;
                        END;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = IsRejectVisible;

                    trigger OnAction()
                    var
                        ApprovalEntry: Record "Approval Entry";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        IF ApprovalEntry.FINDFIRST THEN BEGIN
                            ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                            CurrPage.CLOSE;
                        END;
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = IsDelegateVisible;

                    trigger OnAction()
                    var
                        ApprovalEntry: Record "Approval Entry";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        IF ApprovalEntry.FINDFIRST THEN BEGIN
                            ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                            CurrPage.CLOSE;
                        END;
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments for the record.';
                    Visible = NewApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        // NewApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasNewApprovalEntriesForCurrentUser(RECORDID);
        // NewApprovalEntriesExist := ApprovalsMgmt.HasNewApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        IF Status <> Status::New THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
        END;
        IF Status = Status::New THEN BEGIN
            ModifyFields := TRUE;
        END;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        IF Status <> Status::New THEN BEGIN
            IF CanRequestApprovalForFlow = TRUE THEN BEGIN
                CanRequestApprovalForFlow := FALSE;
            END;
            CurrPage.EDITABLE(FALSE);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin

    end;

    trigger OnOpenPage();
    begin
        CanRequestApprovalForFlow := TRUE;
        IF Status <> Status::New THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF Status = Status::Approved THEN BEGIN
            IF Posted = FALSE THEN BEGIN
                PostingPV := TRUE;
            END;
        END;
        if Status = Status::"Pending Approval" then begin
            IsApproveVisible := true;
            IsDelegateVisible := true;
            IsRejectVisible := true;
        end;
    end;

    local procedure ValidateFields()
    var
    begin
        // TestField("Account No.");
        TestField("Payee Name");
        TestField(Description);
        CalcFields("Total Line Amount");
        TestField(Amount, "Total Line Amount");
        TestField("Payment Method");
    end;

    var
        CashManagement: Codeunit "Cash Management";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        NewApprovalEntriesExist: Boolean;
        CanCancelApprovalForFlow: Boolean;
        NewApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ModifyFields: Boolean;
        //PaymentRemittanceAdvise : Report "50441";
        PostingPV: Boolean;
        IsApproveVisible: Boolean;
        IsDelegateVisible: Boolean;
        IsRejectVisible: Boolean;
        PostPaymentVoucherConfirmMsg: Label 'Do you want to post payment voucher %1?';
        ReversePaymentVoucherConfirmMsg: Label 'Do you want to post reverse payment voucher %1?';
}

