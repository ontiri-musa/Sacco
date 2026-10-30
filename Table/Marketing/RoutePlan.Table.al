table 50700 "Route Plan"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Sales Person Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            begin
                IF SalespersonPurchaser.GET("Sales Person Code") THEN
                    "Sales Person Name" := SalespersonPurchaser.Name;
                // Supervisor := SalespersonPurchaser.Supervisor;
            end;
        }
        field(3; "Sales Person Name"; Code[100])
        {
        }
        field(4; Description; Code[100])
        {
        }
        field(5; "Budget Required"; Decimal)
        {
        }
        field(6; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(7; "Date Created"; Date)
        {
        }
        field(8; f; Code[10])
        {
        }
        field(9; "Created By"; Code[30])
        {
        }
        field(10; Supervisor; Code[100])
        {
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "No.", "Sales Person Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "Created By" := USERID;
        "Date Created" := TODAY;
    end;

    var
        SalespersonPurchaser: Record 13;
}

