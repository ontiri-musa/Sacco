table 50181 "Microcredit Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Group Allocation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Group Attendance Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }


        field(4; "GP Allocation Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(5; "GP Allocation Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("GP Allocation Template Name"));
        }
        field(6; "Group In-Transit Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(7; "Portfolio Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Group Attendance Report Code"; Code[20])
        {

        }
        field(9; "Group Collection Report Code"; Code[20])
        {

        }
        field(10; "Group Allocation Report Code"; Code[20])
        {

        }
        field(11; "Group Collection Control A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(12; "GP Collection Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(13; "GP Collection Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("GP Collection Template Name"));
        }
        field(14; "Group Paybill Nos."; Code[20])
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