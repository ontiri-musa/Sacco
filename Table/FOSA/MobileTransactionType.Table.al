table 50187 "Mobile Transaction Type"
{
    Caption = 'Mobile Transaction Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Integer)
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
