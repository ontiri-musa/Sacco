table 50044 "Teller User Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[30])
        {
            TableRelation = "User Setup";

        }
        field(2; "Till No."; Code[20])
        {
            TableRelation = "Bank Account" where("Account Type" = filter("Till Account"));

        }
        field(3; "Maximum Withdrawal"; Decimal)
        {


        }
        field(4; "Maximum Deposit"; Decimal)
        {


        }
        field(5; "Withdrawal Allowed"; Boolean)
        {


        }
        field(6; "Deposit Allowed"; Boolean)
        {


        }
        field(7; "Cheque Deposit Allowed"; Boolean)
        {


        }
        field(8; Active; Boolean)
        {


        }
        field(9; "Withdrawal Limit (Approval)"; Decimal)
        {


        }
        field(10; "Deposit Limit (Approval)"; Decimal)
        {


        }
        field(13; "Till Minimum Amount"; Decimal)
        {


        }
        field(14; "Till Maximum Amount"; Decimal)
        {


        }
        field(15; "Till Replenishment Level"; Decimal)
        {


        }
        field(16; "Treasury Account No."; Code[20])
        {
            TableRelation = "Bank Account" where("Account Type" = filter("Treasury Account"));

        }

    }

    keys
    {
        key(PK; "User ID")
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