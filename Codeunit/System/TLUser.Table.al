table 70000 "TL User"
{

    fields
    {
        field(1; "User Security ID"; Guid)
        {
        }
        field(2; "User Id"; code[100])
        {
        }
        field(3; "Full Name"; Code[100])
        {
        }
        field(4; Password; Text[80])
        {
            ExtendedDatatype = Masked;
        }
        field(5; "Default Password"; Code[100])
        {
        }

    }


    keys
    {
        key(PK; "User Id")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "User Security ID" := CreateGuid();
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