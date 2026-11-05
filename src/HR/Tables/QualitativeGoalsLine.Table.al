table 50285 "Qualitative Goals Line"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Code; Code[20])
        {
            TableRelation = "Qualitative Goal";

            trigger OnValidate();
            begin
                IF QualitativeGoal.GET(Code) THEN BEGIN
                    Description := QualitativeGoal.Description;
                END;
            end;
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Remarks; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.", Code)
        {
        }
    }

    fieldgroups
    {
    }

    var
        QualitativeGoal: Record "Qualitative Goal";
}

