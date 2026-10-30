codeunit 50015 "Process Loan Reconciliation"
{
    var
        Vendor: Record "Vendor";
        i: Integer;
        GlobalSetup: Record "Global Setup";
        Member: Record "Member";
        LoanProductType: Record "Loan Product Type";
        GLEntry: Record "G/L Entry";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        GlobalManagement: Codeunit "Global Management";
        PenaltyRecovered: Boolean;
        PrincipalRecovered: Boolean;
        Interestrecovered: Boolean;
        Recovered: Boolean;
        Loan: Record "Loan Application";
        LoanApplicationSetup: Record "Loan Application Setup";
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";

    trigger OnRun()
    begin
        LoanApplicationSetup.Get();
        Loan.Reset();
        Loan.SetRange(Posted, true);
        Loan.SetRange(Cleared, true);
        If Loan.FindSet() then begin
            repeat
                Loan.CalcFields(Prepayment, "Outstanding Balance", "Outstanding Principal", "Outstanding Interest", "Outstanding Penalty", "Outstanding Ledger Fee");
                If Loan."Outstanding Balance" <> 0 then begin
                    If Loan."Outstanding Balance" > 0 then begin
                        Loan.Cleared := false;
                        Loan.Modify();
                    end;
                    If Loan."Outstanding Balance" < 0 then begin
                        if Loan.Prepayment < 0 then begin
                            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                            ProcessPrepaymentRecovery(Loan, (Loan.Prepayment * -1), Today);
                            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        end;
                        if Loan."Outstanding Principal" < 0 then begin
                            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                            ProcessPrincipalOverPaymentRecovery(Loan, (Loan."Outstanding Principal" * -1), Today);
                            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        end;
                        if Loan."Outstanding Interest" < 0 then begin
                            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                            ProcessInterestOverPaymentRecovery(Loan, (Loan."Outstanding Interest" * -1), Today);
                            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        end;
                        if Loan."Outstanding Penalty" < 0 then begin
                            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                            ProcessPenaltyOverPaymentRecovery(Loan, (Loan."Outstanding Penalty" * -1), Today);
                            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        end;
                        if Loan."Outstanding Ledger Fee" < 0 then begin
                            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                            ProcessLedgerFeeOverPaymentRecovery(Loan, (Loan."Outstanding Ledger Fee" * -1), Today);
                            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        end;
                    end;
                end else begin
                    if (Loan.Prepayment <> 0) or (Loan."Outstanding Principal" <> 0) or (Loan."Outstanding Interest" <> 0) or (Loan."Outstanding Penalty" <> 0) or (Loan."Outstanding Ledger Fee" <> 0) then begin
                        Loan.Cleared := false;
                        Loan.Modify();
                    end;
                end;
            until Loan.Next = 0;
        end;


        Loan.Reset();
        Loan.SetRange(Posted, true);
        Loan.SetRange(Cleared, false);
        If Loan.FindSet() then begin
            repeat
                Loan.CalcFields(Prepayment, "Outstanding Balance", "Outstanding Principal", "Outstanding Interest", "Outstanding Penalty", "Outstanding Ledger Fee");
                If Loan."Outstanding Balance" <= 0 then begin
                    if Loan.Prepayment < 0 then begin
                        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        ProcessPrepaymentRecovery(Loan, (Loan.Prepayment * -1), Today);
                        GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                    end;
                    if Loan."Outstanding Principal" < 0 then begin
                        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        ProcessPrincipalOverPaymentRecovery(Loan, (Loan."Outstanding Principal" * -1), Today);
                        GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                    end;
                    if Loan."Outstanding Interest" < 0 then begin
                        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        ProcessInterestOverPaymentRecovery(Loan, (Loan."Outstanding Interest" * -1), Today);
                        GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                    end;
                    if Loan."Outstanding Penalty" < 0 then begin
                        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        ProcessPenaltyOverPaymentRecovery(Loan, (Loan."Outstanding Penalty" * -1), Today);
                        GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                    end;
                    if Loan."Outstanding Ledger Fee" < 0 then begin
                        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        ProcessLedgerFeeOverPaymentRecovery(Loan, (Loan."Outstanding Ledger Fee" * -1), Today);
                        GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                    end;
                    Loan.Cleared := true;
                    Loan.Modify();
                end;
            until Loan.Next = 0;
        end;
    end;

    procedure ProcessPrepaymentRecovery(var LoanApp: Record "Loan Application"; PrepaymentAmount: Decimal; CheckDate: Date)
    var
        Text0001: Label 'Interest Recovered from Loan Prepayment-';
        Text0002: Label 'Interest Charged Paid from Loan Prepayment-';
        Text0003: Label 'Principal Recovered from Loan Prepayment-';
        Text0004: Label 'Principal Paid from Loan Prepayment-';
        Text0005: Label 'Penalty Recovered from Loan Prepayment-';
        Text0006: Label 'Penalty Paid from Loan Prepayment-';
        Text0007: Label 'Deposits Recovered from Loan Prepayment Overpayment-';
        Text0008: Label 'Deposits Paid from Loan Prepayment Overpayment-';
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        DateFilter: Text[100];
        DCustL: Record "Detailed Cust. Ledg. Entry";
        OutBal: Decimal;
        LPrePaymentAmount: Decimal;
        IntRecov: Decimal;
        DepsitsRecov: Decimal;
        PrincBal: Decimal;
        PrincRecov: Decimal;
        PenaltyRecov: Decimal;
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        Customer: Record Customer;
    begin
        with LoanApp do begin
            LoanApplicationSetup.GET;
            LoanProductType.Get("Loan Product Type");
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := PrepaymentAmount;
            IntRecov := 0;
            PenaltyRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            DepsitsRecov := 0;
            PrincRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;
            CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Penalty");
            //Message('Message 1 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

            Customer.get("No.");
            if "Outstanding Interest" > 0 then begin
                IntRecov := "Outstanding Interest";
            end;
            if "Outstanding Penalty" > 0 then begin
                PenaltyRecov := "Outstanding Penalty";
            end;
            if "Outstanding Principal" > 0 then begin
                PrincRecov := "Outstanding Principal";
            end;

            If IntRecov > LPrepaymentAmount then begin
                IntRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                IntRecov := IntRecov;
                LPrepaymentAmount := LPrepaymentAmount - IntRecov;
            end;
            If PenaltyRecov > LPrepaymentAmount then begin
                PenaltyRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PenaltyRecov := PenaltyRecov;
                LPrepaymentAmount := LPrepaymentAmount - PenaltyRecov;
            end;
            If PrincRecov > LPrepaymentAmount then begin
                PrincRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PrincRecov := PrincRecov;
                LPrepaymentAmount := LPrepaymentAmount - PrincRecov;
            end;
            If LPrepaymentAmount > 0 then begin
                DepsitsRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end;


            //Recover Interest
            If IntRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0001 + Customer."No.", IntRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0002 + Customer."No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Penalty
            If PenaltyRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0005 + Customer."No.", PenaltyRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0006 + Customer."No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Principal
            If PrincRecov > 0 Then begin
                //Message('Message 2 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0003 + Customer."No.", PrincRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0004 + Customer."No.", -PrincRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recovery to Deposits
            If DepsitsRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", DepsitsRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Vendor, GlobalManagement.GetMemberDepositsAcc(Customer."Member No."), Text0008 + Customer."No.", -DepsitsRecov, '',
                TransactionTypeCodeSetup."Monthly Contribution", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
        end;
    end;

    procedure ProcessLedgerFeeOverPaymentRecovery(var LoanApp: Record "Loan Application"; PrepaymentAmount: Decimal; CheckDate: Date)
    var
        Text0001: Label 'Interest Recovered from Ledger Fee Over Payment-';
        Text0002: Label 'Interest Charged Paid from Ledger Fee Over Payment-';
        Text0003: Label 'Principal Recovered from Ledger Fee Over Payment-';
        Text0004: Label 'Principal Paid from Ledger Fee Over Payment-';
        Text0005: Label 'Penalty Recovered from Ledger Fee Over Payment-';
        Text0006: Label 'Penalty Paid from Ledger Fee Over Payment-';
        Text0007: Label 'Deposits Recovered from Ledger Fee Over Payment-';
        Text0008: Label 'Deposits Paid from Ledger Fee Over Payment-';

        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        DateFilter: Text[100];
        DCustL: Record "Detailed Cust. Ledg. Entry";
        OutBal: Decimal;
        LPrePaymentAmount: Decimal;
        IntRecov: Decimal;
        PrincBal: Decimal;
        DepsitsRecov: Decimal;
        PrincRecov: Decimal;
        PenaltyRecov: Decimal;
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        Customer: Record Customer;
    begin
        with LoanApp do begin
            LoanApplicationSetup.GET;
            LoanProductType.Get("Loan Product Type");
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := PrepaymentAmount;
            IntRecov := 0;
            PenaltyRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            PrincRecov := 0;
            DepsitsRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;
            CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Penalty");
            //Message('Message 1 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

            Customer.get("No.");
            if "Outstanding Interest" > 0 then begin
                IntRecov := "Outstanding Interest";
            end;
            if "Outstanding Penalty" > 0 then begin
                PenaltyRecov := "Outstanding Penalty";
            end;
            if "Outstanding Principal" > 0 then begin
                PrincRecov := "Outstanding Principal";
            end;

            If IntRecov > LPrepaymentAmount then begin
                IntRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                IntRecov := IntRecov;
                LPrepaymentAmount := LPrepaymentAmount - IntRecov;
            end;
            If PenaltyRecov > LPrepaymentAmount then begin
                PenaltyRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PenaltyRecov := PenaltyRecov;
                LPrepaymentAmount := LPrepaymentAmount - PenaltyRecov;
            end;
            If PrincRecov > LPrepaymentAmount then begin
                PrincRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PrincRecov := PrincRecov;
                LPrepaymentAmount := LPrepaymentAmount - PrincRecov;
            end;
            If LPrepaymentAmount > 0 then begin
                DepsitsRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end;


            //Recover Interest
            If IntRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0001 + Customer."No.", IntRecov, LoanProductType."Ledger Fee Due Posting Group",
                TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0002 + Customer."No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Penalty
            If PenaltyRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0005 + Customer."No.", PenaltyRecov, LoanProductType."Ledger Fee Due Posting Group",
                TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0006 + Customer."No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Principal
            If PrincRecov > 0 Then begin
                //Message('Message 2 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0003 + Customer."No.", PrincRecov, LoanProductType."Ledger Fee Due Posting Group",
                TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0004 + Customer."No.", -PrincRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;

            //Recovery to Deposits
            If DepsitsRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", DepsitsRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Vendor, GlobalManagement.GetMemberDepositsAcc(Customer."Member No."), Text0008 + Customer."No.", -DepsitsRecov, '',
                TransactionTypeCodeSetup."Monthly Contribution", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
        end;
    end;

    procedure ProcessPrincipalOverPaymentRecovery(var LoanApp: Record "Loan Application"; PrepaymentAmount: Decimal; CheckDate: Date)
    var
        Text0001: Label 'Interest Recovered from Principal Over Payment-';
        Text0002: Label 'Interest Charged Paid from Principal Over Payment-';
        Text0003: Label 'Prepayment Recovered from Principal Over Payment-';
        Text0004: Label 'Prepayment Paid from Principal Over Payment-';
        Text0005: Label 'Penalty Recovered from Principal Over Payment-';
        Text0006: Label 'Penalty Paid from Principal Over Payment-';
        Text0007: Label 'Deposits Recovered from Principal Over Payment-';
        Text0008: Label 'Deposits Paid from Principal Over Payment-';
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        DateFilter: Text[100];
        DCustL: Record "Detailed Cust. Ledg. Entry";
        OutBal: Decimal;
        LPrePaymentAmount: Decimal;
        LedgerFeeRecov: Decimal;
        IntRecov: Decimal;
        PrincBal: Decimal;
        PrincRecov: Decimal;
        DepsitsRecov: Decimal;
        PenaltyRecov: Decimal;
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        Customer: Record Customer;
    begin
        with LoanApp do begin
            LoanApplicationSetup.GET;
            LoanProductType.Get("Loan Product Type");
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := PrepaymentAmount;
            IntRecov := 0;
            PenaltyRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            PrincRecov := 0;
            DepsitsRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;
            LedgerFeeRecov := 0;
            CalcFields("Outstanding Interest", Prepayment, "Outstanding Penalty", "Outstanding Ledger Fee");
            //Message('Message 1 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

            Customer.get("No.");
            if "Outstanding Interest" > 0 then begin
                IntRecov := "Outstanding Interest";
            end;
            if "Outstanding Penalty" > 0 then begin
                PenaltyRecov := "Outstanding Penalty";
            end;
            if Prepayment > 0 then begin
                PrincRecov := Prepayment;
            end;
            if "Outstanding Ledger Fee" > 0 then begin
                LedgerFeeRecov := "Outstanding Ledger Fee";
            end;

            If IntRecov > LPrepaymentAmount then begin
                IntRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                IntRecov := IntRecov;
                LPrepaymentAmount := LPrepaymentAmount - IntRecov;
            end;
            If PenaltyRecov > LPrepaymentAmount then begin
                PenaltyRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PenaltyRecov := PenaltyRecov;
                LPrepaymentAmount := LPrepaymentAmount - PenaltyRecov;
            end;
            If LedgerFeeRecov > LPrepaymentAmount then begin
                LedgerFeeRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                LedgerFeeRecov := LedgerFeeRecov;
                LPrepaymentAmount := LPrepaymentAmount - LedgerFeeRecov;
            end;
            If PrincRecov > LPrepaymentAmount then begin
                PrincRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PrincRecov := PrincRecov;
                LPrepaymentAmount := LPrepaymentAmount - PrincRecov;
            end;
            If LPrepaymentAmount > 0 then begin
                DepsitsRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end;

            //Recover Interest
            If IntRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0001 + Customer."No.", IntRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0002 + Customer."No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Penalty
            If PenaltyRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0005 + Customer."No.", PenaltyRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0006 + Customer."No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Ledger Fee
            If LedgerFeeRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", LedgerFeeRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0008 + Customer."No.", -LedgerFeeRecov, LoanProductType."Ledger Fee Due Posting Group",
                TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Prepayment
            If PrincRecov > 0 Then begin
                //Message('Message 2 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0003 + Customer."No.", PrincRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0004 + Customer."No.", -PrincRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recovery to Deposits
            If DepsitsRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", DepsitsRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Vendor, GlobalManagement.GetMemberDepositsAcc(Customer."Member No."), Text0008 + Customer."No.", -DepsitsRecov, '',
                TransactionTypeCodeSetup."Monthly Contribution", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
        end;
    end;

    procedure ProcessPenaltyOverPaymentRecovery(var LoanApp: Record "Loan Application"; PrepaymentAmount: Decimal; CheckDate: Date)
    var
        Text0001: Label 'Interest Recovered from Penalty Over Payment-';
        Text0002: Label 'Interest Charged Paid from Penalty Over Payment-';
        Text0003: Label 'Principal Recovered from Penalty Over Payment-';
        Text0004: Label 'Principal Paid from Penalty Over Payment-';
        Text0005: Label 'Prepayment Recovered from Penalty Over Payment-';
        Text0006: Label 'Prepayment Paid from Penalty Over Payment-';
        Text0007: Label 'Deposits Recovered from Penalty Over Payment-';
        Text0008: Label 'Deposits Paid from Penalty Over Payment-';
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        DateFilter: Text[100];
        DCustL: Record "Detailed Cust. Ledg. Entry";
        OutBal: Decimal;
        LPrePaymentAmount: Decimal;
        IntRecov: Decimal;
        PrincBal: Decimal;
        PrincRecov: Decimal;
        DepsitsRecov: Decimal;
        PenaltyRecov: Decimal;
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        Customer: Record Customer;
        LedgerFeeRecov: Decimal;
    begin
        with LoanApp do begin
            LoanApplicationSetup.GET;
            LoanProductType.Get("Loan Product Type");
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := PrepaymentAmount;
            IntRecov := 0;
            PenaltyRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            DepsitsRecov := 0;
            PrincRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;
            LedgerFeeRecov := 0;
            CalcFields("Outstanding Interest", "Outstanding Ledger Fee", "Outstanding Principal", Prepayment);
            //Message('Message 1 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

            Customer.get("No.");
            if "Outstanding Interest" > 0 then begin
                IntRecov := "Outstanding Interest";
            end;
            if Prepayment > 0 then begin
                PenaltyRecov := Prepayment;
            end;
            if "Outstanding Principal" > 0 then begin
                PrincRecov := "Outstanding Principal";
            end;
            if "Outstanding Ledger Fee" > 0 then begin
                LedgerFeeRecov := "Outstanding Ledger Fee";
            end;

            If IntRecov > LPrepaymentAmount then begin
                IntRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                IntRecov := IntRecov;
                LPrepaymentAmount := LPrepaymentAmount - IntRecov;
            end;
            If PenaltyRecov > LPrepaymentAmount then begin
                PenaltyRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PenaltyRecov := PenaltyRecov;
                LPrepaymentAmount := LPrepaymentAmount - PenaltyRecov;
            end;//LedgerFeeRecov
            If LedgerFeeRecov > LPrepaymentAmount then begin
                LedgerFeeRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                LedgerFeeRecov := LedgerFeeRecov;
                LPrepaymentAmount := LPrepaymentAmount - LedgerFeeRecov;
            end;
            If PrincRecov > LPrepaymentAmount then begin
                PrincRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PrincRecov := PrincRecov;
                LPrepaymentAmount := LPrepaymentAmount - PrincRecov;
            end;
            If LPrepaymentAmount > 0 then begin
                DepsitsRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end;


            //Recover Interest
            If IntRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0001 + Customer."No.", IntRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0002 + Customer."No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Ledger Fee
            If LedgerFeeRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", LedgerFeeRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0008 + Customer."No.", -LedgerFeeRecov, LoanProductType."Ledger Fee Due Posting Group",
                TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Prepayment
            If PenaltyRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0005 + Customer."No.", PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0006 + Customer."No.", -PenaltyRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Principal
            If PrincRecov > 0 Then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0003 + Customer."No.", PrincRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0004 + Customer."No.", -PrincRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;

            //Recovery to Deposits
            If DepsitsRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", DepsitsRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Vendor, GlobalManagement.GetMemberDepositsAcc(Customer."Member No."), Text0008 + Customer."No.", -DepsitsRecov, '',
                TransactionTypeCodeSetup."Monthly Contribution", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
        end;
    end;

    procedure ProcessInterestOverPaymentRecovery(var LoanApp: Record "Loan Application"; PrepaymentAmount: Decimal; CheckDate: Date)
    var
        Text0001: Label 'Prepayment Recovered from Interest Over Payment-';
        Text0002: Label 'Prepayment Charged Paid from Interest Over Payment-';
        Text0003: Label 'Principal Recovered from Interest Over Payment-';
        Text0004: Label 'Principal Paid from Interest Over Payment-';
        Text0005: Label 'Penalty Recovered from Interest Over Payment-';
        Text0006: Label 'Penalty Paid from Interest Over Payment-';
        Text0007: Label 'Deposits Recovered from Interest Over Payment-';
        Text0008: Label 'Deposits Paid from Interest Over Payment-';
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        DateFilter: Text[100];
        DCustL: Record "Detailed Cust. Ledg. Entry";
        OutBal: Decimal;
        LPrePaymentAmount: Decimal;
        IntRecov: Decimal;
        PrincBal: Decimal;
        PrincRecov: Decimal;
        PenaltyRecov: Decimal;
        DepsitsRecov: Decimal;
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        Customer: Record Customer;
        LedgerFeeRecov: Decimal;
    begin
        with LoanApp do begin
            LoanApplicationSetup.GET;
            LoanProductType.Get("Loan Product Type");
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := PrepaymentAmount;
            IntRecov := 0;
            PenaltyRecov := 0;
            DepsitsRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            PrincRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;
            CalcFields(Prepayment, "Outstanding Principal", "Outstanding Penalty", "Outstanding Ledger Fee");
            //Message('Message 1 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");

            Customer.get("No.");
            if Prepayment > 0 then begin
                IntRecov := Prepayment;
            end;
            if "Outstanding Penalty" > 0 then begin
                PenaltyRecov := "Outstanding Penalty";
            end;
            if "Outstanding Principal" > 0 then begin
                PrincRecov := "Outstanding Principal";
            end;
            if "Outstanding Ledger Fee" > 0 then begin
                LedgerFeeRecov := "Outstanding Ledger Fee";
            end;

            If IntRecov > LPrepaymentAmount then begin
                IntRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                IntRecov := IntRecov;
                LPrepaymentAmount := LPrepaymentAmount - IntRecov;
            end;
            If PenaltyRecov > LPrepaymentAmount then begin
                PenaltyRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PenaltyRecov := PenaltyRecov;
                LPrepaymentAmount := LPrepaymentAmount - PenaltyRecov;
            end;
            If LedgerFeeRecov > LPrepaymentAmount then begin
                LedgerFeeRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                LedgerFeeRecov := LedgerFeeRecov;
                LPrepaymentAmount := LPrepaymentAmount - LedgerFeeRecov;
            end;
            If PrincRecov > LPrepaymentAmount then begin
                PrincRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end else begin
                PrincRecov := PrincRecov;
                LPrepaymentAmount := LPrepaymentAmount - PrincRecov;
            end;
            If LPrepaymentAmount > 0 then begin
                DepsitsRecov := LPrepaymentAmount;
                LPrepaymentAmount := 0;
            end;


            //Recover Prepayment
            If IntRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0001 + Customer."No.", IntRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0002 + Customer."No.", -IntRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Penalty
            If PenaltyRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0005 + Customer."No.", PenaltyRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0006 + Customer."No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Ledger Fee
            If LedgerFeeRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", LedgerFeeRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0008 + Customer."No.", -LedgerFeeRecov, LoanProductType."Ledger Fee Due Posting Group",
                TransactionTypeCodeSetup."Ledger Fee Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recover Principal
            If PrincRecov > 0 Then begin
                //Message('Message 2 Loan No %1 Prepayment %2 Interest %3 Penalty %4 Principal %5', "No.", PrepaymentAmount, "Outstanding Interest", "Outstanding Penalty", "Outstanding Principal");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0003 + Customer."No.", PrincRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0004 + Customer."No.", -PrincRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
            //Recovery to Deposits
            If DepsitsRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0007 + Customer."No.", DepsitsRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), 'LRECON-' + Format(Date2DMY(CheckDate, 3)), CheckDate, AccountTypeEnum::Vendor, GlobalManagement.GetMemberDepositsAcc(Customer."Member No."), Text0008 + Customer."No.", -DepsitsRecov, '',
                TransactionTypeCodeSetup."Monthly Contribution", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
            end;
        end;
    end;

}
