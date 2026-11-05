report 50415 "staff PaySlip"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\StaffPaySlips.rdl';
    Caption = 'Staff PaySlip';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(TITLECaptionLbl; TITLECaptionLbl)
            {
            }
            column(No; Employee."No.")
            {
            }
            column(Fullname; Fullnames)
            {
            }
            column(Branch; Employee."Global Dimension 1 Code")
            {
            }
            column(Department_Name; "Department Name")
            {

            }
            column(JobTitle; Employee."Job Title")
            {
            }
            column(BranchCodeCaption; BranchCodeCaption)
            {
            }
            column(PayforCaptionLbl; PayforCaptionLbl)
            {
            }
            column(PersonelCaptionLbl; PersonelCaptionLbl)
            {
            }
            column(JobTitleCaption; JobTitleCaption)
            {
            }
            column(NameCaptionLbl; NameCaptionLbl)
            {
            }
            column(PINNoCaption; PINNoCaption)
            {
            }
            column(Employee_PIN; Employee."PIN Number")
            {
            }
            column(NHIFNoCaption; NHIFNoCaption)
            {
            }
            column(Employee_NHIF; Employee.NHIF)
            {
            }
            column(Employee_NSSF; Employee.NSSF)
            {
            }
            column(NSSFNoCaption; NSSFNoCaption)
            {
            }
            column(MonthName; MonthName)
            {
            }
            column(OtherEarnindg_1_; OtherEarning[1])
            {
            }
            column(EARNINGSCaption; EARNINGSCaption)
            {
            }
            column(TOTALEARNINGSCaption; TOTALEARNINGSCaption)
            {
            }
            column(BasicPay; BasicPay)
            {
            }
            column(BasicPayDescCaption; BasicPayDescCaption)
            {
            }
            column(TotalEarning; TotalEarning)
            {
            }
            column(NetPay; NetPay)
            {
            }
            column(NETPAYCaption; NETPAYCaption)
            {
            }
            column(DEDUCTIONSCaption; DEDUCTIONSCaption)
            {
            }
            column(TOTALDEDUCTIONSCaption; TOTALDEDUCTIONSCaption)
            {
            }
            column(TotalDeductions; TotalDeductions)
            {
            }
            column(OtherEarning_1_; OtherEarning[1])
            {
            }
            column(OtherEarning_2_; OtherEarning[2])
            {
            }
            column(OtherEarning_3_; OtherEarning[3])
            {
            }
            column(OtherEarning_4_; OtherEarning[4])
            {
            }
            column(OtherEarning_5_; OtherEarning[5])
            {
            }
            column(OtherEarning_6_; OtherEarning[6])
            {
            }
            column(OtherEarning_7_; OtherEarning[7])
            {
            }
            column(OtherEarning_8_; OtherEarning[8])
            {
            }
            column(OtherEarning_9_; OtherEarning[9])
            {
            }
            column(OtherEarning_10_; OtherEarning[10])
            {
            }
            column(OtherEarningDesc_1_; OtherEarningDesc[1])
            {
            }
            column(OtherEarningDesc_2_; OtherEarningDesc[2])
            {
            }
            column(OtherEarningDesc_3_; OtherEarningDesc[3])
            {
            }
            column(OtherEarningDesc_4_; OtherEarningDesc[4])
            {
            }
            column(OtherEarningDesc_5_; OtherEarningDesc[5])
            {
            }
            column(OtherEarningDesc_6_; OtherEarningDesc[6])
            {
            }
            column(OtherEarningDesc_7_; OtherEarningDesc[7])
            {
            }
            column(OtherEarningDesc_8_; OtherEarningDesc[8])
            {
            }
            column(OtherEarningDesc_9_; OtherEarningDesc[9])
            {
            }
            column(OtherEarningDesc_10_; OtherEarningDesc[10])
            {
            }
            column(NoneCashbenefits_1_; NoneCashbenefits[1])
            {
            }
            column(NoneCashbenefits_2_; NoneCashbenefits[2])
            {
            }
            column(NoneCashbenefits_3_; NoneCashbenefits[3])
            {
            }
            column(NoneCashbenefits_4_; NoneCashbenefits[4])
            {
            }
            column(NoneCashbenefits_5_; NoneCashbenefits[5])
            {
            }
            column(NoneCashbenefits_6_; NoneCashbenefits[6])
            {
            }
            column(NoneCashbenefits_7_; NoneCashbenefits[7])
            {
            }
            column(NoneCashbenefits_8_; NoneCashbenefits[8])
            {
            }
            column(NoneCashbenefits_9_; NoneCashbenefits[9])
            {
            }
            column(NoneCashbenefits_10_; NoneCashbenefits[10])
            {
            }
            column(NoneCashbenefitsdesc_1_; NoneCashbenefitsdesc[1])
            {
            }
            column(NoneCashbenefitsdesc_2_; NoneCashbenefitsdesc[2])
            {
            }
            column(NoneCashbenefitsdesc_3_; NoneCashbenefitsdesc[3])
            {
            }
            column(NoneCashbenefitsdesc_4_; NoneCashbenefitsdesc[4])
            {
            }
            column(NoneCashbenefitsdesc_5_; NoneCashbenefitsdesc[5])
            {
            }
            column(NoneCashbenefitsdesc_6_; NoneCashbenefitsdesc[6])
            {
            }
            column(NoneCashbenefitsdesc_7_; NoneCashbenefitsdesc[7])
            {
            }
            column(NoneCashbenefitsdesc_8_; NoneCashbenefitsdesc[8])
            {
            }
            column(NoneCashbenefitsdesc_9_; NoneCashbenefitsdesc[9])
            {
            }
            column(NoneCashbenefitsdesc_10_; NoneCashbenefitsdesc[10])
            {
            }
            column(TotalNonCash; TotalNonCash)
            {
            }
            column(NONCASHBENEFITSCaption; NONCASHBENEFITSCaption)
            {
            }
            column(TOTALNONCASHBENEFITSCaption; TOTALNONCASHBENEFITSCaption)
            {
            }
            column(PAYE; PAYE)
            {
            }
            column(PAYEafterRelief; PAYEafterRelief)
            { }
            column(TaxableAmount; TaxableAmount)
            {
            }
            column(Totaltax; Totaltax)
            {
            }
            column(PAYCALCULATIONSCaption; PAYCALCULATIONSCaption)
            {
            }
            column(TAXCHARGEDCaption; TAXCHARGEDCaption)
            {
            }
            column(TaxablePayCaption; TaxablePayCaption)
            {
            }
            column(PAYEBeforeReliefCaption; PAYEBeforeReliefCaption)
            {
            }
            column(PAYEAfterReliefCaption; PAYEAfterReliefCaption)
            {
            }
            column(taxrelief_1_; taxrelief[1])
            {
            }
            column(taxrelief_2_; taxrelief[2])
            {
            }
            column(taxrelief_3_; taxrelief[3])
            {
            }
            column(taxrelief_4_; taxrelief[4])
            {
            }
            column(taxrelief_5_; taxrelief[5])
            {
            }
            column(taxreliefDesc_1_; taxreliefDesc[1])
            {
            }
            column(taxreliefDesc_2_; taxreliefDesc[2])
            {
            }
            column(taxreliefDesc_3_; taxreliefDesc[3])
            {
            }
            column(taxreliefDesc_4_; taxreliefDesc[4])
            {
            }
            column(taxreliefDesc_5_; taxreliefDesc[5])
            {
            }
            column(Deductions_1_; Deductions[1])
            {
            }
            column(Deductions_2_; Deductions[2])
            {
            }
            column(Deductions_3_; Deductions[3])
            {
            }
            column(Deductions_4_; Deductions[4])
            {
            }
            column(Deductions_5_; Deductions[5])
            {
            }
            column(Deductions_6_; Deductions[6])
            {
            }
            column(Deductions_7_; Deductions[7])
            {
            }
            column(Deductions_8_; Deductions[8])
            {
            }
            column(Deductions_9_; Deductions[9])
            {
            }
            column(Deductions_10_; Deductions[10])
            {
            }
            column(Deductions_11_; Deductions[11])
            {
            }
            column(Deductions_12_; Deductions[12])
            {
            }
            column(Deductions_13_; Deductions[13])
            {
            }
            column(Deductions_14_; Deductions[14])
            {
            }
            column(Deductions_15_; Deductions[15])
            {
            }
            column(Deductions_16_; Deductions[16])
            {
            }
            column(Deductions_17_; Deductions[17])
            {
            }
            column(Deductions_18_; Deductions[18])
            {
            }
            column(Deductions_19_; Deductions[19])
            {
            }
            column(Deductions_20_; Deductions[20])
            {
            }
            column(DeductionsDesc_1_; DeductionsDesc[1])
            {
            }
            column(DeductionsDesc_2_; DeductionsDesc[2])
            {
            }
            column(DeductionsDesc_3_; DeductionsDesc[3])
            {
            }
            column(DeductionsDesc_4_; DeductionsDesc[4])
            {
            }
            column(DeductionsDesc_5_; DeductionsDesc[5])
            {
            }
            column(DeductionsDesc_6_; DeductionsDesc[6])
            {
            }
            column(DeductionsDesc_7_; DeductionsDesc[7])
            {
            }
            column(DeductionsDesc_8_; DeductionsDesc[8])
            {
            }
            column(DeductionsDesc_9_; DeductionsDesc[9])
            {
            }
            column(DeductionsDesc_10_; DeductionsDesc[10])
            {
            }
            column(DeductionsDesc_11_; DeductionsDesc[11])
            {
            }
            column(DeductionsDesc_12_; DeductionsDesc[12])
            {
            }
            column(DeductionsDesc_13_; DeductionsDesc[13])
            {
            }
            column(DeductionsDesc_14_; DeductionsDesc[14])
            {
            }
            column(DeductionsDesc_15_; DeductionsDesc[15])
            {
            }
            column(DeductionsDesc_16_; DeductionsDesc[16])
            {
            }
            column(DeductionsDesc_17_; DeductionsDesc[17])
            {
            }
            column(DeductionsDesc_18_; DeductionsDesc[18])
            {
            }
            column(DeductionsDesc_19_; DeductionsDesc[19])
            {
            }
            column(DeductionsDesc_20_; DeductionsDesc[20])
            {
            }
            column(MyLoanBalance_1_; MyLoanBalance[1])
            {
            }
            column(MyLoanBalance_2_; MyLoanBalance[2])
            {
            }
            column(MyLoanBalance_3_; MyLoanBalance[3])
            {
            }
            column(MyLoanBalance_4_; MyLoanBalance[4])
            {
            }
            column(MyLoanBalance_5_; MyLoanBalance[5])
            {
            }
            column(MyLoanBalance_6_; MyLoanBalance[6])
            {
            }
            column(MyLoanBalance_7_; MyLoanBalance[7])
            {
            }
            column(MyLoanBalance_8_; MyLoanBalance[8])
            {
            }
            column(MyLoanBalance_9_; MyLoanBalance[9])
            {
            }
            column(MyLoanBalance_10_; MyLoanBalance[10])
            {
            }
            column(MyLoanBalance_11_; MyLoanBalance[11])
            {
            }
            column(MyLoanBalance_12_; MyLoanBalance[12])
            {
            }
            column(MyLoanBalance_13_; MyLoanBalance[13])
            {
            }
            column(MyLoanBalance_14_; MyLoanBalance[14])
            {
            }
            column(MyLoanBalance_15_; MyLoanBalance[15])
            {
            }
            column(MyLoanBalance_16_; MyLoanBalance[16])
            {
            }
            column(MyLoanBalance_17_; MyLoanBalance[17])
            {
            }
            column(MyLoanBalance_18_; MyLoanBalance[18])
            {
            }
            column(MyLoanBalance_19_; MyLoanBalance[19])
            {
            }
            column(MyLoanBalance_20_; MyLoanBalance[20])
            {
            }

            trigger OnAfterGetRecord();
            begin
                Fullnames := '';
                BasicPay := 0;
                TotalEarning := 0;
                TotalDeductions := 0;
                TotalNonCash := 0;
                TaxableAmount := 0;
                PAYE := 0;
                Totaltaxrelief := 0;
                Totaltax := 0;
                PAYEafterRelief := 0;
                MonthName := UPPERCASE(FORMAT(PayPeriod, 0, '<month text> <year4>'));
                Fullnames := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                //======================================================================
                Earningsetup.RESET;
                Earningsetup.SETRANGE("Basic Salary Code", TRUE);
                IF Earningsetup.FINDFIRST THEN BEGIN
                    PayrollEntries.RESET;
                    PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Payment);
                    PayrollEntries.SETRANGE("Employee No", Employee."No.");
                    PayrollEntries.SETRANGE(Code, Earningsetup.Code);
                    PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                    IF PayrollEntries.FINDFIRST THEN BEGIN
                        BasicPay := PayrollEntries.Amount;
                    END;
                END;
                //======================================================================
                E := 1;
                PayrollEntries.RESET;
                PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Payment);
                PayrollEntries.SETRANGE("Non-Cash Benefit", FALSE);
                PayrollEntries.SETRANGE("Basic Salary Code", FALSE);
                PayrollEntries.SETRANGE("Employee No", Employee."No.");
                IF PayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        Earningsetup.RESET;
                        IF Earningsetup.GET(PayrollEntries.Code) THEN BEGIN
                            IF (Earningsetup."Non-Cash Benefit" = FALSE) AND (Earningsetup."Basic Salary Code" = FALSE) THEN BEGIN
                                OtherEarning[E] := ABS(PayrollEntries.Amount);
                                OtherEarningDesc[E] := PayrollEntries.Description;
                                E += 1;
                            END;
                        END;
                    UNTIL (PayrollEntries.NEXT = 0) OR (E = 20);
                END;
                //======================================================================
                N := 1;
                Earningsetup.RESET;
                Earningsetup.SETRANGE("Non-Cash Benefit", TRUE);
                Earningsetup.SetFilter("Earning Type", '%1|%2|%3', Earningsetup."Earning Type"::"Tax Relief", Earningsetup."Earning Type"::"Insurance Relief", Earningsetup."Earning Type"::"AHL Relief");
                IF Earningsetup.FINDFIRST THEN BEGIN
                    REPEAT
                        PayrollEntries.RESET;
                        PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                        PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Payment);
                        PayrollEntries.SETRANGE("Employee No", Employee."No.");
                        PayrollEntries.SETRANGE(Code, Earningsetup.Code);
                        IF PayrollEntries.FINDFIRST THEN BEGIN
                            NoneCashbenefits[N] := ABS(PayrollEntries.Amount);
                            NoneCashbenefitsdesc[N] := PayrollEntries.Description;
                            TotalNonCash := TotalNonCash + ABS(PayrollEntries.Amount);
                            N += 1;
                        END;
                    UNTIL Earningsetup.NEXT = 0;
                END;
                //======================================================================
                Deductionsetup.RESET;
                Deductionsetup.SETRANGE("PAYE Code", TRUE);
                IF Deductionsetup.FINDFIRST THEN BEGIN
                    /* PayrollEntries.RESET;
                     PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                     PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Deduction);
                     PayrollEntries.SETRANGE("Employee No", Employee."No.");
                     PayrollEntries.SETRANGE(Code, Deductionsetup.Code);
                     IF PayrollEntries.FINDFIRST THEN BEGIN
                         PAYE := ABS(PayrollEntries.Amount);
                         TaxableAmount := ABS(PayrollEntries."Taxable amount");
                     END ELSE BEGIN*/
                    Deductionsetup.TESTFIELD("Deduction Table");
                    BracketTable.GET(Deductionsetup."Deduction Table");
                    TaxableAmount := PayrollManagement.GetTaxableAmount(Employee, PayPeriod);
                    PAYE := Round(GetTaxCharged(BracketTable, TaxableAmount, PayPeriod), 1, '=');

                    // END;
                END;
                //======================================================================
                I := 1;
                Earningsetup.RESET;
                Earningsetup.SETFILTER("Earning Type", '%1', Earningsetup."Earning Type"::"Tax Relief");
                IF Earningsetup.FINDFIRST THEN BEGIN
                    REPEAT
                        PayrollEntries.RESET;
                        PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                        PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Payment);
                        PayrollEntries.SETRANGE("Employee No", Employee."No.");
                        PayrollEntries.SETRANGE(Code, Earningsetup.Code);
                        IF PayrollEntries.FINDFIRST THEN BEGIN
                            taxrelief[I] := ABS(PayrollEntries.Amount);
                            taxreliefDesc[I] := 'Less ' + PayrollEntries.Description;
                        END;
                    UNTIL Earningsetup.NEXT = 0;
                END;

                //======================================================================
                //======================================================================
                J := 2;
                Earningsetup.RESET;
                Earningsetup.SETFILTER("Earning Type", '%1', Earningsetup."Earning Type"::"Insurance Relief");
                IF Earningsetup.FINDFIRST THEN BEGIN
                    REPEAT
                        PayrollEntries.RESET;
                        PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                        PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Payment);
                        PayrollEntries.SETRANGE("Employee No", Employee."No.");
                        PayrollEntries.SETRANGE(Code, Earningsetup.Code);
                        IF PayrollEntries.FINDFIRST THEN BEGIN
                            taxrelief[J] := ABS(PayrollEntries.Amount);
                            taxreliefDesc[J] := 'Less ' + PayrollEntries.Description;
                        END;
                    UNTIL Earningsetup.NEXT = 0;
                END;
                K := 3;
                Earningsetup.RESET;
                Earningsetup.SETFILTER("Earning Type", '%1', Earningsetup."Earning Type"::"AHL Relief");
                IF Earningsetup.FINDFIRST THEN BEGIN
                    REPEAT
                        PayrollEntries.RESET;
                        PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                        PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Payment);
                        PayrollEntries.SETRANGE("Employee No", Employee."No.");
                        PayrollEntries.SETRANGE(Code, Earningsetup.Code);
                        IF PayrollEntries.FINDFIRST THEN BEGIN
                            taxrelief[K] := ABS(PayrollEntries.Amount);
                            taxreliefDesc[K] := 'Less ' + PayrollEntries.Description;
                        END;
                    UNTIL Earningsetup.NEXT = 0;
                END;
                Totaltaxrelief := taxrelief[I] + taxrelief[J] + taxrelief[K];

                If PAYE <> 0 then begin
                    Totaltax := PAYE;
                    If PAYE - Totaltaxrelief < 0 then begin
                        PAYEafterRelief := 0;
                    end else begin
                        PAYEafterRelief := PAYE - Totaltaxrelief;
                    end;
                end;
                //======================================================================
                D := 1;
                PayrollEntries.RESET;
                PayrollEntries.SETRANGE("Payroll Period", PayPeriod);
                PayrollEntries.SETRANGE(Type, PayrollEntries.Type::Deduction);
                PayrollEntries.SETRANGE(Paye, FALSE);
                PayrollEntries.SETRANGE("Employee No", Employee."No.");
                IF PayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        Deductions[D] := ABS(PayrollEntries.Amount);
                        DeductionsDesc[D] := PayrollEntries.Description;
                        Deductionsetup.RESET;
                        IF Deductionsetup.GET(PayrollEntries.Code) THEN BEGIN
                            IF Deductionsetup.Loan = TRUE THEN BEGIN
                                IF PayrollEntries."Reference No" <> '' THEN BEGIN
                                    Customer.RESET;
                                    Customer.SETRANGE("No.", PayrollEntries."Reference No");
                                    IF Customer.FINDFIRST THEN BEGIN
                                        Customer.CALCFIELDS("Balance (LCY)");
                                        MyLoanBalance[D] := ABS(Customer."Balance (LCY)");
                                    END;
                                END;
                            END ELSE BEGIN
                                ;
                                IF (Deductionsetup."Account Types" <> '') AND (Deductionsetup."Account Type" = Deductionsetup."Account Type"::Customer) THEN BEGIN
                                    Customer.RESET;
                                    Customer.SETRANGE("Loan Product Type", Deductionsetup."Account Types");
                                    Customer.SETRANGE("Member No.", Employee."Member No.");
                                    IF Customer.FINDFIRST THEN BEGIN
                                        Customer.CALCFIELDS("Balance (LCY)");
                                        MyLoanBalance[D] := ABS(Customer."Balance (LCY)");
                                    END;
                                END;
                            END;
                        END;
                        D += 1;
                    UNTIL (PayrollEntries.NEXT = 0) OR (D = 20);
                END;
                TotalEarning := PayrollManagement.GetGrossPay(Employee, PayPeriod);
                TotalDeductions := PayrollManagement.GetTotalDeductions(Employee, PayPeriod);
                NetPay := TotalEarning - TotalDeductions;
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PayPeriod; PayPeriod)
                {
                    Caption = 'Payroll Period';
                    TableRelation = "Payroll Period";
                    ApplicationArea = All;
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
    trigger OnPreReport();
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then begin
                Error('You do not have permission to view this page');
            end;
        end;
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
        end;
    end;

    var
        PAYEafterRelief: Decimal;
        BracketLines: Record "Bracket Line";
        PayrollSetup: Record "Payroll Setup";
        NameCaptionLbl: Label 'Employee Name :';
        PayforCaptionLbl: Label 'Payslip for:';
        PersonelCaptionLbl: Label 'Personnel No.:';
        JobTitleCaption: Label 'Job Title:';
        Fullnames: Text;
        BasicPay: Decimal;
        BracketTable: Record "Bracket Table";
        OtherEarning: array[100] of Decimal;
        OtherEarningDesc: array[100] of Text;
        NoneCashbenefits: array[100] of Decimal;
        NoneCashbenefitsdesc: array[100] of Text;
        PAYE: Decimal;
        EARNINGSCaption: Label 'EARNINGS';
        TOTALEARNINGSCaption: Label 'TOTAL EARNINGS';
        NONCASHBENEFITSCaption: Label 'NON CASH BENEFITS';
        TOTALNONCASHBENEFITSCaption: Label 'TOTAL NON CASH BENEFITS';
        DEDUCTIONSCaption: Label 'DEDUCTIONS';
        TOTALDEDUCTIONSCaption: Label 'TOTAL DEDUCTIONS';
        Deductions: array[100] of Decimal;
        DeductionsDesc: array[100] of Text;
        MyLoanBalance: array[100] of Decimal;
        Earningsetup: Record "Earnings Setup";
        Deductionsetup: Record "Deductions Setup";
        Deductionsetup2: Record "Deductions Setup";
        PayrollEntries: Record "Payroll Entries";
        PayPeriod: Date;
        BasicPayDescCaption: Label 'Basic Pay';
        D: Integer;
        E: Integer;
        N: Integer;
        I: Integer;
        J: Integer;
        K: Integer;
        TotalEarning: Decimal;
        TotalDeductions: Decimal;
        NetPay: Decimal;
        NETPAYCaption: Label 'NET PAY';
        TotalNonCash: Decimal;
        TaxableAmount: Decimal;
        TAXATIONCaption: Label 'TAXATION';
        taxrelief: array[100] of Decimal;
        taxreliefDesc: array[100] of Text;
        Totaltaxrelief: Decimal;
        Totaltax: Decimal;
        PAYCALCULATIONSCaption: Label 'PAYE CALCULATIONS';
        TAXCHARGEDCaption: Label 'TAX CHARGED';
        TaxablePayCaption: Label 'Taxable Pay';
        PAYEBeforeReliefCaption: Label 'PAYE Before Relief';
        PAYEAfterReliefCaption: Label 'PAYE After Relief';
        Customer: Record Customer;
        PINNoCaption: Label 'PIN No.';
        NHIFNoCaption: Label 'NHIF No.';
        NSSFNoCaption: Label 'NSSF No.';
        BranchCodeCaption: Label 'Branch Code';
        MonthName: Text;
        CompInfo: Record "Company Information";
        TITLECaptionLbl: Label 'PAYSLIP';
        BranchCodeCaptionLbl: Label 'Branch Code';
        PayrollManagement: Codeunit "Payroll Processing";
}

