report 52019 "Loan Calculator"
{
    ApplicationArea = All;
    Caption = 'Loan Calculator';
    UsageCategory = Tasks;
    RDLCLayout = 'Report/BOSA/Loan Calculator.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.";
            column(No_LoanApplication; "No.")
            {
            }
            column(InterestRate_LoanApplication; InterestRate)
            {
            }
            column(MemberNo_LoanApplication; "No.")
            {
            }
            column(MemberName_LoanApplication; "Full Name")
            {
            }
            column(LoanProductType_LoanApplication; LoanProdType)
            {
            }
            column(Description_LoanApplication; ProdDesc)
            {
            }
            column(RepaymentPeriod_LoanApplication; RepayPeriod)
            {
            }
            column(RepaymentMethod_LoanApplication; RepayMethod)
            {
            }
            column(RequestedAmount_LoanApplication; RequestedAmount)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(TotalAmount_1; TotalAmount[1])
            {
            }
            column(TotalAmount_2; TotalAmount[2])
            {
            }
            column(TotalAmount_3; TotalAmount[3])
            {
            }
            dataitem(DataItem1; "Loan Repayment Schedule")
            {
                DataItemLink = "Loan No." = FIELD("No.");
                DataItemTableView = SORTING("Loan No.", "Instalment No.");
                column(LoanNo_LoanRepaymentSchedule; "Loan No.")
                {
                }
                column(LoanAmount_LoanRepaymentSchedule; "Loan Amount")
                {
                }
                column(RepaymentDate_LoanRepaymentSchedule; "Repayment Date")
                {
                }
                column(InstalmentNo_LoanRepaymentSchedule; "Instalment No.")
                {
                }
                column(PrincipalInstallment_LoanRepaymentSchedule; "Principal Installment")
                {
                }
                column(InterestInstallment_LoanRepaymentSchedule; "Interest Installment")
                {
                }
                column(TotalInstallment_LoanRepaymentSchedule; "Total Installment")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                GenerateRepaymentSchedule(Member);

                LoanRepaymentSchedule.RESET;
                LoanRepaymentSchedule.SETRANGE("Loan No.", "No.");
                LoanRepaymentSchedule.CALCSUMS("Principal Installment", "Interest Installment", "Total Installment");
                TotalAmount[1] := LoanRepaymentSchedule."Principal Installment";
                TotalAmount[2] := LoanRepaymentSchedule."Interest Installment";
                TotalAmount[3] := LoanRepaymentSchedule."Total Installment";
            end;

            trigger OnPreDataItem()
            begin
                if LoanProdType = '' then
                    Error('Loan Product must have a value');
                if RequestedAmount = 0 then
                    Error('Requested Amount must have a value');
                if Format(RepayPeriod) = '' then
                    Error('Repayment Period must have a value');

                LoanProduct.Get(LoanProdType);
                InterestRate := LoanProduct."Interest Rate";
                ProdDesc := LoanProduct.Description;
                RepayMethod := LoanProduct."Recovery Method";
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(LoanProdType; LoanProdType)
                    {
                        Caption = 'Loan Product';
                        TableRelation = "Loan Product Type";
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field(RequestedAmount; RequestedAmount)
                    {
                        Caption = 'Requested Amount';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field(RepayPeriod; RepayPeriod)
                    {
                        Caption = 'Repayment Period';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
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
    labels
    {
        ReportTitle = 'Loan Calculator';
    }


    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    procedure GenerateRepaymentSchedule(Member: Record Member)
    Var
        BosaM: Codeunit "BOSA Management";
    begin
        BosaM.CreateRepaymentScheduleLoanCalculator(Member."No.", RequestedAmount, LoanProdType, RepayPeriod);
    end;

    var
        CompanyInfo: Record "Company Information";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalAmount: array[4] of Decimal;
        LoanProdType: Code[50];
        RepayPeriod: DateFormula;
        LoanProduct: Record "Loan Product Type";
        RequestedAmount: Decimal;
        InterestRate: Decimal;
        ProdDesc: Text;
        RepayMethod: Option "Straight Line","Reducing Balance",Amortization;
}
