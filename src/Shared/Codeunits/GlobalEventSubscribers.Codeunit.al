codeunit 50024 "Global Event Subscribers"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LoginManagement, 'OnBeforeLogInStart', '', false, false)]
    local procedure OnBeforeLogInStart();
    var
        ActiveSessions: Record "Active Session";
        Sessions: Record Session;
        SessionEvent: Record "Session Event";
    begin
        // REPORT.Run(REPORT::"Change Password");
        //Message('Welcome %1', UserId);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Vendor List", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure FilterVendorsOnly(var Rec: Record Vendor)
    var

    begin
        Rec.Reset();
        Rec.SetRange("Vendor Type", Rec."Vendor Type"::Normal);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeRunCheck', '', false, false)]
    local procedure OnBeforeRunCheck(var GenJournalLine: Record "Gen. Journal Line");
    begin
        with GenJournalLine do begin
            //if DocNoAlreadyPosted("Document No.") then;
            //  Error(DocNoAlreadyPostedMsg, "Document No.");
        end;
    end;

    local procedure DocNoAlreadyPosted(DocNo: Code[20]): Boolean
    var

    begin
        GLEntry.Reset();
        GLEntry.SetCurrentKey("Document No.", "Posting Date");
        GLEntry.SetRange("Document No.", DocNo);
        Exit(GLEntry.FindFirst());
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure ValidateOnDeleteCustomer(var Rec: Record Customer)
    begin
        // Rec.TestField("Customer Type", Rec."Customer Type"::Normal);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure ValidateOnInsertCustomer(var Rec: Record Customer)
    begin
        // Rec.TestField("Customer Type", Rec."Customer Type"::Normal);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure ValidateOnDeleteVendor(var Rec: Record Vendor)
    begin
        Rec.TestField("Vendor Type", Rec."Vendor Type"::Normal);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeInsertEvent', '', false, false)]
    local procedure ValidateOnBeforeInsertVendor(var Rec: Record Vendor)
    begin
        //  Rec.TestField("Vendor Type", Rec."Vendor Type"::Normal);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnBeforeCustLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        with GenJournalLine do begin
            CustLedgerEntry."Transaction Type Code" := GenJournalLine."Transaction Type Code";
            CustLedgerEntry."Member No." := GenJournalLine."Member No";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        with GenJournalLine do begin
            DtldCustLedgEntry."Transaction Type Code" := GenJournalLine."Transaction Type Code";
            DtldCustLedgEntry."Member No." := GenJournalLine."Member No";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        with GenJournalLine do begin
            VendorLedgerEntry."Transaction Type Code" := GenJournalLine."Transaction Type Code";
            VendorLedgerEntry."Member No." := GenJournalLine."Member No";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldVendLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        with GenJournalLine do begin
            DtldVendLedgEntry."Transaction Type Code" := GenJournalLine."Transaction Type Code";
            DtldVendLedgEntry."Member No." := GenJournalLine."Member No";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(GenJournalLine: Record "Gen. Journal Line"; var GlobalGLEntry: Record "G/L Entry")
    begin
        with GenJournalLine do begin
            GlobalGLEntry."Transaction Type Code" := GenJournalLine."Transaction Type Code";
            GlobalGLEntry."Member No." := GenJournalLine."Member No";
            If GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
                GlobalGLEntry."Posting Loan No." := GenJournalLine."Account No.";
                GlobalGLEntry."Loan Transaction" := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostVend', '', false, false)]
    local procedure OnAfterPostVend(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        Member: Record Member;
    begin
        with GenJournalLine do begin
            if "Account Type" = "Account Type"::Vendor then begin
                if "Credit Amount" > 0 then begin
                    Vendor.Get("Account No.");
                    if Vendor."Vendor Type" = Vendor."Vendor Type"::FOSA then begin
                        AccountTypes.RESET;
                        AccountTypes.SETRANGE(Code, Vendor."Account Type");
                        AccountTypes.SETRANGE(Type, AccountTypes.Type::"Member Deposit");
                        IF AccountTypes.FINDSET THEN BEGIN
                            IF Vendor.Status = Vendor.Status::Dormant THEN BEGIN
                                Vendor.Status := Vendor.Status::Active;
                                Vendor.Modify();
                            END;
                        END;
                        Member.Get(Vendor."Member No.");
                        Member."Dormancy Status" := Vendor.Status;
                        Member.Modify();

                        If (Member."No." = 'SUSPENSE') and (GenJournalLine.Amount < 0) then
                            Error('');
                    end;
                end;
            end;
        end;
    end;//OnBeforePostVend

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostVend', '', false, false)]
    local procedure OnBeforePostVend(var GenJournalLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        Member: Record Member;
    begin
        with GenJournalLine do begin
            if "Account Type" = "Account Type"::Vendor then begin
                if "Credit Amount" > 0 then begin
                    Vendor.Get("Account No.");
                    if Vendor."Vendor Type" = Vendor."Vendor Type"::FOSA then begin
                        Member.Get(Vendor."Member No.");

                        If (Member."No." = 'SUSPENSE') then
                            Error('Only debit amount is allowed for posting to account %1 belonging to member %2', Vendor."No.", Member."No.");
                    end;
                end;
            end;
        end;
    end;

    /*    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnAfterReverseGLEntry', '', false, false)]
        local procedure OnAfterReverseGLEntry(var GLEntry: Record "G/L Entry")
        var
            Customer: Record Customer;
            Vendor: Record Vendor;
        begin
            with GLEntry do begin
                if GLEntry."Source Type" = GLEntry."Source Type"::Customer then begin
                    Customer.Get(GLEntry."Source No.");
                    GLEntry."Member No." := Customer."Member No.";
                end;
                if GLEntry."Source Type" = GLEntry."Source Type"::Vendor then begin
                    Vendor.Get(GLEntry."Source No.");
                    GLEntry."Member No." := Vendor."Member No.";
                end;
                Modify();
            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeInsertGLEntry', '', false, false)]
        local procedure OnReverseGLEntryOnBeforeInsertGLEntry(var GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
        var
            Customer: Record Customer;
            Vendor: Record Vendor;
        begin
            //Message('here to reverse Source Type %1 Source No %2', GLEntry2."Source Type", GLEntry2."Source No.");

            with GLEntry2 do begin
                if GLEntry2."Source Type" = GLEntry2."Source Type"::Customer then begin
                    Customer.Get(GLEntry2."Source No.");
                    GLEntry."Member No." := Customer."Member No.";
                    //Message('here to reverse Source Type %1 Source No %2 Member No %3 GLE MembNo %4', GLEntry2."Source Type", GLEntry2."Source No.", Customer."Member No.", GLEntry."Member No.");
                end;
                if GLEntry2."Source Type" = GLEntry2."Source Type"::Vendor then begin
                    Vendor.Get(GLEntry2."Source No.");
                    GLEntry."Member No." := Vendor."Member No.";
                    //Message('here to reverse Source Type %1 Source No %2 Member No %3 GLE MembNo %4', GLEntry2."Source Type", GLEntry2."Source No.", Vendor."Member No.", GLEntry."Member No.");
                end;
            end;
        end;
    */
    var
        GLEntry: Record "G/L Entry";
        DocNoAlreadyPostedMsg: Label 'Document No. %1 is already posted';
}