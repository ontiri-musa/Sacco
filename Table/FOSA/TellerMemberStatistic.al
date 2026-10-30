table 50170 "Teller Member Statistic"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Description; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; "Transaction No.", "Line No.")
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