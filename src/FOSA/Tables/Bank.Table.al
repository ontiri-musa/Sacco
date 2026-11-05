table 50054 Bank
{
    // version TL2.0
    DrillDownPageID = 50043;
    LookupPageID = 50043;

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; Name; Text[150])
        {
        }

    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name)
        {
        }
    }
}

