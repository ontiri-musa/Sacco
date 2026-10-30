table 50165 "Loan Writeoff Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "LW G/L Control Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Attachment Mandatory"; Boolean)
        {
        }
        field(5; "Loan Writeoff Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Loan Writeoff Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(7; "Loan Writeoff Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Writeoff Template Name"));
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

