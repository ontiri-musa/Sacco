table 50048 "Treasury Transaction Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Till No."; Code[20])
        {
            TableRelation = "Bank Account";


            trigger OnValidate()
            begin
                if BankAccount.get("Till No.") then
                    "Till Name" := BankAccount.Name;
                TellerUserSetup.Get(UserId);
                "Teller User ID" := TellerUserSetup."User ID";
            end;
        }
        field(4; "Till Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(5; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Teller User ID"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
    }

    keys
    {
        key(PK; "Transaction No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        BankAccount: Record "Bank Account";
        TellerUserSetup: Record "Teller User Setup";

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