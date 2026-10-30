table 50174 "Mobile Banking Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Mobile Banking Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Mobile Banking Appl. Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Mobile Banking Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(7; "Mobile Banking Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Mobile Banking Template Name"));
        }
        field(8; "Paybill Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(9; "Loan Repay SMS Template"; Text[2048])
        {

        }
        field(10; "KCB Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(11; "Co-operative Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        Field(12; "Equity Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        Field(13; "Old Paybill"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(14; Suspense; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(15; "KCB Bank Suspense"; Code[100])
        {
            TableRelation = "G/L Account";
        }
        field(16; "Co-operative Bank Suspense"; Code[100])
        {
            TableRelation = "G/L Account";
        }
        Field(17; "Equity Bank Suspense"; Code[100])
        {
            TableRelation = "G/L Account";
        }
        Field(18; "Old Paybill Suspense"; Code[100])
        {
            TableRelation = "G/L Account";
        }
        field(19; "Mpesa B2C"; Code[20])
        {
            TableRelation = "Bank Account";
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