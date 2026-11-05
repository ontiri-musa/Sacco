table 50095 "Agency Banking Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Maximum Withdrawal Per day"; Decimal)
        {

        }
        field(3; "Internal Agent Income A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Internal Agent A/C Type"; Option)
        {
            OptionCaption = 'Commission Account,Sacco Income Account';
            OptionMembers = "Commission Account","Sacco Income Account";
        }
        field(6; "Agency Template Name"; Code[10])
        {
            Caption = 'Agency Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(7; "Agency Batch Name"; Code[10])
        {
            Caption = 'Agency Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Agency Template Name"));
        }
        field(8; "Agency Banking(Non Mobile Banking)"; Boolean)
        {

        }
        field(10; "Agent Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Agent Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
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