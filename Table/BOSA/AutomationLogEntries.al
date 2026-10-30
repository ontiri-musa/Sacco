table 50064 "Automation Log Entries"
{
    Caption = 'Automation Log Entries';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Run Date"; Date)
        {
            Caption = 'Run Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Next Run Date"; Date)
        {
            Caption = 'Next Run Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Automation Code"; Code[200])
        {
            Caption = 'Automation Code';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
