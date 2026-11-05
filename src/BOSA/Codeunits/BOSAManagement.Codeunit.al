codeunit 50010 "BOSA Management"
{
    // version TL2.0


    trigger OnRun()
    begin
    end;

    var


        Vendor: Record "Vendor";
        i: Integer;
        GlobalSetup: Record "Global Setup";
        LoanApplicationSetup: Record "Loan Application Setup";
        StandingOrderSetup: Record "Standing Order Setup";
        RemittanceSetup: Record "Remittance Setup";
        ExitSetup: Record "Exit Setup";
        GuarantorSubstitutionSetup: Record "Guarantor Substitution Setup";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        LoanRestructuringSetup: Record "Loan Restructuring Setup";
        PayoutSetup: Record "Payout Setup";
        DividendSetup: Record "Dividend Setup";
        LoanWriteoffSetup: Record "Loan Writeoff Setup";
        LoanSelloffSetup: Record "Loan Selloff Setup";
        Customer: Record "Customer";
        SourceCodeSetup: Record "Source Code Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        SMTPSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Member: Record "Member";
        LoanProductType: Record "Loan Product Type";
        GlobalManagement: Codeunit "Global Management";
        ReversalEntry: Record "Reversal Entry";
        GLEntry: Record "G/L Entry";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];

    procedure GetFileSize(FileName: Text[1024]) FileSize: Integer
    var
        MyFile: File;
    begin
        BEGIN
            /*  MyFile.Open(FileName) ;
             FileSize := MyFile.Len() ;
             MyFile.Close(); */
        END;
        EXIT(ROUND(FileSize / 1000, 1, '>'));
    end;

    procedure AddAttachment(RecordID: Text[50]; DocumentNo: Code[20]; FileName: Text[200])
    var
        CBSAttachment: Record "CBS Attachment";
        CBSAttachment2: Record "CBS Attachment";
        EntryNo: Integer;
    begin
        IF CBSAttachment2.FINDLAST THEN
            EntryNo := CBSAttachment2."Entry No."
        ELSE
            EntryNo := 0;
        CBSAttachment."Entry No." := EntryNo + 1;
        CBSAttachment.RecordID := RecordID;
        CBSAttachment."Document No." := DocumentNo;
        CBSAttachment."File Name" := FileName;
        CBSAttachment.Attachment.IMPORT(FileName);
        CBSAttachment.INSERT;
    end;

    procedure CreateRepaymentSchedule(LoanNo: Code[20]; LoanAmount: Decimal)
    var
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        NoOfInstallments: Integer;
        PrincipalAmount: Decimal;
        InterestAmount: Decimal;
        ApprovedLoanAmount: Decimal;
        ConstantAmount: Decimal;
        DateofCompletion: Date;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
        RepaymentPeriod: array[8] of integer;
        StartDate: Date;
        DateDiff: Decimal;
    begin

        LoanApplication.GET(LoanNo);
        //LoanApplication.TestField("Interest Rate");
        //      LoanApplication.TestField("Repayment Method");
        //    LoanApplication.TestField("Repayment Period");
        // LoanApplication.TestField("Created Date");
        DateDiff := 0;
        LoanProductType.Get(LoanApplication."Loan Product Type");

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.DELETEALL;

        if LoanApplication."Disbursal Date" = 0D then
            StartDate := LoanApplication."Created Date"
        ELSE
            StartDate := LoanApplication."Disbursal Date";
        if LoanApplication."Loan Restructured" = true then
            StartDate := LoanApplication."Next Due Date";

        GetRepaymentPeriod(LoanNo, StartDate, LoanApplication."Date of Completion",
                            RepaymentPeriod[1], RepaymentPeriod[2], RepaymentPeriod[3], RepaymentPeriod[4]);


        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Daily then
            RepaymentPeriod[5] := RepaymentPeriod[4];
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Weekly then
            RepaymentPeriod[5] := RepaymentPeriod[3];
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Fortnightly then
            RepaymentPeriod[5] := round(RepaymentPeriod[3] / 2, 1, '=');// / 2;
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Monthly then
            RepaymentPeriod[5] := RepaymentPeriod[2];
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Annually then
            RepaymentPeriod[5] := RepaymentPeriod[1];
        EVALUATE(DateFormula, GetRepaymentFrequencyDateFormula(LoanApplication));
        i := 1;

        NextRepaymentDate := CALCDATE(LoanProductType."Grace Period", StartDate);
        NoOfInstallments := GetNoofInstallments(LoanApplication."No.", StartDate, LoanApplication."Date of Completion");
        ApprovedLoanAmount := LoanAmount;
        IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::"Straight Line" THEN BEGIN
            // if NoOfInstallments <> 0 then
            if format(LoanApplication."Repayment Period") <> '' then
                PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
            If (LoanApplication."Loan Restructured" = true) Or (LoanApplication."Loan Product Type" = 'IPF') then
                InterestAmount := 0
            else
                InterestAmount := ApprovedLoanAmount * (LoanApplication."Interest Rate" / 100);

            FOR i := 1 TO NoOfInstallments DO BEGIN
                AddRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                ApprovedLoanAmount -= PrincipalAmount;
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            END;
        END;

        IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::"Reducing Balance" THEN BEGIN
            // if NoOfInstallments <> 0 then
            if format(LoanApplication."Repayment Period") <> '' then
                PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
            FOR i := 1 TO NoOfInstallments DO BEGIN
                If LoanApplication."Loan Restructured" = true then
                    InterestAmount := 0
                else
                    InterestAmount := ApprovedLoanAmount * (LoanApplication."Interest Rate" / 12 / 100);
                //  InterestAmount := ApprovedLoanAmount * (LoanApplication."Interest Rate" / 100);

                AddRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                ApprovedLoanAmount -= PrincipalAmount;
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);

            END;
        END;

        IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::Amortization THEN BEGIN
            /* ConstantAmount := ApprovedLoanAmount *
                            ((LoanApplication."Interest Rate" / NoOfInstallments / 100) *
                            (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments / 100), NoOfInstallments))) /
                            (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments) / 100, NoOfInstallments) - 1);*/

            If LoanApplication."Loan Restructured" = true then
                //  if NoOfInstallments <> 0 then
                ConstantAmount := ApprovedLoanAmount / NoOfInstallments
            else
                ConstantAmount := ApprovedLoanAmount * ((LoanApplication."Interest Rate" / 12 / 100) * (POWER(1 + (LoanApplication."Interest Rate" / 12 / 100),
                 NoOfInstallments))) / (POWER(1 + (LoanApplication."Interest Rate" / 12) / 100, NoOfInstallments) - 1);

            FOR i := 1 TO NoOfInstallments DO BEGIN
                If LoanApplication."Loan Restructured" = true then
                    InterestAmount := 0
                else
                    InterestAmount := (ApprovedLoanAmount) * (LoanApplication."Interest Rate" / 12 / 100);
                PrincipalAmount := ConstantAmount - InterestAmount;
                AddRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                ApprovedLoanAmount -= PrincipalAmount;
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            END;
        END;
    END;

    local procedure GetRepaymentPeriodLoanCalc(MemberNo: Code[20]; StartDate: Date; EndDate: Date;
                                     VAR CountYears: Integer; var CountMonths: Integer; var CountWeeks: Integer; var CountDays: Integer)
    var
        Calendar: Record Date;
        TempDate: Date;
        LastFoundDate: Date;
        TotalDays: Integer;
        Found: Boolean;
        Member: Record Member;
        LoanApplication: Record "Loan Application";
    begin
        if Member.Get(MemberNo) then begin
            Calendar.RESET;
            Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
            Calendar.SETRANGE("Period Start", StartDate, EndDate);

            TotalDays := Calendar.COUNT;          // only for information

            IF Calendar.FINDSET THEN BEGIN

                // *** find count of years ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1Y', StartDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountYears += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1Y', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;

                // *** find count of months ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1M', LastFoundDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountMonths += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1M', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;

                // *** find count of weeks ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1W', LastFoundDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountWeeks += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1W', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;

                // *** find count of days ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1D', LastFoundDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountDays += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1D', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;
            END;

            // MESSAGE(Text001, TotalDays, CountYears, CountMonths, CountDays);
        end;
    end;

    procedure GetNoofInstallmentsLoanCalc(StartDate: Date; EndDate: Date): Integer
    var
        j: Integer;
        LastRepaymentDate: Date;
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
    begin
        j := 0;
        EVALUATE(DateFormula, '1M');
        LastRepaymentDate := EndDate;
        NextRepaymentDate := StartDate;
        WHILE NextRepaymentDate <= LastRepaymentDate DO BEGIN
            NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            j += 1;
        END;
        EXIT(j - 1);
    end;

    local procedure AddRepaymentScheduleLoanCalc(Memb: Record Member; RepaymentDate: Date; LoanBalance: Decimal; PrincipalAmount: Decimal; InterestAmount: Decimal; InstallmentNo: Integer)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoanRepaymentSchedule.INIT;
        LoanRepaymentSchedule."Loan No." := Memb."No.";
        LoanRepaymentSchedule."Repayment Date" := RepaymentDate;
        LoanRepaymentSchedule."Member No." := Memb."No.";
        LoanRepaymentSchedule."Member Name" := Memb."Full Name";
        LoanRepaymentSchedule."Instalment No." := InstallmentNo;
        LoanRepaymentSchedule."Loan Amount" := LoanBalance;
        LoanRepaymentSchedule."Principal Installment" := PrincipalAmount;
        LoanRepaymentSchedule."Interest Installment" := InterestAmount;
        LoanRepaymentSchedule."Total Installment" := PrincipalAmount + InterestAmount;
        LoanRepaymentSchedule.INSERT;
    end;

    procedure CreateRepaymentScheduleLoanCalculator(MemberNo: Code[20]; LoanAmount: Decimal; LoanProd: Code[50]; RepayPeriod: DateFormula)
    var
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        NoOfInstallments: Integer;
        PrincipalAmount: Decimal;
        InterestAmount: Decimal;
        ApprovedLoanAmount: Decimal;
        ConstantAmount: Decimal;
        DateofCompletion: Date;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
        RepaymentPeriod: array[8] of integer;
        StartDate: Date;
        Member: Record Member;
    begin
        Member.Get(MemberNo);
        If LoanProductType.Get(LoanProd) then begin

            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", MemberNo);
            LoanRepaymentSchedule.DELETEALL;
            StartDate := Today;

            GetRepaymentPeriodLoanCalc(MemberNo, StartDate, CalcDate(RepayPeriod, StartDate), RepaymentPeriod[1], RepaymentPeriod[2], RepaymentPeriod[3], RepaymentPeriod[4]);


            if LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Daily then
                RepaymentPeriod[5] := RepaymentPeriod[4];
            if LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Weekly then
                RepaymentPeriod[5] := RepaymentPeriod[3];
            if LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Fortnightly then
                RepaymentPeriod[5] := round(RepaymentPeriod[3] / 2, 1, '=');// / 2;
            if LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Monthly then
                RepaymentPeriod[5] := RepaymentPeriod[2];
            if LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Annually then
                RepaymentPeriod[5] := RepaymentPeriod[1];
            EVALUATE(DateFormula, '1M');
            i := 1;

            NextRepaymentDate := CALCDATE(LoanProductType."Grace Period", StartDate);

            NoOfInstallments := GetNoofInstallmentsLoanCalc(StartDate, CalcDate(RepayPeriod, StartDate));
            ApprovedLoanAmount := LoanAmount;
            IF LoanProductType."Repayment Method" = LoanProductType."Repayment Method"::"Straight Line" THEN BEGIN
                PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
                If LoanApplication."Loan Restructured" = true then
                    InterestAmount := 0
                else
                    InterestAmount := ApprovedLoanAmount * (LoanProductType."Interest Rate" / 100);
                FOR i := 1 TO NoOfInstallments DO BEGIN
                    AddRepaymentScheduleLoanCalc(Member, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                    ApprovedLoanAmount -= PrincipalAmount;
                    NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                END;
            END;

            IF LoanProductType."Repayment Method" = LoanProductType."Repayment Method"::"Reducing Balance" THEN BEGIN
                PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
                FOR i := 1 TO NoOfInstallments DO BEGIN
                    If LoanApplication."Loan Restructured" = true then
                        InterestAmount := 0
                    else
                        InterestAmount := ApprovedLoanAmount * (LoanProductType."Interest Rate" / 12 / 100);
                    AddRepaymentScheduleLoanCalc(Member, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                    ApprovedLoanAmount -= PrincipalAmount;
                    NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                END;
            END;

            IF LoanProductType."Repayment Method" = LoanProductType."Repayment Method"::Amortization THEN BEGIN
                /* ConstantAmount := ApprovedLoanAmount *
                                ((LoanApplication."Interest Rate" / NoOfInstallments / 100) *
                                (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments / 100), NoOfInstallments))) /
                                (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments) / 100, NoOfInstallments) - 1);*/

                If LoanApplication."Loan Restructured" = true then
                    ConstantAmount := ApprovedLoanAmount / NoOfInstallments
                else
                    ConstantAmount := ApprovedLoanAmount * ((LoanProductType."Interest Rate" / 12 / 100) * (POWER(1 + (LoanProductType."Interest Rate" / 12 / 100),
                     NoOfInstallments))) / (POWER(1 + (LoanProductType."Interest Rate" / 12) / 100, NoOfInstallments) - 1);

                FOR i := 1 TO NoOfInstallments DO BEGIN
                    InterestAmount := (ApprovedLoanAmount) * (LoanProductType."Interest Rate" / 12 / 100);
                    PrincipalAmount := ConstantAmount - InterestAmount;
                    AddRepaymentScheduleLoanCalc(Member, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                    ApprovedLoanAmount -= PrincipalAmount;
                    NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                END;
            END;
        end;
    END;



    procedure CreateRepaymentScheduleRestructure(LoanNo: Code[20]; LoanAmount: Decimal)
    var
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        NoOfInstallments: Integer;
        PrincipalAmount: Decimal;
        InterestAmount: Decimal;
        ApprovedLoanAmount: Decimal;
        ConstantAmount: Decimal;
        DateofCompletion: Date;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
        RepaymentPeriod: array[8] of integer;
        StartDate: Date;
        LoanRestructure: Record "Loan Restructuring";
    begin

        LoanApplication.GET(LoanNo);
        LoanApplication.TestField("Interest Rate");
        LoanApplication.TestField("Repayment Method");
        LoanApplication.TestField("Repayment Period");
        // LoanApplication.TestField("Created Date");

        LoanProductType.Get(LoanApplication."Loan Product Type");

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.DELETEALL;

        //if LoanApplication."Disbursal Date" = 0D then
        //StartDate := LoanApplication."Created Date"
        //ELSE
        StartDate := LoanApplication."Next Due Date";


        GetRepaymentPeriod(LoanNo, StartDate, LoanApplication."Date of Completion",
                            RepaymentPeriod[1], RepaymentPeriod[2], RepaymentPeriod[3], RepaymentPeriod[4]);


        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Daily then
            RepaymentPeriod[5] := RepaymentPeriod[4];
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Weekly then
            RepaymentPeriod[5] := RepaymentPeriod[3];
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Fortnightly then
            RepaymentPeriod[5] := round(RepaymentPeriod[3] / 2, 1, '=');// / 2;
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Monthly then
            RepaymentPeriod[5] := RepaymentPeriod[2];
        if LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Annually then
            RepaymentPeriod[5] := RepaymentPeriod[1];
        EVALUATE(DateFormula, GetRepaymentFrequencyDateFormula(LoanApplication));
        i := 1;

        NextRepaymentDate := CALCDATE(LoanProductType."Grace Period", StartDate);
        NoOfInstallments := GetNoofInstallments(LoanApplication."No.", StartDate, LoanApplication."Date of Completion");
        ApprovedLoanAmount := LoanAmount;
        IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::"Straight Line" THEN BEGIN
            PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;

            FOR i := 1 TO NoOfInstallments DO BEGIN
                AddRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                ApprovedLoanAmount -= PrincipalAmount;
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            END;
        END;

        IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::"Reducing Balance" THEN BEGIN
            PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
            FOR i := 1 TO NoOfInstallments DO BEGIN
                AddRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                ApprovedLoanAmount -= PrincipalAmount;
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);

            END;
        END;

        IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::Amortization THEN BEGIN
            /* ConstantAmount := ApprovedLoanAmount *
                            ((LoanApplication."Interest Rate" / NoOfInstallments / 100) *
                            (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments / 100), NoOfInstallments))) /
                            (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments) / 100, NoOfInstallments) - 1);*/


            //ConstantAmount := ApprovedLoanAmount *
            // ((LoanApplication."Interest Rate" / 12 / 100) * (POWER(1 + (LoanApplication."Interest Rate" / 12 / 100), NoOfInstallments))) /
            // (POWER(1 + (LoanApplication."Interest Rate" / 12) / 100, NoOfInstallments) - 1);

            ConstantAmount := ApprovedLoanAmount / NoOfInstallments;

            FOR i := 1 TO NoOfInstallments DO BEGIN
                PrincipalAmount := ConstantAmount;
                AddRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
                ApprovedLoanAmount -= PrincipalAmount;
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            END;
        END;
    END;

    local procedure AddRepaymentSchedule(LoanApplication: Record "Loan Application"; RepaymentDate: Date; LoanBalance: Decimal; PrincipalAmount: Decimal; InterestAmount: Decimal; InstallmentNo: Integer)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoanRepaymentSchedule.INIT;
        LoanRepaymentSchedule."Loan No." := LoanApplication."No.";
        LoanRepaymentSchedule."Repayment Date" := RepaymentDate;
        LoanRepaymentSchedule."Member No." := LoanApplication."Member No.";
        LoanRepaymentSchedule."Member Name" := LoanApplication."Member Name";
        LoanRepaymentSchedule."Instalment No." := InstallmentNo;
        LoanRepaymentSchedule."Loan Amount" := LoanBalance;
        LoanRepaymentSchedule."Principal Installment" := PrincipalAmount;
        LoanRepaymentSchedule."Interest Installment" := InterestAmount;
        LoanRepaymentSchedule."Total Installment" := PrincipalAmount + InterestAmount;
        LoanRepaymentSchedule.INSERT;
    end;

    procedure GetNoofInstallments(LoanNo: Code[20]; StartDate: Date; EndDate: Date): Integer
    var
        LoanApplication: Record "Loan Application";
        j: Integer;
        LastRepaymentDate: Date;
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
    begin
        j := 0;
        LoanApplication.GET(LoanNo);
        EVALUATE(DateFormula, GetRepaymentFrequencyDateFormula(LoanApplication));
        LastRepaymentDate := EndDate;
        NextRepaymentDate := StartDate;
        WHILE NextRepaymentDate <= LastRepaymentDate DO BEGIN
            NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            j += 1;
        END;
        EXIT(j - 1);
    end;

    local procedure GetRepaymentPeriod(LoanNo: Code[20]; StartDate: Date; EndDate: Date;
                                    VAR CountYears: Integer; var CountMonths: Integer; var CountWeeks: Integer; var CountDays: Integer)
    var
        Calendar: Record Date;
        TempDate: Date;
        LastFoundDate: Date;
        TotalDays: Integer;
        Found: Boolean;
        LoanApplication: Record "Loan Application";
    begin
        if LoanApplication.Get(LoanNo) then begin
            Calendar.RESET;
            Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
            Calendar.SETRANGE("Period Start", StartDate, EndDate);

            TotalDays := Calendar.COUNT;          // only for information

            IF Calendar.FINDSET THEN BEGIN

                // *** find count of years ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1Y', StartDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountYears += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1Y', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;

                // *** find count of months ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1M', LastFoundDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountMonths += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1M', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;

                // *** find count of weeks ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1W', LastFoundDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountWeeks += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1W', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;

                // *** find count of days ***
                LastFoundDate := StartDate;
                TempDate := CALCDATE('+1D', LastFoundDate);
                Found := TRUE;

                REPEAT
                    IF (TempDate <= EndDate) AND (Calendar.GET(Calendar."Period Type"::Date, TempDate)) THEN BEGIN
                        CountDays += 1;
                        LastFoundDate := TempDate;
                        TempDate := CALCDATE('+1D', TempDate);
                    END ELSE
                        Found := FALSE;
                UNTIL NOT Found;
            END;

            // MESSAGE(Text001, TotalDays, CountYears, CountMonths, CountDays);
        end;
    end;

    procedure GetRepaymentFrequencyDateFormula(LoanApplication: Record "Loan Application") DateFormula: Code[20]
    var
        LoanProductType: Record "Loan Product Type";
    begin
        with LoanApplication DO begin
            IF LoanProductType.GET("Loan Product Type") THEN BEGIN
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Annually THEN
                    DateFormula := '1Y';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Quarterly THEN
                    DateFormula := '3M';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Monthly THEN
                    DateFormula := '1M';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Fortnightly THEN
                    DateFormula := '2W';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Weekly THEN
                    DateFormula := '1W';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Daily THEN
                    DateFormula := '1D';
            END;
            EXIT(DateFormula);
        END;
    end;

    procedure PostLoan(var LoanApplication: Record "Loan Application")
    var
        GenJournalLine: Record "Gen. Journal Line";
        LoanProductCharge: Record "Loan Product Charge";
        RecRef: RecordRef;
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
        LoanConsolidationEntry: Record "Loan Consolidation Entry";
        DisbursalAmount: Decimal;
        Text000: Label 'Loan Refinancing-';
        LoanProductType: Record "Loan Product Type";
        TransactionTypeCode: Code[20];
        LoanChargeSetup: Record "Loan Charge Setup";
        TotalCharges: Decimal;
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        StartDate: date;
        Installments: Integer;
        BosaM: Codeunit "BOSA Management";
        Memb: Record Member;
        ProdCharge: decimal;
        InterestDue: decimal;
        LoanAmount: decimal;
    begin
        WITH LoanApplication DO BEGIN
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField(Loan);
            LoanApplicationSetup.TestField("Loan Disbursal Template Name");
            LoanApplicationSetup.TestField("Loan Disbursal Batch Name");
            TransactionTypeCodeSetup.TestField("New Loan");
            TransactionTypeCodeSetup.TestField("Processing Fee");
            TransactionTypeCodeSetup.TestField("Insurance Fee");
            TransactionTypeCodeSetup.TestField("Refinancing Fee");
            TransactionTypeCodeSetup.TestField("Ledger Fee Due");

            CALCFIELDS("Total Refinanced Amount", "Total Consolidated Amount");
            IF "Approved Amount" = 0 then
                "Approved Amount" := "Requested Amount";

            DisbursalAmount := "Approved Amount" - "Total Refinanced Amount" - "Total Consolidated Amount";
            TotalCharges := 0;
            LoanAmount := 0;
            CreateLoanAccount(LoanApplication);
            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");

            if LoanApplication."Loan Product Type" = 'IPF' then begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::Customer, "No.", Description, "Approved Amount" - "Interest Charged On IPF",
                                                            LoanProductType."Loan Posting Group", TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end else begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::Customer, "No.", Description, "Approved Amount",
                                            LoanProductType."Loan Posting Group", TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;




            IF "Top-up" THEN BEGIN
                LoanRefinancingEntry.RESET;
                LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
                LoanRefinancingEntry.SETRANGE(Select, TRUE);
                IF LoanRefinancingEntry.FINDSET THEN BEGIN
                    REPEAT
                        GlobalManagement.DeductLoanArrearsRefinancing(TransactionTypeCodeSetup, SourceCodeSetup, LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date",
                         LoanRefinancingEntry."Loan To Refinance", LoanRefinancingEntry."Outstanding Balance", "Global Dimension 1 Code");
                    UNTIL LoanRefinancingEntry.NEXT = 0;
                END;
            END;
            IF Consolidation THEN BEGIN
                LoanConsolidationEntry.RESET;
                LoanConsolidationEntry.SETRANGE("Loan No.", "No.");
                IF LoanConsolidationEntry.FINDSET THEN BEGIN
                    REPEAT
                        GlobalManagement.DeductLoanArrearsConsolidation(TransactionTypeCodeSetup, SourceCodeSetup, LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date",
                         LoanConsolidationEntry."Loan To Consolidate", LoanConsolidationEntry."Outstanding Balance", "Global Dimension 1 Code");
                    UNTIL LoanConsolidationEntry.NEXT = 0;
                END;
            END;

            if "Disbursal Date" = 0D then begin
                StartDate := "Created Date";
            end else begin
                StartDate := "Disbursal Date";
                "Next Due Date" := CalcDate('1M', "Disbursal Date");
                "Date of Completion" := CalcDate("Repayment Period", "Disbursal Date");
                Modify();
            end;
            Installments := BosaM.GetNoofInstallments("No.", StartDate, "Date of Completion");
            LoanProductType.Reset();
            LoanProductType.SetRange(Code, "Loan Product Type");
            if LoanProductType.FindFirst() then begin

                if loanProductType.ChargeInterestUpfront = true then begin
                    if "Loan Product Type" = 'IPF' then begin
                        InterestDue := Round(("Interest Charged On IPF"), 1, '=');
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::Customer, "No.", 'Interest Charged Upfront' + "No.", InterestDue, LoanProductType."Interest Paid Posting Group",
                                       TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::"G/L Account", LoanProductType."Interest Paid Posting Group", 'Interest Charged Upfront' + "No.", -InterestDue, '',
                        TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end else begin
                        InterestDue := Round(("Approved Amount" * ("Interest Rate" / 12 / 100)), 1, '=');

                        GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::"G/L Account",
                                           LoanProductType."Interest Paid Posting Group", 'Interest Charged Upfront' + "No.", -InterestDue, '', TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code",
                                           BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                    end;

                    // else

                    TotalCharges += InterestDue;
                end;
            end;
            LoanProductCharge.RESET;
            LoanProductCharge.SETRANGE("Loan Product Type", "Loan Product Type");
            IF LoanProductCharge.FINDSET THEN BEGIN
                REPEAT
                    LoanChargeSetup.Get(LoanProductCharge.Code);
                    LoanChargeSetup.TestField("Income G/L Account");
                    ProdCharge := 0;

                    if LoanChargeSetup.Type = LoanChargeSetup.Type::"Processing Fee" then
                        TransactionTypeCode := TransactionTypeCodeSetup."Processing Fee";
                    if LoanChargeSetup.Type = LoanChargeSetup.Type::"Insurance Fee" then
                        TransactionTypeCode := TransactionTypeCodeSetup."Insurance Fee";
                    if LoanChargeSetup.Type = LoanChargeSetup.Type::"Ledger Fee" then
                        TransactionTypeCode := TransactionTypeCodeSetup."Ledger Fee Due";

                    //if (("Approved Amount" >= LoanProductCharge."Minimum Amount") AND ("Approved Amount" <= LoanProductCharge."Maximum Amount")) THEN begin

                    IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" THEN BEGIN
                        if LoanChargeSetup.Type = LoanChargeSetup.Type::"Insurance Fee" then begin
                            ProdCharge := Round(((LoanProductCharge.Value * DisbursalAmount * Installments) / 1200), 1, '=');
                            //(LoanProductCharge.Value * LoanAmount * Instalments) / 1200;
                            if LoanProductCharge."Loan Product Type" = 'IPF' then begin
                                ProdCharge := "Insurrance On IPF";
                            end;
                            If LoanProductCharge.Code = 'INSURFEE' Then begin
                                If Memb.Get("Member No.") then begin
                                    if Memb.Category = Memb.Category::Group then
                                        ProdCharge := 0;
                                end;
                            end;

                            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::"G/L Account",
                                      LoanChargeSetup."Income G/L Account", LoanProductCharge.Description, -ProdCharge, '', TransactionTypeCode, SourceCodeSetup.Loan, "Global Dimension 1 Code",
                                      BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                            TotalCharges += ProdCharge;
                        end;

                        if LoanChargeSetup.Type = LoanChargeSetup.Type::"Processing Fee" then begin
                            ProdCharge := Round((LoanProductCharge.Value / 100 * "Approved Amount"), 1, '=');

                            /* if ProdCharge > LoanProductCharge."Maximum Amount" then
                                 ProdCharge := LoanProductCharge."Maximum Amount"
                             else
                                 Prodcharge := ProdCharge;*/

                            if ProdCharge < LoanProductCharge."Minimum Amount" then
                                ProdCharge := LoanProductCharge."Minimum Amount"
                            else
                                Prodcharge := ProdCharge;
                            if LoanProductCharge."Loan Product Type" = 'IPF' then begin
                                ProdCharge := "Processing Fee On IPF";
                            end;
                            If LoanProductCharge.Code = 'INSURFEE' Then begin
                                If Memb.Get("Member No.") then begin
                                    if Memb.Category = Memb.Category::Group then
                                        ProdCharge := 0;
                                end;
                            end;
                            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::"G/L Account",
                                      LoanChargeSetup."Income G/L Account", LoanProductCharge.Description, -ProdCharge, '', TransactionTypeCode, SourceCodeSetup.Loan, "Global Dimension 1 Code",
                                      BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                            TotalCharges += ProdCharge;
                        end;
                    END;

                    IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"Flat Amount" THEN BEGIN
                        GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::"G/L Account",
                                   LoanChargeSetup."Income G/L Account", LoanProductCharge.Description, -LoanProductCharge.Value, '', TransactionTypeCode, SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                        TotalCharges += LoanProductCharge.Value;
                    END;
                // end;
                UNTIL LoanProductCharge.NEXT = 0;
            END;

            if "Mode of Disbursement" = "Mode of Disbursement"::"FOSA Account" then begin
                //GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date",
                //          AccountTypeEnum::Vendor, "Disbursal Account No.", Description, -(DisbursalAmount - TotalCharges), TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
            end;
            if "Mode of Disbursement" = "Mode of Disbursement"::"G/L" then begin

                GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date",
                               AccountTypeEnum::"G/L Account", '3316', Description, -(DisbursalAmount - TotalCharges), '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

                LoanProductType.Get("Loan Product Type");

            end;
            if "Mode of Disbursement" = "Mode of Disbursement"::"Bank Account" then begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date",
                              AccountTypeEnum::"Bank Account", "Disbursal Account No.", Description, -(DisbursalAmount - TotalCharges), '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
            //CLEARLASTERROR;
            IF GlobalManagement.PostJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name") THEN BEGIN
                /*  if Confirm(PrintLoanVoucherConfirmMsg, true) then begin
                     LoanApplication.Get("No.");
                     LoanApplication.SETRECFILTER;
                     // Report.Run(Report::"Loan Voucher", true, false, LoanApplication);
                 end else
                     exit;*/

                Posted := TRUE;
                "Disbursed By" := USERID;
                "Disbursal Date" := "Disbursal Date";
                "Disbursal Time" := TIME;
                "Created By" := USERID;
                "Next Due Date" := CalcDate('1M', "Disbursal Date");
                "Date of Completion" := CalcDate("Repayment Period", "Disbursal Date");
                GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
                "Disbursed By Host Name" := HostName;
                "Disbursed By Host IP" := HostIP;
                "Disbursed By Host MAC" := HostMac;

                IF MODIFY THEN BEGIN
                    CreateRepaymentSchedule("No.", "Approved Amount");
                    RecRef.GetTable(LoanApplication);
                    SendNotification(RecRef);
                END;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN BEGIN
                    IF Customer.GET("No.") THEN
                        Customer.DELETE;
                    ERROR(GETLASTERRORTEXT);
                END;
            END;
        END;
    end;


    procedure PostLoanAttachToGuarantor(var LoanApplication: Record "Loan Application"; LoanApplicationOLD: Record "Loan Application")
    var
        GenJournalLine: Record "Gen. Journal Line";
        LoanProductCharge: Record "Loan Product Charge";
        RecRef: RecordRef;
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
        DisbursalAmount: Decimal;
        Text000: Label 'Loan Attach to Guarantor-';
        LoanProductType: Record "Loan Product Type";
        TransactionTypeCode: Code[20];
        LoanChargeSetup: Record "Loan Charge Setup";
        TotalCharges: Decimal;
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        StartDate: date;
        Installments: Integer;
        BosaM: Codeunit "BOSA Management";
        ProdCharge: decimal;
    begin
        WITH LoanApplication DO BEGIN
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField(Loan);
            LoanApplicationSetup.TestField("Loan Disbursal Template Name");
            LoanApplicationSetup.TestField("Loan Disbursal Batch Name");
            TransactionTypeCodeSetup.TestField("New Loan");
            TransactionTypeCodeSetup.TestField("Processing Fee");
            TransactionTypeCodeSetup.TestField("Insurance Fee");
            TransactionTypeCodeSetup.TestField("Refinancing Fee");
            TransactionTypeCodeSetup.TestField("Ledger Fee Due");

            CALCFIELDS("Total Refinanced Amount");
            IF "Approved Amount" = 0 then
                "Approved Amount" := "Requested Amount";

            DisbursalAmount := "Approved Amount";
            TotalCharges := 0;
            CreateLoanAccount(LoanApplication);
            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");
            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", "Disbursal Date", AccountTypeEnum::Customer, "No.", Description, "Approved Amount",
                                            LoanProductType."Loan Posting Group", TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");

            if "Disbursal Date" = 0D then begin
                StartDate := "Created Date";
            end else begin
                StartDate := "Disbursal Date";
            end;
            Installments := BosaM.GetNoofInstallments("No.", StartDate, "Date of Completion");

            if "Mode of Disbursement" = "Mode of Disbursement"::"Bank Account" then begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", "No.", "No.", Today,
                              AccountTypeEnum::Customer, LoanApplicationOLD."No.", Description, -(DisbursalAmount), '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;

            IF GlobalManagement.PostJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name") THEN BEGIN

                Posted := TRUE;
                "Disbursed By" := USERID;
                "Disbursal Date" := "Disbursal Date";
                "Disbursal Time" := TIME;
                "Created By" := USERID;
                GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
                "Disbursed By Host Name" := HostName;
                "Disbursed By Host IP" := HostIP;
                "Disbursed By Host MAC" := HostMac;

                IF MODIFY THEN BEGIN
                    CreateRepaymentSchedule("No.", "Approved Amount");
                    RecRef.GetTable(LoanApplication);
                    SendNotification(RecRef);
                END;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN BEGIN
                    IF Customer.GET("No.") THEN
                        Customer.DELETE;
                    ERROR(GETLASTERRORTEXT);
                END;
            END;
        END;
    end;

    procedure GetBoreshaAccount(var MemberNo: Code[20]) BoreshaAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::Savings);
        AccountType.SetRange("Sub Type", AccountType."Sub Type"::Boresha);
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                BoreshaAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetSavingsAccount(var MemberNo: Code[20]) SavingsAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::"Member Deposit");
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                SavingsAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetShareCapitalAccount(var MemberNo: Code[20]) ShareCapitalAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::"Share Capital");
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                ShareCapitalAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetDepositAccount(var MemberNo: Code[20]) DepositAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::"Member Deposit");
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                DepositAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetDepositAccountBalance(var MemberNo: Code[20]; AsAt: Date) DepositBal: Decimal
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
        DVendL: Record "Detailed Vendor Ledg. Entry";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::"Member Deposit");
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FindFirst() THEN BEGIN
                DVendL.Reset();
                DVendL.SetRange("Vendor No.", Vendor."No.");
                DVendL.SetFilter("Posting Date", '<=%1', AsAt);
                if DVendL.FindSet() then begin
                    DVendL.CalcSums(Amount);
                    DepositBal := DVendL.Amount;
                end;
            END;
        END;
    end;

    procedure GetDimension(var MemberNo: Code[20]) DimensionCode: Code[20]
    var
        Customer: Record "Customer";
    begin
        DimensionCode := '';
        Member.GET(MemberNo);
        DimensionCode := Member."Global Dimension 1 Code";
    end;



    procedure CreateLoanAccount(LoanApplication: Record "Loan Application")
    var
        AccountType: Record "Account Type";
    begin
        WITH LoanApplication DO BEGIN
            IF NOT Customer.GET("No.") THEN BEGIN
                Customer.INIT;
                Customer."No." := "No.";
                Customer.Name := Description;
                Customer."Customer Posting Group" := "Loan Product Type";
                Customer."Member No." := "Member No.";
                Customer."Member Name" := "Member Name";
                Customer."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Customer.Status := Customer.Status::Active;
                Customer."Loan Product Type" := "Loan Product Type";
                Customer."Customer Type" := Customer."Customer Type"::Loan;
                Customer.INSERT;
            END;
        END;
    end;


    procedure CapitalizeInterest(var Customer: Record Customer; RunDate: Date; PostingDate: Date)
    var
        LoanProductType: Record "Loan Product Type";
        DayofMonth: Integer;
        LPSpecialInterestCapSetup: Record "LP Special Int. Cap. Setup";
        DisbursalDay: Integer;
        CapitalizationDay: Integer;
        LoanApplication: Record "Loan Application";
    begin
        WITH Customer DO BEGIN
            LoanApplication.Get("No.");
            LoanApplication.TestField("Disbursal Date");
            LoanApplication.TestField("Interest Rate");
            LoanApplication.TestField("Repayment Method");
            LoanApplication.TestField("Repayment Frequency");
            LoanApplication.TestField("Repayment Method");
            DisbursalDay := Date2DMY(LoanApplication."Disbursal Date", 1);
            DayofMonth := Date2DMY(Today, 1);
            LoanProductType.GET("Loan Product Type");
            LoanProductType.TestField("Interest Due Posting Group");
            LoanProductType.TestField("Interest Paid Posting Group");
            CreateInterestDueLines(Customer, LoanApplication, LoanProductType, RunDate, PostingDate);
        end;
    end;

    local procedure CreateInterestDueLines(var Customer: Record Customer; LoanApplication: Record "Loan Application"; LoanProductType: Record "Loan Product Type"; RunDate: Date; PostingDate: Date)
    var
        Text000: Label 'Interest Charged-';
        Text0001: Label 'Interest Recovered from Prepayment-';
        Text0002: Label 'Interest Charged Paid from Prepayment-';
        Text0003: Label 'Principal Recovered from Prepayment-';
        Text0004: Label 'Principal Paid from Prepayment-';
        Text0005: Label 'Penalty Recovered from Prepayment-';
        Text0006: Label 'Penalty Paid from Prepayment-';
        CustomerPostingGroup: Record "Customer Posting Group";
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        DateFilter: Text[100];
        DCustL: Record "Detailed Cust. Ledg. Entry";
        OutBal: Decimal;
        LPrePaymentAmount: Decimal;
        IntRecov: Decimal;
        PrincBal: Decimal;
        PrincRecov: Decimal;
        PenaltyRecov: Decimal;
        PrincRepay: Decimal;
        LoanRep: Record "Loan Repayment Schedule";
        ExpectedPrincPaid: Decimal;
        PrincipalPaid: Decimal;
        Arrears: array[10] of Decimal;
    begin
        with Customer do begin
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();
            OutBal := 0;
            LPrePaymentAmount := 0;
            IntRecov := 0;
            PenaltyRecov := 0;
            PenaltyDue := 0;
            PrincBal := 0;
            PrincRecov := 0;
            ExpectedPrincPaid := 0;
            PrincipalPaid := 0;

            //DateFilter := '..' + Format(RunDate);

            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", '<=%1', RunDate);
            if DCustL.FindSet() then begin
                repeat
                    OutBal += DCustL.Amount;
                    If (DCustL."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid") or (DCustL."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") then
                        PrincBal += DCustL.Amount;
                until DCustL.Next = 0;
            end;

            GlobalManagement.CalculateLoanPrepayment(Customer."No.", 0D, RunDate, LPrePaymentAmount);
            LPrePaymentAmount := -(LPrePaymentAmount);
            GlobalManagement.CalculateLoanArrearsAndOverpaymentInterestCharging(Customer."No.", 0D, RunDate, Arrears[1], Arrears[2], Arrears[3], Arrears[4], Arrears[5], Arrears[6], Arrears[7], Arrears[8]);
            PrincRecov := Arrears[1];
            PenaltyRecov := Arrears[4];
            IntRecov := Arrears[2];
            SourceCodeSetup.TestField(Loan);

            TransactionTypeCodeSetup.TestField("Interest Due");
            TransactionTypeCodeSetup.TestField("Interest Paid");
            LoanApplicationSetup.TestField("Loan Interest Template Name");
            LoanApplicationSetup.TestField("Loan Interest Batch Name");
            //Error('Prin Bal %1\Outs Bal %2\Prin rec %3\Pen Rec %4\Prepay %5', PrincBal, OutBal, PrincRecov, PenaltyRecov, LPrePaymentAmount);

            if OutBal > 0 then begin
                if LoanApplication."Loan Restructured" = false then
                    InterestDue := Round((OutBal * (LoanApplication."Interest Rate" / 12 / 100)), 1, '=');
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'INT' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text000 + "No.", InterestDue, LoanProductType."Interest Paid Posting Group",
                TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'INT' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::"G/L Account", LoanProductType."Interest Paid Posting Group", Text000 + "No.", -InterestDue, '',
                TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

                If LPrePaymentAmount > 0 Then begin
                    If PenaltyRecov >= LPrePaymentAmount then begin
                        PenaltyRecov := LPrePaymentAmount;
                        LPrePaymentAmount := 0;
                    end else begin
                        PenaltyRecov := PenaltyRecov;
                        LPrePaymentAmount -= PenaltyRecov;
                    end;

                    IntRecov += InterestDue;
                    If IntRecov >= LPrePaymentAmount then begin
                        IntRecov := LPrePaymentAmount;
                        LPrePaymentAmount := 0;
                    end else begin
                        IntRecov := IntRecov;
                        LPrePaymentAmount -= IntRecov;
                    end;

                    If PrincRecov >= LPrePaymentAmount then begin
                        PrincRecov := LPrePaymentAmount;
                        LPrePaymentAmount := 0;
                    end else begin
                        PrincRecov := PrincRecov;
                        LPrePaymentAmount -= PrincRecov;
                    end;

                    //Recover Penalty
                    If PenaltyRecov > 0 then begin
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text0005 + "No.", PenaltyRecov, LoanProductType."Loan Prepayment Posting Group",
                        TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text0006 + "No.", -PenaltyRecov, LoanProductType."Penalty Due Posting Group",
                        TransactionTypeCodeSetup."Penalty Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end;
                    //Recover Interest
                    If IntRecov > 0 then begin
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text0001 + "No.", IntRecov, LoanProductType."Loan Prepayment Posting Group",
                        TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text0002 + "No.", -IntRecov, LoanProductType."Interest Due Posting Group",
                        TransactionTypeCodeSetup."Interest Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end;
                    //Recover Principal
                    If PrincRecov > 0 Then begin
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text0003 + "No.", PrincRecov, LoanProductType."Loan Prepayment Posting Group",
                        TransactionTypeCodeSetup."Loan Prepayment", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                        GlobalManagement.CreateLoanIntJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", 'REC' + FORMAT(PostingDate), "No.", PostingDate, AccountTypeEnum::Customer, "No.", Text0004 + "No.", -PrincRecov, LoanProductType."Loan Posting Group",
                        TransactionTypeCodeSetup."Principal Paid", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
                    end;
                end;
            end;
        end;
    end;

    local procedure GetLoanPrincipalBalance(LoanNo: Code[20]): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PrincipalPaid: Decimal;
        LoanPrincipalBalance: Decimal;
        LoanApplication: Record "Loan Application";
    begin
        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Principal Paid");

        LoanApplication.Get(LoanNo);
        PrincipalPaid := 0;

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", LoanNo);
        CustLedgerEntry.SetRange("Transaction Type Code", TransactionTypeCodeSetup."Principal Paid");
        if CustLedgerEntry.FindSet() then begin
            repeat
                CustLedgerEntry.CalcFields(Amount);
                PrincipalPaid += CustLedgerEntry.Amount;
            until CustLedgerEntry.Next() = 0;
        end;
        LoanPrincipalBalance := LoanApplication."Approved Amount" - abs(PrincipalPaid);
        if LoanPrincipalBalance > 0 then
            exit(LoanPrincipalBalance)
        else
            exit(0);
    end;

    procedure CapitalizeLedgerFee(var Customer: Record Customer)
    var
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Ledger Fee Charged-';
        CustomerPostingGroup: Record "Customer Posting Group";
        LedgerFeeDue: Decimal;

    begin
        with Customer do begin
            /*  CalcFields("Balance (LCY)");

              LoanApplicationSetup.GET;
              SourceCodeSetup.GET;
              TransactionTypeCodeSetup.Get();

              SourceCodeSetup.TestField(Loan);
              TransactionTypeCodeSetup.TestField("Ledger Fee Due");
              TransactionTypeCodeSetup.TestField("Ledger Fee Paid");

              LoanApplicationSetup.TestField("Ledger Fee Template Name");
              LoanApplicationSetup.TestField("Ledger Fee Batch Name");

              LedgerFeeDue := LoanApplicationSetup."Ledger Fee";

              if GlobalSetup."Income Realization Method" = GlobalSetup."Income Realization Method"::"On Accrual" then begin
                  CustomerPostingGroup.Get(LoanProductType."Ledger Fee Paid Posting Group");
                  CustomerPostingGroup.TestField("Receivables Account");
                  GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", "No.", "No.", Today, AccountTypeEnum::Customer, "No.", Text000 + "No.", LedgerFeeDue, LoanProductType."Ledger Fee Due Posting Group",
                                                 TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                  GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", "No.", "No.", Today, AccountTypeEnum::"G/L Account", CustomerPostingGroup."Receivables Account", Text000 + "No.", -LedgerFeeDue, '',
                                                 TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
              end;
              if GlobalSetup."Income Realization Method" = GlobalSetup."Income Realization Method"::"On Payment" then begin
                  CustomerPostingGroup.Get(LoanProductType."Ledger Fee Due Posting Group");
                  CustomerPostingGroup.TestField("Receivables Account");
                  GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", "No.", "No.", Today, AccountTypeEnum::Customer, "No.", Text000 + "No.", LedgerFeeDue, LoanProductType."Ledger Fee Due Posting Group",
                                                 TransactionTypeCodeSetup."Ledger Fee Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                  GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name", "No.", "No.", Today, AccountTypeEnum::"G/L Account", CustomerPostingGroup."Receivables Account", Text000 + "No.", -LedgerFeeDue, '',
                                                 TransactionTypeCodeSetup."Ledger Fee Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
              end;
              */
        end;
    end;

    procedure CapitalizePenalty(var Customer: Record Customer; RunDate: Date; PostingDate: Date)
    var
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Penalty Charged-';
        CustomerPostingGroup: Record "Customer Posting Group";
        PenaltyDue: Decimal;
        Outbal: Decimal;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        DFilter: Text[100];
        AmoutInArrears: array[4] of Decimal;
        Overpayment: array[4] of Decimal;
        TotalArrears: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalMonthlyRepayment: Decimal;
        AmountPaid: Decimal;
        MonthDateFilter: Text;
        Prepayment: Decimal;
    begin
        with Customer do begin
            CalcFields("Balance (LCY)");
            LoanApplication.Get(Customer."No.");
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            LoanProductType.Get(Customer."Customer Posting Group");
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Penalty Due");
            TransactionTypeCodeSetup.TestField("Penalty Paid");

            LoanApplicationSetup.TestField("Penalty Template Name");
            LoanApplicationSetup.TestField("Penalty Batch Name");

            DFilter := '..' + Format(CalcDate('7D', Rundate));//toka
            MonthDateFilter := Format(CalcDate('-1M', RunDate)) + '..' + Format(CalcDate('7D', Rundate));//change Rundate..Postingdate
            Outbal := 0;
            TotalArrears := 0;
            TotalMonthlyRepayment := 0;
            Prepayment := 0;
            PenaltyDue := 0;
            AmountPaid := 0;
            GlobalManagement.CalculateLoanArrearsAndOverpaymentFactbox(Customer."No.", 0D, Rundate, AmoutInArrears[1], AmoutInArrears[2], AmoutInArrears[3], AmoutInArrears[4], Overpayment[1], Overpayment[2], Overpayment[3], Overpayment[4]);
            TotalArrears := AmoutInArrears[1] + AmoutInArrears[2] + AmoutInArrears[3] + AmoutInArrears[4];
            GlobalManagement.CalculateLoanPrepayment(Customer."No.", 0D, RunDate, Prepayment);//Toka
            Prepayment := -(Prepayment);//Toka

            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", DFilter);
            if DCustL.FindSet() then begin
                DCustL.CalcSums(Amount);
                Outbal := DCustL.Amount;
            end;

            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", MonthDateFilter);
            DCustL.SetFilter("Credit Amount", '>%1', 0);
            if DCustL.FindSet() then begin
                DCustL.CalcSums("Credit Amount");
                AmountPaid := DCustL."Credit Amount";
            end;

            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", Customer."No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', RunDate);
            if LoanRepaymentSchedule.FindLast() then begin
                TotalMonthlyRepayment := Round(LoanRepaymentSchedule."Total Installment", 1, '=');
            end;

            if TotalArrears > 0 then begin
                if AmountPaid = 0 then begin
                    PenaltyDue := Round(((LoanApplicationSetup."Penalty Value" / 100) * TotalMonthlyRepayment), 1, '=');
                end;
                if AmountPaid > 0 then begin
                    if AmountPaid < TotalMonthlyRepayment then begin
                        PenaltyDue := Round((LoanApplicationSetup."Penalty Value" / 100) * (TotalMonthlyRepayment - AmountPaid), 1, '=');
                    end;
                end;
            end;
            If PenaltyDue > 0 Then Begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(Rundate), "No.", Rundate, AccountTypeEnum::Customer, "No.", Text000 + "No."+'-'+ LoanApplication.Description, PenaltyDue, LoanProductType."Penalty Paid Posting Group",
                                               TransactionTypeCodeSetup."Penalty Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(Rundate), "No.", Rundate, AccountTypeEnum::"G/L Account", LoanProductType."Penalty Paid Posting Group", Text000 + "No."+'-'+ LoanApplication.Description, -PenaltyDue, '',
                                               '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;
    end;

    procedure CapitalizePenaltyMob(var Customer: Record Customer; RunDate: Date; PostingDate: Date)
    var
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Penalty Charged-';
        CustomerPostingGroup: Record "Customer Posting Group";
        PenaltyDue: Decimal;
        Outbal: Decimal;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        DFilter: Text[100];
        AmoutInArrears: array[4] of Decimal;
        Overpayment: array[4] of Decimal;
        TotalArrears: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalMonthlyRepayment: Decimal;
        AmountPaid: Decimal;
        MonthDateFilter: Text;
        Prepayment: Decimal;
    begin
        with Customer do begin
            CalcFields("Balance (LCY)");
            LoanApplication.Get(Customer."No.");
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            LoanProductType.Get(Customer."Customer Posting Group");
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField(Loan);
            TransactionTypeCodeSetup.TestField("Penalty Due");
            TransactionTypeCodeSetup.TestField("Penalty Paid");

            LoanApplicationSetup.TestField("Penalty Template Name");
            LoanApplicationSetup.TestField("Penalty Batch Name");

            DFilter := '..' + Format(CalcDate('90D', PostingDate));//toka
                                                                   //  MonthDateFilter := Format(CalcDate('-1M', RunDate)) + '..' + Format(CalcDate('90D', PostingDate));//change Rundate..Postingdate
            Outbal := 0;
            TotalArrears := 0;
            TotalMonthlyRepayment := 0;
            Prepayment := 0;
            PenaltyDue := 0;
            AmountPaid := 0;
            GlobalManagement.CalculateLoanArrearsAndOverpaymentFactbox(Customer."No.", 0D, Rundate, AmoutInArrears[1], AmoutInArrears[2], AmoutInArrears[3], AmoutInArrears[4], Overpayment[1], Overpayment[2], Overpayment[3], Overpayment[4]);
            TotalArrears := AmoutInArrears[1] + AmoutInArrears[2] + AmoutInArrears[3] + AmoutInArrears[4];
            GlobalManagement.CalculateLoanPrepayment(Customer."No.", 0D, RunDate, Prepayment);//Toka
            Prepayment := -(Prepayment);//Toka

            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", DFilter);
            if DCustL.FindSet() then begin
                DCustL.CalcSums(Amount);
                Outbal := DCustL.Amount;
            end;

            DCustL.Reset();
            DCustL.SetRange("Customer No.", Customer."No.");
            DCustL.SetFilter("Posting Date", MonthDateFilter);
            DCustL.SetFilter("Credit Amount", '>%1', 0);
            if DCustL.FindSet() then begin
                DCustL.CalcSums("Credit Amount");
                AmountPaid := DCustL."Credit Amount";
            end;

            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", Customer."No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', RunDate);
            if LoanRepaymentSchedule.FindLast() then begin
                TotalMonthlyRepayment := Round(LoanRepaymentSchedule."Total Installment", 1, '=');
            end;

            if TotalArrears > 0 then begin
                if AmountPaid = 0 then begin
                    PenaltyDue := Round(((LoanApplicationSetup."Penalty Value" / 100) * TotalMonthlyRepayment), 1, '=');
                end;
                if AmountPaid > 0 then begin
                    if AmountPaid < TotalMonthlyRepayment then begin
                        PenaltyDue := Round((LoanApplicationSetup."Penalty Value" / 100) * (TotalMonthlyRepayment - AmountPaid), 1, '=');
                    end;
                end;
            end;
            If PenaltyDue > 0 Then Begin
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(Rundate), "No.", Rundate, AccountTypeEnum::Customer, "No.", Text000 + "No.", PenaltyDue, LoanProductType."Penalty Paid Posting Group",
                                               TransactionTypeCodeSetup."Penalty Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
                GlobalManagement.CreateJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name", 'PEN-' + Format(Rundate), "No.", Rundate, AccountTypeEnum::"G/L Account", LoanProductType."Penalty Paid Posting Group", Text000 + "No.", -PenaltyDue, '',
                                               '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', LoanApplication."Member No.");
            end;
        end;
    end;

    procedure PostStandingOrder(var StandingOrder: Record "Standing Order")
    var
        StandingOrderSetup: Record "Standing Order Setup";
        StandingOrderLine: Record "Standing Order Line";
        ChargeAmount: Decimal;
        PenaltyAmount: Decimal;
        AccountBalance: Decimal;
        AmountToDeduct: Decimal;
        SMSText: BigText;
        EmailText: Text;
        RecRef: RecordRef;
    begin
        with StandingOrder do begin
            LoanApplicationSetup.GET;
            SourceCodeSetup.GET;
            StandingOrderSetup.GET;
            TransactionTypeCodeSetup.Get();
            SourceCodeSetup.TestField("Standing Order");
            TransactionTypeCodeSetup.TestField("Penalty Paid");
            StandingOrderSetup.TestField("Standing Order Template Name");
            StandingOrderSetup.TestField("Standing Order Batch Name");

            JournalTemplateName := StandingOrderSetup."Standing Order Template Name";
            JournalBatchName := StandingOrderSetup."Standing Order Batch Name";

            AccountBalance := GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, "Source Account No.");
            CalcFields("Total Line Amount");

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);
            if StandingOrderSetup."Charge Transaction" then begin
                if StandingOrderSetup."Charges Calculation Method" = StandingOrderSetup."Charges Calculation Method"::"Flat Amount" then
                    ChargeAmount := StandingOrderSetup."Charges Value";
                if StandingOrderSetup."Charges Calculation Method" = StandingOrderSetup."Charges Calculation Method"::"%" then
                    ChargeAmount := StandingOrderSetup."Charges Value" / 100 * "Total Line Amount";

            end;

            /*
                        if AccountBalance >= "Total Line Amount" + ChargeAmount then begin
                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY,
                                    AccountTypeEnum::Vendor, "Source Account No.", Description, "Total Line Amount" + ChargeAmount, '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", StandingOrderLine."Document No.", TODAY,
                                                     AccountTypeEnum::"G/L Account", StandingOrderSetup."Charges G/L Account", 'Charges ' + "No.", -ChargeAmount, '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode(StandingOrderLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                            StandingOrderLine.Reset();
                            StandingOrderLine.SetRange("Document No.", "No.");
                            if StandingOrderLine.FindSet() then begin
                                repeat
                                    IF StandingOrderLine."STO Type" = StandingOrderLine."STO Type"::Internal THEN BEGIN
                                        IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", StandingOrderLine."Document No.", TODAY,
                                                          AccountTypeEnum::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode(StandingOrderLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                                        END;
                                        IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", StandingOrderLine."Document No.", TODAY,
                                                          AccountTypeEnum::Customer, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode(StandingOrderLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                                        END;
                                    end;
                                until StandingOrderLine.Next() = 0;
                            end;

                        end else begin
                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", TODAY,
                                   AccountTypeEnum::Vendor, "Source Account No.", Description, AccountBalance, '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                            if StandingOrderSetup."Charge Penalty" then begin
                                if StandingOrderSetup."Penalty Calculation Method" = StandingOrderSetup."Penalty Calculation Method"::"Flat Amount" then
                                    PenaltyAmount := StandingOrderSetup."Penalty Value";
                                if StandingOrderSetup."Penalty Calculation Method" = StandingOrderSetup."Penalty Calculation Method"::"%" then
                                    PenaltyAmount := StandingOrderSetup."Penalty Value" / 100 * "Total Line Amount";
                            end;
                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", StandingOrderLine."Document No.", TODAY,
                                                            AccountTypeEnum::"G/L Account", StandingOrderSetup."Charges G/L Account", 'Penalty ' + "No.", -PenaltyAmount, '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                            StandingOrderLine.Reset();
                            StandingOrderLine.SetRange("Document No.", "No.");
                            if StandingOrderLine.FindSet() then begin
                                repeat
                                    IF StandingOrderLine."STO Type" = StandingOrderLine."STO Type"::Internal THEN BEGIN
                                        IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", StandingOrderLine."Document No.", TODAY,
                                                          AccountTypeEnum::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode(StandingOrderLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                                        END;
                                        IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", StandingOrderLine."Document No.", TODAY,
                                                          AccountTypeEnum::Customer, StandingOrderLine."Account No.", Description, -AccountBalance, '', '', SourceCodeSetup."Standing Order", GlobalManagement.GetBranchCode(StandingOrderLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                                        END;
                                    end;
                                until StandingOrderLine.Next() = 0;
                            end;
                        end;
            */


            CLEARLASTERROR;
            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) THEN BEGIN
                "Next Run Date" := CALCDATE(Frequency, "Next Run Date");
                MODIFY;

                CLEAR(RecRef);
                RecRef.GETTABLE(StandingOrder);
                SendNotification(RecRef);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        end;
    end;

    local procedure CreateSTOEntry(var StandingOrder: Record "Standing Order"; Amount: Decimal)
    var
        StandingOrderEntry: Record "Standing Order Entry";
    begin
        WITH StandingOrder DO BEGIN
            StandingOrderEntry.INIT;
            StandingOrderEntry."Entry No." := StandingOrderEntry."Entry No." + 1;
            StandingOrderEntry."STO No." := "No.";
            StandingOrderEntry."Member No." := "Member No.";
            StandingOrderEntry."Member Name" := "Member Name";
            StandingOrderEntry."Account No." := "Source Account No.";
            StandingOrderEntry."Account Name" := "Source Account Name";
            StandingOrderEntry.Amount := Amount;
            StandingOrderEntry.INSERT;
        END;
    end;




    procedure PostFundTransfer(var FundTransfer: Record "Fund Transfer")
    var
        FundTransferSetup: Record "Fund Transfer Setup";
        RecRef: RecordRef;
        LoanApplication: Record "Loan Application";
        LoanProd: Record "Loan Product Type";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        RemainingAmount: Decimal;
        OriginalPostingGroup: Code[20];
        FundsTransLine: Record "Funds Transfer Line";
        AccountTypes: Record "Account Type";
        PostingGroup: Code[100];
    begin
        WITH FundTransfer DO BEGIN
            FundTransferSetup.GET;
            SourceCodeSetup.GET;
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField("Fund Transfer");
            TransactionTypeCodeSetup.TestField("Principal Paid");
            TransactionTypeCodeSetup.TestField("Interest Paid");
            TransactionTypeCodeSetup.TestField("Ledger Fee Paid");
            TransactionTypeCodeSetup.TestField("Penalty Paid");
            FundTransferSetup.TestField("Fund Transfer Template Name");
            FundTransferSetup.TestField("Fund Transfer Batch Name");

            JournalTemplateName := FundTransferSetup."Fund Transfer Template Name";
            JournalBatchName := FundTransferSetup."Fund Transfer Batch Name";

            GlobalManagement.ClearJournal(FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name");
            CalcFields("Amount to Transfer");
            //--------------------------Source------------------------------------------------------------------------------------------
            if "Source Account Type" = "Source Account Type"::Vendor then begin

                GlobalManagement.CreateJournal(FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name", "No.", "No.", "Posting Date",
                              AccountTypeEnum::Vendor, "Source Account No.", Remarks, "Amount to Transfer", '', "Source Transaction Type", SourceCodeSetup."Fund Transfer", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', FundTransfer."Member No.");
            end;
            if "Source Account Type" = "Source Account Type"::Customer then begin
                //if "Source Account Balance" < 0 then begin
                /*GlobalManagement.DeductLoanOverPayment(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", "No.", "Posting Date", "Source Account No.", "Amount to Transfer" - 1, GlobalManagement.GetBranchCode("Member No."));
             end else begin*/
                PostingGroup := '';
                LoanApplication.Reset();
                LoanApplication.SetRange("No.", "Source Account No.");
                if LoanApplication.FindFirst() then begin
                    LoanApplication.CalcFields("Outstanding Balance");
                    LoanProd.Get(LoanApplication."Loan Product Type");

                    If "Source Transaction Type" = TransactionTypeCodeSetup."Interest Paid" then
                        PostingGroup := LoanProd."Interest Due Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Interest Due" then
                        PostingGroup := LoanProd."Interest Paid Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Ledger Fee Paid" then
                        PostingGroup := LoanProd."Ledger Fee Due Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Ledger Fee Due" then
                        PostingGroup := LoanProd."Ledger Fee Paid Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Penalty Paid" then
                        PostingGroup := LoanProd."Penalty Due Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Penalty Due" then
                        PostingGroup := LoanProd."Penalty Paid Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Principal Paid" then
                        PostingGroup := LoanProd."Loan Posting Group";
                    If "Source Transaction Type" = TransactionTypeCodeSetup."Loan Prepayment" then
                        PostingGroup := LoanProd."Loan Prepayment Posting Group";
                end;
                /*if LoanApplication."Outstanding Balance" >= 0 then
                    Error('You can not overdraw funds from this account');*/
                GlobalManagement.CreateJournal(FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name", "No.", "No.", "Posting Date",
                 AccountTypeEnum::Customer, "Source Account No.", Remarks, "Amount to Transfer", PostingGroup, "Source Transaction Type", SourceCodeSetup."Fund Transfer", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', FundTransfer."Member No.");

            end;
            //-----------------------Destination--------------------------------------------------------------------------
            FundsTransLine.Reset();
            FundsTransLine.SetRange(FundsTransLine."Document No.", "No.");
            if FundsTransLine.FindSet() then begin
                repeat
                    IF FundsTransLine."Account Type" = FundsTransLine."Account Type"::Vendor THEN BEGIN
                        GlobalManagement.CreateJournal(FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name", "No.", "No.", "Posting Date",
                                      AccountTypeEnum::Vendor, FundsTransLine."Account No.", Remarks, -FundsTransLine."Line Amount", '', FundsTransLine."Transaction Type", SourceCodeSetup."Fund Transfer", GlobalManagement.GetBranchCode(FundsTransLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', FundTransfer."Member No.");
                    end;
                    /*if FundsTransLine."Account Type" = FundsTransLine."Account Type"::Customer then begin
                        GlobalManagement.DeductLoanArrearsFundstransfer(TransactionTypeCodeSetup, SourceCodeSetup, FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name", "No.", "No.", "Posting Date", FundsTransLine."Account No.", FundsTransLine."Line Amount", GlobalManagement.GetBranchCode(FundsTransLine."Member No."));
                    end;*/
                    IF FundsTransLine."Account Type" = FundsTransLine."Account Type"::Customer THEN BEGIN
                        PostingGroup := '';
                        LoanApplication.Reset();
                        LoanApplication.SetRange("No.", FundsTransLine."Account No.");
                        if LoanApplication.FindFirst() then begin
                            LoanProd.Get(LoanApplication."Loan Product Type");
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Interest Paid" then
                                PostingGroup := LoanProd."Interest Due Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Interest Due" then
                                PostingGroup := LoanProd."Interest Paid Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Ledger Fee Paid" then
                                PostingGroup := LoanProd."Ledger Fee Due Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Ledger Fee Due" then
                                PostingGroup := LoanProd."Ledger Fee Paid Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Penalty Paid" then
                                PostingGroup := LoanProd."Penalty Due Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Penalty Due" then
                                PostingGroup := LoanProd."Penalty Paid Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Principal Paid" then
                                PostingGroup := LoanProd."Loan Posting Group";
                            If FundsTransLine."Transaction Type" = TransactionTypeCodeSetup."Loan Prepayment" then
                                PostingGroup := LoanProd."Loan Prepayment Posting Group";
                        end;
                        GlobalManagement.CreateJournal(FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name", "No.", "No.", "Posting Date",
                        AccountTypeEnum::Customer, FundsTransLine."Account No.", Remarks, -FundsTransLine."Line Amount", PostingGroup, FundsTransLine."Transaction Type", SourceCodeSetup."Fund Transfer", GlobalManagement.GetBranchCode(FundsTransLine."Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', FundTransfer."Member No.");
                    end;
                until FundsTransLine.Next = 0;
            end;

            //  CLEARLASTERROR;
            IF GlobalManagement.PostJournal(FundTransferSetup."Fund Transfer Template Name", FundTransferSetup."Fund Transfer Batch Name") THEN BEGIN
                Posted := TRUE;
                MODIFY;

                CLEAR(RecRef);
                RecRef.GETTABLE(FundTransfer);
                // SendNotification(RecRef);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        end;
    end;

    procedure SendNotification(var RecRef: RecordRef)
    var
        LoanApplication: Record "Loan Application";
        LoanApplicationSetup: Record "Loan Application Setup";
        FundTransfer: Record "Fund Transfer";
        FundTransferSetup: Record "Fund Transfer Setup";
        StandingOrder: Record "Standing Order";
        StandingOrderLine: Record "Standing Order Line";
        StandingOrderSetup: Record "Standing Order Setup";
        PayoutHeader: Record "Payout Header";
        PayoutLine: Record "Payout Line";
        PayoutSetup: Record "Payout Setup";
        DividendHeader: Record "Dividend Header";
        DividendLine: Record "Dividend Line";
        DividendSetup: Record "Dividend Setup";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanRescheduling: Record "Loan Rescheduling";
        LoanRestructuring: Record "Loan Restructuring";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        GuarantorSubstitutionSetup: Record "Guarantor Substitution Setup";
        SMSText: BigText;
        SMSText2: BigText;
        EmailText: BigText;
        EmailText2: BigText;
        MemberName: array[5] of Text;
        Member: Record "Member";
        Member2: Record "Member";
        FldRef: FieldRef;
        LoanGuarantor: Record "Loan Guarantor";
        GuarantorAllocation: Record "Guarantor Allocation";
        LoanNotificationSetup: Record "Loan Notification Setup";
        LoanRestructuringSetup: Record "Loan Restructuring Setup";
    begin
        SMTPSetup.GET;
        SourceCodeSetup.Get();
        CASE RecRef.NUMBER OF
            DATABASE::"Loan Application":
                BEGIN
                    RecRef.SETTABLE(LoanApplication);
                    //FldRef := RecRef.FIELD(1);
                    LoanApplicationSetup.GET;
                    SourceCodeSetup.TestField(Loan);
                    IF LoanApplicationSetup."Notify Member" THEN BEGIN
                        Member.GET(LoanApplication."Member No.");
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        if LoanApplication.Status = LoanApplication.Status::New then begin
                            IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Email) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template (Pending Appr.)", LoanApplication."No.", LoanApplication.Description, LoanApplication."Requested Amount"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::SMS) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Pending Appr.)", LoanApplication."No.", LoanApplication.Description, LoanApplication."Requested Amount"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                            END;
                        end;

                        if (LoanApplication.Status = LoanApplication.Status::Approved) and (LoanApplication.Posted = false) then begin
                            IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Email) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template (Approved)", LoanApplication."No.", LoanApplication.Description, LoanApplication."Approved Amount"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::SMS) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Approved)", LoanApplication."No.", LoanApplication.Description, LoanApplication."Approved Amount"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                            END;
                        end;
                        if (LoanApplication.Status = LoanApplication.Status::Approved) and (LoanApplication.Posted = true) then begin
                            LoanRepaymentSchedule.Reset();
                            LoanRepaymentSchedule.SetRange("Loan No.", LoanApplication."No.");
                            if LoanRepaymentSchedule.FindFirst() then begin
                                IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Email) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                    EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Disbursed)", LoanApplication."Approved Amount", Round(LoanRepaymentSchedule."Total Installment", 1, '='), LoanApplication."Repayment Period", CalcDate('1M', LoanApplication."Disbursal Date")));
                                    //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                    //SMTPMail.Send;
                                END;
                                IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::SMS) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                    SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Disbursed)", LoanApplication."Approved Amount", Round(LoanRepaymentSchedule."Total Installment", 1, '='), LoanApplication."Repayment Period", CalcDate('1M', LoanApplication."Disbursal Date")));
                                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                                END;
                            end;
                        end;
                        if LoanApplication.Status = LoanApplication.Status::Rejected then begin
                            IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Email) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template (Rejected)", LoanApplication."No.", LoanApplication.Description, LoanApplication."Requested Amount"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::SMS) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Rejected)", LoanApplication."No.", LoanApplication.Description, LoanApplication."Requested Amount"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                            END;
                        end;
                    END;
                    IF LoanApplicationSetup."Notify Guarantor" THEN BEGIN
                        LoanGuarantor.Reset();
                        LoanGuarantor.SetRange("Loan No.", LoanApplication."No.");
                        if LoanGuarantor.FindSet() then begin
                            repeat
                                LoanGuarantor.TestField("Member No.");
                                LoanGuarantor.TestField("Account No.");
                                LoanGuarantor.TestField("Amount To Guarantee");

                                Clear(SMSText);
                                Clear(EmailText);
                                Member.Reset();
                                Member.Get(LoanGuarantor."Member No.");

                                if LoanApplication.Status = LoanApplication.Status::New then begin
                                    IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Email) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                        EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template (Guarantor)-New", LoanGuarantor."Amount To Guarantee", LoanApplication."Member No.", LoanApplication."Member Name"));
                                        //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                        //SMTPMail.Send;
                                    END;
                                    IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::SMS) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                        SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Guarantor)-New", LoanGuarantor."Amount To Guarantee", LoanApplication."Member No.", LoanApplication."Member Name"));
                                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                                    END;
                                end;
                                if LoanApplication.Status = LoanApplication.Status::Approved then begin
                                    IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Email) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                        EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template (Guarantor)-Approved", LoanGuarantor."Amount To Guarantee", LoanApplication."Member No.", LoanApplication."Member Name"));
                                        //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                        //SMTPMail.Send;
                                    END;
                                    IF ((LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::SMS) OR (LoanApplicationSetup."Notification Channel" = LoanApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                        SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Guarantor)-Approved", LoanGuarantor."Amount To Guarantee", LoanApplication."Member No.", LoanApplication."Member Name"));
                                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                                    END;
                                end;
                            until LoanGuarantor.Next() = 0;
                        end;
                    end;
                END;
            Database::"Loan Rescheduling":
                begin
                    RecRef.SETTABLE(LoanRescheduling);
                    LoanReschedulingSetup.GET;
                    SourceCodeSetup.Get();
                    SourceCodeSetup.TestField("Loan Rescheduling");
                    IF LoanReschedulingSetup."Notify Member" THEN BEGIN
                        Member.GET(LoanRescheduling."Member No.");
                        MemberName[1] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        if LoanRescheduling.Status = LoanRescheduling.Status::"Pending Approval" then begin
                            IF ((LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Email) OR (LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanReschedulingSetup."Email Template (Pending Appr.)", LoanRescheduling."Loan No.", LoanRescheduling.Description));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::SMS) OR (LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanReschedulingSetup."SMS Template (Pending Appr.)", LoanRescheduling."Loan No.", LoanRescheduling.Description));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Loan Rescheduling");
                            END;
                        end;
                        if LoanRescheduling.Status = LoanRescheduling.Status::Approved then begin
                            IF ((LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Email) OR (LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanReschedulingSetup."Email Template (Approved)", MemberName[1], LoanRescheduling."Outstanding Loan Balance"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::SMS) OR (LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanReschedulingSetup."SMS Template (Approved)", MemberName[1], LoanRescheduling."Outstanding Loan Balance"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Loan Rescheduling");
                            END;
                        end;
                        if LoanRescheduling.Status = LoanRescheduling.Status::Rejected then begin
                            IF ((LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Email) OR (LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanReschedulingSetup."Email Template (Rejected)", MemberName[1], LoanRescheduling."Outstanding Loan Balance"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::SMS) OR (LoanReschedulingSetup."Notification Channel" = LoanReschedulingSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanReschedulingSetup."SMS Template (Rejected)", MemberName[1], LoanRescheduling."Outstanding Loan Balance"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Loan Rescheduling");
                            END;
                        end;
                    END;
                end;
            Database::"Loan Restructuring":
                begin
                    RecRef.SETTABLE(LoanRestructuring);
                    LoanRestructuringSetup.Get;
                    SourceCodeSetup.Get();
                    SourceCodeSetup.TestField("Loan Restructuring");
                    IF LoanRestructuringSetup."Notify Member" THEN BEGIN
                        Member.GET(LoanRestructuring."Member No.");
                        MemberName[1] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        if LoanRestructuring.Status = LoanRestructuring.Status::"Pending Approval" then begin
                            IF ((LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Email) OR (LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanRestructuringSetup."Email Template (Pending Appr.)", LoanRestructuring."Loan No.", LoanRestructuring.Description));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::SMS) OR (LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanRestructuringSetup."SMS Template (Pending Appr.)", LoanRestructuring."Loan No.", LoanRestructuring.Description));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Loan Restructuring");
                            END;
                        end;
                        if LoanRestructuring.Status = LoanRestructuring.Status::Approved then begin
                            IF ((LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Email) OR (LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanRestructuringSetup."Email Template (Approved)", MemberName[1], LoanRestructuring."Outstanding Loan Balance"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::SMS) OR (LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanRestructuringSetup."SMS Template (Approved)", MemberName[1], LoanRestructuring."Outstanding Loan Balance"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Loan Restructuring");
                            END;
                        end;
                        if LoanRestructuring.Status = LoanRestructuring.Status::Rejected then begin
                            IF ((LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Email) OR (LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(LoanRestructuringSetup."Email Template (Rejected)", MemberName[1], LoanRestructuring."Outstanding Loan Balance"));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::SMS) OR (LoanRestructuringSetup."Notification Channel" = LoanRestructuringSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(LoanRestructuringSetup."SMS Template (Rejected)", MemberName[1], LoanRestructuring."Outstanding Loan Balance"));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Loan Restructuring");
                            END;
                        end;
                    END;
                end;
            DATABASE::"Fund Transfer":
                BEGIN
                    RecRef.SETTABLE(FundTransfer);
                    Member.GET(FundTransfer."Member No.");
                    Member2.GET(FundTransfer."Destination Member No.");
                    FundTransferSetup.GET;
                    SourceCodeSetup.TestField("Fund Transfer");
                    IF FundTransferSetup."Notify Source Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::Email) OR (FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Source Email Template", FundTransfer."Amount to Transfer", FundTransfer."Source Account No.", FundTransfer."Source Account Name", FundTransfer."Destination Member No.", FundTransfer."Destination Member Name"));
                            ////SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::SMS) OR (FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Source SMS Template", FundTransfer."Amount to Transfer", FundTransfer."Source Account No.", FundTransfer."Source Account Name", FundTransfer."Destination Member No.", FundTransfer."Destination Member Name"));
                            GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Fund Transfer");
                        END;
                    END;
                    IF FundTransferSetup."Notify Destination Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::Email) OR (FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Destination Email Template", FundTransfer."Amount to Transfer", FundTransfer."Destination Account No.", FundTransfer."Destination Account Name", FundTransfer."Member No.", FundTransfer."Member Name"));
                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member2."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::SMS) OR (FundTransferSetup."Notification Channel" = FundTransferSetup."Notification Channel"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Destination SMS Template", FundTransfer."Amount to Transfer", FundTransfer."Destination Account No.", FundTransfer."Destination Account Name", FundTransfer."Member No.", FundTransfer."Member Name"));
                            GlobalManagement.CreateSMSEntry(Member2."Phone No.", SMSText, SourceCodeSetup."Fund Transfer");
                        END;
                    END;
                END;
            DATABASE::"Guarantor Substitution Header":
                BEGIN
                    RecRef.SETTABLE(GuarantorSubstitutionHeader);
                    FldRef := RecRef.FIELD(1);
                    GuarantorSubstitutionSetup.GET;
                    SourceCodeSetup.Get();
                    SourceCodeSetup.TestField("Guarantor Substitution");
                    IF GuarantorSubstitutionSetup."Notify Member" THEN BEGIN
                        Member.GET(GuarantorSubstitutionHeader."Member No.");
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        if GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::"Pending Approval" then begin
                            IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Email) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."Email Template (Pending Appr.)", GuarantorSubstitutionHeader."Loan No.", GuarantorSubstitutionHeader.Description));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::SMS) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."SMS Template (Pending Appr.)", GuarantorSubstitutionHeader."Loan No.", GuarantorSubstitutionHeader.Description));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Guarantor Substitution");
                            END;
                        end;
                        if GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::Approved then begin
                            IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Email) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."Email Template (Approved)", GuarantorSubstitutionHeader."Loan No.", GuarantorSubstitutionHeader.Description));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::SMS) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."SMS Template (Approved)", GuarantorSubstitutionHeader."Loan No.", GuarantorSubstitutionHeader.Description));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Guarantor Substitution");
                            END;
                        end;
                        if GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::Rejected then begin
                            IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Email) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."Email Template (Rejected)", GuarantorSubstitutionHeader."Loan No.", GuarantorSubstitutionHeader.Description));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::SMS) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."SMS Template (Rejected)", GuarantorSubstitutionHeader."Loan No.", GuarantorSubstitutionHeader.Description));
                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Guarantor Substitution");
                            END;
                        end;
                    END;
                    IF GuarantorSubstitutionSetup."Notify Guarantor" THEN BEGIN
                        GuarantorAllocation.Reset();
                        GuarantorAllocation.SetRange("Document No.", GuarantorSubstitutionHeader."No.");
                        if GuarantorAllocation.FindSet() then begin
                            repeat
                                GuarantorAllocation.TestField("Member No.");
                                GuarantorAllocation.TestField("Account No.");
                                GuarantorAllocation.TestField("Amount To Guarantee");

                                Clear(SMSText);
                                Clear(EmailText);
                                Member.Reset();
                                Member.Get(GuarantorAllocation."Member No.");

                                if GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::New then begin
                                    IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Email) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                        EmailText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."Email Template (Guarantor)-New", GuarantorAllocation."Amount To Guarantee", GuarantorSubstitutionHeader."Member No.", GuarantorSubstitutionHeader."Member Name"));
                                        //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                        //SMTPMail.Send;
                                    END;
                                    IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::SMS) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                        SMSText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."SMS Template (Guarantor)-New", GuarantorAllocation."Amount To Guarantee", GuarantorSubstitutionHeader."Member No.", GuarantorSubstitutionHeader."Member Name"));
                                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Guarantor Substitution");
                                    END;
                                end;
                                if GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::Approved then begin
                                    IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Email) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                        EmailText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."Email Template (Guarantor)-Approved", GuarantorAllocation."Amount To Guarantee", GuarantorSubstitutionHeader."Member No.", GuarantorSubstitutionHeader."Member Name"));
                                        //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                        //SMTPMail.Send;
                                    END;
                                    IF ((GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::SMS) OR (GuarantorSubstitutionSetup."Notification Channel" = GuarantorSubstitutionSetup."Notification Channel"::Both)) THEN BEGIN
                                        SMSText.ADDTEXT(STRSUBSTNO(GuarantorSubstitutionSetup."SMS Template (Guarantor)-Approved", GuarantorAllocation."Amount To Guarantee", GuarantorSubstitutionHeader."Member No.", GuarantorSubstitutionHeader."Member Name"));
                                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Guarantor Substitution");
                                    END;
                                end;
                            until GuarantorAllocation.Next() = 0;
                        end;
                    end;
                END;
            DATABASE::"Standing Order":
                BEGIN
                    RecRef.SETTABLE(StandingOrder);
                    FldRef := RecRef.FIELD(1);
                    SourceCodeSetup.Get();
                    SourceCodeSetup.TestField("Standing Order");
                    StandingOrderSetup.GET;
                    IF StandingOrderSetup."Notify Source Member" THEN BEGIN
                        Member.GET(StandingOrder."Member No.");
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::Email) OR (StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Source Email Template", FundTransfer."Source Account No.", StandingOrder."Source Account Name", StandingOrder."Total Line Amount"));
                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::SMS) OR (StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Source SMS Template", StandingOrder."Source Account No.", StandingOrder."Source Account Name", StandingOrder."Total Line Amount"));
                            GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."STANDING Order");
                        END;
                    END;
                    IF StandingOrderSetup."Notify Destination Member" THEN BEGIN
                        StandingOrderLine.RESET;
                        StandingOrderLine.SETRANGE("Document No.", FORMAT(FldRef.VALUE));
                        IF StandingOrderLine.FINDSET THEN BEGIN
                            REPEAT
                                IF StandingOrderLine."STO Type" = StandingOrderLine."STO Type"::Internal THEN BEGIN
                                    CLEAR(SMSText);
                                    CLEAR(EmailText);
                                    Member2.GET(StandingOrderLine."Member No.");
                                    /*   IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN
                                          CreditAmount := GetPostedAmount(0, StandingOrder."No.", StandingOrderLine."Account No.");
                                      IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN
                                          CreditAmount := GetPostedAmount(1, StandingOrder."No.", StandingOrderLine."Account No."); */

                                    IF ((StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::Email) OR (StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::Both)) THEN BEGIN
                                        EmailText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Destination Email Template", StandingOrderLine."Account No.", StandingOrderLine."Account Name", StandingOrderLine."Line Amount"));
                                        //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                        //SMTPMail.Send;
                                    END;
                                    IF ((StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::SMS) OR (StandingOrderSetup."Notification Channel" = StandingOrderSetup."Notification Channel"::Both)) THEN BEGIN
                                        SMSText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Destination SMS Template", StandingOrderLine."Account No.", StandingOrderLine."Account Name", StandingOrderLine."Line Amount"));
                                        GlobalManagement.CreateSMSEntry(Member2."Phone No.", SMSText, SourceCodeSetup."STANDING Order");
                                    END;
                                END;

                            UNTIL StandingOrderLine.NEXT = 0;
                        END;
                    END;
                END;
            DATABASE::"Payout Header":
                BEGIN
                    RecRef.SETTABLE(PayoutHeader);
                    FldRef := RecRef.FIELD(1);
                    PayoutSetup.GET;
                    SourceCodeSetup.TestField(Payout);
                    IF PayoutSetup."Notify Member" THEN BEGIN
                        PayoutLine.RESET;
                        PayoutLine.SETRANGE("Document No.", PayoutHeader."No.");
                        IF PayoutLine.FINDSET THEN BEGIN
                            REPEAT
                                CLEAR(SMSText);
                                CLEAR(EmailText);
                                Member.GET(PayoutLine."Member No.");
                                // CreditAmount := GetPostedAmount(0, PayoutHeader."No.", PayoutLine."Account No.");

                                IF ((PayoutSetup."Notification Channel" = PayoutSetup."Notification Channel"::Email) OR (PayoutSetup."Notification Channel" = PayoutSetup."Notification Channel"::Both)) THEN BEGIN
                                    EmailText.ADDTEXT(STRSUBSTNO(PayoutSetup."Email Template", PayoutLine."Account No.", PayoutLine."Account Name", PayoutLine."Net Amount"));
                                    //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                    //SMTPMail.Send;
                                END;
                                IF ((PayoutSetup."Notification Channel" = PayoutSetup."Notification Channel"::SMS) OR (PayoutSetup."Notification Channel" = PayoutSetup."Notification Channel"::Both)) THEN BEGIN
                                    SMSText.ADDTEXT(STRSUBSTNO(PayoutSetup."SMS Template", PayoutLine."Account No.", PayoutLine."Account Name", PayoutLine."Net Amount"));
                                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Payout);
                                END;
                            UNTIL PayoutLine.NEXT = 0;
                        END;
                    END;
                END;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SETTABLE(DividendHeader);
                    FldRef := RecRef.FIELD(1);
                    DividendSetup.GET;
                    SourceCodeSetup.Get();
                    SourceCodeSetup.TestField(Dividend);

                    IF DividendSetup."Notify Member" THEN BEGIN
                        DividendSetup.TestField("Dividend Email Template");
                        DividendSetup.TestField("Dividend SMS Template");
                        DividendSetup.TestField("Interest Email Template");
                        DividendSetup.TestField("Interest SMS Template");

                        DividendLine.RESET;
                        DividendLine.SETRANGE("Document No.", DividendHeader."No.");
                        IF DividendLine.FINDSET THEN BEGIN
                            REPEAT
                                CLEAR(SMSText);
                                CLEAR(EmailText);
                                CLEAR(SMSText2);
                                CLEAR(EmailText2);
                                Member.GET(DividendLine."Member No.");
                                IF ((DividendSetup."Notification Channel" = DividendSetup."Notification Channel"::Email) OR (DividendSetup."Notification Channel" = DividendSetup."Notification Channel"::Both)) THEN BEGIN
                                    EmailText.ADDTEXT(STRSUBSTNO(DividendSetup."Dividend Email Template", DividendLine."Gross Earning Amount", DividendLine."Net Earning Amount"));
                                    EmailText2.ADDTEXT(STRSUBSTNO(DividendSetup."Interest Email Template", DividendLine."Gross Earning Amount", DividendLine."Net Earning Amount"));

                                    //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                    //SMTPMail.Send;
                                END;
                                IF ((DividendSetup."Notification Channel" = DividendSetup."Notification Channel"::SMS) OR (DividendSetup."Notification Channel" = DividendSetup."Notification Channel"::Both)) THEN BEGIN
                                    SMSText.ADDTEXT(STRSUBSTNO(DividendSetup."Dividend SMS Template", DividendLine."Gross Earning Amount", DividendLine."Net Earning Amount"));
                                    SMSText2.ADDTEXT(STRSUBSTNO(DividendSetup."Interest SMS Template", DividendLine."Gross Earning Amount", DividendLine."Net Earning Amount"));

                                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Dividend);
                                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText2, SourceCodeSetup.Dividend);
                                END;
                            UNTIL DividendLine.NEXT = 0;
                        END;
                    END;
                end;
        END;
    end;

    procedure SendLoanNotification(LoanApplication: Record "Loan Application")
    var
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanRepayment: Record "Loan Repayment Schedule";
        SMSText: BigText;
        SMSText2: BigText;
        EmailText: BigText;
        EmailText2: BigText;
        Member: Record "Member";
        Member2: Record "Member";
        FldRef: FieldRef;
        LoanNotificationSetup: Record "Loan Notification Setup";
        MemberName: array[5] of Text;
        GlobalM: Codeunit "Global Management";
        LoanArrears: array[5] of Decimal;
        LoanOverPay: array[5] of Decimal;
        TotalArrears: Decimal;
        LoanGuarantor: Record "Loan Guarantor";
        LoanDefaulterSetup: Record "Loan Defaulter Setup";
        NoOfMonthsInArrears: Decimal;
        NoOfDaysInArrears: Decimal;
        LoanProd: Record "Loan Product Type";
    begin
        SMTPSetup.GET;
        SourceCodeSetup.Get();
        //FldRef := RecRef.FIELD(1);
        MemberName[2] := '';
        MemberName[3] := '';
        LoanArrears[1] := 0;
        LoanArrears[2] := 0;
        LoanArrears[3] := 0;
        LoanArrears[4] := 0;
        LoanOverPay[1] := 0;
        LoanOverPay[2] := 0;
        TotalArrears := 0;
        LoanApplicationSetup.GET;
        LoanNotificationSetup.Get;
        LoanDefaulterSetup.Get;
        LoanProd.Get(LoanApplication."Loan Product Type");
        SourceCodeSetup.TestField(Loan);
        Member.GET(LoanApplication."Member No.");
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        CLEAR(SMSText);
        CLEAR(EmailText);
        LoanApplication.CalcFields("Outstanding Balance");
        NoOfMonthsInArrears := 0;

        //**********************************************Loan Repayment Reminders*************************************************************************************
        LoanRepayment.Reset();
        LoanRepayment.SetRange("Loan No.", LoanApplication."No.");
        LoanRepayment.SetFilter("Repayment Date", '>=%1', Today);
        if LoanRepayment.FindFirst() then begin
            if LoanRepayment."Repayment Date" - Today = 7 then begin
                CLEAR(SMSText);
                CLEAR(EmailText);
                GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, LoanRepayment."Repayment Date", LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
                TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
                If TotalArrears > 0 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        if LoanApplication."Loan Product Type" = 'MB' then
                            SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."First Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", Round(LoanApplication."Outstanding Balance", 1, '='), LoanRepayment."Repayment Date", LoanApplication."Member No." + LoanProd.Code))
                        else
                            SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."First Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", Round(LoanRepayment."Total Installment", 1, '='), LoanRepayment."Repayment Date", LoanApplication."Member No." + LoanProd.Code));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;
            end;
            /*
            if LoanRepayment."Repayment Date" - Today = 2 then begin
                CLEAR(SMSText);
                CLEAR(EmailText);
                GlobalM.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, LoanRepayment."Repayment Date", LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2]);
                TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
                If TotalArrears > 0 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Second Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", LoanRepayment."Repayment Date", Round(LoanRepayment."Total Installment", 1, '=')));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;
            end;
            if LoanRepayment."Repayment Date" - Today = 1 then begin
                CLEAR(SMSText);
                CLEAR(EmailText);
                GlobalM.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, LoanRepayment."Repayment Date", LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2]);
                TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
                If TotalArrears > 0 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Third Notification Template", MemberName[2], LoanApplication.Description, Round(LoanApplication."Outstanding Balance", 1, '='), LoanRepayment."Repayment Date"));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;
            end;
            */
            if LoanRepayment."Repayment Date" - Today = 0 then begin
                CLEAR(SMSText);
                CLEAR(EmailText);
                GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, Today, LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
                TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
                If TotalArrears > 0 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Fourth Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", Round(LoanRepayment."Total Installment", 1, '='), TotalArrears, LoanApplication."Member No." + LoanProd.Code));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;
            end;
        end;
        //********************************************** End Loan Repayment Reminders*************************************************************************************

        //**********************************************Loan Defaulter Reminders*****************************************************************************************
        //****************************************************First Notice*****************************************************************************************      
        LoanRepayment.Reset();
        LoanRepayment.SetRange("Loan No.", LoanApplication."No.");
        LoanRepayment.SetFilter("Repayment Date", '%1', CalcDate('-1D', Today));
        if LoanRepayment.FindFirst() then begin
            GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, Today, LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
            TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
            CLEAR(SMSText);
            CLEAR(EmailText);
            If TotalArrears > 0 then begin
                NoOfMonthsInArrears := TotalArrears / (LoanRepayment."Principal Installment" + LoanRepayment."Interest Installment");
                NoOfDaysInArrears := Round(NoOfMonthsInArrears * 30, 1, '=');
                IF ((LoanDefaulterSetup."Notification Channel" = LoanDefaulterSetup."Notification Channel"::SMS) OR (LoanDefaulterSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                    SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."First Default Template", MemberName[2], LoanApplication.Description, LoanApplication."Outstanding Balance", NoOfDaysInArrears, TotalArrears, LoanApplication."Member No." + LoanProd.Code));
                    //GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                END;
                //InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
            end;
        end;
        //****************************************************End First Notice*****************************************************************************************
        LoanRepayment.Reset();
        LoanRepayment.SetRange("Loan No.", LoanApplication."No.");
        LoanRepayment.SetRange("Repayment Date", Today);
        if LoanRepayment.FindFirst() then begin
            GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, Today, LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
            TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
            If TotalArrears > 0 then begin
                CLEAR(SMSText);
                CLEAR(EmailText);
                NoOfMonthsInArrears := TotalArrears / (LoanRepayment."Total Installment");
                NoOfDaysInArrears := Round(NoOfMonthsInArrears * 30, 1, '=');
                //****************************************************Second Notice*****************************************************************************************
                /*IF NoOfDaysInArrears = 30 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Second Default Template", MemberName[2], LoanApplication.Description, LoanApplication."No."+ LoanProd.Code, LoanApplication."Outstanding Balance", NoOfDaysInArrears, TotalArrears));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;
                //****************************************************Third Notice*****************************************************************************************
                IF NoOfDaysInArrears = 60 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Third Default Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", LoanApplication."Outstanding Balance", NoOfDaysInArrears, TotalArrears));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;
                //****************************************************Fourth Notice*****************************************************************************************
                IF NoOfDaysInArrears = 90 then begin
                    IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Fourth Default Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", LoanApplication."Outstanding Balance", NoOfDaysInArrears, TotalArrears));
                        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                    END;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, LoanRepayment."Repayment Date");
                end;*/
            end;
        end;
        //**********************************************End Loan Defaulter Reminders*************************************************************************************
    END;

    procedure SendLoanReminderNotification(LoanApplication: Record "Loan Application")
    var
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanRepayment: Record "Loan Repayment Schedule";
        SMSText: BigText;
        SMSText2: BigText;
        EmailText: BigText;
        EmailText2: BigText;
        Member: Record "Member";
        Member2: Record "Member";
        FldRef: FieldRef;
        LoanNotificationSetup: Record "Loan Notification Setup";
        MemberName: array[5] of Text;
        GlobalM: Codeunit "Global Management";
        LoanArrears: array[5] of Decimal;
        LoanOverPay: array[5] of Decimal;
        TotalArrears: Decimal;
        LoanGuarantor: Record "Loan Guarantor";
        LoanDefaulterSetup: Record "Loan Defaulter Setup";
        NoOfMonthsInArrears: Decimal;
        NoOfDaysInArrears: Decimal;
        PostingDay: Integer;
        PostingMonth: Integer;
        PostingYear: Integer;
        DateToday: Integer;
        MonthToday: Integer;
        YearToday: Integer;
        DueDate: Date;
        LoanProd: Record "Loan Product Type";

    begin
        SMTPSetup.GET;
        SourceCodeSetup.Get();
        //FldRef := RecRef.FIELD(1);
        MemberName[2] := '';
        MemberName[3] := '';
        LoanArrears[1] := 0;
        LoanArrears[2] := 0;
        LoanArrears[3] := 0;
        LoanArrears[4] := 0;
        LoanOverPay[1] := 0;
        LoanOverPay[2] := 0;
        TotalArrears := 0;
        PostingDay := 0;
        PostingMonth := 0;
        PostingYear := 0;
        DateToday := 0;
        MonthToday := 0;
        YearToday := 0;
        LoanApplicationSetup.GET;
        LoanNotificationSetup.Get;
        LoanDefaulterSetup.Get;
        LoanProd.Get(LoanApplication."Loan Product Type");
        SourceCodeSetup.TestField(Loan);
        Member.GET(LoanApplication."Member No.");
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        CLEAR(SMSText);
        CLEAR(EmailText);
        LoanApplication.CalcFields("Outstanding Balance");
        NoOfMonthsInArrears := 0;

        //**********************************************Loan Repayment Reminders*************************************************************************************
        DateToday := DATE2DMY(Today, 1);
        MonthToday := DATE2DMY(Today, 2);
        YearToday := DATE2DMY(Today, 3);
        If DateToday = 27 then begin
            DueDate := CalcDate('4D', CalcDate('-CM', CalcDate('5D', Today)));
            if LoanApplication."Disbursal Date" <> 0D then begin
                PostingDay := Date2DMY(LoanApplication."Disbursal Date", 1);
                PostingMonth := Date2DMY(LoanApplication."Disbursal Date", 2);
                PostingYear := Date2DMY(LoanApplication."Disbursal Date", 3);

                LoanRepayment.Reset();
                LoanRepayment.SetRange("Loan No.", LoanApplication."No.");
                LoanRepayment.SetRange("Repayment Date", CalcDate('CM', Today));
                if LoanRepayment.FindFirst() then begin
                    CLEAR(SMSText);
                    CLEAR(EmailText);
                    GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, Today, LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
                    TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
                    if TotalArrears = 0 then begin
                        IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."First Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", LoanRepayment."Repayment Date", Round(LoanRepayment."Total Installment", 1, '='), LoanApplication."Member No." + LoanProd."Code"));
                            GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                        END;
                    end;
                    InsertLoanNotificationEntry(LoanApplication, SMSText, DueDate);
                end;

            end;
        end;
        If DateToday = 15 then begin
            CLEAR(SMSText);
            CLEAR(EmailText);
            GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, Today, LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
            TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
            if TotalArrears > 0 then begin
                IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                    SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."Second Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", Round(TotalArrears, 1, '='), LoanApplication."Member No." + LoanProd."Code"));
                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                END;
            end;
            InsertLoanNotificationEntry(LoanApplication, SMSText, Today);
        end;
        //********************************************** End Loan Repayment Reminders*************************************************************************************
    END;

    procedure SendExpiredLoanNotification(LoanApplication: Record "Loan Application")
    var
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanRepayment: Record "Loan Repayment Schedule";
        SMSText: BigText;
        SMSText2: BigText;
        EmailText: BigText;
        EmailText2: BigText;
        Member: Record "Member";
        Member2: Record "Member";
        FldRef: FieldRef;
        LoanNotificationSetup: Record "Loan Notification Setup";
        MemberName: array[5] of Text;
        GlobalM: Codeunit "Global Management";
        LoanArrears: array[5] of Decimal;
        LoanOverPay: array[5] of Decimal;
        TotalArrears: Decimal;
        LoanGuarantor: Record "Loan Guarantor";
        LoanDefaulterSetup: Record "Loan Defaulter Setup";
        NoOfMonthsInArrears: Decimal;
        NoOfDaysInArrears: Decimal;
        PostingDay: Integer;
        PostingMonth: Integer;
        PostingYear: Integer;
        DateToday: Integer;
        MonthToday: Integer;
        YearToday: Integer;
        DueDate: Date;
    begin
        SMTPSetup.GET;
        SourceCodeSetup.Get();
        //FldRef := RecRef.FIELD(1);
        MemberName[2] := '';
        MemberName[3] := '';
        LoanArrears[1] := 0;
        LoanArrears[2] := 0;
        LoanArrears[3] := 0;
        LoanArrears[4] := 0;
        LoanOverPay[1] := 0;
        LoanOverPay[2] := 0;
        TotalArrears := 0;
        PostingDay := 0;
        PostingMonth := 0;
        PostingYear := 0;
        DateToday := 0;
        MonthToday := 0;
        YearToday := 0;
        LoanApplicationSetup.GET;
        LoanNotificationSetup.Get;
        LoanDefaulterSetup.Get;
        SourceCodeSetup.TestField(Loan);
        Member.GET(LoanApplication."Member No.");
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        CLEAR(SMSText);
        CLEAR(EmailText);
        LoanApplication.CalcFields("Outstanding Balance");
        NoOfMonthsInArrears := 0;

        //**********************************************Expired Loan Repayment Reminders*************************************************************************************
        DateToday := DATE2DMY(Today, 1);
        MonthToday := DATE2DMY(Today, 2);
        YearToday := DATE2DMY(Today, 3);

        If DateToday = 15 then begin
            CLEAR(SMSText);
            CLEAR(EmailText);
            TotalArrears := LoanApplication."Outstanding Balance";
            if TotalArrears > 0 then begin
                IF ((LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::SMS) OR (LoanNotificationSetup."Notification Channel" = LoanNotificationSetup."Notification Channel"::Both)) THEN BEGIN
                    SMSText.ADDTEXT(STRSUBSTNO(LoanNotificationSetup."First Notification Template", MemberName[2], LoanApplication.Description, LoanApplication."No.", LoanRepayment."Repayment Date", Round(LoanRepayment."Total Installment", 1, '=')));
                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                END;
            end;
            InsertLoanNotificationEntry(LoanApplication, SMSText, DueDate);
        end;
        //********************************************** End Expired Loan Repayment Reminders*************************************************************************************
    END;

    procedure SendDormancyNotification(Member: Record Member)
    var
        MembAppSetup: Record "Member Application Setup";
        SMSText: BigText;
        MemberName: array[2] of Text;
    begin
        MembAppSetup.Get();
        MembAppSetup.TestField("SMS Template (Dormancy)");
        CLEAR(SMSText);
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        SMSText.ADDTEXT(STRSUBSTNO(MembAppSetup."SMS Template (Dormancy)", MemberName[2]));
        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Dormancy);
    end;

    procedure SendNonSavingNotification(Member: Record Member)
    var
        MembAppSetup: Record "Member Application Setup";
        SMSText: BigText;
        MemberName: array[2] of Text;
    begin
        MembAppSetup.Get();
        MembAppSetup.TestField("SMS Template (No Savings)");
        CLEAR(SMSText);
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        SMSText.ADDTEXT(STRSUBSTNO(MembAppSetup."SMS Template (No Savings)", MemberName[2]));
        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Dormancy);
    end;

    procedure InsertLoanNotificationEntry(Loan: Record "Loan Application"; SMSText: BigText; DueDate: Date)
    var
        LoanNotificationEntry: Record "Loan Notification Entry";
        EntryNo: Integer;
        Ostream: OutStream;
        LoanProd: Record "Loan Product Type";
    begin
        LoanNotificationEntry.Reset();
        if LoanNotificationEntry.FindLast() then begin
            EntryNo := LoanNotificationEntry."Entry No." + 1;
        end else begin
            EntryNo := 1;
        end;
        LoanNotificationEntry.Init();
        LoanNotificationEntry."Entry No." := EntryNo;
        LoanNotificationEntry."Notification Date" := Today;
        LoanNotificationEntry."Notification Time" := Time;
        LoanNotificationEntry."Member No." := Loan."Member No.";
        LoanNotificationEntry."Member Name" := Loan."Member Name";
        LoanNotificationEntry."Loan No." := Loan."No." + LoanProd."Code";
        LoanNotificationEntry.Description := Loan.Description;
        LoanNotificationEntry."Due Date" := DueDate;
        LoanNotificationEntry."Notification Sent".CREATEOUTSTREAM(Ostream);
        SMSText.WRITE(Ostream);
        LoanNotificationEntry.Insert();
    end;

    procedure SendLoanClearedNotification(LoanApplication: Record "Loan Application")
    var
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanRepayment: Record "Loan Repayment Schedule";
        SMSText: BigText;
        SMSText2: BigText;
        EmailText: BigText;
        EmailText2: BigText;
        Member: Record "Member";
        Member2: Record "Member";
        FldRef: FieldRef;
        LoanNotificationSetup: Record "Loan Notification Setup";
        MemberName: array[5] of Text;
        GlobalM: Codeunit "Global Management";
        LoanArrears: array[5] of Decimal;
        LoanOverPay: array[5] of Decimal;
        TotalArrears: Decimal;
        LoanGuarantor: Record "Loan Guarantor";
        LoanDefaulterSetup: Record "Loan Defaulter Setup";
        NoOfMonthsInArrears: Decimal;
        NoOfDaysInArrears: Decimal;
    begin
        SMTPSetup.GET;
        SourceCodeSetup.Get();
        MemberName[2] := '';
        LoanApplicationSetup.GET;
        LoanNotificationSetup.Get;
        LoanDefaulterSetup.Get;
        SourceCodeSetup.TestField(Loan);
        Member.GET(LoanApplication."Member No.");
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        CLEAR(SMSText);
        CLEAR(EmailText);
        LoanApplication.CalcFields("Outstanding Balance");

        SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."SMS Template (Cleared)", MemberName[2], LoanApplication.Description));
        GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
    end;

    procedure CalculateDaysAndInstallmentsInArrears(LoanNo: Code[20]; AmountInArrears: Decimal; var NoofDaysInArrears: Integer; var NoofInstallmentInArrears: Integer): Integer
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanApplication: Record "Loan Application";
    begin
        LoanApplication.GET(LoanNo);
        LoanApplication.TestField("Disbursal Date");

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        IF LoanRepaymentSchedule.FINDFIRST THEN;

        IF LoanRepaymentSchedule."Total Installment" > 0 THEN
            NoofInstallmentInArrears := ROUND(AmountInArrears / (LoanRepaymentSchedule."Principal Installment" + LoanRepaymentSchedule."Interest Installment"), 1, '=');
        NoofDaysInArrears := NoofInstallmentInArrears * 30;

        /*if GetLastRepaymentDate(LoanNo, Today) <> 0D then
            NoofDaysInArrears := Today - GetLastRepaymentDate(LoanNo, Today)
        else
        */
    end;

    procedure CalculateDaysAndInstallmentsInArrearsDefaulter(LoanNo: Code[20]; AmountInArrears: Decimal; var NoofDaysInArrears: Integer; var NoofInstallmentInArrears: Integer; EndDate: Date): Integer
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanApplication: Record "Loan Application";
    begin
        LoanApplication.GET(LoanNo);
        LoanApplication.TestField("Disbursal Date");

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        IF LoanRepaymentSchedule.FINDFIRST THEN;

        IF LoanRepaymentSchedule."Total Installment" > 0 THEN
            NoofInstallmentInArrears := ROUND(AmountInArrears / (LoanRepaymentSchedule."Principal Installment"), 1, '=');
        NoofDaysInArrears := NoofInstallmentInArrears * 30;
        if EndDate > LoanApplication."Date of Completion" then
            NoofDaysInArrears := NoofDaysInArrears + (EndDate - LoanApplication."Date of Completion");
        /*if GetLastRepaymentDate(LoanNo, Today) <> 0D then
            NoofDaysInArrears := Today - GetLastRepaymentDate(LoanNo, Today)
        else
        */
    end;

    procedure GenerateMemberRemittanceAdvice(Member: Record "Member")
    var
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        LineNo: Integer;
        MemberRemittanceHeader: Record "Member Remittance Header";
        MemberRemittanceLine: Record "Member Remittance Line";
        MemberRemittanceLine2: Record "Member Remittance Line";
        AccountType: Record "Account Type";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentAmount: array[4] of Decimal;
        RemittanceNo: Code[20];
        RemittanceCode: Record "Remittance Code";
        LoanProductType: Record "Loan Product Type";
    begin
        WITH Member DO BEGIN
            RemittanceSetup.GET;
            MemberRemittanceHeader.INIT;
            MemberRemittanceHeader."No." := NoSeriesManagement.GetNextNo(RemittanceSetup."Member Remittance Advice Nos.", TODAY, TRUE);
            MemberRemittanceHeader.VALIDATE("Member No.", "No.");
            MemberRemittanceHeader.INSERT(TRUE);

            Vendor.RESET;
            Vendor.SETRANGE("Member No.", "No.");
            IF Vendor.FINDSET THEN BEGIN
                REPEAT
                    IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                        RemittanceCode.RESET;
                        RemittanceCode.SETRANGE("Account Type", AccountType.Code);
                        RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::Normal);
                        IF RemittanceCode.FINDFIRST THEN;
                        CreateMemberRemittanceLine(MemberRemittanceHeader."No.", 0, AccountType.Code, Vendor."No.", 0, RemittanceCode.Code, AccountType."Minimum Contribution");
                    END;
                UNTIL Vendor.NEXT = 0;
            END;

            Customer.RESET;
            Customer.SETRANGE("Member No.", "No.");
            IF Customer.FINDSET THEN BEGIN
                REPEAT
                    //AccountType.GET(Customer."Account Type");
                    LoanProductType.GET(Customer."Customer Posting Group");
                    GlobalManagement.CalculateInstallmentDue(Customer."No.", TODAY, InstallmentAmount[1], InstallmentAmount[2]);
                    InstallmentAmount[1] := 4000;
                    InstallmentAmount[2] := 550;
                    IF InstallmentAmount[1] > 0 THEN BEGIN
                        RemittanceCode.RESET;
                        RemittanceCode.SETRANGE("Account Type", LoanProductType.Code);
                        RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::"Principal Due");
                        IF RemittanceCode.FINDFIRST THEN;
                        CreateMemberRemittanceLine(MemberRemittanceHeader."No.", 1, LoanProductType.Code, Customer."No.", 1, RemittanceCode.Code, InstallmentAmount[1]);
                    END;
                    IF InstallmentAmount[2] > 0 THEN BEGIN
                        RemittanceCode.RESET;
                        RemittanceCode.SETRANGE("Account Type", LoanProductType.Code);
                        RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::"Interest Due");
                        IF RemittanceCode.FINDFIRST THEN;
                        CreateMemberRemittanceLine(MemberRemittanceHeader."No.", 1, LoanProductType.Code, Customer."No.", 2, RemittanceCode.Code, InstallmentAmount[2]);
                    END;
                UNTIL Customer.NEXT = 0;
            END;
        END;
    end;

    local procedure CreateMemberRemittanceLine(DocumentNo: Code[20]; AccountCategory: Integer; AccountType: Code[20]; AccountNo: Code[20]; ContributionType: Integer; RemittanceCode: Code[20]; Amount: Decimal)
    var
        MemberRemittanceLine: Record "Member Remittance Line";
        MemberRemittanceLine2: Record "Member Remittance Line";
        LineNo: Integer;
    begin
        MemberRemittanceLine.INIT;
        MemberRemittanceLine."Document No." := DocumentNo;
        MemberRemittanceLine2.RESET;
        MemberRemittanceLine2.SETRANGE("Document No.", DocumentNo);
        IF MemberRemittanceLine2.FINDLAST THEN
            LineNo := MemberRemittanceLine2."Line No."
        ELSE
            LineNo := 0;
        MemberRemittanceLine."Line No." := LineNo + 10000;
        MemberRemittanceLine."Account Category" := AccountCategory;
        MemberRemittanceLine."Account Type" := AccountType;
        MemberRemittanceLine."Remittance Code" := RemittanceCode;
        MemberRemittanceLine.VALIDATE("Account No.", AccountNo);
        MemberRemittanceLine."Contribution Type" := ContributionType;
        MemberRemittanceLine."Expected Amount" := Amount;
        MemberRemittanceLine."Actual Amount" := Amount;
        MemberRemittanceLine.INSERT;
    end;

    procedure PostPayout(var PayoutHeader: Record "Payout Header")
    var
        PayoutLine: Record "Payout Line";
        PayoutSetup: Record "Payout Setup";
        PayoutType: Record "Payout Type";
        PayoutLoanProduct: Record "Payout Loan Product";
        LoanApplication: Record "Loan Application";
        TotalDeductionAmount: array[4] of Decimal;
        RemittanceAgentSetup: Record "Remittance Agent Setup";
        RecRef: RecordRef;
        SendPayoutNotificationConfirmMsg: Label 'Do you want to send notification to members?';
        Text013: Label '-Gross Amount';
        Text010: Label '-Excise Duty';
        Text011: Label '-Withholding Tax';
        Text016: Label '-Charges';
        Text014: Label '-Net Amount';
    begin
        WITH PayoutHeader DO BEGIN
            GlobalSetup.GET;
            PayoutSetup.GET;
            SourceCodeSetup.GET;
            RemittanceAgentSetup.GET("Agent Code");
            CALCFIELDS("Total Payout Amount");

            SourceCodeSetup.TestField(Payout);
            GlobalManagement.ClearJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name");
            /*
                        GlobalManagement.CreateJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name", "No.", "No.", TODAY, RemittanceAgentSetup."Account Type",
                                      RemittanceAgentSetup."Account No.", Description + Text013, "Total Payout Amount", '', '', SourceCodeSetup.Payout, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                        PayoutLine.RESET;
                        PayoutLine.SETRANGE("Document No.", "No.");
                        IF PayoutLine.FINDSET THEN BEGIN
                            REPEAT
                                IF PayoutLine."Charge Amount" > 0 THEN BEGIN
                                    GlobalManagement.CreateJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                                  PayoutSetup."Charges G/L Account", Description + Text016, -PayoutLine."Charge Amount", '', '', SourceCodeSetup."Payout", PayoutLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                END;
                                IF PayoutLine."Excise Duty Amount" > 0 THEN BEGIN
                                    GlobalManagement.CreateJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                                  GlobalSetup."Excise Duty G/L Account", Description + Text010, -PayoutLine."Excise Duty Amount", '', '', SourceCodeSetup."Payout", PayoutLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                END;
                                IF PayoutLine."Withholding Tax Amount" > 0 THEN BEGIN
                                    GlobalManagement.CreateJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                                  GlobalSetup."Withholding Tax G/L Account", Description + Text011, -PayoutLine."Withholding Tax Amount", '', '', SourceCodeSetup."Payout", PayoutLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                END;
                                Vendor.RESET;
                                Vendor.SETRANGE("Member No.", PayoutLine."Member No.");
                                Vendor.SETRANGE("Account Type", PayoutSetup."FOSA Account Type");
                                IF Vendor.FINDFIRST THEN;

                                TotalDeductionAmount[1] := 0;
                                IF PayoutLine."Net Amount" > 0 THEN BEGIN
                                    GlobalManagement.CreateJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                                  Vendor."No.", Description + Text014, -PayoutLine."Net Amount", '', '', SourceCodeSetup.Payout, PayoutLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                END;
                            UNTIL PayoutLine.NEXT = 0;
                        END;
                        CLEARLASTERROR;
                        IF GlobalManagement.PostJournal(PayoutSetup."Payout Template Name", PayoutSetup."Payout Batch Name") THEN BEGIN
                            Posted := TRUE;
                            "Posted By" := USERID;
                            "Posted Date" := TODAY;
                            "Posted Time" := TIME;
                            if MODIFY then begin
                                if Confirm(SendPayoutNotificationConfirmMsg) then begin
                                    RecRef.GETTABLE(PayoutHeader);
                                    SendNotification(RecRef);
                                end;
                            end;
                        END ELSE BEGIN
                            IF GETLASTERRORTEXT <> '' THEN
                                ERROR(GETLASTERRORTEXT);
                        END;
                    */
        END;
    end;

    procedure GenerateLoanClassification(var LoanApplication: Record "Loan Application"; EndDate: Date)
    var
        LoanClassificationEntry: Record "Loan Classification Entry";
        LoanClassificationEntry2: Record "Loan Classification Entry";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentAmount: array[4] of Decimal;
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationDesc: Text[50];
        ClassificationCode: Code[20];
        ProvisioningPercent: Decimal;
        TotalPrincipalPaid: Decimal;
        TotalInterestPaid: Decimal;
        TotalPrincipalDue: Decimal;
        TotalInterestDue: Decimal;
        PrincBal: Decimal;
        EntryNo: Integer;
        Lrep: Record "Loan Repayment Schedule";
        DCustL: Record "Detailed Cust. Ledg. Entry";
        LPrepayment: decimal;
        objloans: Record "Loan Application";
    begin
        WITH LoanApplication DO BEGIN
            PrincBal := 0;
            LPrepayment := 0;

            LoanClassificationEntry.INIT;
            IF LoanClassificationEntry2.FINDLAST THEN
                EntryNo := LoanClassificationEntry2."Entry No."
            ELSE
                EntryNo := 0;
            LoanClassificationEntry."Entry No." := EntryNo + 1;
            LoanClassificationEntry."Loan No." := "No.";
            LoanClassificationEntry.Description := Description;
            LoanClassificationEntry."Member No." := "Member No.";
            LoanClassificationEntry."Member Name" := "Member Name";
            if Member.Get("Member No.") then begin


                LoanClassificationEntry."Date Of Birth" := Member."Date of Birth";
                LoanClassificationEntry."Phone No." := Member."Phone No.";
                LoanClassificationEntry."Approved Amount" := "Approved Amount";
                CALCFIELDS("Outstanding Balance");
                LoanClassificationEntry."Outstanding Balance" := "Outstanding Balance";
                LoanClassificationEntry."Repayment Method" := "Repayment Method";
                LoanClassificationEntry."Repayment Period" := "Repayment Period";
                LoanClassificationEntry."Repayment Frequency" := "Repayment Frequency";
                if LoanApplication."Date of Completion" <= EndDate then
                    LoanClassificationEntry."Remaining Period" := 0
                else
                    LoanClassificationEntry."Remaining Period" := Round((LoanApplication."Date of Completion" - EndDate) / 30, 1, '=');
                GlobalManagement.CalculateLoanArrearsAndOverpaymentFactbox("No.", 0D, EndDate, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
                LoanClassificationEntry."Principal Overpayment" := OverpaymentAmount[1];
                LoanClassificationEntry."Interest Overpayment" := OverpaymentAmount[2];
                LoanClassificationEntry."Ledger Fee Overpayment" := OverpaymentAmount[3];//
                LoanClassificationEntry."Penalty Overpayment" := OverpaymentAmount[4];
                GlobalManagement.CalculateLoanPrepayment(LoanApplication."No.", 0D, EndDate, LPrepayment);
                LoanClassificationEntry."Loan Prepayment" := LPrepayment;
                LoanClassificationEntry."Principal Arrears" := ArrearsAmount[1];
                LoanClassificationEntry."Interest Arrears" := ArrearsAmount[2];
                LoanClassificationEntry."Ledger Fee Arrears" := ArrearsAmount[3];//
                LoanClassificationEntry."Penalty Arrears" := ArrearsAmount[4];
                TransactionTypeCodeSetup.Get();

                DCustL.Reset();
                DCustL.SetRange("Customer No.", "No.");
                DCustL.SetFilter("Posting Date", '..%1', EndDate);
                DCustL.SetRange("Entry Type", DCustL."Entry Type"::"Initial Entry");
                if DCustL.FindSet() then begin
                    repeat
                        if (DCustL."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") or (DCustL."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid") or (DCustL."Transaction Type Code" = 'CONT') then
                            PrincBal += DCustL.Amount;
                    until DCustL.Next = 0;
                end;
                LoanClassificationEntry."Principal Balance" := PrincBal;
                LoanClassificationEntry."Total Arrears" := ROUND(ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4], 0.01, '<');
                LoanClassificationEntry."No. of Days in Arrears" := 0;
                GlobalManagement.CalculateInstallmentDue("No.", "Next Due Date", InstallmentAmount[1], InstallmentAmount[2]);
                LoanClassificationEntry."Principal Installment" := InstallmentAmount[1];
                LoanClassificationEntry."Interest Installment" := InstallmentAmount[2];
                LoanClassificationEntry."Total Installment" := InstallmentAmount[1] + InstallmentAmount[2];
                CalculateTotalExpectedAmount("No.", TotalPrincipalDue, TotalInterestDue);
                CalculateTotalAmountPaid("No.", EndDate, TotalPrincipalPaid, TotalInterestPaid);
                LoanClassificationEntry."Remaining Principal Amount" := TotalPrincipalDue - TotalPrincipalPaid;
                LoanClassificationEntry."Remaining Interest Amount" := TotalInterestDue - TotalInterestPaid;
                if (ArrearsAmount[1]) > 0 then
                    CalculateDaysAndInstallmentsInArrearsDefaulter("No.", (ArrearsAmount[1]), NoofDaysInArrears, NoofInstallmentInArrears, EndDate);
                LoanClassificationEntry."No. of Days in Arrears" := NoofDaysInArrears;
                LoanClassificationEntry."No. of Defaulted Installment" := NoofInstallmentInArrears;
                GetClassificationClassDetails(NoofDaysInArrears, ClassificationCode, ClassificationDesc, ProvisioningPercent);
                LoanClassificationEntry."Deposit Balance" := GetDepositAccountBalance("Member No.", EndDate);
                LoanClassificationEntry."Classification Code" := ClassificationCode;
                LoanClassificationEntry."Class Description" := ClassificationDesc;
                LoanClassificationEntry."Loan Start Date" := LoanApplication."Disbursal Date";
                LoanClassificationEntry."Expected Completion Date" := LoanApplication."Date of Completion";
                LoanClassificationEntry."Last Payment Date" := GetLastRepaymentDate("No.", EndDate);
                LoanClassificationEntry."Church District Code" := LoanApplication."Church District Code";
                LoanClassificationEntry."Church Section Code" := LoanApplication."Church Section Code";
                LoanClassificationEntry."Provisioning Amount" := PrincBal * (ProvisioningPercent / 100);
                LoanClassificationEntry."Classification Date" := EndDate;
                LoanClassificationEntry."Classification Time" := Time;
                LoanClassificationEntry.Insert()
            end;
        END;
    end;

    procedure GetClassificationClassDetails(NoofDaysInArrears: Integer; var ClassificationCode: Code[20]; var ClassificationDesc: Text[100]; var ProvisioningPercent: Decimal)
    var
        LoanClassificationSetup: Record "Loan Classification Setup";
    begin
        LoanClassificationSetup.RESET;
        IF LoanClassificationSetup.FINDSET THEN BEGIN
            REPEAT
                IF ((NoofDaysInArrears >= LoanClassificationSetup."Min. Defaulted Days") AND (NoofDaysInArrears <= LoanClassificationSetup."Max. Defaulted Days")) THEN begin
                    ClassificationCode := LoanClassificationSetup.Code;
                    ClassificationDesc := LoanClassificationSetup.Description;
                    ProvisioningPercent := LoanClassificationSetup."Provisioning %";
                end;
            UNTIL LoanClassificationSetup.NEXT = 0;
        END;
    end;

    procedure CalculateNoofMonths(StartDate: Date; EndDate: Date): Integer
    var
        Calender: Record "Date";
    begin
        Calender.RESET;
        Calender.SETRANGE("Period Start", StartDate, EndDate);
        Calender.SETRANGE("Period Type", Calender."Period Type"::Month);
        EXIT(Calender.COUNT);
    end;

    procedure CheckLoanApprovedAmount(Loan: Record "Loan Application")
    var
        DCustL: Record "Detailed Cust. Ledg. Entry";
        Trans: Record "Transaction Type Code Setup";
        TransCode: code[100];
    begin
        Trans.Get();
        TransCode := Trans."New Loan";

        DCustL.Reset();
        DCustL.SetRange("Posting Date", 20171231D);
        DCustL.SetRange("Customer No.", Loan."No.");
        DCustL.SetRange("Transaction Type Code", TransCode);
        if DCustL.FindFirst() then begin
            Loan."Approved Amount" := DCustL.Amount;
            Loan."Requested Amount" := DCustL.Amount;
            Loan.Modify();
        end;
    end;

    procedure CalculateTotalAmountPaid(LoanNo: Code[20]; EndDate: Date; var TotalPrincipalPaid: Decimal; var TotalInterestPaid: Decimal)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        TransactionTypeCodeSetup.Get();
        TransactionTypeCodeSetup.TestField("Interest Paid");
        TransactionTypeCodeSetup.TestField("Principal Paid");

        TotalPrincipalPaid := 0;
        TotalInterestPaid := 0;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
        CustLedgerEntry.SetRange(Reversed, false);
        IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                CustLedgerEntry.CALCFIELDS(Amount);
                IF CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" THEN
                    TotalPrincipalPaid += ABS(CustLedgerEntry.Amount);
                IF CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                    TotalInterestPaid += ABS(CustLedgerEntry.Amount);
            UNTIL CustLedgerEntry.NEXT = 0;
        END;
    end;

    procedure CalculateTotalExpectedAmount(LoanNo: Code[20]; var TotalPrincipalDue: Decimal; var TotalInterestDue: Decimal) TotalExpectedAmount: Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        DetailedCust: Record "Detailed Cust. Ledg. Entry";
        Trans: Record "Transaction Type Code Setup";
    begin
        Trans.Get();
        TotalPrincipalDue := 0;
        TotalInterestDue := 0;
        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        if LoanRepaymentSchedule.FindSet() then begin
            LoanRepaymentSchedule.CALCSUMS("Principal Installment");
            LoanRepaymentSchedule.CALCSUMS("Interest Installment");
            TotalPrincipalDue := LoanRepaymentSchedule."Principal Installment";
        end;

        DetailedCust.Reset();
        DetailedCust.SetRange("Customer No.", LoanNo);
        if DetailedCust.FindSet() then begin
            if DetailedCust."Transaction Type Code" = Trans."Interest Due" then
                TotalInterestDue += LoanRepaymentSchedule."Interest Installment";
        end;
    end;

    procedure GenerateDefaultedLoans(var LoanApplication: Record "Loan Application"; EndDate: Date)
    var
        LoanDefaulterEntry: Record "Loan Defaulter Entry";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentAmount: array[4] of Decimal;
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationDesc: Text[50];
        ClassificationCode: Code[20];
        ProvisioningPercent: Decimal;
        TotalPrincipalPaid: Decimal;
        TotalInterestPaid: Decimal;
        TotalPrincipalDue: Decimal;
        TotalInterestDue: Decimal;
        Member: Record Member;
        EntryNo: Integer;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        PrincBal: Decimal;
    begin
        WITH LoanApplication DO BEGIN
            PrincBal := 0;

            LoanDefaulterEntry.INIT;
            IF LoanDefaulterEntry.FINDLAST THEN
                EntryNo := LoanDefaulterEntry."Entry No."
            ELSE
                EntryNo := 0;
            LoanDefaulterEntry."Entry No." := EntryNo + 1;
            LoanDefaulterEntry."Loan No." := "No.";
            LoanDefaulterEntry.Description := Description;
            LoanDefaulterEntry."Member No." := "Member No.";
            LoanDefaulterEntry."Member Name" := "Member Name";
            LoanDefaulterEntry."Approved Amount" := "Approved Amount";
            CALCFIELDS("Outstanding Balance");
            LoanDefaulterEntry."Outstanding Balance" := "Outstanding Balance";
            LoanDefaulterEntry."Repayment Method" := "Repayment Method";
            LoanDefaulterEntry."Repayment Period" := "Repayment Period";
            LoanDefaulterEntry."Repayment Frequency" := "Repayment Frequency";
            if LoanApplication."Date of Completion" < EndDate then
                LoanDefaulterEntry."Remaining Period" := 0
            else
                LoanDefaulterEntry."Remaining Period" := Round((LoanApplication."Date of Completion" - EndDate) / 30, 1, '=');

            GlobalManagement.CalculateLoanArrearsAndOverpaymentFactbox("No.", 0D, EndDate, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
            if ArrearsAmount[1] > 0 then begin
                if ArrearsAmount[1] > "Outstanding Balance" then
                    LoanDefaulterEntry."Principal Arrears" := "Outstanding Balance"
                else
                    LoanDefaulterEntry."Principal Arrears" := ArrearsAmount[1];
            end;
            LoanDefaulterEntry."Interest Arrears" := ArrearsAmount[2];
            LoanDefaulterEntry."Ledger Fee Arrears" := ArrearsAmount[3];
            LoanDefaulterEntry."Penalty Arrears" := ArrearsAmount[4];

            if LoanApplication."Date of Completion" < EndDate then
                LoanDefaulterEntry."Total Arrears" := "Outstanding Balance"
            else
                LoanDefaulterEntry."Total Arrears" := ROUND(ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4], 0.01, '<');
            LoanDefaulterEntry."No. of Days in Arrears" := 0;
            //LG
            GlobalManagement.CalculateInstallmentDue("No.", "Next Due Date", InstallmentAmount[1], InstallmentAmount[2]);
            LoanDefaulterEntry."Principal Installment" := InstallmentAmount[1];
            LoanDefaulterEntry."Interest Installment" := InstallmentAmount[2];
            LoanDefaulterEntry."Total Installment" := InstallmentAmount[1] + InstallmentAmount[2];

            //LG
            CalculateTotalExpectedAmount("No.", TotalPrincipalDue, TotalInterestDue);
            CalculateTotalAmountPaid("No.", EndDate, TotalPrincipalPaid, TotalInterestPaid);

            LoanDefaulterEntry."Remaining Principal Amount" := TotalPrincipalDue - TotalPrincipalPaid;
            LoanDefaulterEntry."Remaining Interest Amount" := TotalInterestDue - TotalInterestPaid;
            //LG
            if (ArrearsAmount[1]) > 0 then
                CalculateDaysAndInstallmentsInArrearsDefaulter("No.", (ArrearsAmount[1]), NoofDaysInArrears, NoofInstallmentInArrears, EndDate);

            LoanDefaulterEntry."No. of Days in Arrears" := NoofDaysInArrears;
            LoanDefaulterEntry."No. of Defaulted Installment" := NoofInstallmentInArrears;
            //LG
            GetClassificationClassDetails(NoofDaysInArrears, ClassificationCode, ClassificationDesc, ProvisioningPercent);
            if Member.Get("Member No.") then begin


                LoanDefaulterEntry."Deposit Balance" := GetDepositAccountBalance("Member No.", EndDate);
                LoanDefaulterEntry."Classification Code" := ClassificationCode;
                LoanDefaulterEntry."Class Description" := ClassificationDesc;
                LoanDefaulterEntry."Loan Start Date" := LoanApplication."Disbursal Date";
                LoanDefaulterEntry."Expected Completion Date" := LoanApplication."Date of Completion";
                LoanDefaulterEntry."Last Payment Date" := GetLastRepaymentDate("No.", EndDate);
                LoanDefaulterEntry."Church District Code" := LoanApplication."Church District Code";
                LoanDefaulterEntry."Church Section Code" := LoanApplication."Church Section Code";
                LoanDefaulterEntry."Phone No" := Member."Phone No.";
                IF LoanDefaulterEntry."Total Arrears" > 0 THEN
                    LoanDefaulterEntry.Insert();
            end;

        END;
    end;


    procedure AttachLoanToGuarantor(var LoanDefaulterEntry: Record "Loan Defaulter Entry")
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanApplication2: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Defaulter Loan';
        LoanApplication: Record "Loan Application";
        TotalGuarAmount: Decimal;
    begin
        WITH LoanDefaulterEntry DO BEGIN
            //if "Notice Due Date" = Today then begin

            LoanApplication.Get("Loan No.");
            LoanApplication.CalcFields("Outstanding Balance");

            LoanGuarantor.RESET;
            LoanGuarantor.SETRANGE("Loan No.", LoanApplication."No.");
            IF LoanGuarantor.FINDSET THEN BEGIN
                LoanGuarantor.CalcSums("Amount To Guarantee");
                TotalGuarAmount := LoanGuarantor."Amount To Guarantee";
            END;



            LoanGuarantor.RESET;
            LoanGuarantor.SETRANGE("Loan No.", LoanApplication."No.");
            IF LoanGuarantor.FINDSET THEN BEGIN
                REPEAT
                    // Message('Amount Guaranteed %1, Total Amount Guaranteed %2', LoanGuarantor."Amount To Guarantee", TotalGuarAmount);

                    LoanGuarantor.TestField("Member No.");
                    LoanGuarantor.TestField("Account No.");
                    LoanGuarantor.TestField("Amount To Guarantee");

                    LoanApplication2.TRANSFERFIELDS(LoanApplication);
                    LoanApplication2."No." := '';
                    LoanApplication2.VALIDATE("Member No.", LoanGuarantor."Member No.");
                    IF TotalGuarAmount > 0 THEN BEGIN
                        LoanApplication2."Requested Amount" := (LoanGuarantor."Amount To Guarantee" / TotalGuarAmount) * LoanApplication."Outstanding Balance";
                        LoanApplication2."Approved Amount" := (LoanGuarantor."Amount To Guarantee" / TotalGuarAmount) * LoanApplication."Outstanding Balance";
                        LoanApplication2."Mode of Disbursement" := LoanApplication2."Mode of Disbursement"::"Bank Account";
                        // LoanApplication2.Modify();
                    END;

                    LoanApplication2.Remarks := Text000;
                    IF LoanApplication2.INSERT(TRUE) THEN begin
                        PostLoanAttachToGuarantor(LoanApplication2, LoanApplication);
                        //CreateGuarantorAttachEntries(LoanDefaulterEntry, LoanApplication2);
                    end;

                UNTIL LoanGuarantor.NEXT = 0;
            END;
            //END;
        end;
    end;

    procedure RecoverLoanFromGuarantor(var LoanDefaulterEntry: Record "Loan Defaulter Entry")
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanApplication2: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Defaulter Loan';
        LoanApplication: Record "Loan Application";
        TotalGuarAmount: Decimal;
        Vendor: record Vendor;
        AmountToRecover: Decimal;
        RunningBal: Decimal;
    begin
        WITH LoanDefaulterEntry DO BEGIN
            //if "Notice Due Date" = Today then begin
            RunningBal := 0;

            LoanApplication.Get("Loan No.");
            LoanApplication.CalcFields("Outstanding Balance");
            RunningBal := LoanApplication."Outstanding Balance";

            LoanGuarantor.RESET;
            LoanGuarantor.SETRANGE("Loan No.", LoanApplication."No.");
            IF LoanGuarantor.FINDSET THEN BEGIN
                LoanGuarantor.CalcSums("Amount To Guarantee");
                TotalGuarAmount := LoanGuarantor."Amount To Guarantee";
            END;

            LoanGuarantor.RESET;
            LoanGuarantor.SETRANGE("Loan No.", LoanApplication."No.");
            LoanGuarantor.SetRange("Member No.", LoanApplication."Member No.");
            IF LoanGuarantor.FindFirst THEN BEGIN
                AmountToRecover := RunningBal;
                Vendor.get(LoanGuarantor."Account No.");
                Vendor.CalcFields(Balance);
                if Vendor.Balance > AmountToRecover then
                    AmountToRecover := AmountToRecover
                else
                    AmountToRecover := Vendor.Balance;
                PostGuarRecovery(LoanApplication, AmountToRecover);
                RunningBal := RunningBal - AmountToRecover;
            END;
            if RunningBal > 0 then begin
                LoanGuarantor.RESET;
                LoanGuarantor.SETRANGE("Loan No.", LoanApplication."No.");
                LoanGuarantor.SetFilter("Member No.", '<>%1', LoanApplication."Member No.");
                IF LoanGuarantor.FINDSET THEN BEGIN
                    REPEAT
                        AmountToRecover := 0;
                        LoanGuarantor.TestField("Member No.");
                        LoanGuarantor.TestField("Account No.");
                        LoanGuarantor.TestField("Amount To Guarantee");
                        AmountToRecover := (LoanGuarantor."Amount To Guarantee" / TotalGuarAmount) * RunningBal;
                        PostGuarRecovery(LoanApplication, AmountToRecover);
                    UNTIL LoanGuarantor.NEXT = 0;
                END;
            end;
            //END;
        end;
    end;

    procedure PostGuarRecovery(var LoanApp: Record "Loan Application"; AmountToRecover: Decimal)
    var
        Descrp: Text[250];
        LoanAppSetup: Record "Loan Application Setup";

    begin
        with LoanApp do begin

            SourceCodeSetup.Get();
            GlobalSetup.Get();
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField("Loan Recovery");

            JournalTemplateName := LoanAppSetup."Loan Recovery Template Name";
            JournalBatchName := LoanAppSetup."Loan Recovery Template Name";

            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);

            GlobalManagement.DeductLoanArrearsGuarRecovery(TransactionTypeCodeSetup, SourceCodeSetup, JournalTemplateName, JournalBatchName, "No.", '', Today, LoanApp."No.", AmountToRecover, "Global Dimension 1 Code");

            GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName)


        end;
    end;

    local procedure CreateGuarantorAttachEntries(var LoanDefaulterEntry: Record "Loan Defaulter Entry"; LoanApplication: Record "Loan Application")
    var
        GuarantorAttachEntry: Record "Guarantor Attach Entry";
        GuarantorAttachEntry2: Record "Guarantor Attach Entry";
        LineNo: Integer;
    begin
        with LoanApplication do begin
            GuarantorAttachEntry.Init();
            GuarantorAttachEntry."Loan No." := LoanDefaulterEntry."Loan No.";
            GuarantorAttachEntry2.Reset();
            GuarantorAttachEntry2.SetRange("Loan No.", LoanDefaulterEntry."Loan No.");
            if GuarantorAttachEntry2.FindLast() then
                LineNo := GuarantorAttachEntry2."Line No"
            else
                LineNo := 0;
            GuarantorAttachEntry."Line No" := LineNo + 10000;
            GuarantorAttachEntry."Attached Loan No." := "No.";
            GuarantorAttachEntry."Attached Amount" := "Approved Amount";
            GuarantorAttachEntry.Insert();
        end;
    end;

    procedure ReverseAttachedLoan(var LoanDefaulterEntry: Record "Loan Defaulter Entry")
    var
        GuarantorAttachEntry: Record "Guarantor Attach Entry";
        LoanApplication: Record "Loan Application";
    begin
        WITH LoanDefaulterEntry DO BEGIN
            GuarantorAttachEntry.SetRange("Loan No.", "Loan No.");
            if GuarantorAttachEntry.FindSet() then begin
                repeat
                    LoanApplication.Get(GuarantorAttachEntry."Attached Loan No.");
                    ReverseLoan(LoanApplication);
                    GuarantorAttachEntry.Delete();
                until GuarantorAttachEntry.Next() = 0;
            end;

        END;
    end;

    local procedure GetTotalGuaranteedAmount(LoanNo: Code[20]): Decimal
    var
        LoanGuarantor: Record "Loan Guarantor";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", LoanNo);
        LoanGuarantor.CALCSUMS("Account Balance");
        EXIT(LoanGuarantor."Account Balance");
    end;

    procedure SendDefaulterNotice(var LoanDefaulterEntry: Record "Loan Defaulter Entry")
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanDefaulterSetup: Record "Loan Defaulter Setup";
        SMSText: BigText;
        LoanApplication: Record "Loan Application";
        Member: Record "Member";
        Member2: Record "Member";
        NoticeDueDate: Date;
    begin
        LoanDefaulterSetup.GET;
        LoanDefaulterSetup.TestField("First Notice Template");
        LoanDefaulterSetup.TestField("Second Notice Template-Member");
        LoanDefaulterSetup.TestField("Second Notice-Guarantor");
        LoanDefaulterSetup.TestField("Third Notice-Member");
        LoanDefaulterSetup.TestField("Third Notice-Guarantor");

        SourceCodeSetup.GET;
        SourceCodeSetup.TestField(Defaulter);
        WITH LoanDefaulterEntry DO BEGIN
            IF LoanDefaulterEntry."Class Description" <> 'PERFORMING' then begin

                LoanApplication.GET("Loan No.");
                LoanApplication.CalcFields("Outstanding Balance");

                Member.GET("Member No.");
                if "Notice Category" = "Notice Category"::" " then begin
                    if LoanDefaulterSetup."Notify Member" then begin
                        NoticeDueDate := CalcDate(LoanDefaulterSetup."Grace Period", TODAY);
                        Clear(SMSText);
                        SMSText.ADDTEXT(STRSUBSTNO(LoanDefaulterSetup."First Notice Template", Description, LoanDefaulterEntry."No. of Days in Arrears", LoanApplication."Outstanding Balance", NoticeDueDate));
                        GlobalManagement.CreateSMSEntry(CopyStr(Member."Phone No.", 1, 10), SMSText, SourceCodeSetup.Defaulter);
                        "Notice Category" := "Notice Category"::"First Notice";
                        "Notice Due Date" := NoticeDueDate;
                    end;
                end;
                if "Notice Category" = "Notice Category"::"First Notice" then begin
                    if "Notice Date" = Today then begin
                        // "Notice Date"
                        if LoanDefaulterSetup."Notify Member" then begin
                            Clear(SMSText);
                            SMSText.ADDTEXT(STRSUBSTNO(LoanDefaulterSetup."Second Notice Template-Member", Description, LoanDefaulterEntry."No. of Days in Arrears", LoanApplication."Outstanding Balance"));
                            GlobalManagement.CreateSMSEntry(CopyStr(Member."Phone No.", 1, 10), SMSText, SourceCodeSetup.Defaulter);
                        end;
                        if LoanDefaulterSetup."Notify Guarantor" then begin
                            LoanGuarantor.RESET;
                            LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                            IF LoanGuarantor.FINDSET THEN BEGIN
                                REPEAT
                                    Clear(SMSText);
                                    Member2.GET(LoanGuarantor."Member No.");
                                    SMSText.ADDTEXT(STRSUBSTNO(LoanDefaulterSetup."Second Notice-Guarantor", Description, "Member Name", LoanDefaulterEntry."No. of Days in Arrears"));
                                    GlobalManagement.CreateSMSEntry(CopyStr(Member2."Phone No.", 1, 10), SMSText, SourceCodeSetup.Defaulter);
                                UNTIL LoanGuarantor.NEXT = 0;
                            END;
                        end;
                        "Notice Category" := "Notice Category"::"Second Notice";
                    end;
                END;
                if "Notice Category" = "Notice Category"::"Second Notice" then begin
                    if "Notice Date" = Today then begin
                        if LoanDefaulterSetup."Notify Member" then begin
                            Clear(SMSText);
                            SMSText.ADDTEXT(STRSUBSTNO(LoanDefaulterSetup."Second Notice Template-Member", Description, LoanDefaulterEntry."No. of Days in Arrears", LoanApplication."Outstanding Balance"));
                            GlobalManagement.CreateSMSEntry(CopyStr(Member."Phone No.", 1, 10), SMSText, SourceCodeSetup.Defaulter);
                        end;
                        if LoanDefaulterSetup."Notify Guarantor" then begin
                            LoanGuarantor.RESET;
                            LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                            IF LoanGuarantor.FINDSET THEN BEGIN
                                REPEAT
                                    Clear(SMSText);
                                    Member2.GET(LoanGuarantor."Member No.");
                                    SMSText.ADDTEXT(STRSUBSTNO(LoanDefaulterSetup."Second Notice-Guarantor", Description, "Member Name", LoanDefaulterEntry."No. of Days in Arrears"));
                                    GlobalManagement.CreateSMSEntry(CopyStr(Member2."Phone No.", 1, 10), SMSText, SourceCodeSetup.Defaulter);
                                UNTIL LoanGuarantor.NEXT = 0;
                            END;
                        end;
                        "Notice Category" := "Notice Category"::"Third Notice";
                    end;
                end;
                "Notice Date" := TODAY;
                MODIFY;
            END;
        end;
    end;

    procedure ProcessMemberExit(var MemberExitHeader: Record "Member Exit Header")
    var
        ExitReason: Record "Exit Reason";
    begin
        WITH MemberExitHeader DO BEGIN
            //ExitReason.GET("Reason Code");
            //IF ExitReason."Initiate Refund" THEN
            // CreateRefund(MemberExitHeader);

            // IF ExitReason."Initiate Claim" THEN
            //CreateClaim(MemberExitHeader);

            //PostExitFee(MemberExitHeader);
        END;
    end;

    local procedure CreateRefund(var MemberExitHeader: Record "Member Exit Header")
    var
        MemberRefundHeader: Record "Member Refund Header";
        MemberRefundLine: Record "Member Refund Line";
        MemberExitLine: Record "Member Exit Line";
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        ExitSetup.GET;
        WITH MemberExitHeader DO BEGIN
            MemberRefundHeader.TRANSFERFIELDS(MemberExitHeader);
            MemberRefundHeader."No." := '';
            MemberRefundHeader."Exit No." := "No.";
            MemberRefundHeader.VALIDATE("Member No.");
            MemberRefundHeader."No. Series" := ExitSetup."Refund Nos.";
            MemberRefundHeader.Status := MemberRefundHeader.Status::New;
            MemberRefundHeader.INSERT(TRUE);

            MemberExitLine.RESET;
            MemberExitLine.SETRANGE("Document No.", "No.");
            MemberExitLine.SETRANGE("Account Category", MemberExitLine."Account Category"::Vendor);
            IF MemberExitLine.FINDSET THEN BEGIN
                REPEAT
                    MemberRefundLine.TRANSFERFIELDS(MemberExitLine);
                    MemberRefundLine."Document No." := MemberRefundHeader."No.";
                    MemberRefundLine.INSERT;
                UNTIL MemberExitLine.NEXT = 0;
            END;
            IF ApprovalsMgmt.CheckMemberRefundApprovalPossible(MemberRefundHeader) THEN
                ApprovalsMgmt.OnSendMemberRefundForApproval(MemberRefundHeader);
        END;
    end;

    local procedure CreateClaim(var MemberExitHeader: Record "Member Exit Header")
    var
        MemberClaimHeader: Record "Member Claim Header";
        MemberClaimLine: Record "Member Claim Line";
        MemberExitLine: Record "Member Exit Line";
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        ExitSetup.GET;
        WITH MemberExitHeader DO BEGIN
            MemberClaimHeader.TRANSFERFIELDS(MemberExitHeader);
            MemberClaimHeader."No." := '';
            MemberClaimHeader."Exit No." := "No.";
            MemberClaimHeader.VALIDATE("Member No.");
            MemberClaimHeader."No. Series" := ExitSetup."Refund Nos.";
            MemberClaimHeader.Status := MemberClaimHeader.Status::New;
            MemberClaimHeader.INSERT(TRUE);

            MemberExitLine.RESET;
            MemberExitLine.SETRANGE("Document No.", "No.");
            MemberExitLine.SETRANGE("Account Category", MemberExitLine."Account Category"::Customer);
            IF MemberExitLine.FINDSET THEN BEGIN
                REPEAT
                    MemberClaimLine.TRANSFERFIELDS(MemberExitLine);
                    MemberClaimLine."Document No." := MemberClaimHeader."No.";
                    MemberClaimLine.INSERT;
                UNTIL MemberExitLine.NEXT = 0;
            END;
            IF ApprovalsMgmt.CheckMemberClaimApprovalPossible(MemberClaimHeader) THEN
                ApprovalsMgmt.OnSendMemberClaimForApproval(MemberClaimHeader);
        END;
    end;

    procedure PostLoanRecovery(var LoanApplication: Record "Loan Application")
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        AccountBalance: Decimal;
        LoanProductRecovery: Record "Loan Product Recovery";
        BoostAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
    begin

    end;

    procedure PostRefund(var MemberRefundHeader: Record "Member Refund Header")
    var
        MemberRefundLine: Record "Member Refund Line";
        RefundAmount: Decimal;
        BeneficiaryAllocation: Record "Beneficiary Allocation";
        TotalDeductionAmount: array[4] of Decimal;
        Text009: Label 'Refund-';
        Text007: Label '-Principal Overpayment';
    begin
        WITH MemberRefundHeader DO BEGIN
            ExitSetup.GET;
            SourceCodeSetup.GET;

            SourceCodeSetup.TestField("Member Exit");
            SourceCodeSetup.TestField(refund);

            GlobalManagement.ClearJournal(ExitSetup."Refund Template Name", ExitSetup."Refund Batch Name");
            RefundAmount := 0;
            MemberRefundLine.RESET;
            MemberRefundLine.SETRANGE("Document No.", "No.");
            IF MemberRefundLine.FINDSET THEN BEGIN
                REPEAT
                /* GlobalManagement.CreateJournal(ExitSetup."Refund Template Name", ExitSetup."Refund Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                               MemberRefundLine."Account No.", Text009 + "No.", MemberRefundLine."Account Balance", '', '', SourceCodeSetup."Refund", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                 RefundAmount += MemberRefundLine."Account Balance";

                 BeneficiaryAllocation.RESET;
                 BeneficiaryAllocation.SETRANGE("Document No.", MemberRefundLine."Document No.");
                 BeneficiaryAllocation.SETRANGE("Source Account No.", MemberRefundLine."Account No.");
                 IF BeneficiaryAllocation.FINDSET THEN BEGIN
                     REPEAT
                         BeneficiaryAllocation.TESTFIELD("Account No.");
                         IF BeneficiaryAllocation."Account Category" = BeneficiaryAllocation."Account Category"::Vendor THEN BEGIN
                             GlobalManagement.CreateJournal(ExitSetup."Refund Template Name", ExitSetup."Refund Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                           BeneficiaryAllocation."Account No.", Text009 + "No.", -BeneficiaryAllocation."Allocation Amount", '', '', SourceCodeSetup."Refund", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                         END;
                         IF BeneficiaryAllocation."Account Category" = BeneficiaryAllocation."Account Category"::Customer THEN BEGIN
                             IF BeneficiaryAllocation."Allocation Amount" > 0 THEN BEGIN
                                 GlobalManagement.CreateJournal(ExitSetup."Refund Template Name", ExitSetup."Refund Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Customer,
                                               BeneficiaryAllocation."Account No.", Text009 + "No." + Text007, -BeneficiaryAllocation."Allocation Amount", '', '', SourceCodeSetup."Refund", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                             END;
                         END;
                         IF BeneficiaryAllocation."Account Category" = BeneficiaryAllocation."Account Category"::"Bank Account" THEN BEGIN
                             GlobalManagement.CreateJournal(ExitSetup."Refund Template Name", ExitSetup."Refund Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"Bank Account",
                                           BeneficiaryAllocation."Account No.", Text009 + "No.", -BeneficiaryAllocation."Allocation Amount", '', '', SourceCodeSetup."Refund", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                         END;
                     UNTIL BeneficiaryAllocation.NEXT = 0;
                 END;
                 */
                UNTIL MemberRefundLine.NEXT = 0;
            END;
            CLEARLASTERROR;
            IF GlobalManagement.PostJournal(ExitSetup."Refund Template Name", ExitSetup."Refund Batch Name") THEN BEGIN
                Posted := TRUE;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END
    end;

    procedure CalculateDividends(var Member: Record "Member"; DividendType: Option Both,Dividend,Interest,Boresha; DocumentNo: Code[20]; CalcEndDate: Date)
    var
        DividendLine: Record "Dividend Line";
        DividendHeader: Record "Dividend Header";
        DividendLine2: Record "Dividend Line";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        LineNo: Integer;
        DividendSetup: Record "Dividend Setup";
        RemainingAmount: array[4] of Decimal;
        Amount: array[8] of Decimal;
        Found: array[4] of Boolean;
        AccountType: Record "Account Type";
        StartDate: Date;
        DFilter: Text;
        Jan: Decimal;
        Feb: Decimal;
        March: Decimal;
        April: Decimal;
        May: Decimal;
        June: Decimal;
        July: Decimal;
        Aug: Decimal;
        Sep: Decimal;
        Oct: Decimal;
        Nov: Decimal;
        Dec: Decimal;
    begin
        GlobalSetup.GET;
        DividendSetup.GET;
        DividendHeader.Get(DocumentNo);

        WITH Member DO BEGIN
            StartDate := CalcDate('-CY', CalcEndDate);
            DividendLine.INIT;
            DividendLine2.RESET;
            DividendLine2.SETRANGE("Document No.", DocumentNo);
            IF DividendLine2.FINDLAST THEN
                LineNo := DividendLine2."Line No."
            ELSE
                LineNo := 0;
            DividendLine."Document No." := DocumentNo;
            DividendLine."Line No." := LineNo + 1;
            DividendLine.VALIDATE("Member No.", "No.");
            DividendLine."National ID" := Member."National ID";
            DividendLine."Phone No" := Member."Phone No.";
            DividendLine."District " := Member."Church District Code";
            DividendLine.Section := Member."Church Section Code";

            // DividendLine."Account Type" := Vendor."Account Type";
            // DividendLine.VALIDATE("Account No.", Vendor."No.");

            Vendor.RESET;
            Vendor.SETRANGE("Member No.", "No.");
            Vendor.SetRange("Vendor Type", Vendor."Vendor Type"::FOSA);
            IF Vendor.FINDSET THEN BEGIN
                REPEAT
                    AccountType.GET(Vendor."Account Type");
                    If DividendType <> DividendType::Boresha then begin
                        IF (AccountType.Type = AccountType.Type::"Share Capital") then begin
                            //Amount[1] += DividendSetup."Dividend Rate %" / 100 * GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
                            DividendLine."Share Capital Amount" := GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
                            DFilter := '..' + FORMAT(CALCDATE('CM', StartDate));
                            Jan := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (12 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('1M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('1M', StartDate)));
                            Feb := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (11 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('2M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('2M', StartDate)));
                            March := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (10 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('3M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('3M', StartDate)));
                            April := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (9 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('4M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('4M', StartDate)));
                            May := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (8 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('5M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('5M', StartDate)));
                            June := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (7 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('6M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('6M', StartDate)));
                            July := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (6 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('7M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('7M', StartDate)));
                            Aug := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (5 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('8M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('8M', StartDate)));
                            Sep := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (4 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('9M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('9M', StartDate)));
                            Oct := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (3 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('10M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('10M', StartDate)));
                            Nov := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (2 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('11M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('11M', StartDate)));
                            Dec := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (1 / 12);
                            Amount[1] += Jan + Feb + March + April + May + June + July + Aug + Sep + Oct + Nov + Dec;
                        end;
                        If (AccountType.Type = AccountType.Type::"Member Deposit") then begin
                            DFilter := '..' + FORMAT(CALCDATE('CM', StartDate));
                            Jan := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (12 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('1M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('1M', StartDate)));
                            Feb := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (11 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('2M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('2M', StartDate)));
                            March := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (10 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('3M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('3M', StartDate)));
                            April := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (9 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('4M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('4M', StartDate)));
                            May := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (8 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('5M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('5M', StartDate)));
                            June := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (7 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('6M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('6M', StartDate)));
                            July := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (6 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('7M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('7M', StartDate)));
                            Aug := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (5 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('8M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('8M', StartDate)));
                            Sep := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (4 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('9M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('9M', StartDate)));
                            Oct := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (3 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('10M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('10M', StartDate)));
                            Nov := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (2 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('11M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('11M', StartDate)));
                            Dec := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (1 / 12);
                            Amount[1] += Jan + Feb + March + April + May + June + July + Aug + Sep + Oct + Nov + Dec;
                            DividendLine."Member Deposits Amount" := GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
                        end;
                    end else begin
                        DividendHeader.TestField("Interest Calc %");

                        If (AccountType.Type = AccountType.Type::Savings) and (AccountType."Sub Type" = AccountType."Sub Type"::Boresha) then begin
                            DFilter := '..' + FORMAT(CALCDATE('CM', StartDate));
                            Jan := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (12 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('1M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('1M', StartDate)));
                            Feb := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (11 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('2M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('2M', StartDate)));
                            March := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (10 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('3M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('3M', StartDate)));
                            April := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (9 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('4M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('4M', StartDate)));
                            May := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (8 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('5M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('5M', StartDate)));
                            June := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (7 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('6M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('6M', StartDate)));
                            July := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (6 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('7M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('7M', StartDate)));
                            Aug := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (5 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('8M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('8M', StartDate)));
                            Sep := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (4 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('9M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('9M', StartDate)));
                            Oct := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (3 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('10M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('10M', StartDate)));
                            Nov := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (2 / 12);
                            DFilter := FORMAT(CALCDATE('-CM', CALCDATE('11M', StartDate))) + '..' + FORMAT(CALCDATE('CM', CALCDATE('11M', StartDate)));
                            Dec := DividendHeader."Interest Calc %" / 100 * GlobalManagement.GetAccountFilteredBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", DFilter) * (1 / 12);
                            Amount[1] += Jan + Feb + March + April + May + June + July + Aug + Sep + Oct + Nov + Dec;
                            DividendLine."Boresha Savings Amount" := GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
                        end;
                    end;
                Until Vendor.Next = 0;
            END;
            DividendLine."Gross Earning Amount" := Round(Amount[1], 1, '=');
            //DividendLine."Account Balance" := GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
            /* IF AccountType."Earns Dividend" THEN BEGIN
                 DividendSetup.TestField("Dividend Rate %");
                 // Amount[1] := DividendSetup."Dividend Rate %" / 100 * GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
                 Amount[2] := 0;
                 DividendLine."Gross Earning Amount" := Amount[1];
                 DividendLine."Earning Type" := DividendLine."Earning Type"::Dividend;
                 IF DividendSetup."Topup Shares" THEN BEGIN
                     IF DividendLine."Account Balance" < AccountType."Minimum Balance" THEN
                         Amount[5] := AccountType."Minimum Balance" - DividendLine."Account Balance"
                     ELSE
                         Amount[5] := 0;
                 END;
             END;*/
            /* IF AccountType."Earns Interest" THEN BEGIN
                 DividendSetup.TestField("Interest Rate %");
                 Amount[1] := DividendSetup."Interest Rate %" / 100 * GlobalManagement.GetAccountBalanceDividend(AccountTypeEnum::Vendor, Vendor."No.", CalcEndDate);
                 DividendLine."Gross Earning Amount" := Amount[1];
                 DividendLine."Earning Type" := DividendLine."Earning Type"::Interest;
                 IF AccountType."Earns Commission on Interest" THEN
                     Amount[2] := DividendSetup."Commission Amount";
                 Amount[5] := 0;
             END;*/
            IF DividendSetup."Charge Excise Duty" THEN
                Amount[3] := Round(GlobalSetup."Excise Duty %" / 100 * DividendLine."Gross Earning Amount", 1, '=');
            IF DividendSetup."Charge Withholdig Tax" THEN
                Amount[4] := Round(GlobalSetup."Withholding Tax %" / 100 * DividendLine."Gross Earning Amount", 1, '=');

            DividendLine."Excise Duty Amount" := Amount[3];
            DividendLine."Withholding Tax Amount" := Amount[4];
            DividendLine."Commission Amount" := Amount[2];
            DividendLine."Shares Topup Amount" := Amount[5];
            DividendLine."Net Earning Amount" := DividendLine."Gross Earning Amount" - DividendLine."Excise Duty Amount" - DividendLine."Withholding Tax Amount";
            IF DividendLine."Gross Earning Amount" > 0 THEN
                DividendLine.INSERT;
        END;
    end;



    procedure PostDividends(var DividendHeader: Record "Dividend Header")
    var
        DividendLine: Record "Dividend Line";
        DeductionAmount: array[4] of Decimal;
        TopupAmount: Decimal;
        AccountType: Record "Account Type";
        GenJournalLine: Record "Gen. Journal Line";
        DividendSetup: Record "Dividend Setup";
        TotalDeductionAmount: array[4] of Decimal;
        LoanApplication: Record "Loan Application";
        ArrearsAmount: array[4] of Decimal;
        RecRef: RecordRef;
        SendDividendsNotificationConfirmMsg: Label 'Do you want to send notification to members?';
        Text013: Label '-Gross Amount';
        Text014: Label '-Net Amount';
        Text015: Label '-Shares Topup';
        Text010: Label '-Excise Duty';
        Text011: Label '-Withholding Tax';
        Text012: Label '-Commission';
    begin
        WITH DividendHeader DO BEGIN
            GlobalSetup.GET;
            DividendSetup.GET;
            SourceCodeSetup.GET;
            CALCFIELDS("Total Amount");

            SourceCodeSetup.TestField(Dividend);
            DividendSetup.TestField("Dividend Template Name");
            DividendSetup.TestField("Dividend Batch Name");

            GlobalManagement.ClearJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name");
            GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                          DividendSetup."Dividend Control G/L Account", Description + Text013, "Total Amount", '', '', SourceCodeSetup.Dividend, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');

            DividendLine.RESET;
            DividendLine.SETRANGE("Document No.", "No.");
            IF DividendLine.FINDSET THEN BEGIN
                REPEAT
                    AccountType.GET(DividendLine."Account Type");
                    IF DividendLine."Excise Duty Amount" > 0 THEN BEGIN
                        GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                      GlobalSetup."Excise Duty G/L Account", Description + Text010, -DividendLine."Excise Duty Amount", '', '', SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', DividendLine."Member No.");
                    END;
                    IF DividendLine."Withholding Tax Amount" > 0 THEN BEGIN
                        GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                      GlobalSetup."Withholding Tax G/L Account", Description + Text011, -DividendLine."Withholding Tax Amount", '', '', SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', DividendLine."Member No.");
                    END;
                    IF DividendLine."Commission Amount" > 0 THEN BEGIN
                        GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                      DividendSetup."Commission G/L Account", Description + Text012, -DividendLine."Commission Amount", '', '', SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', DividendLine."Member No.");
                    END;
                    IF DividendLine."Shares Topup Amount" > 0 THEN BEGIN
                        GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                      DividendLine."Account No.", Description + Text015, -DividendLine."Shares Topup Amount", '', '', SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', DividendLine."Member No.");
                    END;
                    Vendor.RESET;
                    Vendor.SETRANGE("Member No.", DividendLine."Member No.");
                    Vendor.SETRANGE("Account Type", DividendSetup."FOSA Account Type");
                    IF Vendor.FINDFIRST THEN begin

                        IF DividendLine."Distribution Option" = DividendLine."Distribution Option"::"To FOSA" THEN BEGIN
                            GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                          Vendor."No.", Description + Text014, -DividendLine."Net Earning Amount", 'DIVIDEND', '', SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Vendor."Member No.");
                        END;

                        IF DividendLine."Distribution Option" = DividendLine."Distribution Option"::"To Loan" THEN BEGIN

                            IF DividendLine."Net Earning Amount" > 0 THEN BEGIN
                                GlobalManagement.CreateJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                              Vendor."No.", Description + Text014, -DividendLine."Net Earning Amount", '', '', SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', DividendLine."Member No.");
                            END;
                        END;
                    end;

                UNTIL DividendLine.NEXT = 0;
            END;
            CLEARLASTERROR;
            IF GlobalManagement.PostJournal(DividendSetup."Dividend Template Name", DividendSetup."Dividend Batch Name") THEN BEGIN
                Posted := TRUE;
                if MODIFY then begin
                    if Confirm(SendDividendsNotificationConfirmMsg) then begin
                        RecRef.GetTable(DividendHeader);
                        SendNotification(RecRef);
                    end;
                end;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure IsDividendAccountType(DividendType: Option Both,Dividend,Interest; AccountTypeCode: Code[20]): Boolean
    var
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Code, AccountTypeCode);
        IF AccountType.FINDFIRST THEN BEGIN
            IF DividendType = DividendType::Dividend THEN BEGIN
                AccountType.SETRANGE("Earns Dividend", TRUE);
                EXIT(AccountType.FINDFIRST);
            END;
            IF DividendType = DividendType::Interest THEN BEGIN
                AccountType.SETRANGE("Earns Interest", TRUE);
                EXIT(AccountType.FINDFIRST);
            END;
            IF DividendType = DividendType::Both THEN BEGIN
                IF (AccountType."Earns Dividend") OR (AccountType."Earns Interest") THEN BEGIN
                    AccountType.MARK(TRUE);
                    AccountType.MARKEDONLY;
                    AccountType.COPY(AccountType);
                    EXIT(AccountType.FINDFIRST);
                END;
            END;
        END;
    end;

    procedure SendDividendsNotice(var DividendLine: Record "Dividend Line")
    var
        SMSText: BigText;
        DividendSetup: Record "Dividend Setup";
        Member: Record "Member";
    begin
        WITH DividendLine DO BEGIN
            SourceCodeSetup.GET;
            DividendSetup.GET;
            Member.GET(DividendLine."Member No.");
            IF DividendLine."Earning Type" = DividendLine."Earning Type"::Dividend THEN
                SMSText.ADDTEXT(STRSUBSTNO(DividendSetup."Dividend SMS Template", "Gross Earning Amount", "Net Earning Amount"));
            IF DividendLine."Earning Type" = DividendLine."Earning Type"::Interest THEN
                SMSText.ADDTEXT(STRSUBSTNO(DividendSetup."Interest SMS Template", "Gross Earning Amount", "Net Earning Amount"));
            GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Dividend);
        END;
    end;

    procedure GetLastRepaymentDate(LoanNo: Code[20]; EndDate: Date): Date
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        TransactionTypeCodeSetup.GET;
        TransactionTypeCodeSetup.TestField("Principal Paid");
        TransactionTypeCodeSetup.TestField("Interest Paid");

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
        CustLedgerEntry.SETFILTER(CustLedgerEntry."Transaction Type Code", '%1|%2', TransactionTypeCodeSetup."Principal Paid", TransactionTypeCodeSetup."Interest Paid");
        IF CustLedgerEntry.FINDLAST THEN
            EXIT(CustLedgerEntry."Posting Date");
    end;

    procedure BoostShares(var MemberExitLine: Record "Member Exit Line")
    var
        MemberExitHeader: Record "Member Exit Header";
        MemberExitHeader2: Record "Member Exit Header";
        AccountType: Record "Account Type";
        AccountType2: Record "Account Type";
        Amount: array[4] of Decimal;
        Error010: Label 'Member %1 does not have a Share Capital account';
        Error000: Label 'You cannot boost shares from %1 account';
        Text015: Label '-Shares Topup';
    begin
        ExitSetup.GET;
        SourceCodeSetup.GET;
        GlobalManagement.ClearJournal(ExitSetup."Shares Boosting Template Name", ExitSetup."Shares Boosting Batch Name");
        IF MemberExitLine.FINDFIRST THEN BEGIN
            MemberExitHeader.GET(MemberExitLine."Document No.");
            AccountType.GET(MemberExitLine."Account Type");
            IF NOT ((AccountType.Type = AccountType.Type::Savings) OR (AccountType.Type = AccountType.Type::"Member Deposit")) THEN
                ERROR(Error000, FORMAT(AccountType.Type))
            ELSE BEGIN
                AccountType2.RESET;
                AccountType2.SETRANGE(Type, AccountType2.Type::"Share Capital");
                IF AccountType2.FINDFIRST THEN;
                IF GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code) = '' THEN
                    ERROR(Error010, MemberExitHeader."Member Name");
                IF GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code)) < AccountType2."Minimum Balance" THEN BEGIN
                    Amount[1] := AccountType2."Minimum Balance" - GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code));
                    IF MemberExitLine."Account Balance" >= Amount[1] THEN
                        Amount[2] := Amount[1]
                    ELSE
                        Amount[2] := MemberExitLine."Account Balance";
                END;
                GlobalManagement.CreateJournal(ExitSetup."Shares Boosting Template Name", ExitSetup."Shares Boosting Batch Name", MemberExitLine."Document No.", MemberExitLine."Document No.", TODAY, AccountTypeEnum::Vendor,
                              MemberExitLine."Account No.", MemberExitHeader.Description + Text015, Amount[2], '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MemberExitHeader."Member No.");

                GlobalManagement.CreateJournal(ExitSetup."Shares Boosting Template Name", ExitSetup."Shares Boosting Batch Name", MemberExitLine."Document No.", MemberExitLine."Document No.", TODAY, AccountTypeEnum::Vendor,
                              GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code), MemberExitHeader.Description + Text015, -Amount[2], '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MemberExitHeader."Member No.");
                CLEARLASTERROR;
                IF GlobalManagement.PostJournal(ExitSetup."Shares Boosting Template Name", ExitSetup."Shares Boosting Batch Name") THEN BEGIN
                    MemberExitHeader.VALIDATE("Member No.");
                END ELSE BEGIN
                    IF GETLASTERRORTEXT <> '' THEN
                        ERROR(GETLASTERRORTEXT);
                END;
            END;
        END;
    end;

    local procedure GetAccountNo(MemberNo: Code[20]; AccountType: Code[20]): Code[20]
    var
        Vendor: Record "Vendor";
    begin
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", MemberNo);
        Vendor.SETRANGE("Account Type", AccountType);
        IF Vendor.FINDFIRST THEN
            EXIT(Vendor."No.");
    end;

    procedure ReverseMemberExit(var MembExit: Record "Member Exit Header")
    var
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        Memb: Record Member;
        Vendor: Record Vendor;
        DVend: Record "Detailed Vendor Ledg. Entry";
        AccTypes: Record "Account Type";
    begin
        with MembExit do begin
            GLEntry.Reset();
            GLEntry.SetRange(GLEntry."Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            if Memb.Get("Member No.") then begin
                Memb.Status := Memb.Status::Active;
                Memb.Modify();

                vendor.Reset();
                vendor.SetRange("Member No.", Memb."No.");
                if vendor.FindSet() then begin
                    repeat
                        Vendor.Status := vendor.Status::Active;
                        vendor.Modify();

                        IF AccTypes.Get(Vendor."Account Type") then begin
                            If AccTypes.Type = AccTypes.Type::"Member Deposit" then begin
                                DVend.Reset();
                                DVend.SetCurrentKey("Posting Date");
                                DVend.SetRange(DVend."Vendor No.", vendor."No.");
                                DVend.SetFilter(DVend."Credit Amount", '>%1', 0);
                                If DVend.FindLast() then begin
                                    if DVend."Posting Date" <= CalcDate('-3M', Today) then begin
                                        vendor.Status := vendor.Status::Dormant;
                                        vendor.Modify();
                                    end;
                                end;

                                DVend.Reset();
                                DVend.SetCurrentKey("Posting Date");
                                DVend.SetRange(DVend."Vendor No.", vendor."No.");
                                DVend.SetFilter(DVend."Credit Amount", '>%1', 0);
                                If not DVend.FindLast() then begin
                                    if CalcDate('-3M', Today) >= Memb."Registration Date" then begin
                                        vendor.Status := vendor.Status::Dormant;
                                        vendor.Modify();
                                    end;
                                end;

                                Memb."Dormancy Status" := vendor.Status;
                                Memb.Modify();
                            end;
                        end;
                    until vendor.Next = 0;
                end;
            end;
            Posted := false;
            Status := Status::New;
            "Posted By" := '';
            "Date Posted" := 0D;
            "Time Posted" := 0T;
            Modify();
        end;
    end;

    procedure PostMemberExit(var MembExit: Record "Member Exit Header")
    var
        ExitSetup: Record "Exit Setup";
        ExitReasons: Record "Exit Reason";
        TTypeCodeSetup: Record "Transaction Type Code Setup";
        SCodeSetup: Record "Source Code Setup";
        Memb: Record Member;
        Dep: Code[20];
        Bor: Code[20];
        Nex: Code[20];
        vendor: Record Vendor;
        Ac: Record "Account Type";
    begin
        with MembExit do begin
            ExitSetup.Get();
            TTypeCodeSetup.Get();
            SCodeSetup.Get();
            ExitReasons.Get("Reason Code");

            vendor.Reset();
            vendor.SetRange("Member No.", MembExit."Member No.");
            if vendor.FindSet() then begin
                repeat
                    If Ac.Get(vendor."Account Type") then begin
                        if Ac.Type = Ac.Type::"Member Deposit" then
                            Dep := vendor."No.";
                        if (Ac.Type = Ac.Type::Savings) and (Ac."Sub Type" = Ac."Sub Type"::Boresha) then
                            Bor := vendor."No.";
                        if (Ac.Type = Ac.Type::Savings) and (Ac."Sub Type" = Ac."Sub Type"::NXTGen) then
                            Nex := vendor."No.";
                    end;
                until vendor.Next = 0;
            end;
            GlobalManagement.ClearJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name");
            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", MembExit."No.", MembExit."No.", MembExit."Payment Date", AccountTypeEnum::"Bank Account",
                          MembExit."Paying Bank", Description, MembExit."Net Payment" * -1, '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MembExit."Member No.");
            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", MembExit."No.", MembExit."No.", MembExit."Payment Date", AccountTypeEnum::Vendor,
                          Dep, Description, MembExit."Member Deposits", '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MembExit."Member No.");
            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", MembExit."No.", MembExit."No.", MembExit."Payment Date", AccountTypeEnum::Vendor,
                          Bor, Description, MembExit."Boresha Savings", '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MembExit."Member No.");
            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", MembExit."No.", MembExit."No.", MembExit."Payment Date", AccountTypeEnum::Vendor,
                          Nex, Description, MembExit."Next Gen Savings", '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MembExit."Member No.");
            Customer.Reset();
            Customer.SetRange("Member No.", MembExit."Member No.");
            if Customer.FindSet() then begin
                repeat
                    Customer.CalcFields(Balance);
                    if Customer.Balance <> 0 then begin
                        GlobalManagement.DeductLoanArrearsMembExit(TTypeCodeSetup, SCodeSetup, ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", MembExit."No.", MembExit."No.", MembExit."Payment Date", Customer."No.", Customer.Balance, Customer."Global Dimension 1 Code");
                    end;
                until Customer.Next = 0;
            end;
            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", MembExit."No.", MembExit."No.", MembExit."Payment Date", AccountTypeEnum::"G/L Account",
              '5417', Description, "Exit Fee" * -1, '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MembExit."Member No.");
            If GlobalManagement.PostJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name") then begin
                if Memb.Get(MembExit."Member No.") then begin
                    Memb.Status := ExitReasons.Status;
                    Memb.Modify();

                    vendor.Reset();
                    vendor.SetRange("Member No.", Memb."No.");
                    if vendor.FindSet() then begin
                        repeat
                            vendor.Status := vendor.Status::Closed;
                            vendor.Modify;
                        until vendor.Next = 0;
                    end;
                end;

                MembExit."Posted By" := UserId;
                MembExit."Date Posted" := Today;
                MembExit."Time Posted" := Time;
                MembExit.Posted := true;
                MembExit.Modify();
            end else begin
                Error(GetLastErrorText());
            end;
        end;
    end;

    procedure ProcessMemberArchive(var MembArchive: Record "Member Achive Header")
    var
        ExitSetup: Record "Exit Setup";
        TTypeCodeSetup: Record "Transaction Type Code Setup";
        SCodeSetup: Record "Source Code Setup";
        Memb: Record Member;
        Dep: Code[20];
        Bor: Code[20];
        Nex: Code[20];
        vendor: Record Vendor;
        Ac: Record "Account Type";
    begin
        with MembArchive do begin
            ExitSetup.Get();
            TTypeCodeSetup.Get();
            SCodeSetup.Get();

            vendor.Reset();
            vendor.SetRange("Member No.", MembArchive."Member No.");
            if vendor.FindSet() then begin
                repeat
                    If Ac.Get(vendor."Account Type") then begin
                        if Ac.Type = Ac.Type::"Member Deposit" then
                            Dep := vendor."No.";
                        if (Ac.Type = Ac.Type::Savings) and (Ac."Sub Type" = Ac."Sub Type"::Boresha) then
                            Bor := vendor."No.";
                        if (Ac.Type = Ac.Type::Savings) and (Ac."Sub Type" = Ac."Sub Type"::NXTGen) then
                            Nex := vendor."No.";
                    end;
                    vendor.Blocked := vendor.Blocked::All;
                    vendor.Status := vendor.Status::Blocked;
                    vendor.Modify;
                until vendor.Next = 0;
            end;

            Customer.Reset();
            Customer.SetRange("Member No.", MembArchive."Member No.");
            if Customer.FindSet() then begin
                repeat
                    Customer.CalcFields(Balance);
                    if Customer.Balance <> 0 then begin
                    end;
                    Customer.Blocked := Customer.Blocked::All;
                    Customer.Status := Customer.Status::Blocked;
                    Customer.Modify;
                until Customer.Next = 0;
            end;

            if Memb.Get(MembArchive."Member No.") then begin
                Memb.Status := Memb.Status::Blocked;
                Memb.Modify();
            end;

            MembArchive."Posted By" := UserId;
            MembArchive."Date Posted" := Today;
            MembArchive."Time Posted" := Time;
            MembArchive.Posted := true;
            MembArchive.Modify();
            Message('Member Archive is complete. Accounts belonging to this member will no longer be able to perform any transactions');
        end;
    end;

    procedure PostLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    var
        LoanWriteoffLine: Record "Loan Writeoff Line";
        LoanWriteoffSetup: Record "Loan Writeoff Setup";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
    begin
        WITH LoanWriteoffHeader DO BEGIN
            LoanWriteoffSetup.GET;
            SourceCodeSetup.GET;
            LoanWriteoffSetup.GET;
            TransactionTypeCodeSetup.Get();
            CALCFIELDS("Total Writeoff Amount");
            SourceCodeSetup.TestField("Loan Writeoff");
            LoanWriteoffSetup.TESTFIELD("LW G/L Control Account");
            GlobalManagement.ClearJournal(LoanWriteoffSetup."Loan Writeoff Template Name", LoanWriteoffSetup."Loan Writeoff Batch Name");
            GlobalManagement.CreateJournal(LoanWriteoffSetup."Loan Writeoff Template Name", LoanWriteoffSetup."Loan Writeoff Batch Name", LoanWriteoffHeader."No.", LoanWriteoffLine."Document No.", TODAY, AccountTypeEnum::"G/L Account",
                          LoanWriteoffSetup."LW G/L Control Account", Description, "Total Writeoff Amount", '', '', SourceCodeSetup."Loan Writeoff", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');

            LoanWriteoffLine.RESET;
            LoanWriteoffLine.SETRANGE("Document No.", "No.");
            IF LoanWriteoffLine.FINDSET THEN BEGIN
                REPEAT
                    LoanWriteoffLine.TESTFIELD("Loan No.");
                    //GlobalManagement.CreateJournal(LoanWriteoffSetup."Loan Writeoff Template Name", LoanWriteoffSetup."Loan Writeoff Batch Name", LoanWriteoffLine."Document No.", LoanWriteoffLine."Document No.", TODAY, AccountTypeEnum::Customer,
                    //LoanWriteoffLine."Loan No.", Description, LoanWriteoffLine."Outstanding Balance", '', '', SourceCodeSetup."Loan Writeoff", LoanWriteoffLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    GlobalManagement.DeductLoanArrearsLoanWriteOff(TransactionTypeCodeSetup, SourceCodeSetup, LoanWriteoffSetup."Loan Writeoff Template Name", LoanWriteoffSetup."Loan Writeoff Batch Name", LoanWriteoffHeader."No.",
                    LoanWriteoffHeader."No.", Today, LoanWriteoffLine."Loan No.", LoanWriteoffLine."Outstanding Balance", '');
                UNTIL LoanWriteoffLine.NEXT = 0;
            END;
            IF GlobalManagement.PostJournal(LoanWriteoffSetup."Loan Writeoff Template Name", LoanWriteoffSetup."Loan Writeoff Batch Name") THEN BEGIN
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date" := TODAY;
                "Posted Time" := TIME;
                //ClearLoan();
            END;
        END;
    end;

    local procedure ClearLoan(LoanNo: Code[20])
    var
        LoanApplication: Record "Loan Application";
    begin
        IF LoanApplication.GET(LoanNo) THEN BEGIN
            LoanApplication.Cleared := TRUE;
            LoanApplication.MODIFY;

            Customer.GET(LoanNo);
            //Customer.Status:=Customer.Status::Closed;
            Customer.MODIFY;
        END;
    end;

    procedure PostExitFee(var MemberExitHeader: Record "Member Exit Header")
    var
        ExitReason: Record "Exit Reason";
        ExitSetup: Record "Exit Setup";
        ExitReasonFee: Record "Exit Reason Fee";
        ExitFee: Record "Exit Fee";
        Text018: Label 'Exit Fees posted successfully';
    begin
        WITH MemberExitHeader DO BEGIN
            ExitSetup.GET;
            SourceCodeSetup.GET;
            ExitSetup.GET;

            SourceCodeSetup.TestField("Member Exit");
            GlobalManagement.ClearJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name");
            ExitReasonFee.RESET;
            ExitReasonFee.SETRANGE("Reason Code", "Reason Code");
            IF ExitReasonFee.FINDSET THEN BEGIN
                REPEAT
                    IF ExitFee.GET(ExitReasonFee.Code) THEN BEGIN
                        IF ExitFee."Earning Party" = ExitFee."Earning Party"::Sacco THEN BEGIN
                            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                          GetAccountNo("Member No.", ExitSetup."Debit FOSA Account Type"), Description, ExitReasonFee.Amount, '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MemberExitHeader."Member No.");
                            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                                          ExitSetup."Income G/L Account", Description, -ExitReasonFee.Amount, '', SourceCodeSetup."Member Exit", '', '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MemberExitHeader."Member No.");
                        END;
                        IF ExitFee."Earning Party" = ExitFee."Earning Party"::Member THEN BEGIN
                            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", "No.", "No.", TODAY, ExitSetup."Expense Account Type",
                                          ExitSetup."Expense Account No.", Description, ExitReasonFee.Amount, '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MemberExitHeader."Member No.");
                            GlobalManagement.CreateJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                          GetAccountNo("Member No.", ExitSetup."Credit FOSA Account Type"), Description, -ExitReasonFee.Amount, '', '', SourceCodeSetup."Member Exit", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', MemberExitHeader."Member No.");
                        END;
                    END;
                UNTIL ExitReasonFee.NEXT = 0;
            END;
            IF GlobalManagement.PostJournal(ExitSetup."Exit Template Name", ExitSetup."Exit Batch Name") THEN BEGIN
                MESSAGE(Text018);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    procedure GenerateAgencyRemittanceHeader(AgencyCode: Code[20]; RemittancePeriodDate: Date; var DocumentNo: Code[20])
    var
        AgencyRemittanceHeader: Record "Agency Remittance Header";
        RemittancePeriod: Record "Remittance Period";
        LineNo: Integer;
        Text019: Label 'Remittance for %1 %2';
    begin
        RemittanceSetup.GET;
        AgencyRemittanceHeader."No." := '';
        AgencyRemittanceHeader.VALIDATE("Agent Code", AgencyCode);
        IF RemittancePeriod.GET(RemittancePeriodDate) THEN;
        AgencyRemittanceHeader.Description := STRSUBSTNO(Text019, RemittancePeriod.Month, FORMAT(RemittancePeriod.Year));
        AgencyRemittanceHeader."Period Month" := RemittancePeriod.Month;
        AgencyRemittanceHeader."Period Year" := RemittancePeriod.Year;
        IF AgencyRemittanceHeader.INSERT(TRUE) THEN
            DocumentNo := AgencyRemittanceHeader."No.";
    end;

    procedure GenerateAgencyRemittanceLine(MemberRemittanceHeader: Record "Member Remittance Header"; MemberRemittanceLine: Record "Member Remittance Line"; DocumentNo: Code[20])
    var
        AgencyRemittanceLine: Record "Agency Remittance Line";
        AgencyRemittanceLine2: Record "Agency Remittance Line";
        LineNo: Integer;
    begin
        AgencyRemittanceLine."Document No." := DocumentNo;
        AgencyRemittanceLine2.RESET;
        AgencyRemittanceLine2.SETRANGE("Document No.", DocumentNo);
        IF AgencyRemittanceLine2.FINDLAST THEN
            LineNo := AgencyRemittanceLine2."Line No."
        ELSE
            LineNo := 0;
        AgencyRemittanceLine."Line No." := LineNo + 10000;
        AgencyRemittanceLine."Member No." := MemberRemittanceHeader."Member No.";
        AgencyRemittanceLine."Member Name" := MemberRemittanceHeader."Member Name";
        AgencyRemittanceLine."Account Category" := MemberRemittanceLine."Account Category";
        AgencyRemittanceLine."Account Type" := MemberRemittanceLine."Account Type";
        AgencyRemittanceLine."Account No." := MemberRemittanceLine."Account No.";
        AgencyRemittanceLine."Account Name" := MemberRemittanceLine."Account Name";
        AgencyRemittanceLine."Contribution Type" := MemberRemittanceLine."Contribution Type";
        AgencyRemittanceLine."Remittance Code" := MemberRemittanceLine."Remittance Code";
        AgencyRemittanceLine."Expected Amount" := MemberRemittanceLine."Actual Amount";
        AgencyRemittanceLine.INSERT;
    end;

    procedure PostAgencyRemittance(var AgencyRemittanceHeader: Record "Agency Remittance Header")
    var
        AgencyRemittanceLine: Record "Agency Remittance Line";
        SourceCode: Code[20];
        RemittanceAgentSetup: Record "Remittance Agent Setup";
    begin
        WITH AgencyRemittanceHeader DO BEGIN
            RemittanceSetup.GET;
            SourceCodeSetup.GET;
            CALCFIELDS("Total Actual Amount");
            RemittanceAgentSetup.GET("Agent Code");

            SourceCodeSetup.TestField(Remittance);
            /*
                        GlobalManagement.ClearJournal(RemittanceSetup."Remittance Template Name", RemittanceSetup."Remittance Batch Name");
                        AgencyRemittanceLine.RESET;
                        AgencyRemittanceLine.SETRANGE("Document No.", "No.");
                        IF AgencyRemittanceLine.FINDSET THEN BEGIN
                            REPEAT
                                SourceCode := SourceCodeSetup.Remittance;
                                IF AgencyRemittanceLine."Account Category" = AgencyRemittanceLine."Account Category"::Vendor THEN BEGIN
                                    GlobalManagement.CreateJournal(RemittanceSetup."Remittance Template Name", RemittanceSetup."Remittance Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Vendor,
                                                  AgencyRemittanceLine."Account No.", Description, AgencyRemittanceLine."Actual Amount", '', '', SourceCodeSetup.Remittance, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                END;
                                IF AgencyRemittanceLine."Account Category" = AgencyRemittanceLine."Account Category"::Customer THEN BEGIN
                                    IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::"Principal Due" THEN
                                        SourceCode := SourceCodeSetup.Loan;
                                    IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::"Interest Due" THEN
                                        SourceCode := SourceCodeSetup.Loan;
                                    IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::Insurance THEN
                                        SourceCode := SourceCodeSetup.Loan;
                                    GlobalManagement.CreateJournal(RemittanceSetup."Remittance Template Name", RemittanceSetup."Remittance Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Customer,
                                                  AgencyRemittanceLine."Account No.", Description, AgencyRemittanceLine."Actual Amount", '', '', SourceCodeSetup.Remittance, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                END;
                            UNTIL AgencyRemittanceLine.NEXT = 0;
                        END;
                        GlobalManagement.CreateJournal(RemittanceSetup."Remittance Template Name", RemittanceSetup."Remittance Batch Name", "No.", "No.", TODAY, RemittanceAgentSetup."Account Type",
                                      RemittanceAgentSetup."Account No.", Description, -"Total Actual Amount", '', '', SourceCodeSetup.Remittance, '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                        IF GlobalManagement.PostJournal(RemittanceSetup."Remittance Template Name", RemittanceSetup."Remittance Batch Name") THEN BEGIN
                            Status := Status::Posted;
                            MODIFY;
                        END ELSE BEGIN
                            IF GETLASTERRORTEXT <> '' THEN
                                ERROR(GETLASTERRORTEXT);
                        END;
                        */
        END;
    end;

    procedure PostLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    var
        LoanSelloffCharge: Record "Loan Selloff Charge";
        ChargeAmount: Decimal;
        LoanSelloffSetup: Record "Loan Selloff Setup";
    begin
        WITH LoanSelloff DO BEGIN
            GlobalSetup.GET;
            SourceCodeSetup.GET;
            LoanSelloffSetup.GET;
            CALCFIELDS("Outstanding Balance");
            GlobalManagement.ClearJournal(LoanSelloffSetup."Loan Selloff Template Name", LoanSelloffSetup."Loan Selloff Batch Name");
            /*
             GlobalManagement.CreateJournal(LoanSelloffSetup."Loan Selloff Template Name", LoanSelloffSetup."Loan Selloff Batch Name", "No.", "No.", TODAY, AccountTypeEnum::Customer,
                           "Loan No.", Description, -"Outstanding Balance", '', '', SourceCodeSetup."Loan Selloff", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
             LoanSelloffCharge.RESET;
             IF LoanSelloffCharge.FINDSET THEN BEGIN
                 REPEAT
                     IF (("Outstanding Balance" >= LoanSelloffCharge."Minimum Amount") AND ("Outstanding Balance" <= LoanSelloffCharge."Maximum Amount")) THEN BEGIN
                         IF LoanSelloffCharge."Calculation Method" = LoanSelloffCharge."Calculation Method"::"Flat Amount" THEN
                             ChargeAmount := LoanSelloffCharge.Amount;
                         IF LoanSelloffCharge."Calculation Method" = LoanSelloffCharge."Calculation Method"::"%" THEN
                             ChargeAmount := LoanSelloffCharge.Amount / 100 * "Outstanding Balance"
                     END;
                 UNTIL LoanSelloffCharge.NEXT = 0;
             END;
             LoanSelloffSetup.TESTFIELD("Income G/L Account");
             GlobalManagement.CreateJournal(LoanSelloffSetup."Loan Selloff Template Name", LoanSelloffSetup."Loan Selloff Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"G/L Account",
                           LoanSelloffSetup."Income G/L Account", Description, -ChargeAmount, '', '', SourceCodeSetup."Loan Selloff", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

             LoanSelloffSetup.TESTFIELD("Receiving Bank Account");
             GlobalManagement.CreateJournal(LoanSelloffSetup."Loan Selloff Template Name", LoanSelloffSetup."Loan Selloff Batch Name", "No.", "No.", TODAY, AccountTypeEnum::"Bank Account",
                           LoanSelloffSetup."Receiving Bank Account", Description, (ChargeAmount + "Outstanding Balance"), '', '', SourceCodeSetup."Loan Selloff", '', BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
             IF GlobalManagement.PostJournal(LoanSelloffSetup."Loan Selloff Template Name", LoanSelloffSetup."Loan Selloff Batch Name") THEN BEGIN
                 Posted := TRUE;
                 MODIFY;
             END ELSE BEGIN
                 IF GETLASTERRORTEXT <> '' THEN
                     ERROR(GETLASTERRORTEXT);
             END;
             */
        END;
    end;

    procedure ReverseLoan(var LoanApplication: Record "Loan Application")
    var
        LoanReversalSuccessMsg: Label 'Loan %1 has been reversed successfully';
        CustL: Record "Cust. Ledger Entry";
        TotalLoanTrans: Integer;
        TotalLoanTransReversed: Integer;
    begin
        with LoanApplication do begin

            CustL.Reset();
            CustL.SetRange("Customer No.", "No.");
            CustL.SetFilter("Document No.", '<>%1', "No.");
            If CustL.FindSet() then begin
                TotalLoanTrans := CustL.Count;
            end;
            CustL.Reset();
            CustL.SetRange("Customer No.", "No.");
            CustL.SetFilter("Document No.", '<>%1', "No.");
            CustL.SetRange(Reversed, true);
            If CustL.FindSet() then begin
                TotalLoanTransReversed := CustL.Count;
            end;

            If TotalLoanTransReversed <> TotalLoanTrans then
                Error('Kindly ensure all transactions posted after loan disbursement are all reversed to proceed');

            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
            Reversed := true;
            posted := false;
            if Modify() then
                Message(LoanReversalSuccessMsg, "No.");
        end;
    end;

    procedure CalculateOtherGuaranteedAmount(MemberNo: Code[20]; LoanNo: Code[20]): Decimal
    var
        TotalGuaranteedAmount: Decimal;
        LoanGuarantor: Record "Loan Guarantor";
        LoanApplication: Record "Loan Application";
        Vend: Record Vendor;
        DepBal: Decimal;
        GuaranteedAmount: Decimal;
    begin
        TotalGuaranteedAmount := 0;
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Member No.", MemberNo);
        LoanGuarantor.SetRange("Loan No.", '<>%1', LoanNo);
        if LoanGuarantor.FindSet() then begin
            repeat
                LoanApplication.Get(LoanGuarantor."Loan No.");
                LoanApplication.CalcFields("Outstanding Balance");
                if ((LoanApplication."Outstanding Balance" > 0)) then begin
                    TotalGuaranteedAmount += (LoanGuarantor."Amount To Guarantee" / LoanApplication."Approved Amount") * LoanApplication."Outstanding Balance";
                    GuaranteedAmount += LoanGuarantor."Amount To Guarantee";
                end;
            until LoanGuarantor.Next() = 0;
            if TotalGuaranteedAmount > GuaranteedAmount then
                TotalGuaranteedAmount := GuaranteedAmount;
        end;
        exit(TotalGuaranteedAmount);
    end;

    procedure CalculateOtherLoanBalances(MemberNo: Code[20]): Decimal
    var
        TotalLoanBalance: Decimal;
    begin
        TotalLoanBalance := 0;
        Customer.Reset();
        Customer.SetRange("Member No.", MemberNo);
        if Customer.FindSet() then begin
            repeat
                Customer.CalcFields("Balance (LCY)");
                if Customer."Balance (LCY)" > 0 then
                    TotalLoanBalance += Customer."Balance (LCY)";
            until Customer.Next() = 0;
        end;
        exit(TotalLoanBalance)
    end;

    procedure LoanOverpaymentTransfer(Customer: Record Customer)
    var

    begin
        with Customer do begin
            LoanApplicationSetup.Get();
            SourceCodeSetup.Get();
            SourceCodeSetup.TestField("Loan Overpayment");

            JournalTemplateName := LoanApplicationSetup."Loan Overpayment Template Name";
            JournalBatchName := LoanApplicationSetup."Loan Overpayment Batch Name";
            CalcFields("Balance (LCY)");

            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, AccountTypeEnum::Customer, "No.", 'Overpayment Transfer-' + "No.", abs("Balance (LCY)"), '', '', SourceCodeSetup.Loan,
                     "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");

            GlobalManagement.CreateJournal(JournalTemplateName, JournalBatchName, "No.", "No.", Today, AccountTypeEnum::Vendor, GlobalManagement.GetOverpaymentAccount(Customer."Member No."), 'Overpayment Transfer' + "No.", -abs("Balance (LCY)"), '', '', '',
                          "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', Customer."Member No.");
        end;
    end;


    procedure postEloan(RequestID: Text; MemberNo: Code[20]; LoanAmountApplied: Decimal; TChargeAmount: Decimal) LoanNo: Code[20]
    var
        Member: Record Member;
        LoanApplication: Record "Loan Application";
    begin
        IF Member.GET(MemberNo) THEN BEGIN
            LoanNo := createEloanAccount(LoanAmountApplied, Member."Phone No.", TChargeAmount);
            IF LoanApplication.GET(LoanNo) THEN BEGIN
                IF DisburseELoanToMpesa(LoanApplication, RequestID, TChargeAmount) THEN BEGIN
                    EXIT(LoanNo);
                END ELSE
                    EXIT('');
            END;
        END ELSE BEGIN
            EXIT('');
        END;
    end;

    procedure createEloanAccount(VAR Amount: Decimal; VAR Phoneno: Code[100]; TChargeAmount: Decimal) LoanNo: Code[20]
    var
        LoanApplication: Record "Loan Application";
        LoanNumber: code[20];
    begin
        LoanApplicationSetup.GET;
        LoanApplicationSetup.TestField("Loan Application Nos.");

        LoanProductType.RESET;
        LoanProductType.SETRANGE("E-Loan", TRUE);
        IF LoanProductType.FINDSET THEN BEGIN
            Member.RESET;
            Member.SETRANGE("Phone No.", Phoneno);
            IF Member.FINDSET THEN BEGIN
                LoanNumber := NoSeriesManagement.GetNextNo(LoanApplicationSetup."Loan Application Nos.", TODAY, TRUE);
                LoanApplication.INIT;
                LoanApplication."No." := LoanNumber;
                LoanApplication."Member No." := Member."No.";
                LoanApplication."Member Name" := Member."Full Name";
                LoanApplication."Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                LoanApplication."Loan Product Type" := LoanProductType.Code;
                LoanApplication.Description := LoanProductType.Description;
                LoanApplication."Interest Rate" := LoanProductType."Interest Rate";
                LoanApplication."Repayment Period" := LoanProductType."Repayment Period";
                LoanApplication."Repayment Method" := LoanProductType."Repayment Method";
                LoanApplication."Requested Amount" := Amount;
                LoanApplication."Approved Amount" := Amount;
                LoanApplication."Mobile Loan Transaction Charges" := TChargeAmount;
                LoanApplication."No. Series" := LoanApplicationSetup."Loan Application Nos.";
                LoanApplication.Status := LoanApplication.Status::Approved;
                LoanApplication."Disbursal Date" := today;
                LoanApplication."Date of Completion" := TODAY;
                LoanApplication."Next Due Date" := CALCDATE('1M', TODAY);
                LoanApplication."Created Date" := TODAY;
                LoanApplication."Created Time" := TIME;
                LoanApplication."Repayment Frequency" := LoanProductType."Repayment Frequency";
                IF LoanApplication.INSERT THEN BEGIN
                    CreateLoanAccount(LoanApplication);
                    LoanNo := LoanNumber;
                END;
            END;
        END;
        EXIT(LoanNo);
    end;

    procedure DisburseELoanToMpesa(var LoanApplication: Record "Loan Application"; RequestID: text; TChargeAmount: Decimal) ReturnValue: Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        LoanProductCharge: Record "Loan Product Charge";
        RecRef: RecordRef;
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
        DisbursalAmount: Decimal;
        Text000: Label 'Loan Refinancing-';
        LoanProductType: Record "Loan Product Type";
        TransactionTypeCode: Code[20];
        LoanChargeSetup: Record "Loan Charge Setup";
        TotalCharges: Decimal;
        StartDate: date;
        Installments: Integer;
        BosaM: Codeunit "BOSA Management";
        Memb: Record Member;
        ProdCharge: decimal;
        PostingBankAccount: Code[20];
        BankAccount: Record "Bank Account";
        LoanAmounts: array[5] of Decimal;
        MobileSetup: Record "Mobile Banking Setup";
        ChargeAmount: array[5] of decimal;
        lineNo: integer;
        InterestCharged: Decimal;
        PinnoAmount: Decimal;
    begin
        WITH LoanApplication DO BEGIN
            LoanApplicationSetup.GET;
            MobileSetup.get();
            SourceCodeSetup.GET;
            TransactionTypeCodeSetup.Get();
            DisbursalAmount := "Approved Amount";
            PostingBankAccount := '';
            BankAccount.RESET;
            BankAccount.SETRANGE("No.", Mobilesetup."Mpesa B2C");
            IF BankAccount.FINDFIRST THEN BEGIN
                PostingBankAccount := BankAccount."No.";
            END;
            IF LoanProductType.GET("Loan Product Type") THEN;
            IF LoanProductType."Interest Rate" > 0 THEN
                LoanAmounts[1] := DisbursalAmount * (LoanProductType."Interest Rate" / 100);//12);
                                                                                            //   LoanAmounts[1] := DisbursalAmount * (LoanProductType."Interest Rate" / 12 / 100);
            DisbursalAmount := "Approved Amount";
            LoanAmounts[2] := 0;
            LoanAmounts[2] := FetchTotalCharges(LoanApplication);
            LoanAmounts[3] := DisbursalAmount - LoanAmounts[2];
            LoanAmounts[4] := DisbursalAmount - LoanAmounts[1];// - LoanAmounts[2];
            SourceCodeSetup.TestField(Loan);
            LoanApplicationSetup.TestField("Loan Disbursal Template Name");
            LoanApplicationSetup.TestField("Loan Disbursal Batch Name");
            TransactionTypeCodeSetup.TestField("New Loan");
            TransactionTypeCodeSetup.TestField("Processing Fee");
            TransactionTypeCodeSetup.TestField("Insurance Fee");
            TransactionTypeCodeSetup.TestField("Refinancing Fee");
            TransactionTypeCodeSetup.TestField("Ledger Fee Due");

            CALCFIELDS("Total Refinanced Amount");
            IF "Approved Amount" = 0 then
                "Approved Amount" := "Requested Amount";

            InterestCharged := 0;
            PinnoAmount := 0;
            InterestCharged := Round("Approved Amount" * (LoanProductType."Interest Rate" / 12 / 100));
            If ("Approved Amount" >= 1000) and ("Approved Amount" <= 3000) then
                PinnoAmount := 20;
            If "Approved Amount" > 3000 then
                PinnoAmount := 100;

            CreateLoanAccount(LoanApplication);
            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");
            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::Customer, "No.", Description + '_' + "Member Name", "Approved Amount",
            LoanProductType."Loan Posting Group", TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::"Bank Account", PostingBankAccount, Description + '_' + "Member Name", -("Approved Amount"),
            '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::"G/L Account", LoanApplicationSetup."Mobile Loan DCharges Account", Description + '_' + "Member Name" + '_Disbursment Charges', TChargeAmount,
            LoanProductType."Loan Posting Group", TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::"Bank Account", PostingBankAccount, Description + '_' + "Member Name" + '_Disbursment Charges', -TChargeAmount,
            '', TransactionTypeCodeSetup."New Loan", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::Customer, "No.", Description + '_' + "Member Name" + '_Interest Due', InterestCharged,
            LoanProductType."Interest Paid Posting Group", TransactionTypeCodeSetup."Interest Due", SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::"G/L Account", LoanProductType."Interest Paid Posting Group", Description + '_' + "Member Name" + '_Interest Due', -InterestCharged,
            '', '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::"G/L Account", LoanProductType."Interest Due Posting Group", Description + '_' + "Member Name" + '_ Pinnoserv Commision', PinnoAmount,
            '', '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");
            GlobalManagement.CreateJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name", RequestID, "No.", "Disbursal Date", AccountTypeEnum::"G/L Account", LoanApplicationSetup."Pinno Comm On Mobile Loan Int Account", Description + '_' + "Member Name" + '_ Pinnoserv Commision', -PinnoAmount,
            '', '', SourceCodeSetup.Loan, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "Member No.");

            if "Disbursal Date" = 0D then begin
                StartDate := "Created Date";
            end else begin
                StartDate := "Disbursal Date";
                "Next Due Date" := CalcDate('1M', "Disbursal Date");
                "Date of Completion" := CalcDate("Repayment Period", "Disbursal Date");
                Modify();
            end;

            //IF GlobalManagement.PostJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name") THEN BEGIN
            //GlobalManagement.PostJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");
            Posted := TRUE;
            "Disbursed By" := USERID;
            "Disbursal Date" := "Disbursal Date";
            "Disbursal Time" := TIME;
            "Created By" := USERID;
            "Next Due Date" := CalcDate('1M', "Disbursal Date");
            "Date of Completion" := CalcDate("Repayment Period", "Disbursal Date");
            IF MODIFY THEN BEGIN
                CreateRepaymentSchedule("No.", "Approved Amount");
                RecRef.GetTable(LoanApplication);
            END;
            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Disbursal Template Name", LoanApplicationSetup."Loan Disbursal Batch Name");
            /*END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN BEGIN
                    IF Customer.GET("No.") THEN
                        Customer.DELETE;
                    ERROR(GETLASTERRORTEXT);
                END;
            END;*/
        END;
        ReturnValue := true;
        exit(ReturnValue);
    end;

    local procedure FetchTotalCharges(LoanApplication: Record "Loan Application") TotalCharges: decimal
    var
        LoanProductCharge: Record "Loan Product Charge";
        ChargeAmount: array[3] of Decimal;
    begin
        WITH LoanApplication DO BEGIN
            LoanProductCharge.RESET;
            LoanProductCharge.SETRANGE("Loan Product Type", "Loan Product Type");
            IF LoanProductCharge.FINDSET THEN BEGIN
                ChargeAmount[1] := 0;
                ChargeAmount[2] := 0;
                REPEAT
                    IF (LoanProductCharge.Value <> 0) and (LoanProductCharge."Account No." <> '') THEN BEGIN
                        IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" THEN BEGIN
                            ChargeAmount[1] += ABS((LoanProductCharge.Value) * "Approved Amount") / 100;
                        END;
                        IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"Flat Amount" THEN BEGIN
                            ChargeAmount[1] += ABS(LoanProductCharge.Value);
                        END;
                        IF (LoanProductCharge."Pinno Value" <> 0) AND (LoanProductCharge."Pinno Account No" <> '') THEN BEGIN
                            IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" THEN BEGIN
                                ChargeAmount[2] += ABS((LoanProductCharge."Pinno Value") * "Approved Amount") / 100;
                            END;
                            IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"Flat Amount" THEN BEGIN
                                ChargeAmount[2] += ABS(LoanProductCharge."Pinno Value");
                            END;
                        END;
                    END;
                UNTIL LoanProductCharge.NEXT = 0;
            END;
        END;
        TotalCharges := ChargeAmount[1];
        EXIT(TotalCharges);
    end;

    procedure fnGetmemberNo(loanNo: Code[35]) memberNo: Code[35]
    var
        loanApp: record "Loan Application";
        memb: record Member;
        vendor: Record Vendor;
    begin
        loanApp.Reset();
        loanApp.SetRange("No.", loanNo);
        if loanApp.Find('-') then begin
            memb.Reset();
            memb.SetRange("No.", loanApp."Member No.");
            if memb.Find('-') then begin
                vendor.Reset();
                vendor.SetFilter("Account Type", '%1', '02');
                vendor.SetRange("Member No.", memb."No.");
                if vendor.Find('-') then begin
                    memberNo := vendor."Member No.";
                end;
            end;
        end;
        exit(memberNo);
    end;

    procedure createDefaulterloanAccount(VAR Amount: Decimal; VAR Phoneno: Code[100]) LoanNo: Code[20]
    var
        LoanApplication: Record "Loan Application";
        LoanNumber: code[20];
    begin
        LoanApplicationSetup.GET;
        LoanApplicationSetup.TestField("Loan Application Nos.");

        LoanProductType.RESET;
        LoanProductType.SETRANGE(code, 'DL');
        IF LoanProductType.FINDSET THEN BEGIN
            Member.RESET;
            Member.SETRANGE("Phone No.", Phoneno);
            IF Member.FINDSET THEN BEGIN
                LoanNumber := NoSeriesManagement.GetNextNo(LoanApplicationSetup."Loan Application Nos.", TODAY, TRUE);
                LoanApplication.INIT;
                LoanApplication."No." := LoanNumber;
                LoanApplication."Member No." := Member."No.";
                LoanApplication."Member Name" := Member."Full Name";
                LoanApplication."Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                LoanApplication."Loan Product Type" := LoanProductType.Code;
                LoanApplication.Description := LoanProductType.Description;
                LoanApplication."Interest Rate" := LoanProductType."Interest Rate";
                LoanApplication."Repayment Period" := LoanProductType."Repayment Period";
                LoanApplication."Repayment Method" := LoanProductType."Repayment Method";
                LoanApplication."Requested Amount" := Amount;
                LoanApplication."Approved Amount" := Amount;
                LoanApplication."No. Series" := LoanApplicationSetup."Loan Application Nos.";
                LoanApplication.Status := LoanApplication.Status::Approved;
                LoanApplication.posted := true;
                LoanApplication."Disbursal Date" := today;
                LoanApplication."Date of Completion" := TODAY;
                LoanApplication."Next Due Date" := CALCDATE('1M', TODAY);
                LoanApplication."Created Date" := TODAY;
                LoanApplication."Created Time" := TIME;
                LoanApplication."Repayment Frequency" := LoanProductType."Repayment Frequency";
                IF LoanApplication.INSERT THEN BEGIN
                    CreateLoanAccount(LoanApplication);
                    LoanNo := LoanNumber;
                END;

            END;
        END;
        EXIT(LoanNo);
    end;

}

