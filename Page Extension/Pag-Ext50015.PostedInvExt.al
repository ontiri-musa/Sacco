pageextension 50015 PostedInvoiceExt extends "Posted Purchase Invoice"
{
    layout
    {
        modify("Invoice Details")
        {
            Visible = false;
        }

        modify("Shipping and Payment")
        {
            Visible = false;
        }
    }
    actions
    {
        addafter("Update Document")
        {
            action(ReverseDoc)
            {
                Caption = 'Reverse Invoice';
                Image = ReverseLines;
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = Basic, Suite;
                trigger OnAction();
                var
                    GLEntry: Record "G/L Entry";
                    ReversalEntry: Record "Reversal Entry";
                begin
                    GLEntry.Reset();
                    GLEntry.SetRange(GLEntry."Document No.", "No.");
                    GLEntry.SetRange(Reversed, false);
                    if GLEntry.FindSet() then begin
                        repeat
                            ReversalEntry.SetHideWarningDialogs();
                            ReversalEntry.SetHideDialog(true);
                            ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                        until GLEntry.Next() = 0;
                    end;
                    Rec.Cancelled := True;
                    Rec.Modify();
                end;
            }
        }
    }
}
