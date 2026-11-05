table 50172 "Tellering Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Teller Transaction Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }

        field(4; "Teller Return Treasury Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Teller Close Till Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Teller Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(11; "Teller Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Teller Template Name"));
        }
        field(160; "Inter Teller Transfer Nos"; Code[20])
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