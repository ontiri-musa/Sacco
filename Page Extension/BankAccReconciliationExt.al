pageextension 50004 "BankAcc.ReconciliationExt" extends "Bank Acc. Reconciliation"
{
    actions
    {
        // Add changes to page actions here
        modify(MatchManually)
        {
            trigger OnBeforeAction()
            var
                TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
            begin
                CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                if TempBankAccReconciliationLine."Statement Amount" <> TempBankAccountLedgerEntry.Amount then
                    Error('The Amounts do not match');
                // MatchBankRecLines.MatchManually(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
            end;
        }
        modify(SuggestLines)
        {
            trigger OnAfterAction()
            var
                BankStatLine: Record "Bank Account Statement Line";
                BankStatLine2: Record "Bank Account Statement Line";
            begin
                BankStatLine.Reset();
                BankStatLine.SetRange(BankStatLine."Statement No.", "Statement No.");
                BankStatLine.SetRange(BankStatLine."Bank Account No.", "Bank Account No.");
                if BankStatLine.FindSet() then begin
                    repeat
                        BankStatLine2.Reset();
                        BankStatLine2.SetRange(BankStatLine2."Statement No.", BankStatLine."Statement No.");
                        BankStatLine2.SetRange(BankStatLine2."Document No.", BankStatLine."Document No.");
                        BankStatLine2.SetRange(BankStatLine2."Statement Amount", BankStatLine."Statement Amount");
                        If BankStatLine2.FindSet() then begin
                            if BankStatLine2.Count > 1 then begin

                            end;
                        end;
                    until BankStatLine.Next = 0;
                end;
            end;
        }

    }

}
