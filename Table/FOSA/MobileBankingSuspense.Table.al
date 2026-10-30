table 50789 "Mobile Banking Suspense"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Transaction No."; Code[20])
        {
        }
        field(3; "Phone No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF MobileBankingMember.GET("Phone No.") THEN BEGIN
                    "Account No." := MobileBankingMember."Account Name";
                    "Member No." := MobileBankingMember."Member Name";
                END;
            end;
        }
        field(4; "Member No."; Code[20])
        {
        }
        field(5; "Account No."; Code[100])
        {
        }
        field(6; "Transaction Date"; Date)
        {
        }
        field(7; "Transaction Time"; Time)
        {
        }
        field(8; Description; Text[100])
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; Reversed; Boolean)
        {
        }
        field(11; "Service ID"; Integer)
        {
            TableRelation = "Mobile Transaction Type";
            trigger OnValidate()
            begin
                if MobileTrType.Get("Service ID") then begin
                    Description := MobileTrType.Description;
                end;
            end;
        }
        field(12; "CR Account No."; Code[100])
        {
        }
        field(13; "Status"; Code[20])
        {
        }
        field(14; "FKey"; Code[55])
        {
        }
        field(15; "Transacted By"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Transaction Date" := TODAY;
        "Transaction Time" := TIME;
    end;

    var
        MobileBankingMember: Record "Mobile Banking Member";
        MobileTrType: Record "Mobile Transaction Type";
}

