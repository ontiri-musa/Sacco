table 50176 "Audit Log Table Setup"
{
    // version MC2.0


    fields
    {
        field(1; "Table No."; Integer)
        {
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnValidate();
            begin
                AddTableFields("Table No.");
            end;
        }
        field(2; "Table Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type" = CONST(Table),
                                                             "Object ID" = FIELD("Table No.")));
            Editable = false;

        }
        field(5; "Activate Log"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Table No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        DeleteRelatedLinks;
    end;

    local procedure AddTableFields(TableNo: Integer);
    var
        "Field": Record Field;
        TableFieldSetup: Record "Audit Log Table Field Setup";
    begin
        Field.RESET;
        Field.SETRANGE(TableNo, TableNo);
        IF Field.FINDSET THEN BEGIN
            REPEAT
                TableFieldSetup.INIT;
                TableFieldSetup."Table No." := Field.TableNo;
                TableFieldSetup."Table Name" := Field.TableName;
                TableFieldSetup."Field No." := Field."No.";
                TableFieldSetup."Field Name" := Field.FieldName;
                IF TableFieldSetup.INSERT THEN
                    AddUsers(TableFieldSetup);
            UNTIL Field.NEXT = 0;
        END;
    end;

    local procedure AddUsers(TableFieldSetup: Record "Audit Log Table Field Setup");
    var
        UserSetup: Record "User Setup";
        FieldUserAccess: Record "Audit Log Field User Access";
    begin
        WITH TableFieldSetup DO BEGIN
            UserSetup.RESET;
            IF UserSetup.FINDSET THEN BEGIN
                REPEAT
                    FieldUserAccess.INIT;
                    FieldUserAccess."Table No." := "Table No.";
                    FieldUserAccess."Field No." := "Field No.";
                    FieldUserAccess."User ID" := UserSetup."User ID";
                    FieldUserAccess."Table Name" := "Table Name";
                    FieldUserAccess."Field Name" := "Field Name";
                    FieldUserAccess.Allow := TRUE;
                    FieldUserAccess.INSERT;
                UNTIL UserSetup.NEXT = 0;
            END;
        END;
    end;

    local procedure DeleteRelatedLinks();
    var
        TableFieldSetup: Record "Audit Log Table Field Setup";
        FieldUserAccess: Record "Audit Log Field User Access";
    begin
        TableFieldSetup.RESET;
        TableFieldSetup.SETRANGE("Table No.", Rec."Table No.");
        TableFieldSetup.DELETEALL;

        FieldUserAccess.RESET;
        FieldUserAccess.SETRANGE("Table No.", Rec."Table No.");
        FieldUserAccess.DELETEALL;
    end;
}

