table 50030 "NSSF Rates"
{
    Caption = 'NSSF Rates';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
        }
        field(2; "Tier I Lower Limit"; Decimal)
        {
            Caption = 'Tier I Lower Limit';
        }
        field(3; "Tier II Upper Limit"; Decimal)
        {
            Caption = 'Tier II Upper Limit';
        }
        field(4; "% Of Gross Pay"; Decimal)
        {
            Caption = '% Of Gross Pay';
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
