tableextension 50019 DetailedVendorLedgerEntryExt extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";

        }
        field(50003; "GL Account"; code[30])
        {
            Editable = false;
        }
        field(50005; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(50008; "Posting Description"; Text[300])
        {
            Editable = false;
        }
        field(50009; "Posting Transaction No."; Integer)
        {
            Caption = 'Posting Transaction No.';
            Editable = false;
        }
        field(50011; "Posting Vend Ledger Entry No."; Integer)
        {
            Caption = 'Posting Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(50012; "Posting Account No."; Code[20])
        {
        }
        field(50013; "Posting Reversal"; Boolean)
        {
        }
        field(50014; "Posting Amount"; Decimal)
        {
        }

    }

    var
        myInt: Integer;
}