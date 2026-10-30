report 50107 "Rescheduled Loans"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Rescheduled Loans.rdl';

    dataset
    {
        dataitem(DataItem1; "Loan Rescheduling")
        {
            DataItemTableView = WHERE(Status = FILTER(Approved));
            RequestFilterFields = "Loan No.";
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(No_LoanRescheduling; "No.")
            {
            }
            column(MemberNo_LoanRescheduling; "Member No.")
            {
            }
            column(MemberName_LoanRescheduling; "Member Name")
            {
            }
            column(LoanNo_LoanRescheduling; "Loan No.")
            {
            }
            column(Description_LoanRescheduling; Description)
            {
            }
            column(ApprovedLoanAmount_LoanRescheduling; "Approved Loan Amount")
            {
            }
            column(OutstandingLoanBalance_LoanRescheduling; "Outstanding Loan Balance")
            {
            }
            column(CurrentRepaymentPeriod_LoanRescheduling; "Current Repayment Period")
            {
            }
            column(NewRepaymentPeriod_LoanRescheduling; "New Repayment Period")
            {
            }
            column(Remarks_LoanRescheduling; Remarks)
            {
            }
            column(CurrentRepaymentFrequency_LoanRescheduling; RepaymentFreq)
            {
            }
            column(NewRepaymentFrequency_LoanRescheduling; RepaymentFreq)
            {
            }
            column(CurrentInterestRate_LoanRescheduling; "Current Interest Rate")
            {
            }
            column(NewInterestRate_LoanRescheduling; "Current Interest Rate")
            {
            }
            column(ReschedulingOption_LoanRescheduling; "Rescheduling Type")
            {
            }
            trigger OnAfterGetRecord()
            begin
                if Loan.Get("Loan No.") then
                    RepaymentFreq := Format(Loan."Repayment Frequency");
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
        ReportTitle = 'Rescheduled Loans';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        RepaymentFreq: Text;
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        Member: Record "Member";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalAmount: array[4] of Decimal;
        Loan: Record "Loan Application";
}

