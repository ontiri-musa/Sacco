table 50136 "Fund Transfer Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }

        field(5; "Notify Source Member"; Boolean)
        {
        }
        field(6; "Notify Destination Member"; Boolean)
        {
        }

        field(10; "Source SMS Template"; Text[250])
        {
        }
        field(11; "Destination SMS Template"; Text[250])
        {
        }
        field(12; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(13; "Source Email Template"; Text[250])
        {
        }
        field(14; "Destination Email Template"; Text[250])
        {
        }
        field(16; "Fund Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Fund Transfer Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(18; "Fund Transfer Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Fund Transfer Template Name"));
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

    var
        BOSAManagement: Codeunit "BOSA Management";
}

