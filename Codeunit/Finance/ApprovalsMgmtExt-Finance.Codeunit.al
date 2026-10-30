codeunit 50042 "Approvals Mgmt Ext-Finance"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    var

        PaymentHeader: Record "Payment Header";
        PettyCashHeader: Record "PettyCash Header";
    begin
        case RecRef.NUMBER of
            DATABASE::"Payment Header":
                begin
                    RecRef.SETTABLE(PaymentHeader);
                    ApprovalEntryArgument."Document No." := PaymentHeader."No.";
                end;
            DATABASE::"PettyCash Header":
                begin
                    RecRef.SETTABLE(PettyCashHeader);
                    ApprovalEntryArgument."Document No." := PettyCashHeader."No.";
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
    var
        PaymentHeader: Record "Payment Header";
        PettyCashHeader: Record "PettyCash Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    PaymentHeader.Status := PaymentHeader.Status::"Pending Approval";
                    PaymentHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"PettyCash Header":
                begin
                    RecRef.SetTable(PettyCashHeader);
                    PettyCashHeader.Status := PettyCashHeader.Status::"Pending Approval";
                    PettyCashHeader.Modify(true);
                    isHandled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        PaymentHeader: Record "Payment Header";
        PettyCashHeader: Record "PettyCash Header";
    begin
        CASE ApprovalEntry."Table ID" OF
            DATABASE::"Payment Header":
                begin
                    PaymentHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFinanceDocument.RejectPaymentVoucher(PaymentHeader);
                end;
            DATABASE::"PettyCash Header":
                begin
                    PettyCashHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFinanceDocument.RejectPettyCashVoucher(PettyCashHeader);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPaymentVoucherForApproval(var PaymentHeader: Record "Payment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPaymentVoucherApprovalRequest(var PaymentHeader: Record "Payment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPettyCashVoucherForApproval(var PettyCashHeader: Record "PettyCash Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPettyCashVoucherApprovalRequest(var PettyCashHeader: Record "PettyCash Header")
    begin
    end;


    procedure IsPaymentVoucherApprovalsWorkflowEnabled(var PaymentHeader: Record "Payment Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PaymentHeader, WorkflowEventHandlingExt.RunWorkflowOnSendPaymentVoucherForApprovalCode));
    end;

    procedure IsPettyCashVoucherApprovalsWorkflowEnabled(var PettyCashHeader: Record "PettyCash Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PettyCashHeader, WorkflowEventHandlingExt.RunWorkflowOnSendPettyCashVoucherForApprovalCode));
    end;



    procedure CheckPaymentVoucherApprovalPossible(var PaymentHeader: Record "Payment Header"): Boolean
    begin
        IF NOT IsPaymentVoucherApprovalsWorkflowEnabled(PaymentHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckPettyCashVoucherApprovalPossible(var PettyCashHeader: Record "PettyCash Header"): Boolean
    begin
        IF NOT IsPettyCashVoucherApprovalsWorkflowEnabled(PettyCashHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;



    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext-F";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ReleaseFinanceDocument: Codeunit "Release Finance Document";

}