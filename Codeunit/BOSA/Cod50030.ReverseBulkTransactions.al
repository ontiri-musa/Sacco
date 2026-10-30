codeunit 50030 "Reverse Bulk Transactions"
{
    trigger OnRun()
    begin
        GLEntry.Reset();
        GLEntry.SetRange(GLEntry."G/L Account No.", '3426');
        GLEntry.SetRange(Reversed, false);
        if GLEntry.FindSet() then begin
            repeat
                ReversalEntry.SetHideWarningDialogs();
                ReversalEntry.SetHideDialog(true);
                ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
            until GLEntry.Next() = 0;
        end;
    end;

    var
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
}
