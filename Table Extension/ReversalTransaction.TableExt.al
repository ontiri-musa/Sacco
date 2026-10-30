tableextension 50999 ReverseTransactionExt extends "Reversal Entry"
{
    fields
    {
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
    local procedure InsertFromCustLedgEntry(var TempRevertTransactionNo: record Integer; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        Cust: Record Customer;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SETCURRENTKEY("Transaction No.", "Customer No.", "Entry Type");
        DtldCustLedgEntry.SETFILTER(
       "Entry Type", '<>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        IF CustLedgEntry.FINDSET THEN
            REPEAT
                DtldCustLedgEntry.SETRANGE("Transaction No.", CustLedgEntry."Transaction No.");
                DtldCustLedgEntry.SETRANGE("Customer No.", CustLedgEntry."Customer No.");
                IF (NOT DtldCustLedgEntry.ISEMPTY) AND (RevType = RevType::Register) THEN
                    ERROR(Text012, Number);

                CLEAR(TempReversalEntry);
                IF RevType = RevType::Register THEN
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Customer;
                Cust.GET(CustLedgEntry."Customer No.");
                TempReversalEntry."Account No." := Cust."No.";
                TempReversalEntry."Account Name" := Cust.Name;
                TempReversalEntry.CopyFromCustLedgEntry(CustLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.INSERT;

                DtldCustLedgEntry.SETRANGE(Unapplied, TRUE);
                IF DtldCustLedgEntry.FINDSET THEN
                    REPEAT
                    //   InsertCustTempRevertTransNo(TempRevertTransactionNo, DtldCustLedgEntry."Unapplied by Entry No.");
                    UNTIL DtldCustLedgEntry.NEXT = 0;
                DtldCustLedgEntry.SETRANGE(Unapplied);
            UNTIL CustLedgEntry.NEXT = 0;
    end;

    local procedure InsertReversalEntry2(Number: Integer; RevType: Option Transaction,Register)
    var
        TempRevertTransactionNo: Record "Integer" temporary;
        NextLineNo: Integer;
    begin
        GLSetup.GET;
        TempReversalEntry.DELETEALL;
        NextLineNo := 1;
        TempRevertTransactionNo.Number := Number;
        TempRevertTransactionNo.INSERT;
        SetReverseFilter(Number, RevType);

        InsertFromCustLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        /*     InsertFromVendLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
             InsertFromBankAccLedgEntry(Number, RevType, NextLineNo);
             InsertFromFALedgEntry(Number, RevType, NextLineNo);
             InsertFromMaintenanceLedgEntry(Number, RevType, NextLineNo);
             InsertFromVATEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
             InsertFromGLEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);*/
        IF TempReversalEntry.FIND('-') THEN;
    end;

    local procedure ReverseEntries2(Number: Integer; RevType: Option Transaction,Register)
    var
        ReversalPost: Codeunit "Reversal-Post";
    begin
        InsertReversalEntry2(Number, RevType);
        TempReversalEntry.SETCURRENTKEY("Document No.", "Posting Date", "Entry Type", "Entry No.");
        HideDialog := TRUE;
        IF NOT HideDialog THEN
            PAGE.RUNMODAL(PAGE::"Reverse Entries", TempReversalEntry)
        ELSE BEGIN
            ReversalPost.SetPrint(FALSE);
            ReversalPost.SetHideDialog(TRUE);
            ReversalPost.RUN(TempReversalEntry);
        END;
        TempReversalEntry.DELETEALL;
    end;

    procedure ReverseTransaction2(TransactionNo: Integer)
    var

    begin

    end;

    var
        TempReversalEntry: Record "Reversal Entry" temporary;
        HideDialog: Boolean;
        GLSetup: Record "General Ledger Setup";
        NextLineNo: Integer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Text012: label 'You cannot reverse register No. %1 because it contains customer or vendor ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register No. %1 separately.';

}