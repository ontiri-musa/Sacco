table 50016 "Loans Recovered From Deposits"
{
    Caption = 'Loans Recovered From Deposits';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
        }
        field(2; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(3; "Member Name"; Text[250])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Loan No"; Code[20])
        {
            Caption = 'Loan No';
            DataClassification = ToBeClassified;
        }
        field(5; "Loan Product"; Text[250])
        {
            Caption = 'Loan Product';
            DataClassification = ToBeClassified;
        }
        field(6; "Amount Recovered"; Decimal)
        {
            Caption = 'Amount Recovered';
            DataClassification = ToBeClassified;
        }
        field(7; "Date Recovered"; Date)
        {
            Caption = 'Date Recovered';
            DataClassification = ToBeClassified;
        }
        field(8; "Recovered By"; Code[100])
        {
            Caption = 'Recovered By';
            DataClassification = ToBeClassified;
        }
        field(9; "Deposits Balance"; Decimal)
        {
            Caption = 'Deposits Balance';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
