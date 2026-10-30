table 50031 "Member Activation Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }
        field(2; "Member Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }


        field(6; "Charge Registration Fee"; Boolean)
        {
        }
        field(10; "Member Activ. Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(11; "Member Activ. Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Member Activ. Template Name"));
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

    trigger OnInsert()
    begin

    end;

    var

}

