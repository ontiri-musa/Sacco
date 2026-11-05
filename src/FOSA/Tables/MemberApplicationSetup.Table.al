table 50079 "Member Application Setup"
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
        field(12; "Enforce 18 Years and Above"; Boolean)
        {
        }
        field(15; "MA Individual Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Member Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Member No. Format"; Option)
        {
            OptionCaption = 'No. Series Only,Branch Code+No. Series';
            OptionMembers = "No. Series Only","Branch Code+No. Series";
        }
        field(18; "MA Joint Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(19; "MA Group Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; "MA Company Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(21; "Phone No. Format"; Option)
        {
            OptionCaption = '07XXXXXXXX,2547XXXXXXXX';
            OptionMembers = "07XXXXXXXX","2547XXXXXXXX";
        }
        field(25; "Registration Fee"; Decimal)
        {
        }
        field(26; "Registration Fee Posting Group"; Code[20])
        {
            TableRelation = "Vendor Posting Group";
        }

        field(27; "Registration Fee Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(28; "Registration Fee Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Registration Fee Template Name"));
        }
        field(30; "Registration (Account Type)"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(31; "SMS Template (Dormancy)"; Text[1024])
        {
        }
        field(32; "SMS Template (No Savings)"; Text[1024])
        {
        }
        field(33; "Junior Member Nos."; Code[20])
        {
            TableRelation = "No. Series";
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

