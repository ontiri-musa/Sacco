table 50116 "Exit Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Attachment Mandatory"; Boolean)
        {
        }
        field(3; "Insurance G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Refund Shares to Shares"; Boolean)
        {
        }
        field(9; "Expense Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(10; "Expense Account No."; Code[20])
        {

            TableRelation = IF ("Expense Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                 Blocked = filter(false))
            ELSE
            IF ("Expense Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Expense Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Expense Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(6; "Income G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Credit FOSA Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(8; "Debit FOSA Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(15; "Insurance Claim Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Refund Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Insurace Claim Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(18; "Insurace Claim Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Insurace Claim Template Name"));
        }
        field(19; "Refund Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(20; "Refund Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Refund Template Name"));
        }
        field(21; "Exit Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(22; "Exit Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Exit Template Name"));
        }
        field(23; "Member Exit Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(25; "Shares Boosting Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(26; "Shares Boosting Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Shares Boosting Template Name"));
        }
        field(30; "Notify Member"; Boolean)
        {
        }
        field(31; "Email Template"; Text[1024])
        {
        }
        field(32; "SMS Template"; Text[1024])
        {
        }
        field(33; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(34; "Member Archive Nos."; Code[20])
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

