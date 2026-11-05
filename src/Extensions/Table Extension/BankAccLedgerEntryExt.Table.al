tableextension 50012 BankAccLedgerEntryExt extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "Posting Time"; Time)
        {
        }
        field(50001; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(50002; "Running Balance"; Decimal)
        {

        }
        field(50005; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
    }

    var
        myInt: Integer;
}