table 50609 "Account Signatory"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Member No."; Code[30])
        {
        }
        field(3; "Account No."; code[30])
        {

        }
        field(4; "First Name"; Code[50])
        {
        }
        field(5; "Middle Name"; Code[50])
        {
        }
        field(6; "Last Name"; Code[50])
        {
        }
        field(7; "Date of Birth"; Date)
        {
        }
        field(8; "Identification No."; Code[50])
        {
        }
        field(9; "Signatory"; Boolean)
        {
        }
        field(10; Picture; Media)
        {
        }
        field(13; Signature; Media)
        {
        }
        field(11; "Front ID"; Media)
        {
        }
        field(12; "Back ID"; Media)
        {
        }

    }

    keys
    {
        key(PK; "Entry No.", "Account No.")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}