codeunit 50008 "Release BOSA Document"
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
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        Member: Record "Member";
        GlobalSetup: Record "Global Setup";
        Vendor: Record "Vendor";
        AccountType: Record "Account Type";
        Customer: Record "Customer";

        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        Text005: Label '%1 %2 has been approved successfully.';
        Text006: Label '%1 %2 has been rejected sucessfully.';
        Text007: Label 'Reset to New Stage,Reject Completely';
        Text008: Label 'Choose Reject Action';
        Text009: Label '%1 %2 has been reset to New Stage.';
        RejectAction: Text[50];
        SelectedAction: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        SourceCodeSetup: Record "Source Code Setup";




    procedure PerformCheckAndReleaseLoanApplication(var LoanApplication: Record "Loan Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        WITH LoanApplication DO BEGIN
            If Consolidation = false then begin
                Validate("Approved Amount", "Requested Amount");
                if Remarks = '' then
                    Validate(Remarks, 'Approved');
                TestField("Approved Amount");
                TestField(Remarks);
            end else begin
                CalcFields("Total Consolidated Amount");
                Validate("Requested Amount", "Total Consolidated Amount");
                Validate("Approved Amount", "Total Consolidated Amount");
                if Remarks = '' then
                    Validate(Remarks, 'Approved');
                TestField("Approved Amount");
                TestField(Remarks);
            end;
            //IF LoanApplication.Status <> LoanApplication.Status::"Pending Approval" THEN
            // ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(LoanApplication);
                    GlobalManagement.UpdateAuditInfo(RecRef);
                    BOSAManagement.SendNotification(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenLoanApplication(var LoanApplication: Record "Loan Application")
    begin
        WITH LoanApplication DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanApplication(var LoanApplication: Record "Loan Application")
    var
        RecRef: RecordRef;
    begin
        WITH LoanApplication DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, 'Loan Application', "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, 'Loan Application', "No.");
                    END;
            END;
            RecRef.GetTable(LoanApplication);
            BOSAManagement.SendNotification(RecRef);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseLoanApplication(var LoanApplication: Record "Loan Application")
    begin
    end;


    procedure PerformCheckAndReleaseStandingOrder(var StandingOrder: Record "Standing Order")
    var

        ApprovalEntry: Record "Approval Entry";
    begin
        WITH StandingOrder DO BEGIN
            //IF ApprovalsMgmt.IsStandingOrderApprovalsWorkflowEnabled(StandingOrder) AND
            // (StandingOrder.Status = StandingOrder.Status::New) THEN
            // ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;
            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                Running := TRUE;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text005, 'Standing Order', "No.");
                END;
            END;

        END;
    end;


    procedure ReopenStandingOrder(var StandingOrder: Record "Standing Order")
    begin
        WITH StandingOrder DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectStandingOrder(var StandingOrder: Record "Standing Order")
    begin
        WITH StandingOrder DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, 'Standing Order', "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, 'Standing Order', "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseStandingOrder(var StandingOrder: Record "Standing Order")
    begin
    end;


    procedure PerformCheckAndReleaseFundTransfer(var FundTransfer: Record "Fund Transfer")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
    begin
        WITH FundTransfer DO BEGIN
            //IF ApprovalsMgmt.IsFundTransferApprovalsWorkflowEnabled(FundTransfer) AND
            //(FundTransfer.Status = FundTransfer.Status::"Pending Approval") THEN
            //ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, FundTransfer.TABLECAPTION, "No.");
            END;
            OnAfterReleaseFundTransfer(FundTransfer);
        END;
    end;


    procedure ReopenFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
        WITH FundTransfer DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
        WITH FundTransfer DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, FundTransfer.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, FundTransfer.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
    end;


    procedure PerformCheckAndReleaseLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        RecRef: RecordRef;
    begin
        WITH LoanRescheduling DO BEGIN
            //IF ApprovalsMgmt.IsLoanReschedulingApprovalsWorkflowEnabled(LoanRescheduling) AND
            // (LoanRescheduling.Status = LoanRescheduling.Status::"Pending Approval") THEN
            //   ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, LoanRescheduling.TABLECAPTION, "No.");
            END;
            OnAfterReleaseLoanRescheduling(LoanRescheduling);
            LoanReschedulingSetup.Get();
            if LoanReschedulingSetup."Rescheduling Method" = LoanReschedulingSetup."Rescheduling Method"::"Change Existing Loan" then begin
                ApplyNewLoanValues(LoanRescheduling);
                RecreateRepaymentSchedule(LoanRescheduling);
            end else
                if LoanReschedulingSetup."Rescheduling Method" = LoanReschedulingSetup."Rescheduling Method"::"Create New Loan" then begin
                    CreatePostNewLoan(LoanRescheduling);
                end;
            RecRef.GetTable(LoanRescheduling);
            BOSAManagement.SendNotification(RecRef);

        END;
    end;


    procedure ReopenLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WITH LoanRescheduling DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    var
        RecRef: RecordRef;
    begin
        WITH LoanRescheduling DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, LoanRescheduling.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        RecRef.GetTable(LoanRescheduling);
                        BOSAManagement.SendNotification(RecRef);
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, LoanRescheduling.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    begin
    end;


    //------------------------------------------------------------------------------------------------------------------
    procedure PerformCheckAndReleaseLoanRestructuring(var LoanRestructuring: Record "Loan Restructuring")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        LoanRestructuringSetup: Record "Loan Restructuring Setup";
        RecRef: RecordRef;
    begin
        WITH LoanRestructuring DO BEGIN
            /* IF ApprovalsMgmt.IsLoanRestructuringApprovalsWorkflowEnabled(LoanRestructuring) AND
               (LoanRestructuring.Status = LoanRestructuring.Status::"Pending Approval") THEN
                 ERROR(Text002);*/
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, LoanRestructuring.TABLECAPTION, "No.");
            END;
            OnAfterReleaseLoanRestructuring(LoanRestructuring);
            LoanRestructuringSetup.Get();
            if LoanRestructuringSetup."Restructuring Method" = LoanRestructuringSetup."Restructuring Method"::"Change Existing Loan" then begin
                ApplyNewLoanValuesRestr(LoanRestructuring);
                RecreateRepaymentScheduleRestr(LoanRestructuring);
            end else
                if LoanRestructuringSetup."Restructuring Method" = LoanRestructuringSetup."Restructuring Method"::"Create New Loan" then begin
                    //CreatePostNewLoan(LoanRestructuringSetup);
                end;
            RecRef.GetTable(LoanRestructuring);
            BOSAManagement.SendNotification(RecRef);

        END;
    end;


    procedure ReopenLoanRestructuring(var LoanRestructuring: Record "Loan Restructuring")
    begin
        WITH LoanRestructuring DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanRestructuring(var LoanRestructuring: Record "Loan Restructuring")
    var
        RecRef: RecordRef;
    begin
        WITH LoanRestructuring DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, LoanRestructuring.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        RecRef.GetTable(LoanRestructuring);
                        BOSAManagement.SendNotification(RecRef);
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, LoanRestructuring.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseLoanRestructuring(var LoanRestructuring: Record "Loan Restructuring")
    begin
    end;

    local procedure ApplyNewLoanValuesRestr(LoanRestructuring: Record "Loan Restructuring")
    var
        LoanApplication: Record "Loan Application";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        Lprod: Record "Loan Product Type";
        LoanApplication2: Record "Loan Application";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanChargeSetup: Record "Loan Charge Setup";
        TotalCharges: Decimal;
        HostName: Code[20];
        HostIP: Code[20];
        TransactionTypeCode: code[20];
        HostMac: Code[20];
        StartDate: date;
        Installments: Integer;
        BosaM: Codeunit "BOSA Management";
        ProdCharge: decimal;
        LoanProductCharge: Record "Loan Product Charge";
    begin
        WITH LoanRestructuring DO BEGIN
            IF LoanApplication.GET("Loan No.") THEN BEGIN
                Lprod.Get(LoanApplication."Loan Product Type");
                IF ("Restructuring Type" = "Restructuring Type"::"Repayment Period") THEN
                    LoanApplication."Repayment Period" := "New Repayment Period";
                IF ("Restructuring Type" = "Restructuring Type"::"Repayment Frequency") THEN
                    LoanApplication."Repayment Frequency" := "New Repayment Frequency";
                IF ("Restructuring Type" = "Restructuring Type"::"Interest Rate") THEN
                    LoanApplication."Interest Rate" := "New Interest Rate";

                LoanApplication."Economic Sector" := '0000';
                LoanApplication."Economic Sector Category" := '0000';
                LoanApplication."Economic Sector Sub-Category" := '0000';
                LoanApplication."Disbursal Date" := Today;
                LoanApplication."Next Due Date" := CalcDate('1M', Today);
                LoanApplication."Date of Completion" := CalcDate("New Repayment Period", Today);
                LoanApplication."Requested Amount" := "Outstanding Loan Balance";
                LoanApplication."Approved Amount" := "Outstanding Loan Balance";
                LoanApplication."Loan Restructured" := true;
                LoanApplication.Description := 'Restructured' + ' ' + Lprod.Description;
                LoanApplication.MODIFY;

                LoanReschedulingSetup.Get();
                SourceCodeSetup.Get();
                GlobalSetup.Get();
                TransactionTypeCodeSetup.Get();

                LoanReschedulingSetup.TestField("Loan Resch. Template Name");
                LoanReschedulingSetup.TestField("Loan Resch. Batch Name");

                JournalTemplateName := LoanReschedulingSetup."Loan Resch. Template Name";
                JournalBatchName := LoanReschedulingSetup."Loan Resch. Batch Name";
                GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
                GlobalManagement.DeductLoanArrearsRestructuring(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", "Loan No.", "Outstanding Loan Balance", LoanApplication2."Global Dimension 1 Code");
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", AccountTypeEnum::Customer, "Loan No.", Description + ' -' + 'Loan Restructure',
                "Outstanding Loan Balance", '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, LoanApplication2."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication2."Member No.");

                GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName);
            END;
        END;
    end;

    procedure ApplyNewLoanValuesRestrApproved(LoanRestructuring: Record "Loan Restructuring")
    var
        LoanApplication: Record "Loan Application";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        Lprod: Record "Loan Product Type";
        LoanApplication2: Record "Loan Application";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanChargeSetup: Record "Loan Charge Setup";
        TotalCharges: Decimal;
        HostName: Code[20];
        HostIP: Code[20];
        TransactionTypeCode: code[20];
        HostMac: Code[20];
        StartDate: date;
        Installments: Integer;
        BosaM: Codeunit "BOSA Management";
        ProdCharge: decimal;
        LoanProductCharge: Record "Loan Product Charge";
    begin
        WITH LoanRestructuring DO BEGIN
            IF LoanApplication.GET("Loan No.") THEN BEGIN
                Lprod.Get(LoanApplication."Loan Product Type");

                LoanReschedulingSetup.Get();
                SourceCodeSetup.Get();
                GlobalSetup.Get();
                TransactionTypeCodeSetup.Get();

                LoanReschedulingSetup.TestField("Loan Resch. Template Name");
                LoanReschedulingSetup.TestField("Loan Resch. Batch Name");

                JournalTemplateName := LoanReschedulingSetup."Loan Resch. Template Name";
                JournalBatchName := LoanReschedulingSetup."Loan Resch. Batch Name";
                GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
                GlobalManagement.DeductLoanArrearsRestructuring(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", "Loan No.", "Outstanding Loan Balance", LoanApplication2."Global Dimension 1 Code");
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", AccountTypeEnum::Customer, "Loan No.", Description + ' -' + 'Loan Restructure',
                "Outstanding Loan Balance", '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, LoanApplication2."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication2."Member No.");

                GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName);
            END;
        END;
    end;

    local procedure RecreateRepaymentScheduleRestr(var LoanRestructuring: Record "Loan Restructuring")
    begin
        WITH LoanRestructuring DO BEGIN
            BOSAManagement.CreateRepaymentScheduleRestructure("Loan No.", "Outstanding Loan Balance");
        END;
    end;
    //------------------------------------------------------------------------------------------------------------------
    local procedure ApplyNewLoanValues(LoanRescheduling: Record "Loan Rescheduling")
    var
        LoanApplication: Record "Loan Application";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        Lprod: Record "Loan Product Type";
    begin
        WITH LoanRescheduling DO BEGIN
            IF LoanApplication.GET("Loan No.") THEN BEGIN
                Lprod.Get(LoanApplication."Loan Product Type");
                IF ("Rescheduling Type" = "Rescheduling Type"::"Repayment Period") THEN
                    LoanApplication."Repayment Period" := "New Repayment Period";
                IF ("Rescheduling Type" = "Rescheduling Type"::"Repayment Frequency") THEN
                    LoanApplication."Repayment Frequency" := "New Repayment Frequency";
                IF ("Rescheduling Type" = "Rescheduling Type"::"Interest Rate") THEN
                    LoanApplication."Interest Rate" := "New Interest Rate";
                LoanApplication."Next Due Date" := Today;
                LoanApplication."Date of Completion" := CalcDate("New Repayment Period", Today);
                LoanApplication."Requested Amount" := "Outstanding Loan Balance";
                LoanApplication."Approved Amount" := "Outstanding Loan Balance";
                LoanApplication."Loan Rescheduled" := true;
                LoanApplication.Description := 'Rescheduled' + ' ' + Lprod.Description;
                LoanApplication.MODIFY;
            END;
        END;
    end;

    local procedure RecreateRepaymentSchedule(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WITH LoanRescheduling DO BEGIN
            BOSAManagement.CreateRepaymentSchedule("Loan No.", "Outstanding Loan Balance");
        END;
    end;

    local procedure CreatePostNewLoan(var LoanRescheduling: Record "Loan Rescheduling")
    var
        LoanApplication: Record "Loan Application";
        LoanApplication2: Record "Loan Application";
        Lprod: Record "Loan Product Type";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanChargeSetup: Record "Loan Charge Setup";
        TotalCharges: Decimal;
        HostName: Code[20];
        HostIP: Code[20];
        TransactionTypeCode: code[20];
        HostMac: Code[20];
        StartDate: date;
        Installments: Integer;
        BosaM: Codeunit "BOSA Management";
        ProdCharge: decimal;
        LoanProductCharge: Record "Loan Product Charge";
    begin
        with LoanRescheduling do begin
            TestField("Member No.");
            TestField("Loan No.");

            LoanApplication.Get("Loan No.");
            LoanApplication2.Init();
            LoanApplication2.TransferFields(LoanApplication);
            LoanApplication2."No." := '';
            LoanApplication2."Member Category" := LoanApplication2."Member Category"::Member;
            LoanApplication2.Validate("Member No.");
            LoanApplication2.Validate("Loan Product Type");
            LoanApplication2."Requested Amount" := "Outstanding Loan Balance";
            LoanApplication2."Approved Amount" := "Outstanding Loan Balance";
            LoanApplication2."Next Due Date" := CalcDate('1M', Today);
            LoanApplication2."Date of Completion" := CalcDate("New Repayment Period", CalcDate('1M', Today));
            LoanApplication2."Disbursal Date" := Today;
            LoanApplication2."Disbursed By" := UserId;
            LoanApplication2."Disbursal Time" := Time;
            LoanApplication2.Remarks := LoanRescheduling.Remarks;
            LoanApplication2."Loan Rescheduled" := true;
            LoanApplication2.Description := 'Rescheduled' + ' ' + LoanApplication2.Description;
            LoanApplication2."Date of Completion" := CalcDate(LoanRescheduling."New Repayment Period", Today);

            if "Rescheduling Type" = "Rescheduling Type"::"Interest Rate" then
                LoanApplication2."Interest Rate" := "New Interest Rate"
            else
                if "Rescheduling Type" = "Rescheduling Type"::"Repayment Period" then
                    LoanApplication2.Validate("Repayment Period", "New Repayment Period")
                else
                    if "Rescheduling Type" = "Rescheduling Type"::"Repayment Frequency" then
                        LoanApplication2.Validate("Repayment Frequency", "New Repayment Frequency");
            LoanApplication2.Insert(true);
            BOSAManagement.CreateLoanAccount(LoanApplication2);
            LoanApplication2."Date of Completion" := CalcDate("New Repayment Period", CalcDate('1M', Today));
            LoanApplication2.Modify();

            LoanReschedulingSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();

            LoanReschedulingSetup.TestField("Loan Resch. Template Name");
            LoanReschedulingSetup.TestField("Loan Resch. Batch Name");

            JournalTemplateName := LoanReschedulingSetup."Loan Resch. Template Name";
            JournalBatchName := LoanReschedulingSetup."Loan Resch. Batch Name";
            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);

            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", AccountTypeEnum::Customer, LoanApplication2."No.", Description + ' -' + 'Loan Reschedule',
            "Outstanding Loan Balance", '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, LoanApplication2."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication2."Member No.");

            //---------Cahrge Insurance Fee
            LoanProductCharge.RESET;
            LoanProductCharge.SETRANGE("Loan Product Type", LoanApplication2."Loan Product Type");
            IF LoanProductCharge.FINDSET THEN BEGIN
                REPEAT
                    LoanChargeSetup.Get(LoanProductCharge.Code);
                    LoanChargeSetup.TestField("Income G/L Account");
                    ProdCharge := 0;

                    if LoanChargeSetup.Type = LoanChargeSetup.Type::"Insurance Fee" then
                        TransactionTypeCode := TransactionTypeCodeSetup."Insurance Fee";

                    IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" THEN BEGIN
                        if LoanChargeSetup.Type = LoanChargeSetup.Type::"Insurance Fee" then begin
                            ProdCharge := ((LoanProductCharge.Value * "Outstanding Loan Balance" * Installments) / 1200);

                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", AccountTypeEnum::"G/L Account", LoanChargeSetup."Income G/L Account", LoanProductCharge.Description,
                            -ProdCharge, '', TransactionTypeCode, SourceCodeSetup.Loan, LoanApplication2."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication2."Member No.");
                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", AccountTypeEnum::Customer, LoanApplication2."No.", LoanProductCharge.Description,
                            ProdCharge, '', '', SourceCodeSetup.Loan, LoanApplication2."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication2."Member No.");
                        end;
                    End;
                until LoanProductCharge.Next = 0;
            end;

            //------Clear Old Loan
            GlobalManagement.DeductLoanArrearsRescheduling(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", "Loan No.", "Outstanding Loan Balance", LoanApplication2."Global Dimension 1 Code");


            // GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Approved Date", AccountTypeEnum::Customer, "Loan No.", Description,
            //-"Outstanding Loan Balance", '', '', SourceCodeSetup.Loan, LoanApplication2."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
            if GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
            end;
            BOSAManagement.CreateRepaymentSchedule(LoanApplication2."No.", LoanApplication2."Approved Amount");
        end;
    end;

    procedure PerformCheckAndReleaseGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    var
        RecRef: RecordRef;
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            // IF ApprovalsMgmt.IsGuarantorSubstitutionApprovalsWorkflowEnabled(GuarantorSubstitutionHeader) AND
            // (GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::"Pending Approval") THEN
            // ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, GuarantorSubstitutionHeader.TABLECAPTION, "No.");
            END;
            OnAfterReleaseGuarantorSubstitution(GuarantorSubstitutionHeader);
            SubstituteGuarantors(GuarantorSubstitutionHeader);

            RecRef.GETTABLE(GuarantorSubstitutionHeader);
            BOSAManagement.SendNotification(RecRef);
        END;
    end;


    procedure ReopenGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, GuarantorSubstitutionHeader.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, GuarantorSubstitutionHeader.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
    end;

    local procedure SubstituteGuarantors(GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    var
        GuarantorSubstitutionLine: Record "Guarantor Substitution Line";
        LoanGuarantor: Record "Loan Guarantor";
        LoanGuarantor2: Record "Loan Guarantor";
        GuarantorAllocation: Record "Guarantor Allocation";
        loanCollateral: Record "Loan Collateral";
        collateralAllocation: Record "Loan Collateral Substitution";
        loanCollateral1: Record "Loan Collateral";

        LineNo: Integer;
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            if "Substitution Type" = "Substitution Type"::Guarantor then begin
                GuarantorAllocation.RESET;
                GuarantorAllocation.SETRANGE("Document No.", "No.");
                IF GuarantorAllocation.FINDSET THEN BEGIN
                    REPEAT
                        LoanGuarantor.RESET;
                        LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                        LoanGuarantor.SETRANGE("Member No.", GuarantorAllocation."Guarantor Member No.");
                        IF LoanGuarantor.FINDFIRST THEN
                            LoanGuarantor.DELETE;

                        LoanGuarantor.INIT;
                        LoanGuarantor2.RESET;
                        LoanGuarantor2.SETRANGE("Loan No.", "Loan No.");
                        IF LoanGuarantor2.FINDLAST THEN
                            LineNo := LoanGuarantor2."Line No."
                        ELSE
                            LineNo := 0;
                        LoanGuarantor."Loan No." := "Loan No.";
                        LoanGuarantor."Line No." := LineNo + 10000;
                        LoanGuarantor.VALIDATE("Member No.", GuarantorAllocation."Member No.");
                        LoanGuarantor.VALIDATE("Account No.", GuarantorAllocation."Account No.");
                        LoanGuarantor.Validate("Amount To Guarantee", GuarantorAllocation."Amount To Guarantee");
                        IF LoanGuarantor.INSERT THEN
                            CreateSubstitutionEntry(GuarantorAllocation);
                    UNTIL GuarantorAllocation.NEXT = 0;
                END;
            end;
            if "Substitution Type" = "Substitution Type"::Collateral then begin
                collateralAllocation.RESET;
                collateralAllocation.SETRANGE("Document No.", "No.");
                IF collateralAllocation.FINDSET THEN BEGIN
                    REPEAT
                        LoanGuarantor.RESET;
                        LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                        LoanGuarantor.SETRANGE("Member No.", collateralAllocation."Guarantor Member No");
                        IF LoanGuarantor.FINDFIRST THEN
                            LoanGuarantor.DELETE;

                        loanCollateral.INIT;
                        loanCollateral1.RESET;
                        loanCollateral1.SETRANGE("Loan No.", "Loan No.");
                        IF loanCollateral1.FINDLAST THEN
                            LineNo := loanCollateral1."Line No."
                        ELSE
                            LineNo := 0;
                        loanCollateral."Loan No." := "Loan No.";
                        loanCollateral."Line No." := LineNo + 10000;
                        loanCollateral."Security Type Code" := collateralAllocation."Security Type Code";
                        loanCollateral."Security Value" := collateralAllocation."Security Value";
                        loanCollateral.VALIDATE("Security Type Code");
                        loanCollateral.VALIDATE("Security Value");
                        loanCollateral.Validate("Security Factor");
                        loanCollateral."Guaranteed Amount" := collateralAllocation."Guaranteed Amount";
                        IF loanCollateral.INSERT THEN
                            CreateSubstitutionEntryCollateral(collateralAllocation);
                    UNTIL collateralAllocation.NEXT = 0;
                END;
            end;
        END;
    end;

    local procedure CreateSubstitutionEntry(var GuarantorAllocation: Record "Guarantor Allocation")
    var
        GuarantorSubstitutionEntry: Record "Guarantor Substitution Entry";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        Member: Record "Member";
        EntryNo: Integer;
    begin
        WITH GuarantorAllocation DO BEGIN
            GuarantorSubstitutionHeader.GET("Document No.");
            GuarantorSubstitutionHeader.CALCFIELDS("Guaranteed Amount", "Substituted Amount");
            GuarantorSubstitutionEntry.INIT;
            IF GuarantorSubstitutionEntry.FINDLAST THEN
                EntryNo := GuarantorSubstitutionEntry."Entry No."
            ELSE
                EntryNo := 0;
            GuarantorSubstitutionEntry."Entry No." := EntryNo + 1;
            GuarantorSubstitutionEntry."Document No." := "Document No.";
            GuarantorSubstitutionEntry."Previous Guarantor No." := "Guarantor Member No.";
            IF Member.GET("Guarantor Member No.") THEN
                GuarantorSubstitutionEntry."Previous Guarantor Name" := Member."Full Name";
            GuarantorSubstitutionEntry."New Guarantor No." := "Member No.";
            GuarantorSubstitutionEntry."New Guarantor Name" := "Member Name";
            GuarantorSubstitutionEntry."Security Type" := GuarantorSubstitutionHeader."Substitution Type";
            GuarantorSubstitutionEntry."Loan No." := GuarantorSubstitutionHeader."Loan No.";
            GuarantorSubstitutionEntry.Description := GuarantorSubstitutionHeader.Description;
            GuarantorSubstitutionEntry."Substitution Date" := TODAY;
            GuarantorSubstitutionEntry."Substitution Time" := TIME;
            GuarantorSubstitutionEntry."Previous Amount Guaranteed" := GuarantorSubstitutionHeader."Guaranteed Amount";
            GuarantorSubstitutionEntry."New Amount Guaranteed" := GuarantorSubstitutionHeader."Substituted Amount";
            GuarantorSubstitutionEntry.INSERT;
        END;
    end;

    local procedure CreateSubstitutionEntryCollateral(var collateralAllocation: Record "Loan Collateral Substitution")
    var
        GuarantorSubstitutionEntry: Record "Guarantor Substitution Entry";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        Member: Record "Member";
        EntryNo: Integer;
    begin
        WITH collateralAllocation DO BEGIN
            GuarantorSubstitutionHeader.GET("Document No.");
            GuarantorSubstitutionHeader.CALCFIELDS("Guaranteed Amount", "Substitution Amount Collateral");
            GuarantorSubstitutionEntry.INIT;
            IF GuarantorSubstitutionEntry.FINDLAST THEN
                EntryNo := GuarantorSubstitutionEntry."Entry No."
            ELSE
                EntryNo := 0;
            GuarantorSubstitutionEntry."Entry No." := EntryNo + 1;
            GuarantorSubstitutionEntry."Document No." := "Document No.";
            GuarantorSubstitutionEntry."Previous Guarantor No." := "Guarantor Member No";
            IF Member.GET("Guarantor Member No") THEN
                GuarantorSubstitutionEntry."Previous Guarantor Name" := Member."Full Name";
            GuarantorSubstitutionEntry."New Guarantor No." := "Security Register Code";
            GuarantorSubstitutionEntry."New Guarantor Name" := "Security Type Code";
            GuarantorSubstitutionEntry."Security Type" := GuarantorSubstitutionHeader."Substitution Type";
            GuarantorSubstitutionEntry."Loan No." := GuarantorSubstitutionHeader."Loan No.";
            GuarantorSubstitutionEntry.Description := GuarantorSubstitutionHeader.Description;
            GuarantorSubstitutionEntry."Substitution Date" := TODAY;
            GuarantorSubstitutionEntry."Substitution Time" := TIME;
            GuarantorSubstitutionEntry."Previous Amount Guaranteed" := GuarantorSubstitutionHeader."Guaranteed Amount";
            GuarantorSubstitutionEntry."New Amount Guaranteed" := GuarantorSubstitutionHeader."Substitution Amount Collateral";
            GuarantorSubstitutionEntry.INSERT;
        END;
    end;


    procedure PerformCheckAndReleasePayout(var PayoutHeader: Record "Payout Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH PayoutHeader DO BEGIN
            //IF PayoutHeader.Status <> PayoutHeader.Status::"Pending Approval" THEN
            //ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(PayoutHeader);
                    GlobalManagement.UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenPayout(var PayoutHeader: Record "Payout Header")
    begin
        WITH PayoutHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectPayout(var PayoutHeader: Record "Payout Header")
    begin
        WITH PayoutHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleasePayout(var PayoutHeader: Record "Payout Header")
    begin
    end;


    procedure PerformCheckAndReleaseMemberExit(var MemberExitHeader: Record "Member Exit Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberExitHeader DO BEGIN
            //IF MemberExitHeader.Status <> MemberExitHeader.Status::"Pending Approval" THEN
            //ERROR(Text002);
            //Message('Member Status %1', Status);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseMemberExit(MemberExitHeader);
            BOSAManagement.ProcessMemberExit(MemberExitHeader);
            Message('Member Status %1', Status);
        END;

    end;


    procedure ReopenMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
        WITH MemberExitHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
        WITH MemberExitHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
    end;

    procedure PerformCheckAndReleaseMemberArchive(var MemberArchiveHeader: Record "Member Achive Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberArchiveHeader DO BEGIN
            // IF MemberArchiveHeader.Status <> MemberArchiveHeader.Status::"Pending Approval" THEN
            //  ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseMemberArchive(MemberArchiveHeader);
            //BOSAManagement.ProcessMemberArchive(MemberArchiveHeader);
        END;
    end;


    procedure ReopenMemberArchive(var MemberArchiveHeader: Record "Member Achive Header")
    begin
        WITH MemberArchiveHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberArchive(var MemberArchiveHeader: Record "Member Achive Header")
    begin
        WITH MemberArchiveHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberArchive(var MemberArchiveHeader: Record "Member Achive Header")
    begin
    end;

    procedure PerformCheckAndReleaseMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberRefundHeader DO BEGIN
            //IF MemberRefundHeader.Status <> MemberRefundHeader.Status::"Pending Approval" THEN
            // ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(MemberRefundHeader);
                    GlobalManagement.UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WITH MemberRefundHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WITH MemberRefundHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
    end;


    procedure PerformCheckAndReleaseMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberClaimHeader DO BEGIN
            // IF MemberClaimHeader.Status <> MemberClaimHeader.Status::"Pending Approval" THEN
            //   ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseMemberClaim(MemberClaimHeader);
        END;
    end;


    procedure ReopenMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WITH MemberClaimHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WITH MemberClaimHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
    end;


    procedure PerformCheckAndReleaseDividend(var DividendHeader: Record "Dividend Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH DividendHeader DO BEGIN
            // IF DividendHeader.Status <> DividendHeader.Status::"Pending Approval" THEN
            //  ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(DividendHeader);
                    GlobalManagement.UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenDividend(var DividendHeader: Record "Dividend Header")
    begin
        WITH DividendHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectDividend(var DividendHeader: Record "Dividend Header")
    begin
        WITH DividendHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseDividend(var DividendHeader: Record "Dividend Header")
    begin
    end;

    procedure PerformCheckAndReleaseLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH LoanSelloff DO BEGIN
            // IF LoanSelloff.Status <> LoanSelloff.Status::"Pending Approval" THEN
            //  ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseLoanSelloff(LoanSelloff);
        END;
    end;


    procedure ReopenLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
        WITH LoanSelloff DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
        WITH LoanSelloff DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterReleaseLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
    end;

    procedure PerformCheckAndReleaseLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH LoanWriteoffHeader DO BEGIN
            // IF LoanWriteoffHeader.Status <> LoanWriteoffHeader.Status::"Pending Approval" THEN
            //  ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseLoanWriteoff(LoanWriteoffHeader);
        END;
    end;


    procedure ReopenLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
        WITH LoanWriteoffHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
        WITH LoanWriteoffHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
    end;

    procedure PerformCheckAndReleaseGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH GroupAllocationHeader DO BEGIN
            // IF GroupAllocationHeader.Status <> GroupAllocationHeader.Status::"Pending Approval" THEN
            // ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseGroupAllocation(GroupAllocationHeader);
        END;
    end;


    procedure ReopenGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WITH GroupAllocationHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WITH GroupAllocationHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
    end;

    procedure PerformCheckAndReleasePortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH PortfolioTransfer DO BEGIN
            // IF PortfolioTransfer.Status <> PortfolioTransfer.Status::"Pending Approval" THEN
            // ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF (Status = Status::New) or (Status = Status::"Pending Approval") THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleasePortfolioTransfer(PortfolioTransfer);
            CreatePorfolioTransfer(PortfolioTransfer);
        END;
    end;


    procedure ReopenPortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WITH PortfolioTransfer DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectPortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WITH PortfolioTransfer DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleasePortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
    end;

    local procedure CreatePorfolioTransfer(PortfolioTransfer: Record "Portfolio Transfer");
    var
        MicroCreditMember: Record Member;
        MicroCreditMember2: Record Member;
        LoanOfficerSetup: Record "Loan Recovery Officer Setup";
        MicroCreditManagement: Codeunit "MicroCredit Management";
    begin
        WITH PortfolioTransfer DO BEGIN
            IF "Transfer Type" = "Transfer Type"::"Client Transfer" THEN BEGIN
                MicroCreditMember.GET("Member No.");
                BEGIN
                    IF Category = Category::"Inter-branch" THEN BEGIN
                        MicroCreditMember."Global Dimension 1 Code" := "Destination Branch Code";
                    END;
                    MicroCreditMember."Loan Officer ID" := "Destination Loan Officer ID";
                    MicroCreditMember."Group Link No." := "Destination Group No.";
                    IF "No. of Loans" <> 0 THEN BEGIN
                        UpdateLoanAccounts("No.", "Member No.", "Source Loan Officer ID", "Destination Loan Officer ID", 'Loan', "Source Branch Code", "Destination Branch Code");
                    END;
                    MicroCreditManagement.CreatePortfolioEntry("No.", TODAY, '', 'Client Transfer', MicroCreditMember."No.", MicroCreditMember."Full Name", 0, "Source Loan Officer ID",
                                                               "Destination Loan Officer ID", 'Client', "Source Branch Code", "Destination Branch Code");
                    MicroCreditMember.MODIFY;
                END;
            END;
            IF "Transfer Type" = "Transfer Type"::"Group Transfer" THEN BEGIN
                IF MicroCreditMember.GET("Source Group No.") THEN BEGIN
                    IF Category = Category::"Inter-branch" THEN BEGIN
                        MicroCreditMember."Global Dimension 1 Code" := "Destination Branch Code";
                    END;
                    MicroCreditMember."Loan Officer ID" := "Destination Loan Officer ID";
                    MicroCreditMember2.RESET;
                    MicroCreditMember2.SETRANGE("Group Link No.", "Source Group No.");
                    IF MicroCreditMember2.FINDSET THEN BEGIN
                        REPEAT
                            MicroCreditMember2."Loan Officer ID" := "Destination Loan Officer ID";
                            MicroCreditMember2."Global Dimension 1 Code" := "Destination Branch Code";
                            MicroCreditMember2.MODIFY;
                            IF "No. of Loans" <> 0 THEN BEGIN
                                UpdateLoanAccounts("No.", MicroCreditMember2."No.", "Source Loan Officer ID", "Destination Loan Officer ID", 'Loan', "Source Branch Code", "Destination Branch Code");
                            END;
                            MicroCreditManagement.CreatePortfolioEntry("No.", TODAY, '', 'Client Transfer', MicroCreditMember2."No.", MicroCreditMember2."Full Name", 0, "Source Loan Officer ID",
                                                                       "Destination Loan Officer ID", 'Client', "Source Branch Code", "Destination Branch Code");
                        UNTIL MicroCreditMember2.NEXT = 0;
                    END;
                    MicroCreditManagement.CreatePortfolioEntry("No.", TODAY, '', 'Group Transfer', MicroCreditMember."No.", MicroCreditMember."Full Name", 0, "Source Loan Officer ID",
                                                               "Destination Loan Officer ID", 'Group', "Source Branch Code", "Destination Branch Code");
                    MicroCreditMember.MODIFY;
                END;
            END;
            IF "Transfer Type" = "Transfer Type"::"Loan Officer Transfer" THEN BEGIN
                MicroCreditMember.RESET;
                MicroCreditMember.SETRANGE("Loan Officer ID", "Source Loan Officer ID");
                IF MicroCreditMember.FINDSET THEN BEGIN
                    REPEAT
                        MicroCreditMember."Loan Officer ID" := "Destination Loan Officer ID";
                        MicroCreditMember.MODIFY;
                        UpdateLoanAccounts("No.", MicroCreditMember."No.", "Source Loan Officer ID", "Destination Loan Officer ID", 'Loan', "Source Branch Code", "Destination Branch Code");
                        IF MicroCreditMember.Category = MicroCreditMember.Category::Individual THEN BEGIN
                            MicroCreditManagement.CreatePortfolioEntry("No.", TODAY, '', 'Client Transfer', MicroCreditMember."No.", MicroCreditMember."Full Name", 0, "Source Loan Officer ID",
                                                                        "Destination Loan Officer ID", 'Client', "Source Branch Code", "Destination Branch Code");
                        END ELSE BEGIN
                            MicroCreditManagement.CreatePortfolioEntry("No.", TODAY, '', 'Group Transfer', MicroCreditMember."No.", MicroCreditMember."Full Name", 0, "Source Loan Officer ID",
                                                                        "Destination Loan Officer ID", 'Group', "Source Branch Code", "Destination Branch Code");
                        END;
                    UNTIL MicroCreditMember.NEXT = 0;
                END;
                IF LoanOfficerSetup.GET("Source Loan Officer ID") THEN BEGIN
                    LoanOfficerSetup."Global Dimension 1 Code" := "Destination Branch Code";
                    LoanOfficerSetup.MODIFY;
                    MicroCreditManagement.CreatePortfolioEntry("No.", TODAY, '', 'Loan Officer Transfer', '', LoanOfficerSetup."First Name" + ' ' + LoanOfficerSetup."Last Name", 0, '',
                                                                '', 'Loan Officer', "Source Branch Code", "Destination Branch Code");
                END;
            END;
            UpdateLoanClassification;
        END;
    end;

    local procedure UpdateLoanAccounts(TransferID: Code[20]; "MemberNo.": Code[20]; PreviousLoanOfficerID: Code[20]; CurrentLoanOfficerID: Code[20]; Type: Text; CurrentBranchCode: Code[10]; PreviousBranchCode: Code[10]);
    var
        MCLoanApplication: Record "Loan Application";
        Customer: Record Customer;
        MicroCreditManagement: Codeunit "MicroCredit Management";
    begin
        Customer.RESET;
        Customer.SETRANGE("Member No.", "MemberNo.");
        Customer.SETRANGE(Status, Customer.Status::Active);
        Customer.SETFILTER("Balance (LCY)", '<>%1', 0);
        IF Customer.FINDSET THEN BEGIN
            REPEAT
                //   Customer."Loan Officer ID" := CurrentLoanOfficerID;
                Customer.MODIFY;
                Customer.CALCFIELDS("Balance (LCY)");
                MicroCreditManagement.CreatePortfolioEntry(TransferID, TODAY, Customer."No.", Customer.Name, "MemberNo.", Customer."Member Name", ABS(Customer."Balance (LCY)"),
                                                           PreviousLoanOfficerID, CurrentLoanOfficerID, Type, CurrentBranchCode, PreviousBranchCode);
                IF MCLoanApplication.GET(Customer."No.") THEN BEGIN
                    //     MCLoanApplication."Loan Officer ID" := CurrentLoanOfficerID;
                    MCLoanApplication.MODIFY;
                END;
            UNTIL Customer.NEXT = 0;
        END;
    end;

    local procedure UpdateLoanClassification();
    var
        MCLoanApplication: Record "Loan Application";
        MicroCreditManagement: Codeunit "MicroCredit Management";
    begin
        MCLoanApplication.RESET;
        MCLoanApplication.SETRANGE(Posted, TRUE);
        IF MCLoanApplication.FINDSET THEN BEGIN
            REPEAT
            //   MicroCreditManagement.GenerateLoanClassification(MCLoanApplication, TODAY);
            UNTIL MCLoanApplication.NEXT = 0;
        END;
    end;
}

