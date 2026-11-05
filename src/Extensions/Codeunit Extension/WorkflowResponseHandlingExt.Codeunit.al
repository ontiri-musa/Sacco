codeunit 50013 "Workflow Response Handling Ext"
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
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendFundTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanReschedulingForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanRestructuringForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPayoutForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendDividendForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberArchiveForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberRefundForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberClaimForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanSelloffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanWriteoffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendGroupAllocationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPortfolioTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMCollectionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendChequeClearanceForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendAccountOpeningForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendAgentApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerReturnTreasuryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerCloseTillForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryReturnBankForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendInterTellerTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendInterTreasuryTransferForApprovalCode);
                end;
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendAccountOpeningForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendFundTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanReschedulingForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanRestructuringForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPayoutForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendDividendForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberArchiveForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberRefundForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberClaimForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanSelloffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanWriteoffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendGroupAllocationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPortfolioTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMCollectionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendChequeClearanceForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendAgentApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerReturnTreasuryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerCloseTillForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryReturnBankForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendInterTellerTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendInterTreasuryTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnMemberChangedCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnBeneficiaryChangedCode);
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendAccountOpeningForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendFundTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanReschedulingForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanRestructuringForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPayoutForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendDividendForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberArchiveForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberRefundForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberClaimForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanSelloffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLoanWriteoffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendGroupAllocationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPortfolioTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMCollectionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendChequeClearanceForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendAgentApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerReturnTreasuryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTellerCloseTillForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryReturnBankForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendInterTellerTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendInterTreasuryTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnMemberChangedCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnBeneficiaryChangedCode);
                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMemberApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelAccountOpeningApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelLoanApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelStandingOrderApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelFundTransferApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelLoanReschedulingApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelLoanRestructuringApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelGuarantorSubstitutionApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPayoutApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelDividendApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMemberExitApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMemberArchiveApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMemberRefundApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMemberClaimApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelLoanSelloffApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelLoanWriteoffApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelGroupAllocationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPortfolioTransferApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMemberActivationDeactivationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelAccountActivationDeactivationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMobileBankingApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelMobileBankingActivationDeactivationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelATMApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelATMCollectionApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelATMActivationDeactivationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelChequeBookApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelChequeClearanceApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelAgentApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelTellerTransactionApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelTellerReturnTreasuryApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelTellerCloseTillApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelTreasuryTransactionApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelTreasuryReturnBankApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelInterTellerTransferApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelInterTreasuryTransferApprovalRequestCode);
                end;
            WorkflowResponseHandling.RevertValueForFieldCode:
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingExt.RunWorkflowOnMemberChangedCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingExt.RunWorkflowOnBeneficiaryChangedCode);
                END;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MemberApplication: Record "Member Application";
        AccountOpening: Record "Account Opening";
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        FundTransfer: Record "Fund Transfer";
        LoanRescheduling: Record "Loan Rescheduling";
        LoanRestructuring: Record "Loan Restructuring";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        PayoutHeader: Record "Payout Header";
        DividendHeader: Record "Dividend Header";
        MemberExitHeader: Record "Member Exit Header";
        MemberArchiveHeader: Record "Member Achive Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSelloff: Record "Loan Selloff";
        LoanWriteoffHeader: Record "Loan Writeoff Header";
        GroupAllocationHeader: Record "Group Allocation Header";
        PortfolioTransfer: Record "Portfolio Transfer";
        MemberActivationHeader: Record "Member Activation Header";
        MobileBankingApplication: Record "Mobile Banking Application";
        MobileBankingActivationHeader: Record "Mobile Banking Activ. Header";
        ATMApplication: Record "ATM Application";
        ATMCollection: Record "ATM Collection";
        ATMActivationHeader: Record "ATM Activation Header";
        ChequeBookApplication: Record "Cheque Book Application";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
        AgentApplication: Record "Agent Application";
        TellerTransactionHeader: Record "Teller Transaction Header";
        TellerReturnTreasury: Record "Teller Return Treasury";
        TellerCloseTill: Record "Teller Close Till";
        TreasuryTransactionHeader: Record "Treasury Transaction Header";
        TreasuryReturnBank: Record "Treasury Return Bank Header";
        InterTellerTransferHeader: Record "InterTeller Transfer Header";
        InterTreasuryTransferHeader: Record "InterTreasury Transfer Header";
    begin

        CASE RecRef.NUMBER OF
            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    ReleaseFOSADocument.PerformCheckAndReleaseMemberApplication(MemberApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Account Opening":
                begin
                    RecRef.SetTable(AccountOpening);
                    ReleaseFOSADocument.PerformCheckAndReleaseAccountOpening(AccountOpening);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    ReleaseBOSADocument.PerformCheckAndReleaseLoanApplication(LoanApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    ReleaseBOSADocument.PerformCheckAndReleaseStandingOrder(StandingOrder);
                    Handled := TRUE;
                end;
            DATABASE::"Fund Transfer":
                begin
                    RecRef.SetTable(FundTransfer);
                    ReleaseBOSADocument.PerformCheckAndReleaseFundTransfer(FundTransfer);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    RecRef.SetTable(LoanRescheduling);
                    ReleaseBOSADocument.PerformCheckAndReleaseLoanRescheduling(LoanRescheduling);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Restructuring":
                begin
                    RecRef.SetTable(LoanRestructuring);
                    ReleaseBOSADocument.PerformCheckAndReleaseLoanRestructuring(LoanRestructuring);
                    Handled := TRUE;
                end;

            DATABASE::"Guarantor Substitution Header":
                begin
                    RecRef.SetTable(GuarantorSubstitutionHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseGuarantorSubstitution(GuarantorSubstitutionHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Payout Header":
                begin
                    RecRef.SetTable(PayoutHeader);
                    ReleaseBOSADocument.PerformCheckAndReleasePayout(PayoutHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SetTable(DividendHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseDividend(DividendHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExitHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseMemberExit(MemberExitHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Achive Header":
                begin
                    RecRef.SetTable(MemberArchiveHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseMemberArchive(MemberArchiveHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Refund Header":
                begin
                    RecRef.SetTable(MemberRefundHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseMemberRefund(MemberRefundHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Claim Header":
                begin
                    RecRef.SetTable(MemberClaimHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseMemberClaim(MemberClaimHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Selloff":
                begin
                    RecRef.SetTable(LoanSelloff);
                    ReleaseBOSADocument.PerformCheckAndReleaseLoanSelloff(LoanSelloff);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    RecRef.SetTable(LoanWriteoffHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseLoanWriteoff(LoanWriteoffHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Group Allocation Header":
                begin
                    RecRef.SetTable(GroupAllocationHeader);
                    ReleaseBOSADocument.PerformCheckAndReleaseGroupAllocation(GroupAllocationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    ReleaseBOSADocument.PerformCheckAndReleasePortfolioTransfer(PortfolioTransfer);
                    Handled := TRUE;
                end;
            DATABASE::"Member Activation Header":
                begin
                    RecRef.SetTable(MemberActivationHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseMemberActivationDeactivation(MemberActivationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Mobile Banking Application":
                begin
                    RecRef.SetTable(MobileBankingApplication);
                    ReleaseFOSADocument.PerformCheckAndReleaseMobileBankingApplication(MobileBankingApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Mobile Banking Activ. Header":
                begin
                    RecRef.SetTable(MobileBankingActivationHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseMobileBankingActivationDeactivation(MobileBankingActivationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ReleaseFOSADocument.PerformCheckAndReleaseATMApplication(ATMApplication);
                    Handled := TRUE;
                end;
            DATABASE::"ATM Collection":
                begin
                    RecRef.SetTable(ATMCollection);
                    ReleaseFOSADocument.PerformCheckAndReleaseATMCollection(ATMCollection);
                    Handled := TRUE;
                end;
            DATABASE::"ATM Activation Header":
                begin
                    RecRef.SetTable(ATMActivationHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseATMActivationDeactivation(ATMActivationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Cheque Book Application":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ReleaseFOSADocument.PerformCheckAndReleaseChequeBookApplication(ChequeBookApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    RecRef.SetTable(ChequeClearanceHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseChequeClearance(ChequeClearanceHeader);
                    Handled := TRUE;
                end;

            DATABASE::"Agent Application":
                begin
                    RecRef.SetTable(AgentApplication);
                    ReleaseFOSADocument.PerformCheckAndReleaseAgentApplication(AgentApplication);
                    Handled := true;
                end;
            DATABASE::"Teller Transaction Header":
                begin
                    RecRef.SetTable(TellerTransactionHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseTellerTransaction(TellerTransactionHeader);
                    Handled := true;
                end;
            DATABASE::"Teller Return Treasury":
                begin
                    RecRef.SetTable(TellerReturnTreasury);
                    ReleaseFOSADocument.PerformCheckAndReleaseTellerReturnTreasury(TellerReturnTreasury);
                    Handled := true;
                end;
            DATABASE::"Teller Close Till":
                begin
                    RecRef.SetTable(TellerCloseTill);
                    ReleaseFOSADocument.PerformCheckAndReleaseTellerCloseTill(TellerCloseTill);
                    Handled := true;
                end;
            DATABASE::"Treasury Transaction Header":
                begin
                    RecRef.SetTable(TreasuryTransactionHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseTreasuryTransaction(TreasuryTransactionHeader);
                    Handled := true;
                end;
            DATABASE::"Treasury Return Bank Header":
                begin
                    RecRef.SetTable(TellerReturnTreasury);
                    ReleaseFOSADocument.PerformCheckAndReleaseTreasuryReturnBank(TreasuryReturnBank);
                    Handled := true;
                end;
            DATABASE::"InterTeller Transfer Header":
                begin
                    RecRef.SetTable(InterTellerTransferHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseInterTellerTransfer(InterTellerTransferHeader);
                    Handled := true;
                end;
            DATABASE::"InterTreasury Transfer Header":
                begin
                    RecRef.SetTable(InterTreasuryTransferHeader);
                    ReleaseFOSADocument.PerformCheckAndReleaseInterTreasuryTransfer(InterTreasuryTransferHeader);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MemberApplication: Record "Member Application";
        AccountOpening: Record "Account Opening";
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        FundTransfer: Record "Fund Transfer";
        LoanRescheduling: Record "Loan Rescheduling";
        LoanRestructuring: Record "Loan Restructuring";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        PayoutHeader: Record "Payout Header";
        DividendHeader: Record "Dividend Header";
        MemberExitHeader: Record "Member Exit Header";
        MemberArchiveHeader: Record "Member Achive Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSelloff: Record "Loan Selloff";
        LoanWriteoffHeader: Record "Loan Writeoff Header";
        GroupAllocationHeader: Record "Group Allocation Header";
        PortfolioTransfer: Record "Portfolio Transfer";
        MemberActivationHeader: Record "Member Activation Header";
        MobileBankingApplication: Record "Mobile Banking Application";
        MobileBankingActivationHeader: Record "Mobile Banking Activ. Header";
        ATMApplication: Record "ATM Application";
        ATMCollection: Record "ATM Collection";
        ATMActivationHeader: Record "ATM Activation Header";
        ChequeBookApplication: Record "Cheque Book Application";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
        AgentApplication: Record "Agent Application";
        TellerTransactionHeader: Record "Teller Transaction Header";
        TellerReturnTreasury: Record "Teller Return Treasury";
        TellerCloseTill: Record "Teller Close Till";
        TreasuryTransactionHeader: Record "Treasury Transaction Header";
        TreasuryReturnBank: Record "Treasury Return Bank Header";
        InterTellerTransferHeader: Record "InterTeller Transfer Header";
        InterTreasuryTransferHeader: Record "InterTreasury Transfer Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    ReleaseFOSADocument.ReopenMemberApplication(MemberApplication);
                    Handled := true;
                end;
            DATABASE::"Account Opening":
                begin
                    RecRef.SetTable(AccountOpening);
                    ReleaseFOSADocument.ReopenAccountOpening(AccountOpening);
                    Handled := true;
                end;
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    ReleaseBOSADocument.ReopenLoanApplication(LoanApplication);
                    Handled := true;
                end;
            DATABASE::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    ReleaseBOSADocument.ReopenStandingOrder(StandingOrder);
                    Handled := TRUE;
                end;
            DATABASE::"Fund Transfer":
                begin
                    RecRef.SetTable(FundTransfer);
                    ReleaseBOSADocument.ReopenFundTransfer(FundTransfer);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    RecRef.SetTable(LoanRescheduling);
                    ReleaseBOSADocument.ReopenLoanRescheduling(LoanRescheduling);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Restructuring":
                begin
                    RecRef.SetTable(LoanRestructuring);
                    ReleaseBOSADocument.ReopenLoanRestructuring(LoanRestructuring);
                    Handled := TRUE;
                end;

            DATABASE::"Guarantor Substitution Header":
                begin
                    RecRef.SetTable(GuarantorSubstitutionHeader);
                    ReleaseBOSADocument.ReopenGuarantorSubstitution(GuarantorSubstitutionHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Payout Header":
                begin
                    RecRef.SetTable(PayoutHeader);
                    ReleaseBOSADocument.ReopenPayout(PayoutHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SetTable(DividendHeader);
                    ReleaseBOSADocument.ReopenDividend(DividendHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExitHeader);
                    ReleaseBOSADocument.ReopenMemberExit(MemberExitHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Achive Header":
                begin
                    RecRef.SetTable(MemberArchiveHeader);
                    ReleaseBOSADocument.ReopenMemberArchive(MemberArchiveHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Refund Header":
                begin
                    RecRef.SetTable(MemberRefundHeader);
                    ReleaseBOSADocument.ReopenMemberRefund(MemberRefundHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Member Claim Header":
                begin
                    RecRef.SetTable(MemberClaimHeader);
                    ReleaseBOSADocument.ReopenMemberClaim(MemberClaimHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Selloff":
                begin
                    RecRef.SetTable(LoanSelloff);
                    ReleaseBOSADocument.ReopenLoanSelloff(LoanSelloff);
                    Handled := TRUE;
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    RecRef.SetTable(LoanWriteoffHeader);
                    ReleaseBOSADocument.ReopenLoanWriteoff(LoanWriteoffHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Group Allocation Header":
                begin
                    RecRef.SetTable(GroupAllocationHeader);
                    ReleaseBOSADocument.ReopenGroupAllocation(GroupAllocationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    ReleaseBOSADocument.ReopenPortfolioTransfer(PortfolioTransfer);
                    Handled := TRUE;
                end;
            DATABASE::"Member Activation Header":
                begin
                    RecRef.SetTable(MemberActivationHeader);
                    ReleaseFOSADocument.ReopenMemberActivationDeactivation(MemberActivationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"Mobile Banking Application":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    ReleaseFOSADocument.ReopenMobileBankingApplication(MobileBankingApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Mobile Banking Activ. Header":
                begin
                    RecRef.SetTable(MobileBankingActivationHeader);
                    ReleaseFOSADocument.ReopenMobileBankingActivationDeactivation(MobileBankingActivationHeader);
                    Handled := TRUE;
                end;
            DATABASE::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ReleaseFOSADocument.ReopenATMApplication(ATMApplication);
                    Handled := TRUE;
                end;
            DATABASE::"ATM Collection":
                begin
                    RecRef.SetTable(ATMCollection);
                    ReleaseFOSADocument.ReopenATMCollection(ATMCollection);
                    Handled := TRUE;
                end;
            DATABASE::"ATM Activation Header":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    ReleaseBOSADocument.ReopenPortfolioTransfer(PortfolioTransfer);
                    Handled := TRUE;
                end;
            DATABASE::"Cheque Book Application":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    ReleaseFOSADocument.ReopenChequeBookApplication(ChequeBookApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    RecRef.SetTable(ChequeClearanceHeader);
                    ReleaseFOSADocument.ReopenChequeClearance(ChequeClearanceHeader);
                    Handled := TRUE;
                end;

            DATABASE::"Agent Application":
                begin
                    RecRef.SetTable(AgentApplication);
                    ReleaseFOSADocument.ReopenAgentApplication(AgentApplication);
                    Handled := true;
                end;
            DATABASE::"Teller Transaction Header":
                begin
                    RecRef.SetTable(TellerTransactionHeader);
                    ReleaseFOSADocument.ReopenTellerTransaction(TellerTransactionHeader);
                    Handled := true;
                end;
            DATABASE::"Teller Return Treasury":
                begin
                    RecRef.SetTable(TellerReturnTreasury);
                    ReleaseFOSADocument.ReopenTellerReturnTreasury(TellerReturnTreasury);
                    Handled := true;
                end;
            DATABASE::"Teller Close Till":
                begin
                    RecRef.SetTable(TellerCloseTill);
                    ReleaseFOSADocument.ReopenTellerCloseTill(TellerCloseTill);
                    Handled := true;
                end;
            DATABASE::"Treasury Transaction Header":
                begin
                    RecRef.SetTable(TreasuryTransactionHeader);
                    ReleaseFOSADocument.ReopenTreasuryTransaction(TreasuryTransactionHeader);
                    Handled := true;
                end;
            DATABASE::"Treasury Return Bank Header":
                begin
                    RecRef.SetTable(TellerReturnTreasury);
                    ReleaseFOSADocument.ReopenTreasuryReturnBank(TreasuryReturnBank);
                    Handled := true;
                end;
            DATABASE::"InterTeller Transfer Header":
                begin
                    RecRef.SetTable(InterTellerTransferHeader);
                    ReleaseFOSADocument.ReopenInterTellerTransfer(InterTellerTransferHeader);
                    Handled := true;
                end;
            DATABASE::"InterTreasury Transfer Header":
                begin
                    RecRef.SetTable(InterTreasuryTransferHeader);
                    ReleaseFOSADocument.ReopenInterTreasuryTransfer(InterTreasuryTransferHeader);
                    Handled := true;
                end;

        end;
    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        ReleaseFOSADocument: Codeunit "Release FOSA Document";
        ReleaseBOSADocument: Codeunit "Release BOSA Document";

        ApprovalMgmt: Codeunit "Approvals Mgmt Ext";

}