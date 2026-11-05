report 50336 "Member Exit Summary"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Exit Summary.rdl';

    dataset
    {
        dataitem(DataItem1; "Member Exit Header")
        {

            RequestFilterFields = "No.", "Date Posted";
            DataItemTableView = where(Posted = filter(true));
            column(No_Member; "No.")
            {
            }
            column(Member_No_; "Member No.")
            {
            }
            column(Member_Name; "Member Name")
            {
            }
            column(Reason_Code; "Reason Code")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Member_Deposits; "Member Deposits")
            {
            }
            column(Net_Payment; "Net Payment")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Total_Outstanding_Loan; "Total Outstanding Loan")
            {
            }
            column(Exit_Fee; "Exit Fee")
            {
            }
            column(Total_Deductions; "Total Deductions")
            {
            }
            column(Date_Posted; "Date Posted")
            {
            }


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
        ReportTitle = 'Member Exit Summary';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;





    var

        CompanyInfo: Record "Company Information";



}

