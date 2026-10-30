report 50464 "Recover Penalty Charges."
{
    // version TL 2.0

    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = WHERE("Customer Type" = FILTER(Loan),
                                      Status = FILTER(Active));
            RequestFilterFields = "No.", "Global Dimension 1 Filter";

            trigger OnAfterGetRecord();
            var
                Text000: Label 'Penalty Charges';
            begin
                LineNo2 += 1;
                LineNo += 10000;
                GlobalSetup.GET;
                OriginalPostingGrp := '';
                OriginalPostingGrp := Customer."Customer Posting Group";
                SavingsAcc := '';
                SavingsBalance := 0;
                //SavingsBalance:=GetSavingsBalance(Member."No.");
                GetSavingsBalance(Member."No.");
                PenaltyChargeAmount := 0;
                NewPostingGrp := '';
                PenaltyChargeAmount := CheckPenaltyBal(Vendor2."No.");
                IF PenaltyChargeAmount < 0 THEN
                    CurrReport.SKIP;
                IF SavingsBalance < PenaltyChargeAmount THEN BEGIN
                    PenaltyChargeAmount := SavingsBalance;
                END;

                NewPostingGrp := GetLoanIntGL(Customer."Customer Posting Group");
                IF (NewPostingGrp <> '') AND (PenaltyChargeAmount > 0) THEN BEGIN
                    Customer."Customer Posting Group" := NewPostingGrp;
                    Customer.MODIFY;

                    //MESSAGE(Vendor."Vendor Posting Group");
                    CreateJournal(PenaltyTemplate, PenaltyBatch, 'PENALTY-' + FORMAT(TODAY), STRSUBSTNO(PenaltyDesc, Vendor2."No."),
                      PostingAccType::Vendor, Vendor2."No.", -PenaltyChargeAmount, Vendor2."Global Dimension 1 Code", TranscType::"Administration Fee", '');
                    CreateJournal(PenaltyTemplate, PenaltyBatch, 'PENALTY-' + FORMAT(TODAY), STRSUBSTNO(PenaltyDesc, Vendor2."No."),
                      PostingAccType::Vendor, SavingsAcc, PenaltyChargeAmount, Vendor2."Global Dimension 1 Code", TranscType::"Administration Fee", '');
                END;

                /*IF PenaltyChargeAmount >= Vendor2."Penalty Amount" THEN BEGIN
                    //Vendor2."Penalty Amount" := 0;
                END ELSE BEGIN
                    // Vendor2."Penalty Amount" -= PenaltyChargeAmount;
                END;*/
                Customer."Customer Posting Group" := OriginalPostingGrp;
                Customer.MODIFY;


                IntProgress := ROUND(LineNo2 / TotalCount * 10000, 1);

                ProgressWindow.UPDATE(1, "No.");
                ProgressWindow.UPDATE(2, Name);
                ProgressWindow.UPDATE(3, "No.");
                ProgressWindow.UPDATE(4, Name);
                ProgressWindow.UPDATE(5, IntProgress);
                ProgressWindow.UPDATE(6, TIME);
            end;

            trigger OnPostDataItem();
            begin
                ProgressWindow.CLOSE;
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", PenaltyTemplate);
                GenJournalLine.SETRANGE("Journal Batch Name", PenaltyBatch);
                IF GenJournalLine.FINDSET THEN BEGIN
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
                END;
            end;

            trigger OnPreDataItem();
            begin
                GenJournalLine.SETRANGE("Journal Template Name", PenaltyTemplate);
                GenJournalLine.SETRANGE("Journal Batch Name", PenaltyBatch);
                GenJournalLine.DELETEALL;

                LineNo := 0;
                LineNo2 := 0;
                TimeProgress := 0T;
                TotalCount := COUNT;
                ProgressWindow.OPEN('Posting Penalty Charges' + '\' +
                                    'Account No.' + '#1#############################################\' +
                                    'Account Name' + '#2#############################################\' +
                                    'Member No.' + '#3#############################################\' +
                                    'Member Name' + '#4#############################################\' +
                                    'Progress' + '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    'Time is' + '##6##############################################');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        Vendor2: Record vendor;
        LineNo: Integer;
        GlobalSetup: Record "Global Setup";
        PenaltyAmount: Decimal;
        Vendor3: Record Vendor;
        ProgressWindow: Dialog;
        TotalCount: Integer;
        IntProgress: Integer;
        LineNo2: Integer;
        Text000: Label 'Penalty Charges';
        PenaltyTemplate: Label 'GENERAL';
        PenaltyBatch: Label 'PENALTY';
        PenaltyDesc: Label 'Penalty charge on %1';
        PenaltyChargeAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
        LoanApplications: Record "Loan Application";
        LoanTypes2: Record "Loan Product Type";
        ExpectedEndDate: Date;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PenaltyCharge: Decimal;
        PostingAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        GenJournalBatch: Record "Gen. Journal Batch";
        Gnljnline: Record "Gen. Journal Line";
        //GlobalSetup: Record "Global Setup";
        TranscType: Option " ",Deposit,Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Shares Contribution","Welfare Contribution","Registration Fee","Administration Fee",Dividend,"Withholding Tax","Fixed Deposit Interest","Shares Contributions","Welfare Contribution 2","Loan Adjustment","Fixed Deposit Interest2","Ledger Fees","Interest P","Interest PD";
        SavingsAcc: Code[20];
        OriginalPostingGrp: Code[20];
        NewPostingGrp: Code[20];
        SavingsBalance: Decimal;
        AccountTypes: Record "Account Type";
        TimeProgress: Time;
        Member: Record Member;

    local procedure CheckPenaltyBal(LoanNo: Code[30]) IntPBalance: Decimal;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        IntPBalance := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
        //VendorLedgerEntry.SETFILTER("Transaction Type",'%1..%2',VendorLedgerEntry."Transaction Type"::"Administration Fee",VendorLedgerEntry."Transaction Type"::"Administration Fee");
        IF VendorLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                VendorLedgerEntry.CALCFIELDS(Amount);
                IntPBalance += VendorLedgerEntry.Amount;
            UNTIL VendorLedgerEntry.NEXT = 0;
        END;
        IF IntPBalance > 0 THEN
            EXIT(IntPBalance)
        ELSE
            EXIT(0);
    end;

    local procedure CreateJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; Description: Text[50]; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; Amount: Decimal; BranchCode: Code[20]; TransactionType: Option " ",Deposit,Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Shares Contribution","Welfare Contribution","Registration Fee","Administration Fee",Dividend,"Withholding Tax","Fixed Deposit Interest","Shares Contributions","Welfare Contribution 2","Loan Adjustment","Fixed Deposit Interest2","Ledger Fees","Interest P"; PostingGroup: Code[30]);
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        LineNo := 1000;
        GenJournalLine2.RESET;
        GenJournalLine2.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine2.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJournalLine2.FINDLAST THEN
            LineNo := GenJournalLine2."Line No."
        ELSE
            LineNo := 1000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplateName;
        GenJournalLine."Journal Batch Name" := JournalBatchName;
        GenJournalLine."Line No." := LineNo + 1000;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Posting Date" := TODAY;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine.VALIDATE("Account Type");
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine.Description := Description;
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(Amount);
        IF PostingGroup <> '' THEN
            GenJournalLine.VALIDATE("Posting Group", PostingGroup);
        //GenJournalLine."Transaction Type":=TransactionType;
        GenJournalLine."Shortcut Dimension 1 Code" := BranchCode;
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT(TRUE);
    end;

    procedure PostJournal(TemplateName: Code[20]; BatchCode: Code[20]);
    var
        SpotCashRegistration: Record "Mobile Banking Application";
        AccNo: Code[20];
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DocNo: Code[10];
        SMSSubsciprionList: Record "SMS Entry";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NoCode: Code[20];
        SMSChargesList: Record "SMS Entry";
        GenJournalLine: Record "Gen. Journal Line";
        BranchCode: Code[10];
        Cust: Record Customer;
        PostingAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        Gnljnline: Record "Gen. Journal Line";
    begin
        Gnljnline.RESET;
        Gnljnline.SETRANGE("Journal Template Name", TemplateName);
        Gnljnline.SETRANGE("Journal Batch Name", BatchCode);
        IF Gnljnline.FIND('-') THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", Gnljnline);
        END;
    end;

    procedure ClearPenaltyJournal();
    var
        LoanApplications: Record "Loan Application";
        LoanTypes2: Record "Loan Product Type";
        ExpectedEndDate: Date;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PenaltyCharge: Decimal;
        DocNo: Code[10];
        NoCode: Code[20];
        GenJournalLine: Record "Gen. Journal Line";
        PostingAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        GenJournalBatch: Record "Gen. Journal Batch";
        Gnljnline: Record "Gen. Journal Line";
    begin
        Gnljnline.RESET;
        Gnljnline.SETRANGE("Journal Template Name", PenaltyTemplate);
        Gnljnline.SETRANGE("Journal Batch Name", PenaltyBatch);
        Gnljnline.DELETEALL;

        IF NOT GenJournalBatch.GET(PenaltyTemplate, PenaltyBatch) THEN BEGIN
            GenJournalBatch.INIT;
            GenJournalBatch.Name := PenaltyBatch;
            GenJournalBatch."Journal Template Name" := PenaltyTemplate;
            GenJournalBatch.INSERT;
        END;
    end;

    local procedure GetSavingsBalance(MemberNo: Code[20]);
    var
        Vendor2: Record Vendor;
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::Savings);
        IF AccountType.FINDSET THEN BEGIN
            Vendor2.RESET;
            Vendor2.SETRANGE("Member No.", MemberNo);
            Vendor2.CALCFIELDS("Balance (LCY)");
            Vendor2.SETFILTER("Balance (LCY)", '>%1', 0);
            IF Vendor2.FINDFIRST THEN BEGIN
                Vendor2.CALCFIELDS("Balance (LCY)");
                SavingsAcc := Vendor2."No.";
                IF AccountTypes.GET(Vendor2."Account Type") THEN
                    SavingsBalance := Vendor2."Balance (LCY)" - AccountType."Minimum Balance"
                ELSE
                    SavingsBalance := Vendor2."Balance (LCY)";
            END;
        END;
    end;

    local procedure GetLoanIntGL(LoanType: Code[10]): Code[10];
    begin
        IF LoanProductType.GET(LoanType) THEN BEGIN
            // EXIT(LoanProductType."Interest Accrued Account");
        END;
    end;
}

