codeunit 50339 "Charge Penalty Mobile Loans"
{
    var
        Cust: Record Customer;
        LoanRepSch: Record "Loan Repayment Schedule";
        disbursalDate: Date;
        "Loan Application": Record "Loan Application";
        LoanApplicationSetup: Record "Loan Application Setup";
        GlobalManagement: Codeunit "Global Management";
        RunDate: Date;
        BOSAManagement: Codeunit "BOSA Management";
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Penalty Charged-';
        CustomerPostingGroup: Record "Customer Posting Group";
        PenaltyDue: Decimal;
        Outbal: Decimal;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        DFilter: Text[100];
        AmoutInArrears: array[4] of Decimal;
        Overpayment: array[2] of Decimal;
        TotalArrears: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalMonthlyRepayment: Decimal;
        AmountPaid: Decimal;
        MonthDateFilter: Text;
        Prepayment: Decimal;
        dateDiff: Integer;
        penAmt: Decimal;
        PenCharged: Decimal;
        defaulterLoanNo: Code[35];
        intBal: Decimal;
        princBal: Decimal;
        penBal: Decimal;
        SourceCodeSetup: Record "Source Code Setup";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        Member: Record Member;
        CustL: Record "Cust. Ledger Entry";
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        postingDate: Date;
        LPrePaymentAmount: Decimal;
        LoanApp: Record "Loan Application";

    trigger OnRun()
    begin
        LoanApplicationSetup.Get();

        GlobalManagement.ClearJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name");

        // for postingDate := 20241212D To Today do begin
        postingDate := Today;
        RunDate := Calcdate('-1D', PostingDate);


        "Loan Application".Reset();
        // "Loan Application".SetRange("No.", 'BCL03675');
        "Loan Application".CalcFields("Outstanding Balance", Prepayment);
        "Loan Application".SetFilter(Posted, '%1', true);
        "Loan Application".SetRange(Cleared, false);
        "Loan Application".SetFilter("Date Filter", '..%1', postingDate);
        if "Loan Application".FindSet() then begin
            repeat

                LoanProductType.Get("Loan Application"."Loan Product Type");
                If LoanProductType."E-Loan" = true then begin

                    "Loan Application".CalcFields("Outstanding Balance", Prepayment);
                    if "Loan Application"."Outstanding Balance" > 0 then begin
                        Cust.Get("Loan Application"."No.");
                        if "Loan Application"."Date of Completion" >= postingDate then begin
                            LoanRepSch.Reset();
                            LoanRepSch.SetRange("Loan No.", "Loan Application"."No.");
                            LoanRepSch.SetRange("Repayment Date", RunDate);
                            if LoanRepSch.FindFirst() then begin
                                LoanApp.Reset();
                                LoanApp.SetRange("No.", "Loan Application"."No.");
                                LoanApp.SetFilter("Date Filter", '..%1', postingDate);
                                if LoanApp.FindFirst() then begin
                                    CapitalizePenaltyMob(Cust, RunDate, postingDate, LoanRepSch."Total Installment", LoanApp);
                                end;
                            end;

                        end;/* else begin
                            if CalcDate('90D', "Loan Application"."Date of Completion") >= postingDate then begin
                                RecoverLoanFromPrepayment(Cust, RunDate, postingDate, LoanRepSch."Total Installment", "Loan Application");
                                CreateMobileDefaultLoan(Cust, postingDate, "Loan Application".Prepayment);
                            end;
                        end;*/
                    end;
                end;

            until "Loan Application".Next = 0;
        end;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", LoanApplicationSetup."Penalty Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name", LoanApplicationSetup."Penalty Batch Name");
        IF GenJournalLine.FINDSET THEN BEGIN
            GenJnlPostBatch.RUN(GenJournalLine);
        end;
        //  Commit();
        // end;
    end;
    //GlobalManagement.PostJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name");



    //-------------------------------
    //   end;

    procedure CapitalizePenaltyMob(var Customer: Record Customer; RunDate: Date; PostingDate: Date; TotalMonthlyRepayment: Decimal; LoanApp2: Record "Loan Application")
    var

    begin
        with Customer do begin

            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            LoanProductType.Get(Customer."Customer Posting Group");
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


            CustL.Reset();
            CustL.SetRange("Customer No.", Customer."No.");
            CustL.SetRange("Posting Date", PostingDate);
            CustL.SetRange(Reversed, false);
            CustL.SetRange("Transaction Type Code", 'PENDUE');
            if not CustL.FindSet() then begin
                PenaltyDue := PenaltyDue;
            end else begin
                PenaltyDue := 0;
            end;

            If PenaltyDue > 0 Then Begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text000 + "No.", PenaltyDue, LoanProductType."Penalty Paid Posting Group",
                TransactionTypeCodeSetup."Penalty Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::"G/L Account", LoanProductType."Penalty Paid Posting Group", Text000 + "No.", -PenaltyDue, '',
                '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
            end;
        end;
    end;

    procedure RecoverLoanFromPrepayment(var Customer: Record Customer; RunDate: Date; PostingDate: Date; TotalMonthlyRepayment: Decimal; LoanApp2: Record "Loan Application")
    var
        prepayment: Decimal;
        PrincRecov: Decimal;
        PenaltyRecov: Decimal;
        IntRecov: Decimal;
    begin
        with Customer do begin

            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            LoanProductType.Get(Customer."Customer Posting Group");
            TransactionTypeCodeSetup.Get();
            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Penalty Due");
            TransactionTypeCodeSetup.TestField("Penalty Paid");
            LoanApplicationSetup.TestField("Penalty Template Name");
            LoanApplicationSetup.TestField("Penalty Batch Name");

            Outbal := 0;
            PenaltyDue := 0;
            PenaltyRecov := 0;
            PrincRecov := 0;
            DFilter := '..' + Format(PostingDate);
            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", DFilter);
            if DCustL.FindSet() then begin
                repeat
                    if (DCustL."Transaction Type Code" = 'PENDUE') or (DCustL."Transaction Type Code" = 'PENPAID') then
                        penBal += DCustL.Amount;
                    if (DCustL."Transaction Type Code" = 'INTPAID') or (DCustL."Transaction Type Code" = 'INTDUE') then
                        intBal += DCustL.Amount;
                    if (DCustL."Transaction Type Code" = 'NEWLOAN') or (DCustL."Transaction Type Code" = 'PPAID') then
                        princBal += DCustL.Amount;
                until DCustL.Next() = 0;
            end;

            LoanApp2.CalcFields("Outstanding Balance", Prepayment);


            if LoanApp2.Prepayment < 0 then begin
                LoanApp2.Prepayment *= -1;

                PenaltyRecov := PenCharged;
                IntRecov := intBal;
                PrincRecov := princBal;
                If LoanApp2.Prepayment > 0 Then Begin
                    If PenaltyRecov >= LoanApp2.Prepayment then begin
                        PenaltyRecov := LoanApp2.Prepayment;
                        LoanApp2.Prepayment := 0;
                    end else begin
                        PenaltyRecov := PenaltyRecov;
                        LoanApp2.Prepayment -= PenaltyRecov;
                    end;


                    If IntRecov >= LoanApp2.Prepayment then begin
                        IntRecov := LoanApp2.Prepayment;
                        LoanApp2.Prepayment := 0;
                    end else begin
                        IntRecov := IntRecov;
                        LoanApp2.Prepayment -= IntRecov;
                    end;

                    If PrincRecov >= LoanApp2.Prepayment then begin
                        PrincRecov := LoanApp2.Prepayment;
                        LoanApp2.Prepayment := 0;
                    end else begin
                        PrincRecov := PrincRecov;
                        LoanApp2.Prepayment -= PrincRecov;
                    end;



                    if PenaltyRecov > 0 then begin
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Penalty Paid From Prepayment-' + "No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                         TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Penalty Recoverd From Prepayment-' + "No.", PenaltyRecov, LoanProductType."Loan Prepayment Posting Group",
                        TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end;


                    if IntRecov > 0 then begin
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Interest Recoverd From Prepayment-' + "No.", IntRecov, LoanProductType."Loan Prepayment Posting Group",
                       TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Interest Paid From Prepayment-' + "No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                        TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end;
                    If PrincRecov > 0 Then begin
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Principal Recoverd From Prepayment-' + "No.", PrincRecov, LoanProductType."Loan Prepayment Posting Group",
                        TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Principal Paid From Prepayment-' + "No.", -PrincRecov, LoanProductType."Loan Posting Group",
                        TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end;

                end;
            end;
        end;
    end;

    procedure CreateMobileDefaultLoan(Var Customer: Record Customer; postingDate: Date; prepayAmt: Decimal)
    var
        prepayment: Decimal;
        PrincRecov: Decimal;
        PenaltyRecov: Decimal;
        IntRecov: Decimal;
    begin
        with Customer Do Begin
            LoanApplicationSetup.GET;

            IF Member.GET(BOSAManagement.fnGetmemberNo("No.")) THEN BEGIN
                penBal := 0;
                intBal := 0;
                princBal := 0;
                Outbal := 0;
                //  prePayAmt:=0;
                PenaltyDue := 0;
                PenaltyRecov := 0;
                PrincRecov := 0;


                CalcFields(Balance);
                Outbal := Balance;
                DFilter := '..' + Format(PostingDate);

                DCustL.Reset();
                DCustL.SetRange("Customer No.", Customer."No.");
                DCustL.SetFilter("Posting Date", DFilter);
                if DCustL.FindSet() then begin
                    repeat
                        if (DCustL."Transaction Type Code" = 'PENDUE') or (DCustL."Transaction Type Code" = 'PENPAID') then
                            penBal += DCustL.Amount;
                        if (DCustL."Transaction Type Code" = 'INTPAID') or (DCustL."Transaction Type Code" = 'INTDUE') then
                            intBal += DCustL.Amount;
                        if (DCustL."Transaction Type Code" = 'NEWLOAN') or (DCustL."Transaction Type Code" = 'PPAID') then
                            princBal += DCustL.Amount;
                    until DCustL.Next() = 0;
                end;

                if prepayAmt < 0 then begin
                    prepayAmt *= -1;

                    PenaltyRecov := PenCharged;
                    IntRecov := intBal;
                    PrincRecov := princBal;
                    If prepayAmt > 0 Then Begin
                        If PenaltyRecov >= prepayAmt then begin
                            PenaltyRecov := prepayAmt;
                            prepayAmt := 0;
                        end else begin
                            PenaltyRecov := PenaltyRecov;
                            prepayAmt -= PenaltyRecov;
                        end;


                        If IntRecov >= prepayAmt then begin
                            IntRecov := prepayAmt;
                            prepayAmt := 0;
                        end else begin
                            IntRecov := IntRecov;
                            prepayAmt -= IntRecov;
                        end;

                        If PrincRecov >= prepayAmt then begin
                            PrincRecov := prepayAmt;
                            prepayAmt := 0;
                        end else begin
                            PrincRecov := PrincRecov;
                            prepayAmt -= PrincRecov;
                        end;
                    end;
                end;






                defaulterLoanNo := BOSAManagement.createDefaulterloanAccount(Outbal, Member."Phone No.");
                IF LoanApplication.GET(defaulterLoanNo) THEN BEGIN
                    // clear interest
                    if (intBal - IntRecov) > 0 then begin
                        GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC-' + Format(PostingDate), "No.", postingDate, AccountTypeEnum::Customer, "No.", 'loan Recovered Mob ' + "No.", -(intBal - IntRecov), LoanProductType."Interest Due Posting Group",
                        'INTPAID', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    end;
                    //recover penalty
                    if (penBal - PenaltyRecov) > 0 then begin

                        GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC-' + Format(PostingDate), "No.", postingDate, AccountTypeEnum::Customer, "No.", 'Penalty Recovered ' + "No.", -(penBal - PenaltyRecov), LoanProductType."Penalty Due Posting Group",
                        'PENPAID', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    end;
                    //recover principal
                    if (princBal - PrincRecov) > 0 then begin
                        GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC-' + Format(PostingDate), "No.", postingDate, AccountTypeEnum::Customer, "No.", 'Principal Recovered ' + "No.", -(princBal - PrincRecov), LoanProductType."Loan Posting Group",
                        'PPAID', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    end;
                    //newLoan
                    GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'REC-' + Format(PostingDate), "No.", postingDate, AccountTypeEnum::Customer, defaulterLoanNo, 'Defaulter Recovery ' + "No.", Outbal, '',
                    'NEWLOAN', SourceCodeSetup.Loan, LoanApplication."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                end;
            end
        end;
    end;
}
