tableextension 50020 GLEntryExt extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(50001; "Principal Transaction"; Boolean)
        {
            Editable = false;
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
        field(50011; "Posting Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Posting Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
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
        field(50015; "Posting Source No."; Code[20])
        {
        }
        field(50017; "Date Posted"; Date)
        {
        }
        field(50018; "Posting Doc No"; Code[100])
        {
        }
        field(50019; "Posted By"; code[100])
        {
        }
        field(50020; "Loan Transaction"; Boolean)
        {
            Editable = false;
        }
    }

    var
        myInt: Integer;
}