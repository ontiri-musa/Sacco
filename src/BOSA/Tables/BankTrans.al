table 50017 BankTrans
{
    Caption = 'BankTrans';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
        }
        field(2; "Bank No"; Code[30])
        {
            Caption = 'Bank No';
            DataClassification = ToBeClassified;
        }
        field(3; "Doc No"; Code[30])
        {
            Caption = 'Doc No';
            DataClassification = ToBeClassified;
        }
        field(4; Narration; Text[200])
        {
            Caption = 'Narration';
            DataClassification = ToBeClassified;
        }
        field(5; "Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = ToBeClassified;
        }
        field(6; "Posting Date"; date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(7; "Crebit Amount"; Decimal)
        {
            Caption = 'Crebit Amount';
            DataClassification = ToBeClassified;
        }
        field(8; Reversed; Boolean)
        {
            Caption = 'Reversed';
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
