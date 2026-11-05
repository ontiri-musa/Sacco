pageextension 50021 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        modify("Original Amount")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Document Type")
        {
            Visible = false;
        }
        addafter(Amount)
        {
            field("Transaction Type Code"; "Transaction Type Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
