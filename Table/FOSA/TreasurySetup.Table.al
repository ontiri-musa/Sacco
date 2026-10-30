table 50173 "Treasury Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Treasury Transaction Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Treasury Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(6; "Treasury Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Treasury Template Name"));
        }
        field(7; "Treasury Request Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Treasury Transactions Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Treasury Return Bank Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}