page 50060 "Teller Transaction Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Teller Transaction Header";
    RefreshOnActivate = true;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Category5,Category6,Category7,Category8';


    layout
    {
        area(Content)
        {
            group(Teller)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Teller User ID"; "Teller User ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;


                }
                field("Till No."; "Till No.")
                {
                    ApplicationArea = All;
                }
                field("Till Name"; "Till Name")
                {
                    ApplicationArea = All;
                }
                field("Till Balance"; "Till Balance")
                {
                    ApplicationArea = All;
                }
                field("Transaction Amount"; "Transaction Amount")
                {
                    ApplicationArea = All;

                }
                field("Total Line Amount"; "Total Line Amount")
                {
                    ApplicationArea = All;

                }
                field("Total Coinage Amount"; "Total Coinage Amount")
                {
                    ApplicationArea = All;

                }
                field("Teller Host IP"; "Teller Host IP")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Teller Host MAC"; "Teller Host MAC")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Teller Host Name"; "Teller Host Name")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;

                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = All;

                }
                field("Coinage Breakdown"; "Coinage Breakdown")
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Importance = Additional;


                }

            }
            part("Teller Transaction Subform"; "Teller Transaction Subform")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
                SubPageLink = "Transaction No." = field("No.");
            }

            group(TransactionCoinage)
            {
                Caption = '';
                Visible = "Coinage Breakdown" = true;
                part("Transaction Coinage Setup"; "Transaction Coinage Setup")
                {
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    SubPageLink = "Transaction No." = field("No."), "Coinage Source" = filter(Teller);
                }
            }
        }
        area(factboxes)
        {
            part(TellerMemberStatistics2; "Teller Member Statistics")
            {
                ApplicationArea = All;
                SubPageLink = "Transaction No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Post)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                Visible = IsVisiblePost;

                trigger OnAction();
                begin
                    ValidateTellerTransaction();
                    if Confirm(PostConfirmMsg, true) then
                        TelleringTreasury.PostTellerTransaction(Rec)
                    else
                        exit;
                end;
            }
            action(Reverse)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ReverseLines;
                Visible = IsVisiblePost;

                trigger OnAction();
                begin
                    if Confirm(ReverseConfirmMsg, true) then begin

                        GLEntry.Reset();
                        GLEntry.SetRange("Document No.", "No.");
                        if GLEntry.FindSet() then begin
                            repeat
                            //  GLEntry.rev
                            until GLEntry.Next() = 0;
                        end;
                    end;
                end;
            }
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
                    IF ApprovalsMgmt.CheckTellerTransactionApprovalPossible(Rec) THEN begin
                        ApprovalsMgmt.OnSendTellerTransactionForApproval(Rec);
                        CurrPage.Close();
                    end;
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
                    ApprovalsMgmt.OnCancelTellerTransactionApprovalRequest(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = Suite;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = IsVisibleApprove;

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
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action(Reject)
            {
                ApplicationArea = Suite;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';
                Visible = IsVisibleReject;

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
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action(Delegate)
            {
                ApplicationArea = Suite;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = IsVisibleDelegate;


                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
        area(Reporting)
        {
            action(Print)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction();
                begin
                    TellerTransactionHeader.Get("No.");
                    TellerTransactionHeader.SETRECFILTER;
                    Report.Run(50004, true, false, TellerTransactionHeader);
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin

    end;

    local procedure SetVisible()
    begin
        IF Status = Status::New THEN BEGIN
            begin
                if Posted then begin
                    IsVisibleSendApprovalRequest := false;
                    IsVisibleCancelApprovalRequest := FALSE;

                end else begin
                    IsVisibleSendApprovalRequest := true;
                    IsVisibleCancelApprovalRequest := false;
                end;
                IsVisibleApprove := false;
                IsVisibleDelegate := false;
                IsVisibleReject := false;
                if Posted then
                    IsVisiblePost := false
                else
                    IsVisiblePost := true
            END;
        end;
        IF Status = Status::"Pending Approval" THEN BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := TRUE;
            IsVisibleApprove := true;
            IsVisibleDelegate := true;
            IsVisibleReject := true;
            IsVisiblePost := false;
        END;
        IF Status = Status::Approved THEN BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleApprove := false;
            IsVisibleDelegate := false;
            IsVisibleReject := false;
            IsVisiblePost := true;
        END;
        IF Status = Status::Rejected THEN BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleApprove := false;
            IsVisibleDelegate := false;
            IsVisibleReject := false;
            IsVisiblePost := false;
        END;
    end;

    local procedure SetEditable()
    begin
        IF Status = Status::New THEN begin
            if Posted then
                CurrPage.EDITABLE := false
            else
                CurrPage.EDITABLE := true;
        end;
        IF Status = Status::"Pending Approval" THEN
            CurrPage.EDITABLE := FALSE;
        IF Status = Status::Approved THEN
            CurrPage.EDITABLE := FALSE;
    end;



    var
        TelleringTreasury: Codeunit "Tellering & Treasury";
        TellerTransactionHeader: Record "Teller Transaction Header";
        PostConfirmMsg: Label 'Do you want to post this transaction?';
        ReverseConfirmMsg: Label 'Do you want to reverse this transaction?';
        GLEntry: Record "G/L Entry";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        IsVisibleApprove: Boolean;
        IsVisibleReject: Boolean;
        IsVisibleDelegate: Boolean;
        IsVisiblePost: Boolean;


}