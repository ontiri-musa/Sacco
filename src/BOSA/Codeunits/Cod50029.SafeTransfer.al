codeunit 50029 "Safe Transfer"
{
    trigger OnRun()
    Begin
        MobileBSetup.Get();

        MobileBankingLedger.Reset();
        if MobileBankingLedger.FindSet() then begin
            repeat
                GLEntry.Reset();
                GLEntry.SetRange("Document No.", MobileBankingLedger."Transaction No.");
                GLEntry.SetFilter("G/L Account No.", '%1|%2|%3|%4', MobileBSetup."KCB Bank Suspense", MobileBSetup."Equity Bank Suspense", MobileBSetup."Co-operative Bank Suspense", MobileBSetup."Old Paybill Suspense");
                GLEntry.SetFilter("Credit Amount", '>%1', 0);
                if GLEntry.FindFirst() then begin
                    MobileSuspense.Init();
                    MobileSuspense.TransferFields(MobileBankingLedger);
                    MobileSuspense.Insert();
                    MobileBankingLedger.Delete();
                end;
            until MobileBankingLedger.Next = 0;
        end;
        Message('Update Complete');
    end;

    var
        MobileBankingLedger: Record "Mobile Banking Ledger Entry";
        MobileSuspense: Record "Mobile Banking Suspense";
        MobileBSetup: Record "Mobile Banking Setup";
        GLEntry: Record "G/L Entry";
}
