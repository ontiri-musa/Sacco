table 50012 "Account Opening Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Notify Member"; Boolean)
        {
        }
        field(3; "Email Template (PendingApprov)"; Text[1024])
        {
        }
        field(6; "SMS Template (PendingApprov)"; Text[1024])
        {
        }
        field(7; "Email Template (Approved)"; Text[1024])
        {
        }
        field(8; "SMS Template (Approved)"; Text[1024])
        {
        }
        field(9; "Email Template (Additional)"; Text[1024])
        {
        }
        field(10; "SMS Template (Additional)"; Text[1024])
        {
        }
        field(5; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(15; "Account Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(16; "Account No. Format"; Option)
        {
            OptionCaption = 'No. Series Only,Member No.+Account Type';
            OptionMembers = "No. Series Only","Member No.+Account Type";
        }
        field(17; "Account Opening Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Account Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }


        field(19; "Closing Account Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; "Closure Fee GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }


        field(21; "Fixed/Call Dep. Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(23; "Fixed/Call Dep. Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Fixed/Call Dep. Template Name"));
        }
        field(24; "Account Closure Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(25; "Account Closure Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Account Closure Template Name"));
        }
        field(27; "Ledger Fee Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(28; "Ledger Fee Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Ledger Fee Template Name"));
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

