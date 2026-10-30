report 50252 "Report Per Employee"
{

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\ReportPerEmployee.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; Employee)
        {
            RequestFilterFields = "No.";

            column(No_Employee; "No.")
            { }
            column(FirstName_Employee; "First Name")
            { }
            column(MiddleName_Employee; "Middle Name")
            { }
            column(LastName_Employee; "Last Name")
            { }
            column(CountryRegionCode_Employee; "Country/Region Code")
            { }
            column(FullName; FullName)
            { }
            column(Disability_Employee; Disability)
            { }
            column(DisabilityDescription_Employee; Disability)
            { }
            column(Age_Employee; Age)
            { }
            column(Religion; Religion)
            { }
            column(Tribe; Tribe)
            { }
            column(Resident_Estate_; "Resident(Estate)")
            { }
            column(Street_Address_Court; "Street Address/Court")
            { }
            column(House_No_; "House No.")
            { }
            column(City; City)
            { }
            column(MaritalStatus_Employee; "Marital Status")
            { }
            column(EmploymentDate; "Employment Date")
            { }
            column(Status_Employee; Status)
            { }
            column(JobTitle_Employee; "Job Title")
            { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Probation_Period; "Probation Period")
            { }
            column(Probation_End_Date; "Probation End Date")
            { }
            column(Grade; Grade)
            { }
            column(Bank_Branch_No_; "Bank Branch No.")
            { }
            column(Bank_Account_No_; "Bank Account No.")
            { }
            column(Basic_Pay; "Basic Pay")
            { }
            column(E_Mail; "E-Mail")
            { }
            column(Extension_Employee; Extension)
            { }
            column(CompanyEMail_Employee; "Company E-Mail")
            { }
            column(BloodType_Employee; "Blood Type")
            { }
            column(MobilePhoneNo_Employee; "Mobile Phone No.")
            { }
            column(BirthDate_Employee; "Birth Date")
            { }
            column(National_ID; "National ID")
            { }
            column(PINNumber_Employee; "PIN Number")
            { }
            column(NSSFNo_Employee; NSSF)
            { }
            column(NHIFNo_Employee; NHIF)
            { }
            column(HELBNo_Employee; "HELB No.")
            { }
            column(CountyCode_Employee; "County Code")
            { }
            column(Address2_Employee; "Address 2")
            { }
            column(PostCode_Employee; "Post Code")
            { }
            column(PhoneNo_Employee; "Phone No.")
            { }
            column(Gender_Employee; Gender)
            { }
            column(EMail_Employee; "E-Mail")
            { }
            column(Picture_Employee; Image)
            { }
            column(Image_Employee; Image)
            { }
            column(CompanyInformation_Name; CompanyInformation.Name)
            { }
            column(CompanyInformation_Address; CompanyInformation.Address)
            { }
            column(CompanyInformation_City; CompanyInformation.City)
            { }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            { }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            { }

            trigger OnAfterGetRecord();
            begin
                VALIDATE(Image);
            end;
        }
    }


    trigger OnInitReport();
    begin
         CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
         CompanyInformation.CALCFIELDS(Picture);

    end;

    var
        UserSetup: Record 91;
        CompanyInformation: Record 79;
        empno: Text;


}

