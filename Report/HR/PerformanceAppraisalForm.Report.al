report 50287 "Performance Appraisal Form"
{
    DefaultLayout = RDLC;
    // RDLCLayout = 'Report\HR\Performance Appraisal Form.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Performance Review Header"; "Performance Review Header")
        {
            column(Employee_No_; "Employee No.")
            {
            }
            column(Full_Name; "Full Name")
            {
            }
            column(Branch_Name; "Branch Name")
            {
            }
            column(Department_Name; "Department Name")
            {
            }
            column(Employment_Date; "Employment Date")
            {
            }
            column(HeaderTxt; HeaderTxt)
            {
            }
            column(Text000; Text000)
            {
            }
            column(Text001; Text001)
            {
            }
            column(Footer; Footer)
            {
            }
            column(Period; Period)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            dataitem("Performance Competency Line-Qt"; "Performance Competency Line-Qt")
            {
                DataItemLink = "Review No." = field("Review No.");
                column(Code; Code)
                {
                }
                column(Description; Description)
                {
                }
                column(Employee_Score; "Employee Score")
                {
                }
                column(Appraiser_Score; "Appraiser Score")
                {
                }
                column(Agreed_Score; "Agreed Score")
                {
                }
                column(Agreed_Weighting; "Agreed Weighting")
                {
                }
            }
            dataitem("Performance Competency Line-Ql"; "Performance Competency Line-Ql")
            {
                DataItemLink = "Review No." = field("Review No.");
                column(Code_Ql; Code)
                {
                }
                column(Description_Ql; Description)
                {
                }
                column(Employee_Score_Ql; "Employee Score")
                {
                }
                column(Appraiser_Score_Ql; "Appraiser Score")
                {
                }
                column(Agreed_Score_Ql; "Agreed Score")
                {
                }
            }
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(appraisalperiod; appraisalperiod)
                {
                    Caption = 'Appraisal Period';
                    TableRelation = "Appraisal Period";
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInfo.Get();

        AppraisalPeriods.RESET;
        AppraisalPeriods.SETRANGE(Code, appraisalperiod);
        IF AppraisalPeriods.FINDFIRST THEN BEGIN
            Period := 'APPRAISAL PERIOD:' + AppraisalPeriods.Description;
        END;
    end;

    var

        HeaderTxt: Label 'PERFORMANCE APPRAISAL FORM';
        Text000: Label 'A.Quantitative Goals';
        Text001: Label 'B.Qualitative Goals';
        Footer: Label 'OVERALL AGREED PERCENTAGE SCORE:';
        AppraisalPeriods: Record "Appraisal Period";
        Period: Text;
        AppraisalPeriod: Code[10];
        CompanyInfo: Record "Company Information";
}

