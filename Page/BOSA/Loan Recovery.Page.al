page 59660 "Loan Recovery"
{
    // version TL2.0

    SourceTable = "Loan Recovery Header";
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

                field(Description; Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }

                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Total Recovery Amount"; "Total Recovery Amount")
                {
                    ApplicationArea = All;
                    Enabled = False;
                    Editable = false;
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
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = All;
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
            part("Loan Recovery Subform"; "Loan Recovery Subform")
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
            action(Post)
            {
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = IsVisiblePost;
                ApplicationArea = Basic, Suite;
                trigger OnAction();
                var
                    Usersetup: Record "User Setup";
                begin
                    if Usersetup.Get(UserId) then begin
                        if Usersetup."Allow Recover Loan From Deposits" = false then
                            Error('Sorry, you dont have permission to post this document. Kindly contact system admin.');

                        if Confirm(PostCheckoffVoucherConfirmMsg, true, "No.") then begin
                            CashManagement.PostLoanRecovery(Rec);
                            CurrPage.Close();
                        end else
                            exit;
                    end;

                end;
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
                        CashManagement.ReverseLoanRecovery(Rec);
                        CurrPage.Close();
                    end;
                end;
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
        PostCheckoffVoucherConfirmMsg: Label 'Do you want to post loan recovery %1?';
        ReverseCheckoffVoucherConfirmMsg: Label 'Do you want to reverse loan recovery %1?';
}

