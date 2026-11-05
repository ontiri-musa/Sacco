codeunit 50002 "Release FOSA document"
{
    // version TL2.0


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text004: Label 'Are you sure you want to confirm approval for this document?';
        Text005: Label '%1 %2 has been approved successfully.';
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text006: Label '%1 %2 has been rejected sucessfully.';
        RejectAction: Text[50];
        SelectedAction: Integer;
        Text007: Label 'Reset to New Stage,Reject Completely';
        Text008: Label 'Choose Reject Action';
        Text009: Label '%1 %2 has been reset to New Stage.';
        AccountType: Record "Account Type";

    procedure PerformCheckAndReleaseMemberApplication(var MemberApplication: Record "Member Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        RecRef: RecordRef;
        Member: Record Member;
        MError: Label 'Member %1 already exist in the Member Register.';
    begin
        with MemberApplication do begin
            // If ApprovalsMgmt.IsMemberApplicationApprovalsWorkflowEnabled(MemberApplication) AND
            // (MemberApplication.Status = MemberApplication.Status::"Pending Approval") then
            //  ERROR(Text002);
            /*Member.Reset();
            Member.SetRange(Member."National ID", MemberApplication."National ID");
            if Member.FindFirst() then
                Error(MError, Member."Full Name");*/

            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                if "Registration Date" = 0D then
                    "Registration Date" := "Created Date";
                If modify(true) then
                    MESSAGE(Text005, MemberApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseMemberApplication(MemberApplication);

            RecRef.GetTable(MemberApplication);
            FOSAManagement.SendNotification(RecRef);
            FOSAManagement.CreateMember(MemberApplication);
        end;
    end;

    procedure ReopenMemberApplication(var MemberApplication: Record "Member Application")
    begin
        with MemberApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectMemberApplication(var MemberApplication: Record "Member Application")
    begin
        with MemberApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, MemberApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, MemberApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseMemberApplication(var MemberApplication: Record "Member Application")
    begin
    end;



    procedure PerformCheckAndReleaseAccountOpening(var AccountOpening: Record "Account Opening")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with AccountOpening do begin
            // If ApprovalsMgmt.IsAccountOpeningApprovalsWorkflowEnabled(AccountOpening) AND
            //  (AccountOpening.Status = AccountOpening.Status::New) then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;
            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, AccountOpening.TABLECAPTION, "No.");
            end;
            OnAfterReleaseAccountOpening(AccountOpening);
            FOSAManagement.CreateAccount(AccountOpening);

            AccountType.Get("Account Type");
            if ((AccountType.Type = AccountType.Type::"Fixed Deposit") or (AccountType.Type = AccountType.Type::"Call Deposit")) then
                FOSAManagement.CreateFixedCallDepositSummary(AccountOpening);
        end;
    end;

    procedure ReopenAccountOpening(var AccountOpening: Record "Account Opening")
    begin
        with AccountOpening do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectAccountOpening(var AccountOpening: Record "Account Opening")
    begin
        with AccountOpening do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, AccountOpening.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, AccountOpening.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseAccountOpening(var AccountOpening: Record "Account Opening")
    begin
    end;



    procedure PerformCheckAndReleaseMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        Member: Record Member;
    begin
        with MemberActivationHeader do begin
            //If ApprovalsMgmt.IsMemberActivationDeactivationApprovalsWorkflowEnabled(MemberActivationHeader) AND
            //(MemberActivationHeader.Status = MemberActivationHeader.Status::"Pending Approval") then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, MemberActivationHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseMemberActivationDeactivation(MemberActivationHeader);
            FOSAManagement.ActivateMember(MemberActivationHeader);
            if MemberActivationHeader."Activation Type" = MemberActivationHeader."Activation Type"::Reinstatement then begin
                Member.Get("Member No.");
                FOSAManagement.CapitalizeRegistrationFee(Member);
            end;
        end;
    end;

    procedure ReopenMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
        with MemberActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
        with MemberActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, MemberActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, MemberActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
    end;

    procedure PerformCheckAndReleaseMobileBankingApplication(var MobileBankingApplication: Record "Mobile Banking Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with MobileBankingApplication do begin
            //If ApprovalsMgmt.IsMobileBankingApplicationApprovalsWorkflowEnabled(MobileBankingApplication) AND
            //  (MobileBankingApplication.Status = MobileBankingApplication.Status::"Pending Approval") then
            //   ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, MobileBankingApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseMobileBankingApplication(MobileBankingApplication);
            FOSAManagement.CreateMobileBankingMember(MobileBankingApplication);
        end;
    end;

    procedure ReopenMobileBankingApplication(var MobileBankingApplication: Record "Mobile Banking Application")
    begin
        with MobileBankingApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectMobileBankingApplication(var MobileBankingApplication: Record "Mobile Banking Application")
    begin
        with MobileBankingApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, MobileBankingApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, MobileBankingApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseMobileBankingApplication(var MobileBankingApplication: Record "Mobile Banking Application")
    begin
    end;



    procedure PerformCheckAndReleaseMobileBankingActivationDeactivation(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        MobileBankingMemb: Record "Mobile Banking Member";
    begin
        with MobileBankingActivationHeader do begin
            //If ApprovalsMgmt.IsMobileBankingActivationDeactivationApprovalsWorkflowEnabled(MobileBankingActivationHeader) AND
            //(MobileBankingActivationHeader.Status = MobileBankingActivationHeader.Status::"Pending Approval") then
            // ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, MobileBankingActivationHeader.TABLECAPTION, "No.");
            end;
            If MobileBankingActivationHeader."Application Option" = MobileBankingActivationHeader."Application Option"::Activation then begin
                MobileBankingMemb.Get(MobileBankingActivationHeader."Phone No.");
                MobileBankingMemb.Status := MobileBankingMemb.Status::Active;
                MobileBankingMemb.Modify();

                MobileBankingMemb.Reset();
                MobileBankingMemb.SetRange("Member No.", MobileBankingActivationHeader."Member No.");
                MobileBankingMemb.SetFilter("Phone No.", '<>%1', MobileBankingActivationHeader."Phone No.");
                If MobileBankingMemb.FindSet() then begin
                    repeat
                        MobileBankingMemb.Status := MobileBankingMemb.Status::Inactive;
                        MobileBankingMemb.Modify();
                    until MobileBankingMemb.Next = 0;
                end;

            end else begin
                MobileBankingMemb.Get(MobileBankingActivationHeader."Phone No.");
                MobileBankingMemb.Status := MobileBankingMemb.Status::Inactive;
                MobileBankingMemb.Modify();
            end;
            OnAfterReleaseMobileBankingActivationDeactivation(MobileBankingActivationHeader);
        end;
    end;

    procedure ReopenMobileBankingActivationDeactivation(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header")
    begin
        with MobileBankingActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectMobileBankingActivationDeactivation(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header")
    begin
        with MobileBankingActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, MobileBankingActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, MobileBankingActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseMobileBankingActivationDeactivation(var MobileBankingActivationHeader: Record "Mobile Banking Activ. Header")
    begin
    end;

    procedure PerformCheckAndReleaseATMApplication(var ATMApplication: Record "ATM Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ATMApplication do begin
            //If ApprovalsMgmt.IsATMApplicationApprovalsWorkflowEnabled(ATMApplication) AND
            // (ATMApplication.Status = ATMApplication.Status::"Pending Approval") then
            //    ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ATMApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseATMApplication(ATMApplication);
        end;
    end;

    procedure ReopenATMApplication(var ATMApplication: Record "ATM Application")
    begin
        with ATMApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectATMApplication(var ATMApplication: Record "ATM Application")
    begin
        with ATMApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ATMApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ATMApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATMApplication(var ATMApplication: Record "ATM Application")
    begin
    end;

    procedure PerformCheckAndReleaseATMCollection(var ATMCollection: Record "ATM Collection")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ATMCollection do begin
            //If ApprovalsMgmt.IsATMCollectionApprovalsWorkflowEnabled(ATMCollection) AND
            // (ATMCollection.Status = ATMCollection.Status::"Pending Approval") then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ATMCollection.TABLECAPTION, "No.");
            end;
            OnAfterReleaseATMCollection(ATMCollection);
            FOSAManagement.CreateATMMember(ATMCollection);
        end;
    end;

    procedure ReopenATMCollection(var ATMCollection: Record "ATM Collection")
    begin
        with ATMCollection do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectATMCollection(var ATMCollection: Record "ATM Collection")
    begin
        with ATMCollection do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ATMCollection.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ATMCollection.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATMCollection(var ATMCollection: Record "ATM Collection")
    begin
    end;




    procedure PerformCheckAndReleaseATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ATMActivationHeader do begin
            // If ApprovalsMgmt.IsATMActivationDeactivationApprovalsWorkflowEnabled(ATMActivationHeader) AND
            // (ATMActivationHeader.Status = ATMActivationHeader.Status::"Pending Approval") then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ATMActivationHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseATMActivationDeactivation(ATMActivationHeader);
        end;
    end;

    procedure ReopenATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        with ATMActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        with ATMActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ATMActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ATMActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
    end;

    procedure PerformCheckAndReleaseChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ChequeBookApplication do begin
            //If ApprovalsMgmt.IsChequeBookApplicationApprovalsWorkflowEnabled(ChequeBookApplication) AND
            //  (ChequeBookApplication.Status = ChequeBookApplication.Status::"Pending Approval") then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ChequeBookApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseChequeBookApplication(ChequeBookApplication);
            FOSAManagement.FlagChequeBook(ChequeBookApplication);
            FOSAManagement.PostChequeBook(ChequeBookApplication);
        end;
    end;

    procedure ReopenChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        with ChequeBookApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        with ChequeBookApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ChequeBookApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ChequeBookApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
    end;


    procedure PerformCheckAndReleaseChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ChequeClearanceHeader do begin
            //If ApprovalsMgmt.IsChequeClearanceApprovalsWorkflowEnabled(ChequeClearanceHeader) AND
            //  (ChequeClearanceHeader.Status = ChequeClearanceHeader.Status::"Pending Approval") then
            //   ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ChequeClearanceHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseChequeClearance(ChequeClearanceHeader);
            FOSAManagement.PostChequeClearance(ChequeClearanceHeader);
        end;
    end;

    procedure ReopenChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        with ChequeClearanceHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        with ChequeClearanceHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ChequeClearanceHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ChequeClearanceHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
    end;

    procedure PerformCheckAndReleaseAgentApplication(var AgentApplication: Record "Agent Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with AgentApplication do begin
            // If ApprovalsMgmt.IsAgentApplicationWorkflowEnabled(AgentApplication) AND
            //  (AgentApplication.Status = AgentApplication.Status::"Pending Approval") then
            //   ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, AgentApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseAgentApplication(AgentApplication);
            FOSAManagement.CreateAgent(AgentApplication);
        end;
    end;

    procedure ReopenAgentApplication(var AgentApplication: Record "Agent Application")
    begin
        with AgentApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectAgentApplication(var AgentApplication: Record "Agent Application")
    begin
        with AgentApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, AgentApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, AgentApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseAgentApplication(var AgentApplication: Record "Agent Application")
    begin
    end;



    procedure PerformCheckAndReleaseTellerTransaction(var TellerTransactionHeader: Record "Teller Transaction Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with TellerTransactionHeader do begin
            // If ApprovalsMgmt.IsTellerTransactionWorkflowEnabled(TellerTransactionHeader) AND
            //   (TellerTransactionHeader.Status = TellerTransactionHeader.Status::"Pending Approval") then
            //   ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, TellerTransactionHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseTellerTransaction(TellerTransactionHeader);
        end;
    end;

    procedure ReopenTellerTransaction(var TellerTransactionHeader: Record "Teller Transaction Header")
    begin
        with TellerTransactionHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectTellerTransaction(var TellerTransactionHeader: Record "Teller Transaction Header")
    begin
        with TellerTransactionHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, TellerTransactionHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, TellerTransactionHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseTellerTransaction(var TellerTransactionHeader: Record "Teller Transaction Header")
    begin
    end;

    procedure PerformCheckAndReleaseTreasuryTransaction(var TreasuryTransactionHeader: Record "Treasury Transaction Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with TreasuryTransactionHeader do begin
            // If ApprovalsMgmt.IsTreasuryTransactionWorkflowEnabled(TreasuryTransactionHeader) AND
            //  (TreasuryTransactionHeader.Status = TreasuryTransactionHeader.Status::"Pending Approval") then
            //    ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, TreasuryTransactionHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseTreasuryTransaction(TreasuryTransactionHeader);
        end;
    end;

    procedure ReopenTreasuryTransaction(var TreasuryTransactionHeader: Record "Treasury Transaction Header")
    begin
        with TreasuryTransactionHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectTreasuryTransaction(var TreasuryTransactionHeader: Record "Treasury Transaction Header")
    begin
        with TreasuryTransactionHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, TreasuryTransactionHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, TreasuryTransactionHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseTreasuryTransaction(var TreasuryTransactionHeader: Record "Treasury Transaction Header")
    begin
    end;

    procedure PerformCheckAndReleaseTellerCloseTill(var TellerCloseTill: Record "Teller Close Till")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with TellerCloseTill do begin
            // If ApprovalsMgmt.IsTellerCloseTillWorkflowEnabled(TellerCloseTill) AND
            //   (TellerCloseTill.Status = TellerCloseTill.Status::"Pending Approval") then
            //    ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, TellerCloseTill.TABLECAPTION, "No.");
            end;
            OnAfterReleaseTellerCloseTill(TellerCloseTill);
        end;
    end;

    procedure ReopenTellerCloseTill(var TellerCloseTill: Record "Teller Close Till")
    begin
        with TellerCloseTill do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectTellerCloseTill(var TellerCloseTill: Record "Teller Close Till")
    begin
        with TellerCloseTill do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, TellerCloseTill.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, TellerCloseTill.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseTellerCloseTill(var TellerCloseTill: Record "Teller Close Till")
    begin
    end;

    procedure PerformCheckAndReleaseTellerReturnTreasury(var TellerReturnTreasury: Record "Teller Return Treasury")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with TellerReturnTreasury do begin
            // If ApprovalsMgmt.IsTellerReturnTreasuryWorkflowEnabled(TellerReturnTreasury) AND
            // (TellerReturnTreasury.Status = TellerReturnTreasury.Status::"Pending Approval") then
            // ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, TellerReturnTreasury.TABLECAPTION, "No.");
            end;
            OnAfterReleaseTellerReturnTreasury(TellerReturnTreasury);
        end;
    end;

    procedure ReopenTellerReturnTreasury(var TellerReturnTreasury: Record "Teller Return Treasury")
    begin
        with TellerReturnTreasury do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectTellerReturnTreasury(var TellerReturnTreasury: Record "Teller Return Treasury")
    begin
        with TellerReturnTreasury do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, TellerReturnTreasury.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, TellerReturnTreasury.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseTellerReturnTreasury(var TellerReturnTreasury: Record "Teller Return Treasury")
    begin
    end;

    procedure PerformCheckAndReleaseTreasuryReturnBank(var TreasuryReturnBank: Record "Treasury Return Bank Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with TreasuryReturnBank do begin
            //If ApprovalsMgmt.IsTreasuryReturnBankWorkflowEnabled(TreasuryReturnBank) AND
            // (TreasuryReturnBank.Status = TreasuryReturnBank.Status::"Pending Approval") then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, TreasuryReturnBank.TABLECAPTION, "No.");
            end;
            OnAfterReleaseTreasuryReturnBank(TreasuryReturnBank);
        end;
    end;

    procedure ReopenTreasuryReturnBank(var TreasuryReturnBank: Record "Treasury Return Bank Header")
    begin
        with TreasuryReturnBank do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectTreasuryReturnBank(var TreasuryReturnBank: Record "Treasury Return Bank Header")
    begin
        with TreasuryReturnBank do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, TreasuryReturnBank.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, TreasuryReturnBank.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseTreasuryReturnBank(var TreasuryReturnBank: Record "Treasury Return Bank Header")
    begin
    end;

    procedure PerformCheckAndReleaseInterTellerTransfer(var InterTellerTransferHeader: Record "InterTeller Transfer Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with InterTellerTransferHeader do begin
            //If ApprovalsMgmt.IsInterTellerTransferWorkflowEnabled(InterTellerTransferHeader) AND
            //(InterTellerTransferHeader.Status = InterTellerTransferHeader.Status::New) then
            // ERROR(Text002);
            If Status = Status::Approved then
                exit;
            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, InterTellerTransferHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseInterTellerTransfer(InterTellerTransferHeader);

        end;
    end;

    procedure ReopenInterTellerTransfer(var InterTellerTransferHeader: Record "InterTeller Transfer Header")
    begin
        with InterTellerTransferHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectInterTellerTransfer(var InterTellerTransferHeader: Record "InterTeller Transfer Header")
    begin
        with InterTellerTransferHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, InterTellerTransferHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, InterTellerTransferHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseInterTellerTransfer(var InterTellerTransferHeader: Record "InterTeller Transfer Header")
    begin
    end;

    procedure PerformCheckAndReleaseInterTreasuryTransfer(var InterTreasuryTransferHeader: Record "InterTreasury Transfer Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with InterTreasuryTransferHeader do begin
            // If ApprovalsMgmt.IsInterTreasuryTransferWorkflowEnabled(InterTreasuryTransferHeader) AND
            // (InterTreasuryTransferHeader.Status = InterTreasuryTransferHeader.Status::New) then
            //  ERROR(Text002);
            If Status = Status::Approved then
                exit;
            If (Status = Status::New) or (Status = Status::"Pending Approval") then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, InterTreasuryTransferHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseInterTreasuryTransfer(InterTreasuryTransferHeader);

        end;
    end;

    procedure ReopenInterTreasuryTransfer(var InterTreasuryTransferHeader: Record "InterTreasury Transfer Header")
    begin
        with InterTreasuryTransferHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectInterTreasuryTransfer(var InterTreasuryTransferHeader: Record "InterTreasury Transfer Header")
    begin
        with InterTreasuryTransferHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, InterTreasuryTransferHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, InterTreasuryTransferHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseInterTreasuryTransfer(var InterTreasuryTransferHeader: Record "InterTreasury Transfer Header")
    begin
    end;



    var

        FOSAManagement: Codeunit "FOSA Management";
        SMTPMailSetup: Record "SMTP Mail Setup";
        GlobalManagement: Codeunit "Global Management";
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
}

