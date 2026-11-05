report 50288 "Performance Objectives Guide"
{
    DefaultLayout = RDLC;
    // RDLCLayout = 'Report\HR\Performance Objectives Guide.rdl';

    dataset
    {
        dataitem(DataItem1; "Quantitative Goal")
        {
            column(Code; Code)
            {
            }
            column(Description; Description)
            {
            }
            column(Score; Score)
            {
            }
            column(Header; Header)
            {
            }
            column(Footer; Footer)
            {
            }
            column(Text000; Text000)
            {
            }
            column(Text001; Text001)
            {
            }
            column(Text002; Text002)
            {
            }
            column(Text003; Text003)
            {
            }
            column(Text005; Text005)
            { }
            column(Text006; Text006)
            { }
            column(Text007; Text007)
            { }

        }
        dataitem("Qualitative Goal"; "Qualitative Goal")
        {
            DataItemTableView = sorting(Code) order(ascending);
            column(Code_Ql; Code)
            {
            }
            column(Description_QualitativeGoals; Description)
            {
            }
            column(Score_Ql; Score)
            {
            }

        }
    }
    trigger OnPreReport()
    begin
        Footer := StrSubstNo(Text004, GetCurrentAppraisalYear());
    end;

    var
        Header: Label 'PERFORMANCE OBJECTIVES GUIDE';
        Text000: Label 'Weighting for objectives will be linked to the balance scorecard as follows:';
        Text001: Label 'A.Quantitative Goals - 80% of total weighting';
        Text002: Label 'Weighting for competencies can also be distributed as follows as follows:';
        Text003: Label 'B.Qualitative Goals - 20% of total weighting';
        Text004: Label 'Both the Appraiser and the Appraisee confirm that the above objectives/targets for the year %1 have been discussed and agreed upon. ';
        Text005: Label 'Signed By:';
        Text006: Label 'Appraiser: _________________________________________   Date: _______________________';
        Text007: Label 'Appraisee: _________________________________________   Date: _______________________';
        Footer: Text;
        CompanyInformation: Record "Company Information";

    procedure GetCurrentAppraisalYear(): Integer
    var
        ApprasialPeriod: Record "Appraisal Period";
    begin
        ApprasialPeriod.reset;
        ApprasialPeriod.SetRange(Active, true);
        if ApprasialPeriod.FindFirst() then
            exit(ApprasialPeriod.Year);
    end;

}

