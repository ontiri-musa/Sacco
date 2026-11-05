table 52225 LoansUpdate
{
    Caption = 'LoansUpdate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            Caption = 'Loan No';
            DataClassification = ToBeClassified;
        }
        field(2; "Application Date"; Date)
        {
            Caption = 'Application Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Loan Prodcut Code"; Code[10])
        {
            Caption = 'Loan Prodcut Code';
            DataClassification = ToBeClassified;
        }
        field(4; "Req Amount"; Decimal)
        {
            Caption = 'Req Amount';
            DataClassification = ToBeClassified;
        }
        field(5; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = ToBeClassified;
        }
        field(6; Interest; Decimal)
        {
            Caption = 'Interest';
            DataClassification = ToBeClassified;
        }
        field(7; "Member name"; Text[200])
        {
            Caption = 'Member name';
            DataClassification = ToBeClassified;
        }
        field(8; "Issued Date"; Date)
        {
            Caption = 'Issued Date';
            DataClassification = ToBeClassified;
        }
        field(9; Installments; Integer)
        {
            Caption = 'Installments';
            DataClassification = ToBeClassified;
        }
        field(10; "Repayment Start Date"; Date)
        {
            Caption = 'Repayment Start Date';
            DataClassification = ToBeClassified;
        }
        field(11; "Ex Date of Completion"; Date)
        {
            Caption = 'Ex Date of Completion';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Loan No")
        {
            Clustered = true;
        }
    }

}
