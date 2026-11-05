table 50009 "Overdraft Charge"
{

    fields
    {
        field(1; Code; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Charge %"; Decimal)
        {
        }
        field(4; "Normal Overdraft"; Boolean)
        {
        }
        field(5; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter('Yes'));
        }
    }

    keys
    {
        key(PK; Code)
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