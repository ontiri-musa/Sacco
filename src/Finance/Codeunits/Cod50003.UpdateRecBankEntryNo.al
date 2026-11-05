codeunit 50003 UpdateRecBankEntryNo
{
    trigger OnRun()
    var
        BankRecLine: Record "Bank Acc. Reconciliation Line";
        BankRec: Record "Bank Acc. Reconciliation";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankRec.Reset();
        if BankRec.FindSet() then begin
            repeat
                BankRecLine.Reset();
                BankRecLine.SetRange("Statement No.", BankRec."Statement No.");
                IF BankRecLine.FindSet() then begin
                    repeat
                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Posting Date", BankRecLine."Transaction Date");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Document No.", BankRecLine."Document No.");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."External Document No.", BankRecLine."External Doc No");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Amount, BankRecLine."Statement Amount");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Description, BankRecLine.Description);
                        IF BankAccountLedgerEntry.FINDFIRST THEN begin
                            BankRecLine."Ledger Entry No" := BankAccountLedgerEntry."Entry No.";
                            BankRecLine.Modify();
                        end;
                    until BankRecLine.Next = 0;
                end;
            until BankRec.Next = 0;
        end;
    end;

}
