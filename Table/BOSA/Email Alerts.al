table 50299 "Email Alerts"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Alert Message"; BLOB)
        {
        }
        field(3; "Email Addres"; Text[100])
        {
        }
        field(4; "Date Sent"; Date)
        {
        }
        field(5; "Time Sent"; Time)
        {
        }
        field(6; "Email Header"; Text[150])
        {
        }
        field(7; Subject; Text[150])
        {
        }
        field(8; "Is Token valid"; Boolean)
        {
        }
        field(9; UUID; Text[200])
        {
        }
        field(10; "Time Stamp"; DateTime)
        {
        }
        field(11; "Date Initiated"; Date)
        {
        }
        field(12; "Date Validated"; Date)
        {
        }
        field(13; "Member Id"; Code[10])
        {
        }
        field(14; "User ID"; Code[100])
        {
        }
        field(15; "Reset Token"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

