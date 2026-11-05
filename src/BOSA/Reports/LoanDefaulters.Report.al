report 50078 "Loan Defaulters"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Defaulters.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Defaulter Entry")
        {
            RequestFilterFields = "Member No.";
            column(LoanNo_LoanDefaulterEntry; "Loan No.")
            {
            }
            column(Description_LoanDefaulterEntry; Description)
            {
            }
            column(MemberNo_LoanDefaulterEntry; "Member No.")
            {
            }
            column(MemberName_LoanDefaulterEntry; "Member Name")
            {
            }
            column(ApprovedAmount_LoanDefaulterEntry; "Approved Amount")
            {
            }
            column(RepaymentMethod_LoanDefaulterEntry; "Repayment Method")
            {
            }
            column(RepaymentPeriod_LoanDefaulterEntry; "Repayment Period")
            {
            }
            column(RemainingPeriod_LoanDefaulterEntry; "Remaining Period")
            {
            }
            column(RemainingPrincipalAmount_LoanDefaulterEntry; "Remaining Principal Amount")
            {
            }
            column(RemainingInterestAmount_LoanDefaulterEntry; "Remaining Interest Amount")
            {
            }
            column(PrincipalInstallment_LoanDefaulterEntry; "Principal Installment")
            {
            }
            column(InterestInstallment_LoanDefaulterEntry; "Interest Installment")
            {
            }
            column(TotalInstallment_LoanDefaulterEntry; "Total Installment")
            {
            }
            column(PrincipalArrearsAmount_LoanDefaulterEntry; "Principal Arrears")
            {
            }
            column(InterestArrearsAmount_LoanDefaulterEntry; "Interest Arrears")
            {
            }
            column(TotalArrearsAmount_LoanDefaulterEntry; "Total Arrears")
            {
            }
            column(OutstandingBalance_LoanDefaulterEntry; "Outstanding Balance")
            {
            }
            column(ClassificationClass_LoanDefaulterEntry; "Class Description")
            {
            }
            column(RepaymentFrequency_LoanDefaulterEntry; "Repayment Frequency")
            {
            }
            column(NoofDaysinArrears_LoanDefaulterEntry; "No. of Days in Arrears")
            {
            }
            column(LastPaymentDate_LoanDefaulterEntry; "Last Payment Date")
            {
            }
            column(NoofDefaultedInstallment_LoanDefaulterEntry; "No. of Defaulted Installment")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
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
        ReportTitle = 'Loan Defaulters';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
}

