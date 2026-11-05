codeunit 50550 Automations
{
    trigger OnRun()
    begin
        ProcessAutomationsPenalty(Today);
        ProcessAutomationsInterest(Today);
    end;

    procedure ProcessAutomationsInterest(RunningDate: Date)
    var
        i: Date;
        AutEnt: Record "Automation Log Entries";
        AutEnt2: Record "Automation Log Entries";
        AutEnt3: Record "Automation Log Entries";
        EntryNo: Integer;
    begin

        AutEnt.Reset();
        AutEnt.SetRange("Automation Code", 'LOAN-INT');
        AutEnt.SetRange("Run Date", RunningDate);
        If AutEnt.FindFirst() then begin
            exit;
        end else begin
            AutEnt3.Reset();
            AutEnt3.SetRange("Automation Code", 'LOAN-INT');
            If AutEnt3.FindLast() then begin
                If AutEnt3."Next Run Date" <= RunningDate then begin
                    for i := AutEnt3."Next Run Date" to RunningDate do begin
                        RunMonthlyInterest(i);

                        AutEnt2.Reset();
                        If AutEnt2.FindLast() then
                            EntryNo := AutEnt2."Entry No." + 1
                        Else
                            EntryNo := 1;

                        AutEnt2.Init();
                        AutEnt2."Entry No." := EntryNo;
                        AutEnt2."Automation Code" := 'LOAN-INT';
                        AutEnt2."Run Date" := i;
                        AutEnt2."Next Run Date" := CalcDate('1D', i);
                        AutEnt2.Insert();
                    end;
                end;
            end;
        end;
    end;

    procedure ProcessAutomationsPenalty(RunningDate: Date)
    var//
        i: Date;
        AutEnt: Record "Automation Log Entries";
        AutEnt2: Record "Automation Log Entries";
        AutEnt3: Record "Automation Log Entries";
        EntryNo: Integer;
    begin
        AutEnt.Reset();
        AutEnt.SetRange("Automation Code", 'LOANPENALTY');
        AutEnt.SetRange("Run Date", RunningDate);
        If AutEnt.FindFirst() then begin
            exit;
        end else begin
            AutEnt3.Reset();
            AutEnt3.SetRange("Automation Code", 'LOANPENALTY');
            If AutEnt3.FindLast() then begin
                If AutEnt3."Next Run Date" <= RunningDate then begin
                    for i := AutEnt3."Next Run Date" to RunningDate do begin
                        RunMonthlyPenalty(i);

                        AutEnt2.Reset();
                        If AutEnt2.FindLast() then
                            EntryNo := AutEnt2."Entry No." + 1
                        Else
                            EntryNo := 1;

                        AutEnt2.Init();
                        AutEnt2."Entry No." := EntryNo;
                        AutEnt2."Automation Code" := 'LOANPENALTY';
                        AutEnt2."Run Date" := i;
                        AutEnt2."Next Run Date" := CalcDate('1D', i);
                        AutEnt2.Insert();
                    end;
                end;
            end;
        end;
    end;


    procedure ProcessAutomationsSTO(Var RunningDate: Date)
    var//
        i: Date;
        AutEnt: Record "Automation Log Entries";
        AutEnt2: Record "Automation Log Entries";
        AutEnt3: Record "Automation Log Entries";
        EntryNo: Integer;
    begin
        AutEnt.Reset();
        AutEnt.SetRange("Automation Code", 'STO');
        AutEnt.SetRange("Run Date", RunningDate);
        If AutEnt.FindFirst() then begin
            exit;
        end else begin
            AutEnt3.Reset();
            AutEnt3.SetRange("Automation Code", 'STO');
            If AutEnt3.FindLast() then begin
                If AutEnt3."Next Run Date" <= RunningDate then begin
                    for i := AutEnt3."Next Run Date" to RunningDate do begin
                        If i = CalcDate('-CM', i) then begin
                            RunSTO(i);

                            AutEnt2.Reset();
                            If AutEnt2.FindLast() then
                                EntryNo := AutEnt2."Entry No." + 1
                            Else
                                EntryNo := 1;

                            AutEnt2.Init();
                            AutEnt2."Entry No." := EntryNo;
                            AutEnt2."Automation Code" := 'STO';
                            AutEnt2."Run Date" := i;
                            AutEnt2."Next Run Date" := CalcDate('-CM', CalcDate('1M', i));
                            AutEnt2.Insert();
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure ProcessAutomationsSTOLocal(RunningDate: Date)
    var//
        i: Date;
        AutEnt: Record "Automation Log Entries";
        AutEnt2: Record "Automation Log Entries";
        AutEnt3: Record "Automation Log Entries";
        EntryNo: Integer;
    begin
        AutEnt.Reset();
        AutEnt.SetRange("Automation Code", 'STO');
        AutEnt.SetRange("Run Date", RunningDate);
        If AutEnt.FindFirst() then begin
            exit;
        end else begin
            AutEnt3.Reset();
            AutEnt3.SetRange("Automation Code", 'STO');
            If AutEnt3.FindLast() then begin
                If AutEnt3."Next Run Date" <= RunningDate then begin
                    for i := AutEnt3."Next Run Date" to RunningDate do begin
                        If i = CalcDate('-CM', i) then begin
                            RunSTO(i);

                            AutEnt2.Reset();
                            If AutEnt2.FindLast() then
                                EntryNo := AutEnt2."Entry No." + 1
                            Else
                                EntryNo := 1;

                            AutEnt2.Init();
                            AutEnt2."Entry No." := EntryNo;
                            AutEnt2."Automation Code" := 'STO';
                            AutEnt2."Run Date" := i;
                            AutEnt2."Next Run Date" := CalcDate('-CM', CalcDate('1M', i));
                            AutEnt2.Insert();
                        end;
                    end;
                end;
            end;
        end;
    end;

    Local procedure RunSTO(PostingDate: Date)
    begin
    end;

    Local procedure RunMonthlyInterest(PostingDate: Date)
    begin
        RunDate := PostingDate;
        LoanApplicationSetup.Get();
        LoanApplicationSetup.TestField("Loan Interest Template Name");
        LoanApplicationSetup.TestField("Loan Interest Batch Name");
        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");

        "Loan Application".Reset();
        "Loan Application".SetRange(Posted, true);
        "Loan Application".SetRange("Pause Loan Interest", false);
        "Loan Application".SetRange("Loan Restructured", false);
        "Loan Application".SetFilter("Loan Product Type", '<>%1', 'MB');
        if "Loan Application".FindSet() then begin
            repeat
                If "Loan Application"."Loan Product Type" <> 'IPF' then begin
                    "Loan Application".CalcFields("Outstanding Balance");
                    if "Loan Application"."Outstanding Balance" > 0 then begin
                        Cust.Reset();
                        Cust.SetRange("No.", "Loan Application"."No.");
                        Cust.SetFilter(Status, '<>%1', Cust.Status::Blocked);
                        If Cust.FindFirst() then begin
                            DCustL.Reset();
                            DCustL.SetRange("Customer No.", "Loan Application"."No.");
                            DCustL.SetRange("Transaction Type Code", 'INTDUE');
                            DCustL.SetRange("Posting Date", PostingDate);
                            DCustL.SetRange(Reversed, false);
                            If not DCustL.FindFirst() then begin
                                if "Loan Application"."Date of Completion" >= RunDate then begin
                                    LoanRep.Reset();
                                    LoanRep.SetRange("Loan No.", "Loan Application"."No.");
                                    LoanRep.SetRange("Repayment Date", RunDate);
                                    If LoanRep.FindFirst() then begin
                                        Customer.Get("Loan Application"."No.");
                                        BOSAManagement.CapitalizeInterest(Customer, RunDate, PostingDate);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            until "Loan Application".Next = 0;
        end;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", LoanApplicationSetup."Loan Interest Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name", LoanApplicationSetup."Loan Interest Batch Name");
        IF GenJournalLine.FINDSET THEN BEGIN
            COMMIT;
            GenJnlPostBatch.RUN(GenJournalLine);
        END;
    end;

    Local procedure RunMonthlyPenalty(PostingDate: Date)
    var
        LoanApp: Record "Loan Application";
    begin
        // RunDate := PostingDate;

        LoanApplicationSetup.Get();
        LoanApplicationSetup.TestField("Penalty Template Name");
        LoanApplicationSetup.TestField("Penalty Batch Name");
        GlobalManagement.ClearJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name");

        "Loan Application".Reset();
        "Loan Application".SetRange(Posted, true);
        "Loan Application".SetRange("Pause Loan Penalty", false);
        "Loan Application".SetRange("Loan Restructured", false);
        if "Loan Application".FindSet() then begin
            repeat
                LProd.Get("Loan Application"."Loan Product Type");
                If "Loan Application"."Loan Product Type" <> 'IPF' then begin
                    "Loan Application".CalcFields("Outstanding Balance");
                    if "Loan Application"."Outstanding Balance" > 0 then begin
                        Cust.Reset();
                        Cust.SetRange("No.", "Loan Application"."No.");
                        Cust.SetFilter(Status, '<>%1', Cust.Status::Blocked);
                        If Cust.FindFirst() then begin
                            If LProd."E-Loan" = false then begin
                                RunDate := Calcdate('-1M', PostingDate);
                                DCustL.Reset();
                                DCustL.SetRange("Customer No.", "Loan Application"."No.");
                                DCustL.SetRange("Transaction Type Code", 'PENDUE');
                                DCustL.SetRange("Posting Date", PostingDate);
                                DCustL.SetRange(Reversed, false);
                                If not DCustL.FindFirst() then begin
                                    if "Loan Application"."Date of Completion" >= RunDate then begin
                                        LoanRep.Reset();
                                        LoanRep.SetRange("Loan No.", "Loan Application"."No.");
                                        LoanRep.SetRange("Repayment Date", PostingDate);
                                        If LoanRep.FindFirst() then begin
                                            Customer.Get("Loan Application"."No.");
                                            BOSAManagement.CapitalizePenalty(Customer, RunDate, PostingDate);
                                        end;
                                    end;
                                end;
                            end else begin
                                RunDate := Calcdate('-1D', PostingDate);
                                DCustL.Reset();
                                DCustL.SetRange("Customer No.", "Loan Application"."No.");
                                DCustL.SetRange("Transaction Type Code", 'PENDUE');
                                DCustL.SetRange("Posting Date", RunDate);
                                DCustL.SetRange(Reversed, false);
                                If not DCustL.FindFirst() then begin
                                    if "Loan Application"."Date of Completion" >= RunDate then begin
                                        LoanRep.Reset();
                                        LoanRep.SetRange("Loan No.", "Loan Application"."No.");
                                        LoanRep.SetRange("Repayment Date", PostingDate);
                                        If LoanRep.FindFirst() then begin
                                            Customer.Get("Loan Application"."No.");
                                            LoanApp.Reset();
                                            LoanApp.SetRange("No.", "Loan Application"."No.");
                                            LoanApp.SetFilter("Date Filter", '..%1', PostingDate);
                                            if LoanApp.FindFirst() then begin
                                                CapitalizePenaltyMob(Customer, RunDate, LoanApp);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            until "Loan Application".Next = 0;
        end;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", LoanApplicationSetup."Penalty Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name", LoanApplicationSetup."Penalty Batch Name");
        IF GenJournalLine.FINDSET THEN BEGIN
            COMMIT;
            GenJnlPostBatch.RUN(GenJournalLine);
        END;
    end;

    procedure CapitalizePenaltyMob(Customer: Record Customer; PostingDate: Date; LoanApp2: Record "Loan Application")
    var
        LoanProductType: Record "Loan Product Type";
        Outbal: Decimal;
        PenaltyDue: Decimal;
        CustL: Record "Cust. Ledger Entry";
        Text000: Label 'Penalty Charged-';
    begin
        with Customer do begin

            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            LoanProductType.Get(LoanApp2."Loan Product Type");
            TransactionTypeCodeSetup.Get();
            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Penalty Due");
            TransactionTypeCodeSetup.TestField("Penalty Paid");
            LoanApplicationSetup.TestField("Penalty Template Name");
            LoanApplicationSetup.TestField("Penalty Batch Name");

            Outbal := 0;
            PenaltyDue := 0;

            LoanApp2.CalcFields("Outstanding Balance");
            Outbal := LoanApp2."Outstanding Balance";
            PenaltyDue := Round(((5 / 100) * Outbal), 1, '=');

            If PenaltyDue > 0 Then Begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text000 + "No." + '-' + LoanApp2.Description, PenaltyDue, LoanProductType."Penalty Paid Posting Group",
                TransactionTypeCodeSetup."Penalty Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApp2."Member No.");
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::"G/L Account", LoanProductType."Penalty Paid Posting Group", Text000 + "No." + '-' + LoanApp2.Description, -PenaltyDue, '',
                '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApp2."Member No.");
            end;
        end;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        Member: Record Member;
        AccType: Record "Account Type";
        AccType2: Record "Account Type";
        AccType3: Record "Account Type";
        Vendor: Record Vendor;
        Vendor2: Record Vendor;
        Vendor3: Record Vendor;
        StandingOrderSetup: Record "Standing Order Setup";
        JournalTemplateName: Code[50];
        JournalBatchName: Code[50];
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        AccountBalance: Decimal;
        ChargeAmount: Decimal;
        RunBal: Decimal;
        GlobalManagement: Codeunit "Global Management";
        SourceCodeSetup: Record "Source Code Setup";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        GlobalSetup: Record "Global Setup";
        TotalDeduction: Decimal;
        Cust: Record Customer;
        Loan: Record "Loan Application";
        Arrears: array[2] of Decimal;
        Overpayment: array[2] of Decimal;
        LProd: Record "Loan Product Type";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        Deposits: Decimal;
        LoanSchedule: Record "Loan Repayment Schedule";
        Customer: Record Customer;
        Memb: Record Member;
        DCustL: Record "Cust. Ledger Entry";
        "Loan Application": Record "Loan Application";
        i: Integer;
        TotalLoanAccount: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanApplication: Record "Loan Application";
        DateFormula: DateFormula;
        RunDate: Date;
        PostingDate: Date;
        LoanRep: Record "Loan Repayment Schedule";
}
