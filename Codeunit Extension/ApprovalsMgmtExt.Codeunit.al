codeunit 50012 "Approvals Mgmt Ext"
{
    trigger OnRun()
    begin

    end;
    //OnApproveApprovalRequest
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        ApprovalEntry2: Record "Approval Entry";
        ApprovalEntry3: Record "Approval Entry";
        ApprovalEntry4: Record "Approval Entry";
        ResponseExt: Codeunit "Workflow Response Handling Ext";
        WorkflowEventQue: Record "Workflow Event Queue";
        PurchaseHeader: Record "Purchase Header";
        PaymentHeader: Record "Payment Header";
        ApprovalEntryCount: Integer;
        ApprovedApprovalEntryCount: Integer;
        RecRef: RecordRef;
        Handled: Boolean;
        RecId: RecordId;
        ApprovalEntTID: Text;
        VariantNew: Variant;
        RestrictedRecord: Record "Restricted Record";
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
        //A minimun of one approver in the same sequence is required for any approval 
        if ApprovalEntry.Status = ApprovalEntry.Status::Approved then begin
            RecRef.Open(ApprovalEntry."Table ID");
            RecId := ApprovalEntry."Record ID to Approve";

            //Approve all approval entries in the same sequence
            ApprovalEntry2.Reset();
            ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalEntry2.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry2.SetRange("Document No.", ApprovalEntry."Document No.");
            ApprovalEntry2.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
            ApprovalEntry2.SetFilter("Entry No.", '<>%1', ApprovalEntry."Entry No.");
            if ApprovalEntry2.FindSet() then begin
                repeat
                    ApprovalEntry2.Status := ApprovalEntry2.Status::Approved;
                    ApprovalEntry2."Last Modified By User ID" := UserId;
                    ApprovalEntry2.Modify();
                until ApprovalEntry2.Next = 0;
            end;

            //Check count of all approval entries
            ApprovalEntry3.Reset();
            ApprovalEntry3.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalEntry3.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry3.SetRange("Document No.", ApprovalEntry."Document No.");
            ApprovalEntry3.SetRange("Table ID", ApprovalEntry."Table ID");
            if ApprovalEntry3.FindSet() then begin
                ApprovalEntryCount := ApprovalEntry3.Count();
            end;

            //Check count of all approved approval entries
            ApprovalEntry4.Reset();
            ApprovalEntry4.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalEntry4.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry4.SetRange("Document No.", ApprovalEntry."Document No.");
            ApprovalEntry4.SetRange("Table ID", ApprovalEntry."Table ID");
            ApprovalEntry4.SetRange(Status, ApprovalEntry4.Status::Approved);
            if ApprovalEntry4.FindSet() then begin
                ApprovedApprovalEntryCount := ApprovalEntry4.Count();
            end;

            //Clear Sessions From Workflow Event Que due to Nav variant Error
            WorkflowEventQue.Reset();
            WorkflowEventQue.SetRange("Session ID", SessionId());
            if WorkflowEventQue.FindSet() then begin
                WorkflowEventQue.DeleteAll();
            end;

            //If All Approval entries are approved then proceed to release document
            If ApprovalEntryCount = ApprovedApprovalEntryCount then begin
                if RecRef.Get(RecId) then begin // This is will find the record in the table to be Approved.  
                    CASE ApprovalEntry."Table ID" OF
                        DATABASE::"Purchase Header":
                            BEGIN
                                IF PurchaseHeader.GET(ApprovalEntry."Document Type", ApprovalEntry."Document No.") THEN BEGIN
                                    PurchaseHeader.Status := PurchaseHeader.Status::Released;
                                    PurchaseHeader.Modify();
                                    RestrictedRecord.Reset();
                                    RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
                                    if RestrictedRecord.FindSet() then begin
                                        RestrictedRecord.DeleteAll();
                                    end;
                                END;
                            END;
                        DATABASE::"Payment Header":
                            BEGIN
                                IF PaymentHeader.GET(ApprovalEntry."Document No.") THEN BEGIN
                                    PaymentHeader.Status := PaymentHeader.Status::Approved;
                                    PaymentHeader.Modify();
                                    RestrictedRecord.Reset();
                                    RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
                                    if RestrictedRecord.FindSet() then begin
                                        RestrictedRecord.DeleteAll();
                                    end;
                                END;
                            END;
                    END;
                    ResponseExt.OnReleaseDocument(RecRef, Handled);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
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
        AgentApplicaton: Record "Agent Application";
        TellerTransactionHeader: Record "Teller Transaction Header";
        TellerReturnTreasury: Record "Teller Return Treasury";
        TellerCloseTill: Record "Teller Close Till";
        TreasuryTransactionHeader: Record "Treasury Transaction Header";
        TreasuryReturnBank: Record "Treasury Return Bank Header";
        InterTellerTransferHeader: Record "InterTeller Transfer Header";
        InterTreasuryTransferHeader: Record "InterTreasury Transfer Header";
    begin
        case RecRef.NUMBER of
            DATABASE::"Member Application":
                begin
                    RecRef.SETTABLE(MemberApplication);
                    ApprovalEntryArgument."Document No." := MemberApplication."No.";
                end;
            DATABASE::"Account Opening":
                begin
                    RecRef.SETTABLE(AccountOpening);
                    ApprovalEntryArgument."Document No." := AccountOpening."No.";
                end;
            DATABASE::"Loan Application":
                begin
                    RecRef.SETTABLE(LoanApplication);
                    ApprovalEntryArgument."Document No." := LoanApplication."No.";
                end;
            DATABASE::"Standing Order":
                begin
                    RecRef.SETTABLE(StandingOrder);
                    ApprovalEntryArgument."Document No." := StandingOrder."No.";
                end;
            DATABASE::"Fund Transfer":
                begin
                    RecRef.SETTABLE(FundTransfer);
                    ApprovalEntryArgument."Document No." := FundTransfer."No.";
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    RecRef.SETTABLE(LoanRescheduling);
                    ApprovalEntryArgument."Document No." := LoanRescheduling."No.";
                end;

            DATABASE::"Loan Restructuring":
                begin
                    RecRef.SETTABLE(LoanRestructuring);
                    ApprovalEntryArgument."Document No." := LoanRestructuring."No.";
                end;
            DATABASE::"Guarantor Substitution Header":
                begin
                    RecRef.SETTABLE(GuarantorSubstitutionHeader);
                    ApprovalEntryArgument."Document No." := GuarantorSubstitutionHeader."No.";
                end;
            DATABASE::"Payout Header":
                begin
                    RecRef.SETTABLE(PayoutHeader);
                    ApprovalEntryArgument."Document No." := PayoutHeader."No.";
                end;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SETTABLE(DividendHeader);
                    ApprovalEntryArgument."Document No." := DividendHeader."No.";
                end;
            DATABASE::"Member Exit Header":
                begin
                    RecRef.SETTABLE(MemberExitHeader);
                    ApprovalEntryArgument."Document No." := MemberExitHeader."No.";
                end;
            DATABASE::"Member Achive Header":
                begin
                    RecRef.SETTABLE(MemberArchiveHeader);
                    ApprovalEntryArgument."Document No." := MemberArchiveHeader."No.";
                end;
            DATABASE::"Member Refund Header":
                begin
                    RecRef.SETTABLE(MemberRefundHeader);
                    ApprovalEntryArgument."Document No." := MemberRefundHeader."No.";
                end;
            DATABASE::"Member Claim Header":
                begin
                    RecRef.SETTABLE(MemberClaimHeader);
                    ApprovalEntryArgument."Document No." := MemberClaimHeader."No.";
                end;
            DATABASE::"Loan Selloff":
                begin
                    RecRef.SETTABLE(LoanSelloff);
                    ApprovalEntryArgument."Document No." := LoanSelloff."No.";
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    RecRef.SETTABLE(LoanWriteoffHeader);
                    ApprovalEntryArgument."Document No." := LoanWriteoffHeader."No.";
                end;
            DATABASE::"Group Allocation Header":
                begin
                    RecRef.SETTABLE(GroupAllocationHeader);
                    ApprovalEntryArgument."Document No." := GroupAllocationHeader."No.";
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    RecRef.SETTABLE(PortfolioTransfer);
                    ApprovalEntryArgument."Document No." := PortfolioTransfer."No.";
                end;
            DATABASE::"Member Activation Header":
                begin
                    RecRef.SETTABLE(MemberActivationHeader);
                    ApprovalEntryArgument."Document No." := MemberActivationHeader."No.";
                end;

            DATABASE::"Mobile Banking Application":
                begin
                    RecRef.SETTABLE(MobileBankingApplication);
                    ApprovalEntryArgument."Document No." := MobileBankingApplication."No.";
                end;
            DATABASE::"Mobile Banking Activ. Header":
                begin
                    RecRef.SETTABLE(MobileBankingActivationHeader);
                    ApprovalEntryArgument."Document No." := MobileBankingActivationHeader."No.";
                end;
            DATABASE::"ATM Application":
                begin
                    RecRef.SETTABLE(ATMApplication);
                    ApprovalEntryArgument."Document No." := ATMApplication."No.";
                end;
            DATABASE::"ATM Collection":
                begin
                    RecRef.SETTABLE(ATMCollection);
                    ApprovalEntryArgument."Document No." := ATMCollection."No.";
                end;
            DATABASE::"ATM Activation Header":
                begin
                    RecRef.SETTABLE(ATMActivationHeader);
                    ApprovalEntryArgument."Document No." := ATMActivationHeader."No.";
                end;
            DATABASE::"Cheque Book Application":
                begin
                    RecRef.SETTABLE(ChequeBookApplication);
                    ApprovalEntryArgument."Document No." := ChequeBookApplication."No.";
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    RecRef.SETTABLE(ChequeClearanceHeader);
                    ApprovalEntryArgument."Document No." := ChequeClearanceHeader."No.";
                end;
            DATABASE::"Agent Application":
                begin
                    RecRef.SETTABLE(AgentApplicaton);
                    ApprovalEntryArgument."Document No." := AgentApplicaton."No.";
                end;
            DATABASE::"Teller Transaction Header":
                begin
                    RecRef.SETTABLE(TellerTransactionHeader);
                    ApprovalEntryArgument."Document No." := TellerTransactionHeader."No.";
                end;
            DATABASE::"Teller Return Treasury":
                begin
                    RecRef.SETTABLE(TellerReturnTreasury);
                    ApprovalEntryArgument."Document No." := TellerReturnTreasury."No.";
                end;
            DATABASE::"Teller Close Till":
                begin
                    RecRef.SETTABLE(TellerCloseTill);
                    ApprovalEntryArgument."Document No." := TellerCloseTill."No.";
                end;
            DATABASE::"Treasury Transaction Header":
                begin
                    RecRef.SETTABLE(TreasuryTransactionHeader);
                    ApprovalEntryArgument."Document No." := TreasuryTransactionHeader."No.";
                end;
            DATABASE::"Treasury Return Bank Header":
                begin
                    RecRef.SETTABLE(TreasuryReturnBank);
                    ApprovalEntryArgument."Document No." := TreasuryReturnBank."No.";
                end;
            DATABASE::"InterTeller Transfer Header":
                begin
                    RecRef.SETTABLE(InterTellerTransferHeader);
                    ApprovalEntryArgument."Document No." := InterTellerTransferHeader."No.";
                end;
            DATABASE::"InterTreasury Transfer Header":
                begin
                    RecRef.SETTABLE(InterTreasuryTransferHeader);
                    ApprovalEntryArgument."Document No." := InterTreasuryTransferHeader."No.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
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
        AgentApplicaton: Record "Agent Application";
        TellerTransactionHeader: Record "Teller Transaction Header";
        TellerReturnTreasury: Record "Teller Return Treasury";
        TellerCloseTill: Record "Teller Close Till";
        TreasuryTransactionHeader: Record "Treasury Transaction Header";
        TreasuryReturnBank: Record "Treasury Return Bank Header";
        InterTellerTransferHeader: Record "InterTeller Transfer Header";
        InterTreasuryTransferHeader: Record "InterTreasury Transfer Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    MemberApplication.Status := MemberApplication.Status::"Pending Approval";
                    MemberApplication.Modify(true);
                    isHandled := true;

                    RecRef.GetTable(MemberApplication);
                    FOSAManagement.SendNotification(RecRef);

                end;
            DATABASE::"Account Opening":
                begin
                    RecRef.SetTable(AccountOpening);
                    AccountOpening.Status := AccountOpening.Status::"Pending Approval";
                    AccountOpening.Modify(true);
                    isHandled := true;

                    RecRef.GetTable(AccountOpening);
                    FOSAManagement.SendNotification(RecRef);

                end;
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    LoanApplication.Status := LoanApplication.Status::"Pending Approval";
                    LoanApplication.Modify(true);
                    isHandled := true;

                    RecRef.GetTable(LoanApplication);
                    BOSAManagement.SendNotification(RecRef);
                end;
            DATABASE::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    StandingOrder.Status := StandingOrder.Status::"Pending Approval";
                    StandingOrder.Modify(true);
                    isHandled := true;

                end;
            DATABASE::"Fund Transfer":
                begin
                    RecRef.SetTable(FundTransfer);
                    FundTransfer.Status := FundTransfer.Status::"Pending Approval";
                    FundTransfer.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    RecRef.SetTable(LoanRescheduling);
                    LoanRescheduling.Status := LoanRescheduling.Status::"Pending Approval";
                    LoanRescheduling.Modify(true);
                    isHandled := true;

                    RecRef.GetTable(LoanRescheduling);
                    BOSAManagement.SendNotification(RecRef);
                end;

            DATABASE::"Loan Restructuring":
                begin
                    RecRef.SetTable(LoanRestructuring);
                    LoanRestructuring.Status := LoanRestructuring.Status::"Pending Approval";
                    LoanRestructuring.Modify(true);
                    isHandled := true;

                    RecRef.GetTable(LoanRestructuring);
                    BOSAManagement.SendNotification(RecRef);
                end;
            DATABASE::"Guarantor Substitution Header":
                begin
                    RecRef.SetTable(GuarantorSubstitutionHeader);
                    GuarantorSubstitutionHeader.Status := GuarantorSubstitutionHeader.Status::"Pending Approval";
                    GuarantorSubstitutionHeader.Modify(true);
                    isHandled := true;

                    RecRef.GetTable(GuarantorSubstitutionHeader);
                    BOSAManagement.SendNotification(RecRef);
                end;
            DATABASE::"Payout Header":
                begin
                    RecRef.SetTable(PayoutHeader);
                    PayoutHeader.Status := PayoutHeader.Status::"Pending Approval";
                    PayoutHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SetTable(DividendHeader);
                    DividendHeader.Status := DividendHeader.Status::"Pending Approval";
                    DividendHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExitHeader);
                    MemberExitHeader.Status := MemberExitHeader.Status::"Pending Approval";
                    MemberExitHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Achive Header":
                begin
                    RecRef.SetTable(MemberArchiveHeader);
                    MemberArchiveHeader.Status := MemberArchiveHeader.Status::"Pending Approval";
                    MemberArchiveHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Refund Header":
                begin
                    RecRef.SetTable(MemberRefundHeader);
                    MemberRefundHeader.Status := MemberRefundHeader.Status::"Pending Approval";
                    MemberRefundHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Claim Header":
                begin
                    RecRef.SetTable(MemberClaimHeader);
                    MemberClaimHeader.Status := MemberClaimHeader.Status::"Pending Approval";
                    MemberClaimHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Loan Selloff":
                begin
                    RecRef.SetTable(LoanSelloff);
                    LoanSelloff.Status := LoanSelloff.Status::"Pending Approval";
                    LoanSelloff.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    RecRef.SetTable(LoanWriteoffHeader);
                    LoanWriteoffHeader.Status := LoanWriteoffHeader.Status::"Pending Approval";
                    LoanWriteoffHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Group Allocation Header":
                begin
                    RecRef.SetTable(GroupAllocationHeader);
                    GroupAllocationHeader.Status := GroupAllocationHeader.Status::"Pending Approval";
                    GroupAllocationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    PortfolioTransfer.Status := PortfolioTransfer.Status::"Pending Approval";
                    PortfolioTransfer.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Activation Header":
                begin
                    RecRef.SetTable(MemberActivationHeader);
                    MemberActivationHeader.Status := MemberActivationHeader.Status::"Pending Approval";
                    MemberActivationHeader.Modify(true);
                    isHandled := true;
                end;

            DATABASE::"Mobile Banking Application":
                begin
                    RecRef.SetTable(MobileBankingApplication);
                    MobileBankingApplication.Status := MobileBankingApplication.Status::"Pending Approval";
                    MobileBankingApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Mobile Banking Activ. Header":
                begin
                    RecRef.SetTable(MobileBankingActivationHeader);
                    MobileBankingActivationHeader.Status := MobileBankingActivationHeader.Status::"Pending Approval";
                    MobileBankingActivationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ATMApplication.Status := ATMApplication.Status::"Pending Approval";
                    ATMApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"ATM Collection":
                begin
                    RecRef.SetTable(ATMCollection);
                    ATMCollection.Status := ATMCollection.Status::"Pending Approval";
                    ATMCollection.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"ATM Activation Header":
                begin
                    RecRef.SetTable(ATMActivationHeader);
                    ATMActivationHeader.Status := ATMActivationHeader.Status::"Pending Approval";
                    ATMActivationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Cheque Book Application":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ChequeBookApplication.Status := ChequeBookApplication.Status::"Pending Approval";
                    ChequeBookApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    RecRef.SetTable(ChequeClearanceHeader);
                    ChequeClearanceHeader.Status := ChequeClearanceHeader.Status::"Pending Approval";
                    ChequeClearanceHeader.Modify(true);
                    isHandled := true;
                end;

            DATABASE::"Agent Application":
                begin
                    RecRef.SETTABLE(AgentApplicaton);
                    AgentApplicaton.VALIDATE(Status, AgentApplicaton.Status::"Pending Approval");
                    AgentApplicaton.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"Teller Transaction Header":
                begin
                    RecRef.SETTABLE(TellerTransactionHeader);
                    TellerTransactionHeader.VALIDATE(Status, TellerTransactionHeader.Status::"Pending Approval");
                    TellerTransactionHeader.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"Teller Return Treasury":
                begin
                    RecRef.SETTABLE(TellerReturnTreasury);
                    TellerReturnTreasury.VALIDATE(Status, TellerReturnTreasury.Status::"Pending Approval");
                    TellerReturnTreasury.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"Teller Close Till":
                begin
                    RecRef.SETTABLE(TellerCloseTill);
                    TellerCloseTill.VALIDATE(Status, TellerCloseTill.Status::"Pending Approval");
                    TellerCloseTill.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"Treasury Transaction Header":
                begin
                    RecRef.SETTABLE(TreasuryTransactionHeader);
                    TreasuryTransactionHeader.VALIDATE(Status, TreasuryTransactionHeader.Status::"Pending Approval");
                    TreasuryTransactionHeader.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"Treasury Return Bank Header":
                begin
                    RecRef.SETTABLE(TreasuryReturnBank);
                    TreasuryReturnBank.VALIDATE(Status, TreasuryReturnBank.Status::"Pending Approval");
                    TreasuryReturnBank.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"InterTeller Transfer Header":
                begin
                    RecRef.SETTABLE(InterTellerTransferHeader);
                    InterTellerTransferHeader.VALIDATE(Status, InterTellerTransferHeader.Status::"Pending Approval");
                    InterTellerTransferHeader.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"InterTreasury Transfer Header":
                begin
                    RecRef.SETTABLE(InterTreasuryTransferHeader);
                    InterTreasuryTransferHeader.VALIDATE(Status, InterTreasuryTransferHeader.Status::"Pending Approval");
                    InterTreasuryTransferHeader.MODIFY(TRUE);
                    isHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
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
        AgentApplicaton: Record "Agent Application";
        TellerTransactionHeader: Record "Teller Transaction Header";
        TellerReturnTreasury: Record "Teller Return Treasury";
        TellerCloseTill: Record "Teller Close Till";
        TreasuryTransactionHeader: Record "Treasury Transaction Header";
        TreasuryReturnBank: Record "Treasury Return Bank Header";
        InterTellerTransferHeader: Record "InterTeller Transfer Header";
        InterTreasuryTransferHeader: Record "InterTreasury Transfer Header";
    begin
        CASE ApprovalEntry."Table ID" OF
            DATABASE::"Member Application":
                begin
                    MemberApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectMemberApplication(MemberApplication);
                end;
            DATABASE::"Account Opening":
                begin
                    AccountOpening.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectAccountOpening(AccountOpening);
                end;
            DATABASE::"Loan Application":
                begin
                    LoanApplication.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanApplication(LoanApplication);
                end;
            DATABASE::"Standing Order":
                begin
                    StandingOrder.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectStandingOrder(StandingOrder);
                end;
            DATABASE::"Fund Transfer":
                begin
                    FundTransfer.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectFundTransfer(FundTransfer);
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    LoanRescheduling.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanRescheduling(LoanRescheduling);
                end;

            DATABASE::"Loan Restructuring":
                begin
                    LoanRestructuring.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanRestructuring(LoanRestructuring);
                end;
            DATABASE::"Guarantor Substitution Header":
                begin
                    GuarantorSubstitutionHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectGuarantorSubstitution(GuarantorSubstitutionHeader);
                end;
            DATABASE::"Payout Header":
                begin
                    PayoutHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectPayout(PayoutHeader);
                end;
            DATABASE::"Dividend Header":
                begin
                    DividendHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectDividend(DividendHeader);
                end;
            DATABASE::"Member Exit Header":
                begin
                    MemberExitHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberExit(MemberExitHeader);
                end;
            DATABASE::"Member Achive Header":
                begin
                    MemberArchiveHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberArchive(MemberArchiveHeader);
                end;
            DATABASE::"Member Refund Header":
                begin
                    MemberRefundHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberRefund(MemberRefundHeader);
                end;
            DATABASE::"Member Claim Header":
                begin
                    MemberClaimHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberClaim(MemberClaimHeader);
                end;
            DATABASE::"Loan Selloff":
                begin
                    LoanSelloff.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanSelloff(LoanSelloff);
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    LoanWriteoffHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanWriteoff(LoanWriteoffHeader);
                end;
            DATABASE::"Group Allocation Header":
                begin
                    GroupAllocationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectGroupAllocation(GroupAllocationHeader);
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    PortfolioTransfer.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectPortfolioTransfer(PortfolioTransfer);
                end;
            DATABASE::"Member Activation Header":
                begin
                    MemberActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectMemberActivationDeactivation(MemberActivationHeader);
                end;

            DATABASE::"Mobile Banking Application":
                begin
                    MobileBankingApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectMobileBankingApplication(MobileBankingApplication);
                end;
            DATABASE::"Mobile Banking Activ. Header":
                begin
                    MobileBankingActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectMobileBankingActivationDeactivation(MobileBankingActivationHeader);
                end;
            DATABASE::"ATM Application":
                begin
                    ATMApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectATMApplication(ATMApplication);
                end;
            DATABASE::"ATM Collection":
                begin
                    ATMCollection.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectATMCollection(ATMCollection);
                end;
            DATABASE::"ATM Activation Header":
                begin
                    ATMActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectATMActivationDeactivation(ATMActivationHeader);
                end;
            DATABASE::"Cheque Book Application":
                begin
                    ChequeBookApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectChequeBookApplication(ChequeBookApplication);
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    ChequeClearanceHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectChequeClearance(ChequeClearanceHeader);
                end;

            DATABASE::"Agent Application":
                begin
                    AgentApplicaton.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectAgentApplication(AgentApplicaton);
                end;
            DATABASE::"Teller Transaction Header":
                begin
                    TellerTransactionHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectTellerTransaction(TellerTransactionHeader);
                end;
            DATABASE::"Teller Return Treasury":
                begin
                    TellerReturnTreasury.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectTellerReturnTreasury(TellerReturnTreasury);
                end;
            DATABASE::"Teller Close Till":
                begin
                    TellerCloseTill.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectTellerCloseTill(TellerCloseTill);
                end;
            DATABASE::"Treasury Transaction Header":
                begin
                    TreasuryTransactionHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectTreasuryTransaction(TreasuryTransactionHeader);
                end;
            DATABASE::"Treasury Return Bank Header":
                begin
                    TreasuryReturnBank.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectTreasuryReturnBank(TreasuryReturnBank);
                end;
            DATABASE::"InterTeller Transfer Header":
                begin
                    InterTellerTransferHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectInterTellerTransfer(InterTellerTransferHeader);
                end;
            DATABASE::"InterTreasury Transfer Header":
                begin
                    InterTreasuryTransferHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectInterTreasuryTransfer(InterTreasuryTransferHeader);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAccountOpeningForApproval(var AccountOpening: Record "Account Opening")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendFundTransferForApproval(var FundTransfer: Record "Fund Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanReschedulingForApproval(var LoanRescheduling: Record "Loan Rescheduling")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanRestructuringForApproval(var LoanRestructuring: Record "Loan Restructuring")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendGuarantorSubstitutionForApproval(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPayoutForApproval(var PayoutHeader: Record "Payout Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDividendForApproval(var DividendHeader: Record "Dividend Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberExitForApproval(var MemberExitHeader: Record "Member Exit Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberArchiveForApproval(var MemberArchiveHeader: Record "Member Achive Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberRefundForApproval(var MemberRefundHeader: Record "Member Refund Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberClaimForApproval(var MemberClaimHeader: Record "Member Claim Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanSelloffForApproval(var LoanSelloff: Record "Loan Selloff")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanWriteoffForApproval(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendGroupAllocationForApproval(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPortfolioTransferForApproval(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberActivationDeactivationForApproval(var MemberActivationHeader: Record "Member Activation Header")
    begin
    end;



    [IntegrationEvent(false, false)]
    procedure OnSendMobileBankingApplicationForApproval(var MobileBankingApplication: Record "Mobile Banking Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMobileBankingActivationDeactivationForApproval(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMCollectionForApproval(var ATMCollection: Record "ATM Collection")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMActivationDeactivationForApproval(var ATMActivationHeader: Record "ATM Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChequeBookApplicationForApproval(var ChequeBookApplication: Record "Cheque Book Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChequeClearanceForApproval(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAgentApplicationForApproval(VAR AgentApplication: Record "Agent Application");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTellerTransactionForApproval(VAR TellerTransactionHeader: Record "Teller Transaction Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTellerReturnTreasuryForApproval(VAR TellerReturnTreasury: Record "Teller Return Treasury");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTellerCloseTillForApproval(VAR TellerCloseTill: Record "Teller Close Till");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTreasuryTransactionForApproval(VAR TreasuryTransactionHeader: Record "Treasury Transaction Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTreasuryReturnBankForApproval(VAR TreasuryReturnBank: Record "Treasury Return Bank Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendInterTellerTransferForApproval(VAR InterTellerTransferHeader: Record "InterTeller Transfer Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendInterTreasuryTransferForApproval(VAR InterTreasuryTransferHeader: Record "InterTreasury Transfer Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberApplicationApprovalRequest(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelAccountOpeningApprovalRequest(var AccountOpening: Record "Account Opening")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanApplicationApprovalRequest(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStandingOrderApprovalRequest(var StandingOrder: Record "Standing Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFundTransferApprovalRequest(var FundTransfer: Record "Fund Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanReschedulingApprovalRequest(var LoanRescheduling: Record "Loan Rescheduling")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanRestructuringApprovalRequest(var LoanRestructuring: Record "Loan Restructuring")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelGuarantorSubstitutionApprovalRequest(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPayoutApprovalRequest(var PayoutHeader: Record "Payout Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDividendApprovalRequest(var DividendHeader: Record "Dividend Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberExitApprovalRequest(var MemberExitHeader: Record "Member Exit Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberArchiveApprovalRequest(var MemberArchiveHeader: Record "Member Achive Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberRefundApprovalRequest(var MemberRefundHeader: Record "Member Refund Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberClaimApprovalRequest(var MemberClaimHeader: Record "Member Claim Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanSelloffApprovalRequest(var LoanSelloff: Record "Loan Selloff")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanWriteoffApprovalRequest(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelGroupAllocationApprovalRequest(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPortfolioTransferApprovalRequest(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberActivationDeactivationApprovalRequest(var MemberActivationHeader: Record "Member Activation Header")
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnCancelMobileBankingApplicationApprovalRequest(var MobileBankingApplication: Record "Mobile Banking Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMobileBankingActivationDeactivationApprovalRequest(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelATMApplicationApprovalRequest(var ATMApplication: Record "ATM Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelATMCollectionApprovalRequest(var ATMCollection: Record "ATM Collection")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelATMActivationDeactivationApprovalRequest(var ATMActivationHeader: Record "ATM Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelChequeBookApplicationApprovalRequest(var ChequeBookApplication: Record "Cheque Book Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelChequeClearanceApprovalRequest(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
    end;



    [IntegrationEvent(false, false)]
    procedure OnCancelAgentApplicationApprovalRequest(VAR AgentApplication: Record "Agent Application");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTellerTransactionApprovalRequest(VAR TellerTransactionHeader: Record "Teller Transaction Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTellerReturnTreasuryApprovalRequest(VAR TellerReturnTreasury: Record "Teller Return Treasury");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTellerCloseTillApprovalRequest(VAR TellerCloseTill: Record "Teller Close Till");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTreasuryTransactionApprovalRequest(VAR TreasuryTransactionHeader: Record "Treasury Transaction Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTreasuryReturnBankApprovalRequest(VAR TreasuryReturnBank: Record "Treasury Return Bank Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelInterTellerTransferApprovalRequest(VAR InterTellerTransferHeader: Record "InterTeller Transfer Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelInterTreasuryTransferApprovalRequest(VAR InterTreasuryTransferHeader: Record "InterTreasury Transfer Header");
    begin
    end;

    procedure IsMemberApplicationApprovalsWorkflowEnabled(var MemberApplication: Record "Member Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberApplication, WorkflowEventHandlingExt.RunWorkflowOnSendMemberApplicationForApprovalCode));
    end;

    procedure IsAccountOpeningApprovalsWorkflowEnabled(var AccountOpening: Record "Account Opening"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(AccountOpening, WorkflowEventHandlingExt.RunWorkflowOnSendAccountOpeningForApprovalCode));
    end;

    procedure IsLoanApplicationApprovalsWorkflowEnabled(var LoanApplication: Record "Loan Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanApplication, WorkflowEventHandlingExt.RunWorkflowOnSendLoanApplicationForApprovalCode));
    end;

    procedure IsStandingOrderApprovalsWorkflowEnabled(var StandingOrder: Record "Standing Order"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(StandingOrder, WorkflowEventHandlingExt.RunWorkflowOnSendStandingOrderForApprovalCode));
    end;

    procedure IsFundTransferApprovalsWorkflowEnabled(var FundTransfer: Record "Fund Transfer"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(FundTransfer, WorkflowEventHandlingExt.RunWorkflowOnSendFundTransferForApprovalCode));
    end;

    procedure IsLoanReschedulingApprovalsWorkflowEnabled(var LoanRescheduling: Record "Loan Rescheduling"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanRescheduling, WorkflowEventHandlingExt.RunWorkflowOnSendLoanReschedulingForApprovalCode));
    end;

    procedure IsLoanRestructuringApprovalsWorkflowEnabled(var LoanRestructuring: Record "Loan Restructuring"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanRestructuring, WorkflowEventHandlingExt.RunWorkflowOnSendLoanRestructuringForApprovalCode));
    end;

    procedure IsGuarantorSubstitutionApprovalsWorkflowEnabled(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(GuarantorSubstitutionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendGuarantorSubstitutionForApprovalCode));
    end;

    procedure IsPayoutApprovalsWorkflowEnabled(var PayoutHeader: Record "Payout Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PayoutHeader, WorkflowEventHandlingExt.RunWorkflowOnSendPayoutForApprovalCode));
    end;

    procedure IsDividendApprovalsWorkflowEnabled(var DividendHeader: Record "Dividend Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(DividendHeader, WorkflowEventHandlingExt.RunWorkflowOnSendDividendForApprovalCode));
    end;

    procedure IsMemberExitApprovalsWorkflowEnabled(var MemberExitHeader: Record "Member Exit Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberExitHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberExitForApprovalCode));
    end;

    procedure IsMemberArchiveApprovalsWorkflowEnabled(var MemberArchiveHeader: Record "Member Achive Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberArchiveHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberArchiveForApprovalCode));
    end;

    procedure IsMemberRefundApprovalsWorkflowEnabled(var MemberRefundHeader: Record "Member Refund Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberRefundHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberRefundForApprovalCode));
    end;

    procedure IsMemberClaimApprovalsWorkflowEnabled(var MemberClaimHeader: Record "Member Claim Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberClaimHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberClaimForApprovalCode));
    end;

    procedure IsLoanSelloffApprovalsWorkflowEnabled(var LoanSelloff: Record "Loan Selloff"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanSelloff, WorkflowEventHandlingExt.RunWorkflowOnSendLoanSelloffForApprovalCode));
    end;

    procedure IsLoanSellWriteoffApprovalsWorkflowEnabled(var LoanWriteoffHeader: Record "Loan Writeoff Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanWriteoffHeader, WorkflowEventHandlingExt.RunWorkflowOnSendLoanWriteoffForApprovalCode));
    end;

    procedure IsGroupAllocationApprovalsWorkflowEnabled(var GroupAllocationHeader: Record "Group Allocation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(GroupAllocationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendGroupAllocationForApprovalCode));
    end;

    procedure IsPortfolioTransferApprovalsWorkflowEnabled(var PortfolioTransfer: Record "Portfolio Transfer"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PortfolioTransfer, WorkflowEventHandlingExt.RunWorkflowOnSendPortfolioTransferForApprovalCode));
    end;

    procedure IsMemberActivationDeactivationApprovalsWorkflowEnabled(var MemberActivationHeader: Record "Member Activation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberActivationDeactivationForApprovalCode));
    end;

    procedure IsMobileBankingApplicationApprovalsWorkflowEnabled(var MobileBankingApplication: Record "Mobile Banking Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MobileBankingApplication, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingApplicationForApprovalCode));
    end;

    procedure IsMobileBankingActivationDeactivationApprovalsWorkflowEnabled(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MobileBankingActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMobileBankingActivationDeactivationForApprovalCode));
    end;

    procedure IsATMApplicationApprovalsWorkflowEnabled(var ATMApplication: Record "ATM Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ATMApplication, WorkflowEventHandlingExt.RunWorkflowOnSendATMApplicationForApprovalCode));
    end;

    procedure IsATMCollectionApprovalsWorkflowEnabled(var ATMCollection: Record "ATM Collection"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ATMCollection, WorkflowEventHandlingExt.RunWorkflowOnSendATMCollectionForApprovalCode));
    end;

    procedure IsATMActivationDeactivationApprovalsWorkflowEnabled(var ATMActivationHeader: Record "ATM Activation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ATMActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendATMActivationDeactivationForApprovalCode));
    end;

    procedure IsChequeBookApplicationApprovalsWorkflowEnabled(var ChequeBookApplication: Record "Cheque Book Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ChequeBookApplication, WorkflowEventHandlingExt.RunWorkflowOnSendChequeBookApplicationForApprovalCode));
    end;

    procedure IsChequeClearanceApprovalsWorkflowEnabled(var ChequeClearanceHeader: Record "Cheque Clearance Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ChequeClearanceHeader, WorkflowEventHandlingExt.RunWorkflowOnSendChequeClearanceForApprovalCode));
    end;



    procedure IsAgentApplicationWorkflowEnabled(VAR AgentApplication: Record "Agent Application"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(AgentApplication, WorkflowEventHandlingExt.RunWorkflowOnSendAgentApplicationForApprovalCode));
    end;

    procedure IsTellerTransactionWorkflowEnabled(VAR TellerTransactionHeader: Record "Teller Transaction Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TellerTransactionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendTellerTransactionForApprovalCode));
    end;

    procedure IsTellerReturnTreasuryWorkflowEnabled(VAR TellerReturnTreasury: Record "Teller Return Treasury"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TellerReturnTreasury, WorkflowEventHandlingExt.RunWorkflowOnSendTellerReturnTreasuryForApprovalCode));
    end;

    procedure IsTellerCloseTillWorkflowEnabled(VAR TellerCloseTill: Record "Teller Close Till"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TellerCloseTill, WorkflowEventHandlingExt.RunWorkflowOnSendTellerCloseTillForApprovalCode));
    end;

    procedure IsTreasuryTransactionWorkflowEnabled(VAR TreasuryTransactionHeader: Record "Treasury Transaction Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TreasuryTransactionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryTransactionForApprovalCode));
    end;

    procedure IsTreasuryReturnBankWorkflowEnabled(VAR TreasuryReturnBank: Record "Treasury Return Bank Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TreasuryReturnBank, WorkflowEventHandlingExt.RunWorkflowOnSendTreasuryReturnBankForApprovalCode));
    end;

    procedure IsInterTellerTransferWorkflowEnabled(VAR InterTellerTransferHeader: Record "InterTeller Transfer Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(InterTellerTransferHeader, WorkflowEventHandlingExt.RunWorkflowOnSendInterTellerTransferForApprovalCode));
    end;

    procedure IsInterTreasuryTransferWorkflowEnabled(VAR InterTreasuryTransferHeader: Record "InterTreasury Transfer Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(InterTreasuryTransferHeader, WorkflowEventHandlingExt.RunWorkflowOnSendInterTreasuryTransferForApprovalCode));
    end;

    procedure IsMemberChangedWorkflowEnabled(VAR Member: Record Member): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(Member, WorkflowEventHandlingExt.RunWorkflowOnMemberChangedCode));
    end;

    procedure IsBeneficiaryChangedWorkflowEnabled(VAR BeneficiaryType: Record "Beneficiary Type"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(BeneficiaryType, WorkflowEventHandlingExt.RunWorkflowOnBeneficiaryChangedCode));
    end;

    procedure CheckMemberApplicationApprovalPossible(var MemberApplication: Record "Member Application"): Boolean
    begin
        IF NOT IsMemberApplicationApprovalsWorkflowEnabled(MemberApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;


    procedure CheckAccountOpeningApprovalPossible(var AccountOpening: Record "Account Opening"): Boolean
    begin
        IF NOT IsAccountOpeningApprovalsWorkflowEnabled(AccountOpening) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanApplicationApprovalPossible(var LoanApplication: Record "Loan Application"): Boolean
    begin
        IF NOT IsLoanApplicationApprovalsWorkflowEnabled(LoanApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckStandingOrderApprovalPossible(var StandingOrder: Record "Standing Order"): Boolean
    begin
        IF NOT IsStandingOrderApprovalsWorkflowEnabled(StandingOrder) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckFundTransferApprovalPossible(var FundTransfer: Record "Fund Transfer"): Boolean
    begin
        IF NOT IsFundTransferApprovalsWorkflowEnabled(FundTransfer) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanReschedulingApprovalPossible(var LoanRescheduling: Record "Loan Rescheduling"): Boolean
    begin
        IF NOT IsLoanReschedulingApprovalsWorkflowEnabled(LoanRescheduling) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanRestructuringApprovalPossible(var LoanRestructuring: Record "Loan Restructuring"): Boolean
    begin
        IF NOT IsLoanRestructuringApprovalsWorkflowEnabled(LoanRestructuring) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckGuarantorSubstitutionApprovalPossible(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header"): Boolean
    begin
        IF NOT IsGuarantorSubstitutionApprovalsWorkflowEnabled(GuarantorSubstitutionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckPayoutApprovalPossible(var PayoutHeader: Record "Payout Header"): Boolean
    begin
        IF NOT IsPayoutApprovalsWorkflowEnabled(PayoutHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckDividendApprovalPossible(var DividendHeader: Record "Dividend Header"): Boolean
    begin
        IF NOT IsDividendApprovalsWorkflowEnabled(DividendHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberExitApprovalPossible(var MemberExitHeader: Record "Member Exit Header"): Boolean
    begin
        IF NOT IsMemberExitApprovalsWorkflowEnabled(MemberExitHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberArchiveApprovalPossible(var MemberArchiveHeader: Record "Member Achive Header"): Boolean
    begin
        IF NOT IsMemberArchiveApprovalsWorkflowEnabled(MemberArchiveHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberRefundApprovalPossible(var MemberRefundHeader: Record "Member Refund Header"): Boolean
    begin
        IF NOT IsMemberRefundApprovalsWorkflowEnabled(MemberRefundHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberClaimApprovalPossible(var MemberClaimHeader: Record "Member Claim Header"): Boolean
    begin
        IF NOT IsMemberClaimApprovalsWorkflowEnabled(MemberClaimHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanSelloffApprovalPossible(var LoanSelloff: Record "Loan Selloff"): Boolean
    begin
        IF NOT IsLoanSelloffApprovalsWorkflowEnabled(LoanSelloff) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanWriteoffApprovalPossible(var LoanWriteoffHeader: Record "Loan Writeoff Header"): Boolean
    begin
        IF NOT IsLoanSellWriteoffApprovalsWorkflowEnabled(LoanWriteoffHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckGroupAllocationApprovalPossible(var GroupAllocationHeader: Record "Group Allocation Header"): Boolean
    begin
        IF NOT IsGroupAllocationApprovalsWorkflowEnabled(GroupAllocationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckPortfolioTransferApprovalPossible(var PortfolioTransfer: Record "Portfolio Transfer"): Boolean
    begin
        IF NOT IsPortfolioTransferApprovalsWorkflowEnabled(PortfolioTransfer) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberActivationDeactivationApprovalPossible(var MemberActivationHeader: Record "Member Activation Header"): Boolean
    begin
        IF NOT IsMemberActivationDeactivationApprovalsWorkflowEnabled(MemberActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMobileBankingApplicationApprovalPossible(var MobileBankingApplication: Record "Mobile Banking Application"): Boolean
    begin
        IF NOT IsMobileBankingApplicationApprovalsWorkflowEnabled(MobileBankingApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMobileBankingActivationDeactivationApprovalPossible(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header"): Boolean
    begin
        IF NOT IsMobileBankingActivationDeactivationApprovalsWorkflowEnabled(MobileBankingActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckATMApplicationApprovalPossible(var ATMApplication: Record "ATM Application"): Boolean
    begin
        IF NOT IsATMApplicationApprovalsWorkflowEnabled(ATMApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckATMCollectionApprovalPossible(var ATMCollection: Record "ATM Collection"): Boolean
    begin
        IF NOT IsATMCollectionApprovalsWorkflowEnabled(ATMCollection) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckATMActivationDeactivationAApprovalPossible(var ATMActivationHeader: Record "ATM Activation Header"): Boolean
    begin
        IF NOT IsATMActivationDeactivationApprovalsWorkflowEnabled(ATMActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckChequeBookApplicationApprovalPossible(var ChequeBookApplication: Record "Cheque Book Application"): Boolean
    begin
        IF NOT IsChequeBookApplicationApprovalsWorkflowEnabled(ChequeBookApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckChequeClearanceApprovalPossible(var ChequeClearanceHeader: Record "Cheque Clearance Header"): Boolean
    begin
        IF NOT IsChequeClearanceApprovalsWorkflowEnabled(ChequeClearanceHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckAgentApplicationApprovalPossible(VAR AgentApplication: Record "Agent Application"): Boolean;
    begin
        IF NOT IsAgentApplicationWorkflowEnabled(AgentApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckTellerTransactionApprovalPossible(VAR TellerTransactionHeader: Record "Teller Transaction Header"): Boolean;
    begin
        IF NOT IsTellerTransactionWorkflowEnabled(TellerTransactionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckTellerReturnTreasuryApprovalPossible(VAR TellerReturnTreasury: Record "Teller Return Treasury"): Boolean;
    begin
        IF NOT IsTellerReturnTreasuryWorkflowEnabled(TellerReturnTreasury) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckTellerCloseTillPossible(VAR TellerCloseTill: Record "Teller Close Till"): Boolean;
    begin
        IF NOT IsTellerCloseTillWorkflowEnabled(TellerCloseTill) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckTreasuryTransactionApprovalPossible(VAR TreasuryTransactionHeader: Record "Treasury Transaction Header"): Boolean;
    begin
        IF NOT IsTreasuryTransactionWorkflowEnabled(TreasuryTransactionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckTreasuryReturnBankApprovalPossible(VAR TreasuryReturnBank: Record "Treasury Return Bank Header"): Boolean;
    begin
        IF NOT IsTreasuryReturnBankWorkflowEnabled(TreasuryReturnBank) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckInterTellerTransferApprovalPossible(VAR InterTellerTransferHeader: Record "InterTeller Transfer Header"): Boolean;
    begin
        IF NOT IsInterTellerTransferWorkflowEnabled(InterTellerTransferHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckInterTreasuryTransferApprovalPossible(VAR InterTreasuryTransferHeader: Record "InterTreasury Transfer Header"): Boolean;
    begin
        IF NOT IsInterTreasuryTransferWorkflowEnabled(InterTreasuryTransferHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberChangedApprovalPossible(VAR Member: Record Member): Boolean;
    begin
        IF WorkflowManagement.EnabledWorkflowExist(DATABASE::Member, WorkflowEventHandlingExt.RunWorkflowOnMemberChangedCode) THEN
            EXIT(FALSE);
        ERROR(NoWorkflowEnabledErr);
    end;

    procedure CheckBeneficiaryChangedApprovalPossible(VAR BeneficiaryType: Record "Beneficiary Type"): Boolean;
    begin
        IF WorkflowManagement.EnabledWorkflowExist(DATABASE::"Beneficiary Type", WorkflowEventHandlingExt.RunWorkflowOnBeneficiaryChangedCode) THEN
            EXIT(FALSE);
        ERROR(NoWorkflowEnabledErr);
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ReleaseFOSADocument: Codeunit "Release FOSA Document";
        ReleaseBOSADocument: Codeunit "Release BOSA Document";
        FOSAManagement: Codeunit "FOSA Management";
        BOSAManagement: Codeunit "BOSA Management";

}
