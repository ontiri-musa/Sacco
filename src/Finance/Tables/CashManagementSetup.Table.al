table 50330 "Cash Management Setup"
{
    // version TL 2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(3; "Payment Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Payment Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Template Name"));
        }

        field(4; "Imprest Surr. Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(5; "Imprest Surr. Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Imprest Surr. Template Name"));

        }
        field(6; "Payment Voucher Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Imprest Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Imprest Surrender Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "PettyCash Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Receipt Voucher Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Salary Advance"; Code[20])
        {
            TableRelation = "No. Series";
        }

        field(12; "Checkoff Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Checkoff Receipt Voucher Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        /*  field(16; "Imprest Code"; Code[20])
         {
             TableRelation = "Account Mapping Type";
         } */
        field(15; "Loan Recovery Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Receipt Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(19; "Receipt Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Receipt Template Name"));
        }
        field(20; "Claim Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(21; "Imprest Path"; Option)
        {
            OptionCaption = 'PettyCash,Teller';
            OptionMembers = "PettyCash",Teller;
        }
        field(22; "PettyCash Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }

        field(24; "Budget Admin"; Code[120])
        {
            TableRelation = "User Setup";
        }
        field(25; "Use Budget"; Boolean)
        {

        }
        field(27; "PettyCash Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(28; "PettyCash Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("PettyCash Template Name"));

        }
        field(30; "Checkoff Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(31; "Checkoff Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Checkoff Template Name"));
        }
        field(32; "Payroll NetPay Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33; "Loan Recovery Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(34; "Loan Recovery Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Checkoff Template Name"));
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

