table 50112 "Security Register"
{
    // version TL2.0

    DataCaptionFields = Description;
    DrillDownPageID = 51330;
    LookupPageID = 51330;

    fields
    {
        field(1; Code; Code[20])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Security Type Code"; Code[20])
        {
            TableRelation = "Security Type";
        }
    }

    keys
    {
        key(Key1; Code)
        {
        }
    }

    fieldgroups
    {
    }
}

