report 50023 "Second Demand Letter"
{
    ApplicationArea = All;
    Caption = 'Second Demand Letter';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Second Demand Letter.rdl';

    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MemberName; "Member Name")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
