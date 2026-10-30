codeunit 50340 CorrectWrongPenalties
{
    trigger OnRun()
    begin
        /*  custRec1.Reset();
          custRec1.setfilter("Customer Posting Group", '%1', 'MB');
          if custRec1.FindSet() then begin
              repeat
                  cust.Reset();
                  cust.SetRange("Customer No.", custRec."No.");
                  cust.SetRange("Transaction Type Code", 'PENDUE');
                  cust.SetFilter(Reversed, '%1', false);
                  cust.SetFilter("Posting Date", '%1..%2', 20240326D, Today);
                  if cust.FindSet() then begin
                      repeat
                          GLEntry.Reset();
                          GLEntry.SetRange(GLEntry."Transaction No.", cust."Transaction No.");
                          GLEntry.SetRange(Reversed, false);
                          if GLEntry.FindSet() then begin
                              repeat
                                  ReversalEntry.SetHideWarningDialogs();
                                  ReversalEntry.SetHideDialog(true);
                                  ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                              until GLEntry.Next() = 0;
                          end;
                      until cust.next() = 0;
                  end;
              until custRec1.next = 0;
          end;
          Commit();*/
        /*  LoanApplicationSetup.Get();

          GlobalManagement.ClearJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name");
          for postingDate := 20240326D To Today do begin
              RunDate := Calcdate('-1D', PostingDate);
              "Loan Application".Reset();
              "Loan Application".SetFilter(Posted, '%1', true);
              if "Loan Application".FindSet() then begin
                  repeat
                      LoanProductType.Get("Loan Application"."Loan Product Type");
                      If LoanProductType."E-Loan" = true then begin
                          "Loan Application".CalcFields("Outstanding Balance");
                          if "Loan Application"."Outstanding Balance" > 0 then begin
                              custRec.Get("Loan Application"."No.");
                              //  if "Loan Application"."Date of Completion" >= postingDate then begin
                              LoanRepSch.Reset();
                              LoanRepSch.SetRange("Loan No.", "Loan Application"."No.");
                              LoanRepSch.SetRange("Repayment Date", RunDate);
                              if LoanRepSch.FindFirst() then begin
                                  LoanApp.Reset();
                                  LoanApp.SetRange("No.", "Loan Application"."No.");
                                  LoanApp.SetFilter("Date Filter", '..%1', postingDate);
                                  If LoanApp.FindFirst() then begin
                                      LoanApp.CalcFields("Outstanding Balance");
                                      //Message('%1', postingDate);
                                      CapitalizePenaltyMob(custRec, LoanApp."Disbursal Date", postingDate, LoanApp);
                                  end;
                              end;
                          end;


                      end;
                  // end;
                  until "Loan Application".Next() = 0;
              end;
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name", LoanApplicationSetup."Penalty Template Name");
              GenJournalLine.SETRANGE("Journal Batch Name", LoanApplicationSetup."Penalty Batch Name");
              IF GenJournalLine.FINDSET THEN BEGIN
                  GenJnlPostBatch.RUN(GenJournalLine);
              end;
              Commit();


          end;*/


    end;

    procedure CapitalizePenaltyMob(Customer: Record Customer; RunDate: Date; PostingDate: Date; Loan: Record "Loan Application")
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
            DFilter := '..' + Format(PostingDate);
            Outbal := 0;
            Loan.CalcFields("Outstanding Balance");
            Outbal := Loan."Outstanding Balance";
            MonthDateFilter := Format(RunDate) + '..' + Format(PostingDate);



            CustL.Reset();
            CustL.SetRange("Customer No.", Customer."No.");
            CustL.SetFilter("Posting Date", MonthDateFilter);
            CustL.SetRange("Transaction Type Code", TransactionTypeCodeSetup."Principal Paid", TransactionTypeCodeSetup."Loan Prepayment");
            CustL.SetRange(Reversed, false);
            if CustL.FindSet() then begin
                repeat
                    CustL.CalcFields("Credit Amount");
                    AmountPaid += CustL."Credit Amount";
                until CustL.Next = 0;
            end;

            if AmountPaid = 0 then begin
                PenaltyDue := 0;
                PenaltyDue := Round(((5 / 100) * Outbal), 1, '=');
            end;

            if AmountPaid > 0 then begin
                PenaltyDue := 0;
                if AmountPaid < Loan."Approved Amount" then begin
                    PenaltyDue := Round(((5 / 100) * Outbal), 1, '=');
                end
            end;
            /* GlobalManagement.CalculateLoanPrepayment(Customer."No.", 0D, PostingDate, Prepayment);
             Prepayment := -(Prepayment);*/
            if PenaltyDue > 0 then begin

                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text000 + "No.", PenaltyDue, LoanProductType."Penalty Paid Posting Group",
                TransactionTypeCodeSetup."Penalty Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::"G/L Account", LoanProductType."Penalty Paid Posting Group", Text000 + "No.", -PenaltyDue, '',
                '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

            end;
        end;
        /* if Prepayment > 0 then begin
              if Prepayment > PenaltyDue then
                  Prepayment := PenaltyDue
              else
                  Prepayment := Prepayment;

              GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Txt004 + "No.", Prepayment, LoanProductType."Loan Prepayment Posting Group",
                TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
              GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Txt004 + "No.", -Prepayment, LoanProductType."Loan Posting Group",
              TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
          end else begin*/
        /*  If PenaltyDue > 0 Then Begin
              GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text000 + "No.", PenaltyDue, LoanProductType."Penalty Paid Posting Group",
              TransactionTypeCodeSetup."Penalty Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
              GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(PostingDate), "No.", PostingDate, AccountTypeEnum::"G/L Account", LoanProductType."Penalty Paid Posting Group", Text000 + "No.", -PenaltyDue, '',
              '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
          end;
          if LPrePaymentAmount > 0 then begin
              If PenaltyDue >= LPrePaymentAmount then begin
                  PenaltyDue := LPrePaymentAmount;
                  LPrePaymentAmount := 0;
              end else begin
                  PenaltyDue := PenaltyDue;

              end;
              //Recover Penalty
              If PenaltyDue > 0 then begin
                  GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Text0005' + "No.", PenaltyDue, LoanProductType."Loan Prepayment Posting Group",
                  TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                  GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", 'Text0006' + "No.", -PenaltyDue, LoanProductType."Penalty Due Posting Group",
                  TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
              end;
          end;*/
    end;
    // end;

    var

        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        custRec: Record Customer;
        custRec1: Record Customer;
        Cust: Record "Cust. Ledger Entry";
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
        loanApp: Record "Loan Application";
        Txt004: Label 'Penalty Recovered From Prepayment-';
}