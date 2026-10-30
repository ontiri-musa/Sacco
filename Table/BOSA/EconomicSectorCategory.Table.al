table 50183 "Economic Sector Category"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = 51301;
    LookupPageId = 51301;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Economic Sector"; Code[20])
        {
            TableRelation = "Economic Sector";

        }
        field(3; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Code)
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