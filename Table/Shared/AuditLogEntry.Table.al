table 50175 "Audit Log Entry"
{
    // version MC2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; "Action"; Option)
        {
            OptionMembers = Create,Modify,Delete;
        }
        field(3; "Table ID"; Integer)
        {
            Editable = false;
        }
        field(4; "Table Name"; Text[50])
        {
        }
        field(5; "Field No."; Integer)
        {
            Editable = false;
        }
        field(6; "Field Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Old Value"; Text[50])
        {
            Editable = false;
        }
        field(8; "New Value"; Text[50])
        {
            Editable = false;
        }
        field(9; "Record ID"; RecordID)
        {
        }
        field(10; "Action Date"; Date)
        {
            Editable = false;
        }
        field(11; "Action Time"; Time)
        {
            Editable = false;
        }
        field(12; "User ID"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(13; "Record ID Key"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

