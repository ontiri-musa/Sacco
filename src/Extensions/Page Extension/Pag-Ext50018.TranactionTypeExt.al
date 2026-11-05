pageextension 50018 "Tranaction Type Ext" extends "Transaction Types"
{
    layout
    {
        addafter(Description)
        {
            field("Is Loan Transaction Type"; "Is Loan Transaction Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
