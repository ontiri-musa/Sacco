table 50082 "Standing Order Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary key"; Code[10])
        {
        }
        field(2; "Charges Calculation Method"; Option)
        {
            OptionMembers = "%","Flat Amount";
        }
        field(3; "Charges Value"; Decimal)
        {

            trigger OnValidate()
            begin

            end;
        }
        field(4; "Charges G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Penalty Calculation Method"; Option)
        {
            OptionMembers = "%","Flat Amount";
        }
        field(6; "Penalty Value"; Decimal)
        {

            trigger OnValidate()
            begin

            end;
        }
        field(7; "Penalty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Charge Transaction"; Boolean)
        {
        }
        field(9; "Charge Penalty"; Boolean)
        {
        }

        field(34; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }

        field(38; "Notify Source Member"; Boolean)
        {
        }
        field(39; "Notify Destination Member"; Boolean)
        {
        }
        field(40; "Source SMS Template"; Text[250])
        {
        }
        field(41; "Destination SMS Template"; Text[250])
        {
        }
        field(42; "Source Email Template"; Text[250])
        {
        }
        field(43; "Destination Email Template"; Text[250])
        {
        }

        field(46; "Standing Order Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(47; "Standing Order Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(48; "Standing Order Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Standing Order Template Name"));
        }
    }

    keys
    {
        key(Key1; "Primary key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BOSAManagement: Codeunit "BOSA Management";









}

