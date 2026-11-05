table 50002 "Member Balances Upload"
{
    Caption = 'Member Balances Upload';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(2; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(3; Deposits; Decimal)
        {
            Caption = 'Deposits';
            DataClassification = ToBeClassified;
        }
        field(4; "Share Capital"; Decimal)
        {
            Caption = 'Share Capital';
            DataClassification = ToBeClassified;
        }
        field(5; "Account Type"; Option)
        {
            OptionCaption = 'Shares,Deposits,Loans,Savings';
            OptionMembers = Shares,Deposits,Loans,Savings;
        }
        field(6; Posted; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(8; "Account No"; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Member No")
        {
            Clustered = true;
        }
    }

}
