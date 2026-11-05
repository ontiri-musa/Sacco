report 50280 "Separation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\SeparationReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; Separation)
        {
            column(Employee_No_; "Employee No.")
            {
            }
            column(Employee_Name; "Employee Name")
            {
            }
            column(Job_Title; "Job Title")
            {
            }
            column(Employment_Date; "Employment Date")
            {
            }
            column(Separation_Type; "Separation Type")
            {
            }
            column(Notification_Start_Date; "Notification Start Date")
            {
            }
            column(Notice_Period; "Notice Period")
            {
            }
            column(Notification_End_Date; "Notification End Date")
            {
            }
            column(Last_Working_Date; "Last Working Date")
            {
            }
            column(Leave_Accrual_End_Date; "Leave Accrual End Date")
            {
            }
            column(Days_In_Lieu_of_Notice; "Days In Lieu of Notice")
            {
            }
            column(Leave_Days_Earned_to_Date; "Leave Days Earned to Date")
            {
            }
            column(Leave_Days_in_Notice; "Leave Days in Notice")
            {
            }
            column(Leave_Start_Date; "Leave Start Date")
            {
            }
            column(Leave_End_Date; "Leave End Date")
            {
            }
            column(Outstanding_Leave_Days; "Outstanding Leave Days")
            {
            }
            column(Pay_for_Outstanding_Leave_Days; "Pay for Outstanding Leave Days")
            {
            }
            column(Basic_Salary; "Basic Salary")
            {
            }
            column(No__Of_Months_Salary; "No. Of Months Salary")
            {
            }
            column(Salary_For_Full_Month; "Salary For Full Month")
            {
            }
            column(Salary_For_Extra_Days; "Salary For Extra Days")
            {
            }
            column(Part_Salary_to_be_paid; "Part Salary to be paid")
            {
            }
            column(Golden_Handshake; "Golden Handshake")
            {
            }
            column(Transport_Allowance; "Transport Allowance")
            {
            }
            column(No_of_Years_Worked; "No of Years Worked")
            {
            }
            column(Severence_Pay; "Severence Pay")
            {
            }
            column(Leave_Allowance_Paid; "Leave Allowance Paid")
            {
            }
            column(Car_Allowance; "Car Allowance")
            {
            }
            column(Car_Allowance_Months_; "Car Allowance(Months)")
            {
            }
            column(Total; Total)
            {
            }
            column(PAYE_Due; "PAYE Due")
            {
            }
            column(Total_after_PAYE; "Total after PAYE")
            {
            }
            column(Total_Deductions; "Total Deductions")
            {
            }
            column(Amount_In_Lieu_of_Notice; "Amount In Lieu of Notice")
            {
            }
            column(Amount_Payable; "Amount Payable")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(HeaderTxt;HeaderTxt)
            {
                            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);
            end;
        }

    }

    var
        CompanyInfo: Record "Company Information";
        HeaderTxt: Label 'Employee Separation Report';
}