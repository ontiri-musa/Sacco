table 50197 "Transaction Type Code Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Appraisal Fee"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(3; "Insurance Fee"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(4; "Refinancing Fee"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(5; "Principal Paid"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(6; "Interest Paid"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(7; "Interest Due"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(8; "New Loan"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(9; "Ledger Fee Due"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(10; "Processing Fee"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(11; "Registration Fee"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(12; "Monthly Contribution"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(13; "Penalty Due"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(14; "Opening Balance"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(15; "Ledger Fee Paid"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(16; "Penalty Paid"; Code[20])
        {
            TableRelation = "Transaction Type";
        }
        field(17; "Loan Prepayment"; Code[20])
        {
            TableRelation = "Transaction Type";
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}