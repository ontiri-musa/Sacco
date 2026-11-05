table 50010 "Account Type"
{
    // version TL2.0

    LookupPageId = "Account Type List";
    DrillDownPageId = "Account Type List";
    fields
    {
        field(1; Code; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Minimum Balance"; Decimal)
        {
        }
        field(4; "Dormancy Period"; DateFormula)
        {
        }
        field(5; "Ledger Fee"; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionMembers = ,Savings,"Share Capital","Member Deposit","Fixed Deposit","Call Deposit",Board;
        }
        field(7; "Sub Type"; Option)
        {
            OptionMembers = ,Ordinary,Junior,Benevolent,Holiday,Business,Special,Virtual,Agent,Boresha,NXTGen;
        }
        field(8; "Allow Withdrawal"; Boolean)
        {
        }
        field(9; "Allow Deposit"; Boolean)
        {
        }
        field(10; "Maximum Withdrawal Amount"; Decimal)
        {

        }
        field(11; "Maximum Deposit Amount"; Decimal)
        {

        }

        field(14; "Earns Interest"; Boolean)
        {
        }
        field(15; "Interest Rate"; Decimal)
        {
        }
        field(16; "Posting Group"; Code[30])
        {
            TableRelation = "Vendor Posting Group";
        }
        field(17; "Closing Fees"; Decimal)
        {
        }
        field(18; "Maximum No. of Withdrawal"; Integer)
        {
        }
        field(19; "Allow Multiple Accounts"; Boolean)
        {
        }
        field(20; "Allow Cheque Deposit"; Boolean)
        {
        }
        field(21; "Allow Cheque Withdrawal"; Boolean)
        {
        }
        field(22; "Exclude from Closure"; Boolean)
        {
        }
        field(23; "Transfer Account After Closure"; Code[10])
        {
            TableRelation = "Account Type";

            trigger OnValidate()
            begin
                IF "Transfer Account After Closure" = Code THEN BEGIN
                    ERROR(Error000);
                END;
            end;
        }

        field(25; "Open Automatically"; Boolean)
        {
        }
        field(26; "Ledger Fee Posting Group"; Code[20])
        {
            TableRelation = "Vendor Posting Group";
        }

        field(29; "Allow InterAccount Transfer"; Boolean)
        {
        }
        field(31; "FOSA Account"; Boolean)
        {
        }


        field(33; "Minimum Contribution"; Decimal)
        {
        }
        field(34; "Earns Dividend"; Boolean)
        {
        }
        field(35; "Earns Commission on Interest"; Boolean)
        {
        }
        field(36; "Paybill Short Code"; Code[20])
        {
        }

        field(42; "Can Guarantee Loan"; Boolean)
        {
        }

        field(45; "Applies to Age Class"; Option)
        {
            OptionMembers = " ",Adult,Junior,Both;
            OptionCaption = ' ,Adult,Junior,Both';

        }
        field(46; "Applies to Member Category"; Option)
        {
            OptionMembers = All,Individual,Group,Company,Joint;

        }


    }

    keys
    {
        key(Key1; Code)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Error000: Label 'Please select a different account';
}

