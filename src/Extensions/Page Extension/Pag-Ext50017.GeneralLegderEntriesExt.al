pageextension 50017 "General Legder Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Transaction Type Code"; "Transaction Type Code")
            {
                ApplicationArea = All;
            }
            field("Member No."; "Member No.")
            {
                ApplicationArea = All;
            }
            field("Loan Transaction"; "Loan Transaction")
            {
                ApplicationArea = All;
            }
            field("Posting Loan No."; "Posting Loan No.")
            {
                ApplicationArea = All;
            }
            field("Posting Cust. Ledger Entry No."; "Posting Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
            }
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bal. Account No.")
        {
            field("Source Type"; "Source Type")
            {
                ApplicationArea = All;
            }
            field("Source No."; "Source No.")
            {
                ApplicationArea = All;
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
    }
}
