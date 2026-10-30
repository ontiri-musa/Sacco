table 50033 "CTS Setup"
{
    // version CTS2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }

        field(3; "Charges Per Leaf"; Decimal)
        {
        }

        field(6; "Charges G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(8; "Charge Excise Duty"; Boolean)
        {
        }

        field(10; "Clearance Charges"; Decimal)
        {
        }
        field(11; "Commission G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Cheque Clearance Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13; "SMS Charges"; Decimal)
        {
        }
        field(14; "SMS G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(16; "Penalty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(20; "Cheque Clearance Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(21; "Cheque Template Name"; Code[10])
        {
            Caption = 'Cheque Journal Template';
            TableRelation = "Gen. Journal Template";
        }
        field(22; "Cheque Batch Name"; Code[10])
        {
            Caption = 'Cheque Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cheque Template Name"));
        }
        field(23; "Coinage Mandatory"; Boolean)
        {
        }
        field(24; "Cheque Book Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(25; "Cheque Book Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

