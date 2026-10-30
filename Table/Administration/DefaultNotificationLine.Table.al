table 59609 "Default Notification Line"
{

    fields
    {
        field(1; "Document No"; Code[10])
        {
        }
        field(2; "Line No"; Integer)
        {
        }
        field(4; "Member No"; Code[10])
        {
        }
        field(5; "Member Name"; Text[150])
        {
        }
        field(6; "Member Phone No"; Code[15])
        {
        }
        field(7; Select; Boolean)
        {
        }
        field(10; "loan No"; Code[10])
        {
        }
        field(15; "Recovery Amount"; Decimal)
        {
        }
        field(8; "Sent To Phone No"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Line No", "Document No")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(dropdown; "Member No", "Member Name")
        {
        }
    }
}

