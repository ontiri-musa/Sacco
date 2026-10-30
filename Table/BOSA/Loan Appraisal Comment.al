table 53112 "Loan Appraisal Comment"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Loan No"; Code[20])
        {
            TableRelation = "Loan Application";
        }
        field(3; Comment; Text[250])
        {
        }
        field(4; "Commented By"; Code[10])
        {
            TableRelation = Member;

            trigger OnValidate();
            begin
                if Memb.GET("Commented By") then Name := Memb."Full Name";
            end;
        }
        field(5; Date; Date)
        {
        }
        field(6; Time; Time)
        {
        }
        field(7; Name; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Memb: Record Member;
}

