table 50055 "Bank Branch"
{
    // version TL2.0
    DrillDownPageID = 50047;
    LookupPageID = 50047;

    fields
    {
        field(1; Code; Code[10])
        {
        }
        field(2; Name; Text[100])
        {
        }
        field(3; "Bank Code"; Code[10])
        {
            TableRelation = Bank;

            trigger OnValidate()
            begin
                IF Banks.GET("Bank Code") THEN
                    "Bank Name" := Banks.Name;
            end;
        }
        field(4; "Bank Name"; Text[100])
        {
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
        fieldgroup(DropDown; Code, Name, "Bank Name")
        {
        }
    }

    var
        Banks: Record Bank;
}

