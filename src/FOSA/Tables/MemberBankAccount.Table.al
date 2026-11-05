table 50014 "Member Bank Account"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
            trigger OnValidate()
            var
            begin
                Bank.Get("Bank Code");
                "Bank Name" := Bank.Name;
            end;

        }
        field(4; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(5; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branch" where("Bank Code" = field("Bank Code"));
            trigger OnValidate()
            var
            begin
                BankBranch.Get("Branch Code");
                "Branch Name" := BankBranch.Name;
            end;

        }
        field(6; "Branch Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(7; "Account No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(8; Default; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Member No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        Bank: Record Bank;
        BankBranch: Record "Bank Branch";

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