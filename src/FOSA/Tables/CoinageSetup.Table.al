table 50045 "Coinage Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {

        }
        field(2; "Line No."; Integer)
        {

        }
        field(3; Value; Decimal)
        {

        }

    }

    keys
    {
        key(PK; Code, "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Line No.")
        {
        }
    }

    var
        myInt: Integer;

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