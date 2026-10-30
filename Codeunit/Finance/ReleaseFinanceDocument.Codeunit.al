codeunit 50041 "Release Finance Document"
{
    // version TL2.0


    trigger OnRun()
    begin

    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext-Finance";
        RejectAction: Text[50];
        SelectedAction: Integer;
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        Text005: Label '%1 %2 has been approved successfully.';
        Text006: Label '%1 %2 has been rejected sucessfully.';
        Text007: Label 'Reset to New Stage,Reject Completely';
        Text008: Label 'Choose Reject Action';
        Text009: Label '%1 %2 has been reset to New Stage.';





    procedure PerformCheckAndReleasePaymentVoucher(var PaymentHeader: Record "Payment Header")
    var

        ApprovalEntry: Record "Approval Entry";
    begin
        WITH PaymentHeader DO BEGIN
            IF ApprovalsMgmt.IsPaymentVoucherApprovalsWorkflowEnabled(PaymentHeader) AND
              (PaymentHeader.Status = PaymentHeader.Status::New) THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text005, 'Payment Voucher', "No.");
                END;
            END;

        END;
    end;


    procedure ReopenPaymentVoucher(var PaymentHeader: Record "Payment Header")
    begin
        WITH PaymentHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectPaymentVoucher(var PaymentHeader: Record "Payment Header")
    begin
        WITH PaymentHeader DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, 'Payment Voucher', "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, 'Payment Voucher', "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleasePaymentVoucher(var PaymentHeader: Record "Payment Header")
    begin
    end;

    procedure PerformCheckAndReleasePettyCashVoucher(var PettyCashHeader: Record "PettyCash Header")
    var

        ApprovalEntry: Record "Approval Entry";
    begin
        WITH PettyCashHeader DO BEGIN
            IF ApprovalsMgmt.IsPettyCashVoucherApprovalsWorkflowEnabled(PettyCashHeader) AND
              (PettyCashHeader.Status = PettyCashHeader.Status::New) THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text005, 'PettyCash Voucher', "No.");
                END;
            END;

        END;
    end;


    procedure ReopenPettyCashVoucher(var PettyCashHeader: Record "PettyCash Header")
    begin
        WITH PettyCashHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectPettyCashVoucher(var PettyCashHeader: Record "PettyCash Header")
    begin
        WITH PettyCashHeader DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, 'PettyCash Voucher', "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, 'PettyCash Voucher', "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleasePettyCashVoucher(var PettyCashHeader: Record "PettyCash Header")
    begin
    end;



}

