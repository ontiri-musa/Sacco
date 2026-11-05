table 50041 "Fixed Deposit Rate"
{
    // version TL2.0


    fields
    {
        field(2; "Minimum Amount"; Decimal)
        {
        }
        field(3; "Maximum Amount"; Decimal)
        {
        }
        field(4; Period; Integer)
        {
        }
        field(5; "Interest Rate"; Decimal)
        {
        }
        field(6; "Period Unit"; Option)
        {
            OptionMembers = ,Day,Month;
        }
    }

    keys
    {
        key(Key1; "Minimum Amount", "Maximum Amount", Period, "Interest Rate")
        {
        }
    }

    fieldgroups
    {
    }
}

