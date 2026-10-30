table 50108 "LP Special Repayment Rate"
{
    // version TL2.0


    fields
    {
        field(1; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type".Code;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Minimum Amount"; Decimal)
        {
        }
        field(4; "Maximum Amount"; Decimal)
        {
        }
        field(5; "Interest Rate"; Decimal)
        {
        }
        field(6; "Repayment Period"; DateFormula)
        {
        }
    }

    keys
    {
        key(Key1; "Loan Product Type", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

