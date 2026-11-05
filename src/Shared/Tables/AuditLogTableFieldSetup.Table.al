table 50177 "Audit Log Table Field Setup"
{
    // version MC2.0


    fields
    {
        field(1; "Table No."; Integer)
        {
            Editable = false;
        }
        field(2; "Table Name"; Text[50])
        {
            Editable = false;
        }
        field(3; "Field No."; Integer)
        {
            Editable = false;
        }
        field(4; "Field Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "On Insert"; Boolean)
        {
        }
        field(6; "On Modify"; Boolean)
        {
        }
        field(7; "On Delete"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
        }
    }

    fieldgroups
    {
    }
}

