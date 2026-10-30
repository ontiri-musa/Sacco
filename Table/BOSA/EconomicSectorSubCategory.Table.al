table 50184 "Economic Sector Sub-Category"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = 51302;
    LookupPageId = 51302;

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
        field(3; "Economic Sector Category"; Code[20])
        {
            TableRelation = "Economic Sector Category" where("Economic Sector" = field("Economic Sector"));

        }
        field(4; Description; Text[250])
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