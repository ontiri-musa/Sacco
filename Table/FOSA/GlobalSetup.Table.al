table 50001 "Global Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(26; "Securities Path"; Text[250])
        {
        }
        field(27; "Loan Form Path"; Text[250])
        {
        }
        field(28; "Cheque Deposit Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(34; "Excise Duty %"; Decimal)
        {
        }
        field(35; "Excise Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(36; "Withholding Tax %"; Decimal)
        {
        }
        field(37; "Withholding Tax G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(38; "Stamp Duty %"; Decimal)
        {
        }
        field(39; "Stamp Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(87; "Deposit %"; Decimal)
        {
        }
        field(88; "Deposit Figure"; Decimal)
        {
        }
        field(89; "Maximum Deposit Figure"; Decimal)
        {
        }
        field(90; "Share Capital Threshold"; Decimal)
        {
        }
        field(91; "Share Capital Threshold Period"; Decimal)
        {
        }
        field(121; "Reversal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(122; "Reversal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Reversal Template Name"));
        }
        field(123; "Income Realization Method"; Option)
        {
            OptionCaption = 'On Payment,On Accrual';
            OptionMembers = "On Payment","On Accrual";
        }
        field(156; "Use Buffer"; Boolean)
        {

        }
        field(158; "General Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(159; "General Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("General Template Name"));
        }
        field(161; "Image Path Local Directory"; Text[100])
        {

        }
        field(162; "Image Path IP Address"; Text[100])
        {
        }
        field(163; "Registration Fee"; Decimal)
        {

        }
        field(164; "Unallocated Payments G/L"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(165; "Registration Fee Limit Date"; Date)
        {

        }
        field(166; "Board Tax %"; Decimal)
        {
        }
        field(167; "Board Tax G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(168; "Sitting Allowance G/L"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(169; "Transport Reimbursement G/L"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(170; "Board Hospitality G/L"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(171; "Monthly deposit contribution"; Decimal)
        {

        }
        field(172; "Minimum Share contribution"; Decimal)
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

