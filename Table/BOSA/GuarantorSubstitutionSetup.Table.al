table 50180 "Guarantor Substitution Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Guarantor Substitution Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Notify Member"; Boolean)
        {
        }

        field(4; "Email Template (Pending Appr.)"; Text[1024])
        {
        }
        field(5; "SMS Template (Pending Appr.)"; Text[1024])
        {
        }
        field(6; "Notify Guarantor"; Boolean)
        {
        }
        field(7; "Email Template (Guarantor)-New"; Text[1024])
        {
        }
        field(8; "SMS Template (Guarantor)-New"; Text[1024])
        {
        }
        field(10; "Email Template (Rejected)"; Text[1024])
        {
        }
        field(11; "SMS Template (Rejected)"; Text[1024])
        {
        }
        field(13; "Email Template (Approved)"; Text[1024])
        {
        }
        field(14; "SMS Template (Approved)"; Text[1024])
        {
        }
        field(15; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(17; "Email Template (Guarantor)-Approved"; Text[1024])
        {
        }
        field(18; "SMS Template (Guarantor)-Approved"; Text[1024])
        {
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