codeunit 50039 "Cash Management"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        BankAccount: Record "Bank Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        VendLedgEntry: Record "Vendor Ledger Entry";
        ReceiptLine: Record "Receipt Line";
        GenJlLine: Record "Gen. Journal Line";
        CashManagementSetup: Record "Cash Management Setup";
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        GenJournalBatch: Record "Gen. Journal Batch";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GlobalManagement: Codeunit "Global Management";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        LoanProductType: Record "Loan Product Type";
        SourceCodeSetup: Record "Source Code Setup";
        GLAccount: Record "G/L Account";
        GenJournalLine: Record "Gen. Journal Line";
        PrintReceiptVoucherConfirmMsg: Label 'Do you want to print receipt voucher %1?';
        PrintPaymentVoucherConfirmMsg: Label 'Do you want to print payment voucher %1?';
        PrintCheckoffReceiptVoucherConfirmMsg: Label 'Do you want to print Checkoff receipt voucher %1?';
        PrintPettyCashVoucherConfirmMsg: Label 'Do you want to print PettyCash voucher %1?';
        GlobalSetup: Record "Global Setup";
        NoLinesExist: Label 'No Lines Exist';
        ReversalEntry: Record "Reversal Entry";
        GLEntry: Record "G/L Entry";
        PaymentVoucherReversalSuccessMsg: Label 'Payment Voucher %1 reversed successfully';
        ReceiptVoucherReversalSuccessMsg: Label 'Receipt Voucher %1 reversed successfully';
        CheckoffReceiptVoucherReversalSuccessMsg: Label 'Checkoff Receipt Voucher %1 reversed successfully';
        CheckoffReversalSuccessMsg: Label 'Checkoff %1 reversed successfully';
        LoanRecovReversalSuccessMsg: Label 'Loan recovery %1 reversed successfully';
        PettyCashReversalSuccessMsg: Label 'PettyCash %1 reversed successfully';
        InsufficientAccountBalanceErr: Label 'Insufficient Account Balance';
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";

    procedure GetAppliesToDocVendorInfo(VendorNo: Code[20]; var AppliesToDocNo: Code[20]; var RemainingAmount: Decimal)
    begin
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        IF VendorNo <> '' THEN BEGIN
            VendLedgEntry.SetRange("Document Type", VendLedgEntry."Document Type"::Invoice);
            VendLedgEntry.SETRANGE("Vendor No.", VendorNo);
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.SETRANGE(Positive, FALSE);
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            Commit();
            IF PAGE.RUNMODAL(0, VendLedgEntry) = ACTION::LookupOK THEN BEGIN
                AppliesToDocNo := VendLedgEntry."Document No.";
                RemainingAmount := VendLedgEntry."Remaining Amount";
            END;
        END;
    end;

    procedure LookUpAppliesToDocVendRcpt("AccountNo.": Code[20]) "AppliestoDoc.No": Code[20];
    begin
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        IF "AccountNo." <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Vendor No.", "AccountNo.");
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.SETRANGE(Positive, TRUE);
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF PAGE.RUNMODAL(0, VendLedgEntry) = ACTION::LookupOK THEN BEGIN
                "AppliestoDoc.No" := VendLedgEntry."Document No.";
            END;
        END;
    end;

    procedure LookUpAppliesToDocCust("AccountNo.": Code[20]) "AppliestoDoc.No": Code[20];
    begin
        CustLedgerEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        IF "AccountNo." <> '' THEN BEGIN
            CustLedgerEntry.SETRANGE("Customer No.", "AccountNo.");
            CustLedgerEntry.SETRANGE(Open, TRUE);
            CustLedgerEntry.SETRANGE(Positive, TRUE);
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            IF PAGE.RUNMODAL(0, CustLedgerEntry) = ACTION::LookupOK THEN BEGIN
                "AppliestoDoc.No" := CustLedgerEntry."Document No.";
            END;
        END;
    end;

    procedure PostReceiptVoucher(var ReceiptHeader: Record "Receipt Header")
    var
        ReceiptLine: Record "Receipt Line";
        Descrp: Text[250];
        AccountTypes: Record "Account Type";

    begin
        with ReceiptHeader do begin

            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            if "Account Type" = "Account Type"::"Bank Account" then
                TestField("Bank Account No.");
            if "Account Type" = "Account Type"::"G/L Account" then
                TestField("GL Account No");
            // TestField(Description);
            //TestField("Payee Name");
            TestField("Payment Method");
            TestField("Posting Date");
            TestField(Amount);


            SourceCodeSetup.TestField("Receipt Voucher");

            CashManagementSetup.TestField("Receipt Template Name");
            CashManagementSetup.TestField("Receipt Batch Name");

            JournalTemplateName := CashManagementSetup."Receipt Template Name";
            JournalBatchName := CashManagementSetup."Receipt Batch Name";

            if not ReceiptLine.ReceiptLinesExist("No.") then
                Error(NoLinesExist);

            CalcFields("Total Line Amount");
            TestField(Amount, "Total Line Amount");

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);


            ReceiptLine.Reset();
            ReceiptLine.SetRange("Document No.", "No.");
            IF ReceiptLine.FindSet() THEN begin
                repeat
                    ReceiptLine.TestField("Account No.");
                    //ReceiptLine.TestField();
                    ReceiptLine.TestField("Line Amount");
                    if ReceiptHeader."Transaction Type" = ReceiptHeader."Transaction Type"::"Single Member" then
                        Descrp := ReceiptHeader.Description
                    else
                        Descrp := ReceiptLine.Description;

                    if ReceiptLine."Account Type" = ReceiptLine."Account Type"::Vendor then begin
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", ReceiptHeader."External Document No.", "Posting Date", AccountTypeEnum::Vendor, ReceiptLine."Account No.", Descrp + ' -' + ReceiptHeader."External Document No.", -ReceiptLine."Line Amount", '', '', SourceCodeSetup."Receipt Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', ReceiptLine."Member No.");
                    end;

                    if ReceiptLine."Account Type" = ReceiptLine."Account Type"::Customer then begin
                        GlobalManagement.DeductLoanArrears(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", ReceiptHeader."External Document No.", "Posting Date", ReceiptLine."Account No.", ReceiptLine."Line Amount", "Global Dimension 1 Code");
                    end;
                    if ReceiptLine."Account Type" = ReceiptLine."Account Type"::"G/L Account" then begin
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", ReceiptHeader."External Document No.", "Posting Date", AccountTypeEnum::"G/L Account", ReceiptLine."Account No.", Descrp + ' -' + ReceiptHeader."External Document No.", -ReceiptLine."Line Amount", '', '', SourceCodeSetup."Receipt Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', ReceiptLine."Member No.");
                    end;
                until ReceiptLine.Next() = 0;
            end;
            if ReceiptHeader."Account Type" = ReceiptHeader."Account Type"::"Bank Account" then
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", ReceiptHeader."External Document No.", "Posting Date", AccountTypeEnum::"Bank Account", "Bank Account No.", Description + ' -' + ReceiptHeader."External Document No.", "Total Line Amount", '', '', SourceCodeSetup."Receipt Voucher", UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', ReceiptHeader."Member No.");
            if ReceiptHeader."Account Type" = ReceiptHeader."Account Type"::"G/L Account" then
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", ReceiptHeader."External Document No.", "Posting Date", AccountTypeEnum::"G/L Account", "GL Account No", Description + ' -' + ReceiptHeader."External Document No.", "Total Line Amount", '', '', SourceCodeSetup."Receipt Voucher", UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', ReceiptHeader."Member No.");
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                if Confirm(PrintReceiptVoucherConfirmMsg, true, "No.") then begin
                    ReceiptHeader.SETRECFILTER;
                    Report.Run(50440, false, false, ReceiptHeader);
                end;

                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                IF Modify() then;
                //  CreateSMS(TellerTransactionHeader);
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostBoardPaymentVoucher(var PaymentHeader: Record "Board Payment Header");
    var
        PaymentLine: Record "Board Payment Line";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: Decimal;
        TotalNetAmount: Decimal;
        LineNetAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        BoardPVLines: Record "Board Members Payment Line";
        BMembersCount: Integer;

    begin
        with PaymentHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();


            //TestField(Amount);

            SourceCodeSetup.TestField("Payment Voucher");
            CashManagementSetup.TestField("Payment Template Name");
            CashManagementSetup.TestField("Payment Batch Name");

            JournalTemplateName := CashManagementSetup."Payment Template Name";
            JournalBatchName := CashManagementSetup."Payment Batch Name";
            CalcFields("Total Line Amount", "Net Board Amount");
            TotalNetAmount := "Total Line Amount" + "Net Board Amount";

            //if not PaymentLine.PaymentLinesExist("No.") then
            // Error(NoLinesExist);

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            LineNetAmount := 0;
            GlobalSetup.TestField("Board Tax G/L Account");
            GlobalSetup.TestField("Sitting Allowance G/L");
            GlobalSetup.TestField("Transport Reimbursement G/L");
            GlobalSetup.TestField("Board Hospitality G/L");

            BoardPVLines.Reset();
            BoardPVLines.SetRange("Document No.", PaymentHeader."No.");
            If BoardPVLines.FindSet() then begin
                repeat
                    Vendor.Get(BoardPVLines."Account No.");
                    if BoardPVLines."Sitting Allowance" > 0 then
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, BoardPVLines."Account No.", "No." + ' -' + Description + ' -' + BoardPVLines."Account No." + ' -Sitting Allowance', -BoardPVLines."Sitting Allowance", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", GlobalSetup."Sitting Allowance G/L", AppliesToDocTypeEnum::" ", '', Vendor."Member No.");
                    if BoardPVLines."Sitting Allowance Tax" > 0 then
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, BoardPVLines."Account No.", "No." + ' -' + Description + ' -' + BoardPVLines."Account No." + ' -Tax on Sitting Allowance', BoardPVLines."Sitting Allowance Tax", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", GlobalSetup."Board Tax G/L Account", AppliesToDocTypeEnum::" ", '', Vendor."Member No.");
                    if BoardPVLines."Transport Allowance" > 0 then
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, BoardPVLines."Account No.", "No." + ' -' + Description + ' -' + BoardPVLines."Account No." + ' -Transport Reimbursement', -BoardPVLines."Transport Allowance", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", GlobalSetup."Transport Reimbursement G/L", AppliesToDocTypeEnum::" ", '', Vendor."Member No.");
                    if BoardPVLines.Hospitality > 0 then
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, BoardPVLines."Account No.", "No." + ' -' + Description + ' -' + BoardPVLines."Account No." + ' -Hospitality Costs', -BoardPVLines.Hospitality, '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", GlobalSetup."Board Hospitality G/L", AppliesToDocTypeEnum::" ", '', Vendor."Member No.");
                    if BoardPVLines."Net Pay" > 0 then
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, BoardPVLines."Account No.", "No." + ' -' + Description + ' -' + BoardPVLines."Account No." + ' -Net Payment', BoardPVLines."Net Pay", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Vendor."Member No.");
                until BoardPVLines.Next = 0;
            end;

            PaymentLine.Reset();
            PaymentLine.SetRange("Document No.", "No.");
            IF PaymentLine.FindSet() THEN begin
                repeat
                    if PaymentLine."Line Amount" > 0 then begin
                        PaymentLine.TestField("Account No.");
                        PaymentLine.TestField(Description);
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", PaymentLine."Account Type", PaymentLine."Account No.", "No." + ' -' + PaymentLine.Description, PaymentLine."Line Amount", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                    end;
                until PaymentLine.Next() = 0;
            end;

            If TotalNetAmount > 0 then
                GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", "Account Type", "Account No.", "No." + ' -' + Description, -TotalNetAmount, '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');

            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                Modify();
            end;
        end;
    end;

    procedure PostPaymentVoucher(var PaymentHeader: Record "Payment Header");
    var
        PaymentLine: Record "Payment Line";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: Decimal;
        TotalNetAmount: Decimal;
        LineNetAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";

    begin
        with PaymentHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();

            TestField("Bank Account No.");
            TestField(Description);
            TestField("Payee Name");
            TestField("Payment Method");
            TestField(Amount);

            SourceCodeSetup.TestField("Payment Voucher");
            CashManagementSetup.TestField("Payment Template Name");
            CashManagementSetup.TestField("Payment Batch Name");

            JournalTemplateName := CashManagementSetup."Payment Template Name";
            JournalBatchName := CashManagementSetup."Payment Batch Name";
            CalcFields("Total Line Amount", "Total W/Tax Amount", "Total VAT Amount");
            TotalNetAmount := "Total Line Amount" - "Total W/Tax Amount" - "Total VAT Amount";

            if not PaymentLine.PaymentLinesExist("No.") then
                Error(NoLinesExist);

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            PaymentLine.Reset();
            PaymentLine.SetRange("Document No.", "No.");
            IF PaymentLine.FindSet() THEN begin
                repeat
                    PaymentLine.TestField("Account No.");
                    PaymentLine.TestField(Description);
                    PaymentLine.TestField("Line Amount");
                    LineNetAmount := PaymentLine."Line Amount" - PaymentLine."W/Tax Amount" - PaymentLine."VAT Amount";
                    GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, PaymentLine."Account No.", Description, PaymentLine."Line Amount", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', PaymentLine."Applies to Doc Type", PaymentLine."Applies to Doc. No", '');
                    if PaymentLine."W/Tax Amount" <> 0 then begin
                        GlobalSetup.TestField("Withholding Tax G/L Account");
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"G/L Account", GlobalSetup."Withholding Tax G/L Account", Description, -PaymentLine."W/Tax Amount", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', PaymentLine."Applies to Doc Type", PaymentLine."Applies to Doc. No", '');
                    end;
                    if PaymentLine."VAT Amount" <> 0 then begin
                        VATPostingSetup.get(PaymentLine."VAT Business Posting Group", PaymentLine."VAT Product Posting Group");
                        VATPostingSetup.TestField("Purchase VAT Account");
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"G/L Account", VATPostingSetup."Purchase VAT Account", Description, -PaymentLine."VAT Amount", '', '', SourceCodeSetup."Payment Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', PaymentLine."Applies to Doc Type", PaymentLine."Applies to Doc. No", '');
                    end;
                until PaymentLine.Next() = 0;
            end;
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"Bank Account", "Bank Account No.", Description, -TotalNetAmount, '', '', SourceCodeSetup."Payment Voucher", UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin

                if Confirm(PrintPaymentVoucherConfirmMsg, true, "No.") then begin
                    PaymentHeader.SETRECFILTER;
                    Report.Run(50447, false, false, PaymentHeader);
                end;
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                IF Modify() then;
                //  CreateSMS(TellerTransactionHeader);
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostPettyCashVoucher(var PettyCashHeader: Record "PettyCash Header");
    var
        PettyCashLine: Record "PettyCash Line";
        ArrearsAmount: array[4] of Decimal;
        OverPettyCashAmount: array[4] of Decimal;
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: Decimal;
        TotalNetAmount: Decimal;
        LineNetAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";

    begin
        with PettyCashHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();

            TestField("Bank Account No.");
            TestField(Description);
            TestField("Payee Name");
            TestField("Payment Method");
            TestField(Amount);

            SourceCodeSetup.TestField("PettyCash Voucher");
            CashManagementSetup.TestField("PettyCash Template Name");
            CashManagementSetup.TestField("PettyCash Batch Name");

            JournalTemplateName := CashManagementSetup."PettyCash Template Name";
            JournalBatchName := CashManagementSetup."PettyCash Batch Name";
            CalcFields("Total Line Amount", "Total W/Tax Amount", "Total VAT Amount");
            TotalNetAmount := "Total Line Amount" - "Total W/Tax Amount" - "Total VAT Amount";

            if not PettyCashLine.PettyCashLinesExist("No.") then
                Error(NoLinesExist);

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            PettyCashLine.Reset();
            PettyCashLine.SetRange("Document No.", "No.");
            IF PettyCashLine.FindSet() THEN begin
                repeat
                    PettyCashLine.TestField("Account No.");
                    PettyCashLine.TestField(Description);
                    PettyCashLine.TestField("Line Amount");
                    LineNetAmount := PettyCashLine."Line Amount" - PettyCashLine."W/Tax Amount" - PettyCashLine."VAT Amount";
                    GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, PettyCashLine."Account No.", Description, LineNetAmount, '', '', SourceCodeSetup."PettyCash Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', PettyCashLine."Applies to Doc Type", PettyCashLine."Applies to Doc. No", '');

                    if PettyCashLine."W/Tax Amount" <> 0 then begin
                        GlobalSetup.TestField("Withholding Tax G/L Account");
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"G/L Account", GlobalSetup."Withholding Tax G/L Account", Description, PettyCashLine."W/Tax Amount", '', '', SourceCodeSetup."PettyCash Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');

                    end;
                    if PettyCashLine."VAT Amount" <> 0 then begin
                        VATPostingSetup.get(PettyCashLine."VAT Business Posting Group", PettyCashLine."VAT Product Posting Group");
                        VATPostingSetup.TestField("Purchase VAT Account");
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"G/L Account", VATPostingSetup."Purchase VAT Account", Description, PettyCashLine."VAT Amount", '', '', SourceCodeSetup."PettyCash Voucher", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');

                    end;
                until PettyCashLine.Next() = 0;
            end;
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"Bank Account", "Bank Account No.", Description, -"Total Line Amount", '', '', SourceCodeSetup."PettyCash Voucher", UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin

                if Confirm(PrintPettyCashVoucherConfirmMsg, true, "No.") then begin
                    PettyCashHeader.SETRECFILTER;
                    Report.Run(50448, false, false, PettyCashHeader);
                end;
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                IF Modify() then;
                //  CreateSMS(TellerTransactionHeader);
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostCheckoffReceiptVoucher(var CheckoffReceiptHeader: Record "Checkoff Receipt Header")
    var
        CheckoffReceiptLine: Record "Checkoff Receipt Line";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: Decimal;
    begin
        with CheckoffReceiptHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();

            TestField("Account No.");
            TestField(Description);
            //TestField("Payee Name");
            TestField("Payment Method");
            TestField("Posting Date");
            TestField(Amount);

            SourceCodeSetup.TestField(Checkoff);
            CashManagementSetup.TestField("Receipt Template Name");
            CashManagementSetup.TestField("Receipt Batch Name");

            JournalTemplateName := CashManagementSetup."Receipt Template Name";
            JournalBatchName := CashManagementSetup."Receipt Batch Name";

            if not CheckoffReceiptLine.CheckoffReceiptLinesExist("No.") then
                Error(NoLinesExist);

            CalcFields("Total Line Amount");
            TestField(Amount, "Total Line Amount");

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);


            CheckoffReceiptLine.Reset();
            CheckoffReceiptLine.SetRange("Document No.", "No.");
            IF CheckoffReceiptLine.FindSet() THEN begin
                repeat
                    CheckoffReceiptLine.TestField("Account No.");
                    CheckoffReceiptLine.TestField("External Document No.");
                    CheckoffReceiptLine.TestField("Line Amount");

                    if CheckoffReceiptLine."Account Type" = CheckoffReceiptLine."Account Type"::"Bank Account" then begin
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", CheckoffReceiptLine."External Document No.", CheckoffReceiptLine."Receipt Date", AccountTypeEnum::"Bank Account", CheckoffReceiptLine."Account No.", Description + ' -' + CheckoffReceiptLine."External Document No.", CheckoffReceiptLine."Line Amount", '', '', SourceCodeSetup.Checkoff, "Global Dimension 1 Code", "Account Type", "Account No.", 0, '', '');
                    end;
                    if CheckoffReceiptLine."Account Type" = CheckoffReceiptLine."Account Type"::"G/L Account" then begin
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", CheckoffReceiptLine."External Document No.", CheckoffReceiptLine."Receipt Date", AccountTypeEnum::"G/L Account", CheckoffReceiptLine."Account No.", Description + ' -' + CheckoffReceiptLine."External Document No.", CheckoffReceiptLine."Line Amount", '', '', SourceCodeSetup.Checkoff, "Global Dimension 1 Code", "Account Type", "Account No.", 0, '', '');
                    end;
                until CheckoffReceiptLine.Next() = 0;
            end;
            // GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, "Account No.", Description, -"Total Line Amount", SourceCodeSetup.Checkoff, "Global Dimension 1 Code",BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                /*  if Confirm(PrintReceiptVoucherConfirmMsg, true, "No.") then begin
                     CheckoffReceiptHeader.SETRECFILTER;
                     Report.Run(50440, false, false, CheckoffReceiptHeader);
                 end; */

                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                IF Modify() then;
                //  CreateSMS(TellerTransactionHeader);
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostLoanRecovery(var LoanRecoveryHeader: Record "Loan Recovery Header")
    var
        LoanRecovLine: Record "Loan Recovery Line";
        DepositAccNo: Code[20];
    begin
        with LoanRecoveryHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            TestField(Description);
            TestField("Posting Date");
            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Principal Paid");
            TransactionTypeCodeSetup.TestField("Interest Paid");
            TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
            TransactionTypeCodeSetup.TestField("Penalty Paid");
            TransactionTypeCodeSetup.TestField("Loan Prepayment");
            CashManagementSetup.TestField("Loan Recovery Template Name");
            CashManagementSetup.TestField("Loan Recovery Batch Name");

            JournalTemplateName := CashManagementSetup."Loan Recovery Template Name";
            JournalBatchName := CashManagementSetup."Loan Recovery Batch Name";

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);

            LoanRecovLine.Reset();
            LoanRecovLine.SetRange("Document No.", "No.");
            IF LoanRecovLine.FindSet() THEN begin
                repeat
                    DepositAccNo := '';
                    LoanRecovLine.TestField("Member No.");
                    LoanRecovLine.TestField("Loan No.");
                    LoanRecovLine.TestField("Recovery Amount");
                    DepositAccNo := GlobalManagement.GetMemberDepositsAcc(LoanRecovLine."Member No.");
                    Vendor.Get(DepositAccNo);
                    Vendor.CalcFields(Balance);
                    If LoanRecovLine."Recovery Amount" > Vendor.Balance then
                        Error('Member No %1 Loan No %2 recovery amount is more than deposit balance', LoanRecovLine."Member No.", LoanRecovLine."Loan No.");

                    GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, DepositAccNo, Description,
                    LoanRecovLine."Recovery Amount", '', '', SourceCodeSetup.Loan, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanRecovLine."Member No.");

                    GlobalManagement.DeductLoanArrearsLoanRecoveryFromDeposits(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date",
                    LoanRecovLine."Loan No.", LoanRecovLine."Recovery Amount", '');

                until LoanRecovLine.Next() = 0;
            end;

            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                IF Modify() then;
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostDepositRecovery(var RecoveryHeader: Record "Recovery Header")
    var
        RecovLine: Record "Recovery Line";
        DepositAccNo: Code[20];
        sharesAccNo: Code[20];

    begin
        with RecoveryHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            TestField(Description);
            TestField("Posting Date");
            SourceCodeSetup.TestField(Payout);
            if "Destination Account Type" = "Destination Account Type"::" " then Error('Please Define destination accont type');
            JournalTemplateName := 'GENERAL';
            JournalBatchName := 'DEFAULT';

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);

            if "Destination Account Type" = "Destination Account Type"::"G/L" then begin





                RecovLine.Reset();
                RecovLine.SetRange("Document No.", "No.");
                IF RecovLine.FindSet() THEN begin
                    repeat
                        DepositAccNo := '';
                        RecovLine.TestField("Member No.");
                        RecovLine.TestField("Account  No.");
                        RecovLine.TestField("Recovery Amount");
                        DepositAccNo := GlobalManagement.GetMemberDepositsAcc(RecovLine."Member No.");
                        Vendor.Get(DepositAccNo);
                        Vendor.CalcFields(Balance);
                        If RecovLine."Recovery Amount" > Vendor.Balance then
                            Error('Member No %1  recovery amount is more than deposit balance', RecovLine."Member No.");

                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, DepositAccNo, Description,
                        RecovLine."Recovery Amount", '', '', SourceCodeSetup.Payout, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', RecovLine."Member No.");

                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"G/L Account", "Destination G/L", Description,
                        RecovLine."Recovery Amount" * -1, '', '', SourceCodeSetup.Payout, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', RecovLine."Member No.");



                    until RecovLine.Next() = 0;
                end;
            end else begin


                RecovLine.Reset();
                RecovLine.SetRange("Document No.", "No.");
                IF RecovLine.FindSet() THEN begin
                    repeat
                        DepositAccNo := '';
                        sharesAccNo := '';
                        RecovLine.TestField("Member No.");
                        RecovLine.TestField("Account  No.");
                        RecovLine.TestField("Recovery Amount");
                        DepositAccNo := GlobalManagement.GetMemberDepositsAcc(RecovLine."Member No.");
                        sharesAccNo := GlobalManagement.GetMemberSharesAcc(RecovLine."Member No.");
                        Vendor.Get(DepositAccNo);
                        Vendor.CalcFields(Balance);
                        If RecovLine."Recovery Amount" > Vendor.Balance then
                            Error('Member No %1  recovery amount is more than deposit balance', RecovLine."Member No.");

                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, DepositAccNo, Description,
                        RecovLine."Recovery Amount", '', '', SourceCodeSetup.Payout, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', RecovLine."Member No.");

                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, sharesAccNo, Description,
                        -RecovLine."Recovery Amount", '', '', SourceCodeSetup.Payout, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', RecovLine."Member No.");



                    until RecovLine.Next() = 0;
                end;
            end;
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := "Posting Date";
                "Posted Time" := Time;
                IF Modify() then;
            end else
                Message(GetLastErrorText);
        end;
    end;

    procedure PostCheckoff(var CheckoffHeader: Record "Checkoff Header")
    var
        CheckoffLine: Record "Checkoff Line";
        CheckoffLine2: Record "Checkoff Line";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: Decimal;
        SumPreviousLines: Decimal;
        AccountTypes: Record "Account Type";
    begin
        with CheckoffHeader do begin
            CashManagementSetup.Get();
            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();

            TestField("Agent Code");
            TestField(Description);
            TestField("Payee Name");
            TestField("Payment Method");
            TestField("Posting Date");
            TestField(Amount);

            SourceCodeSetup.TestField(Checkoff);
            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Principal Paid");
            TransactionTypeCodeSetup.TestField("Interest Paid");
            TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
            TransactionTypeCodeSetup.TestField("Penalty Paid");
            TransactionTypeCodeSetup.TestField("Loan Prepayment");
            CashManagementSetup.TestField("Checkoff Template Name");
            CashManagementSetup.TestField("Checkoff Batch Name");

            JournalTemplateName := CashManagementSetup."Checkoff Template Name";
            JournalBatchName := CashManagementSetup."Checkoff Batch Name";

            if not CheckoffLine.CheckoffLinesExist("No.") then
                Error(NoLinesExist);

            CalcFields("Total Line Amount");
            TestField(Amount, "Total Line Amount");
            if "Account Balance" < Amount then
                Error(InsufficientAccountBalanceErr);

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);


            CheckoffLine.Reset();
            CheckoffLine.SetRange("Document No.", "No.");
            IF CheckoffLine.FindSet() THEN begin
                repeat

                    CheckoffLine.TestField("Account No.");
                    CheckoffLine.TestField(Description);
                    CheckoffLine.TestField("Line Amount");

                    if CheckoffLine."Account Type" = CheckoffLine."Account Type"::Vendor then begin
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::Vendor, CheckoffLine."Account No.", Description, -CheckoffLine."Line Amount", '', '', SourceCodeSetup.Checkoff, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', CheckoffLine."Member No.");
                    end;

                    if CheckoffLine."Account Type" = CheckoffLine."Account Type"::Customer then begin

                        SumPreviousLines := 0;
                        CheckoffLine2.Reset();
                        CheckoffLine2.SetRange("Document No.", CheckoffLine."Document No.");
                        CheckoffLine2.SetRange("Account No.", CheckoffLine."Account No.");
                        CheckoffLine2.SetFilter("Line No.", '<%1', CheckoffLine."Line No.");
                        IF CheckoffLine2.FindSet() THEN begin
                            repeat
                                SumPreviousLines += CheckoffLine2."Line Amount";
                            until CheckoffLine2.Next = 0;
                        end;
                        GlobalManagement.DeductLoanArrearsCheckoffNew(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", CheckoffLine."Account No.", CheckoffLine."Line Amount", "Global Dimension 1 Code", SumPreviousLines);
                    end;

                    if CheckoffLine."Account Type" = CheckoffLine."Account Type"::"G/L Account" then begin
                        GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", AccountTypeEnum::"G/L Account", CheckoffLine."Account No.", Description + ' ' + CheckoffLine.Description, -CheckoffLine."Line Amount", '', '', SourceCodeSetup.Checkoff, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
                    end;

                until CheckoffLine.Next() = 0;
            end;
            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", "Account Type", "Account No.", Description, "Total Line Amount", '', '', SourceCodeSetup.Checkoff, UserSetup."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                Posted := true;
                "Posted By" := UserId;
                "Posted Date" := Today;
                "Posted Time" := Time;
                IF Modify() then;
                //  CreateSMS(TellerTransactionHeader);
            end else
                Message(GetLastErrorText);
        end;

    end;


    procedure ReversePaymentVoucher(var PaymentHeader: Record "Payment Header")
    var

    begin
        with PaymentHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            if Modify() then
                Message(PaymentVoucherReversalSuccessMsg, "No.");
        end;
    end;

    procedure ReverseBoardPaymentVoucher(var PaymentHeader: Record "Board Payment Header")
    var

    begin
        with PaymentHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            if Modify() then
                Message(CheckoffReversalSuccessMsg, "No.");
        end;
    end;

    local procedure GetLastPaymentLineNo(DocumentNo: Code[20]): integer;
    var
        PaymentLine2: Record "Payment Line";
    begin
        PaymentLine2.SetRange("Document No.", DocumentNo);
        if PaymentLine2.FindLast() then
            exit(PaymentLine2."Line No.")
        else
            exit(0);
    end;

    procedure SuggestPaymentLines(PaymentLine: Record "Payment Line")
    var
        PaymentLine2: Record "Payment Line";
        PaymentHeader: Record "Payment Header";
        AppliesToDocNo: Code[20];
        RemainingAmount: Decimal;
    begin
        with PaymentLine do begin

            PaymentHeader.Get("Document No.");
            PaymentHeader.TestField("Vendor No.");
            GetAppliesToDocVendorInfo(PaymentHeader."Vendor No.", AppliesToDocNo, RemainingAmount);

            PaymentLine2.Reset();
            PaymentLine2.SetRange("Document No.", "Document No.");
            // PaymentLine2.SetRange("Applies to Doc. No", AppliesToDocNo);
            PaymentLine2.DeleteAll();

            InsertPaymentLine("Document No.", PaymentHeader."Vendor No.", AppliesToDocNo, RemainingAmount);
        end;
    end;

    procedure InsertPaymentLine(DocumentNo: Code[20]; VendorNo: Code[20]; AppliesToDocNo: Code[20]; LineAmount: Decimal)
    var
        PaymentLine2: Record "Payment Line";
    begin
        PaymentLine2."Document No." := DocumentNo;
        PaymentLine2."Line No." := GetLastPaymentLineNo(DocumentNo) + 10000;
        PaymentLine2."Account Type" := PaymentLine2."Account Type"::Vendor;
        Vendor.Get(VendorNo);
        PaymentLine2."Account No." := VendorNo;
        PaymentLine2."Account Name" := Vendor.Name;
        PaymentLine2.Description := Vendor.Name;
        PaymentLine2."Line Amount" := abs(LineAmount);
        PaymentLine2."Applies to Doc Type" := PaymentLine2."Applies to Doc Type"::Invoice;
        PaymentLine2."Applies to Doc. No" := AppliesToDocNo;
        PaymentLine2.Insert();
    end;

    procedure SuggestReceiptLines(var ReceiptLine: Record "Receipt Line")
    var
        AmountDue: array[4] of decimal;
        ArrearsAmount: array[4] of decimal;
        AmountOverpaid: array[4] of decimal;
        ReceiptLine2: Record "Receipt Line";
        ReceiptHeader: Record "Receipt Header";
        AccType: Record "Account Type";
        LineAmount: Decimal;
        RunBal: Decimal;
        LoanApp: Record "Loan Application";
        RegFee: Decimal;
        ContAmount: Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        DetailedVend: Record "Detailed Vendor Ledg. Entry";
        GlobalSetup: Record "Global Setup";
        RegFeeCode: code[50];
        Memb: Record Member;
        vendorL: Record "Vendor Ledger Entry";
    begin
        with ReceiptLine do begin
            ReceiptHeader.Get("Document No.");
            ReceiptHeader.TestField("Member No.");
            RunBal := ReceiptHeader.Amount;

            ReceiptLine2.SetRange("Document No.", "Document No.");
            ReceiptLine2.DeleteAll();

            TransactionTypeCodeSetup.Get();
            GlobalSetup.Get();

            //Recover Registration fee
            if Memb.Get(ReceiptHeader."Member No.") then begin

                if Memb."Created Date" > GlobalSetup."Registration Fee Limit Date" then begin

                    Vendor.Reset();
                    Vendor.SetRange(Vendor."Member No.", ReceiptHeader."Member No.");
                    if Vendor.FindSet() then begin
                        repeat
                            AccType.Reset();
                            AccType.SetRange(AccType.Code, Vendor."Account Type");
                            AccType.SetRange(AccType."Sub Type", AccType."Sub Type"::Virtual);
                            if AccType.FindFirst then begin
                                RegFeeCode := TransactionTypeCodeSetup."Registration Fee";



                                // DetailedVend."Vendor Ledger Entry No.";
                                vendorL.Reset();
                                vendorL.SetFilter(reversed, '%1', false);
                                vendorL.SetRange(vendorL."Vendor No.", Vendor."No.");
                                // vendorL.SetRange(vendorL.Amount, -200);
                                vendorL.SetFilter(vendorL.Amount, '%1|%2', -200, -500);
                                If vendorL.FindFirst() then begin
                                end else begin
                                    RegFee := GlobalSetup."Registration Fee";

                                    if RunBal > RegFee then begin
                                        RegFee := RegFee;
                                        RunBal -= RegFee;
                                    end else begin
                                        RegFee := RunBal;
                                        RunBal := 0;
                                    end;
                                    if RegFee > 0 then
                                        InsertReceiptLine(ReceiptHeader."No.", ReceiptHeader."Member No.", 2, Vendor."No.", RegFee);
                                end;
                            end;

                        until Vendor.Next() = 0;
                    end;
                end;
            end;
            //Recover Monthly contribution


            /*
             Vendor.Reset();
             Vendor.SetRange("Member No.", ReceiptHeader."Member No.");
             if Vendor.FindSet() then begin
                 repeat
                     AccType.Reset();
                     AccType.SetRange(AccType.Code, Vendor."Account Type");
                     if AccType.FindFirst then begin
                         if AccType.Type = AccType.Type::"Member Deposit" then begin
                             DetailedVend.Reset();
                             DetailedVend.SetRange("Vendor No.", Vendor."No.");
                             DetailedVend.SetRange("Posting Date", CalcDate('-CM', ReceiptHeader."Posting Date"), CalcDate('CM', ReceiptHeader."Posting Date"));
                             if DetailedVend.FindSet() then begin
                                 DetailedVend.CalcSums(Amount);
                                 ContAmount := -DetailedVend.Amount;
                                 if ContAmount < GlobalSetup."Monthly deposit contribution" then begin
                                     ContAmount := GlobalSetup."Monthly deposit contribution" - ContAmount;
                                     if RunBal > ContAmount then begin
                                         ContAmount := ContAmount;
                                         RunBal -= ContAmount;
                                     end else begin
                                         ContAmount := RunBal;
                                         RunBal := 0;
                                     end;
                                     if ContAmount > 0 then
                                         InsertReceiptLine(ReceiptHeader."No.", ReceiptHeader."Member No.", 2, Vendor."No.", ContAmount);
                                 end;
                             end else begin
                                 ContAmount := GlobalSetup."Monthly deposit contribution";
                                 if RunBal > ContAmount then begin
                                     ContAmount := ContAmount;
                                     RunBal -= ContAmount;
                                 end else begin
                                     ContAmount := RunBal;
                                     RunBal := 0;
                                 end;
                                 if ContAmount > 0 then
                                     InsertReceiptLine(ReceiptHeader."No.", ReceiptHeader."Member No.", 2, Vendor."No.", ContAmount);
                             end;
                         end;
                     end;
                 until Vendor.Next() = 0;
             end;*/
            //Get Loans
            Customer.Reset();
            Customer.SetRange("Member No.", ReceiptHeader."Member No.");
            if Customer.FindSet() then begin
                repeat
                    Customer.CalcFields(Customer.Balance);
                    if Customer.Balance > 0 then begin
                        GlobalManagement.CalculateLoanArrearsAndOverpayment(Customer."No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4],
                                                                             AmountOverpaid[1], AmountOverpaid[2]);
                        LineAmount := (ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4]);
                        LoanApp.Reset();
                        LoanApp.SetRange(LoanApp."No.", Customer."No.");
                        if LoanApp.FindFirst then begin
                            if LoanApp."Date of Completion" <> 0D then
                                if LoanApp."Date of Completion" < Today then
                                    LineAmount := Customer.Balance;
                        end;

                        if RunBal > LineAmount then begin
                            LineAmount := LineAmount;
                            RunBal -= LineAmount;
                        end else begin
                            LineAmount := RunBal;
                            RunBal := 0;
                        end;

                        InsertReceiptLine(ReceiptHeader."No.", ReceiptHeader."Member No.", 1, Customer."No.", LineAmount);
                    end;

                until Customer.Next() = 0;
            end;
            //Get Deposits
            Vendor.Reset();
            Vendor.SetRange("Member No.", ReceiptHeader."Member No.");
            if Vendor.FindSet() then begin
                repeat
                    AccType.Reset();
                    AccType.SetRange(AccType.Code, Vendor."Account Type");
                    if AccType.FindFirst then begin
                        if AccType.Type = AccType.Type::"Member Deposit" then
                            if RunBal > 0 then
                                InsertReceiptLine(ReceiptHeader."No.", ReceiptHeader."Member No.", 2, Vendor."No.", RunBal);
                    end;
                until Vendor.Next() = 0;
            end;
        end;
    end;

    procedure InsertReceiptLine(DocumentNo: Code[20]; MemberNo: Code[20]; AccountType: Integer; AccountNo: Code[20]; LineAmount: Decimal)
    var
        ReceiptLine2: Record "Receipt Line";
        Member: Record Member;
    begin

        ReceiptLine2."Document No." := DocumentNo;
        ReceiptLine2."Line No." := GetLastReceiptLineNo(DocumentNo) + 10000;
        Member.Get(MemberNo);
        ReceiptLine2."Member No." := Member."No.";
        ReceiptLine2."Member Name" := Member."Full Name";
        ReceiptLine2."Account Type" := AccountType;
        ReceiptLine2."Account No." := AccountNo;
        ReceiptLine2.validate("Account Type", AccountType);
        ReceiptLine2.Validate("Account No.", AccountNo);
        ReceiptLine2."Line Amount" := LineAmount;
        ReceiptLine2.Insert();
    end;

    local procedure GetLastReceiptLineNo(DocumentNo: Code[20]): integer;
    var
        ReceiptLine2: Record "Receipt Line";
    begin
        ReceiptLine2.SetRange("Document No.", DocumentNo);
        if ReceiptLine2.FindLast() then
            exit(ReceiptLine2."Line No.")
        else
            exit(0);
    end;

    procedure ReverseReceiptVoucher(var ReceiptHeader: Record "Receipt Header")
    var

    begin
        with ReceiptHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            if Modify() then
                Message(ReceiptVoucherReversalSuccessMsg, "No.");
        end;
    end;

    procedure ReverseCheckoffReceiptVoucher(var CheckoffReceiptHeader: Record "Checkoff Receipt Header")
    var

    begin
        with CheckoffReceiptHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            if Modify() then
                Message(CheckoffReceiptVoucherReversalSuccessMsg, "No.");
        end;
    end;

    procedure ReverseLoanRecovery(var LoanRecovHeader: Record "Loan Recovery Header")
    var

    begin
        with LoanRecovHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            "Reversed By" := UserId;
            "Reversed Date" := Today;
            "Reversed Time" := Time;
            if Modify() then
                Message(LoanRecovReversalSuccessMsg, "No.");
        end;
    end;

    procedure ReverseCheckoff(var CheckoffHeader: Record "Checkoff Header")
    var

    begin
        with CheckoffHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            "Reversed By" := UserId;
            "Reversed Date" := Today;
            "Reversed Time" := Time;
            if Modify() then
                Message(CheckoffReversalSuccessMsg, "No.");
        end;
    end;

    procedure ReversePettyCashVoucher(var PettyCashHeader: Record "PettyCash Header")
    var

    begin
        with PettyCashHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            if Modify() then
                Message(PettyCashReversalSuccessMsg, "No.");
        end;
    end;

    local procedure GetLastPettyCashLineNo(DocumentNo: Code[20]): integer;
    var
        PettyCashLine2: Record "PettyCash Line";
    begin
        PettyCashLine2.SetRange("Document No.", DocumentNo);
        if PettyCashLine2.FindLast() then
            exit(PettyCashLine2."Line No.")
        else
            exit(0);
    end;

    procedure SuggestPettyCashLines(PettyCashLine: Record "PettyCash Line")
    var
        PettyCashLine2: Record "PettyCash Line";
        PettyCashHeader: Record "PettyCash Header";
        AppliesToDocNo: Code[20];
        RemainingAmount: Decimal;
    begin
        with PettyCashLine do begin

            PettyCashHeader.Get("Document No.");
            PettyCashHeader.TestField("Vendor No.");
            GetAppliesToDocVendorInfo(PettyCashHeader."Vendor No.", AppliesToDocNo, RemainingAmount);

            PettyCashLine2.Reset();
            PettyCashLine2.SetRange("Document No.", "Document No.");
            //PettyCashLine2.SetRange("Applies to Doc. No", AppliesToDocNo);
            PettyCashLine2.DeleteAll();

            InsertPettyCashLine("Document No.", PettyCashHeader."Vendor No.", AppliesToDocNo, RemainingAmount);
        end;
    end;

    procedure InsertPettyCashLine(DocumentNo: Code[20]; VendorNo: Code[20]; AppliesToDocNo: Code[20]; LineAmount: Decimal)
    var
        PettyCashLine2: Record "PettyCash Line";
    begin
        PettyCashLine2."Document No." := DocumentNo;
        PettyCashLine2."Line No." := GetLastPettyCashLineNo(DocumentNo) + 10000;
        PettyCashLine2."Account Type" := PettyCashLine2."Account Type"::Vendor;
        Vendor.Get(VendorNo);
        PettyCashLine2."Account No." := VendorNo;
        PettyCashLine2."Account Name" := Vendor.Name;
        PettyCashLine2.Description := Vendor.Name;
        PettyCashLine2."Line Amount" := abs(LineAmount);
        PettyCashLine2."Applies to Doc Type" := PettyCashLine2."Applies to Doc Type"::Invoice;
        PettyCashLine2."Applies to Doc. No" := AppliesToDocNo;
        PettyCashLine2.Insert();
    end;

    procedure GetPostedCheckoffReceiptVoucher(var CheckoffReceiptHeader: Record "Checkoff Receipt Header")
    var
        CheckoffReceiptHeader2: Record "Checkoff Receipt Header";
        CheckoffReceiptHeader3: Record "Checkoff Receipt Header";
        CheckoffReceiptLine: Record "Checkoff Receipt Line";
        CheckoffReceiptLine2: Record "Checkoff Receipt Line";
    begin
        with CheckoffReceiptHeader do begin
            CheckoffReceiptHeader2.Reset();
            CheckoffReceiptHeader2.SetRange(Posted, true);
            //CheckoffReceiptHeader2.SetRange(Reversed, true);
            IF PAGE.RUNMODAL(0, CheckoffReceiptHeader2) = ACTION::LookupOK THEN begin
                CheckoffReceiptHeader3.Init();
                CheckoffReceiptHeader3.TransferFields(CheckoffReceiptHeader2, true);
                CheckoffReceiptHeader3."No." := "No.";
                CheckoffReceiptHeader3.Posted := false;
                Delete();
                CheckoffReceiptHeader3.Insert();

                CheckoffReceiptLine2.Reset();
                CheckoffReceiptLine2.SetRange("Document No.", "No.");
                CheckoffReceiptLine2.DeleteAll();

                CheckoffReceiptLine.Reset();
                CheckoffReceiptLine.SetRange("Document No.", CheckoffReceiptHeader2."No.");
                if CheckoffReceiptLine.FindSet() then begin
                    repeat
                        CheckoffReceiptLine2.TransferFields(CheckoffReceiptLine);
                        CheckoffReceiptLine2."Document No." := CheckoffReceiptHeader3."No.";
                        CheckoffReceiptLine2.Insert();
                    until CheckoffReceiptLine.Next() = 0;
                end;

                Page.Run(50630, CheckoffReceiptHeader3);
            END;
        end;
    end;

    procedure GetPostedCheckoff(var CheckoffHeader: Record "Checkoff Header")
    var
        CheckoffHeader2: Record "Checkoff Header";
        CheckoffHeader3: Record "Checkoff Header";
        CheckoffLine: Record "Checkoff Line";
        CheckoffLine2: Record "Checkoff Line";
    begin
        with CheckoffHeader do begin
            CheckoffHeader2.Reset();
            CheckoffHeader2.SetRange(Posted, true);
            //CheckoffHeader2.SetRange(Reversed, true);
            IF PAGE.RUNMODAL(0, CheckoffHeader2) = ACTION::LookupOK THEN begin
                CheckoffHeader3.Init();
                CheckoffHeader3.TransferFields(CheckoffHeader2, true);
                CheckoffHeader3."No." := "No.";
                CheckoffHeader3.Reversed := false;
                CheckoffHeader3."Reversed By" := '';
                CheckoffHeader3."Reversed Date" := 0D;
                CheckoffHeader3."Reversed Time" := 0T;
                CheckoffHeader3.Posted := false;
                CheckoffHeader3."Posted By" := '';
                CheckoffHeader3."Posted Date" := 0D;
                CheckoffHeader3."Posted Time" := 0T;
                CheckoffHeader3."Created By" := USERID;
                CheckoffHeader3."Created Date" := Today;
                CheckoffHeader3."Created Time" := time;
                Delete();
                CheckoffHeader3.Insert();

                CheckoffLine2.Reset();
                CheckoffLine2.SetRange("Document No.", "No.");
                CheckoffLine2.DeleteAll();

                CheckoffLine.Reset();
                CheckoffLine.SetRange("Document No.", CheckoffHeader2."No.");
                if CheckoffLine.FindSet() then begin
                    repeat
                        CheckoffLine2.TransferFields(CheckoffLine);
                        CheckoffLine2."Document No." := CheckoffHeader3."No.";
                        CheckoffLine2.Insert();
                    until CheckoffLine.Next() = 0;
                end;

                Page.Run(50660, CheckoffHeader3);
            END;
        end;
    end;

    procedure ValidateCheckoffLines(var CheckoffHeader: Record "Checkoff Header")
    var
        CheckoffLine: Record "Checkoff Line";
        AccType: Record "Account Type";
        GlobalSetup: Record "Global Setup";
        RemittanceAgentSetup: Record "Remittance Agent Setup";
    begin
        with CheckoffHeader do begin
            CheckoffLine.Reset();
            CheckoffLine.SetRange("Document No.", "No.");
            if CheckoffLine.FindSet() then begin
                repeat
                    RemittanceAgentSetup.Get("Agent Code");
                    If CheckoffLine."Reference Code" = '' then begin
                        GlobalSetup.Get();
                        CheckoffLine."Account Type" := CheckoffLine."Account Type"::"G/L Account";
                        If RemittanceAgentSetup."Controll Account No." <> '' then
                            CheckoffLine."Account No." := RemittanceAgentSetup."Controll Account No."
                        else
                            CheckoffLine."Account No." := GlobalSetup."Unallocated Payments G/L";
                    end else begin
                        IF CheckoffLine."Member No." = 'SUSPENSE' then begin
                            CheckoffLine."Account Type" := CheckoffLine."Account Type"::"G/L Account";
                            If RemittanceAgentSetup."Controll Account No." <> '' then
                                CheckoffLine."Account No." := RemittanceAgentSetup."Controll Account No."
                            else
                                CheckoffLine."Account No." := GlobalSetup."Unallocated Payments G/L";
                        end;
                        if AccType.Get(CheckoffLine."Reference Code") then
                            CheckoffLine."Account Type" := CheckoffLine."Account Type"::Vendor
                        else
                            CheckoffLine."Account Type" := CheckoffLine."Account Type"::Customer;
                    end;
                    if CheckoffLine."Account Type" = CheckoffLine."Account Type"::Vendor then begin
                        CheckoffLine."Account No." := GetCheckoffVendorNo(CheckoffLine."Member No.", CheckoffLine."Reference Code");

                    end;
                    if CheckoffLine."Account Type" = CheckoffLine."Account Type"::Customer then begin
                        if GetCheckoffLoanNo(CheckoffLine."Member No.", CheckoffLine."Reference Code") <> '' then begin
                            CheckoffLine."Account No." := GetCheckoffLoanNo(CheckoffLine."Member No.", CheckoffLine."Reference Code");
                        end else begin
                            CheckoffLine."Account Type" := CheckoffLine."Account Type"::Vendor;
                            AccType.Reset();
                            AccType.SetRange(AccType.Type, AccType.Type::"Member Deposit");
                            if AccType.FindFirst then begin
                                CheckoffLine."Reference Code" := AccType.Code;
                            end;
                            CheckoffLine."Account No." := GetCheckoffVendorNo(CheckoffLine."Member No.", CheckoffLine."Reference Code");
                        end;
                    end;
                    CheckoffLine.Validate("Account No.");
                    CheckoffLine.Modify();
                until CheckoffLine.Next() = 0;
            end;
        end;
    end;

    local procedure GetCheckoffLoanNo(MemberNo: Code[20]; LoanProductType: Code[20]): Code[20]
    var

    begin
        if GetNoofLoansWithBalance(MemberNo, LoanProductType) >= 1 then begin
            Customer.Reset();
            Customer.SetRange("Member No.", MemberNo);
            Customer.SetRange(Customer."Customer Posting Group", LoanProductType);
            Customer.SetFilter(Balance, '>%1', 0);
            if Customer.FindFirst() then begin
                Customer.CalcFields(Customer.Balance);
                exit(Customer."No.")
            end;
        end else begin
            Error('Member %1 Allocated loan product %2 either does not exist or balance is less or equal to zero', MemberNo, LoanProductType);
        end;
    end;

    procedure GetNoofLoansWithBalance(MemberNo: Code[20]; LoanProductType: Code[20]): Integer
    var
        i: Integer;
    begin
        i := 0;
        Customer.Reset();
        Customer.SetRange("Member No.", MemberNo);
        Customer.SetRange(Customer."Customer Posting Group", LoanProductType);
        if Customer.FindSet() then begin
            repeat
                Customer.CalcFields("Balance (LCY)");
                if Customer."Balance (LCY)" > 0 then
                    i += 1;
            until Customer.Next() = 0;
        end;
        exit(i);
    end;

    local procedure GetCheckoffVendorNo(MemberNo: Code[20]; AccountTypeCode: Code[20]): Code[20]
    var
        AccountTypeRec: Record "Account Type";
    begin
        AccountTypeRec.Reset();

        Vendor.Reset();
        Vendor.SetRange("Member No.", MemberNo);
        Vendor.SetRange("Account Type", AccountTypeCode);
        if Vendor.FindFirst() then
            exit(Vendor."No.");
    end;
}

