table 75061 "B2B setup"
{

    fields
    {
        field(1; "TL settlement AC"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(2; "Coop settlement AC"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Sacco settlement AC"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "TL Commission"; Decimal)
        {
        }
        field(5; "Coop Commission"; Decimal)
        {
        }
        field(6; "Sacco Commission"; Decimal)
        {
        }
        field(7; "Withholding Tax"; Decimal)
        {
        }
        field(8; "Withholding Tax AC"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Accounty Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(10; "Account Code"; Code[20])
        {
        }
        field(11; "B2B Bank"; Code[40])
        {
            TableRelation = "Bank Account";
        }
    }

    keys
    {
        key(Key1; "TL settlement AC")
        {
        }
    }

    fieldgroups
    {
    }
}

