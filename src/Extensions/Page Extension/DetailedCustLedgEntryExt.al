pageextension 50409 "Detailed Cust Ledg EntryExt" extends "Detailed Cust. Ledg. Entries"
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
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }
            field("GL Account"; "GL Account")
            {
                ApplicationArea = All;
            }
            field("Member No."; "Member No.")
            {
                ApplicationArea = All;
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
        CustL: Record "Cust. Ledger Entry";
    begin
        Description := '';
        Reversed := false;
        ExternalDocNo := '';

        CustL.Reset();
        CustL.SetRange("Entry No.", "Cust. Ledger Entry No.");
        if CustL.FindFirst() then begin
            Description := CustL.Description;
            Reversed := CustL.Reversed;
            ExternalDocNo := CustL."External Document No.";
        end;
    end;
}
