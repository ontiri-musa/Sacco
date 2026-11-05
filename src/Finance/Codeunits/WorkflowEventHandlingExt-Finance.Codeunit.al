codeunit 50043 "Workflow Event Handling Ext-F"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPaymentVoucherForApprovalCode, DATABASE::"Payment Header", PaymentVoucherSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPaymentVoucherApprovalRequestCode, DATABASE::"Payment Header", PaymentVoucherApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleasePaymentVoucherApprovalRequestCode, DATABASE::"Payment Header", PaymentVoucherReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPettyCashVoucherForApprovalCode, DATABASE::"PettyCash Header", PettyCashVoucherSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPettyCashVoucherApprovalRequestCode, DATABASE::"PettyCash Header", PettyCashVoucherApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleasePettyCashVoucherApprovalRequestCode, DATABASE::"PettyCash Header", PettyCashVoucherReleasedEventDescTxt, 0, FALSE);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelPaymentVoucherApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPaymentVoucherApprovalRequestCode, RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPaymentVoucherApprovalRequestCode, RunWorkflowOnSendPettyCashVoucherForApprovalCode);

                end;
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPettyCashVoucherForApprovalCode);
                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPettyCashVoucherForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPettyCashVoucherForApprovalCode);
                end;
        end
    end;

    procedure RunWorkflowOnSendPaymentVoucherForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPaymentVoucherForApproval'));
    end;


    procedure RunWorkflowOnCancelPaymentVoucherApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPaymentVoucherApprovalRequest'));
    end;


    procedure RunWorkflowOnReleasePaymentVoucherApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleasePaymentVoucher'));
    end;

    procedure RunWorkflowOnSendPettyCashVoucherForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPettyCashVoucherForApproval'));
    end;


    procedure RunWorkflowOnCancelPettyCashVoucherApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPettyCashVoucherApprovalRequest'));
    end;


    procedure RunWorkflowOnReleasePettyCashVoucherApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleasePettyCashVoucher'));
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext-Finance", 'OnSendPaymentVoucherForApproval', '', false, false)]
    procedure RunWorkflowOnSendPaymentVoucherForApproval(var PaymentHeader: Record "Payment Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentVoucherForApprovalCode, PaymentHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext-Finance", 'OnCancelPaymentVoucherApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPaymentVoucherApprovalRequest(var PaymentHeader: Record "Payment Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentVoucherApprovalRequestCode, PaymentHeader);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Finance Document", 'OnAfterReleasePaymentVoucher', '', false, false)]
    procedure RunWorkflowOnReleasePaymentVoucher(var PaymentHeader: Record "Payment Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleasePaymentVoucherApprovalRequestCode, PaymentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext-Finance", 'OnSendPettyCashVoucherForApproval', '', false, false)]
    procedure RunWorkflowOnSendPettyCashVoucherForApproval(var PettyCashHeader: Record "PettyCash Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPettyCashVoucherForApprovalCode, PettyCashHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext-Finance", 'OnCancelPettyCashVoucherApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPettyCashVoucherApprovalRequest(var PettyCashHeader: Record "PettyCash Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPettyCashVoucherApprovalRequestCode, PettyCashHeader);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Finance Document", 'OnAfterReleasePettyCashVoucher', '', false, false)]
    procedure RunWorkflowOnReleasePettyCashVoucher(var PettyCashHeader: Record "PettyCash Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleasePettyCashVoucherApprovalRequestCode, PettyCashHeader);
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PaymentVoucherSendForApprovalEventDescTxt: Label 'Approval of a Payment Voucher is requested.';
        PaymentVoucherApprReqCancelledEventDescTxt: Label 'An approval request for a Payment Voucher is canceled.';
        PaymentVoucherReleasedEventDescTxt: Label 'A Payment Voucher is released.';

        PettyCashVoucherSendForApprovalEventDescTxt: Label 'Approval of a PettyCash Voucher is requested.';
        PettyCashVoucherApprReqCancelledEventDescTxt: Label 'An approval request for a PettyCash Voucher is canceled.';
        PettyCashVoucherReleasedEventDescTxt: Label 'A PettyCash Voucher is released.';


}

