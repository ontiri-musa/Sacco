codeunit 50038 "Payroll Processing"
{


    trigger OnRun();
    begin
        CreateMorestatus();
    end;

    var
        PayrollPeriods: Record "Payroll Period";
        BracketTable: Record "Bracket Table";
        BracketLines: Record "Bracket Line";
        EarningsSetup: Record "Earnings Setup";
        DeductionsSetup: Record "Deductions Setup";
        PayrollEntry: Record "Payroll Entries";
        AccType: Record "Account Type";
        Vend: Record Vendor;
        Text000: Label 'The new fiscal year begins before an existing fiscal year, so the new year will be closed automatically.\\';
        Text001: Label 'Do you want to create and close the fiscal year?';
        Text002: Label 'Once you create the new fiscal year you cannot change its starting date.\\';
        Text003: Label 'Do you want to create the fiscal year?';
        Text004: Label 'It is only possible to create new fiscal years before or after the existing ones.';
        CurrentPeriod: Date;
        NextPeriod: Date;
        BasicPay: Decimal;
        PayPeriodDate: Date;
        BasicPayCode: Code[10];
        PrincipalAmount: Decimal;
        InterestAmount: Decimal;
        InsuranceAmount: Decimal;
        LoanCode: Code[20];
        PayrollSetup: Record "Payroll Setup";
        Allowance: Decimal;
        TaxableAmount: Decimal;
        PAYECode: Code[20];
        DeductionAmount: Decimal;
        GrossAmount: Decimal;
        Employee: Record Employee;
        RunPayroll: Report "Processing Payroll";
        Records: Integer;
        CurrentRec: Integer;
        Window: Dialog;
        Customer: Record Customer;
        CashManagement: Codeunit "Cash Management";

    procedure ProcessingPayroll(Employee: Record Employee);
    begin
        BasicPay := 0;
        PrincipalAmount := 0;
        InsuranceAmount := 0;
        InterestAmount := 0;
        Allowance := 0;
        TaxableAmount := 0;
        DeductionAmount := 0;
        LoanCode := '';
        PayPeriodDate := GetOpenPeriod();
        WITH Employee DO BEGIN
            IF Employee.Status = Employee.Status::Terminated THEN BEGIN
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Payroll Period", PayPeriodDate);
                PayrollEntry.SETRANGE("Employee No", Employee."No.");
                IF PayrollEntry.FINDSET THEN BEGIN
                    PayrollEntry.DELETEALL;
                END;
            END;
            IF Employee.Status <> Employee.Status::Active THEN BEGIN
                EXIT;
            END;
            ComputeBasicSalary(Employee);
            ComputeOtherEarings(Employee);
            ComputeOtherDeductions(Employee);
            ComputeLoans(Employee);
            ComputePAYE(Employee);
        END;
    end;

    procedure TransferingToJounal(Employee: Record Employee);
    begin
    end;

    procedure UpdatingPayrollEntry(PayrollEntries: Record "Payroll Entries") Description: Text;
    var

    begin
        WITH PayrollEntries DO BEGIN
            CASE Type OF
                Type::Payment:
                    BEGIN
                        EarningsSetup.RESET;
                        IF EarningsSetup.GET(Code) THEN BEGIN
                            IF EarningsSetup.Block = TRUE THEN BEGIN
                                ERROR('Earning Blocked');
                            END;
                            IF EarningsSetup."Basic Salary Code" = TRUE THEN BEGIN
                                "Basic Salary Code" := TRUE;
                            END;
                            Description := EarningsSetup.Description;
                            IF (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Tax Relief") OR (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Insurance Relief") OR (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"AHL Relief") THEN BEGIN
                                "Tax Relief" := TRUE;
                            END;
                            IF EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Normal Earning" THEN BEGIN
                                "Normal Earnings" := TRUE
                            END ELSE BEGIN
                                "Normal Earnings" := FALSE;
                            END;
                            IF EarningsSetup.Taxable = TRUE THEN BEGIN
                                Taxable := TRUE;
                            END ELSE BEGIN
                                Taxable := FALSE;
                            END;
                            "Account Type" := EarningsSetup."Account Type";
                            "Account No." := EarningsSetup."Account No.";
                        END;
                    END;
                Type::Deduction:
                    BEGIN
                        DeductionsSetup.RESET;
                        IF DeductionsSetup.GET(Code) THEN BEGIN
                            IF DeductionsSetup.Block = TRUE THEN BEGIN
                                ERROR('Deduction Blocked');
                            END;
                            Description := DeductionsSetup.Description;
                            "G/L Account" := DeductionsSetup."Account No.";
                            "Tax Deductible" := DeductionsSetup."Tax deductible";
                            Retirement := DeductionsSetup."Pension Scheme";
                            Shares := DeductionsSetup.Shares;
                            Paye := DeductionsSetup."PAYE Code";
                            "Insurance Code" := DeductionsSetup."Insurance Code";
                            "Main Deduction Code" := DeductionsSetup."Main Deduction Code";
                            "Account Type" := DeductionsSetup."Account Type";
                            "Account No." := DeductionsSetup."Account No.";
                            if "Account Type" = "Account Type"::Vendor then begin
                                if DeductionsSetup."Voluntary Code" <> '' then begin
                                    if AccType.Get(DeductionsSetup."Voluntary Code") then begin
                                        Employee.Get(PayrollEntries."Employee No");
                                        Vend.Reset();
                                        Vend.SetRange("Member No.", Employee."Member No.");
                                        Vend.SetRange("Account Type", DeductionsSetup."Voluntary Code");
                                        if Vend.FindFirst() then begin
                                            "Account No." := Vend."No.";
                                        end;
                                    end;
                                end;
                            end;
                        END;

                        if "Account Type" = "Account Type"::Customer then begin
                            "Account No." := "Reference No";
                        end;
                    END;
            END;
            MODIFY;
        END;
    end;

    procedure CreatingPayrollPeriod(NoOfPeriods: Integer; PeriodLength: DateFormula; PayStartDate: Date; PeriodType: Option " ",Daily,Weekly,"Bi-Weekly",Monthly);
    var
        FiscalYearStartDate: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        i: Integer;
        CreateStatus: Boolean;
    begin
        FiscalYearStartDate := PayStartDate;
        CreateStatus := FALSE;
        FOR i := 1 TO NoOfPeriods + 1 DO BEGIN
            IF PayrollPeriods.GET(FiscalYearStartDate) THEN BEGIN
                MESSAGE('Pay Period already Exists!');
                EXIT;
            END;
            PayrollPeriods.INIT;
            PayrollPeriods."Starting Date" := FiscalYearStartDate;
            PayrollPeriods.Type := PeriodType;
            PayrollPeriods.VALIDATE("Starting Date");
            IF (i = 1) OR (i = NoOfPeriods + 1) THEN BEGIN
                PayrollPeriods."New Fiscal Year" := TRUE;
            END;
            IF (FirstPeriodStartDate = 0D) AND (i = 1) THEN BEGIN
                PayrollPeriods."Date Locked" := TRUE;
            END;
            IF (PayrollPeriods."Starting Date" < FirstPeriodStartDate) AND FirstPeriodLocked THEN BEGIN
                PayrollPeriods.Closed := TRUE;
                PayrollPeriods."Date Locked" := TRUE;
            END;
            PayrollPeriods.INSERT;
            FiscalYearStartDate := CALCDATE(PeriodLength, FiscalYearStartDate);
            CreateStatus := TRUE;
        END;
        IF CreateStatus = TRUE THEN BEGIN
            MESSAGE('Pay Period Successfully Created');
        END;
    end;

    procedure ClosingPayrollPeriod();
    var
        CloseStatus: Boolean;
        PayrollEntryCopy: Record "Payroll Entries";
        NextPeriod: Date;
    begin
        CloseStatus := FALSE;
        PayrollPeriods.RESET;
        PayrollPeriods.SETRANGE(Closed, FALSE);
        IF PayrollPeriods.FINDFIRST THEN BEGIN
            CurrentPeriod := PayrollPeriods."Starting Date";
            IF NOT CONFIRM('Are you Sure You Want To Close this Pay Period:  ' + FORMAT(CurrentPeriod) + '?' + //
            '  Make sure all Earnings and Dedcutions are correct before closing the current pay period! ', FALSE) THEN BEGIN
                EXIT;
            END;
            NextPeriod := CALCDATE('1M', CurrentPeriod);
            PayrollPeriods."Closed on Date" := CURRENTDATETIME;
            PayrollPeriods."Close Pay" := TRUE;
            PayrollPeriods.Closed := TRUE;
            PayrollPeriods."Closed By" := USERID;
            PayrollPeriods.MODIFY;
            CloseStatus := TRUE;
        END;
        Window.OPEN('Processing Payroll For: #1### Progress @2@@@@');
        IF CloseStatus = TRUE THEN BEGIN
            Window.OPEN('Closing Pay Period For the Month Of: #1### Progress @2@@@@');
            Records := 0;
            CurrentRec := 0;
            NextPeriod := CALCDATE('1M', CurrentPeriod);
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Payroll Period", CurrentPeriod);
            Records := PayrollEntry.COUNT;
            IF PayrollEntry.FINDFIRST THEN BEGIN
                REPEAT
                    Window.UPDATE(1, CurrentPeriod);
                    CurrentRec += 1;
                    IF PayrollEntry.Type = PayrollEntry.Type::Payment THEN BEGIN
                        EarningsSetup.RESET;
                        EarningsSetup.GET(PayrollEntry.Code);
                        IF EarningsSetup."Pay Type" = EarningsSetup."Pay Type"::Recurring THEN BEGIN
                            PayrollEntryCopy := PayrollEntry;
                            PayrollEntryCopy."Payroll Period" := NextPeriod;
                            PayrollEntryCopy.INSERT;
                        END;
                    END;
                    IF PayrollEntry.Type = PayrollEntry.Type::Deduction THEN BEGIN
                        DeductionsSetup.RESET;
                        DeductionsSetup.GET(PayrollEntry.Code);
                        IF DeductionsSetup.Type = DeductionsSetup.Type::Recurring THEN BEGIN
                            PayrollEntryCopy := PayrollEntry;
                            PayrollEntryCopy."Payroll Period" := NextPeriod;
                            PayrollEntryCopy.INSERT;
                        END;
                    END;
                    PayrollEntry.Closed := TRUE;
                    PayrollEntry.MODIFY;
                    Window.UPDATE(2, ((CurrentRec / Records) * 10000) DIV 1);
                UNTIL PayrollEntry.NEXT = 0;
            END;
            COMMIT;
            Window.CLOSE;
            MESSAGE('Payroll Period %1 Successfully Closed!', CurrentPeriod);
        END;
    end;

    procedure GetOpenPeriod() CurrentOpenPeriod: Date;
    begin
        PayrollPeriods.SETRANGE(Closed, FALSE);
        IF PayrollPeriods.FINDFIRST THEN BEGIN
            CurrentOpenPeriod := PayrollPeriods."Starting Date";
        END;
    end;

    procedure MakePayrollEntry(Employee: Record Employee; PayCode: Code[20]; PayPeriod: Date; Amount: Decimal; TaxableAmount: Decimal; Type: Option Payment,Deduction,"Saving Scheme",Loan,Informational; Principal: Decimal; Interest: Decimal; LedgerFee: Decimal; Penalty: Decimal; ReferenceCode: Code[30]);
    begin
        WITH Employee DO BEGIN
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Employee No", Employee."No.");
            PayrollEntry.SETRANGE(Type, Type);
            PayrollEntry.SETRANGE(Code, PayCode);
            PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
            IF PayrollEntry.FINDFIRST THEN BEGIN
                PayrollEntry.Amount := Amount;
                PayrollEntry."Taxable amount" := TaxableAmount;
                PayrollEntry."Loan Principal" := Principal;
                PayrollEntry."Loan Interest" := Interest;
                PayrollEntry."Loan Penalty" := Penalty;
                PayrollEntry."Loan Ledger Fee" := LedgerFee;
                PayrollEntry."Reference No" := ReferenceCode;
                If DeductionsSetup.Get(PayCode) then begin
                    if DeductionsSetup."G/L Account Employer" <> '' then
                        PayrollEntry."Employer Amount" := Amount;
                end;
                if EarningsSetup.Get(PayCode) then begin
                    if EarningsSetup."House Allowance" = true then begin
                        PayrollEntry."House Allowance" := true;
                    end;
                end;
                PayrollEntry.MODIFY;
                UpdatingPayrollEntry(PayrollEntry);
            END ELSE BEGIN
                PayrollEntry.INIT;
                PayrollEntry."Employee No" := Employee."No.";
                PayrollEntry.Type := Type;
                PayrollEntry.Code := PayCode;
                PayrollEntry."Payroll Period" := PayPeriod;
                PayrollEntry.Amount := Amount;
                PayrollEntry."Taxable amount" := TaxableAmount;
                PayrollEntry."Loan Principal" := Principal;
                PayrollEntry."Loan Interest" := Interest;
                PayrollEntry."Loan Ledger Fee" := LedgerFee;
                PayrollEntry."Loan Penalty" := Penalty;
                If DeductionsSetup.Get(PayCode) then begin
                    if DeductionsSetup."G/L Account Employer" <> '' then
                        PayrollEntry."Employer Amount" := Amount;
                end;
                if EarningsSetup.Get(PayCode) then begin
                    if EarningsSetup."House Allowance" = true then begin
                        PayrollEntry."House Allowance" := true;
                    end;
                end;
                PayrollEntry."Reference No" := ReferenceCode;
                IF PayrollEntry.Amount <> 0 THEN BEGIN
                    PayrollEntry.INSERT;
                    UpdatingPayrollEntry(PayrollEntry);
                END;
            END;
        END;
    end;

    procedure GetEarningsAmount(Empl: Record Employee; Earnings: Record "Earnings Setup"; ControlAmount: Decimal; PayPeriod: Date; NewHREntry: Boolean) EarningsAmount: Decimal;
    begin
        EarningsAmount := 0;
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Payroll Roundoff");
        WITH Earnings DO BEGIN
            PayrollEntry."Account Type" := Earnings."Account Type";
            PayrollEntry."Account No." := Earnings."Account No.";
            PayrollEntry.Modify;

            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"Flat amount" THEN BEGIN
                Earnings.TESTFIELD("Flat Amount");
                EarningsAmount := Earnings."Flat Amount";
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Basic pay" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                EarningsAmount := ROUND(ControlAmount * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Gross pay" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                EarningsAmount := ROUND((GetGrossPay(Empl, PayPeriod)) * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Taxable income" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                EarningsAmount := ROUND((GetTaxableAmount(Empl, PayPeriod)) * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Insurance Amount" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Empl."No.");
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
                If PayrollEntry.FindFirst() then begin
                    repeat
                        DeductionsSetup.Reset();
                        DeductionsSetup.SetRange(Code, PayrollEntry.Code);
                        DeductionsSetup.SetRange("Insurance Code", true);
                        if DeductionsSetup.FindFirst() then begin
                            EarningsAmount := ROUND(Abs(PayrollEntry.Amount) * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
                        end;
                    until PayrollEntry.Next = 0;
                end;
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% Of AHL" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Empl."No.");
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
                If PayrollEntry.FindFirst() then begin
                    repeat
                        DeductionsSetup.Reset();
                        DeductionsSetup.SetRange(Code, PayrollEntry.Code);
                        DeductionsSetup.SetRange("Affordable Housing Levy", true);
                        if DeductionsSetup.FindFirst() then begin
                            EarningsAmount := ROUND(Abs(PayrollEntry.Amount) * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
                        end;
                    until PayrollEntry.Next = 0;
                end;
            END;

            IF Earnings."Applies to All" = TRUE THEN BEGIN
                EarningsAmount := EarningsAmount;
            END ELSE BEGIN
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Empl."No.");
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
                PayrollEntry.SETRANGE(Code, Earnings.Code);
                PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
                IF PayrollEntry.FINDFIRST THEN BEGIN
                    EarningsAmount := EarningsAmount;
                END ELSE BEGIN
                    IF NewHREntry = FALSE THEN BEGIN
                        EarningsAmount := 0;
                    END;
                END;
            END;
        END;
    end;

    procedure GetTaxableAmount(Employee: Record Employee; PayrollPeriod: Date) TaxableAmount: Decimal;
    var
        Earnings: Record "Earnings Setup";
        AllowableDeductions: Decimal;
        Deductions: Record "Deductions Setup";

    begin
        TaxableAmount := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Employee No", Employee."No.");
        PayrollEntry.SETRANGE("Payroll Period", PayrollPeriod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF Earnings.GET(PayrollEntry.Code) THEN BEGIN
                    IF Earnings.Taxable = TRUE THEN BEGIN
                        TaxableAmount := TaxableAmount + ABS(PayrollEntry.Amount);
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;

        AllowableDeductions := 0;
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Pension Cap");
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
        PayrollEntry.SETRANGE("Employee No", Employee."No.");
        PayrollEntry.SETRANGE("Payroll Period", PayrollPeriod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                Deductions.RESET;
                Deductions.GET(PayrollEntry.Code);
                IF Deductions."Tax deductible" = TRUE THEN BEGIN
                    IF Deductions."Pension Scheme" = TRUE THEN BEGIN
                        AllowableDeductions := AllowableDeductions + ABS(PayrollEntry.Amount);
                    END ELSE BEGIN
                        TaxableAmount := TaxableAmount - ABS(PayrollEntry.Amount);
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
            IF AllowableDeductions > PayrollSetup."Pension Cap" THEN BEGIN
                AllowableDeductions := PayrollSetup."Pension Cap";
            END;
            TaxableAmount := TaxableAmount - AllowableDeductions;
        END;
    end;

    procedure GetTaxCharged(BracketTable: Record "Bracket Table"; Amount: Decimal; PayrollPeriod: Date) TaxCharged: Decimal;
    var
        EndTax: Boolean;
        AmountRemaining: Decimal;
        TaxedAmount: Decimal;
        Tax: Decimal;
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Payroll Roundoff");
        WITH BracketTable DO BEGIN
            IF BracketTable.Type = BracketTable.Type::Percentage THEN BEGIN
                EndTax := FALSE;
                //----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                BracketLines.RESET;
                BracketLines.SETCURRENTKEY("Lower Limit");
                BracketLines.SETRANGE("Table Code", BracketTable."Table Code");
                IF BracketLines.FINDFIRST THEN BEGIN
                    REPEAT
                        BracketLines.TESTFIELD(Percentage);
                        IF TaxableAmount <= 0 THEN BEGIN
                            EndTax := TRUE
                        END ELSE BEGIN
                            IF (BracketLines."Upper Limit" < Amount) AND (BracketLines."Upper Limit" <> 0) THEN BEGIN
                                TaxedAmount := TaxedAmount + BracketLines."Amount Charged";
                            END ELSE BEGIN
                                AmountRemaining := (TaxableAmount - (BracketLines."Lower Limit")) + 1;
                                Tax := ROUND(AmountRemaining * (BracketLines.Percentage / 100), PayrollSetup."Payroll Roundoff");
                                TaxedAmount := TaxedAmount + Tax;
                                EndTax := TRUE;
                            END;
                        END;
                    UNTIL (BracketLines.NEXT = 0) OR (EndTax = TRUE);
                    TaxCharged := TaxedAmount;
                END;
            END;
            //----------------------------------------------------------------------------------------------------------------------------------------------------------------------
            IF BracketTable.Type = BracketTable.Type::Range THEN BEGIN
                TaxCharged := 0;
                BracketLines.RESET;
                BracketLines.SETRANGE("Table Code", BracketTable."Table Code");
                BracketLines.SETFILTER("Lower Limit", '<=%1', GrossAmount);
                BracketLines.SETFILTER("Upper Limit", '>=%1', GrossAmount);
                IF BracketLines.FINDFIRST THEN BEGIN
                    TaxCharged := BracketLines."Amount Charged";
                END;
            END;
        END;
    end;

    procedure GetTaxRelief(Empl: Record Employee; PayrollPeriod: Date) TaxRelief: Decimal;
    begin
        TaxRelief := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", PayrollPeriod);
        PayrollEntry.SETRANGE(Taxable, FALSE);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                    IF (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Tax Relief") OR (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Insurance Relief") or
                    (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"AHL Relief") THEN BEGIN
                        TaxRelief := TaxRelief + ABS(PayrollEntry.Amount);
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetDeductionsAmount(Empl: Record Employee; Deductions: Record "Deductions Setup"; ControlAmount: Decimal; PayPeriod: Date; NewHREntry: Boolean) DeductionsAmount: Decimal;
    var
        Insurancerelief: Decimal;
        NSSFRates: Record "NSSF Rates";
    begin
        DeductionsAmount := 0;
        PayrollSetup.GET(1);
        NSSFRates.Get(1);
        PayrollSetup.TESTFIELD("Payroll Roundoff");
        WITH Deductions DO BEGIN
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat Amount" THEN BEGIN
                Deductions.TESTFIELD("Flat Amount");
                DeductionsAmount := Deductions."Flat Amount";
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay" THEN BEGIN
                Deductions.TESTFIELD(Percentage);
                DeductionsAmount := ROUND(ControlAmount * (Deductions.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay+Hse Allowance" THEN BEGIN
                Deductions.TESTFIELD(Percentage);
                DeductionsAmount := ROUND((ControlAmount + GetHouseAllowance(Empl, PayPeriod)) * (Deductions.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Pay" THEN BEGIN
                Deductions.TESTFIELD(Percentage);
                DeductionsAmount := ROUND((GetGrossPay(Empl, PayPeriod)) * (Deductions.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"NSSF Rate" THEN BEGIN
                If (GetGrossPay(Empl, PayPeriod)) <= NSSFRates."Tier I Lower Limit" then begin
                    DeductionsAmount := ROUND((GetGrossPay(Empl, PayPeriod)) * (NSSFRates."% Of Gross Pay" / 100), PayrollSetup."Payroll Roundoff");
                end;
                If (GetGrossPay(Empl, PayPeriod) > NSSFRates."Tier I Lower Limit") And (GetGrossPay(Empl, PayPeriod) <= NSSFRates."Tier II Upper Limit") then begin
                    DeductionsAmount := ROUND((NSSFRates."Tier I Lower Limit") * (NSSFRates."% Of Gross Pay" / 100), PayrollSetup."Payroll Roundoff");
                    DeductionsAmount += ROUND((GetGrossPay(Empl, PayPeriod) - NSSFRates."Tier I Lower Limit") * (NSSFRates."% Of Gross Pay" / 100), PayrollSetup."Payroll Roundoff");
                end;
                If (GetGrossPay(Empl, PayPeriod) > NSSFRates."Tier II Upper Limit") then begin
                    DeductionsAmount := ROUND((NSSFRates."Tier I Lower Limit") * (NSSFRates."% Of Gross Pay" / 100), PayrollSetup."Payroll Roundoff");
                    DeductionsAmount += ROUND((NSSFRates."Tier II Upper Limit" - NSSFRates."Tier I Lower Limit") * (NSSFRates."% Of Gross Pay" / 100), PayrollSetup."Payroll Roundoff");
                end;
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Table" THEN BEGIN
                Deductions.TESTFIELD("Deduction Table");
                BracketTable.GET(Deductions."Deduction Table");
                GrossAmount := 0;
                if Deductions."Insurance Code" = false then
                    GrossAmount := GetGrossPay(Empl, PayPeriod)
                else
                    GrossAmount := GetNHIFGrossPay(Empl, PayPeriod);
                IF GrossAmount <> 0 THEN BEGIN
                    DeductionsAmount := GetTaxCharged(BracketTable, GrossAmount, PayPeriod);
                END;
            END;

            IF Deductions."Applies to All" = TRUE THEN BEGIN
                DeductionsAmount := DeductionsAmount;
            END ELSE BEGIN
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Empl."No.");
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
                PayrollEntry.SETRANGE(Code, Deductions.Code);
                PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
                IF PayrollEntry.FINDFIRST THEN BEGIN
                    IF PayrollEntry.Amount <> 0 THEN BEGIN
                        IF DeductionsAmount <> ABS(PayrollEntry.Amount) THEN BEGIN
                            DeductionsAmount := ABS(DeductionsAmount);
                        END;
                        IF (Deductions."Voluntary Code" <> '') and (Deductions."Account Type" = Deductions."Account Type"::Vendor) then begin
                            PayrollEntry."Account Type" := PayrollEntry."Account Type"::Vendor;
                            if AccType.Get(Deductions."Voluntary Code") then begin
                                Employee.Get(PayrollEntry."Employee No");
                                Vend.Reset();
                                Vend.SetRange("Member No.", Employee."Member No.");
                                Vend.SetRange("Account Type", Deductions."Voluntary Code");
                                if Vend.FindFirst() then begin
                                    PayrollEntry."Account No." := Vend."No.";
                                end;
                            end;
                            PayrollEntry.Modify;
                        end;
                        IF Deductions."Insurance Code" = TRUE THEN BEGIN
                            Insurancerelief := 0;

                            EarningsSetup.RESET;
                            EarningsSetup.SETRANGE("Basic Salary Code", FALSE);
                            EarningsSetup.SETRANGE("Earning Type", EarningsSetup."Earning Type"::"Insurance Relief");
                            IF EarningsSetup.FINDFIRST THEN BEGIN
                                EarningsSetup.TESTFIELD(Percentage);
                                PayrollSetup.TESTFIELD("Insurance Relief Cap");
                                IF ABS(PayrollEntry.Amount) <= PayrollSetup."Insurance Relief Cap" THEN BEGIN
                                    Insurancerelief := (ABS(PayrollEntry.Amount) * EarningsSetup.Percentage / 100);
                                END ELSE BEGIN
                                    Insurancerelief := (PayrollSetup."Insurance Relief Cap" * EarningsSetup.Percentage / 100);
                                END;
                                Insurancerelief := ROUND(Insurancerelief, PayrollSetup."Payroll Roundoff");
                                IF Insurancerelief <> 0 THEN BEGIN
                                    MakePayrollEntry(Empl, EarningsSetup.Code, PayPeriodDate, Insurancerelief, TaxableAmount, PayrollEntry.Type::Payment, PrincipalAmount, InsuranceAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                                END;
                            END ELSE BEGIN
                                ERROR('Kindly Add Insurance Relief on Earnings Setup!');
                            END;
                        END;
                    END;
                END ELSE BEGIN
                    IF NewHREntry = FALSE THEN BEGIN
                        DeductionsAmount := 0;
                    END;
                END;
            END;
        END;
    end;

    procedure GetGrossPay(Empl: Record Employee; Payrollperiod: Date) GrossPay: Decimal;
    begin
        GrossPay := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Non-Cash Benefit", FALSE);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", Payrollperiod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                    IF EarningsSetup."Non-Cash Benefit" = FALSE THEN BEGIN
                        GrossPay := GrossPay + PayrollEntry.Amount;
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetHouseAllowance(Empl: Record Employee; Payrollperiod: Date) HouseAllowance: Decimal;
    begin
        HouseAllowance := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Non-Cash Benefit", FALSE);
        PayrollEntry.SETRANGE("House Allowance", TRUE);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", Payrollperiod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                    HouseAllowance := HouseAllowance + PayrollEntry.Amount;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetNHIFGrossPay(Empl: Record Employee; Payrollperiod: Date) GrossPay: Decimal;
    begin
        GrossPay := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Non-Cash Benefit", FALSE);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", Payrollperiod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                    IF (EarningsSetup."Non-Cash Benefit" = FALSE) and (EarningsSetup."Increase NHIF" = TRUE) THEN BEGIN
                        GrossPay := GrossPay + PayrollEntry.Amount;
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetTotalDeductions(Empl: Record Employee; Payrollperiod: Date) TotalDeductions: Decimal;
    begin
        TotalDeductions := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", Payrollperiod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                TotalDeductions := TotalDeductions + ABS(PayrollEntry.Amount);
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetEDDescription(PayrollEntries: Record "Payroll Entries") EDDescription: Text;
    begin
        WITH PayrollEntries DO BEGIN
            CASE Type OF
                Type::Payment:
                    BEGIN
                        EarningsSetup.RESET;
                        IF EarningsSetup.GET(Code) THEN BEGIN
                            IF EarningsSetup.Block = TRUE THEN BEGIN
                                ERROR('Earning Blocked');
                            END;
                            EDDescription := EarningsSetup.Description;
                        END;
                    END;
                Type::Deduction:
                    BEGIN
                        DeductionsSetup.RESET;
                        IF DeductionsSetup.GET(Code) THEN BEGIN
                            IF DeductionsSetup.Block = TRUE THEN BEGIN
                                ERROR('Deduction Blocked');
                            END;
                            EDDescription := DeductionsSetup.Description;
                        END;
                    END;
            END;
        END;
    end;

    procedure ComputeBasicSalary(Employee: Record Employee);
    begin
        Employee.TESTFIELD("Basic Pay");
        Employee.TESTFIELD("Member No.");
        BasicPay := GetBasicPay(Employee);
        BasicPayCode := '';
        EarningsSetup.RESET;
        EarningsSetup.SETRANGE("Basic Salary Code", TRUE);
        IF EarningsSetup.FINDFIRST THEN BEGIN
            BasicPayCode := EarningsSetup.Code;
            MakePayrollEntry(Employee, BasicPayCode, PayPeriodDate, BasicPay, TaxableAmount, PayrollEntry.Type::Payment, PrincipalAmount, InsuranceAmount, InsuranceAmount, InsuranceAmount, LoanCode);
        END;
    end;

    procedure ComputeOtherEarings(Employee: Record Employee);
    begin
        EarningsSetup.RESET;
        EarningsSetup.SETRANGE("Basic Salary Code", FALSE);
        IF EarningsSetup.FINDFIRST THEN BEGIN
            REPEAT
                Allowance := GetEarningsAmount(Employee, EarningsSetup, BasicPay, PayPeriodDate, FALSE);
                IF Allowance <> 0 THEN BEGIN
                    MakePayrollEntry(Employee, EarningsSetup.Code, PayPeriodDate, Allowance, TaxableAmount, PayrollEntry.Type::Payment, PrincipalAmount, InsuranceAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            UNTIL EarningsSetup.NEXT = 0;
        END;
    end;

    procedure ComputePAYE(Employee: Record Employee);
    begin
        DeductionsSetup.RESET;
        DeductionsSetup.SETRANGE("PAYE Code", TRUE);
        IF DeductionsSetup.FINDFIRST THEN BEGIN
            DeductionsSetup.TESTFIELD("Deduction Table");
            BracketTable.GET(DeductionsSetup."Deduction Table");
            TaxableAmount := 0;
            TaxableAmount := GetTaxableAmount(Employee, PayPeriodDate);


            IF TaxableAmount <> 0 THEN BEGIN
                DeductionAmount := 0;
                DeductionAmount := Round(GetTaxCharged(BracketTable, TaxableAmount, PayPeriodDate), 1, '=');
                DeductionAmount := DeductionAmount - GetTaxRelief(Employee, PayPeriodDate);
                IF DeductionAmount > 0 THEN BEGIN
                    DeductionAmount := -DeductionAmount;
                END ElSE BEGIN
                    DeductionAmount := 0;
                END;
                IF DeductionAmount <> 0 THEN BEGIN
                    MakePayrollEntry(Employee, DeductionsSetup.Code, PayPeriodDate, DeductionAmount, TaxableAmount, PayrollEntry.Type::Deduction, PrincipalAmount, InsuranceAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            END;
        END;
    end;

    procedure ComputeOtherDeductions(Employee: Record Employee);
    var
        DedSetup: Record "Deductions Setup";
    begin
        DedSetup.RESET;
        DedSetup.SETRANGE("PAYE Code", FALSE);
        DedSetup.SETRANGE(Loan, FALSE);
        IF DedSetup.FINDFIRST THEN BEGIN
            REPEAT
                Clear(LoanCode);
                DeductionAmount := 0;
                If DedSetup."Pension Scheme" = true then begin
                    If (Employee."Pension Non Contributor" = false) then
                        DeductionAmount := GetDeductionsAmount(Employee, DedSetup, BasicPay, PayPeriodDate, FALSE);
                end else begin
                    DeductionAmount := GetDeductionsAmount(Employee, DedSetup, BasicPay, PayPeriodDate, FALSE);
                end;
                DeductionAmount := -DeductionAmount;
                IF DeductionAmount <> 0 THEN BEGIN
                    MakePayrollEntry(Employee, DedSetup.Code, PayPeriodDate, DeductionAmount, TaxableAmount, PayrollEntry.Type::Deduction, PrincipalAmount, InsuranceAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            UNTIL DedSetup.NEXT = 0;
        END;
    end;

    procedure ComputeLoans(Employee: Record Employee);
    var
        DedSetup: Record "Deductions Setup";
    begin
        DedSetup.Reset();
        DedSetup.SetRange("PAYE Code", FALSE);
        DedSetup.SetRange(Loan, TRUE);
        IF DedSetup.FindFirst() THEN BEGIN
            REPEAT
                //DedSetup.TestField("Main Loan Code");
                GetStaffLoans(Employee, PayPeriodDate, DedSetup."Main Loan Code", DedSetup.Code);
            UNTIL DedSetup.NEXT = 0;
        END;
    end;

    local procedure GetLoanAmounts(TotalAmount: Decimal; Principle: Decimal; IntDue: Decimal)
    var
        myInt: Integer;
    begin

    end;

    procedure GetAmount(PayrollEntries: Record "Payroll Entries") GetControlAmount: Decimal;
    var
        Amount: Decimal;
        DedSetup: Record "Deductions Setup";
    begin
        WITH PayrollEntries DO BEGIN
            Employee.GET(PayrollEntries."Employee No");
            IF Type = Type::Payment THEN BEGIN
                EarningsSetup.Reset();
                EarningsSetup.GET(PayrollEntries.Code);
                GetControlAmount := GetEarningsAmount(Employee, EarningsSetup, GetBasicPay(Employee), GetOpenPeriod, TRUE);
            END;
            IF Type = Type::Deduction THEN BEGIN
                DedSetup.Reset();
                DedSetup.GET(PayrollEntries.Code);
                GetControlAmount := -GetDeductionsAmount(Employee, DedSetup, GetBasicPay(Employee), GetOpenPeriod, TRUE);
            END;
        END;
    end;

    procedure GetBasicPay(Employee: Record Employee) BasicPaid: Decimal;
    begin
        WITH Employee DO BEGIN
            BasicPaid := Employee."Basic Pay";
        END;
    end;

    procedure GetStaffLoans(Employee: Record Employee; PayrollDate: Date; LoanCode: Code[20]; DedCode: Code[20])
    var
        LoanApplication: Record "Loan Application";
        OutstandingBalance: Decimal;
        DeductionAmount: Decimal;
        LoanPrincipleAmount: Decimal;
        AmountInArrears: array[4] of Decimal;
        Overpayment: array[2] of Decimal;
        IntDue: Decimal;
        PenDue: Decimal;
        LegdDue: Decimal;
        RepaymentAdj: Decimal;
        GlobalM: Codeunit "Global Management";
        Pentries: Record "Payroll Entries";
    begin

        LoanApplication.Reset();
        LoanApplication.SetRange(LoanApplication."Member No.", Employee."Member No.");
        LoanApplication.SetRange(LoanApplication."Repayment Adjustment", false);
        LoanApplication.SetRange("Loan Product Type", DedCode);
        if LoanApplication.FindSet() then begin
            repeat
                LoanApplication.CalcFields("Outstanding Balance");
                OutstandingBalance := 0;
                LoanPrincipleAmount := 0;
                DeductionAmount := 0;
                IntDue := 0;
                PenDue := 0;
                LegdDue := 0;
                RepaymentAdj := 0;

                Pentries.Reset();
                Pentries.SetRange("Reference No", LoanApplication."No.");
                Pentries.SetRange("Payroll Period", PayPeriodDate);
                If Pentries.FindFirst() then begin
                    Pentries.Delete();
                end;

                OutstandingBalance := LoanApplication."Outstanding Balance";
                IF OutstandingBalance > 0 then BEGIN
                    GlobalM.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, CalcDate('CM', Today), AmountInArrears[1], AmountInArrears[2], AmountInArrears[3], AmountInArrears[4], Overpayment[1], Overpayment[2]);
                    If LoanApplication."Repayment Adjustment Amount" <> 0 then begin
                        RepaymentAdj := LoanApplication."Repayment Adjustment Amount";

                        if RepaymentAdj > Round(AmountInArrears[2], 1, '=') then begin
                            IntDue := Round(AmountInArrears[2], 1, '=');
                            RepaymentAdj := RepaymentAdj - IntDue;
                        end else begin
                            IntDue := RepaymentAdj;
                            RepaymentAdj := 0;
                        end;
                        if RepaymentAdj > Round(AmountInArrears[3], 1, '=') then begin
                            LegdDue := Round(AmountInArrears[3], 1, '=');
                            RepaymentAdj := RepaymentAdj - LegdDue;
                        end else begin
                            LegdDue := RepaymentAdj;
                            RepaymentAdj := 0;
                        end;
                        if RepaymentAdj > Round(AmountInArrears[4], 1, '=') then begin
                            PenDue := Round(AmountInArrears[4], 1, '=');
                            RepaymentAdj := RepaymentAdj - PenDue;
                        end else begin
                            PenDue := RepaymentAdj;
                            RepaymentAdj := 0;
                        end;
                        if RepaymentAdj > 0 then
                            LoanPrincipleAmount := RepaymentAdj;

                    end else begin
                        LoanPrincipleAmount := Round(AmountInArrears[1], 1, '=');
                        IntDue := Round(AmountInArrears[2], 1, '=');
                        LegdDue := Round(AmountInArrears[3], 1, '=');
                        PenDue := Round(AmountInArrears[4], 1, '=');
                    end;
                    DeductionAmount := -(LoanPrincipleAmount + IntDue + LegdDue + PenDue);
                    MakePayrollEntry(Employee, DedCode, PayPeriodDate, DeductionAmount, TaxableAmount, PayrollEntry.Type::Deduction, LoanPrincipleAmount, IntDue, LegdDue, PenDue, LoanApplication."No.");
                END;
            until LoanApplication.Next = 0;
        end;
    end;

    local procedure GetLoanBalance(LoanNumber: Code[20]): Decimal

    begin
        Customer.Reset();
        if Customer.Get(LoanNumber) then begin
            Customer.CalcFields("Balance (LCY)");
            if Customer."Balance (LCY)" <> 0 then begin
                exit(Customer."Balance (LCY)");
            end;
        end;
    end;

    local procedure GetPricipleAmount(LoanNumber: Code[20]; PayPeriod: Date) PrincipleAmount: Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        PayPeriod := CalcDate('-CM', Today);
        PrincipleAmount := 0;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoanNumber);
        LoanRepaymentSchedule.SetRange("Repayment Date", PayPeriod, CalcDate('CM', PayPeriod));
        IF LoanRepaymentSchedule.FindSet(true) THEN BEGIN
            repeat
                PrincipleAmount += LoanRepaymentSchedule."Principal Installment";
            until LoanRepaymentSchedule.Next() = 0;
        END;
        PrincipleAmount := Round(PrincipleAmount, 0.01);
        exit(PrincipleAmount);
    end;

    local procedure GetInterestDue(LoanNumber: Code[20]) InterestDue: Decimal
    var
        SourceCodeSetup: Record "Source Code Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TransSetup: Record "Transaction Type Code Setup";
        IntDueCode: code[40];
        IntPaidCode: Code[40];
    begin
        InterestDue := 0;
        TransSetup.Get();
        IntDueCode := TransSetup."Interest Due";
        IntPaidCode := TransSetup."Interest Paid";
        SourceCodeSetup.Reset();
        SourceCodeSetup.Get();
        SourceCodeSetup.TestField(Loan);
        SourceCodeSetup.TestField(Loan);
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", LoanNumber);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Transaction Type Code", '%1|%2', IntDueCode, IntPaidCode);
        if CustLedgerEntry.FindSet() then begin
            repeat
                CustLedgerEntry.CalcFields(Amount);
                InterestDue += CustLedgerEntry.Amount;
            until CustLedgerEntry.Next() = 0;
        end;

    end;

    procedure CreateMorestatus();
    var
        Employ: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Counts: Integer;
    begin
        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Employee Nos.");
        Employee.RESET;
        Counts := 500;
        IF Employee.FINDFIRST THEN BEGIN
            REPEAT
                Employ.COPY(Employee);
                Employ."No." := NoSeriesMgt.GetNextNo(HumanResSetup."Employee Nos.", TODAY, TRUE);
                Employ."First Name" := Employ."No." + '' + 'F';
                Employ."Middle Name" := Employ."No." + '' + 'M';
                Employ."Last Name" := Employ."No." + '' + 'L';
                Employ."Basic Pay" := Employ."Basic Pay" + 1000;
                Employ.INSERT;
                Counts := Counts - 1;
            UNTIL (Employee.NEXT = 0) OR (Counts = 0);
        END;
    end;

    procedure TransferingPayrollToJournal(Employee: Record Employee; GnLLineNumber: Integer; PostingDate: Date) LastLineNumber: Integer;
    var
        EDDescription: Text;
        NetPay: Decimal;
        DedSetup: Record "Deductions Setup";
        SourceCodeSetup: Record "Source Code Setup";
        TransSettup: Record "Transaction Type Code Setup";
        SourceCode: Code[20];
        PPaidCode: Code[40];
        IntPaidCode: Code[40];
        PenPaidCode: Code[40];
        InsPaid: Code[40];
        LedgerFeePaidCode: code[40];
        LoanPrincipal: Decimal;
        LoanInterest: Decimal;
        ContCode: Code[40];
        Loan: Record "Loan Application";
        LProdType: Record "Loan Product Type";
        LoanPenalty: Decimal;
        LoanLedgerFee: Decimal;
        NetCreditAccount: Code[20];
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        WITH Employee DO BEGIN
            SourceCodeSetup.Reset();
            TransSettup.Get();
            SourceCodeSetup.Get();
            SourceCodeSetup.TestField(Loan);
            SourceCodeSetup.TestField(Loan);
            SourceCodeSetup.TestField(Loan);
            PayrollSetup.Get(1);

            NetPay := 0;
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Employee No", Employee."No.");
            PayrollEntry.SETRANGE("Payroll Period", GetOpenPeriod());
            IF PayrollEntry.FINDFIRST THEN BEGIN
                REPEAT
                    EDDescription := PayrollEntry.Description + ': ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                    IF PayrollEntry.Type = PayrollEntry.Type::Payment THEN BEGIN
                        EarningsSetup.RESET;
                        IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                            IF EarningsSetup."Non-Cash Benefit" = FALSE THEN BEGIN
                                Clear(SourceCode);
                                CreatingJurnalLines(EDDescription, PayrollEntry, Employee, PayrollEntry.Amount, EarningsSetup."Account Type", EarningsSetup."Account No.", GnLLineNumber, SourceCode, PostingDate);
                            END;
                        END;
                    END;
                    IF PayrollEntry.Type = PayrollEntry.Type::Deduction THEN BEGIN
                        DedSetup.Reset();
                        if DedSetup.Get(PayrollEntry.Code) then begin
                            if DedSetup.Loan then begin
                                if Loan.Get(PayrollEntry."Account No.") then begin
                                    LProdType.Get(Loan."Loan Product Type");
                                    if PayrollEntry."Loan Principal" <> 0 then begin
                                        EDDescription := PayrollEntry.Description + ' (Loan Principal) : ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                                        LoanPrincipal := 0;
                                        PPaidCode := TransSettup."Principal Paid";
                                        Clear(SourceCode);
                                        LoanPrincipal := -PayrollEntry."Loan Principal";
                                        SourceCode := SourceCodeSetup.Loan;
                                        CreatingLoanJurnalLines(EDDescription, PayrollEntry, Employee, LoanPrincipal, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber, SourceCode, PPaidCode, LProdType.Code, PostingDate);
                                    end;
                                    if PayrollEntry."Loan Interest" <> 0 then begin
                                        EDDescription := PayrollEntry.Description + ' (Loan Interest) : ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                                        Clear(SourceCode);
                                        LoanInterest := -PayrollEntry."Loan Interest";
                                        IntPaidCode := TransSettup."Interest Paid";
                                        SourceCode := SourceCodeSetup.Loan;
                                        CreatingLoanJurnalLines(EDDescription, PayrollEntry, Employee, LoanInterest, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber, SourceCode, IntPaidCode, LProdType."Interest Due Posting Group", PostingDate);
                                    end;
                                    if PayrollEntry."Loan Penalty" <> 0 then begin
                                        EDDescription := PayrollEntry.Description + ' (Loan Penalty) : ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                                        Clear(SourceCode);
                                        PenPaidCode := TransSettup."Penalty Paid";
                                        LoanPenalty := -PayrollEntry."Loan Penalty";
                                        SourceCode := SourceCodeSetup.Loan;
                                        CreatingLoanJurnalLines(EDDescription, PayrollEntry, Employee, LoanPenalty, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber, SourceCode, PenPaidCode, LProdType."Penalty Due Posting Group", PostingDate);
                                    end;
                                    if PayrollEntry."Loan Ledger Fee" <> 0 then begin
                                        EDDescription := PayrollEntry.Description + ' (Loan Ledger Fee) : ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                                        Clear(SourceCode);
                                        LedgerFeePaidCode := TransSettup."Ledger Fee Paid";
                                        LoanLedgerFee := -PayrollEntry."Loan Ledger Fee";
                                        SourceCode := SourceCodeSetup.Loan;
                                        CreatingLoanJurnalLines(EDDescription, PayrollEntry, Employee, LoanLedgerFee, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber, SourceCode, LedgerFeePaidCode, LProdType."Ledger Fee Due Posting Group", PostingDate);
                                    end;
                                end;
                            end else begin
                                Clear(SourceCode);
                                if DedSetup."Account Type" <> DedSetup."Account Type"::Vendor then begin
                                    If DedSetup."G/L Account Employer" = '' then begin
                                        CreatingJurnalLines(EDDescription, PayrollEntry, Employee, PayrollEntry.Amount, DedSetup."Account Type", DedSetup."Account No.", GnLLineNumber, SourceCode, PostingDate);
                                    end else begin
                                        //Epmloyee Deduction
                                        CreatingJurnalLines(EDDescription + ' (Employee)', PayrollEntry, Employee, PayrollEntry.Amount, DedSetup."Account Type", DedSetup."Account No.", GnLLineNumber, SourceCode, PostingDate);
                                        // Employer Matching
                                        CreatingJurnalLines(EDDescription + ' (Employer)', PayrollEntry, Employee, PayrollEntry.Amount, DedSetup."Account Type", DedSetup."Account No.", GnLLineNumber, SourceCode, PostingDate);
                                        CreatingJurnalLines(EDDescription + ' (Employer)', PayrollEntry, Employee, -PayrollEntry.Amount, DedSetup."Account Type", DedSetup."G/L Account Employer", GnLLineNumber, SourceCode, PostingDate);
                                    end;
                                end else begin
                                    ContCode := TransSettup."Monthly Contribution";
                                    CreatingContJurnalLines(EDDescription, PayrollEntry, Employee, PayrollEntry.Amount, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber, SourceCode, ContCode, PostingDate);
                                end;
                            end;
                        end;

                    END;
                    GnLLineNumber := GnLLineNumber + 1;
                UNTIL PayrollEntry.NEXT = 0;
                NetPay := -(GetGrossPay(Employee, PayrollEntry."Payroll Period") - GetTotalDeductions(Employee, PayrollEntry."Payroll Period"));
                EDDescription := 'Net Pay' + ': ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                Clear(SourceCode);

                if PayrollSetup."Paying Account Type" = PayrollSetup."Paying Account Type"::"FOSA Account" then begin
                    Employee.TestField("FOSA Account");
                    CreatingJurnalLines(EDDescription, PayrollEntry, Employee, NetPay, PayrollEntry."Account Type"::Vendor, Employee."FOSA Account", GnLLineNumber, SourceCode, PostingDate);
                end;
                if PayrollSetup."Paying Account Type" = PayrollSetup."Paying Account Type"::"Bank Account" then begin
                    PayrollSetup.TestField("Bank Account No.");
                    CreatingJurnalLines(EDDescription, PayrollEntry, Employee, NetPay, PayrollEntry."Account Type"::"Bank Account", PayrollSetup."Bank Account No.", GnLLineNumber, SourceCode, PostingDate);
                end;
                if PayrollSetup."Paying Account Type" = PayrollSetup."Paying Account Type"::"G/L Account" then begin
                    PayrollSetup.TestField("Bank Account No.");
                    CreatingJurnalLines(EDDescription, PayrollEntry, Employee, NetPay, PayrollEntry."Account Type"::"G/L Account", PayrollSetup."G/L Account No", GnLLineNumber, SourceCode, PostingDate);
                end;
                LastLineNumber := GnLLineNumber + 1;
            END ELSE BEGIN
                EXIT;
            END;
        END;
    end;

    procedure PayrollProcessNetPay(Employee: Record Employee; PostingDate: Date; ChequeNo: Code[30]; PayPeriod: Date; BankNo: Code[50])
    var
        EDDescription: Text;
        NetPay: Decimal;
        DedSetup: Record "Deductions Setup";
        SourceCodeSetup: Record "Source Code Setup";
        TransSettup: Record "Transaction Type Code Setup";
        SourceCode: Code[20];
        GnLLineNumber: Integer;
        ContCode: Code[40];
        NetCreditAccount: Code[20];
        CustomerPostingGroup: Record "Customer Posting Group";
        ExtDocNo: Text;

    begin
        WITH Employee DO BEGIN
            SourceCodeSetup.Reset();
            TransSettup.Get();
            SourceCodeSetup.Get();
            PayrollSetup.Get(1);

            NetPay := 0;
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Employee No", Employee."No.");
            PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
            IF PayrollEntry.FINDFIRST THEN BEGIN

                NetPay := (GetGrossPay(Employee, PayrollEntry."Payroll Period") - GetTotalDeductions(Employee, PayrollEntry."Payroll Period"));
                EDDescription := 'Net Pay' + ': ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>' + ': Cheque No ' + ChequeNo);
                ExtDocNo := 'Cheque No ' + ChequeNo;
                Clear(SourceCode);

                if PayrollSetup."Paying Account Type" = PayrollSetup."Paying Account Type"::"G/L Account" then begin
                    PayrollSetup.TestField("G/L Account No");
                    CreatingJurnalLinesNetPay(EDDescription, PayrollEntry, Employee, NetPay, PayrollEntry."Account Type"::"G/L Account", PayrollSetup."G/L Account No", ExtDocNo, SourceCode, PostingDate);
                end;
                CreatingJurnalLinesNetPay(EDDescription, PayrollEntry, Employee, -NetPay, PayrollEntry."Account Type"::"Bank Account", BankNo, ExtDocNo, SourceCode, PostingDate);
            END ELSE BEGIN
                EXIT;
            END;
        END;
    end;

    procedure CreatingLoanJurnalLines(Description: Text; PayrollEntries: Record "Payroll Entries"; Employee: Record Employee; Amount: Decimal; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No.": Code[20]; GnLLineNumber: Integer; Sourcecode: Code[20]; TransCode: code[50]; PostingCode: code[50]; PostingDate: date)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournal: Record "Gen. Journal Line";
        LineNumber: Integer;
        Noseries: Code[20];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        Noseries := FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 2)) + '-' + FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 3));
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := PayrollSetup."General Journal Template Name";
        GenJournalLine."Journal Batch Name" := PayrollSetup."General Journal Batch Name";
        GenJournal.Reset();
        GenJournal.SetRange(GenJournal."Journal Template Name", PayrollSetup."General Journal Template Name");
        GenJournal.SetRange(GenJournal."Journal Batch Name", PayrollSetup."General Journal Batch Name");
        if GenJournal.FindLast() then
            GenJournalLine."Line No." := GenJournal."Line No." + 1;
        GenJournalLine."Account Type" := "Account Type";
        GenJournalLine."Account No. 2" := "Account No.";
        GenJournalLine."Account No." := "Account No.";
        GenJournalLine."Member No" := Employee."Member No.";
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine.Description := Description + '- ' + Employee."Member No.";
        GenJournalLine."Document No." := Noseries + '-SALARY';
        GenJournalLine."Transaction Type Code" := TransCode;
        GenJournalLine."Posting Group" := PostingCode;
        GenJournalLine.Amount := Amount;
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        GenJournalLine."Source Code" := Sourcecode;
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN BEGIN
            if PayrollEntries."Reference No" <> '' then begin
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
                VendorLedgerEntry.SetRange("Document No.", PayrollEntries."Reference No");
                VendorLedgerEntry.SetRange(Positive, true);
                if VendorLedgerEntry.FindFirst() then begin
                    GenJournalLine."Applies-to Doc. No." := PayrollEntries."Reference No";
                    GenJournalLine."Applies-to Doc. Type" := VendorLedgerEntry."Document Type";
                end;
            end;
        END;
        IF GenJournalLine.Amount <> 0 THEN BEGIN
            GenJournalLine.INSERT;
        END;
    end;

    procedure CreatingJurnalLinesNetPay(Description: Text; PayrollEntries: Record "Payroll Entries"; Employee: Record Employee; Amount: Decimal; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No.": Code[20]; ExDocNo: Text; Sourcecode: Code[20]; PostingDate: Date);
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournal: Record "Gen. Journal Line";
        LineNumber: Integer;
        Noseries: Code[20];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        Noseries := FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 2)) + '-' + FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 3));
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := PayrollSetup."General Journal Template Name";
        GenJournalLine."Journal Batch Name" := PayrollSetup."General Journal Batch Name";
        GenJournal.Reset();
        GenJournal.SetRange(GenJournal."Journal Template Name", PayrollSetup."General Journal Template Name");
        GenJournal.SetRange(GenJournal."Journal Batch Name", PayrollSetup."General Journal Batch Name");
        if GenJournal.FindLast() then
            GenJournalLine."Line No." := GenJournal."Line No." + 1;
        GenJournalLine."Account Type" := "Account Type";
        GenJournalLine."Account No. 2" := "Account No.";
        GenJournalLine."Account No." := "Account No.";
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Member No" := Employee."Member No.";
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine.Description := Description + '- ' + Employee."Member No.";
        GenJournalLine."External Document No." := ExDocNo;
        GenJournalLine."Document No." := Noseries + '-SALARY';
        GenJournalLine.Amount := Amount;
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        GenJournalLine."Source Code" := Sourcecode;
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN BEGIN
            if PayrollEntries."Reference No" <> '' then begin
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
                VendorLedgerEntry.SetRange("Document No.", PayrollEntries."Reference No");
                VendorLedgerEntry.SetRange(Positive, true);
                if VendorLedgerEntry.FindFirst() then begin
                    GenJournalLine."Applies-to Doc. No." := PayrollEntries."Reference No";
                    GenJournalLine."Applies-to Doc. Type" := VendorLedgerEntry."Document Type";
                end;
            end;
        END;
        IF GenJournalLine.Amount <> 0 THEN BEGIN
            GenJournalLine.INSERT;
        END;
    end;

    procedure CreatingJurnalLines(Description: Text; PayrollEntries: Record "Payroll Entries"; Employee: Record Employee; Amount: Decimal; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No.": Code[20]; GnLLineNumber: Integer; Sourcecode: Code[20]; PostingDate: Date);
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournal: Record "Gen. Journal Line";
        LineNumber: Integer;
        Noseries: Code[20];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        Noseries := FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 2)) + '-' + FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 3));
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := PayrollSetup."General Journal Template Name";
        GenJournalLine."Journal Batch Name" := PayrollSetup."General Journal Batch Name";
        GenJournal.Reset();
        GenJournal.SetRange(GenJournal."Journal Template Name", PayrollSetup."General Journal Template Name");
        GenJournal.SetRange(GenJournal."Journal Batch Name", PayrollSetup."General Journal Batch Name");
        if GenJournal.FindLast() then
            GenJournalLine."Line No." := GenJournal."Line No." + 1;
        GenJournalLine."Account Type" := "Account Type";
        GenJournalLine."Account No. 2" := "Account No.";
        GenJournalLine."Account No." := "Account No.";
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Member No" := Employee."Member No.";
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine.Description := Description + '- ' + Employee."Member No.";
        GenJournalLine."Document No." := Noseries + '-SALARY';
        GenJournalLine.Amount := Amount;
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        GenJournalLine."Source Code" := Sourcecode;
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN BEGIN
            if PayrollEntries."Reference No" <> '' then begin
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
                VendorLedgerEntry.SetRange("Document No.", PayrollEntries."Reference No");
                VendorLedgerEntry.SetRange(Positive, true);
                if VendorLedgerEntry.FindFirst() then begin
                    GenJournalLine."Applies-to Doc. No." := PayrollEntries."Reference No";
                    GenJournalLine."Applies-to Doc. Type" := VendorLedgerEntry."Document Type";
                end;
            end;
        END;
        IF GenJournalLine.Amount <> 0 THEN BEGIN
            GenJournalLine.INSERT;
        END;
    end;

    procedure CreatingContJurnalLines(Description: Text; PayrollEntries: Record "Payroll Entries"; Employee: Record Employee; Amount: Decimal; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No.": Code[20]; GnLLineNumber: Integer; Sourcecode: Code[20]; TransCode: Code[40]; PostingDate: Date);
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournal: Record "Gen. Journal Line";
        LineNumber: Integer;
        Noseries: Code[20];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        Noseries := FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 2)) + '-' + FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 3));
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := PayrollSetup."General Journal Template Name";
        GenJournalLine."Journal Batch Name" := PayrollSetup."General Journal Batch Name";
        GenJournalLine."Transaction Type Code" := TransCode;
        GenJournal.Reset();
        GenJournal.SetRange(GenJournal."Journal Template Name", PayrollSetup."General Journal Template Name");
        GenJournal.SetRange(GenJournal."Journal Batch Name", PayrollSetup."General Journal Batch Name");
        if GenJournal.FindLast() then
            GenJournalLine."Line No." := GenJournal."Line No." + 1;
        GenJournalLine."Account Type" := "Account Type";
        GenJournalLine."Account No. 2" := "Account No.";
        GenJournalLine."Account No." := "Account No.";
        GenJournalLine."Member No" := Employee."Member No.";
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine.Description := Description + '- ' + Employee."Member No.";
        GenJournalLine."Document No." := Noseries + '-SALARY';
        GenJournalLine.Amount := Amount;
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        GenJournalLine."Source Code" := Sourcecode;
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN BEGIN
            if PayrollEntries."Reference No" <> '' then begin
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
                VendorLedgerEntry.SetRange("Document No.", PayrollEntries."Reference No");
                VendorLedgerEntry.SetRange(Positive, true);
                if VendorLedgerEntry.FindFirst() then begin
                    GenJournalLine."Applies-to Doc. No." := PayrollEntries."Reference No";
                    GenJournalLine."Applies-to Doc. Type" := VendorLedgerEntry."Document Type";
                end;
            end;
        END;
        IF GenJournalLine.Amount <> 0 THEN BEGIN
            GenJournalLine.INSERT;
        END;
    end;

    procedure ClearJournalLines();
    var
        GenJnline: Record "Gen. Journal Line";
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        GenJnline.RESET;
        GenJnline.SETRANGE("Journal Template Name", PayrollSetup."General Journal Template Name");
        GenJnline.SETRANGE("Journal Batch Name", PayrollSetup."General Journal Batch Name");
        IF GenJnline.FINDSET THEN BEGIN
            GenJnline.DELETEALL;
        END;
    end;

    procedure CheckJournal(BatchName: Code[100]) Status: Boolean;
    begin
        Status := FALSE;
        PayrollSetup.RESET;
        IF PayrollSetup."General Journal Batch Name" = BatchName THEN BEGIN
            MESSAGE(PayrollSetup."General Journal Batch Name" + 'ttt' + BatchName);
            Status := TRUE;
        END;
    end;

    procedure CalculateOneThirdOfBasic(Employee: Record Employee): Decimal;
    begin
        WITH Employee DO BEGIN
            PayrollSetup.GET(1);
            IF PayrollSetup."Apply 1/3 Rule?" = TRUE THEN BEGIN
                EXIT(ROUND(GetBasicPay(Employee) * (1 / 3), PayrollSetup."Payroll Roundoff"));
                ;
            END;
        END;
    end;


}

