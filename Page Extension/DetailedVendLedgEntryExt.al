pageextension 50002 DetailedVendLedgEntryExt extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Transaction Type Code"; "Transaction Type Code")
            {
            }
            field(Reversed; Reversed)
            {
                Editable = false;
            }
        }
        addafter("Document No.")
        {
            field(ExternalDocNo; ExternalDocNo)
            {
                Editable = false;
                Caption = 'External Document No';
            }
            field(Description; Description)
            {
                Editable = false;
            }
        }
        addafter("User ID")
        {
            field(SystemCreatedAt; SystemCreatedAt)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SystemModifiedAt; SystemModifiedAt)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        modify("Entry Type")
        {
            Visible = false;
        }
        modify("Document Type")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Initial Entry Due Date")
        {
            Visible = false;
        }
    }
    actions
    {
        // Add changes to page actions here
        addafter("Unapply Entries")
        {
            group(main)
            {
                action(Reverse)
                {
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
                        GLEntry.SetRange(GLEntry."Document No.", "Document No.");
                        GLEntry.SetRange(GLEntry."Transaction No.", "Transaction No.");
                        GLEntry.SetRange(Reversed, false);
                        if GLEntry.FindSet() then begin
                            repeat
                                ReversalEntry.SetHideWarningDialogs();
                                ReversalEntry.SetHideDialog(true);
                                ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                            until GLEntry.Next() = 0;
                        end;
                    end;
                }
            }
        }
    }
    var
        Description: Text;
        Reversed: Boolean;
        ExternalDocNo: Code[150];

    trigger OnAfterGetRecord()
    var
        VendL: Record "Vendor Ledger Entry";
    begin
        /*
         Description := '';
         Reversed := false;
         ExternalDocNo := '';

         VendL.Reset();
         VendL.SetRange("Entry No.", Rec."Vendor Ledger Entry No.");
         if VendL.FindFirst() then begin
             Description := VendL.Description;
             Reversed := VendL.Reversed;
             ExternalDocNo := VendL."External Document No.";
         end;
         */
    end;

    trigger OnAfterGetCurrRecord()
    var
        VendL: Record "Vendor Ledger Entry";
    begin
        Description := '';
        Reversed := false;
        ExternalDocNo := '';

        VendL.Reset();
        VendL.SetRange("Entry No.", Rec."Vendor Ledger Entry No.");
        if VendL.FindFirst() then begin
            Description := VendL.Description;
            Reversed := VendL.Reversed;
            ExternalDocNo := VendL."External Document No.";
        end;
    end;
}
