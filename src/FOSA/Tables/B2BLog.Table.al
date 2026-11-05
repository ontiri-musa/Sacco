table 75062 "B2B logs"
{

    fields
    {
        field(1; "No."; Integer)
        {
        }
        field(2; "Member No."; Code[30])
        {
        }
        field(3; "Member Name"; Text[250])
        {
        }
        field(4; "Account No."; Code[30])
        {
        }
        field(5; "Amount Transacted"; Decimal)
        {
        }
        field(6; "Tax Charged"; Decimal)
        {
        }
        field(7; "Coop Commission"; Decimal)
        {
        }
        field(8; "Tl Commission"; Decimal)
        {
        }
        field(9; "Sacco Commission"; Decimal)
        {
        }
        field(10; "Transaction Date"; Date)
        {
        }
        field(11; "Reference Number"; Text[50])
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "Transcation Reference"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

