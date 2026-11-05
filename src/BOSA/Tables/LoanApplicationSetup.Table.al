table 50100 "Loan Application Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Notify Member"; Boolean)
        {
        }
        field(3; "Email Template (Pending Appr.)"; Text[1024])
        {
        }
        field(4; "SMS Template (Pending Appr.)"; Text[1024])
        {
        }
        field(5; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(6; "Loan Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Loan Product Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Loan Disbursal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(13; "Loan Disbursal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Disbursal Template Name"));
        }
        field(14; "Loan Interest Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(15; "Loan Interest Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Interest Template Name"));
        }
        field(16; "Loan Repayment Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(17; "Loan Repayment Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Repayment Template Name"));
        }
        field(18; "Email Template (Rejected)"; Text[1024])
        {
        }
        field(19; "SMS Template (Rejected)"; Text[1024])
        {
        }

        field(24; "Loan Recovery Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(25; "Loan Recovery Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Recovery Template Name"));
        }
        field(26; "Notify Guarantor"; Boolean)
        {
        }
        field(27; "Email Template (Guarantor)-New"; Text[1024])
        {
        }
        field(28; "SMS Template (Guarantor)-New"; Text[1024])
        {
        }
        field(29; "Email Template (Approved)"; Text[1024])
        {
        }
        field(30; "SMS Template (Approved)"; Text[1024])
        {
        }
        field(31; "Email Template (Guarantor)-Approved"; Text[1024])
        {
        }
        field(32; "SMS Template (Guarantor)-Approved"; Text[1024])
        {
        }
        field(33; "Loan Overpayment (Account Type)"; Text[1024])
        {
            TableRelation = "Account Type";
        }
        field(34; "Ledger Fee"; Decimal)
        {

        }

        field(35; "Penalty Calculation Method"; Option)
        {
            OptionMembers = "% of Outstanding Loan","Flat Amount";
            trigger OnValidate()
            var
            begin
                Clear("Penalty Value");
            end;
        }
        field(36; "Penalty Value"; Decimal)
        {
        }
        field(37; "Penalty Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(38; "Penalty Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Penalty Template Name"));
        }
        field(39; "Ledger Fee Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(40; "Ledger Fee Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Ledger Fee Template Name"));
        }
        field(41; "Loan Overpayment Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(42; "Loan Overpayment Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Overpayment Template Name"));
        }
        field(43; "SMS Template (Cleared)"; Text[1024])
        {
        }
        field(44; "SMS Template (Disbursed)"; Text[1024])
        {
        }
        field(45; "Pinno Comm On Mobile Loan Int Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(46; "Mobile Loan DCharges Account"; Code[20])
        {
            TableRelation = "G/L Account";
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

