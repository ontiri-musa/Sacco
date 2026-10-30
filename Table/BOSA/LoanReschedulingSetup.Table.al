table 50145 "Loan Rescheduling Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }

        field(3; "Rescheduling Type"; Option)
        {
            OptionCaption = 'Repayment Period,Interest Rate,Repayment Frequency';
            OptionMembers = "Repayment Period","Interest Rate","Repayment Frequency";
        }
        field(4; "Loan Rescheduling Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Rescheduling Method"; Option)
        {
            OptionMembers = "Change Existing Loan","Create New Loan";
        }
        field(6; "Notify Member"; Boolean)
        {
        }
        field(7; "Email Template (Pending Appr.)"; Text[1024])
        {
        }
        field(8; "SMS Template (Pending Appr.)"; Text[1024])
        {
        }
        field(9; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(14; "Loan Resch. Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(15; "Loan Resch. Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Resch. Template Name"));
        }
        field(16; "Email Template (Rejected)"; Text[1024])
        {
        }
        field(17; "SMS Template (Rejected)"; Text[1024])
        {
        }
        field(18; "Email Template (Approved)"; Text[1024])
        {
        }
        field(19; "SMS Template (Approved)"; Text[1024])
        {
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

