page 50630 "Checkoff Receipt Voucher"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Checkoff Receipt Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
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
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Payee Name"; "Payee Name")
                {
                    ApplicationArea = All;

                }
                field("Payment Method"; "Payment Method")
                {
                    ApplicationArea = All;

                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;

                }

                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;

                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;

                }

                field("Total Line Amount"; "Total Line Amount")
                {
                    ApplicationArea = All;

                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
            }
            part("Checkoff Receipt V. Subform"; "Checkoff Receipt V. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;

            }
        }
    }

    actions
    {
        area(Reporting)
        {


            action(Print)
            {
                Image = Print;
                Visible = Posted = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = Basic, Suite;
                trigger OnAction();
                begin
                    Rec.SETRANGE("No.", "No.");
                    REPORT.RUN(50449, TRUE, TRUE, Rec);
                end;
            }




        }
        area(processing)
        {
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
                    if Confirm(PostCheckoffReceiptVoucherConfirmMsg, true, "No.") then begin
                        CashManagement.PostCheckoffReceiptVoucher(Rec);
                        CurrPage.Close();
                    end else
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
                    if Confirm(ReverseCheckoffReceiptVoucherConfirmMsg, true, "No.") then begin
                        CashManagement.ReverseCheckoffReceiptVoucher(Rec);
                        CurrPage.Close();
                    end else
                        exit;
                end;
            }
            action(CopyPostedCheckoffRV)
            {
                Caption = 'Copy Document';
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = Posted = false;
                ApplicationArea = Basic, Suite;
                trigger OnAction();
                begin
                    CashManagement.GetPostedCheckoffReceiptVoucher(Rec)

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
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
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
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
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
        PostCheckoffReceiptVoucherConfirmMsg: Label 'Do you want to post Checkoff receipt voucher %1?';
        ReverseCheckoffReceiptVoucherConfirmMsg: Label 'Do you want to reverse Checkoff receipt voucher %1?';

}