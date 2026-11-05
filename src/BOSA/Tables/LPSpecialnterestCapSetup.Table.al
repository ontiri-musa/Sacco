table 50195 "LP Special Int. Cap. Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan Product Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Disbursal Start Day"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Disbursal End Day"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Capitalization Day"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Loan Product Code", "Line No.")
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