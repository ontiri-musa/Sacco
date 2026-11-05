table 50204 "Grading Structure"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Rating; Text[100])
        {

        }
        field(3; "Lower Value"; Decimal)
        {

        }
        field(4; "Higher Value"; Decimal)
        {

        }
        field(5; "Total (Out of 5)"; Decimal)
        {

        }
        field(6; "% Bonus Payment"; Decimal)
        {

        }
        field(7; "% Salary Increment"; Decimal)
        {

        }
    }

    keys
    {
        key(PK; "Entry No.")
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