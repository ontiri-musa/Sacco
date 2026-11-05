table 50046 "Transaction Coinage Setup"
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
        field(3; Quantity; Integer)
        {
            trigger OnValidate()
            var

            begin
                "Line Amount" := Quantity * "Coinage Value";

            end;

        }
        field(4; "Coinage Code"; Code[20])
        {
            Editable = false;
        }
        field(5; "Coinage Value"; Decimal)
        {
            Editable = false;
        }
        field(6; "Line Amount"; Decimal)
        {
            Editable = false;

        }
        field(7; "Coinage Source"; Option)
        {
            OptionMembers = Teller,"Teller Return To Bank","Teller Close Till",Treasury,"Treasury Return Bank";
            OptionCaption = 'Teller,Teller Return To Bank,Teller Close Till,Treasury,Treasury Return Bank';

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