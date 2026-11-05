codeunit 50023 "Global Management"
{
    trigger OnRun()
    begin

    end;

    procedure IsNumeric(Variant: Code[20]): Integer
    var
        j: Integer;
    begin
        FOR i := 1 TO STRLEN(Variant) DO BEGIN
            IF NOT (Variant[i] IN ['0' .. '9', '+']) THEN
                j += 1;
        END;
        EXIT(j);
    end;

    procedure IsValidEmail(EmailAddress: Code[30]): Boolean
    var
        Email: Code[20];
        Regex: DotNet Regex;
        RegexOptions: DotNet RegexOptions;
        Pattern: Text[50];
        Result: Boolean;
    begin
        Pattern := '^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$';

        RegexOptions := 0;
        RegexOptions := RegexOptions.Parse(RegexOptions.GetType(), 'IgnoreCase');

        Result := Regex.IsMatch(EmailAddress, Pattern, RegexOptions);

        EXIT(Result);
    end;

    procedure CreateSMSEntry(PhoneNo: Code[20]; SMSText: BigText; SourceCode: Code[20])
    var
        SMSEntry: Record "SMS Entry";
        SMSEntry2: Record "SMS Entry";
        EntryNo: Integer;
        Ostream: OutStream;
    begin
        SMSEntry.INIT;
        IF SMSEntry2.FINDLAST THEN
            EntryNo := SMSEntry2."Entry No."
        ELSE
            EntryNo := 0;
        SMSEntry."Entry No." := EntryNo + 1;
        SMSEntry."Phone No." := PhoneNo;
        SMSEntry."SMS Text".CREATEOUTSTREAM(Ostream);
        SMSText.WRITE(Ostream);
        SMSEntry."Created Date" := TODAY;
        SMSEntry."Created Time" := TIME;
        SMSEntry."Source Code" := SourceCode;
        IF SMSEntry."Phone No." <> '' then
            SMSEntry.INSERT;
    end;

    procedure GetLastJournalLineNo(JournalTemplateName: Code[20]; JournalBatchName: Code[20]) LineNo: Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJournalLine.FINDLAST THEN
            LineNo := GenJournalLine."Line No."
        ELSE
            LineNo := 0;
        EXIT(LineNo);
    end;

    procedure CreateJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; AccountTypeEnum: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; Description: Text[1000]; Amount: Decimal; PostingGroup: Code[20]; TransactionTypeCode: Code[20]; SourceCode: Code[20]; GlobalDimensionCode: Code[20]; BalAccountTypeEnum: Enum "Gen. Journal Account Type"; BalAccountNo: Code[20]; ApplyToDocType: Enum "Gen. Journal Document Type"; AppliesToDocNo: Code[20]; MemberNo: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Cust: Record Customer;
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplateName;
        GenJournalLine."Journal Batch Name" := JournalBatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Line No." := GetLastJournalLineNo(JournalTemplateName, JournalBatchName) + 10000;
        GenJournalLine.Description := Description;
        GenJournalLine."Account Type" := AccountTypeEnum;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine."Account No. 2" := AccountNo;
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Member No" := MemberNo;
        GenJournalLine."Posting Group" := PostingGroup;
        GenJournalLine."Transaction Type Code" := TransactionTypeCode;
        GenJournalLine."Source Code" := SourceCode;
        GenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        // GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJournalLine."Bal. Account Type" := BalAccountTypeEnum;
        GenJournalLine."Bal. Account No." := BalAccountNo;
        GenJournalLine."Applies-to Doc. Type" := ApplyToDocType;
        GenJournalLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(Amount);
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure CreateLoanIntJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; AccountTypeEnum: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; Description: Text[100]; Amount: Decimal; PostingGroup: Code[20]; TransactionTypeCode: Code[20]; SourceCode: Code[20]; GlobalDimensionCode: Code[20]; BalAccountTypeEnum: Enum "Gen. Journal Account Type"; BalAccountNo: Code[20]; ApplyToDocType: Enum "Gen. Journal Document Type"; AppliesToDocNo: Code[20]; MemberNo: Code[30]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        // Message('Member No %1 Amount %2', MemberNo, Amount);
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplateName;
        GenJournalLine."Journal Batch Name" := JournalBatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Member No" := MemberNo;
        GenJournalLine."Line No." := GetLastJournalLineNo(JournalTemplateName, JournalBatchName) + 10000;
        GenJournalLine.Description := Description;
        GenJournalLine."Account Type" := AccountTypeEnum;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Posting Group" := PostingGroup;
        GenJournalLine."Transaction Type Code" := TransactionTypeCode;
        GenJournalLine."Source Code" := SourceCode;
        GenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        // GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJournalLine."Bal. Account Type" := BalAccountTypeEnum;
        GenJournalLine."Bal. Account No." := BalAccountNo;
        GenJournalLine."Applies-to Doc. Type" := ApplyToDocType;
        GenJournalLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(Amount);
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure PostJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJournalLine.FINDSET THEN BEGIN
            COMMIT;
            IF GenJnlPostBatch.RUN(GenJournalLine) THEN
                EXIT(TRUE)
            ELSE
                EXIT(false);
        END;
    end;

    procedure ClearJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJournalLine.DELETEALL;
    end;

    procedure GetAccountBalance(AccountTypeEnum: Enum "Gen. Journal Account Type"; AccountNo: Code[20]): Decimal
    var
        AccountType: Record "Account Type";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        BankAccount: Record "Bank Account";
        GLAccount: Record "G/L Account";
        AccountBalance: Decimal;
    begin
        CASE AccountTypeEnum OF
            AccountTypeEnum::"G/L Account":
                BEGIN
                    IF GLAccount.GET(AccountNo) THEN BEGIN
                        GLAccount.CALCFIELDS(Balance);
                        AccountBalance := ABS(GLAccount.Balance);
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;
            AccountTypeEnum::Customer:
                BEGIN
                    IF Customer.GET(AccountNo) THEN BEGIN
                        Customer.CALCFIELDS("Balance (LCY)");
                        AccountBalance := (Customer."Balance (LCY)");
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;
            AccountTypeEnum::Vendor:
                BEGIN
                    IF Vendor.GET(AccountNo) THEN BEGIN
                        Vendor.CALCFIELDS("Balance (LCY)");
                        IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                            AccountBalance := ABS(Vendor."Balance (LCY)") - AccountType."Minimum Balance";
                            IF AccountBalance <= 0 THEN
                                AccountBalance := 0;
                        END else
                            AccountBalance := ABS(Vendor."Balance (LCY)");

                    end;
                    exit(AccountBalance);
                END;

            AccountTypeEnum::"Bank Account":
                BEGIN
                    IF BankAccount.GET(AccountNo) THEN BEGIN
                        BankAccount.CALCFIELDS("Balance (LCY)");
                        AccountBalance := ABS(BankAccount."Balance (LCY)");
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;

        END;
    end;

    procedure GetAccountBalanceDividend(AccountTypeEnum: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; CalcEndDate: Date): Decimal
    var
        AccountType: Record "Account Type";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        BankAccount: Record "Bank Account";
        GLAccount: Record "G/L Account";
        AccountBalance: Decimal;
        DVend: Record "Detailed Vendor Ledg. Entry";
        DFilter: Text;
    begin
        CASE AccountTypeEnum OF
            AccountTypeEnum::"G/L Account":
                BEGIN
                    IF GLAccount.GET(AccountNo) THEN BEGIN
                        GLAccount.CALCFIELDS(Balance);
                        AccountBalance := ABS(GLAccount.Balance);
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;
            AccountTypeEnum::Customer:
                BEGIN
                    IF Customer.GET(AccountNo) THEN BEGIN
                        Customer.CALCFIELDS("Balance (LCY)");
                        AccountBalance := (Customer."Balance (LCY)");
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;
            AccountTypeEnum::Vendor:
                BEGIN
                    DFilter := '..' + Format(CalcEndDate);
                    IF Vendor.GET(AccountNo) THEN BEGIN
                        DVend.Reset();
                        DVend.SetRange("Vendor No.", Vendor."No.");
                        DVend.SetFilter("Posting Date", DFilter);
                        if DVend.FindSet() then begin
                            DVend.CalcSums(Amount);
                            AccountBalance := Abs(DVend.Amount);
                        end;
                    end;
                    exit(AccountBalance);
                END;

            AccountTypeEnum::"Bank Account":
                BEGIN
                    IF BankAccount.GET(AccountNo) THEN BEGIN
                        BankAccount.CALCFIELDS("Balance (LCY)");
                        AccountBalance := ABS(BankAccount."Balance (LCY)");
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;

        END;
    end;

    procedure GetAccountFilteredBalanceDividend(AccountTypeEnum: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; Dfilter: Text): Decimal
    var
        AccountType: Record "Account Type";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        BankAccount: Record "Bank Account";
        GLAccount: Record "G/L Account";
        AccountBalance: Decimal;
        DVend: Record "Detailed Vendor Ledg. Entry";
    //DFilter: Text;
    begin
        CASE AccountTypeEnum OF
            AccountTypeEnum::"G/L Account":
                BEGIN
                    IF GLAccount.GET(AccountNo) THEN BEGIN
                        GLAccount.CALCFIELDS(Balance);
                        AccountBalance := ABS(GLAccount.Balance);
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;
            AccountTypeEnum::Customer:
                BEGIN
                    IF Customer.GET(AccountNo) THEN BEGIN
                        Customer.CALCFIELDS("Balance (LCY)");
                        AccountBalance := (Customer."Balance (LCY)");
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;
            AccountTypeEnum::Vendor:
                BEGIN
                    IF Vendor.GET(AccountNo) THEN BEGIN
                        Vendor.SetFilter("Date Filter", Dfilter);
                        Vendor.Calcfields("Net Change");
                        /*DVend.Reset();
                        DVend.SetRange("Vendor No.", Vendor."No.");
                        DVend.SetFilter("Posting Date", DFilter);
                        if DVend.FindSet() then begin
                            DVend.CalcSums(Amount);
                            AccountBalance := Abs(DVend.Amount);
                        end;*/
                        AccountBalance := Vendor."Net Change";
                    end;
                    exit(AccountBalance);
                END;

            AccountTypeEnum::"Bank Account":
                BEGIN
                    IF BankAccount.GET(AccountNo) THEN BEGIN
                        BankAccount.CALCFIELDS("Balance (LCY)");
                        AccountBalance := ABS(BankAccount."Balance (LCY)");
                        IF AccountBalance <= 0 THEN
                            AccountBalance := 0;
                    END;
                    exit(AccountBalance);
                END;

        END;
    end;

    procedure GetBranchCode(MemberNo: Code[20]): Code[20]
    var
        Member: Record "Member";
    begin
        Member.GET(MemberNo);
        EXIT(Member."Global Dimension 1 Code");
    end;

    procedure GetMemberDepositsAcc(MemberNo: Code[20]): Code[20]
    var
        AccTypes: Record "Account Type";
        Vendor: Record Vendor;
        DepAccNo: code[20];
    begin
        DepAccNo := '';
        AccTypes.Reset();
        AccTypes.SetRange(Type, AccTypes.Type::"Member Deposit");
        If AccTypes.FindFirst() then begin
            Vendor.Reset();
            Vendor.SetRange("Member No.", MemberNo);
            Vendor.SetRange("Account Type", AccTypes.Code);
            if Vendor.FindFirst() then begin
                DepAccNo := Vendor."No.";
            end;
        end;
        If DepAccNo <> '' then
            Exit(DepAccNo)
        else
            exit(DepAccNo);
    end;

    procedure GetMemberSharesAcc(MemberNo: Code[20]): Code[20]
    var
        AccTypes: Record "Account Type";
        Vendor: Record Vendor;
        sharesAccNo: code[20];
    begin
        sharesAccNo := '';
        AccTypes.Reset();
        AccTypes.SetRange(Type, AccTypes.Type::"Share Capital");
        If AccTypes.FindFirst() then begin
            Vendor.Reset();
            Vendor.SetRange("Member No.", MemberNo);
            Vendor.SetRange("Account Type", AccTypes.Code);
            if Vendor.FindFirst() then begin
                sharesAccNo := Vendor."No.";
            end;
        end;
        If sharesAccNo <> '' then
            Exit(sharesAccNo)
        else
            exit(sharesAccNo);
    end;

    procedure CreateJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; AccountTypeEnum: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; Description: Text[100]; Amount: Decimal; PostingGroup: Code[20]; TransactionTypeCode: Code[20]; SourceCode: Code[20]; GlobalDimensionCode: Code[20]; BalAccountTypeEnum: Enum "Gen. Journal Account Type"; BalAccountNo: Code[20]; ApplyToDocType: Enum "Gen. Journal Document Type"; AppliesToDocNo: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Cust: Record Customer;
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplateName;
        GenJournalLine."Journal Batch Name" := JournalBatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Line No." := GetLastJournalLineNo(JournalTemplateName, JournalBatchName) + 10000;
        GenJournalLine.Description := Description;
        GenJournalLine."Account Type" := AccountTypeEnum;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine."Account No. 2" := AccountNo;
        GenJournalLine.VALIDATE("Account No.");
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
            Cust.Get(AccountNo);
            GenJournalLine."Member No" := Cust."Member No.";
        end;
        GenJournalLine."Posting Group" := PostingGroup;
        GenJournalLine."Transaction Type Code" := TransactionTypeCode;
        GenJournalLine."Source Code" := SourceCode;
        GenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        // GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJournalLine."Bal. Account Type" := BalAccountTypeEnum;
        GenJournalLine."Bal. Account No." := BalAccountNo;
        GenJournalLine."Applies-to Doc. Type" := ApplyToDocType;
        GenJournalLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(Amount);
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure CalculateLoanPrepayment(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var Prepayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
    begin
        TransactionTypeCodeSetup.Get();

        Cust.Reset;
        Cust.SetRange(Cust."No.", LoanNo);
        if Cust.FindFirst THEN BEGIN
            DetailedCustLedger.Reset();
            DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
            DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
            if DetailedCustLedger.FindFirst then begin
                repeat
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" THEN
                        Prepayment += DetailedCustLedger.Amount;
                until DetailedCustLedger.Next = 0;
            end;
        END;
    end;

    procedure CalculateLoanArrearsAndOverpayment(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalArrears: Decimal; var InterestArrears: Decimal; var LedgerFeeArrears: Decimal; var PenaltyArrears: Decimal; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PrePay: Decimal;
        PrePayBal: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
        CustLedger: Record "Cust. Ledger Entry";
    begin
        InterestDue := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;
        PrePay := 0;
        PrePayBal := 0;

        PrincipalArrears := 0;
        InterestArrears := 0;
        LedgerFeeArrears := 0;
        PenaltyArrears := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;

        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        If Loan.Get(LoanNo) then begin
            Loan.CalcFields("Outstanding Balance");
            if Today < Loan."Date of Completion" then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', EndDate);
                if LoanRepaymentSchedule.FindSet then begin
                    LoanRepaymentSchedule.CalcSums("Principal Installment");
                    PrincipalDue := Round(LoanRepaymentSchedule."Principal Installment");
                end;
            end else begin
                PrincipalDue := Loan."Approved Amount";
            end;
            //Message('PrincipalDue %1', PrincipalDue);

            Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                Cust.CalcFields(Cust.Balance);
                //if Cust.Balance > 0 THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindFirst then begin
                    repeat
                        CustLedger.get(DetailedCustLedger."Cust. Ledger Entry No.");
                        If CustLedger.Reversed = false then begin
                            IF (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") and (DetailedCustLedger."Credit Amount" <> 0) THEN BEGIN
                                DetailedCustLedger."Transaction Type Code" := TransactionTypeCodeSetup."Principal Paid";
                                DetailedCustLedger.Modify();
                            END;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                                PrincipalPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                                InterestDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                                InterestPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                                LedgerFeeDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                                LedgerFeePaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                                PenaltyDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                                PenaltyPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" THEN
                                PrePay += DetailedCustLedger.Amount;
                        end;
                    until DetailedCustLedger.Next = 0;
                end;
                //Message('Princ due %1 Princ Paid %2', PrincipalDue, PrincipalPaid);
                //END;
            END;

            IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
                PrincipalArrears := PrincipalDue - ABS(PrincipalPaid);
                PrincipalOverpayment := 0;
            END ELSE BEGIN
                PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
                PrincipalArrears := 0;
            END;
            IF ABS(InterestDue) > ABS(InterestPaid) THEN BEGIN
                InterestArrears := ABS(InterestDue) - ABS(InterestPaid);
                InterestOverpayment := 0;
            END ELSE BEGIN
                InterestOverpayment := ABS(InterestPaid) - ABS(InterestDue);
                InterestArrears := 0;
            END;
            IF ABS(LedgerFeeDue) > ABS(LedgerFeePaid) THEN
                LedgerFeeArrears := ABS(LedgerFeeDue) - ABS(LedgerFeePaid)
            else
                LedgerFeeArrears := 0;
            IF ABS(PenaltyDue) > ABS(PenaltyPaid) THEN
                PenaltyArrears := ABS(PenaltyDue) - ABS(PenaltyPaid)
            else
                PenaltyArrears := 0;

            if PrePay > 0 then
                PrePay := 0
            else
                PrePay := PrePay;

            IF ABS(PrePay) > 0 then begin
                PrePayBal := ABS(PrePay);
                If PrePayBal > 0 then begin
                    If PrePayBal >= InterestArrears then begin
                        InterestArrears := 0;
                        PrePayBal := PrePayBal - InterestArrears;
                    end else begin
                        InterestArrears := InterestArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= LedgerFeeArrears then begin
                        LedgerFeeArrears := 0;
                        PrePayBal := PrePayBal - LedgerFeeArrears;
                    end else begin
                        LedgerFeeArrears := LedgerFeeArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= PenaltyArrears then begin
                        PenaltyArrears := 0;
                        PrePayBal := PrePayBal - PenaltyArrears;
                    end else begin
                        PenaltyArrears := PenaltyArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= PrincipalArrears then begin
                        PrincipalArrears := 0;
                        PrePayBal := PrePayBal - PrincipalArrears;
                    end else begin
                        PrincipalArrears := PrincipalArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
            end;
            if Loan."Outstanding Balance" <= 0 then begin
                PrincipalArrears := 0;
                InterestArrears := 0;
                LedgerFeeArrears := 0;
                PenaltyArrears := 0;
            end;
        end;
    end;

    procedure CalculateLoanArrearsAndOverpaymentPrepayment(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalArrears: Decimal; var InterestArrears: Decimal; var LedgerFeeArrears: Decimal; var PenaltyArrears: Decimal; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PrePay: Decimal;
        PrePayBal: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
        CustLedger: Record "Cust. Ledger Entry";
    begin
        InterestDue := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;
        PrePay := 0;
        PrePayBal := 0;

        PrincipalArrears := 0;
        InterestArrears := 0;
        LedgerFeeArrears := 0;
        PenaltyArrears := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;

        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        If Loan.Get(LoanNo) then begin
            Loan.CalcFields("Outstanding Balance");
            if Today < Loan."Date of Completion" then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', EndDate);
                if LoanRepaymentSchedule.FindSet then begin
                    LoanRepaymentSchedule.CalcSums("Principal Installment");
                    PrincipalDue := Round(LoanRepaymentSchedule."Principal Installment");
                end;
            end else begin
                PrincipalDue := Loan."Approved Amount";
            end;
            //Message('PrincipalDue %1', PrincipalDue);

            Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                Cust.CalcFields(Cust.Balance);
                //if Cust.Balance > 0 THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindFirst then begin
                    repeat
                        CustLedger.get(DetailedCustLedger."Cust. Ledger Entry No.");
                        If CustLedger.Reversed = false then begin
                            IF (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") and (DetailedCustLedger."Credit Amount" <> 0) THEN BEGIN
                                DetailedCustLedger."Transaction Type Code" := TransactionTypeCodeSetup."Principal Paid";
                                DetailedCustLedger.Modify();
                            END;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                                PrincipalPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                                InterestDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                                InterestPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                                LedgerFeeDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                                LedgerFeePaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                                PenaltyDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                                PenaltyPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" THEN
                                PrePay += DetailedCustLedger.Amount;
                        end;
                    until DetailedCustLedger.Next = 0;
                end;
            END;

            IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
                PrincipalArrears := PrincipalDue - ABS(PrincipalPaid);
                PrincipalOverpayment := 0;
            END ELSE BEGIN
                PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
                PrincipalArrears := 0;
            END;
            IF ABS(InterestDue) > ABS(InterestPaid) THEN BEGIN
                InterestArrears := ABS(InterestDue) - ABS(InterestPaid);
                InterestOverpayment := 0;
            END ELSE BEGIN
                InterestOverpayment := ABS(InterestPaid) - ABS(InterestDue);
                InterestArrears := 0;
            END;
            IF ABS(LedgerFeeDue) > ABS(LedgerFeePaid) THEN
                LedgerFeeArrears := ABS(LedgerFeeDue) - ABS(LedgerFeePaid)
            else
                LedgerFeeArrears := 0;
            IF ABS(PenaltyDue) > ABS(PenaltyPaid) THEN
                PenaltyArrears := ABS(PenaltyDue) - ABS(PenaltyPaid)
            else
                PenaltyArrears := 0;


            if Loan."Outstanding Balance" <= 0 then begin
                PrincipalArrears := 0;
                InterestArrears := 0;
                LedgerFeeArrears := 0;
                PenaltyArrears := 0;
            end;
        end;
    end;


    procedure CalculateLoanArrearsAndOverpaymentFactbox(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalArrears: Decimal; var InterestArrears: Decimal; var LedgerFeeArrears: Decimal; var PenaltyArrears: Decimal; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal; var LedgerFeeOverpayment: Decimal; var PenaltyOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PrePay: Decimal;
        PrePayBal: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
        CustLedger: record "Cust. Ledger Entry";
    begin
        InterestDue := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;
        PrePay := 0;
        PrePayBal := 0;

        PrincipalArrears := 0;
        InterestArrears := 0;
        LedgerFeeArrears := 0;
        PenaltyArrears := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;

        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        If Loan.Get(LoanNo) then begin
            Loan.CalcFields("Outstanding Balance");
            if EndDate < Loan."Date of Completion" then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', EndDate);
                if LoanRepaymentSchedule.FindSet then begin
                    LoanRepaymentSchedule.CalcSums("Principal Installment");
                    PrincipalDue := Round(LoanRepaymentSchedule."Principal Installment");
                end;
            end else begin
                PrincipalDue := Loan."Approved Amount";
            end;

            /*Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindSet then begin
                    repeat
                        if (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") AND (DetailedCustLedger.Amount <> Loan."Approved Amount") THEN
                            PrincipalDue += DetailedCustLedger.Amount;
                    until DetailedCustLedger.Next = 0;//
                end;
            END;*/

            StartDate := Loan."Disbursal Date";

            Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindSet then begin
                    repeat
                        CustLedger.get(DetailedCustLedger."Cust. Ledger Entry No.");
                        If CustLedger.Reversed = false then begin
                            IF (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") and (DetailedCustLedger."Credit Amount" <> 0) THEN BEGIN
                                DetailedCustLedger."Transaction Type Code" := TransactionTypeCodeSetup."Principal Paid";
                                DetailedCustLedger.Modify();
                            END;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                                PrincipalPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                                InterestDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                                InterestPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                                LedgerFeeDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                                LedgerFeePaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                                PenaltyDue += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                                PenaltyPaid += DetailedCustLedger.Amount;
                            IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" THEN
                                PrePay += DetailedCustLedger.Amount;
                        end;
                    until DetailedCustLedger.Next = 0;
                end;
            END;

            IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
                PrincipalArrears := PrincipalDue - ABS(PrincipalPaid);
                PrincipalOverpayment := 0;
            END ELSE BEGIN
                PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
                PrincipalArrears := 0;
            END;
            IF (InterestDue) > ABS(InterestPaid) THEN BEGIN
                InterestArrears := (InterestDue) - ABS(InterestPaid);
                InterestOverpayment := 0;
            END ELSE BEGIN
                InterestOverpayment := ABS(InterestPaid) - (InterestDue);
                InterestArrears := 0;
            END;
            IF (LedgerFeeDue) > ABS(LedgerFeePaid) THEN BEGIN
                LedgerFeeArrears := (LedgerFeeDue) - ABS(LedgerFeePaid);
                LedgerFeeOverpayment := 0;
            END ELSE BEGIN
                LedgerFeeOverpayment := ABS(LedgerFeePaid) - (LedgerFeeDue);
                LedgerFeeArrears := 0;
            END;
            IF (PenaltyDue) > ABS(PenaltyPaid) THEN BEGIN
                PenaltyArrears := (PenaltyDue) - ABS(PenaltyPaid);
                PenaltyOverpayment := 0;
            END ELSE BEGIN
                PenaltyOverpayment := ABS(PenaltyPaid) - (PenaltyDue);
                PenaltyArrears := 0;
            END;

            if PrePay > 0 then
                PrePay := 0
            else
                PrePay := PrePay;

            IF ABS(PrePay) > 0 then begin
                PrePayBal := ABS(PrePay);
                If PrePayBal > 0 then begin
                    If PrePayBal >= InterestArrears then begin
                        InterestArrears := 0;
                        PrePayBal := PrePayBal - InterestArrears;
                    end else begin
                        InterestArrears := InterestArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= LedgerFeeArrears then begin
                        LedgerFeeArrears := 0;
                        PrePayBal := PrePayBal - LedgerFeeArrears;
                    end else begin
                        LedgerFeeArrears := LedgerFeeArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= PenaltyArrears then begin
                        PenaltyArrears := 0;
                        PrePayBal := PrePayBal - PenaltyArrears;
                    end else begin
                        PenaltyArrears := PenaltyArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= PrincipalArrears then begin
                        PrincipalArrears := 0;
                        PrePayBal := PrePayBal - PrincipalArrears;
                    end else begin
                        PrincipalArrears := PrincipalArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
            end;
            if Loan."Outstanding Balance" <= 0 then begin
                PrincipalArrears := 0;
                InterestArrears := 0;
                LedgerFeeArrears := 0;
                PenaltyArrears := 0;
            end;
        end;
    end;

    procedure CalculateLoanArrearsAndOverpaymentCheckoffAdvice(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalArrears: Decimal; var InterestArrears: Decimal; var LedgerFeeArrears: Decimal; var PenaltyArrears: Decimal; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal; var LedgerFeeOverpayment: Decimal; var PenaltyOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PrePay: Decimal;
        PrePayBal: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
    begin
        InterestDue := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;
        PrePay := 0;
        PrePayBal := 0;

        PrincipalArrears := 0;
        InterestArrears := 0;
        LedgerFeeArrears := 0;
        PenaltyArrears := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;

        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        If Loan.Get(LoanNo) then begin
            Loan.CalcFields("Outstanding Balance");
            if EndDate < Loan."Date of Completion" then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', EndDate);
                if LoanRepaymentSchedule.Find('+') then begin
                    PrincipalArrears := Round(LoanRepaymentSchedule."Principal Installment");
                    InterestArrears := Round(LoanRepaymentSchedule."Interest Installment");
                end;
            end else begin
                PrincipalDue := Loan."Approved Amount";
            end;

            /*Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindSet then begin
                    repeat
                        if (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") AND (DetailedCustLedger.Amount <> Loan."Approved Amount") THEN
                            PrincipalDue += DetailedCustLedger.Amount;
                    until DetailedCustLedger.Next = 0;//
                end;
            END;



           Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindSet then begin
                    repeat
                        IF (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") and (DetailedCustLedger."Credit Amount" <> 0) THEN BEGIN
                            DetailedCustLedger."Transaction Type Code" := TransactionTypeCodeSetup."Principal Paid";
                            DetailedCustLedger.Modify();
                        END;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                            PrincipalPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                            InterestDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                            InterestPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                            LedgerFeeDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                            LedgerFeePaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                            PenaltyDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                            PenaltyPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" THEN
                            PrePay += DetailedCustLedger.Amount;
                    until DetailedCustLedger.Next = 0;
                end;
            END;

            IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
                PrincipalArrears := PrincipalDue - ABS(PrincipalPaid);
                PrincipalOverpayment := 0;
            END ELSE BEGIN
                PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
                PrincipalArrears := 0;
            END;
            IF (InterestDue) > ABS(InterestPaid) THEN BEGIN
                InterestArrears := (InterestDue) - ABS(InterestPaid);
                InterestOverpayment := 0;
            END ELSE BEGIN
                InterestOverpayment := ABS(InterestPaid) - (InterestDue);
                InterestArrears := 0;
            END;
            IF (LedgerFeeDue) > ABS(LedgerFeePaid) THEN BEGIN
                LedgerFeeArrears := (LedgerFeeDue) - ABS(LedgerFeePaid);
                LedgerFeeOverpayment := 0;
            END ELSE BEGIN
                LedgerFeeOverpayment := ABS(LedgerFeePaid) - (LedgerFeeDue);
                LedgerFeeArrears := 0;
            END;
            IF (PenaltyDue) > ABS(PenaltyPaid) THEN BEGIN
                PenaltyArrears := (PenaltyDue) - ABS(PenaltyPaid);
                PenaltyOverpayment := 0;
            END ELSE BEGIN
                PenaltyOverpayment := ABS(PenaltyPaid) - (PenaltyDue);
                PenaltyArrears := 0;
            END;

            IF ABS(PrePay) > 0 then begin
                PrePayBal := ABS(PrePay);
                If PrePayBal > 0 then begin
                    If PrePayBal >= InterestArrears then begin
                        InterestArrears := 0;
                        PrePayBal := PrePayBal - InterestArrears;
                    end else begin
                        InterestArrears := InterestArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= LedgerFeeArrears then begin
                        LedgerFeeArrears := 0;
                        PrePayBal := PrePayBal - LedgerFeeArrears;
                    end else begin
                        LedgerFeeArrears := LedgerFeeArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= PenaltyArrears then begin
                        PenaltyArrears := 0;
                        PrePayBal := PrePayBal - PenaltyArrears;
                    end else begin
                        PenaltyArrears := PenaltyArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
                If PrePayBal > 0 then begin
                    If PrePayBal >= PrincipalArrears then begin
                        PrincipalArrears := 0;
                        PrePayBal := PrePayBal - PrincipalArrears;
                    end else begin
                        PrincipalArrears := PrincipalArrears - PrePayBal;
                        PrePayBal := 0;
                    end;
                end;
            end;
            if Loan."Outstanding Balance" <= 0 then begin
                PrincipalArrears := 0;
                InterestArrears := 0;
                LedgerFeeArrears := 0;
                PenaltyArrears := 0;
            end;*/
        end;
    end;

    procedure CalculateLoanArrearsAndOverpaymentInterestCharging(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalArrears: Decimal; var InterestArrears: Decimal; var LedgerFeeArrears: Decimal; var PenaltyArrears: Decimal; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal; var LedgerFeeOverpayment: Decimal; var PenaltyOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PrePay: Decimal;
        PrePayBal: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
    begin
        InterestDue := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;
        PrePay := 0;
        PrePayBal := 0;

        PrincipalArrears := 0;
        InterestArrears := 0;
        LedgerFeeArrears := 0;
        PenaltyArrears := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;

        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        If Loan.Get(LoanNo) then begin
            Loan.CalcFields("Outstanding Balance");
            if EndDate < Loan."Date of Completion" then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', EndDate);
                if LoanRepaymentSchedule.FindSet then begin
                    LoanRepaymentSchedule.CalcSums("Principal Installment");
                    PrincipalDue := Round(LoanRepaymentSchedule."Principal Installment");
                end;
            end else begin
                PrincipalDue := Loan."Approved Amount";
            end;

            Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindSet then begin
                    repeat
                        if (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") AND (DetailedCustLedger.Amount <> Loan."Approved Amount") THEN
                            PrincipalDue += DetailedCustLedger.Amount;
                    until DetailedCustLedger.Next = 0;//
                end;
            END;

            Cust.Reset;
            Cust.SetRange(Cust."No.", LoanNo);
            if Cust.FindFirst THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindSet then begin
                    repeat
                        IF (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") and (DetailedCustLedger."Credit Amount" <> 0) THEN BEGIN
                            DetailedCustLedger."Transaction Type Code" := TransactionTypeCodeSetup."Principal Paid";
                            DetailedCustLedger.Modify();
                        END;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                            PrincipalPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                            InterestDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                            InterestPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                            LedgerFeeDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                            LedgerFeePaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                            PenaltyDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                            PenaltyPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" THEN
                            PrePay += DetailedCustLedger.Amount;
                    until DetailedCustLedger.Next = 0;
                end;
            END;

            IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
                PrincipalArrears := PrincipalDue - ABS(PrincipalPaid);
                PrincipalOverpayment := 0;
            END ELSE BEGIN
                PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
                PrincipalArrears := 0;
            END;
            IF (InterestDue) > ABS(InterestPaid) THEN BEGIN
                InterestArrears := (InterestDue) - ABS(InterestPaid);
                InterestOverpayment := 0;
            END ELSE BEGIN
                InterestOverpayment := ABS(InterestPaid) - (InterestDue);
                InterestArrears := 0;
            END;
            IF (LedgerFeeDue) > ABS(LedgerFeePaid) THEN BEGIN
                LedgerFeeArrears := (LedgerFeeDue) - ABS(LedgerFeePaid);
                LedgerFeeOverpayment := 0;
            END ELSE BEGIN
                LedgerFeeOverpayment := ABS(LedgerFeePaid) - (LedgerFeeDue);
                LedgerFeeArrears := 0;
            END;
            IF (PenaltyDue) > ABS(PenaltyPaid) THEN BEGIN
                PenaltyArrears := (PenaltyDue) - ABS(PenaltyPaid);
                PenaltyOverpayment := 0;
            END ELSE BEGIN
                PenaltyOverpayment := ABS(PenaltyPaid) - (PenaltyDue);
                PenaltyArrears := 0;
            END;
        end;
    end;


    procedure CalculateLoanArrearsAndOverpaymentLoanReminder(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalArrears: Decimal; var InterestArrears: Decimal; var LedgerFeeArrears: Decimal; var PenaltyArrears: Decimal; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestDueCurrMonth: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
    begin
        InterestDue := 0;
        InterestDueCurrMonth := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;

        PrincipalArrears := 0;
        InterestArrears := 0;
        LedgerFeeArrears := 0;
        PenaltyArrears := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;

        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        If Loan.Get(LoanNo) then begin
            if Today < Loan."Date of Completion" then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', EndDate);
                if LoanRepaymentSchedule.FindSet then begin
                    LoanRepaymentSchedule.CalcSums("Principal Installment");
                    PrincipalDue := Round(LoanRepaymentSchedule."Principal Installment");
                end;
            end else begin
                PrincipalDue := Loan."Approved Amount";
            end;
        end;

        Cust.Reset;
        Cust.SetRange(Cust."No.", LoanNo);
        if Cust.FindFirst THEN BEGIN
            Cust.CalcFields(Cust.Balance);
            //if Cust.Balance > 0 THEN BEGIN
            DetailedCustLedger.Reset();
            DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
            DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
            if DetailedCustLedger.FindFirst then begin
                repeat
                    IF (DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") and (DetailedCustLedger."Credit Amount" <> 0) THEN BEGIN
                        DetailedCustLedger."Transaction Type Code" := TransactionTypeCodeSetup."Principal Paid";
                        DetailedCustLedger.Modify();
                    END;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                        PrincipalPaid += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                        InterestDue += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                        InterestPaid += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                        LedgerFeeDue += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                        LedgerFeePaid += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                        PenaltyDue += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                        PenaltyPaid += DetailedCustLedger.Amount;
                until DetailedCustLedger.Next = 0;
            end;
            DetailedCustLedger.Reset();
            DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
            DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", CalcDate('-CM', EndDate), EndDate);
            if DetailedCustLedger.FindFirst then begin
                repeat
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                        InterestDueCurrMonth += DetailedCustLedger.Amount;
                    IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                        InterestDueCurrMonth += DetailedCustLedger.Amount;
                until DetailedCustLedger.Next = 0;
            end;
            // Message('Princ due %1 Princ Paid %2', PrincipalDue, PrincipalPaid);
            //END;
        END;

        IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
            PrincipalArrears := PrincipalDue - ABS(PrincipalPaid);
            PrincipalOverpayment := 0;
        END ELSE BEGIN
            PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
            PrincipalArrears := 0;
        END;
        IF ABS(InterestDue) > ABS(InterestPaid) THEN BEGIN
            InterestArrears := ABS(InterestDue) - ABS(InterestPaid);
            If InterestDueCurrMonth = InterestArrears then begin
                InterestArrears := 0;
                InterestDueCurrMonth := 0;
            end;
            if InterestDueCurrMonth < InterestArrears then begin
                InterestArrears -= InterestDueCurrMonth;
                InterestDueCurrMonth := 0;
            end;
            InterestOverpayment := 0;
        END ELSE BEGIN
            InterestOverpayment := ABS(InterestPaid) - ABS(InterestDue);
            InterestArrears := 0;
        END;
        IF ABS(LedgerFeeDue) > ABS(LedgerFeePaid) THEN
            LedgerFeeArrears := ABS(LedgerFeeDue) - ABS(LedgerFeePaid)
        else
            LedgerFeeArrears := 0;
        IF ABS(PenaltyDue) > ABS(PenaltyPaid) THEN
            PenaltyArrears := ABS(PenaltyDue) - ABS(PenaltyPaid)
        else
            PenaltyArrears := 0;
    end;

    procedure CalculateLoanOverpayment(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PrincipalOverpayment: Decimal; var InterestOverpayment: Decimal; var LegderFeeOverPayment: Decimal; PenaltyOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestDue: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        PrincipalDue: Decimal;
        LedgerFeeDue: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyDue: Decimal;
        PenaltyPaid: Decimal;
        Cust: Record Customer;
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
    begin
        InterestDue := 0;
        InterestPaid := 0;
        PrincipalPaid := 0;
        LedgerFeeDue := 0;
        LedgerFeePaid := 0;
        PenaltyDue := 0;
        PenaltyPaid := 0;

        PrincipalOverpayment := 0;
        InterestOverpayment := 0;
        LegderFeeOverPayment := 0;
        PenaltyOverpayment := 0;


        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Due");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Due");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
        LoanRepaymentSchedule.SetFilter("Repayment Date", '..%1', EndDate);
        if LoanRepaymentSchedule.FindSet then begin
            LoanRepaymentSchedule.CalcSums("Principal Installment");
            PrincipalDue := LoanRepaymentSchedule."Principal Installment";
        end;

        Cust.Reset;
        Cust.SetRange(Cust."No.", LoanNo);
        if Cust.FindFirst THEN BEGIN
            Cust.CalcFields(Cust.Balance);
            if Cust.Balance < 0 THEN BEGIN
                DetailedCustLedger.Reset();
                DetailedCustLedger.SetRange(DetailedCustLedger."Customer No.", Cust."No.");
                DetailedCustLedger.SetRange(DetailedCustLedger."Posting Date", StartDate, EndDate);
                if DetailedCustLedger.FindFirst then begin
                    repeat
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                            PrincipalPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                            InterestDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                            InterestPaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" THEN
                            LedgerFeeDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" THEN
                            LedgerFeePaid += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" THEN
                            PenaltyDue += DetailedCustLedger.Amount;
                        IF DetailedCustLedger."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" THEN
                            PenaltyPaid += DetailedCustLedger.Amount;
                    until DetailedCustLedger.Next = 0;
                end;
                // Message('Princ due %1 Princ Paid %2', PrincipalDue, PrincipalPaid);
            END;
        END;

        IF PrincipalDue > ABS(PrincipalPaid) THEN BEGIN
            PrincipalOverpayment := 0;
        END ELSE BEGIN
            PrincipalOverpayment := ABS(PrincipalPaid) - PrincipalDue;
        END;
        IF ABS(InterestDue) > ABS(InterestPaid) THEN BEGIN
            InterestOverpayment := 0;
        END ELSE BEGIN
            InterestOverpayment := ABS(InterestPaid) - ABS(InterestDue);
        END;
        IF ABS(LedgerFeeDue) > ABS(LedgerFeePaid) THEN
            LegderFeeOverPayment := 0
        else
            LegderFeeOverPayment := Abs(LedgerFeePaid) - Abs(LedgerFeeDue);
        IF ABS(PenaltyDue) > ABS(PenaltyPaid) THEN
            PenaltyOverpayment := 0
        else
            PenaltyOverpayment := ABS(PenaltyDue) - ABS(PenaltyPaid);
    end;

    procedure CalculateInstallmentDue(LoanNo: Code[20]; RepaymentDate: Date; var PDue: Decimal; var IDue: Decimal)
    var
        InstallmentDue: array[4] of Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        Loan: Record "Loan Application";
        Bosa: Codeunit "BOSA Management";
    begin
        InstallmentDue[1] := 0;
        InstallmentDue[2] := 0;

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        // LoanRepaymentSchedule.SETRANGE("Repayment Date", RepaymentDate);
        IF LoanRepaymentSchedule.FINDFIRST THEN BEGIN
            //Message('Schedule exists');
            InstallmentDue[1] := LoanRepaymentSchedule."Principal Installment";
            InstallmentDue[2] := LoanRepaymentSchedule."Interest Installment";
        END ELSE BEGIN
            if Loan.Get(LoanNo) then begin
                Bosa.CreateRepaymentSchedule(Loan."No.", Loan."Approved Amount");
                // Message('New schedule exists');
                LoanRepaymentSchedule.RESET;
                LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
                //LoanRepaymentSchedule.SETRANGE("Repayment Date", RepaymentDate);
                IF LoanRepaymentSchedule.FINDFIRST THEN BEGIN
                    InstallmentDue[1] := LoanRepaymentSchedule."Principal Installment";
                    InstallmentDue[2] := LoanRepaymentSchedule."Interest Installment";
                END;
            end;
        END;

        PDue := InstallmentDue[1];
        IDue := InstallmentDue[2];
    end;

    procedure DeductLoanArrears(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Prepayment: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        BosaM: Codeunit "BOSA Management";
    begin
        GlobalSetup.Get();
        ReceiptHeader.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");
        TransactionTypeCodeSetup.TestField("Loan Prepayment");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);
        Prepayment := 0;
        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        CalculateLoanPrepayment(LoanNo, 0D, Today, Prepayment);

        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                if Customer.Balance - (TotalPaid + LoanOverPaid) = 0 then begin
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                    GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                    If Prepayment < 0 then begin
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment Recovery ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -Prepayment, LoanProductType."Loan Prepayment Posting Group", TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan,
                        GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + ReceiptHeader.Description + '- ' + ExternalDocNo, Prepayment, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                        GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                    end;
                end;
                if Customer.Balance - (TotalPaid + LoanOverPaid) > 0 then begin
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Loan Prepayment ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -LoanOverPaid, LoanProductType."Loan Prepayment Posting Group", TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan,
                    GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                end;
                if Customer.Balance - (TotalPaid + LoanOverPaid) = 0 then begin
                    BosaM.SendLoanClearedNotification(LoanApplication);
                end;
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanArrearsLoanRecovery(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        BosaM: Codeunit "BOSA Management";
    begin
        GlobalSetup.Get();
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);


        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + LoanApplication.Description + ' - Recovery', -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + LoanApplication.Description + ' - Recovery', -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + LoanApplication.Description + ' - Recovery', -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Principal
        /*if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;*/

        PrincipalPaid := RemainingAmount;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + LoanApplication.Description + ' - Recovery', -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
    end;

    procedure DeductLoanArrearsMembExit(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        ExitHeader: Record "Member Exit Header";
    begin
        GlobalSetup.Get();
        ExitHeader.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + ExitHeader.Description + '- ' + ExternalDocNo, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + ExitHeader.Description + '- ' + ExternalDocNo, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + ExitHeader.Description + '- ' + ExternalDocNo, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + ExitHeader.Description + '- ' + ExternalDocNo, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + ExitHeader.Description + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + ExitHeader.Description + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanArrearsGuarRecovery(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        Text001: Text[250];
    begin
        GlobalSetup.Get();
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);
        Text001 := 'Loan Defaulted Deposit Recovery';

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + Text001, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + Text001, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + Text001, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + Text001, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + Text001, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + Text001, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanArrearsFundstransfer(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        FundsTrans: Record "Fund Transfer";
    begin
        GlobalSetup.Get();
        Customer.Get(LoanNo);
        FundsTrans.Get(DocumentNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + FundsTrans.Remarks + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanArrearsLoanRecoveryFromDeposits(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        LoanRecovH: Record "Loan Recovery Header";
    begin
        GlobalSetup.Get();
        Customer.Get(LoanNo);
        LoanRecovH.Get(DocumentNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + LoanRecovH.Description, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + LoanRecovH.Description, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + LoanRecovH.Description, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + LoanRecovH.Description, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + LoanRecovH.Description, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + LoanRecovH.Description, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;


    procedure DeductLoanArrearsCheckoff(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: array[4] of Decimal;
        LedgerFeePaid: array[4] of Decimal;
        PenaltyPaid: array[4] of Decimal;
        PrincipalPaid: array[4] of Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        Cust: Record Customer;
        CustL: Record Customer;
        BosaM: Codeunit "BOSA Management";
    begin
        GlobalSetup.Get();
        CheckoffHeader.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        TotalPaid := 0;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);

        if Amount > ArrearsAmount[2] then begin
            InterestPaid[1] := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid[1] := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -InterestPaid[1], LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += InterestPaid[1];
        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid[1] := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -LedgerFeePaid[1], LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += LedgerFeePaid[1];
        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid[1] := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -PenaltyPaid[1], LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += PenaltyPaid[1];
        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid[1] := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -PrincipalPaid[1], '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        TotalPaid += PrincipalPaid[1];

        //LoanScheduleOverPayment
        if RemainingAmount > 0 then begin
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if ((Customer.Balance - TotalPaid) > 0) then begin
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + ReceiptHeader.Description + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;
        Customer.CalcFields(Balance);
        if Customer.Balance - (TotalPaid + LoanOverPaid) = 0 then begin
            BosaM.SendLoanClearedNotification(LoanApplication);
        end;
    end;

    procedure DeductLoanArrearsCheckoffNew(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20]; SumPreviousLines: Decimal)
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: array[4] of Decimal;
        LedgerFeePaid: array[4] of Decimal;
        PenaltyPaid: array[4] of Decimal;
        PrincipalPaid: array[4] of Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Prepayment: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        Cust: Record Customer;
        CustL: Record Customer;
        BosaM: Codeunit "BOSA Management";
    begin
        GlobalSetup.Get();
        CheckoffHeader.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        Prepayment := 0;
        TotalPaid := 0;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        CalculateLoanPrepayment(LoanNo, 0D, Today, Prepayment);
        //Check Checkoff Previous Lines-----------------------------------------------------------------------
        If SumPreviousLines > 0 then begin
            if ArrearsAmount[2] > 0 then begin
                if SumPreviousLines > ArrearsAmount[2] then begin
                    ArrearsAmount[2] := 0;
                    SumPreviousLines := SumPreviousLines - ArrearsAmount[2];
                end else begin
                    ArrearsAmount[2] := ArrearsAmount[2] - SumPreviousLines;
                    SumPreviousLines := 0;
                end;
            end;
            if ArrearsAmount[3] > 0 then begin
                if SumPreviousLines > ArrearsAmount[3] then begin
                    ArrearsAmount[3] := 0;
                    SumPreviousLines := SumPreviousLines - ArrearsAmount[3];
                end else begin
                    ArrearsAmount[3] := ArrearsAmount[3] - SumPreviousLines;
                    SumPreviousLines := 0;
                end;
            end;
            if ArrearsAmount[4] > 0 then begin
                if SumPreviousLines > ArrearsAmount[4] then begin
                    ArrearsAmount[4] := 0;
                    SumPreviousLines := SumPreviousLines - ArrearsAmount[4];
                end else begin
                    ArrearsAmount[4] := ArrearsAmount[4] - SumPreviousLines;
                    SumPreviousLines := 0;
                end;
            end;
        end;
        //End Check Checkoff Previous Lines-----------------------------------------------------------------------

        if Amount > ArrearsAmount[2] then begin
            InterestPaid[1] := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid[1] := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -InterestPaid[1], LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += InterestPaid[1];
        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid[1] := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -LedgerFeePaid[1], LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += LedgerFeePaid[1];
        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid[1] := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -PenaltyPaid[1], LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += PenaltyPaid[1];
        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid[1] := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -PrincipalPaid[1], '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        TotalPaid += PrincipalPaid[1];

        //LoanScheduleOverPayment
        if RemainingAmount > 0 then begin
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if ((Customer.Balance - TotalPaid) > 0) then begin
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                if Customer.Balance - (TotalPaid + LoanOverPaid) = 0 then begin
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                    GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                    IF Prepayment < 0 then begin
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment Recovery ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -Prepayment, LoanProductType."Loan Prepayment Posting Group", TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan,
                        GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + CheckoffHeader.Description + '- ' + ExternalDocNo, Prepayment, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                        GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                    end;
                end;
                if Customer.Balance - (TotalPaid + LoanOverPaid) > 0 then begin
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Loan Prepayment ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -LoanOverPaid, LoanProductType."Loan Prepayment Posting Group", TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan,
                    GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                end;
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + CheckoffHeader.Description + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;
        Customer.CalcFields(Balance);
        if Customer.Balance - (TotalPaid + LoanOverPaid) = 0 then begin
            BosaM.SendLoanClearedNotification(LoanApplication);
        end;
    end;

    procedure DeductLoanArrearsRefinancing(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: array[4] of Decimal;
        LedgerFeePaid: array[4] of Decimal;
        PenaltyPaid: array[4] of Decimal;
        PrincipalPaid: array[4] of Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        Cust: Record Customer;
        CustL: Record Customer;
        BosaM: Codeunit "BOSA Management";
    begin
        GlobalSetup.Get();
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        TotalPaid := 0;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid[1] := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid[1] := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- Loan Refinancing' + '- ' + ExternalDocNo, -InterestPaid[1], LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += InterestPaid[1];
        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid[1] := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- Loan Refinancing' + '- ' + ExternalDocNo, -LedgerFeePaid[1], LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += LedgerFeePaid[1];
        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid[1] := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- Loan Refinancing' + '- ' + ExternalDocNo, -PenaltyPaid[1], LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += PenaltyPaid[1];
        //Principal

        PrincipalPaid[1] := RemainingAmount;
        RemainingAmount := 0;

        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Loan Refinancing' + '- ' + ExternalDocNo, -PrincipalPaid[1], '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        TotalPaid += PrincipalPaid[1];

        Customer.CalcFields(Balance);
        if Customer.Balance - TotalPaid = 0 then begin
            BosaM.SendLoanClearedNotification(LoanApplication);
        end;
    end;

    procedure DeductLoanArrearsConsolidation(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: array[4] of Decimal;
        LedgerFeePaid: array[4] of Decimal;
        PenaltyPaid: array[4] of Decimal;
        PrincipalPaid: array[4] of Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        Cust: Record Customer;
        CustL: Record Customer;
        BosaM: Codeunit "BOSA Management";
    begin
        GlobalSetup.Get();
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        TotalPaid := 0;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid[1] := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid[1] := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- Loan Consolidation' + '- ' + ExternalDocNo, -InterestPaid[1], LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += InterestPaid[1];
        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid[1] := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- Loan Consolidation' + '- ' + ExternalDocNo, -LedgerFeePaid[1], LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += LedgerFeePaid[1];
        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid[1] := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid[1] := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- Loan Consolidation' + '- ' + ExternalDocNo, -PenaltyPaid[1], LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        TotalPaid += PenaltyPaid[1];
        //Principal

        PrincipalPaid[1] := RemainingAmount;
        RemainingAmount := 0;

        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Loan Consolidation' + '- ' + ExternalDocNo, -PrincipalPaid[1], '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        TotalPaid += PrincipalPaid[1];

        Customer.CalcFields(Balance);
        if Customer.Balance - TotalPaid = 0 then begin
            BosaM.SendLoanClearedNotification(LoanApplication);
        end;
    end;

    procedure DeductLoanArrearsRescheduling(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        LoanRescheduling: Record "Loan Rescheduling";
    begin
        GlobalSetup.Get();
        LoanRescheduling.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);

        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + LoanRescheduling.Remarks + '- ' + ExternalDocNo, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + LoanRescheduling.Remarks + '- ' + ExternalDocNo, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + LoanRescheduling.Remarks + '- ' + ExternalDocNo, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + LoanRescheduling.Remarks + '- ' + ExternalDocNo, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + LoanRescheduling.Remarks + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + LoanRescheduling.Remarks + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanArrearsRestructuring(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        LoanRestructuring: Record "Loan Restructuring";
    begin
        GlobalSetup.Get();
        LoanRestructuring.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, PostingDate, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);

        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + LoanRestructuring.Remarks + '- ' + ExternalDocNo, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + LoanRestructuring.Remarks + '- ' + ExternalDocNo, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + LoanRestructuring.Remarks + '- ' + ExternalDocNo, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + LoanRestructuring.Remarks + '- ' + ExternalDocNo, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + LoanRestructuring.Remarks + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + LoanRestructuring.Remarks + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanArrearsLoanWriteOff(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
        CheckoffHeader: Record "Checkoff Header";
        LoanWriteoffHeader: Record "Loan Writeoff Header";
    begin
        GlobalSetup.Get();
        LoanWriteoffHeader.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanArrearsAndOverpaymentFactbox(LoanNo, 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
        if Amount > ArrearsAmount[2] then begin
            InterestPaid := ArrearsAmount[2];
            RemainingAmount -= ArrearsAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Paid- ' + LoanWriteoffHeader.Remarks + '- ' + ExternalDocNo, -InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

        //Ledger Fee
        if RemainingAmount > ArrearsAmount[3] then begin
            LedgerFeePaid := ArrearsAmount[3];
            RemainingAmount -= ArrearsAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Paid- ' + LoanWriteoffHeader.Remarks + '- ' + ExternalDocNo, -LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > ArrearsAmount[4] then begin
            PenaltyPaid := ArrearsAmount[4];
            RemainingAmount -= ArrearsAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Paid- ' + LoanWriteoffHeader.Remarks + '- ' + ExternalDocNo, -PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > ArrearsAmount[1] then begin
            PrincipalPaid := ArrearsAmount[1];
            RemainingAmount -= ArrearsAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- ' + LoanWriteoffHeader.Remarks + '- ' + ExternalDocNo, -PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //LoanScheduleOverPayment
        if Customer.get(LoanNo) then begin
            TotalPaid := 0;
            LoanOverPaid := 0;
            Customer.CalcFields(Balance);
            if Customer.Balance > 0 then begin
                TotalPaid := InterestPaid + LedgerFeePaid + PenaltyPaid + PrincipalPaid;
                if RemainingAmount > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    RemainingAmount -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := RemainingAmount;
                    RemainingAmount := 0;
                end;
                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Paid- Advance Payment ' + LoanWriteoffHeader.Remarks + '- ' + ExternalDocNo, -LoanOverPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
             GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;

        if RemainingAmount > 0 then begin
            CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Vendor, GetOverpaymentAccount(Customer."Member No."), 'Overpayment- ' + LoanWriteoffHeader.Remarks + '- ' + ExternalDocNo, -RemainingAmount, '', '', SourceCodeSetup."Loan Overpayment",
                          GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
        end;

    end;

    procedure DeductLoanOverPayment(var TransactionTypeCodeSetup: Record "Transaction Type Code Setup"; var SourceCodeSetup: Record "Source Code Setup"; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; LoanNo: Code[20]; Amount: Decimal; GlobalDimension1Code: Code[20])
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;

        RemainingAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        Customer: Record Customer;
        FundsTrans: Record "Fund Transfer";
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestPaid: Decimal;
        LedgerFeePaid: Decimal;
        PenaltyPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        Descrp: Text[250];
        ReceiptHeader: Record "Receipt Header";
    begin
        GlobalSetup.Get();
        FundsTrans.Get(DocumentNo);
        Customer.Get(LoanNo);
        LoanApplication.Get(LoanNo);
        LoanProductType.Get(Customer."Loan Product Type");
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
        TransactionTypeCodeSetup.TestField("Penalty Paid");

        LoanProductType.TestField("Interest Due Posting Group");
        LoanProductType.TestField("Interest Paid Posting Group");
        LoanProductType.TestField("Ledger Fee Due Posting Group");
        LoanProductType.TestField("Ledger Fee Paid Posting Group");
        LoanProductType.TestField("Penalty Due Posting Group");
        LoanProductType.TestField("Penalty Paid Posting Group");
        SourceCodeSetup.TestField(Loan);

        RemainingAmount := Amount;
        CalculateLoanOverpayment(LoanNo, 0D, Today, OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);

        if Amount > OverpaymentAmount[2] then begin
            InterestPaid := OverpaymentAmount[2];
            RemainingAmount -= OverpaymentAmount[2];
        end else begin
            InterestPaid := Amount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Interest Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Interest Overpayment- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, InterestPaid, LoanProductType."Interest Due Posting Group",
                      TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Ledger Fee
        if RemainingAmount > OverpaymentAmount[3] then begin
            LedgerFeePaid := OverpaymentAmount[3];
            RemainingAmount -= OverpaymentAmount[3];
        end else begin
            LedgerFeePaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Ledger Fee Overpayment- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, LedgerFeePaid, LoanProductType."Ledger Fee Due Posting Group",
                      TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Penalty Fee
        if RemainingAmount > OverpaymentAmount[4] then begin
            PenaltyPaid := OverpaymentAmount[4];
            RemainingAmount -= OverpaymentAmount[4];
        end else begin
            PenaltyPaid := RemainingAmount;
            RemainingAmount := 0;
        end;

        CustomerPostingGroup.Get(LoanProductType."Penalty Due Posting Group");
        CustomerPostingGroup.TestField("Receivables Account");
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Penalty Overpayment- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, PenaltyPaid, LoanProductType."Penalty Due Posting Group",
                      TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");


        //Principal
        if RemainingAmount > OverpaymentAmount[1] then begin
            PrincipalPaid := OverpaymentAmount[1];
            RemainingAmount -= OverpaymentAmount[1];
        end else begin
            PrincipalPaid := RemainingAmount;
            RemainingAmount := 0;
        end;
        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, ExternalDocNo, PostingDate, AccountTypeEnum::Customer, LoanNo, 'Principal Overpayment- ' + FundsTrans.Remarks + '- ' + ExternalDocNo, PrincipalPaid, '', TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan,
                     GlobalDimension1Code, BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
    end;

    procedure GetAmountInWords(Amount: Decimal): Text[250]
    var
        myInt: Integer;
    begin
        InitTextVariables;
        AmountInWords := NumberInWords(Amount, 'Shillings', 'Cents');
        exit(AmountInWords);
    end;

    local procedure InitTextVariables()
    var
        myInt: Integer;
    begin

        OnesText[1] := 'One';
        OnesText[2] := 'Two';
        OnesText[3] := 'Three';
        OnesText[4] := 'Four';
        OnesText[5] := 'Five';
        OnesText[6] := 'Six';
        OnesText[7] := 'Seven';
        OnesText[8] := 'Eight';
        OnesText[9] := 'Nine';
        OnesText[10] := 'Ten';
        OnesText[11] := 'Eleven';
        OnesText[12] := 'Twelve';
        OnesText[13] := 'Thirteen';
        OnesText[14] := 'Fourteen';
        OnesText[15] := 'Fifteen';
        OnesText[16] := 'Sixteen';
        OnesText[17] := 'Seventeen';
        OnesText[18] := 'Eighteen';
        OnesText[19] := 'Nineteen';

        TensText[1] := '';
        TensText[2] := 'Twenty';
        TensText[3] := 'Thirty';
        TensText[4] := 'Forty';
        TensText[5] := 'Fifty';
        TensText[6] := 'Sixty';
        TensText[7] := 'Seventy';
        TensText[8] := 'Eighty';
        TensText[9] := 'Ninety';

        ThousText[1] := 'Hundred';
        ThousText[2] := 'Thousand';
        ThousText[3] := 'Million';
        ThousText[4] := 'Billion';
        ThousText[5] := 'Trillion';
    end;

    local procedure NumberInWords(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);

        WholeInWords := NumberToWords(WholePart, CurrencyName);

        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, DenomName);
            WholeInWords := WholeInWords + ' and ' + DecimalInWords;
        END;

        AmountInWords := '****' + WholeInWords + ' Only';
        EXIT(AmountInWords);
    end;

    local procedure NumberToWords(number: Decimal; appendScale: Text[30]): Text[300]
    var
        numString: Text[300];
        pow: Integer;
        powStr: Text[50];
        log: Integer;
    begin
        numString := '';
        IF number < 100 THEN
            IF number < 20 THEN BEGIN
                IF number <> 0 THEN numString := OnesText[number];
            END ELSE BEGIN
                numString := TensText[number DIV 10];
                IF (number MOD 10) > 0 THEN
                    numString := numString + ' ' + OnesText[number MOD 10];
            END
        ELSE BEGIN
            pow := 0;
            powStr := '';
            IF number < 1000 THEN BEGIN // number is between 100 and 1000
                pow := 100;
                powStr := ThousText[1];
            END ELSE BEGIN // find the scale of the number
                log := ROUND(STRLEN(FORMAT(number DIV 1000)) / 3, 1, '>');
                pow := POWER(1000, log);
                powStr := ThousText[log + 1];
            END;

            numString := NumberToWords(number DIV pow, powStr) + ' ' + NumberToWords(number MOD pow, '');
        END;

        EXIT(DELCHR(numString, '<>', ' ') + ' ' + appendScale);
    end;

    procedure GetHostInfo(var HName: Code[20]; var HIP: Code[20]; var HMac: Code[20])
    var
        Dns: dotNet Dns;
        GetIPMac2: dotNet GetIPMac;
        IPHostEntry: dotNet IPHostEntry;
        IPAddress: dotNet IPAddress;
    begin
        HName := Dns.GetHostName();
        Clear(GetIPMac2);
        GetIPMac2 := GetIPMac2.GetIPMac();
        HIP := GetIPMac2.GetIP(HName);
        HMac := GetIPMac2.GetMac();
    end;

    procedure UpdateAuditInfo(RecRef: RecordRef)
    var
        LoanRescheduling: Record "Loan Rescheduling";
        LoanApplication: Record "Loan Application";
        FundTransfer: Record "Fund Transfer";
        DividendHeader: Record "Dividend Header";
        PayoutHeader: Record "Payout Header";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        StandingOrder: Record "Standing Order";
        MemberExitHeader: Record "Member Exit Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSellOff: Record "Loan Selloff";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Loan Application":
                BEGIN
                    RecRef.SETTABLE(LoanApplication);
                    LoanApplication."Approved By" := USERID;
                    LoanApplication."Approved Date" := TODAY;
                    LoanApplication."Approved Time" := TIME;
                    GetHostInfo(HostName, HostIP, HostMac);
                    LoanApplication."Approved By Host IP" := HostIP;
                    LoanApplication."Approved By Host MAC" := HostMac;
                    LoanApplication."Approved By Host Name" := HostName;
                    LoanApplication.MODIFY;
                END;
            DATABASE::"Loan Rescheduling":
                BEGIN
                    RecRef.SETTABLE(LoanRescheduling);
                    LoanRescheduling."Approved By" := USERID;
                    LoanRescheduling."Approved Date" := TODAY;
                    LoanRescheduling."Approved Time" := TIME;
                    LoanRescheduling.MODIFY;
                END;
            DATABASE::"Guarantor Substitution Header":
                BEGIN
                    RecRef.SETTABLE(GuarantorSubstitutionHeader);
                    GuarantorSubstitutionHeader."Approved By" := USERID;
                    GuarantorSubstitutionHeader."Approved Date" := TODAY;
                    GuarantorSubstitutionHeader."Approved Time" := TIME;
                    GuarantorSubstitutionHeader.MODIFY;
                END;
            DATABASE::"Standing Order":
                BEGIN
                    RecRef.SETTABLE(StandingOrder);
                    StandingOrder."Approved By" := USERID;
                    StandingOrder."Approved Date" := TODAY;
                    StandingOrder."Approved Time" := TIME;
                    StandingOrder.MODIFY;
                END;
            DATABASE::"Fund Transfer":
                BEGIN
                    RecRef.SETTABLE(FundTransfer);
                    FundTransfer."Approved By" := USERID;
                    FundTransfer."Approved Date" := TODAY;
                    FundTransfer."Approved Time" := TIME;
                    FundTransfer.MODIFY;
                END;
            DATABASE::"Payout Header":
                BEGIN
                    RecRef.SETTABLE(PayoutHeader);
                    PayoutHeader."Approved By" := USERID;
                    PayoutHeader."Approved Date" := TODAY;
                    PayoutHeader."Approved Time" := TIME;
                    PayoutHeader.MODIFY;
                END;
            DATABASE::"Dividend Header":
                BEGIN
                    RecRef.SETTABLE(DividendHeader);
                    DividendHeader."Approved By" := USERID;
                    DividendHeader."Approved Date" := TODAY;
                    DividendHeader."Approved Time" := TIME;
                    DividendHeader.MODIFY;
                END;
            DATABASE::"Member Exit Header":
                BEGIN
                    RecRef.SETTABLE(MemberExitHeader);
                    MemberExitHeader."Approved By" := USERID;
                    MemberExitHeader."Approved Date" := TODAY;
                    MemberExitHeader."Approved Time" := TIME;
                    MemberExitHeader.MODIFY;
                END;
            DATABASE::"Member Refund Header":
                BEGIN
                    RecRef.SETTABLE(MemberRefundHeader);
                    MemberRefundHeader."Approved By" := USERID;
                    MemberRefundHeader."Approved Date" := TODAY;
                    MemberRefundHeader."Approved Time" := TIME;
                    MemberRefundHeader.MODIFY;
                END;
            DATABASE::"Member Claim Header":
                BEGIN
                    RecRef.SETTABLE(MemberClaimHeader);
                    MemberClaimHeader."Approved By" := USERID;
                    MemberClaimHeader."Approved Date" := TODAY;
                    MemberClaimHeader."Approved Time" := TIME;
                    MemberClaimHeader.MODIFY;
                END;
            DATABASE::"Loan Selloff":
                BEGIN
                    RecRef.SETTABLE(LoanSellOff);
                    LoanSellOff."Approved By" := USERID;
                    LoanSellOff."Approved Date" := TODAY;
                    LoanSellOff."Approved Time" := TIME;
                    LoanSellOff.MODIFY;
                END;
        END;
    end;

    procedure ValidateUserAllowePostingTo(PostingDate: Date): Boolean
    begin
        UserSetup.Get(UserId);
        If UserSetup."Allow Posting To" <= PostingDate then
            exit(true)
        else
            exit(false);
    end;

    procedure GetOverpaymentAccount(MemberNo: Code[20]): Code[20]
    var
        AccountType: Record "Account Type";
        LoanApplicationSetup: Record "Loan Application Setup";
        Vendor: Record Vendor;
    begin
        LoanApplicationSetup.Get();
        LoanApplicationSetup.TestField("Loan Overpayment (Account Type)");

        Vendor.Reset();
        Vendor.SetRange("Member No.", MemberNo);
        Vendor.SetRange("Account Type", LoanApplicationSetup."Loan Overpayment (Account Type)");
        if Vendor.FindFirst() then
            exit(Vendor."No.");
    end;

    var
        OnesText: array[20] of Text[100];
        TensText: array[20] of Text[100];
        ThousText: array[20] of Text[100];
        AmountInWords: Text[300];
        WholeInWords: Text[300];
        DecimalInWords: Text[300];
        WholePart: Integer;
        DecimalPart: Integer;
        RecRef: RecordRef;
        FldRef: FieldRef;
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        GlobalSetup: Record "Global Setup";
        i: Integer;
        UserSetup: Record "User Setup";

}