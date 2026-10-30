table 55750 "Registry Requests Approval"
{
    // version CBS-TL,REG


    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate();
            begin
                "HOD Approval" := TRUE;
            end;
        }
        field(2; "Approver ID"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate();
            begin
                IF "User ID" = "Approver ID" THEN BEGIN
                    ERROR('User ID and Approver ID cannot be the same user. Please select another approver ID.');
                END;
                "HOD Approver" := TRUE;
            end;
        }
        field(3; "HOD Approval"; Boolean)
        {
            Editable = false;
        }
        field(4; "HOD Approver"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
        }
    }

    fieldgroups
    {
    }
}

