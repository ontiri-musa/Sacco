table 50107 "Loan Product Charge"
{
    // version TL2.0


    fields
    {
        field(1; "Loan Product Type"; Code[20])
        {
        }
        field(2; Code; Code[20])
        {
            NotBlank = true;
            TableRelation = "Loan Charge Setup";

            trigger OnValidate()
            begin
                LoanChargeSetup.GET(Code);
                Description := LoanChargeSetup.Description;
            end;
        }
        field(3; Description; Text[30])
        {
            Editable = false;
        }
        field(4; "Calculation Mode"; Option)
        {
            OptionCaption = '% of Loan,Flat Amount,% of Outstanding Loan';
            OptionMembers = "% of Loan","Flat Amount","% of Outstanding Loan";
        }
        field(5; Value; Decimal)
        {
        }
        field(6; "Account Type"; Option)
        {
            OptionCaption = 'GL Account';
            OptionMembers = "GL Account";
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false), "Direct Posting" = CONST(true));
        }
        field(9; "Minimum Amount"; Decimal)
        {
        }
        field(10; "Maximum Amount"; Decimal)
        {
        }
        field(11; "Pinno Value"; Decimal)
        {
        }
        field(12; "Pinno Account No"; Code[20])
        {
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false), "Direct Posting" = CONST(true));

        }

        field(13; "Line No."; Integer)
        {

        }
        field(14; "Bal. Account No."; Code[20])
        {
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false), "Direct Posting" = CONST(true));
        }
    }

    keys
    {
        key(Key1; "Loan Product Type", "Line No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description)
        {
        }
    }

    var
        LoanChargeSetup: Record "Loan Charge Setup";
}

