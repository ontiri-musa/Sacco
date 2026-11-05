table 50192 Church
{
    DataClassification = ToBeClassified;
    DrillDownPageId = Churches;
    LookupPageId = Churches;

    fields
    {
        field(1; Code; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Church District Code"; Code[20])
        {
            TableRelation = "Church District";
            // Editable = false;

        }
        field(4; "Church Section Code"; Code[20])
        {
            TableRelation = "Church Section" where("Church District Code" = field("Church District Code"));
            trigger OnValidate()
            var
                ChurchSection: Record "Church Section";
            begin
                ChurchSection.get("Church Section Code");
                "Church District Code" := ChurchSection."Church District Code";
            end;

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