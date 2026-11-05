table 50311 "Benevolent Exempt"
{

    fields
    {
        field(1; "Member No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                Customer.GET("Member No.");
                "Member Name" := Customer.Name;
                "Shares Capital" := TRUE;
                Benevolent := TRUE;
            end;
        }
        field(2; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(3; "Shares Capital"; Boolean)
        {
        }
        field(4; Benevolent; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Member No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Customer: Record Customer;
}

