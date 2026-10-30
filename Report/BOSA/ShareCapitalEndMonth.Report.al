report 50461 "Share Capital End Month"
{
    // version TL2.0

    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Loan Product Type";

            trigger OnAfterGetRecord();
            begin
                WITH Customer DO BEGIN
                    RowsCount += 1;
                    ProgressBar.UPDATE(1, "No.");
                    ProgressBar.UPDATE(2, Name);
                    ProgressBar.UPDATE(3, ((RowsCount / AllRows) * 10000) DIV 1);
                    ProgressBar.UPDATE(4, RowsCount);
                    ProgressBar.UPDATE(5, AllRows);
                    IF Status = Status::Dormant THEN BEGIN
                        CurrReport.SKIP;
                    END;
                    SavingsAccount := GetSavingsAccount("No.");
                    ShareCapitalAccount := '';
                    ShareCapitalAccount := GetShareCapitalAccount("No.");
                    IF CheckLastPosting(ShareCapitalAccount) = TRUE THEN BEGIN
                        CurrReport.SKIP;
                    END;

                END;
                //ActualBalance:=20000;
                ActualBalance := GetActualBalance("No.");
                IF ActualBalance <= 0 THEN BEGIN
                    CurrReport.SKIP;
                END;
                IF ActualBalance < LFeeAmount THEN BEGIN
                    CurrReport.SKIP;
                END;
                SavingsAccount := GetSavingsAccount("No.");
                PrepareJournal(ShareCapitalAccount, SavingsAccount, LFeeAmount, "Global Dimension 1 Code");
                //END;
            end;

            trigger OnPostDataItem();
            begin
                ProgressBar.CLOSE;
                TLPostGenJnl.RunPostingGenJnl(TempGenJournalLine, JournalName, JournalBatch);

                CLEAR(TempGenJournalLine);
                IF GenBatches.GET(JournalName, JournalBatch) THEN BEGIN
                    GenBatches.DELETE;
                END;
            end;

            trigger OnPreDataItem();
            begin
                IF LFeeAmount = 0 THEN BEGIN
                    ERROR('Please fill in the Amount to Deduct');
                END;
                ProgressBar.OPEN('Capitalizing Shares for Members\Member No. #1#######\Name #2#######\Progress @3@@@@@@@\Current Line #4######\All Members #5######');
                AllRows := COUNT;
                RowsCount := 0;
                JournalName := 'GENERAL';
                JournalBatch := 'SCAP2';
                LineNo := 1;
                IF NOT GenBatches.GET(JournalName, JournalBatch) THEN BEGIN
                    GenBatches.INIT;
                    GenBatches."Journal Template Name" := JournalName;
                    GenBatches.Name := JournalBatch;
                    GenBatches.Description := 'Share Capital Deposit';
                    GenBatches.VALIDATE(GenBatches."Journal Template Name");
                    GenBatches.VALIDATE(GenBatches.Name);
                    GenBatches.INSERT;
                END;
                CLEAR(TempGenJournalLine);
            end;
        }
    }

    requestpage
    {
        SourceTable = "Account Type";

        layout
        {
            area(content)
            {
                field(LFeeAmount; LFeeAmount)
                {
                    Caption = 'Charged Ledger Fee';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Vendor: Record Vendor;
        ProgressBar: Dialog;
        AllRows: Integer;
        RowsCount: Integer;
        LFeeAmount: Decimal;
        TempGenJournalLine: Record "Gen. Journal Line" temporary;
        JournalName: Code[20];
        JournalBatch: Code[20];
        MyAccountType: Code[20];
        ShareCapitalAccount: Code[20];
        SavingsAccount: Code[20];
        LineNo: Integer;
        GenBatches: Record "Gen. Journal Batch";
        TLPostGenJnl: Codeunit "TL-Post Gen Jnl";
        ActualBalance: Decimal;
        AccountTypes: Record "Account Type";
        MyAccountTypeCode: Code[20];
        NumberofLoop: Integer;
        NewString: Code[50];

    local procedure PrepareJournal(var MyShareCapitalAccount: Code[20]; var MySavingsAccount: Code[20]; var MyLFeeAmount: Decimal; var GlobalDimension1Code: Code[20]);
    begin
        TempGenJournalLine.INIT;
        TempGenJournalLine."Journal Template Name" := JournalName;
        TempGenJournalLine."Journal Batch Name" := JournalBatch;
        TempGenJournalLine."Line No." := LineNo;
        TempGenJournalLine."Document No." := JournalBatch + FORMAT(TODAY);
        TempGenJournalLine."Posting Date" := TODAY;
        TempGenJournalLine."Account Type" := TempGenJournalLine."Account Type"::Vendor;
        TempGenJournalLine."Account No." := MyShareCapitalAccount;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Account No.");
        TempGenJournalLine."Shortcut Dimension 1 Code" := GlobalDimension1Code;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Shortcut Dimension 1 Code");
        TempGenJournalLine.Description := 'Share Capital Deposit';
        TempGenJournalLine.Amount := -MyLFeeAmount;
        TempGenJournalLine.VALIDATE(TempGenJournalLine.Amount);
        IF TempGenJournalLine.Amount <> 0 THEN BEGIN
            TempGenJournalLine.INSERT;
        END;
        LineNo += 1;
        //_____________________BALANCING ACCOUNT
        TempGenJournalLine.INIT;
        TempGenJournalLine."Journal Template Name" := JournalName;
        TempGenJournalLine."Journal Batch Name" := JournalBatch;
        TempGenJournalLine."Line No." := LineNo;
        TempGenJournalLine."Document No." := JournalBatch + FORMAT(TODAY);
        TempGenJournalLine."Posting Date" := TODAY;
        TempGenJournalLine."Account Type" := TempGenJournalLine."Account Type"::Vendor;
        TempGenJournalLine."Account No." := MySavingsAccount;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Account No.");
        TempGenJournalLine."Shortcut Dimension 1 Code" := GlobalDimension1Code;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Shortcut Dimension 1 Code");
        TempGenJournalLine.Description := 'Share Capital Deposit';
        TempGenJournalLine.Amount := MyLFeeAmount;
        TempGenJournalLine.VALIDATE(TempGenJournalLine.Amount);
        IF TempGenJournalLine.Amount <> 0 THEN BEGIN
            TempGenJournalLine.INSERT;
        END;
        LineNo += 1;
    end;

    local procedure CheckLastPosting(var ShareAccount: Code[20]): Boolean;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Vendor No.", ShareAccount);
        VendorLedgerEntry.SETCURRENTKEY("Posting Date");
        IF VendorLedgerEntry.FINDLAST THEN BEGIN
            VendorLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
            IF DATE2DMY(VendorLedgerEntry."Posting Date", 2) = DATE2DMY(TODAY, 2) THEN BEGIN
                IF VendorLedgerEntry."Remaining Amt. (LCY)" <> 0 THEN BEGIN
                    EXIT(TRUE);
                END;
            END;
        END;
    end;

    local procedure GetActiveAccount(var MemberNumber: Code[20]): Decimal;
    var
        ACVendor: Record Vendor;
        ACAccountTypes: Record "Account Type";
    begin
        ACVendor.RESET;
        ACVendor.SETCURRENTKEY("Balance (LCY)");
        ACVendor.CALCFIELDS("Balance (LCY)");
        ACVendor.ASCENDING(FALSE);
        ACVendor.SETRANGE("Member No.", MemberNumber);
        ACVendor.SETRANGE(Status, ACVendor.Status::Active);
        //ACVendor.SETRANGE(Dormant,FALSE);
        ACVendor.SETFILTER("Account Type", '%1|%2|%3|%4', '01', '02', '03', '05');
        IF ACVendor.FINDFIRST THEN BEGIN
            ACVendor.CALCFIELDS("Balance (LCY)");
            ACAccountTypes.RESET;
            ACAccountTypes.GET(ACVendor."Account Type");
            IF (ACVendor."Balance (LCY)" > ACAccountTypes."Minimum Balance") THEN BEGIN
                SavingsAccount := ACVendor."No.";
                EXIT(ACVendor."Balance (LCY)" - ACAccountTypes."Minimum Balance");
            END
        END;
    end;

    procedure GetSavingsAccount(var MemberNo: Code[20]) SavingsAccount: Code[20];
    var
        Customer: Record Customer;
    begin
        AccountTypes.RESET;
        AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
        IF AccountTypes.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountTypes.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                SavingsAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetShareCapitalAccount(var MemberNo: Code[20]) ShareCapitalAccount: Code[20];
    var
        Customer: Record Customer;
    begin
        AccountTypes.RESET;
        AccountTypes.SETRANGE(Type, AccountTypes.Type::"Share Capital");
        IF AccountTypes.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountTypes.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                ShareCapitalAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetDepositAccount(var MemberNo: Code[20]) DepositAccount: Code[20];
    var
        Customer: Record Customer;
    begin
        AccountTypes.RESET;
        AccountTypes.SETRANGE(Type, AccountTypes.Type::"Member Deposit");
        IF AccountTypes.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountTypes.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                DepositAccount := Vendor."No.";
            END;
        END;
    end;

    local procedure GetActualBalance(AccountNo: Code[20]) MemberAccountBalance: Decimal;
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            AccountTypes.RESET;
            AccountTypes.SETRANGE(Code, Vendor."Vendor Posting Group");
            IF AccountTypes.FINDSET THEN BEGIN
                Vendor.CALCFIELDS("Balance (LCY)");
                MemberAccountBalance := ABS(Vendor."Balance (LCY)" - AccountTypes."Minimum Balance");
                EXIT(MemberAccountBalance);
            END;
        END;
    end;
}

