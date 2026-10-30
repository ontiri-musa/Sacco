table 50178 "Audit Log Field User Access"
{
    // version MC2.0


    fields
    {
        field(1; "Table No."; Integer)
        {
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; "Table Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type" = CONST(Table),
                                                             "Object ID" = FIELD("Table No.")));
            Editable = false;

        }
        field(3; "Field No."; Integer)
        {
            NotBlank = true;
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table No."));
        }
        field(4; "Field Name"; Text[30])
        {
            TableRelation = AllObj."Object Name";
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.DisplayUserInformation("User ID");
            end;
        }
        field(6; Allow; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "User ID")
        {
        }
    }

    fieldgroups
    {
    }
}

