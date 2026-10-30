report 50181 "Loan Insurrance Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/loanInsurranceReport.rdl';

    dataset
    {
        dataitem(DataItem7; "Loan Application")
        {
            DataItemTableView = WHERE("Outstanding Balance" = filter(> 0));
            RequestFilterFields = "Outstanding Balance";
            column(No_LoanApplication; "No.")
            {
            }
            column(MemberNo_LoanApplication; "Member No.")
            {
            }
            column(MemberName_LoanApplication; "Member Name")
            {
            }
            column(Disbursal_Date; "Disbursal Date")
            {
            }
            column(LoanProductType_LoanApplication; "Loan Product Type")
            {
            }
            column(Description_LoanApplication; Description)
            {
            }
            column(InterestRate_LoanApplication; "Interest Rate")
            {
            }
            column(RepaymentPeriod_LoanApplication; "Repayment Period")
            {
            }

            column(ApprovedAmount_LoanApplication; "Approved Amount")
            {
            }
            column(Outstanding_Balance; "Outstanding Balance")
            {
            }

            column(Date_of_Completion; "Date of Completion")
            {
            }
            column(PayableInstallment; PayableInstallment)
            {
            }
            column(Full_Name; "Member Name")
            {
            }
            column(No_; "Member No.")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Date_of_Birth; Date_of_Birth)
            {
            }
            column(National_ID; National_ID)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(SNo; SNo)
            {
            }
            column(Savings; Savings)
            {
            }
            column(Total; Total)
            {
            }

            column(Name; CompanyInfo.Name)
            {
            }

            trigger OnPreDataItem()
            Var
                LoanApp: Record "Loan Application";
            begin
                if (StartDate <> 0D) or (EndDate <> 0D) THEN
                    SetRange("Disbursal Date", StartDate, EndDate);
            end;


            trigger OnAfterGetRecord()
            var
            begin
                SNo += 1;
                Total := 0;
                Member.Get("Member No.");
                National_ID := Member."National ID";
                Date_of_Birth := Member."Date of Birth";
                Gender := Member.Gender;


                Vendor.RESET;
                Vendor.SETRANGE("Member No.", Member."No.");
                Vendor.SETRANGE("Account Type", '02');
                IF Vendor.FINDFIRST THEN BEGIN
                    Vendor.CALCFIELDS(Balance);
                    IF Vendor.Balance > 0 THEN
                        Total += Vendor.Balance;
                END;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                }

            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'Loan Insurance report';
    }
    trigger OnInitReport()
    begin
        SNo := 0;

    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;





    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RunningBalance: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        PayableInstallment: Decimal;
        StartDate: Date;
        EndDate: Date;
        BalanceBF: Decimal;
        SNo: Integer;
        Savings: Decimal;
        National_ID: Code[20];
        Date_of_Birth: Date;
        Gender: Option " ",Male,Female,Other;
        Total: Decimal;
        Vendor: Record Vendor;
        Member: Record Member;

}

