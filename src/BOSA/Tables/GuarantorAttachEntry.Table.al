table 50198 "Guarantor Attach Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No."; Code[20])
        {

        }
        field(2; "Line No"; Integer)
        {

        }
        field(3; "Attached Loan No."; Code[20])
        {

        }
        field(4; Description; Code[20])
        {

        }
        field(5; "Attached Amount"; Decimal)
        {

        }

    }

    keys
    {
        key(Key1; "Loan No.", "Line No")
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