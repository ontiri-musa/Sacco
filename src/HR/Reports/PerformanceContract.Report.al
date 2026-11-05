report 50289 "Performance Contract"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Performance Contract.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Performance Contract"; "Performance Contract")
        {
            RequestFilterFields = "Employee No.";
            column(Employee_No_; "Employee No.")
            {
            }
            column(Employee_Name; "Employee Name")
            {
            }
            column(Employment_Date; "Employment Date")
            {
            }
            column(Job_Title; "Job Title")
            {
            }
            column(Branch_Name; "Branch Name")
            {
            }
            column(Department_Name; "Department Name")
            {
            }
            column(Appraiser_Name; "Appraiser Name")
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(HeaderTxt; HeaderTxt)
            {
            }
            dataitem("Quantitative Goals Line"; "Quantitative Goals Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.") order(ascending);
                column(Code; Code)
                {
                }
                column(Description; Description)
                {
                }
                column(Objectives; Objectives)
                {
                }
                column(Indicators; Indicators)
                {
                }
                column(Action_Plans; "Action Plans")
                {
                }
                column(Agreed_Weighting; "Agreed Weighting")
                {
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        HeaderTxt: Label 'PERFORMANCE CONTRACT';
}