page 56602 "Board Payment Voucher"
{
    // version TL2.0

    SourceTable = "Board Payment Header";
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
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
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
                    ShowMandatory = true;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Total Board Sitting"; "Total Board Sitting")
                {
                    Caption = 'Total Board Sitting Allowance';
                    ApplicationArea = All;
                }
                field("Total Board Tax"; "Total Board Tax")
                {
                    Caption = 'Total Tax on Sitting Allowance';
                    ApplicationArea = All;
                }
                field("Total Board Transport"; "Total Board Transport")
                {
                    Caption = 'Total Board Transport Reimbursement';
                    ApplicationArea = All;
                }
                field("Total Board Hospitality"; "Total Board Hospitality")
                {
                    Caption = 'Total Board Hospitality Costs';
                    ApplicationArea = All;
                }
                field("Gross Board Amount"; "Gross Board Amount")
                {
                    Caption = 'Total Board Gross Pay';
                    ApplicationArea = All;
                }
                field("Net Board Amount"; "Net Board Amount")
                {
                    Caption = 'Total Board Net Pay';
                    ApplicationArea = All;
                }
                field("Total Line Amount"; "Total Line Amount")
                {
                    ApplicationArea = All;
                }
                field(TotalPaymentAmount; "Total Line Amount" + "Net Board Amount")
                {
                    Caption = 'Total Payment Amount';
                    ApplicationArea = All;
                    Editable = false;
                }

                group(Audit)
                {
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
                    field("Approved By"; "Approved By")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Date Approved"; "Date Approved")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Time Approved"; "Time Approved")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
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
            part("Board Member PV Subform"; "Board Member PV Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Board Payment Voucher Subform"; "Board Payment Voucher Subform")
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
                    Visible = false;
                    trigger OnAction();
                    begin
                        Rec.SETRANGE("No.", "No.");
                        REPORT.RUN(50447, TRUE, TRUE, Rec);
                    end;
                }

                action(Post)
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = Rec.Status = 2;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    var
                        Gle: Record "G/L Entry";
                        VendL: Record "Vendor Ledger Entry";
                        DVendL: Record "Detailed Vendor Ledg. Entry";
                        BankL: Record "Bank Account Ledger Entry";
                    begin
                        if Confirm(PostPaymentVoucherConfirmMsg, true, "No.") then begin
                            CashManagement.PostBoardPaymentVoucher(Rec);
                        end else begin
                            exit;
                        end;
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
                            CashManagement.ReverseBoardPaymentVoucher(Rec)
                        else
                            exit;
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT NewApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Status = 0;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext-Finance";

                    begin
                        TestField("Account No.");
                        TestField(Description);
                        TestField("Payment Method");

                        BoardPVLines.Reset();
                        BoardPVLines.SetRange("Document No.", Rec."No.");
                        BoardPVLines.SetRange("Net Pay", 0);
                        if BoardPVLines.FindSet() then begin
                            BoardPVLines.DeleteAll();
                        end;


                        if UserSetup.Get(UserId) then begin
                            if UserSetup."Approve Board Payments" = true then begin
                                Status := Status::Approved;
                                "Date Approved" := Today;
                                "Time Approved" := Time;
                                "Approved By" := UserId;
                                Modify();
                                Message('Board payment approval request has been approved successfuly');
                            end else begin
                                Status := Status::"Pending Approval";
                                Modify();
                                Message('Board payment approval request has been initiated Successfuly');
                            end;
                        end;
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
                    Visible = Rec.Status = 1;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext-Finance";
                        WorkflowWebhookMgt: Codeunit "Approvals Mgmt.";
                    begin
                        Status := Status::New;
                        Modify();
                        Message('Board payment approval request has been canceled successfuly');
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
                        if UserSetup.Get(UserId) then begin
                            if UserSetup."Approve Board Payments" = true then begin
                                Status := Status::Approved;
                                "Date Approved" := Today;
                                "Time Approved" := Time;
                                "Approved By" := UserId;
                                Modify();
                                Message('Board payment approval request has been approved successfuly');
                            end else begin
                                Error('You do not have permission to complete this action. Contact Administrator');
                            end;
                        end;
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
                        if UserSetup.Get(UserId) then begin
                            if UserSetup."Approve Board Payments" = true then begin
                                Status := Status::Rejected;
                                "Rejected By" := UserId;
                                "Date Rejected" := Today;
                                "Time Rejected" := Time;
                                Modify();
                                Message('Board payment approval request has been rejected successfuly');
                            end else begin
                                Error('You do not have permission to complete this action. Contact Administrator');
                            end;
                        end;
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
        CalcFields("Total Line Amount", "Net Board Amount");
        TotalPaymentAmount := "Total Line Amount" + "Net Board Amount";
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
        BoardPVLines: Record "Board Members Payment Line";
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
        AccType: Record "Account Type";
        PostPaymentVoucherConfirmMsg: Label 'Do you want to post payment voucher %1?';
        ReversePaymentVoucherConfirmMsg: Label 'Do you want to post reverse payment voucher %1?';
        UserSetup: Record "User Setup";
        TotalPaymentAmount: Decimal;
}

