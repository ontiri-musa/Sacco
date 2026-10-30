table 50027 "Loan Prepayment Recovery"
{
    Caption = 'Loan Prepayment Recovery';
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
            Caption = 'Amount to Recover';
            DataClassification = ToBeClassified;
        }
        field(7; "Date Recovered"; Date)
        {
            Caption = 'Date Created';
            DataClassification = ToBeClassified;
        }
        field(8; "Recovered By"; Code[100])
        {
            Caption = 'Recovered By';
            DataClassification = ToBeClassified;
        }
        field(9; "Prepayment Amount"; Decimal)
        {
            Caption = 'Prepayment Amount';
            DataClassification = ToBeClassified;
        }
        field(10; "Principal Recovered"; Decimal)
        {
            Caption = 'Principal to Recover';
            DataClassification = ToBeClassified;
        }
        field(11; "Penalty Recovered"; Decimal)
        {
            Caption = 'Penalty to Recover';
            DataClassification = ToBeClassified;
        }
        field(12; "Interest Recovered"; Decimal)
        {
            Caption = 'Interest to Recover';
            DataClassification = ToBeClassified;
        }
        field(13; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(14; Posted; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(15; PostedBy; Boolean)
        {
            Caption = 'Posted By';
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
