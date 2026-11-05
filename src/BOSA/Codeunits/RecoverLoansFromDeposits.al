codeunit 50006 "Recover Loans From Deposits"
{
    trigger OnRun()
    begin
        if Confirm('Are you sure you want to recover expired loans with balances below or equal to 2000 from member deposits?', true) then begin
            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            DefaulterSetup.Get();

            JournalTemplateName := DefaulterSetup."Defaulter Template Name";
            JournalBatchName := DefaulterSetup."Defaulter Batch Name";
            GlobalM.ClearJournal(JournalTemplateName, JournalBatchName);

            //IF GUIALLOWED THEN BEGIN
            //ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            //LoanRecov.DeleteAll();

            Loan.Reset();
            Loan.SetRange(Posted, true);
            if Loan.FindSet() then begin
                TotalLoan := Loan.Count;
                repeat
                    If Cust.Get(Loan."No.") then begin
                        Cust.CalcFields(Balance);
                        If (Cust.Balance > 0) and (Cust.Balance <= 2000) then begin
                            i += 1;
                            //ProgressWindow.UPDATE(1, Loan."Member No.");
                            //ProgressWindow.UPDATE(2, Loan."Member Name");
                            //ProgressWindow.UPDATE(3, Loan."No.");
                            //ProgressWindow.UPDATE(4, Loan.Description);

                            AmountRecovered := 0;
                            DepositBalance := 0;
                            DepositAcc := '';


                            AmountRecovered := Cust.Balance;
                            DepositBalance := (BosaM.GetDepositAccountBalance(Loan."Member No.", Today)) * -1;
                            DepositAcc := BosaM.GetDepositAccount(Loan."Member No.");
                            if DepositBalance > 0 then begin
                                if DepositBalance >= AmountRecovered then
                                    AmountRecovered := AmountRecovered
                                else
                                    AmountRecovered := DepositBalance;
                                //GlobalM.CalculateLoanArrearsAndOverpayment(Loan."No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2]);
                                //BosaM.CalculateDaysAndInstallmentsInArrearsDefaulter(Loan."No.", (ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4]), NoofDaysInArrears, NoofInstallmentInArrears, Today);
                                //BosaM.GetClassificationClassDetails(NoofDaysInArrears, ClassificationCode, ClassificationDesc, ProvisioningPercent);
                                //LoanClassSetup.Get(ClassificationCode);
                                //if ((LoanClassSetup.Code = '004') or (LoanClassSetup.Code = '005')) and (Loan."Date of Completion" <= Today) then begin
                                if (Loan."Date of Completion" <= Today) then begin
                                    GlobalM.DeductLoanArrearsLoanRecovery(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, 'LOANRECOV', Loan."No.", Today, Loan."No.", AmountRecovered, Loan."Global Dimension 1 Code");
                                    GlobalM.CreateJournal(JournalTemplateName, JournalBatchName, 'LOANRECOV', Loan."No.", Today, AccountTypeEnum::Vendor, DepositAcc, Loan.Description + ' - Recovery', AmountRecovered, '', '', SourceCodeSetup.Defaulter,
                                    Loan."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '',Loan."Member No.");

                                    LoanRecov.Reset();
                                    if LoanRecov.FindLast() then
                                        EntryNo := LoanRecov."Entry No" + 1
                                    else
                                        EntryNo := 1;
                                    LoanRecov.Init();
                                    LoanRecov."Entry No" := EntryNo;
                                    LoanRecov."Loan No" := Loan."No.";
                                    LoanRecov."Loan Product" := Loan.Description;
                                    LoanRecov."Member No" := Loan."Member No.";
                                    LoanRecov."Member Name" := Loan."Member Name";
                                    LoanRecov."Deposits Balance" := DepositBalance;
                                    LoanRecov."Amount Recovered" := AmountRecovered;
                                    LoanRecov."Date Recovered" := Today;
                                    LoanRecov."Recovered By" := UserId;
                                    LoanRecov.Insert();
                                end;
                            end;
                        end;
                        //ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
                    end;
                until Loan.Next = 0;
            end;
            //ProgressWindow.CLOSE;
            GlobalM.PostJournal(JournalTemplateName, JournalBatchName);
            Message('Loan Recovery Complete');
            //END;
        end;
    end;

    var
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        Text000: Label 'Generating Defaulted Loans\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ClassificationCode: Code[100];
        ClassificationDesc: Text;
        ProvisioningPercent: Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        SourceCodeSetup: Record "Source Code Setup";
        DepositBalance: Decimal;
        DepositAcc: Code[20];
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        GlobalSetup: Record "Global Setup";
        DefaulterSetup: Record "Loan Defaulter Setup";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        JournalTemplateName: Code[100];
        JournalBatchName: Code[100];
        Cust: Record Customer;
        AmountRecovered: Decimal;
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        Member: Record Member;
        Loan: Record "Loan Application";
        BosaM: Codeunit "BOSA Management";
        GlobalM: Codeunit "Global Management";
        LoanRecov: Record "Loans Recovered From Deposits";
        EntryNo: Integer;
        ArrearsAmount: array[10] of Decimal;
        OverpaymentAmount: array[10] of Decimal;
        LoanClassSetup: Record "Loan Classification Setup";
}
