table 50202 "Quantitative Goals Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Code; Code[20])
        {
            TableRelation = "Quantitative Goal";

            trigger OnValidate();
            begin
                IF QuantitativeGoal.GET(Code) THEN BEGIN
                    Description := QuantitativeGoal.Description;
                END;
            end;
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Indicators; Text[250])
        {
        }
        field(5; "Action Plans"; Text[250])
        {
        }
        field(6; Objectives; Text[250])
        {
        }
        field(7; "Agreed Weighting"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No.", Code)
        {
        }
    }


    var
        QuantitativeGoal: Record "Quantitative Goal";
}

