codeunit 50026 "Audit Management"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterGetDatabaseTableTriggerSetup', '', false, false)]
    local procedure OnAfterGetDatabaseTableTriggerSetup(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseRename: Boolean);
    var
        TableField: Record "Audit Log Table Field Setup";
    begin
        IF COMPANYNAME = '' THEN
            EXIT;

        TableSetup.SETRANGE("Table No.", TableId);
        IF TableSetup.FINDFIRST THEN BEGIN
            OnDatabaseInsert := TRUE;
            OnDatabaseModify := TRUE;
            OnDatabaseDelete := TRUE;
            OnDatabaseRename := TRUE;
        END ELSE BEGIN
            OnDatabaseInsert := FALSE;
            OnDatabaseModify := FALSE;
            OnDatabaseDelete := FALSE;
            OnDatabaseRename := FALSE;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseDelete', '', false, false)]
    local procedure OnAfterOnDatabaseDelete(RecRef: RecordRef);
    var
        TableField: Record "AUDIT LOG TABLE FIELD SETUP";
    begin
        IF RecRef.ISTEMPORARY THEN
            EXIT;

        IF TableSetup.GET(RecRef.NUMBER) THEN BEGIN
            IF TableSetup."Activate Log" THEN BEGIN
                TableField.RESET;
                TableField.SETRANGE("Table No.", TableSetup."Table No.");
                IF TableField.FINDSET THEN BEGIN
                    REPEAT
                        IF NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") THEN
                            ERROR(Error012);
                        IF TableField."On Delete" THEN
                            CreateAuditLogEntry(2, RecRef, RecRef, TableField."Field No.");
                    UNTIL TableField.NEXT = 0;
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseInsert', '', false, false)]
    local procedure OnAfterOnDatabaseInsert(RecRef: RecordRef);
    var
        FldRef: FieldRef;
        TableField: Record "Audit Log Table Field Setup";
    begin
        IF RecRef.ISTEMPORARY THEN
            EXIT;

        IF TableSetup.GET(RecRef.NUMBER) THEN BEGIN
            IF TableSetup."Activate Log" THEN BEGIN
                TableField.RESET;
                TableField.SETRANGE("Table No.", TableSetup."Table No.");
                IF TableField.FINDSET THEN BEGIN
                    REPEAT
                        FldRef := RecRef.FIELD(TableField."Field No.");
                        IF FORMAT(FldRef.TYPE) <> 'Option' THEN BEGIN
                            IF FORMAT(FldRef.VALUE) <> '' THEN BEGIN
                                IF NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") THEN
                                    ERROR(Error011);
                                IF TableField."On Insert" THEN
                                    CreateAuditLogEntry(0, RecRef, RecRef, TableField."Field No.");
                            END;
                        END;
                    UNTIL TableField.NEXT = 0;
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseModify', '', false, false)]
    local procedure OnAfterOnDatabaseModify(RecRef: RecordRef);
    var
        xRecRef: RecordRef;
        FldRef: FieldRef;
        xFldRef: FieldRef;
        Text000: Label '%1 field cannot be modified directly.It requires approval';
        TableField: Record "Audit Log Table Field Setup";
    begin
        IF RecRef.ISTEMPORARY THEN
            EXIT;

        IF NOT xRecRef.GET(RecRef.RECORDID) THEN
            EXIT;

        IF TableSetup.GET(RecRef.NUMBER) THEN BEGIN
            IF TableSetup."Activate Log" THEN BEGIN
                TableField.RESET;
                TableField.SETRANGE("Table No.", TableSetup."Table No.");
                IF TableField.FINDSET THEN BEGIN
                    REPEAT
                        FldRef := RecRef.FIELD(TableField."Field No.");
                        xFldRef := xRecRef.FIELD(TableField."Field No.");
                        IF FORMAT(FldRef.VALUE) <> FORMAT(xFldRef.VALUE) THEN BEGIN
                            IF NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") THEN
                                ERROR(Error010, TableField."Field Name");
                            IF TableField."On Modify" THEN
                                CreateAuditLogEntry(1, RecRef, xRecRef, TableField."Field No.");
                        END;
                    UNTIL TableField.NEXT = 0;
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnGlobalRename', '', false, false)]
    local procedure OnAfterOnGlobalRename(RecRef: RecordRef; xRecRef: RecordRef);
    var
        FldRef: FieldRef;
        xFldRef: FieldRef;
        TableField: Record "Audit Log Table Field Setup";
    begin
        IF RecRef.ISTEMPORARY THEN
            EXIT;

        IF TableSetup.GET(RecRef.NUMBER) THEN BEGIN
            IF TableSetup."Activate Log" THEN BEGIN
                TableField.RESET;
                TableField.SETRANGE("Table No.", TableSetup."Table No.");
                IF TableField.FINDSET THEN BEGIN
                    REPEAT
                        FldRef := RecRef.FIELD(TableField."Field No.");
                        xFldRef := xRecRef.FIELD(TableField."Field No.");
                        IF FORMAT(FldRef.VALUE) <> FORMAT(xFldRef.VALUE) THEN BEGIN
                            IF NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") THEN
                                ERROR(Error010, TableField."Field Name");
                            CreateAuditLogEntry(1, RecRef, RecRef, TableField."Field No.");
                        END;
                    UNTIL TableField.NEXT = 0;
                END;
            END;
        END;
    end;

    local procedure HasFieldAccess(TableNo: Integer; FieldNo: Integer): Boolean;
    begin
        FieldUserAccess.SETRANGE("Table No.", TableNo);
        FieldUserAccess.SETRANGE("Field No.", FieldNo);
        FieldUserAccess.SETRANGE("User ID", USERID);
        FieldUserAccess.SETRANGE(Allow, TRUE);
        EXIT(FieldUserAccess.FINDFIRST);
    end;

    local procedure CreateAuditLogEntry("Action": Integer; var RecRef: RecordRef; var XRecRef: RecordRef; FieldNo: Integer);
    var
        AuditLogEntry: Record "Audit Log Entry";
        AuditLogEntry2: Record "Audit Log Entry";
        EntryNo: Integer;
        FldRef: FieldRef;
        xFldRef: FieldRef;
        "Field": Record Field;
        TableField: Record "Audit Log Table Field Setup";
    begin
        AuditLogEntry.INIT;
        IF AuditLogEntry2.FINDLAST THEN
            EntryNo := AuditLogEntry2."Entry No."
        ELSE
            EntryNo := 0;
        AuditLogEntry."Entry No." := EntryNo + 1;
        ;
        AuditLogEntry.Action := Action;
        FldRef := RecRef.FIELD(FieldNo);
        xFldRef := XRecRef.FIELD(FieldNo);
        AuditLogEntry."Table ID" := RecRef.NUMBER;
        AuditLogEntry."Table Name" := RecRef.NAME;
        AuditLogEntry."Field No." := FldRef.NUMBER;
        AuditLogEntry."Field Name" := FldRef.NAME;
        AuditLogEntry."Old Value" := FORMAT(xFldRef.VALUE);
        AuditLogEntry."New Value" := FORMAT(FldRef.VALUE);
        AuditLogEntry."Record ID" := RecRef.RECORDID;
        AuditLogEntry."Record ID Key" := FORMAT(RecRef.RECORDID);
        AuditLogEntry."Action Date" := TODAY;
        AuditLogEntry."Action Time" := TIME;
        AuditLogEntry."User ID" := USERID;
        AuditLogEntry.INSERT;
    end;

    var
        TableSetup: Record "Audit Log Table Setup";
        FieldUserAccess: Record "Audit Log Field User Access";
        Error010: Label 'You are not allowed to change %1 field.';
        Error011: Label 'You are not allowed to create new record';
        Error012: Label 'You are not allowed to delete this record';
}