table 50057 ComplainCategory
{

    fields
    {
        field(1; Id; Integer)
        {
        }
        field(2; Name; Text[200])
        {
        }
        field(3; Description; Text[200])
        {
        }
        field(4; Priority; Text[20])
        {
        }
        field(5; Intrash; Text[20])
        {
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
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