table 50154 "Loan Selloff Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Income G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Attachment Mandatory"; Boolean)
        {
        }
        field(4; "Receiving Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(6; "Loan Selloff Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Loan Selloff Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(8; "Loan Selloff Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Selloff Template Name"));
        }
        field(10; "Notify Member"; Boolean)
        {
        }
        field(11; "Email Template"; Text[1024])
        {
        }
        field(12; "SMS Template"; Text[1024])
        {
        }
        field(13; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

