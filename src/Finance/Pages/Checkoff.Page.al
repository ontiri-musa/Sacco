page 50660 "Checkoff"
{
    // version TL2.0

    SourceTable = "Checkoff Header";
    PromotedActionCategories = 'New,Process,Reports,Approval,Reversal,Category 6,Category 7,Category 8';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Agent Code"; "Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Agent Name"; "Agent Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;

                }

                field("Payee Name"; "Payee Name")
                {
                    ApplicationArea = All;
                }

                field(Description; Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Payment Method"; "Payment Method")
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Allocate';
                }
                field("Total Line Amount"; "Total Line Amount")
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
                field(Posted; Posted)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                group(ReversedCheckoff)
                {
                    Caption = '';
                    Visible = Reversed;
                    field(Reversed; Reversed)
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
                    field("Reversed Time"; "Reversed Time")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part("Checkoff Subform"; "Checkoff Subform")
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
                action(CopyPostedCheckoffRV)
                {
                    Caption = 'Copy Document';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = Posted = false;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        CashManagement.GetPostedCheckoff(Rec)
                    end;
                }
                action(Print)
                {
                    Image = Print;
                    Visible = IsVisiblePrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        Rec.SETRANGE("No.", "No.");
                        REPORT.RUN(50115, TRUE, TRUE, Rec);
                    end;
                }
                action(Post)
                {
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = IsVisiblePost;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        if Confirm(PostCheckoffVoucherConfirmMsg, true, "No.") then begin
                            CashManagement.PostCheckoff(Rec);
                            CurrPage.Close();
                        end else
                            exit;
                    end;
                }
                /*   action(SendApprovalRequest)
                  {
                      ApplicationArea = Basic, Suite;
                      Caption = 'Send A&pproval Request';
                      Enabled = NOT NewApprovalEntriesExist AND CanRequestApprovalForFlow;
                      Image = SendApprovalRequest;
                      Promoted = true;
                      PromotedCategory = Process;
                      PromotedIsBig = true;
                      PromotedOnly = true;
                      ToolTip = 'Request approval of the document.';
                      Visible = false;

                      trigger OnAction();
                      var
                          ApprovalsMgmt: Codeunit "Approvals Mgt Ext-Finance";
                      begin
                          CashManagement.RequiredFields(Rec);
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
                      Visible = false;

                      trigger OnAction();
                      var
                          ApprovalsMgmt: Codeunit "Approvals Mgt Ext-Finance";
                          WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                      begin
                          ApprovalsMgmt.OnCancelPaymentVoucherApprovalRequest(Rec);
                      end;
                  } 
                  */
            }
        }
        area(processing)
        {
            action(Reverse)
            {
                ApplicationArea = All;
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                Visible = Posted = true;
                trigger OnAction();
                var
                begin
                    if Confirm(ReverseCheckoffVoucherConfirmMsg, true, "No.") then begin
                        CashManagement.ReverseCheckOff(Rec);
                        CurrPage.Close();
                    end;
                end;
            }
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
                    Visible = false;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
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
                    Visible = NewApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        // ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
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
                    Visible = NewApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        //  ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
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
        //NewApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasNewApprovalEntriesForCurrentUser(RECORDID);
        //  NewApprovalEntriesExist := ApprovalsMgmt.HasNewApprovalEntries(RECORDID);
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
        IF Posted = FALSE THEN BEGIN
            IsVisiblePost := TRUE;
            IsVisiblePrint := false;
            CurrPage.EDITABLE(TRUE);
        END ELSE BEGIN
            CurrPage.EDITABLE(FALSE);
            IsVisiblePrint := true;
        END;
    end;

    var
        CashManagement: Codeunit "Cash Management";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        IsVisiblePost: Boolean;
        IsVisiblePrint: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        NewApprovalEntriesExist: Boolean;
        CanCancelApprovalForFlow: Boolean;
        NewApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ModifyFields: Boolean;
        PostCheckoffVoucherConfirmMsg: Label 'Do you want to post checkoff %1?';
        ReverseCheckoffVoucherConfirmMsg: Label 'Do you want to reverse checkoff %1?';
}

