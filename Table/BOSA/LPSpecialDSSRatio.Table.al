table 50193 "LP Special DSS Ratio"
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
        field(3; Ratio; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Applies to Borrower Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "First-Time Borrower","Subsequent Borrower";

        }
        field(5; "Account Type"; Option)
        {
            OptionMembers = Deposits,Savings,Shares;
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