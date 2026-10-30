table 50179 "ATM Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "ATM Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "ATM Collection Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "ATM Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "ATM Journal Template"; Code[10])
        {
            Caption = 'ATM Journal Template';
            TableRelation = "Gen. Journal Template";
        }
        field(6; "ATM Batch Name"; Code[10])
        {
            Caption = 'ATM Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("ATM Journal Template"));
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