table 50094 "Agency Ledger Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Request ID."; Code[20])
        {

        }
        field(3; "Transaction Date"; Date)
        {

        }
        field(4; "Transaction Time"; Time)
        {

        }
        field(5; "Description"; Text[50])
        {

        }
        field(6; "Agent No."; Code[20])
        {

        }
        field(7; "Agent Name"; Text[50])
        {

        }
        field(8; "Amount"; Decimal)
        {

        }
        field(9; "Member No."; Code[20])
        {

        }
        field(10; "Member Name."; Text[50])
        {

        }

        field(11; "Transaction Type."; Code[20])
        {

        }
        field(12; "CR Account No."; Code[20])
        {

        }
        field(13; Fkey; Code[20])
        {

        }
        field(14; "Account No."; Code[20])
        {

        }
        field(15; "Account Name"; Text[50])
        {

        }
    }

    keys
    {
        key(PK; "Entry No.")
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