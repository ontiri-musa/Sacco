report 51115 "CRB Report org"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\BOSA\CRB Report New.rdl';
    Caption = 'CRB RETURN';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true), "Approved Amount" = FILTER(> 0), "Outstanding Balance" = FILTER(> 0));
            column(Surname; Surname)
            {
            }
            column(Forename_1; Forename_1)
            {
            }
            column(Forename_2; Forename_2)
            {
            }
            column(Forename_3; Forename_3)
            {
            }
            column(Salutation; Salutation)
            {
            }
            column(DateOfBirth; DateOfBirth)
            {
            }
            column(ClientNumber; ClientNumber)
            {
            }
            column(AccountNumber; AccountNumber)
            {
            }
            column(Gender; Gender)
            {
            }
            column(Nationality; Nationality)
            {
            }
            column(MaritalStatus; MaritalStatus)
            {
            }
            column(PrimaryIdentificationDocumentType; PrimaryIdentificationDocumentType)
            {
            }
            column(PrimaryIdentification; PrimaryIdentification)
            {
            }
            column(SecondaryIdentificationDocumentType; SecondaryIdentificationDocumentType)
            {
            }
            column(SecondaryIdentification; SecondaryIdentification)
            {
            }
            column(OtherIdentification; OtherIdentification)
            {
            }
            column(OtherIdentificationNo; OtherIdentificationNo)
            {
            }
            column(MobileTelephone; MobileTelephone)
            {
            }
            column(HomeTelephone; HomeTelephone)
            {
            }
            column(WorktelephoneNo; WorktelephoneNo)
            {
            }
            column(PostalAddress1; PostalAddress1)
            {
            }
            column(PostalAddress2; PostalAddress2)
            {
            }
            column(PostalLocationTown; PostalLocationTown)
            {
            }
            column(PostalLocationCountry; PostalLocationCountry)
            {
            }
            column(PostCode; PostCode)
            {
            }
            column(PhysicalAddress1; PhysicalAddress1)
            {
            }
            column(Physical_Address_2; Physical_Address_2)
            {
            }
            column(Plot_Number; Plot_Number)
            {
            }
            column(Location_Town; Location_Town)
            {
            }
            column(Location_Country; Location_Country)
            {
            }
            column(Date_at_Physical_Address; "Date_at_Physical Address")
            {
            }
            column(PIN_Number; PIN_Number)
            {
            }
            column(Consumer_work_E_Mail; "Consumer_work_E-Mail")
            {
            }
            column(Employer_Name; Employer_Name)
            {
            }
            column(Employer_Industry_Type; Employer_Industry_Type)
            {
            }
            column(Employment_Date; Employment_Date)
            {
            }
            column(Employment_type; Employment_type)
            {
            }
            column(Salary_Band; Salary_Band)
            {
            }
            column(Lenders_Registered; Lenders_Registered)
            {
            }
            column(Lenders_Trading_Name; Lenders_Trading_Name)
            {
            }
            column(Lenders_Branch_Name; Lenders_Branch_Name)
            {
            }
            column(Lenders_Branch_Code; Lenders_Branch_Code)
            {
            }
            column(Account_Joint_or_Single; "Account_Joint_or_ Single")
            {
            }
            column(Account_Product_Type; Account_Product_Type)
            {
            }
            column(Date_Account_Opened; Date_Account_Opened)
            {
            }
            column(Instalment_Due_Date; Instalment_Due_Date)
            {
            }
            column(Original_Amount; Original_Amount)
            {
            }
            column(Currency_of_Facility; Currency_of_Facility)
            {
            }
            column(Amount_in_Kenya_shillings; Amount_in_Kenya_shillings)
            {
            }
            column(Current_Balance; Current_Balance)
            {
            }
            column(Overdue_Balance; Overdue_Balance)
            {
            }
            column(Overdue_Date; Overdue_Date)
            {
            }
            column(Nr_of_Days_In_Arrears; Nr_of_Days_In_Arrears)
            {
            }
            column(Nr_of_Instalments_In_Arrears; Nr_of_Instalments_In_Arrears)
            {
            }
            column(Performing_NPL_Indicator; Performing_NPL_Indicator)
            {
            }
            column(Account_Status; Account_Status)
            {
            }
            column(Account_Status_Date; Account_Status_Date)
            {
            }
            column(Account_Closure_Reason; Account_Closure_Reason)
            {
            }
            column(Repayment_Period; Repayment_Period)
            {
            }
            column(Deferred_Payment_Date; Deferred_Payment_Date)
            {
            }
            column(Deferred_Payment; Deferred_Payment)
            {
            }
            column(Payment_Frequency; Payment_Frequency)
            {
            }
            column(Disbursement_Date; Disbursement_Date)
            {
            }
            column(Instalment_Amount; Instalment_Amount)
            {
            }
            column(Date_of_Latest_Payment; Date_of_Latest_Payment)
            {
            }
            column(Last_Payment_Amount; Last_Payment_Amount_CRB)
            {
            }
            column(Type_of_Security; Type_of_Security)
            {
            }
            column(OldAccountNumber; OldAccountNumber)
            {
            }
            column(PrudentialRiskClassification; PrudentialRiskClassification)
            {
            }
            column(SystemAccountStatus; SystemAccountStatus)
            {
            }
            column(CurrentLoanClassification; CurrentLoanClassification)
            {
            }

            trigger OnAfterGetRecord();
            var
                MemberName: array[10] of Text;
                ClassificationDate: Date;
            begin

                /*                 if not Customer.GET("Loan Application"."No.") then begin
                                    CurrReport.SKIP;
                                end;
                                if "Loan Application"."Approved Amount" < 0 then begin
                                    CurrReport.SKIP;
                                end; */

                if Customer.GET("Loan Application"."No.") then begin
                    /*                     if Customer."Customer Type" <> Customer."Customer Type"::Loan then begin
                                            CurrReport.SKIP;
                                        end; */
                    SystemAccountStatus := FORMAT(Customer.Status);

                    LoanClassifications.RESET;
                    LoanClassifications.SETCURRENTKEY("Classification Date");
                    LoanClassifications.SETASCENDING("Classification Date", false);
                    if LoanClassifications.FINDFIRST then begin
                        CurrentLoanClassification := FORMAT(LoanClassifications."Classification Code");
                    end;
                end;
                //==========================================================================================
                if Member.GET("Loan Application"."Member No.") then begin
                    Allname := '';
                    Allname := "Loan Application"."Member Name";
                    OldAccountNumber := '';
                    MemberName[1] := Member."Full Name";
                    MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));//firstname
                    MemberName[3] := DELSTR(MemberName[1], 1, STRLEN(MemberName[2]));
                    MemberName[4] := COPYSTR(MemberName[3], 1, STRPOS(MemberName[3], ' ')); //middle
                    MemberName[5] := DELSTR(MemberName[3], 1, STRLEN(MemberName[4]));

                    Surname := '';
                    Surname := Surname;
                    Forename_1 := '';
                    Forename_1 := MemberName[2];
                    Forename_2 := '';
                    Forename_2 := MemberName[4];
                    Surname := '';
                    Surname := MemberName[5];

                    if Surname = '' then begin
                        Surname := Forename_2
                    end;
                    Forename_3 := '';
                    Salutation := '';
                    if Member.Gender = Member.Gender::Male then begin
                        Salutation := 'Mr.';
                        Gender := 'M';
                    end;
                    if Member.Gender = Member.Gender::Female then begin
                        Salutation := 'Mrs.';
                        Gender := 'F';
                    end;

                    if Member.Category = Member.Category::Group then begin
                        Salutation := '';
                        Gender := '';
                    end;
                    DateOfBirth := '';
                    if Member."Date of Birth" <> 0D then begin
                        if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 1))) > 1 then begin
                                DateOfBirth := FORMAT(DATE2DMY(Member."Date of Birth", 3)) +
                                             FORMAT(DATE2DMY(Member."Date of Birth", 2)) +
                                             FORMAT(DATE2DMY(Member."Date of Birth", 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 1))) > 1 then begin
                                DateOfBirth := FORMAT(DATE2DMY(Member."Date of Birth", 3)) +
                                             '0' + FORMAT(DATE2DMY(Member."Date of Birth", 2)) +
                                             FORMAT(DATE2DMY(Member."Date of Birth", 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 1))) < 2 then begin
                                DateOfBirth := FORMAT(DATE2DMY(Member."Date of Birth", 3)) +
                                             '0' + FORMAT(DATE2DMY(Member."Date of Birth", 2)) +
                                             '0' + FORMAT(DATE2DMY(Member."Date of Birth", 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(Member."Date of Birth", 1))) < 2 then begin
                                DateOfBirth := FORMAT(DATE2DMY(Member."Date of Birth", 3)) +
                                             FORMAT(DATE2DMY(Member."Date of Birth", 2)) +
                                             '0' + FORMAT(DATE2DMY(Member."Date of Birth", 1));
                            end;
                        end;
                    end;


                    ClientNumber := '';
                    ClientNumber := Member."No.";
                    AccountNumber := '';
                    AccountNumber := "Loan Application"."No.";
                    Nationality := '';
                    Nationality := 'KE';
                    MaritalStatus := '';
                    MaritalStatus := '';
                    if Member."National ID" <> '' then
                        PrimaryIdentificationDocumentType := '001';
                    PrimaryIdentification := Member."National ID";
                    SecondaryIdentificationDocumentType := '';//'002';
                    SecondaryIdentification := '';
                    OtherIdentification := '';
                    OtherIdentificationNo := '';
                    MobileTelephone := '';
                    MobileTelephone := Member."Phone No.";
                    HomeTelephone := '';
                    WorktelephoneNo := '';
                    PostalAddress1 := '';
                    PostalAddress1 := Member."Postal Address";
                    PostalAddress2 := '';
                    PostalAddress2 := Member."Postal Address";
                    PostCode := '';
                    PhysicalAddress1 := '';
                    Physical_Address_2 := '';
                    Plot_Number := '';
                    Location_Town := "Loan Application"."Church District Code";
                    Location_Country := 'KE';
                    "Date_at_Physical Address" := '';
                    PIN_Number := Member."PIN No.";
                    "Consumer_work_E-Mail" := Member."E-mail";
                    Lenders_Trading_Name := CompanyInfo.Name;
                    Lenders_Branch_Name := 'NAIROBI';
                    Lenders_Branch_Code := 'S001';
                    Lenders_Registered := CompanyInfo.Name;



                    if Member.Category = Member.Category::Individual then begin
                        "Account_Joint_or_ Single" := 'S';
                    end;
                    if Member.Category <> Member.Category::Individual then begin
                        "Account_Joint_or_ Single" := 'J';
                    end;

                    LoanProductTypes.RESET;
                    LoanProductTypes.SETRANGE(Code, "Loan Application"."Loan Product Type");
                    LoanProductTypes.FINDSET;
                    Account_Product_Type := 'H';
                    if LoanProductTypes."E-Loan" then begin
                        Account_Product_Type := 'I';
                    end;


                    Date_Account_Opened := '';
                    Date_Account_Opened := FORMAT("Loan Application"."Disbursal Date");

                    if "Loan Application"."Disbursal Date" <> 0D then begin
                        Date_Account_Opened := '';
                        if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) > 1 then begin
                                Date_Account_Opened := FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 3)) +
                                             '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                             FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) < 2 then begin
                                Date_Account_Opened := FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 3)) +
                                             '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                             '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) < 2 then begin
                                Date_Account_Opened := FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 3)) +
                                             FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                             '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                            end;
                        end;
                        /* if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) > 1 then begin
                             if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) > 1 then begin
                                 Date_Account_Opened := FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 3)) +
                                                       FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                                       FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                             end;
                         end;
                         if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) < 2 then begin
                             if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) > 1 then begin
                                 Date_Account_Opened := FORMAT("Loan Application"."Disbursal Date", 3) +
                                                     '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                                     FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                             end;
                         end;
                         if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) < 2 then begin
                             if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) < 2 then begin
                                 Date_Account_Opened := FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 3)) +
                                               '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                               '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                             end;
                         end;
                         if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2))) > 1 then begin
                             if STRLEN(FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1))) < 2 then begin
                                 Date_Account_Opened := FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 3)) +
                                               FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 2)) +
                                               '0' + FORMAT(DATE2DMY("Loan Application"."Disbursal Date", 1));
                             end;
                         end;*/
                    end;
                    /*                     if STRPOS(Date_Account_Opened, '/') > 1 then begin
                                            CurrReport.SKIP;
                                        end; */
                    MemberLoanRepaymentSchedule.RESET;
                    MemberLoanRepaymentSchedule.SETRANGE("Loan No.", "Loan Application"."No.");
                    MemberLoanRepaymentSchedule.SETFILTER("Repayment Date", '<=%1', TODAY);
                    if MemberLoanRepaymentSchedule.FINDFIRST then begin
                        Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                             FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                             FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));



                        if Instalment_Due_Date <> '' then begin
                            if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) < 2 then begin
                                if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) > 1 then begin
                                    Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                                 '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                 FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));
                                end;
                            end;
                            if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) < 2 then begin
                                if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) < 2 then begin
                                    Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                                 '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                 '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));
                                end;
                            end;
                            if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) > 1 then begin
                                if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) < 2 then begin
                                    Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                                 FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                 '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));
                                end;
                            end;

                        end;

                        /* if Instalment_Due_Date <> '' then begin
                             if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) > 1 then begin
                                 if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) > 1 then begin
                                     Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                                  FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                  FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));

                                 end;
                             end;
                             if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) < 2 then begin
                                 if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) > 1 then begin
                                     Instalment_Due_Date := FORMAT(MemberLoanRepaymentSchedule."Repayment Date", 3) +
                                                  '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                  FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));
                                 end;
                             end;
                             if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) < 2 then begin
                                 if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) < 2 then begin
                                     Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                                  '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                  '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));
                                 end;
                             end;
                             if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2))) > 1 then begin
                                 if STRLEN(FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1))) < 2 then begin
                                     Instalment_Due_Date := FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 3)) +
                                                  FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 2)) +
                                                  '0' + FORMAT(DATE2DMY(MemberLoanRepaymentSchedule."Repayment Date", 1));

                                 end;
                             end;
                         end;*/
                    end;

                    //  Original_Amount := FORMAT(ROUND("Loan Application"."Approved Amount", 1));//,0,'<Precision,2:2><Standard Format,0>');
                    Original_Amount := FORMAT("Loan Application"."Approved Amount");
                    Original_Amount := DELCHR(Original_Amount, '=', '.');
                    Original_Amount := DELCHR(Original_Amount, '=', ',');
                    Currency_of_Facility := 'KES';
                    // Amount_in_Kenya_shillings := FORMAT(ROUND("Loan Application"."Approved Amount", 1));//,0,'<Precision,2:2><Standard Format,0>');
                    Amount_in_Kenya_shillings := FORMAT("Loan Application"."Approved Amount");
                    Amount_in_Kenya_shillings := DELCHR(Amount_in_Kenya_shillings, '=', '.');
                    Amount_in_Kenya_shillings := DELCHR(Amount_in_Kenya_shillings, '=', ',');
                    Customer.RESET;
                    Customer.GET("Loan Application"."No.");
                    Customer.CALCFIELDS(Balance);
                    ///Current_Balance := FORMAT(ROUND(Customer.Balance, 1));
                    Current_Balance := FORMAT(Customer.Balance);
                    Current_Balance := DELCHR(Current_Balance, '=', '.');
                    Current_Balance := DELCHR(Current_Balance, '=', ',');

                    BDA := 0;
                    Instalment_Amount := '';
                    RealDate := 0D;
                    LoanClassifications.Reset();
                    LoanClassifications.SetRange("Loan No.", "Loan Application"."No.");
                    if LoanClassifications.FindFirst() then begin
                        ClassificationDate := LoanClassifications."Classification Date";

                        //  Overdue_Balance := FORMAT(ROUND(LoanClassifications."Total Arrears", 1));
                        Overdue_Balance := FORMAT(LoanClassifications."Total Arrears");
                        Overdue_Balance := DELCHR(Overdue_Balance, '=', '.');
                        Overdue_Balance := DELCHR(Overdue_Balance, '=', ',');
                        Nr_of_Days_In_Arrears := Format(LoanClassifications."No. of Days in Arrears");
                        Nr_of_Days_In_Arrears := DELCHR(Nr_of_Days_In_Arrears, '=', '.');
                        Nr_of_Days_In_Arrears := DELCHR(Nr_of_Days_In_Arrears, '=', ',');
                        Nr_of_Instalments_In_Arrears := Format(LoanClassifications."No. of Defaulted Installment");
                        Nr_of_Instalments_In_Arrears := DELCHR(Nr_of_Instalments_In_Arrears, '=', '.');
                        Nr_of_Instalments_In_Arrears := DELCHR(Nr_of_Instalments_In_Arrears, '=', ',');

                        if LoanClassifications."Total Arrears" > 0 then begin
                            Performing_NPL_Indicator := 'B';
                        end;
                        if LoanClassifications."Total Arrears" <= 0 then begin
                            Performing_NPL_Indicator := 'A';
                        end;
                        /*
                        A = Normal (0-30)
                        B = Watch (>30-90)
                        C = Substandard(>90-180)
                        D = Doubtful(>180-360)
                        E = Loss(>360)
                        */
                        PrudentialRiskClassification := '';
                        if (LoanClassifications."No. of Days in Arrears" = 0) and (LoanClassifications."No. of Days in Arrears" <= 30) then
                            PrudentialRiskClassification := 'A';
                        if (LoanClassifications."No. of Days in Arrears" > 30) and (LoanClassifications."No. of Days in Arrears" <= 90) then
                            PrudentialRiskClassification := 'B';
                        if (LoanClassifications."No. of Days in Arrears" > 90) and (LoanClassifications."No. of Days in Arrears" <= 180) then
                            PrudentialRiskClassification := 'C';
                        if (LoanClassifications."No. of Days in Arrears" > 180) and (LoanClassifications."No. of Days in Arrears" <= 360) then
                            PrudentialRiskClassification := 'D';
                        if (LoanClassifications."No. of Days in Arrears" > 360) then
                            PrudentialRiskClassification := 'E';

                        Instalment_Amount := Format(Round(LoanClassifications."Total Installment", 1, '='));
                        Instalment_Amount := DELCHR(Instalment_Amount, '=', '.');
                        Instalment_Amount := DELCHR(Instalment_Amount, '=', ',');
                        Account_Status_Date := FORMAT(LoanClassifications."Classification Date");

                        if LoanClassifications."Classification Date" <> 0D then begin
                            if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2))) > 1 then begin
                                if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1))) > 1 then begin
                                    Account_Status_Date := FORMAT(DATE2DMY(LoanClassifications."Classification Date", 3)) +
                                                 FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2)) +
                                                 FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1));
                                end;
                            end;
                            if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2))) < 2 then begin
                                if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1))) > 1 then begin
                                    Account_Status_Date := FORMAT(DATE2DMY(LoanClassifications."Classification Date", 3)) +
                                                 '0' + FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2)) +
                                                 FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1));
                                end;
                            end;
                            if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2))) < 2 then begin
                                if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1))) < 2 then begin
                                    Account_Status_Date := FORMAT(DATE2DMY(LoanClassifications."Classification Date", 3)) +
                                                 '0' + FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2)) +
                                                 '0' + FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1));
                                end;
                            end;
                            if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2))) > 1 then begin
                                if STRLEN(FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1))) < 2 then begin
                                    Account_Status_Date := FORMAT(DATE2DMY(LoanClassifications."Classification Date", 3)) +
                                                 FORMAT(DATE2DMY(LoanClassifications."Classification Date", 2)) +
                                                 '0' + FORMAT(DATE2DMY(LoanClassifications."Classification Date", 1));
                                end;
                            end;
                        end;
                    end;

                    RealDate := 0D;
                    //Message('Class Date %1', ClassificationDate);
                    MemberLoanRepaymentSchedule.RESET;
                    MemberLoanRepaymentSchedule.SETRANGE("Loan No.", "Loan Application"."No.");
                    MemberLoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', ClassificationDate);
                    if MemberLoanRepaymentSchedule.FINDLAST then begin
                        BDA := MemberLoanRepaymentSchedule."Total Installment";
                        RealDate := MemberLoanRepaymentSchedule."Repayment Date";
                    end;

                    if RealDate <> 0D then begin
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                Overdue_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                              FORMAT(DATE2DMY(RealDate, 2)) +
                                              FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                Overdue_Date := FORMAT(RealDate, 3) +
                                              '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                              FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                Overdue_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                              '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                              '0' + FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                Overdue_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                              FORMAT(DATE2DMY(RealDate, 2)) +
                                              '0' + FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;

                    end;

                    Customer.GET("Loan Application"."No.");
                    Customer.CalcFields(Balance);
                    if Customer.Balance > 0 then begin
                        Account_Status := 'F';
                    end;
                    if Customer.Balance < 0 then begin
                        Account_Status := 'I';
                    end;

                    Account_Closure_Reason := '';
                    Repayment_Period := FORMAT("Loan Application"."Repayment Period");

                    Deferred_Payment_Date := '';
                    Deferred_Payment := '';
                    Payment_Frequency := 'M';
                    Disbursement_Date := '';
                    RealDate := 0D;

                    if "Loan Application"."Disbursal Date" <> 0D then begin
                        Disbursement_Date := FORMAT("Loan Application"."Disbursal Date");
                        RealDate := "Loan Application"."Disbursal Date";
                    end;
                    if "Loan Application"."Disbursal Date" = 0D then begin
                        Disbursement_Date := FORMAT("Loan Application"."Disbursal Date");
                        RealDate := "Loan Application"."Disbursal Date";
                    end;

                    if RealDate <> 0D then begin
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                Disbursement_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                             FORMAT(DATE2DMY(RealDate, 2)) +
                                             FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                Disbursement_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                             FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                Disbursement_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                Disbursement_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                             FORMAT(DATE2DMY(RealDate, 2)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                    end;

                    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    if noofmonthsinarears >= 0 then begin
                        if noofmonthsinarears > 999 then begin
                            noofmonthsinarears := 999;
                        end;
                        RealDate := CALCDATE('-' + FORMAT(noofmonthsinarears) + 'M', TODAY);
                        //Nr_of_Days_In_Arrears := FORMAT(ROUND((TODAY - RealDate), 1, '>'));
                        //if Nr_of_Days_In_Arrears = '0' then begin
                        //Nr_of_Days_In_Arrears := '000';
                        //end;
                        if STRLEN(Nr_of_Days_In_Arrears) = 1 then begin
                            Nr_of_Days_In_Arrears := '00' + Nr_of_Days_In_Arrears;
                        end;
                        if STRLEN(Nr_of_Days_In_Arrears) = 2 then begin
                            Nr_of_Days_In_Arrears := '0' + Nr_of_Days_In_Arrears;
                        end;
                        if RealDate <> 0D then begin
                            /* if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                                 if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                     Overdue_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                                   FORMAT(DATE2DMY(RealDate, 2)) +
                                                   FORMAT(DATE2DMY(RealDate, 1));
                                 end;
                             end;
                             if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                                 if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                     Overdue_Date := FORMAT(RealDate, 3) +
                                                   '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                                   FORMAT(DATE2DMY(RealDate, 1));
                                 end;
                             end;
                             if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                                 if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                     Overdue_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                                   '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                                   '0' + FORMAT(DATE2DMY(RealDate, 1));
                                 end;
                             end;
                             if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                                 if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                     Overdue_Date := FORMAT(DATE2DMY(RealDate, 3)) +
                                                   FORMAT(DATE2DMY(RealDate, 2)) +
                                                   '0' + FORMAT(DATE2DMY(RealDate, 1));
                                 end;
                             end;*/
                        end;
                    end;

                    Date_of_Latest_Payment := '';
                    Last_Payment_Amount := '0';
                    RealDate := 0D;
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Customer No.", "Loan Application"."No.");
                    CustLedgerEntry.SETFILTER(Amount, '<>%1', "Loan Application"."Approved Amount");
                    CustLedgerEntry.SETFILTER("Transaction Type Code", '%1|%2', 'PPAID', 'INTPAID');
                    if CustLedgerEntry.FINDLAST then begin
                        // REPEAT
                        CustLedgerEntry.CALCFIELDS(Amount);
                        //Last_Payment_Amount+=CustLedgerEntry.Amount;
                        Date_of_Latest_Payment := FORMAT(CustLedgerEntry."Posting Date");
                        //Last_Payment_Amount := FORMAT(CustLedgerEntry.Amount, 0, '<Precision,2:2><Standard Format,0>');
                        RealDate := CustLedgerEntry."Posting Date";
                        DCustL.Reset();
                        DCustL.SetRange("Customer No.", "Loan Application"."No.");
                        DCustL.SetRange("Posting Date", RealDate);
                        DCustL.SETFILTER("Transaction Type Code", '%1|%2|%3', 'PPAID', 'INTPAID', 'PENPAID');
                        If DCustL.FindSet() then begin
                            DCustL.CalcSums("Credit Amount");
                            Last_Payment_Amount := FORMAT(DCustL."Credit Amount");
                            Last_Payment_Amount_CRB := Last_Payment_Amount.Replace('.', '');
                            Last_Payment_Amount_CRB := Last_Payment_Amount_CRB.Replace(',', '');
                        end;
                        // NewTextValue := TextValue.Replace('.', '');
                        //Last_Payment_Amount := DELCHR(Last_Payment_Amount, '=', '.');
                        //Last_Payment_Amount := DELCHR(Last_Payment_Amount, '=', ',');
                        //  UNTIL CustLedgerEntry.NEXT=0;
                    end;

                    // Date_of_Latest_Payment := '';

                    if RealDate <> 0D then begin
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                Date_of_Latest_Payment := FORMAT(DATE2DMY(RealDate, 3)) +
                                             FORMAT(DATE2DMY(RealDate, 2)) +
                                             FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) > 1 then begin
                                Date_of_Latest_Payment := FORMAT(DATE2DMY(RealDate, 3)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                             FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) < 2 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                Date_of_Latest_Payment := FORMAT(DATE2DMY(RealDate, 3)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 2)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                        if STRLEN(FORMAT(DATE2DMY(RealDate, 2))) > 1 then begin
                            if STRLEN(FORMAT(DATE2DMY(RealDate, 1))) < 2 then begin
                                Date_of_Latest_Payment := FORMAT(DATE2DMY(RealDate, 3)) +
                                             FORMAT(DATE2DMY(RealDate, 2)) +
                                             '0' + FORMAT(DATE2DMY(RealDate, 1));
                            end;
                        end;
                    end;
                    Account_Status_Date := Date_of_Latest_Payment;

                end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
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
        Surname: Text;
        Forename_1: Text;
        Forename_2: Text;
        Forename_3: Text;
        Salutation: Text;
        DateOfBirth: Text;
        ClientNumber: Text;
        AccountNumber: Text;
        Gender: Text;
        Nationality: Text;
        MaritalStatus: Text;
        PrimaryIdentificationDocumentType: Text;
        PrimaryIdentification: Text;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        SecondaryIdentificationDocumentType: Text;
        SecondaryIdentification: Text;
        OtherIdentification: Text;
        OtherIdentificationNo: Text;
        MobileTelephone: Text;
        HomeTelephone: Text;
        WorktelephoneNo: Text;
        PostalAddress1: Text;
        PostalAddress2: Text;
        PostalLocationTown: Text;
        PostalLocationCountry: Text;
        PostCode: Text;
        PhysicalAddress1: Text;
        Member: Record Member;
        Customer: Record Customer;
        Physical_Address_2: Text;
        Plot_Number: Text;
        Location_Town: Text;
        Location_Country: Text;
        "Date_at_Physical Address": Text;
        PIN_Number: Text;
        "Consumer_work_E-Mail": Text;
        Employer_Name: Text;
        Employer_Industry_Type: Text;
        Employment_Date: Text;
        Employment_type: Text;
        Salary_Band: Text;
        Lenders_Registered: Text;
        Lenders_Trading_Name: Text;
        Lenders_Branch_Name: Text;
        Lenders_Branch_Code: Text;
        "Account_Joint_or_ Single": Text;
        Account_Product_Type: Text;
        Date_Account_Opened: Text;
        Instalment_Due_Date: Text;
        Original_Amount: Text;
        Currency_of_Facility: Text;
        Amount_in_Kenya_shillings: Text;
        Current_Balance: Text;
        Overdue_Balance: Text;
        Overdue_Date: Text;
        Nr_of_Days_In_Arrears: Text;
        Nr_of_Instalments_In_Arrears: Text;
        Performing_NPL_Indicator: Text;
        Account_Status: Text;
        Account_Status_Date: Text;
        Account_Closure_Reason: Text;
        Repayment_Period: Text;
        Deferred_Payment_Date: Text;
        Deferred_Payment: Text;
        Payment_Frequency: Text;
        Disbursement_Date: Text;
        Instalment_Amount: Text;
        Date_of_Latest_Payment: Text;
        Last_Payment_Amount: Text;
        Type_of_Security: Text;
        CompanyInformation: Record "Company Information";
        DimensionValue: Record "Dimension Value";
        LoanProductTypes: Record "Loan Product Type";
        LoanRepaymentHeader: Record "Select Eval. Questions Entries";
        MemberLoanRepaymentSchedule: Record "Loan Repayment Schedule";
        Vendor: Record Vendor;
        BDA: Decimal;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Allname: Text;
        RealDate: Date;
        SN: Integer;
        noofmonthsinarears: Integer;
        PrudentialRiskClassification: Text;
        SystemAccountStatus: Text;
        CurrentLoanClassification: Text;
        LoanClassifications: Record "Loan Classification Entry";
        OldAccountNumber: Text;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CompanyInfo: Record "Company Information";
        Last_Payment_Amount_CRB: Text;
        dotNetDateTime: Codeunit DotNet_DateTime;
        Instalment_Due_Date_CRB: Date;
}

