codeunit 50004 "Tellering & Treasury"
{
    trigger OnRun()
    begin

    end;

    procedure PostTellerTransaction(var TellerTransactionHeader: Record "Teller Transaction Header")
    var
        TellerTransactionLine: Record "Teller Transaction Line";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: Decimal;
        ChargeAmount: array[8] of Decimal;
        AccountBalance: Decimal;
    begin
        WITH TellerTransactionHeader DO begin
            TelleringSetup.Get();
            SourceCodeSetup.Get();
            TransactionTpeCodeSetup.Get();
            TransactionTpeCodeSetup.TestField("Principal Paid");
            TransactionTpeCodeSetup.TestField("Interest Paid");
            SourceCodeSetup.TestField(Teller);

            UserSetup.Get("Teller User ID");



            JournalTemplateName := TelleringSetup."Teller Template Name";
            JournalBatchName := TelleringSetup."Teller Batch Name";
            CalcFields("Total Line Amount", "Total Coinage Amount");

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            ClearLastError();

            TransactionType.Get("Transaction Type");
            GetTransactionCharges(TransactionType.Code, "Total Line Amount", ChargeAmount[1]);
            case TransactionType.Type of
                TransactionType.Type::"Teller Cash Deposit":
                    begin
                        TellerTransactionLine.Reset();
                        TellerTransactionLine.SetRange("Transaction No.", "No.");
                        IF TellerTransactionLine.FindSet() THEN begin
                            repeat
                                if TellerTransactionLine."Account Type" = TellerTransactionLine."Account Type"::Vendor then begin
                                    GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 2, TellerTransactionLine."Account No.", "Transaction Type", -TellerTransactionLine."Line Amount", '', '', SourceCodeSetup.Teller, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                end;

                                if TellerTransactionLine."Account Type" = TellerTransactionLine."Account Type"::Customer then begin
                                    LoanApplication.get(TellerTransactionLine."Account No.");
                                    OriginalPostingGroup := LoanApplication."Loan Product Type";
                                    LoanProductType.GET(OriginalPostingGroup);

                                    Customer.get(TellerTransactionLine."Account No.");
                                    Customer."Customer Posting Group" := OriginalPostingGroup;

                                    GlobalManagement.CalculateLoanArrearsAndOverpayment(TellerTransactionLine."Account No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2],
                                                                        ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2]);
                                    GlobalManagement.CalculateInstallmentDue(TellerTransactionLine."Account No.", TODAY, InstallmentDue[1], InstallmentDue[2]);
                                    RemainingAmount := TellerTransactionLine."Line Amount";
                                    if TellerTransactionLine."Line Amount" > ArrearsAmount[2] then begin
                                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                                      TellerTransactionLine."Account No.", 'Interest Paid-' + "No.", -ArrearsAmount[2], '', TransactionTpeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                        RemainingAmount -= ArrearsAmount[2];
                                    end else begin
                                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                                      TellerTransactionLine."Account No.", 'Interest Paid-' + "No.", -TellerTransactionLine."Line Amount", '', TransactionTpeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                        RemainingAmount := 0;
                                    end;
                                    if RemainingAmount > InstallmentDue[2] then begin
                                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                                      TellerTransactionLine."Account No.", 'Interest Paid-' + "No.", -InstallmentDue[2], '', TransactionTpeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                        RemainingAmount -= InstallmentDue[2];
                                    end else begin
                                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                                      TellerTransactionLine."Account No.", 'Interest Paid-' + "No.", -RemainingAmount, '', TransactionTpeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                        RemainingAmount := 0;
                                    end;

                                    if RemainingAmount > 0 then begin


                                        Customer.get(TellerTransactionLine."Account No.");
                                        // Message('%1\%2', Customer."No.", Customer."Customer Posting Group");
                                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                                      TellerTransactionLine."Account No.", 'Principal Paid-' + "No.", -RemainingAmount, '', TransactionTpeCodeSetup."Principal Paid", SourceCodeSetup.Loan, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                    end;
                                end;

                                if TellerTransactionLine."Account Type" = TellerTransactionLine."Account Type"::"G/L Account" then begin
                                    GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 0, TellerTransactionLine."Account No.", "Transaction Type", -TellerTransactionLine."Line Amount", '', '', SourceCodeSetup.Teller, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                                end;
                            until TellerTransactionLine.Next() = 0;
                        end;
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, "Till No.", "Transaction Type", "Total Line Amount", '', '', SourceCodeSetup.Teller, UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                    end;
                TransactionType.Type::"Teller Cash Withdrawal":
                    begin
                        TellerTransactionLine.Reset();
                        TellerTransactionLine.SetRange("Transaction No.", "No.");
                        IF TellerTransactionLine.FindSet() THEN begin
                            repeat
                                AccountBalance := GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, TellerTransactionLine."Account No.");
                                if AccountBalance < "Total Line Amount" + ChargeAmount[1] then
                                    Error(InsufficientAccBalErrMsg);
                                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 2, TellerTransactionLine."Account No.", "Transaction Type", TellerTransactionLine."Line Amount" + ChargeAmount[1], '', '', SourceCodeSetup.Teller, GetBranchCode(TellerTransactionLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                            until TellerTransactionLine.Next() = 0;
                        end;
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, TransactionType."Settlement Account Type", TransactionType."Settlement Account No.", "No." + '-Withdrawal Charges', -ChargeAmount[1], '', '', SourceCodeSetup.Teller, UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, "Till No.", "Transaction Type", -"Total Line Amount", '', '', SourceCodeSetup.Teller, UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                    end;
            end;

            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                if Confirm(PrintTransactionReceiptConfirmMsg, true) then begin
                    TellerTransactionHeader.Get("No.");
                    TellerTransactionHeader.SETRECFILTER;
                    Report.Run(50004, true, false, TellerTransactionHeader);
                end else
                    exit;
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := Today;
                "Posted Time" := Time;
                IF Modify() then
                    CreateSMS(TellerTransactionHeader);
            end else
                Message(GetLastErrorText);


        end;
    end;

    local procedure GetTransactionCharges(TransactionTypeCode: Code[20]; TransactionAmount: Decimal; var ChargeAmount: Decimal)
    var
        TransactionCharge: Record "Transaction Charge";
    begin
        ChargeAmount := 0;
        TransactionCharge.Reset();
        TransactionCharge.SetRange("Transaction Type Code", TransactionTypeCode);
        if TransactionCharge.FindSet() then begin
            repeat
                if ((TransactionAmount >= TransactionCharge."Minimum Amount") and (TransactionAmount <= TransactionCharge."Maximum Amount")) then begin
                    ChargeAmount := TransactionCharge."Settlement Amount  (SACCO)";
                end;
            until TransactionCharge.Next() = 0;
        end;
    end;

    procedure CreateTellerReturnToTreasury(TellerTransactionHeader: Record "Teller Transaction Header")
    var
        TellerReturnToTreasury: Record "Teller Return Treasury";
    begin
        with TellerTransactionHeader do begin
            TellerUserSetup.Get("Teller User ID");
            TellerReturnToTreasury.Init();
            TellerReturnToTreasury."No." := '';
            TellerReturnToTreasury."Teller User ID" := "Teller User ID";
            TellerReturnToTreasury."Till No." := "Till No.";
            TellerReturnToTreasury."Till Return Amount" := Abs("Till Balance") - TellerUserSetup."Till Maximum Amount";
            TellerReturnToTreasury."Treasury Account No." := TellerUserSetup."Treasury Account No.";
            TellerreturnToTreasury.Status := TellerreturnToTreasury.Status::New;
            if TellerreturnToTreasury.Insert(true) then begin
                IF ApprovalsMgmt.CheckTellerReturnTreasuryApprovalPossible(TellerreturnToTreasury) THEN begin
                    ApprovalsMgmt.OnSendTellerReturnTreasuryForApproval(TellerreturnToTreasury);

                end;
            end;

        end;

    end;

    procedure PostTellerReturnToTreasury(var TellerReturnToTreasury: Record "Teller Return Treasury")
    var

    begin
        with TellerReturnToTreasury do begin
            TelleringSetup.Get();
            JournalTemplateName := TelleringSetup."Teller Template Name";
            JournalBatchName := TelleringSetup."Teller Batch Name";

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            ClearLastError();
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, "Till No.", Description, -"Till Return Amount", '', '', SourceCodeSetup.Teller, GetBranchCode("Teller User ID"), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, "Treasury Account No.", Description, "Till Return Amount", '', '', SourceCodeSetup.Teller, GetBranchCode("Teller User ID"), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                Modify();
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure CreateTellerRequestFromTreasury(TellerTransactionHeader: Record "Teller Transaction Header")
    var
        TreasuryTransactionHeader: Record "Treasury Transaction Header";

    begin
        with TellerTransactionHeader do begin
            TellerUserSetup.Get("Teller User ID");
            TreasuryTransactionHeader.Init();
            TreasuryTransactionHeader."No." := '';
            TreasuryTransactionHeader.validate("Treasury Account No.", TellerUserSetup."Treasury Account No.");
            TreasuryTransactionHeader.Status := TreasuryTransactionHeader.Status::New;
            if TreasuryTransactionHeader.Insert(true) then begin
                AddTreasuryTransactionLine(TreasuryTransactionHeader, TellerTransactionHeader);
            end;
        end;
    end;

    local procedure AddTreasuryTransactionLine(var TreasuryTransactionHeader: Record "Treasury Transaction Header"; TellerTransactionHeader: Record "Teller Transaction Header")
    var
        TreasuryTransactionLine: Record "Treasury Transaction Line";
        TreasuryTransactionLine2: Record "Treasury Transaction Line";
        LineNo: Integer;
    begin
        with TreasuryTransactionHeader do begin
            TreasuryTransactionLine.Init();
            TreasuryTransactionLine."Transaction No." := "No.";
            TreasuryTransactionLine2.Reset();
            TreasuryTransactionLine2.SetRange("Transaction No.", "No.");
            if TreasuryTransactionLine2.FindLast() then
                LineNo := TreasuryTransactionLine2."Line No."
            else
                LineNo := 0;
            TreasuryTransactionLine."Line No." := LineNo + 10000;
            TreasuryTransactionLine.validate("Till No.", TellerTransactionHeader."Till No.");
            TreasuryTransactionLine."Line Amount" := TellerUserSetup."Till Minimum Amount" - abs(TellerTransactionHeader."Till Balance");
            if TreasuryTransactionLine.Insert then begin
                IF ApprovalsMgmt.CheckTreasuryTransactionApprovalPossible(TreasuryTransactionHeader) THEN begin
                    ApprovalsMgmt.OnSendTreasuryTransactionForApproval(TreasuryTransactionHeader);
                end;
            end;
        end;
    end;

    procedure PostTreasuryTransaction(var TreasuryTransactionHeader: Record "Treasury Transaction Header")
    var
        TreasuryTransactionLine: Record "Treasury Transaction Line";

    begin
        with TreasuryTransactionHeader do begin
            TelleringSetup.Get();
            JournalTemplateName := TelleringSetup."Teller Template Name";
            JournalBatchName := TelleringSetup."Teller Batch Name";

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            ClearLastError();
            CalcFields("Total Amount", "Total Coinage Amount");

            TreasuryTransactionLine.Reset();
            TreasuryTransactionLine.SetRange("Transaction No.", "No.");
            if TreasuryTransactionLine.FindSet() then begin
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, TreasuryTransactionLine."Till No.", Description, -TreasuryTransactionLine."Line Amount", '', '', SourceCodeSetup.Treasury, GetBranchCode(''), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            end;
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, "Treasury Account No.", Description, "Total Amount", '', '', SourceCodeSetup.Treasury, GetBranchCode(''), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');

            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                Modify();
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostTreasuryReturnToBank(var TreasuryReturnToBankHeader: Record "Treasury Return Bank Header")
    var
        TreasuryReturnBankLine: Record "Treasury Return Bank Line";
    begin
        with TreasuryReturnToBankHeader do begin
            TelleringSetup.Get();
            JournalTemplateName := TelleringSetup."Teller Template Name";
            JournalBatchName := TelleringSetup."Teller Batch Name";

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            ClearLastError();
            CalcFields("Total Amount", "Total Coinage Amount");

            TreasuryReturnBankLine.Reset();
            TreasuryReturnBankLine.SetRange("Transaction No.", "No.");
            if TreasuryReturnBankLine.FindSet() then begin
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, TreasuryReturnBankLine."Treasury Account No.", Description, -TreasuryReturnBankLine."Line Amount", '', '', SourceCodeSetup.Treasury, GetBranchCode(''), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            end;
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, 3, "Bank Account No.", Description, "Total Amount", '', '', SourceCodeSetup.Treasury, GetBranchCode(''), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                Modify();
            end else
                Message(GetLastErrorText);
        end;
    end;

    local procedure GetBranchCode(MemberNo: Code[20]): Code[20]
    var
        Member: Record "Member";
    begin
        Member.Get(MemberNo);
        IF Member.FindFirst() THEN
            EXIT(Member."Global Dimension 1 Code");
    end;

    local procedure CreateSMS(TellerTransactionHeader: Record "Teller Transaction Header")
    var
        TellerTransactionLine: Record "Teller Transaction Line";
        SMSText: BigText;
    begin

        with TellerTransactionHeader do begin
            CalcFields("Total Line Amount");
            TransactionType.Get("Transaction Type");
            if TransactionType.Type = TransactionType.Type::"Teller Cash Deposit" then
                SMSText.AddText(StrSubstNo(DepositSMSTextMsg, "Total Line Amount"));
            if TransactionType.Type = TransactionType.Type::"Teller Cash Withdrawal" then
                SMSText.AddText(StrSubstNo(WithdrawalSMSTextMsg, "Total Line Amount"));

            TellerTransactionLine.Reset();
            TellerTransactionLine.SetRange("Transaction No.", "No.");
            if TellerTransactionLine.FindFirst() then begin
                Member.Get(TellerTransactionLine."Member No.");
                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, 'TELLER');
            end;
        end;
    end;

    var
        i: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        // TelleringSetup: Record "Tellering Setup";
        GenJournalLine: Record "Gen. Journal Line";
        TellerUserSetup: Record "Teller User Setup";
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        PrintTransactionReceiptConfirmMsg: Label 'Do you want to print Transaction receipt?';
        GlobalManagement: Codeunit "Global Management";
        LoanProductType: Record "Loan Product Type";
        OriginalPostingGroup: Code[20];
        LoanApplication: Record "Loan Application";
        SourceCodeSetup: Record "Source Code Setup";
        Customer: Record Customer;
        SMSEntry: Record "SMS Entry";
        DepositSMSTextMsg: Label 'Dear Member, We have received KES %1. Kinangop Boost Sacco';
        WithdrawalSMSTextMsg: Label 'Dear Member, You have withdrawn KES %1. Kinangop Boost Sacco';
        Member: Record Member;
        TransactionType: Record "Transaction -Type";
        InsufficientAccBalErrMsg: Label 'Insufficient Account Balance';
        UserSetup: Record "User Setup";
        TelleringSetup: Record "Tellering Setup";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        TransactionTpeCodeSetup: Record "Transaction Type Code Setup";



}