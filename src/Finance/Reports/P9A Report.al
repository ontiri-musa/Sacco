report 50404 "P9A Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\P9A Report.rdlc';
    Caption = 'P9A Report';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(First_Name________Middle_Name_; "First Name" + ' ' + "Middle Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Company_Pin; Company."Company P.I.N")
            {
            }
            column(V30__; '30%')
            {
            }
            column(Actual_; 'Actual')
            {
            }
            column(Fixed_; 'Fixed')
            {
            }
            column(Employee__PIN_Number_; "PIN Number")
            {
            }
            column(FORMAT_StringDate_0___year4___; FORMAT(StringDate, 0, '<year4>'))
            {
            }
            column(CoPin; CoPin)
            {
            }
            column(Employee_Employee__No__; Employee."No.")
            {
            }
            column(Employers_Name_Caption; Employers_Name_CaptionLbl)
            {
            }
            column(Employee_s_Main_Name_Caption; Employee_s_Main_Name_CaptionLbl)
            {
            }
            column(Employee_s_Other_Names_Caption; Employee_s_Other_Names_CaptionLbl)
            {
            }
            column(Employers_PIN_Caption; Employers_PIN_CaptionLbl)
            {
            }
            column(Employee_s_PIN_Caption; Employee_s_PIN_CaptionLbl)
            {
            }
            column(MonthCaption; MonthCaptionLbl)
            {
            }
            column(Gross_SalaryCaption; Gross_SalaryCaptionLbl)
            {
            }
            column(BenefitsCaption; BenefitsCaptionLbl)
            {
            }
            column(QuartersCaption; QuartersCaptionLbl)
            {
            }
            column(Total_A_B_CCaption; Total_A_B_CCaptionLbl)
            {
            }
            column(Defined_Contribution_Retr__SchemeCaption; Defined_Contribution_Retr__SchemeCaptionLbl)
            {
            }
            column(Taxable_AmountCaption; Taxable_AmountCaptionLbl)
            {
            }
            column(Personal_ReliefCaption; Personal_ReliefCaptionLbl)
            {
            }
            column(P_A_Y_E_TAXCaption; P_A_Y_E_TAXCaptionLbl)
            {
            }
            column(KENYA_REVENUE_AUTHORITYCaption; KENYA_REVENUE_AUTHORITYCaptionLbl)
            {
            }
            column(INCOME_TAX_DEPARTMENTCaption; INCOME_TAX_DEPARTMENTCaptionLbl)
            {
            }
            column(INCOME_TAX_DEDUCTION_CARD_YEAR_Caption; INCOME_TAX_DEDUCTION_CARD_YEAR_CaptionLbl)
            {
            }
            column(Tax_ChargedCaption; Tax_ChargedCaptionLbl)
            {
            }
            column(Owner_OccupiedCaption; Owner_OccupiedCaptionLbl)
            {
            }
            column(Retr__Contribution__Caption; Retr__Contribution__CaptionLbl)
            {
            }
            column(ACaption; ACaptionLbl)
            {
            }
            column(BCaption; BCaptionLbl)
            {
            }
            column(CCaption; CCaptionLbl)
            {
            }
            column(DCaption; DCaptionLbl)
            {
            }
            column(F__Standard_Amount_Caption; F__Standard_Amount_CaptionLbl)
            {
            }
            column(G___Lowest_of_E_F_Caption; G___Lowest_of_E_F_CaptionLbl)
            {
            }
            column(HCaption; HCaptionLbl)
            {
            }
            column(JCaption; JCaptionLbl)
            {
            }
            column(KCaption; KCaptionLbl)
            {
            }
            column(LCaption; LCaptionLbl)
            {
            }
            column(MCaption; MCaptionLbl)
            {
            }
            column(ECaption; ECaptionLbl)
            {
            }
            column(IMPORTANT; IMPORTANT)
            {
            }
            column(UseP9A_a; "UseP9A(a)")
            {
            }
            column(UseP9A_b; "UseP9A(b)")
            {
            }
            column(Two_a; "2(a)")
            {
            }
            column(Two_b_1; "2(b)(i)")
            {
            }
            column(Two_b_2; "2(b)(ii)")
            {
            }
            column(CompletionByEmployerLbl; CompletionByEmployerLbl)
            {
            }
            column(Use_P9A_1; "1_Use_P9A")
            {
            }
            column(b_Attach; b_Attach)
            {
            }
            column(InterestCaption; InterestCaptionLbl)
            {
            }
            column(Column_D_GCaption; Column_D_GCaptionLbl)
            {
            }
            column(Occupied_InterestCaption; Occupied_InterestCaptionLbl)
            {
            }
            column(Non_CashCaption; Non_CashCaptionLbl)
            {
            }
            column(Value_OfCaption; Value_OfCaptionLbl)
            {
            }
            column(Personal_File_No_Caption; Personal_File_No_CaptionLbl)
            {
            }
            column(Insurance_ReliefCaption; Insurance_ReliefCaptionLbl)
            {
            }
            dataitem("Payroll Period"; "Payroll Period")
            {
                column(Payroll_PeriodX1_Name; UPPERCASE(FORMAT("Payroll Period"."Starting Date", 0, '<Month Text>')))
                {
                }
                column(BenefitsVar; BenefitsVar)
                {
                }
                column(QuartersVar; QuartersVar)
                {
                }
                column(RetirementVar; RetirementVar)
                {
                }
                column(TaxableAmount1; TaxableAmount)
                {
                }
                column(Relief; Relief)
                {
                }
                column(InsuranceRelief; InsuranceRelief)
                {
                }
                column(ABS_Employee__Cumm__PAYE__; TotalPAYE)
                {
                }
                column(PensionLimit; PensionLimit)
                {
                }
                column(Employee__Total_Allowances_; BasicPay)
                {
                }
                column(Employee__Taxable_Allowance__Employee__Cumm__Basic_Pay__BenefitsVar_QuartersVar; grosspay + BenefitsVar + QuartersVar)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Relief_InsuranceRelief; PAYE_Relief_InsuranceRelief)
                {
                }
                column(ABS_OccupierVar_; ABS(OccupierVar))
                {
                }
                column(V30PerPension_; "30PerPension")
                {
                }
                column(ABS_DefinedContrMin__ABS_OccupierVar_; DefinedContrMin_OccupierVar)
                {
                }
                column(TotBasic; TotBasic)
                {
                }
                column(TotalBenefits; TotalBenefits)
                {
                }
                column(TotQuarter; TotQuarter)
                {
                }
                column(TotGross; TotGross)
                {
                }
                column(V30PerPension__Control188; "30PerPension")
                {
                }
                column(ABS_RetirementVar_; ABS(RetirementVar))
                {
                }
                column(TaxableAmount_Control196; TaxableAmount)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Relief_InsuranceRelief_Control198; TotalPAYE + Relief + InsuranceRelief)
                {
                }
                column(Relief_Control200; Relief)
                {
                }
                column(InsuranceRelief_Control202; InsuranceRelief)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Control204; TotalPAYE)
                {
                }
                column(OccupierVar; OccupierVar)
                {
                }
                column(TaxableAmount; TaxableAmount2)
                {
                }
                column(TotRet; TotRet)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Control164; TotalPAYE)
                {
                }
                column(TaxableAmount_Control166; TaxableAmount)
                {
                }
                column(P9A_; 'P9A')
                {
                }
                column(PensionLimit_Control1000000000; PensionLimit)
                {
                }
                column(CERTIFICATE_OF_PAY_AND_TAXCaption; CERTIFICATE_OF_PAY_AND_TAXCaptionLbl)
                {
                }
                column(NAME______________; NAME_________Lbl)
                {
                }
                column(ADDRESS______________; ADDRESS________Lbl)
                {
                }
                column(SIGNATURE_________________________; SIGNATURE______Lbl)
                {
                }
                column(DATE___STAMP_____________________; DATE___STAMP______Lbl)
                {
                }
                column(NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaption; NAMES_OF_MORTGAGELbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(L_R__NO__OF_OWNER_OCCUPIED_HOUSE___________; L_R__NO__OF_OWNER_OCCUPIED_HOUSE______CapLbl)
                {
                }
                column(DATE_OF_OCCUPATION; DATE_OF_OCCUPATION_____CapLbl)
                {
                }
                column(TOTALSCaption; TOTALSCaptionLbl)
                {
                }
                column(V1__Date_employee_commenced_if_during_the_y; V1__Date_employee_commenced_if_during_the_year____CaptionLbl)
                {
                }
                column(Name_and_address_of_old_employer________________; Name_and_address_of_old_employer___CaptionLbl)
                {
                }
                column(V2__Date_left_if_during_the_year_____________________; V2__Date_left_if_during_the_year________CaptionLbl)
                {
                }
                column(Name_and_address_of_new_employer___________; Name_and_address_of_old_employer___CaptionLbl)
                {
                }
                column(V3__Where_housing_is_provided_State_mo; V3__Where_housing_is_provided_State_monthly_rent__________________________CaptionLbl)
                {
                }
                column(V4__Where_any_of_the_pay_relates_to_a; V4__Where_any_of_the_pay_relates_to_a_period_other_than_this_year_e_g_gratuity__give_details____Lbl)
                {
                }
                column(YearCaption; YearCaptionLbl)
                {
                }
                column(Amount_Kenya_Pounds_Caption; Amount_Kenya_Pounds_CaptionLbl)
                {
                }
                column(Tax__Shs_Caption; Tax__Shs_CaptionLbl)
                {
                }
                column(Reference_No_; Reference_No___CaptionLbl)
                {
                }
                column(TOTAL_TAX__COL_M__KshsCaption; TOTAL_TAX__COL_M__KshsCaptionLbl)
                {
                }
                column(TOTAL_CHARGEABLE_PAY__COL_H__KshsCaption; TOTAL_CHARGEABLE_PAY__COL_H__KshsCaptionLbl)
                {
                }
                column(Payroll_PeriodX1_Starting_Date; "Starting Date")
                {
                }
                column(Payroll_PeriodX1_P_A_Y_E; "P.A.Y.E")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PayrollSetups.Get(1);
                    TotalAllowances := 0;
                    BasicPay := 0;
                    PayrollPeriods := "Payroll Period"."Starting Date";
                    GetBasicPay();
                    GetTotalAllowances();
                    Get30PerPension();
                    GetNonCashBenefits();
                    GetOwnerOccupier();
                    GetTaxRelief();
                    GetInsuranceRelief();
                    TaxableAmount := 0;
                    PensionLimit := 0;
                    RetirementVar := 0;
                    TaxableAmount := 0;
                    InsuranceRelief := 0;
                    IncomeTax := 0;
                    Relief := 0;
                    PAYE_Relief_InsuranceRelief := 0;
                    GetTotalPAYE();
                    GetPensonLimit();
                end;

                trigger OnPreDataItem();
                begin
                    "Payroll Period".SETRANGE("Payroll Period"."Starting Date", StringDate, EndDate);
                end;
            }
            dataitem("Earnings Setup"; "Earnings Setup")
            {
                column(EarningsX1_Description; Description)
                {
                }
                column(EarningsX1__Total_Amount_; "Total Amount")
                {
                }
                column(EarningsX1_Counter; Counter)
                {
                }
                column(EarningsX1__Flat_Amount_; "Flat Amount")
                {
                }
                column(Numb; Numb)
                {
                }
                column(EmployeeBenefits; EmployeeBenefits)
                {
                }
                column(P9A__Control113; 'P9A')
                {
                }
                column(ITEMCaption; ITEMCaptionLbl)
                {
                }
                column(NO_Caption; NO_CaptionLbl)
                {
                }
                column(RATECaption; RATECaptionLbl)
                {
                }
                column(NO__OF_MONTHSCaption; NO__OF_MONTHSCaptionLbl)
                {
                }
                column(TOTAL_AMOUNT_K__shs_Caption; TOTAL_AMOUNT_K__shs_CaptionLbl)
                {
                }
                column(CALCULATION_OF_BENEFITSCaption; CALCULATION_OF_BENEFITSCaptionLbl)
                {
                }
                column(XCaption; XCaptionLbl)
                {
                }
                column(TOTAL_BENEFIT_IN_YEARCaption; TOTAL_BENEFIT_IN_YEARCaptionLbl)
                {
                }
                column(Where_actual_cost_is_higher_than_given_monthly_rates_of; When_given_monthly_ratesn_fullCaptionLbl)
                {
                }
                column(LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_Caption; LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_CaptionLbl)
                {
                }
                column(EMPLOYERS_LOAN____Kshs_______________________________; EMPLOYERS_LOAN____Kshs)
                {
                }
                column(MONTHLY_BENEFIT_____________RATE_DIFFERENCE_X_LOAN__; MONTHLY_BENEFIT__shs________Lbl)
                {
                }
                column(MOTOR_CARSCaption; MOTOR_CARSCaptionLbl)
                {
                }
                column(Upto_1500cCaption; Upto_1500cCaptionLbl)
                {
                }
                column(V1501cc_1750ccCaption; V1501cc_1750ccCaptionLbl)
                {
                }
                column(V1751cc_2000cCaption; V1751cc_2000cCaptionLbl)
                {
                }
                column(Over_3000cCaption; Over_3000cCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control209; EmptyStringCaption_Control209Lbl)
                {
                }
                column(EmptyStringCaption_Control210; EmptyStringCaption_Control210Lbl)
                {
                }
                column(EmptyStringCaption_Control211; EmptyStringCaption_Control211Lbl)
                {
                }
                column(EmptyStringCaption_Control213; EmptyStringCaption_Control213Lbl)
                {
                }
                column(If_this_amount_does_not_agree_with_total_of_Col__b_overlea; If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_CaptionLbl)
                {
                }
                column(FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO; FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_CaptionLbl)
                {
                }
                column(CAR_BENEFIT___The_higher_the_amount_of_the_monthly_rate_or_the_pre; CAR_BENEFIT___The_higherf_benefits_is_to_be_brought_to_charge__CaptiLbl)
                {
                }
                column(PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___Caption; PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(V2001cc_3000ccCaption; V2001cc_3000ccCaptionLbl)
                {
                }
                column(V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___Caption; V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___Caption; V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control224; EmptyStringCaption_Control224Lbl)
                {
                }
                column(KshsCaption; KshsCaptionLbl)
                {
                }
                column(EarningsX1_Code; Code)
                {
                }
                column(EarningsX1_Employee_Filter; "Employee Filter")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                if "Employee Status" <> "Employee Status"::Active then CurrReport.Skip();
                TotBasic := 0;
                TotNonQuarter := 0;
                TotQuarter := 0;
                TotGross := 0;
                TotPercentage := 0;
                TotActual := 0;
                TotFixed := 0;
                TotTaxable := 0;
                TotTax := 0;
                TotRelief := 0;
                TotPAYE := 0;
                NoOfMonths := 0;
                TotalBenefits := 0;
                TotOcc := 0;
                TotRet := 0;
                TotPound := 0;
                grandPAYE := 0;
                TotalPAYE := 0;
                PAYE_Relief_InsuranceRelief := 0;
                TotalAllowances := 0;
                Company.GET;

            end;

            trigger OnPreDataItem();
            begin
                IF Employee.COUNT > 1 THEN BEGIN
                    ERROR('You Can Only Print P9A for One Staff At A Time!');
                END;

                IF Years = 0 THEN BEGIN
                    ERROR('Please Specify The YEAR For The Period');
                END;

                IF STRLEN(FORMAT(Years)) <> 4 THEN BEGIN
                    ERROR('ENTER A FOUR DIGIT NUMBER, I.e %1', DATE2DMY(TODAY, 3) - 1);
                END;
                EVALUATE(MyDate, '0101' + '' + FORMAT(Years));
                StringDate := CALCDATE('<-CY>', MyDate);
                EndDate := CALCDATE('<CY>', MyDate);
                CUser := USERID;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Period)
                {
                }
                field("Enter Year"; Years)
                {
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

    var
        Employers_Name_CaptionLbl: Label 'Employers Name:';
        Employee_s_Main_Name_CaptionLbl: Label 'Employee''s Main Name:';
        Employee_s_Other_Names_CaptionLbl: Label 'Employee''s Other Names:';
        Employers_PIN_CaptionLbl: Label 'Employers PIN:';
        Employee_s_PIN_CaptionLbl: Label 'Employee''s PIN:';
        MonthCaptionLbl: Label 'Month';
        Gross_SalaryCaptionLbl: Label 'Gross Salary';
        BenefitsCaptionLbl: Label 'Benefits';
        QuartersCaptionLbl: Label 'Quarters';
        Total_A_B_CCaptionLbl: Label 'Total A+B+C';
        Defined_Contribution_Retr__SchemeCaptionLbl: Label 'Defined Contribution Retr. Scheme';
        Taxable_AmountCaptionLbl: Label 'Taxable Amount';
        Personal_ReliefCaptionLbl: Label 'Personal Relief';
        P_A_Y_E_TAXCaptionLbl: Label 'P.A.Y.E TAX';
        KENYA_REVENUE_AUTHORITYCaptionLbl: Label 'KENYA REVENUE AUTHORITY';
        INCOME_TAX_DEPARTMENTCaptionLbl: Label 'INCOME TAX DEPARTMENT';
        INCOME_TAX_DEDUCTION_CARD_YEAR_CaptionLbl: Label 'INCOME TAX DEDUCTION CARD YEAR:';
        Tax_ChargedCaptionLbl: Label 'Tax Charged';
        Owner_OccupiedCaptionLbl: Label 'Owner Occupied';
        Retr__Contribution__CaptionLbl: Label 'Retr. Contribution &';
        ACaptionLbl: Label 'A';
        BCaptionLbl: Label 'B';
        CCaptionLbl: Label 'C';
        DCaptionLbl: Label 'D';
        F__Standard_Amount_CaptionLbl: Label 'F (Standard Amount)';
        G___Lowest_of_E_F_CaptionLbl: Label 'G  (Lowest of E+F)';
        HCaptionLbl: Label 'H';
        JCaptionLbl: Label 'J';
        KCaptionLbl: Label 'K';
        LCaptionLbl: Label 'L';
        MCaptionLbl: Label 'M';
        ECaptionLbl: Label 'E';
        InterestCaptionLbl: Label '" Interest"';
        Column_D_GCaptionLbl: Label 'Column D-G';
        Occupied_InterestCaptionLbl: Label '" Occupied Interest"';
        Non_CashCaptionLbl: Label 'Non-Cash';
        Value_OfCaptionLbl: Label 'Value Of';
        Personal_File_No_CaptionLbl: Label 'Personal File No.';
        Insurance_ReliefCaptionLbl: Label 'Insurance Relief';
        CERTIFICATE_OF_PAY_AND_TAXCaptionLbl: Label 'CERTIFICATE OF PAY AND TAX';
        NAME_________Lbl: Label 'NAME            ..................................................................................................';
        ADDRESS________Lbl: Label 'ADDRESS     ...........................................................................................................';
        SIGNATURE______Lbl: Label 'SIGNATURE   ..........................................................................................................';
        DATE___STAMP______Lbl: Label 'DATE & STAMP   ...............................................................................................';
        NAMES_OF_MORTGAGELbl: Label 'NAMES OF MORTGAGE FINANCIAL INSTITUTION ADVANCING MORTGAGE LOAN';
        EmptyStringCaptionLbl: Label '.....................................................................................................................................................';
        L_R__NO__OF_OWNER_OCCUPIED_HOUSE______CapLbl: Label 'L.R. NO. OF OWNER OCCUPIED PROPERTY ............................................';
        DATE_OF_OCCUPATION_____CapLbl: Label 'DATE OF OCCUPATION OF HOUSE ...............................';
        TOTALSCaptionLbl: Label 'TOTALS';
        V1__Date_employee_commenced_if_during_the_year____CaptionLbl: Label '(1) Date employee commenced if during the year...............................................';
        Name_and_address_of_old_employer___CaptionLbl: Label '"      Name and address of old employer.................................................................."';
        V2__Date_left_if_during_the_year________CaptionLbl: Label '(2) Date left if during the year....................................................................................';
        Name_and_address_of_new_employe_____CaptionLbl: Label '"     Name and address of new employer................................................................."';
        V3__Where_housing_is_provided_State_monthly_rent__________________________CaptionLbl: Label '(3) Where housing is provided,State monthly rent..............................................';
        V4__Where_any_of_the_pay_relates_to_a_period_other_than_this_year_e_g_gratuity__give_details____Lbl: Label '(4) Where any of the pay relates to a period other than this year e.g gratuity, give details...........................................';
        YearCaptionLbl: Label 'Year';
        Amount_Kenya_Pounds_CaptionLbl: Label 'Amount(Kenya Pounds)';
        Tax__Shs_CaptionLbl: Label 'Tax (Shs)';
        Reference_No___CaptionLbl: Label 'Reference No:  .....................................................';
        TOTAL_TAX__COL_M__KshsCaptionLbl: Label 'TOTAL TAX (COL L) Kshs';
        TOTAL_CHARGEABLE_PAY__COL_H__KshsCaptionLbl: Label 'TOTAL CHARGEABLE PAY (COL H) Kshs';
        ITEMCaptionLbl: Label 'ITEM';
        NO_CaptionLbl: Label 'NO.';
        RATECaptionLbl: Label 'RATE';
        NO__OF_MONTHSCaptionLbl: Label 'NO. OF MONTHS';
        TOTAL_AMOUNT_K__shs_CaptionLbl: Label 'TOTAL AMOUNT K. shs.';
        CALCULATION_OF_BENEFITSCaptionLbl: Label 'CALCULATION OF BENEFITS';
        XCaptionLbl: Label 'X';
        TOTAL_BENEFIT_IN_YEARCaptionLbl: Label 'TOTAL BENEFIT IN YEAR';
        When_given_monthly_ratesn_fullCaptionLbl: Label '* Where actual cost is higher than given monthly rates of benefits then the actual cost is brought to charge in full';
        LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_CaptionLbl: Label 'LOW INTERES RATE BELOW PRESCRIBED RATE OF (15%) PER CENT.';
        EMPLOYERS_LOAN____Kshs: TextConst ENU = 'EMPLOYERS LOAN   =Kshs..........................@............% RATE          RATE DIFFERENCE    (PRESCRIBED RARE - EMPLOYERS RATE)  =    15%  -   ..........%  =   ........%';
        MONTHLY_BENEFIT__shs________Lbl: TextConst ENU = 'MONTHLY BENEFIT            (RATE DIFFERENCE X LOAN)/12    =      .................................%     X        Kshs. ......................../12   = Kshs...............................';
        MOTOR_CARSCaptionLbl: Label 'MOTOR CARS';
        Upto_1500cCaptionLbl: Label 'Upto 1500c';
        V1501cc_1750ccCaptionLbl: Label '1501cc-1750cc';
        V1751cc_2000cCaptionLbl: Label '1751cc-2000c';
        Over_3000cCaptionLbl: Label 'Over 3000c';
        EmptyStringCaption_Control209Lbl: TextConst ENU = '=';
        EmptyStringCaption_Control210Lbl: TextConst ENU = '=';
        EmptyStringCaption_Control211Lbl: TextConst ENU = '=';
        EmptyStringCaption_Control213Lbl: TextConst ENU = '=';
        If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_CaptionLbl: Label 'If this amount does not agree with total of Col. b overleaf, attach explanation.';
        FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_CaptionLbl: Label 'FOR PICK-UPS, PANEL VANS AND LAND-ROVERS REFER TO APPENDIX 5 OF EMPLOYERS GUIDE.';
        CAR_BENEFIT___The_higherf_benefits_is_to_be_brought_to_charge__CaptiLbl: Label 'CAR BENEFIT - The higher the amount of the monthly rate or the prescribed  rate of benefits is to be brought to charge:-';
        PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '"PRESCRIBED RATE : 1996 - 1% per month of the initial cost of the vehicle   "';
        V2001cc_3000ccCaptionLbl: Label '2001cc-3000cc';
        V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '"1997 - 1.5% per month of the initial cost of the vehicle   "';
        V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '"1998 et seq. - 2.0% per month of the initial cost of the vehicle   "';
        EmptyStringCaption_Control224Lbl: TextConst ENU = '=';
        KshsCaptionLbl: Label 'Kshs';
        IMPORTANT: Label 'IMPORTANT';
        "UseP9A(a)": Label '(a)  For all liable Employees and where director/ employees receives benefits in addition to cash emoluments.';
        "UseP9A(b)": TextConst ENU = '(b)  Where an Employee is eligible to deduction on owner occupier interest and the total interest payable in the year is K.shs. 300,000/= and above.';
        "2(a)": TextConst ENU = '2 (a) Deductible interest in respect of any month must be standard K.shs. 25,000.00/= except for December where the amount shall be K.shs. 25,000.00/=';
        "2(b)(i)": Label '(i) Photostat copy of preceding year''s certificate or confirmation of current Year''s borrowing. If applicable form financial institution.';
        "2(b)(ii)": Label '(ii) The DECLARATION duly signed by the Employees to form P9A';
        CompletionByEmployerLbl: Label 'To be completed by Employer at end of year';
        "1_Use_P9A": Label '"1. Use P9A "';
        b_Attach: Label '"(b) Attach "';
        TaxableAmount: Decimal;
        AmountRemaining: Decimal;
        IncomeTax: Decimal;
        TotBasic: Decimal;
        TotNonQuarter: Decimal;
        TotQuarter: Decimal;
        TotGross: Decimal;
        TotPercentage: Decimal;
        TotActual: Decimal;
        TotFixed: Decimal;
        TotTaxable: Decimal;
        TotTax: Decimal;
        TotRelief: Decimal;
        TotPAYE: Decimal;
        TaxablePound: Decimal;
        TotPound: Decimal;
        TotalBenefits: Decimal;
        EmployeeBenefits: Decimal;
        NoOfMonths: Integer;
        NoOfUnits: Integer;
        Numb: Decimal;
        DefinedContrMin: Decimal;
        HRSetup: Record "Human Resources Setup";
        ExcessRetirement: Decimal;
        HseLimit: Decimal;
        BenefitsVar: Decimal;
        QuartersVar: Decimal;
        OccupierVar: Decimal;
        RetirementVar: Decimal;
        PensionLimit: Decimal;
        Relief: Decimal;
        PAYE: Decimal;
        StringDate: Date;
        EndDate: Date;
        TotOcc: Decimal;
        TotRet: Decimal;
        Company: Record "Company Information";
        CoPin: Text[30];
        grandPAYE: Decimal;
        TaxCode: Code[10];
        retirecontribution: Decimal;
        CompRec: Record "Human Resources Setup";
        "30PerPension": Decimal;
        TLEarning: Record "Earnings Setup";
        PayrollEntries: Record "Payroll Entries";
        InsuranceRelief: Decimal;
        GroupCode: Code[20];
        CUser: Code[30];
        OwnerOccupierAmt: Decimal;
        grosspay: Decimal;
        noncashbenefit: Decimal;
        OwnerOccupier: Decimal;
        TLDeduction: Record "Deductions Setup";
        TaxableAmount2: Decimal;
        PAYE_Relief_InsuranceRelief: Decimal;
        TotalAllowances: Decimal;
        TotalPAYE: Decimal;
        TLRunningPayroll: Report "Processing Payroll";
        Years: Integer;
        MyDate: Date;
        PayrollSetups: Record "Payroll Setup";
        DefinedContrMin_OccupierVar: Decimal;
        PayrollProcessing: Codeunit "Payroll Processing";
        PayrollPeriods: Date;
        TLPayrollEntries: Record "Payroll Entries";
        BasicPay: Decimal;

    procedure GetBasicPay();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Basic Salary Code", TRUE);
        TLEarning.SETRANGE("Non-Cash Benefit", FALSE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        BasicPay := BasicPay + ROUND(TLPayrollEntries.Amount, PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END;
        BasicPay := BasicPay;
    end;

    procedure GetTotalAllowances();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE(TLEarning."Earning Type", TLEarning."Earning Type"::"Normal Earning");
        TLEarning.SETRANGE("Non-Cash Benefit", FALSE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalAllowances := TotalAllowances + ROUND(TLPayrollEntries.Amount, PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END;
        grosspay := TotalAllowances;
    end;

    procedure Get30PerPension();
    begin
        "30PerPension" := 0;
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type", TLEarning."Earning Type"::"Normal Earning");
        TLEarning.SETRANGE("Basic Salary Code", TRUE);
        TLEarning.SETRANGE("Non-Cash Benefit", FALSE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        "30PerPension" := ROUND(((30 / 100) * TLPayrollEntries.Amount), PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END;
        grosspay := TotalAllowances;
    end;

    procedure GetNonCashBenefits();
    begin
        noncashbenefit := 0;
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type", TLEarning."Earning Type"::"Normal Earning");
        TLEarning.SETRANGE(Taxable, TRUE);
        TLEarning.SETRANGE("Non-Cash Benefit", TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        noncashbenefit := noncashbenefit + ROUND(TLPayrollEntries.Amount, PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END;
        BenefitsVar := noncashbenefit;
    end;

    procedure GetOwnerOccupier();
    begin
        OwnerOccupier := 0;
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type", TLEarning."Earning Type"::"Owner Occupier");
        TLEarning.SETRANGE("Non-Cash Benefit", TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        OwnerOccupier := OwnerOccupier + ROUND(TLPayrollEntries.Amount, PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END ELSE BEGIN
            TLPayrollEntries.RESET;
            TLPayrollEntries.SETRANGE("Payroll Period", "Payroll Period"."Starting Date");
            TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Deduction);
            TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
            TLPayrollEntries.SETRANGE(Code, PayrollSetups."Owner Occupier");
            IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                    OwnerOccupier := OwnerOccupier + ROUND(ABS(TLPayrollEntries.Amount), PayrollSetups."Payroll Roundoff");
                UNTIL TLPayrollEntries.NEXT = 0;
            END;
        END;
        OccupierVar := OwnerOccupier;
        IF grosspay = 0 THEN BEGIN
            OccupierVar := 0;
        END;
    end;

    procedure GetTaxRelief();
    begin
        Relief := 0;
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type", TLEarning."Earning Type"::"Tax Relief");
        TLEarning.SETRANGE("Non-Cash Benefit", TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        Relief := Relief + ROUND(TLPayrollEntries.Amount, PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END;
        Relief := Relief;
    end;

    procedure GetInsuranceRelief();
    begin
        InsuranceRelief := 0;
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type", TLEarning."Earning Type"::"Insurance Relief");
        TLEarning.SETRANGE("Non-Cash Benefit", TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        InsuranceRelief := InsuranceRelief + ROUND(TLPayrollEntries.Amount, PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLEarning.NEXT = 0;
        END;
        InsuranceRelief := InsuranceRelief;
    end;

    procedure GetRetirementBenefit();
    begin
        RetirementVar := 0;
        TLDeduction.RESET;
        TLDeduction.SETRANGE("Pension Scheme", TRUE);
        IF TLDeduction.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLDeduction.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        RetirementVar := RetirementVar + ROUND(ABS(TLPayrollEntries.Amount), PayrollSetups."Payroll Roundoff");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLDeduction.NEXT = 0
        END;
        RetirementVar := RetirementVar;
    end;

    procedure GetTotalPAYE();
    begin
        TotalPAYE := 0;
        TaxableAmount2 := 0;
        TLDeduction.RESET;
        TLDeduction.SETRANGE("PAYE Code", TRUE);
        IF TLDeduction.FINDFIRST THEN BEGIN
            REPEAT
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriods);
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, TLDeduction.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalPAYE := TotalPAYE + ABS(TLPayrollEntries.Amount);
                        TaxableAmount2 := TaxableAmount2 + PayrollProcessing.GetTaxableAmount(Employee, "Payroll Period"."Starting Date");
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            UNTIL TLDeduction.NEXT = 0;
        END;
        TotalPAYE := TotalPAYE;
        PAYE_Relief_InsuranceRelief := TotalPAYE + InsuranceRelief + Relief;
        TaxableAmount2 := TaxableAmount2;
    end;

    procedure GetPensonLimit();
    begin
        PensionLimit := 0;
        PayrollSetups.RESET;
        PayrollSetups.Get(1);
        PensionLimit := PayrollSetups."Pension Cap";
        IF (PensionLimit < RetirementVar) AND (PensionLimit < "30PerPension") THEN BEGIN
            DefinedContrMin := PensionLimit;
        END;
        IF (RetirementVar < PensionLimit) AND (RetirementVar < "30PerPension") THEN BEGIN
            DefinedContrMin := RetirementVar;
        END;
        IF ("30PerPension" < RetirementVar) AND ("30PerPension" < PensionLimit) THEN BEGIN
            DefinedContrMin := "30PerPension";
        END;
        IF grosspay = 0 THEN BEGIN
            TotBasic := 0;
            TotNonQuarter := 0;
            TotQuarter := 0;
            TotGross := 0;
            TotPercentage := 0;
            TotActual := 0;
            TotFixed := 0;
            TotTaxable := 0;
            TotTax := 0;
            TotRelief := 0;
            TotPAYE := 0;
            NoOfMonths := 0;
            TotalBenefits := 0;
            PensionLimit := 0;
            TotOcc := 0;
            TotRet := 0;
            TotPound := 0;
            grandPAYE := 0;
            TotalPAYE := 0;
            PAYE_Relief_InsuranceRelief := 0;
            TotalAllowances := 0;
            OccupierVar := 0;
            DefinedContrMin := 0;
        END;
        DefinedContrMin_OccupierVar := 0;
        DefinedContrMin_OccupierVar := ABS(DefinedContrMin) + ABS(OccupierVar);
    end;
}

