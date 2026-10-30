table 50059 "Treasury Return Bank Line"
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

        field(4; "Treasury Account No."; Code[20])
        {
            TableRelation = "Bank Account" where("Account Type" = filter("Treasury Account"));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                BankAccount.get("Treasury Account No.");
                "Treasury Account Name" := BankAccount.Name;
            end;
        }
        field(5; "Treasury Account Name"; Text[50])
        {
            Editable = false;

        }
        field(6; "Treasury Account Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum ("Bank Account Ledger Entry".Amount where("Bank Account No." = field("Treasury Account No.")));

        }
        field(7; "Line Amount"; Decimal)
        {

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