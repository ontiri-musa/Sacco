codeunit 50081 "Recover Loans From Prepayments"
{
    var
        Vendor: Record "Vendor";
        //i: Integer;
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
        i: Date;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        CustL: Record "Cust. Ledger Entry";
        GLEnt: Record "G/L Entry";
        Loan: Record "Loan Application";
        BosaM: Codeunit "BOSA Management";
        ReversalEntry: Record "Reversal Entry";
        LoanRepaymentSch: Record "Loan Repayment Schedule";

        LoanPrePaymentAmount: Decimal;

        Customer: Record Customer;

    trigger OnRun()
    var
    begin
        //'REC' + FORMAT(CheckDate)
        /*for i := 20240101D To Today Do begin
            Loan.Reset();
            //Loan.SetRange("No.", 'BCL03209');
            if Loan.FindSet() then begin
                repeat
                    Loan.CalcFields("Outstanding Balance");
                    If Loan."Outstanding Balance" > 0 then begin
                        CustL.Reset();
                        CustL.SetRange("Customer No.", Loan."No.");
                        CustL.SetRange("Posting Date", i);
                        CustL.SetRange("Document No.", 'REC' + FORMAT(i));
                        CustL.SetRange(Reversed, false);
                        if CustL.FindSet() then begin
                            repeat
                                ReversalEntry.SetHideWarningDialogs();
                                ReversalEntry.SetHideDialog(true);
                                ReversalEntry.ReverseTransaction(CustL."Transaction No.");
                            until CustL.Next = 0;
                        end;
                        //REC03/17/24
                        CustL.Reset();
                        CustL.SetRange("Customer No.", Loan."No.");
                        CustL.SetRange("Posting Date", i);
                        CustL.SetRange("Document No.", 'REC03/17/24');
                        CustL.SetRange(Reversed, false);
                        if CustL.FindSet() then begin
                            repeat
                                ReversalEntry.SetHideWarningDialogs();
                                ReversalEntry.SetHideDialog(true);
                                ReversalEntry.ReverseTransaction(CustL."Transaction No.");
                            until CustL.Next = 0;
                        end;
                    end;
                until Loan.Next = 0;
            end;
        end;*/

        for i := 20240722D To Today Do begin
            Loan.Reset();
            //Loan.SetRange("No.", 'BCL03209');
            if Loan.FindSet() then begin
                repeat
                    LoanPrePaymentAmount := 0;
                    Loan.CalcFields("Outstanding Balance");
                    If Loan."Outstanding Balance" > 0 then begin
                        Customer.Get(Loan."No.");
                        LoanRepaymentSch.Reset();
                        LoanRepaymentSch.SetRange("Repayment Date", i);
                        LoanRepaymentSch.SetRange("Loan No.", Loan."No.");
                        if LoanRepaymentSch.FindFirst() then begin
                            GlobalManagement.CalculateLoanPrepayment(Loan."No.", 0D, i, LoanPrePaymentAmount);
                            LoanPrePaymentAmount := -(LoanPrePaymentAmount);
                            //Message('LoanPrePaymentAmount %1 as at %2', LoanPrePaymentAmount, i);
                            If LoanPrePaymentAmount > 0 then
                                ProcessRecovery(LoanPrePaymentAmount, i, Loan);
                        end;
                    end;
                until Loan.Next = 0;
            end;
        end;
        //ProcessPrepayments(20240101D, Today);
    end;

    procedure ProcessPrepayments(startDate: Date; endDate: Date)
    var
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanApplicationSetup: Record "Loan Application Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanApprec: Record "Loan Application";
        LPrePaymentAmount: Decimal;
        Customer: Record Customer;
        PrepaymentRecoveryRec: Record "Loan Prepayment Recovery";

    begin
        LoanRepaymentSch.Reset();
        LoanRepaymentSch.SetRange("Repayment Date", startDate, endDate);
        if LoanRepaymentSch.FindSet() then begin
            repeat
                LoanApprec.Reset();
                LoanApprec.SetRange("No.", LoanRepaymentSch."Loan No.");
                LoanApprec.SetRange(Posted, true);
                LoanApprec.SetRange("Pause Loan Interest", false);
                LoanApprec.SetRange("Loan Restructured", false);
                if LoanApprec.FindFirst() then begin
                    clear(LPrePaymentAmount);
                    LoanApprec.CalcFields("Outstanding Balance");
                    GlobalManagement.CalculateLoanPrepayment(LoanApprec."No.", 0D, endDate, LPrePaymentAmount);
                    LPrePaymentAmount := -(LPrePaymentAmount);
                    if (LoanApprec."Outstanding Balance" > 0) and (LPrePaymentAmount > 0) then begin
                        if Customer.get(LoanApprec."No.") then begin
                            if Customer.Status <> Customer.Status::Blocked then begin
                                CheckRecoveryDone(Customer, LoanRepaymentSch."Repayment Date");
                                if Recovered = false then begin
                                    PrepaymentRecoveryRec.Reset();
                                    PrepaymentRecoveryRec.SetRange("Loan No", Customer."No.");
                                    PrepaymentRecoveryRec.SetRange("Posting Date", LoanRepaymentSch."Repayment Date");
                                    if PrepaymentRecoveryRec.FindFirst() then begin
                                        if PrepaymentRecoveryRec.Posted = false then
                                            PrepaymentRecoveryRec.Delete();
                                        PopulateRecoveryRec(Customer, LPrePaymentAmount, LoanRepaymentSch."Repayment Date");
                                    end else
                                        PopulateRecoveryRec(Customer, LPrePaymentAmount, LoanRepaymentSch."Repayment Date");
                                end
                            end;
                        end;
                    end;
                end;
            until LoanRepaymentSch.Next() = 0;
        end;
    end;

    procedure CheckRecoveryDone(var CustomerRec: Record Customer; checkDate: Date)
    var
        Text000: Label 'Interest Charged-';
        Text0001: Label 'Interest Recovered from Prepayment-';
        Text0002: Label 'Interest Charged Paid from Prepayment-';
        Text0003: Label 'Principal Recovered from Prepayment-';
        Text0004: Label 'Principal Paid from Prepayment-';
        Text0005: Label 'Penalty Recovered from Prepayment-';
        Text0006: Label 'Penalty Paid from Prepayment-';
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanApplicationSetup: Record "Loan Application Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanApprec: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PostingDesc: Text;
    begin
        with CustomerRec do begin
            Interestrecovered := false;
            PrincipalRecovered := false;
            PenaltyRecovered := false;
            Recovered := false;

            TransactionTypeCodeSetup.Get();
            LoanApplicationSetup.Get();
            CustLedgEntry.Reset();
            CustLedgEntry.SetRange("Customer No.", "No.");
            CustLedgEntry.SetRange(Reversed, false);
            CustLedgEntry.SetRange("Posting Date", checkDate);
            CustLedgEntry.SetRange("Journal Batch Name", LoanApplicationSetup."Loan Interest Batch Name");
            if CustLedgEntry.FindSet() then begin
                repeat
                    if (CustLedgEntry.Description = Text0006 + "No.") and (CustLedgEntry."Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid") then begin
                        PenaltyRecovered := true;
                        Recovered := true;
                    end;
                    if (CustLedgEntry.Description = Text0002 + "No.") and (CustLedgEntry."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid") then begin
                        Interestrecovered := true;
                        Recovered := true;
                    end;
                    if (CustLedgEntry.Description = Text0004 + "No.") and (CustLedgEntry."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid") then begin
                        PrincipalRecovered := true;
                        Recovered := true;
                    end
                until CustLedgEntry.Next() = 0;
            end;
        end;
    end;

    procedure PopulateRecoveryRec(var Customer: Record Customer; PrepaymentAmount: Decimal; CheckDate: Date)
    var
        Text000: Label 'Interest Charged-';
        Text0001: Label 'Interest Recovered from Prepayment-';
        Text0002: Label 'Interest Charged Paid from Prepayment-';
        Text0003: Label 'Principal Recovered from Prepayment-';
        Text0004: Label 'Principal Paid from Prepayment-';
        Text0005: Label 'Penalty Recovered from Prepayment-';
        Text0006: Label 'Penalty Paid from Prepayment-';
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
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanApplicationSetup: Record "Loan Application Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        AmountToRecover: Decimal;
    begin
        with Customer do begin
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := 0;
            IntRecov := 0;
            PenaltyRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            PrincRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;
            AmountToRecover := 0;

            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", '<=%1', CheckDate);
            if DCustL.FindSet() then begin
                repeat
                    OutBal += DCustL.Amount;
                    If (DCustL."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid") or (DCustL."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") then
                        PrincBal += DCustL.Amount;
                until DCustL.Next = 0;
            end;

            LPrePaymentAmount := PrepaymentAmount;
            GlobalManagement.CalculateLoanArrearsAndOverpayment(Customer."No.", 0D, CheckDate, Arrears[1], Arrears[2], Arrears[3], Arrears[4], Arrears[5], Arrears[6]);
            PrincRecov := Arrears[1];
            IntRecov := Arrears[2];
            PenaltyRecov := Arrears[4];
            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Interest Due");
            TransactionTypeCodeSetup.TestField("Interest Paid");
            LoanApplicationSetup.TestField("Loan Interest Template Name");
            LoanApplicationSetup.TestField("Loan Interest Batch Name");

            If IntRecov >= LPrePaymentAmount then begin
                IntRecov := LPrePaymentAmount;
                LPrePaymentAmount := 0;
            end else begin
                IntRecov := IntRecov;
                LPrePaymentAmount -= IntRecov;
            end;

            If PenaltyRecov >= LPrePaymentAmount then begin
                PenaltyRecov := LPrePaymentAmount;
                LPrePaymentAmount := 0;
            end else begin
                PenaltyRecov := PenaltyRecov;
                LPrePaymentAmount -= PenaltyRecov;
            end;

            If PrincRecov >= LPrePaymentAmount then begin
                PrincRecov := LPrePaymentAmount;
                LPrePaymentAmount := 0;
            end else begin
                PrincRecov := PrincRecov;
                LPrePaymentAmount -= PrincRecov;
            end;

            AmountToRecover := IntRecov + PrincRecov + PenaltyRecov;
            if AmountToRecover > 0 then begin
                LoanPrepaymentRec.Reset();
                if LoanPrepaymentRec.FindLast() then
                    EntryNo := LoanPrepaymentRec."Entry No" + 1
                else
                    EntryNo := 1;
                LoanPrepaymentRec.Init();
                LoanPrepaymentRec."Entry No" := EntryNo;
                LoanPrepaymentRec."Loan No" := "No.";
                LoanPrepaymentRec."Loan Product" := Name;
                LoanPrepaymentRec."Member No" := "Member No.";
                LoanPrepaymentRec."Member Name" := "Member Name";
                LoanPrepaymentRec."Prepayment Amount" := PrepaymentAmount;
                LoanPrepaymentRec."Amount Recovered" := PrincRecov + IntRecov + PenaltyRecov;
                LoanPrepaymentRec."Date Recovered" := Today;
                LoanPrepaymentRec."Recovered By" := UserId;
                LoanPrepaymentRec."Principal Recovered" := PrincRecov;
                LoanPrepaymentRec."Interest Recovered" := IntRecov;
                LoanPrepaymentRec."Penalty Recovered" := PenaltyRecov;
                LoanPrepaymentRec."Posting Date" := CheckDate;
                LoanPrepaymentRec.Insert();
                GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                //ProcessRecovery(LoanPrepaymentRec, PrepaymentAmount, CheckDate);
                GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
            end;
        end;
    end;

    procedure ProcessRecovery(PrepaymentAmount: Decimal; CheckDate: Date; LoanApp: Record "Loan Application")
    var
        Text000: Label 'Interest Charged-';
        Text0001: Label 'Interest Recovered from Prepayment-';
        Text0002: Label 'Interest Charged Paid from Prepayment-';
        Text0003: Label 'Principal Recovered from Prepayment-';
        Text0004: Label 'Principal Paid from Prepayment-';
        Text0005: Label 'Penalty Recovered from Prepayment-';
        Text0006: Label 'Penalty Paid from Prepayment-';
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
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        LoanApplicationSetup: Record "Loan Application Setup";
        SourceCodeSetup: Record "Source Code Setup";
        LoanPrepaymentRec: Record "Loan Prepayment Recovery";
        EntryNo: Integer;
        Customer: Record Customer;
        AmountToRecover: Decimal;
    begin
        // with PrepaymentRecovery do begin
        LoanApplicationSetup.GET;
        SourceCodeSetup.GET;
        GlobalSetup.Get();
        TransactionTypeCodeSetup.Get();
        LoanProductType.Get(LoanApp."Loan Product Type");
        OutBal := 0;
        LPrePaymentAmount := 0;
        IntRecov := 0;
        PenaltyRecov := 0;
        PenaltyDue := 0;
        PrincBal := 0;
        PrincRecov := 0;
        ExpectedPrincPaid := 0;
        PrincipalPaid := 0;
        AmountToRecover := 0;
        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");

        Customer.get(LoanApp."No.");
        GlobalManagement.CalculateLoanArrearsAndOverpaymentPrepayment(Customer."No.", 0D, CheckDate, Arrears[1], Arrears[2], Arrears[3], Arrears[4], Arrears[5], Arrears[6]);
        PrincRecov := Arrears[1];
        IntRecov := Arrears[2];
        PenaltyRecov := Arrears[4];
        LPrePaymentAmount := PrepaymentAmount;

        If IntRecov >= LPrePaymentAmount then begin
            IntRecov := LPrePaymentAmount;
            LPrePaymentAmount := 0;
        end else begin
            IntRecov := IntRecov;
            LPrePaymentAmount -= IntRecov;
        end;

        If PenaltyRecov >= LPrePaymentAmount then begin
            PenaltyRecov := LPrePaymentAmount;
            LPrePaymentAmount := 0;
        end else begin
            PenaltyRecov := PenaltyRecov;
            LPrePaymentAmount -= PenaltyRecov;
        end;

        If PrincRecov >= LPrePaymentAmount then begin
            PrincRecov := LPrePaymentAmount;
            LPrePaymentAmount := 0;
        end else begin
            PrincRecov := PrincRecov;
            LPrePaymentAmount -= PrincRecov;
        end;

        AmountToRecover := IntRecov + PrincRecov + PenaltyRecov;
        if AmountToRecover > 0 then begin
            LoanPrepaymentRec.Reset();
            if LoanPrepaymentRec.FindLast() then
                EntryNo := LoanPrepaymentRec."Entry No" + 1
            else
                EntryNo := 1;
            LoanPrepaymentRec.Init();
            LoanPrepaymentRec."Entry No" := EntryNo;
            LoanPrepaymentRec."Loan No" := Customer."No.";
            LoanPrepaymentRec."Loan Product" := Customer.Name;
            LoanPrepaymentRec."Member No" := Customer."Member No.";
            LoanPrepaymentRec."Member Name" := Customer."Member Name";
            LoanPrepaymentRec."Prepayment Amount" := PrepaymentAmount;
            LoanPrepaymentRec."Amount Recovered" := PrincRecov + IntRecov + PenaltyRecov;
            LoanPrepaymentRec."Date Recovered" := Today;
            LoanPrepaymentRec."Recovered By" := UserId;
            LoanPrepaymentRec."Principal Recovered" := PrincRecov;
            LoanPrepaymentRec."Interest Recovered" := IntRecov;
            LoanPrepaymentRec."Penalty Recovered" := PenaltyRecov;
            LoanPrepaymentRec."Posting Date" := CheckDate;
            LoanPrepaymentRec.Insert();

            //Recover Penalty
            If PenaltyRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), Customer."No.", CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0005 + Customer."No.", PenaltyRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), Customer."No.", CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0006 + Customer."No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                //Posted := true;
            end;
            //Recover Interest
            If IntRecov > 0 then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), Customer."No.", CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0001 + Customer."No.", IntRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), Customer."No.", CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0002 + Customer."No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                // Posted := true;
            end;
            //Recover Principal
            If PrincRecov > 0 Then begin
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), Customer."No.", CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0003 + Customer."No.", PrincRecov, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(CheckDate), Customer."No.", CheckDate, AccountTypeEnum::Customer, Customer."No.", Text0004 + Customer."No.", -PrincRecov, LoanProductType."Loan Posting Group",
                TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, Customer."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
                // Posted := true;
            end;
            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
            //Modify(true);
        end;
    end;

}
