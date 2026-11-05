report 50014 "Mobile Banking Suspense Report"
{
    ApplicationArea = All;
    Caption = 'Mobile Banking Suspense Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Mobile Banking Suspense Report.rdl';
    dataset

    {
        dataitem(MobileBankingSuspense; "Mobile Banking Suspense")
        {
            RequestFilterFields = "Service ID";
            column(AccountNo; "Account No.")
            {

            }
            column(Amount; Amount)
            {
            }
            column(Description; Description)
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(ServiceID; "Service ID")
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column(TransactionNo; "Transaction No.")
            {
            }

            column(Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
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
    trigger OnPreReport()
    begin
        CompanyInfo.GET();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}
