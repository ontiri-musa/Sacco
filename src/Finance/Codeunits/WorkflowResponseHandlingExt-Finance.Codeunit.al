codeunit 50044 "Workflow Resp. Handling Ext-F"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])

    begin
        CASE ResponseFunctionName OF
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPettyCashVoucherForApprovalCode);
                end;
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPettyCashVoucherForApprovalCode);
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPettyCashVoucherForApprovalCode);
                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPaymentVoucherApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPettyCashVoucherApprovalRequestCode);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PaymentHeader: Record "Payment Header";
        PettyCashHeader: Record "PettyCash Header";
    begin

        CASE RecRef.NUMBER OF
            DATABASE::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    ReleaseFinanceDocument.PerformCheckAndReleasePaymentVoucher(PaymentHeader);
                    Handled := TRUE;
                end;
            DATABASE::"PettyCash Header":
                begin
                    RecRef.SetTable(PettyCashHeader);
                    ReleaseFinanceDocument.PerformCheckAndReleasePettyCashVoucher(PettyCashHeader);
                    Handled := TRUE;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PaymentHeader: Record "Payment Header";
        PettyCashHeader: Record "PettyCash Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    ReleaseFinanceDocument.ReopenPaymentVoucher(PaymentHeader);
                    Handled := true;
                end;
            DATABASE::"PettyCash Header":
                begin
                    RecRef.SetTable(PettyCashHeader);
                    ReleaseFinanceDocument.ReopenPettyCashVoucher(PettyCashHeader);
                    Handled := true;
                end;

        end;
    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext-F";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        ReleaseFinanceDocument: Codeunit "Release Finance Document";

        ApprovalMgmt: Codeunit "Approvals Mgmt Ext";

}