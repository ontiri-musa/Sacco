tableextension 50016 CustLedgerEntryExt extends "Cust. Ledger Entry"
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
        field(50003; "GL Account"; code[30])
        {
            Editable = false;
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
        field(50012; "Posting Loan No."; Code[20])
        {
        }
        field(50013; "Posting Reversal"; Boolean)
        {
        }
        field(50014; "Posting Amount"; Decimal)
        {
        }
        field(50015; "Date Posted"; Date)
        {
        }
        field(50016; "Posting Doc No"; Code[100])
        {
        }
        field(50017; "Posted By"; code[100])
        {
        }
        field(50018; "Detailed Ledger Entry No"; Integer)
        {
        }
    }

    var
        myInt: Integer;
}