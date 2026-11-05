pageextension 50003 BankAccountLedgerEntriesExt extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; "External Document No.")
            { }
        }
        addafter(Amount)
        {
            field("Running Balance"; "Running Balance")
            {
                Caption = 'Running Balance';
            }
            field("Statement No."; "Statement No.")
            { }
            field("Statement Status"; "Statement Status")
            { }
            field(SystemCreatedAt; SystemCreatedAt)
            { ApplicationArea = All; }
            field(SystemModifiedAt; SystemModifiedAt)
            { ApplicationArea = All; }
        }

    }
    trigger OnOpenPage()
    begin
        //RunningBalance := 0;
        FnUpdateRemainingBal(GETFILTER("Bank Account No."));
    end;

    trigger OnAfterGetRecord()
    begin

        /*
        if Rec."Running Balance" = 0 then begin
            BankL.Reset();
            BankL.SetCurrentKey("Posting Date", "Entry No.");
            BankL.SetAscending("Posting Date", true);
            BankL.SetRange("Bank Account No.", Rec."Bank Account No.");
            BankL.SetFilter("Running Balance", '<>%1', 0);
            //BankL.SetFilter("Entry No.", '<=%1', Rec."Entry No.");
            if BankL.FindLast() then begin
                //BankL.CalcSums(Amount);
                //RunningBalance += BankL.Amount;
                //Rec."Running Balance" := Rec.Amount + BankL."Running Balance";
                Rec.Modify();
            end;
            //RunningBalance += Rec.Amount;
            // Rec.SetCurrentKey("Posting Date");
            //Rec.SetAscending("Posting Date", true);
        end;
        */
    end;

    procedure FnUpdateRemainingBal(BLAccount: Code[50])
    var
        ObjBank: Record "Bank Account";
        ObjBL: Record "Bank Account Ledger Entry";
    begin
        ObjBank.RESET;
        ObjBank.SETCURRENTKEY("No.");
        IF ObjBank.FIND('-') THEN BEGIN
            REPEAT
                RunningBalance := 0;
                ObjBL.RESET;
                ObjBL.SETCURRENTKEY("Posting Date", "Entry No.");
                ObjBL.ASCENDING();
                ObjBL.SETRANGE(ObjBL."Bank Account No.", ObjBank."No.");
                IF ObjBL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        RunningBalance := ObjBL.Amount + RunningBalance;
                        ObjBL."Running Balance" := RunningBalance;
                        ObjBL.MODIFY;
                    UNTIL ObjBL.NEXT = 0;
                END;
            UNTIL ObjBank.NEXT = 0;
        END;
    end;

    var
        BankL: Record "Bank Account Ledger Entry";
        RunningBalance: Decimal;
}