table 50015 MobileBankingBuffer
{
    Caption = 'MobileBankingBuffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Phone No"; Code[50])
        {
            Caption = 'Phone No';
            DataClassification = ToBeClassified;
        }
        field(2; "Member No"; Code[10])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(3; "Member Name"; Text[250])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; LineNo; Integer)
        {
            Caption = 'LineNo';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Phone No", LineNo)
        {
            Clustered = true;
        }
    }
}
