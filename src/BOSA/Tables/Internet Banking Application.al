table 52288 "Internet Banking Application"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Member no"; Code[10])
        {
        }
        field(3; "Member Name"; Text[250])
        {
        }
        field(4; "National ID"; Code[10])
        {
        }
        field(5; "Phone No"; Code[20])
        {
        }
        field(6; Email; Text[50])
        {
        }
        field(7; "Service Type"; Text[30])
        {
        }
        field(8; "Application Comment"; Text[250])
        {
        }
        field(9; "Served By"; Code[100])
        {
        }
        field(10; "Application Date"; Date)
        {
        }
        field(11; "Approved By"; Code[100])
        {
        }
        field(12; "Approval Comment"; Text[250])
        {
        }
        field(13; Password; Text[250])
        {
        }
        field(14; Status; Integer)
        {
        }
        field(15; "Signed In"; Boolean)
        {
        }
        field(16; "Approval Date"; Date)
        {
        }
        field(17; "Approval Time"; Time)
        {
        }
        field(18; "User ID"; Code[50])
        {
        }
        field(19; "Application Form"; Text[250])
        {
        }
        field(20; "User Activation Date"; Date)
        {
        }
        field(21; "User Activation Time"; Time)
        {
        }
        field(22; OTP; Text[50])
        {
        }
        field(23; "OTP Time"; Time)
        {
        }
        field(24; Member; Text[100])
        {
        }
        field(25; Address; Text[100])
        {
        }
        field(26; "Date of Birth"; Date)
        {
        }
        field(27; Activated; Boolean)
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

