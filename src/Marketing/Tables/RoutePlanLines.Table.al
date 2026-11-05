table 50701 "Route Plan Lines"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; Date; Date)
        {

            trigger OnValidate();
            begin
                Day := FORMAT(Date, 0, '<Weekday Text>');
            end;
        }
        field(4; Day; Text[30])
        {
            Editable = false;
        }
        field(5; Description; Code[100])
        {
        }
        field(6; FeedBack; Code[250])
        {
        }
        field(7; "SalesPerson Code"; Code[30])
        {
        }
        field(8; Comments; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; No, "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Days: Integer;
}

