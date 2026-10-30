tableextension 50018 VendorLedgerEntryExt extends "Vendor Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";

        }
        field(50005; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
    }

    var
        myInt: Integer;
}