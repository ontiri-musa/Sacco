report 51333 insurranceCorretction
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'insurranceFeeCorrections';

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/insurranceFeeCorrections.rdl';

    dataset
    {
        dataitem(insurranceCorrections; insurranceCorrections)
        {
            column(loanNo; loanNo)
            {

            }
            column(mnNO; mnNO)
            {

            }
            column(actualAmtCharged; actualAmtCharged)
            {

            }
            column(expectedAmountCharged; expectedAmountCharged)
            {

            }
            trigger OnPreDataItem()
            begin
                GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");
            end;

            trigger OnAfterGetRecord()
            begin
                actualAmtCharged := 0;
                expectedAmountCharged := 0;
                if loanNo = '' then CurrReport.Skip();
                glEntry.Reset();
                glEntry.SetRange("Document No.", loanNo);
                glEntry.SetFilter("Transaction Type Code", 'INSFEE');
                glEntry.SetRange(Reversed, false);
                if glEntry.FindFirst() then begin
                    actualAmtCharged := ABS(glEntry.Amount);
                end;


                loanApp.Reset();
                loanApp.SetRange("No.", loanNo);
                if loanApp.FindFirst() then begin
                    LoanProductCharge.RESET;
                    LoanProductCharge.SETRANGE("Loan Product Type", loanApp."Loan Product Type");
                    IF LoanProductCharge.FINDSET THEN BEGIN
                        REPEAT
                            LoanChargeSetup.Get(LoanProductCharge.Code);
                            IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" THEN BEGIN
                                if LoanChargeSetup.Type = LoanChargeSetup.Type::"Insurance Fee" then begin
                                    expectedAmountCharged := Round(((LoanProductCharge.Value * loanAmt * period) / 1200), 1, '=');
                                    //(LoanProductCharge.Value * LoanAmount * Instalments) / 1200;
                                end;
                            end;
                        until LoanProductCharge.Next() = 0;
                    end;

                end;
                //if actual insurance fee not equal to expected Amt to charge pass corrective Journal to reverse
                if actualAmtCharged <> expectedAmountCharged then begin
                    LoanApplicationSetup.Get();
                    //   LoanChargeSetup.Get();
                    //debit income
                    /* GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date", AccountTypeEnum::"G/L Account",
                                      LoanChargeSetup."Income G/L Account", 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), actualAmtCharged, '', 'INSFEE', 'LOAN', loanApp."Global Dimension 1 Code",
                                      BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', loanApp."Member No.");
                     //credit loan
                     GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date", AccountTypeEnum::Customer,
                     loanApp."No.", 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), -actualAmtCharged, '', 'INSFEE', 'LOAN', loanApp."Global Dimension 1 Code",
                     BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', loanApp."Member No.");


                     //debit loan with expected Amt
                     GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date", AccountTypeEnum::Customer,
                                                   loanApp."No.", 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), insFee, '', 'INSFEE', 'LOAN', loanApp."Global Dimension 1 Code",
                                                   BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', loanApp."Member No.");

                     //credit income gl with expected amt
                     GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date", AccountTypeEnum::"G/L Account",
                                                           LoanChargeSetup."Income G/L Account", 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), -insFee, '', 'INSFEE', 'LOAN', loanApp."Global Dimension 1 Code",
                                                           BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', loanApp."Member No.");

                     //if actual amt is less than expected amt additional to bank
                     if actualAmtCharged < expectedAmountCharged then begin
                         additionalToBank := (expectedAmountCharged - actualAmtCharged);
                         GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date",
                                                       AccountTypeEnum::"Bank Account", loanApp."Disbursal Account No.", 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), -additionalToBank, '', 'NEWLOAN', 'LOAN', loanApp."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', loanApp."Member No.");
                     end;
                      if actualAmtCharged > expectedAmountCharged then begin
                         lessToBank := (actualAmtCharged -expectedAmountCharged );
                         GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date",
                                                       AccountTypeEnum::"Bank Account", loanApp."Disbursal Account No.", 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), lessToBank, '', 'NEWLOAN', 'LOAN', loanApp."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', loanApp."Member No.");
                     end;

                 end;*/
                    if actualAmtCharged < expectedAmountCharged then begin
                        additionalToBank := (insFee - actualAmtCharged);
                        GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date", AccountTypeEnum::"G/L Account",
                                        '3404', 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), -additionalToBank, '', 'INSFEE', 'LOAN', loanApp."Global Dimension 1 Code",
                                        BalAccountTypeEnum::"Bank Account", loanApp."Disbursal Account No.", AppliesToDocTypeEnum::" ", '', loanApp."Member No.");
                    end;
                    if actualAmtCharged > expectedAmountCharged then begin
                        lessToBank := (actualAmtCharged - insFee);
                        GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", 'INSREV' + format(loanNo), 'INSREV' + format(loanNo), loanApp."Disbursal Date", AccountTypeEnum::"G/L Account",
                                     '3404', 'Insurance Fee corrective journal For- ' + Format(loanApp."No."), lessToBank, '', 'INSFEE', 'LOAN', loanApp."Global Dimension 1 Code",
                                     BalAccountTypeEnum::"Bank Account", loanApp."Disbursal Account No.", AppliesToDocTypeEnum::" ", '', loanApp."Member No.");
                    end;
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name", LoanApplicationSetup."Loan Disbursal Template Name");
                    GenJournalLine.SETRANGE("Journal Batch Name", LoanApplicationSetup."Loan Disbursal Batch Name");
                    IF GenJournalLine.FINDSET THEN BEGIN
                        COMMIT;
                        GenJnlPostBatch.RUN(GenJournalLine)

                    END;
                end;
            end;
        }
    }




    var
        myInt: Integer;
        glEntry: Record "G/L Entry";
        actualAmtCharged: Decimal;
        expectedAmountCharged: Decimal;
        loanApp: Record "Loan Application";
        LoanProductCharge: record "Loan Product Charge";
        LoanChargeSetup: Record "Loan Charge Setup";
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        additionalToBank: Decimal;
        lessToBank: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";

}