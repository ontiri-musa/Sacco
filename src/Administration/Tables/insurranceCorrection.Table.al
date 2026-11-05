table 51333 insurranceCorrections
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; loanNo; Code[15])
        {
            DataClassification = ToBeClassified;

        }
        field(5; mnNO; Code[25])
        {
            DataClassification = ToBeClassified;

        }
        field(10; insFee; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(15; period; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(20; loanAmt; Decimal)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; loanNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
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