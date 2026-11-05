report 50117 "Loan Appraisal Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\BOSA\LoanAppraisal.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "No.", "Member No.";

            column(No_; "No.")
            {

            }
            column(Loan_Product_Type; "Loan Product Type")
            {

            }
            column(Description; Description)
            {

            }
            column(Member_No_; "Member No.")
            {

            }
            column(Member_Name; "Member Name")
            {

            }
            column(Requested_Amount; "Requested Amount")
            {

            }
            column(Approved_Amount; "Approved Amount")
            {

            }
            column(Interest_Rate; "Interest Rate")
            {

            }
            column(Repayment_Method; "Repayment Method")
            {

            }
            column(Repayment_Frequency; "Repayment Frequency")
            {

            }
            column(Repayment_Period; "Repayment Period")
            {

            }
            column(Total_Deposits_Amount; "Total Deposits Amount")
            {

            }
            column(TotalLoanBalance; TotalLoanBalance)
            {

            }
            column(TopupAmount; TopupAmount)
            {

            }
            column(TotalGuarantorsAmount; TotalGuarantorsAmount)
            {

            }
            column(TotalCollateralAmount; TotalCollateralAmount)
            {

            }
            column(ProcessingFee; ProcessingFee)
            {

            }
            column(InsuranceFee; InsuranceFee)
            {

            }
            column(interestChargedUpfront; interestChargedUpfront)
            {

            }
            column(TotalDeductions; TotalDeductions)
            {

            }
            column(QualifyingAmount; QualifyingAmount)
            {

            }

            column(Created_Date; "Created Date")
            {

            }
            column(Created_By; "Created By")
            {

            }
            column(Appraisal_Date; "Appraisal Date")
            {

            }
            column(Appraised_By; "Appraised By")
            {

            }
            column(Approved_By; "Approved By")
            {

            }
            column(Approved_Date; "Approved Date")
            {

            }
            column(No__of_Guarantors; "No. of Guarantors")
            {

            }
            column(Loan_Deposits_Ratio; "Loan Deposits Ratio")
            {

            }
            column(Max__Eligible_Amount_Deposit; "Max. Eligible Amount-Deposit")
            {

            }
            column(Total_Savings_Amount; "Total Savings Amount")
            {

            }
            column(Loan_Savings_Ratio; "Loan Savings Ratio")
            {

            }
            column(Max__Eligible_Amount_Savings; "Max. Eligible Amount-Savings")
            {

            }
            column(Total_Shares_Amount; "Total Shares Amount")
            {

            }
            column(Loan_Shares_Ratio; "Loan Shares Ratio")
            {

            }
            column(Max__Eligible_Amount_Shares; "Max. Eligible Amount-Shares")
            {

            }
            column(PayableInstallment; PayableInstallment)
            {

            }
            column(CompInfo_Picture; CompInfo.Picture)
            {

            }
            column(CompInfo_Name; CompInfo.Name)
            {

            }
            column(Remarks; Remarks)
            {

            }
            dataitem("Loan Guarantor"; "Loan Guarantor")
            {
                DataItemLink = "Loan No." = field("No.");
                column(Member_No_2; "Member No.")
                {

                }
                column(Member_Name2; "Member Name")
                {

                }
                column(Account_No_; "Account No.")
                {

                }
                column(Account_Name; "Account Name")
                {

                }
                column(Amount_To_Guarantee; "Amount To Guarantee")
                {

                }

            }
            dataitem("Loan Collateral"; "Loan Collateral")
            {
                DataItemLink = "Loan No." = field("No.");
                column(Security_Type_Code; "Security Type Code")
                {

                }
                column(Security_Register_Code; "Security Register Code")
                {

                }
                column(Description2; Description)
                {

                }
                column(Security_Value; "Security Value")
                {

                }
                column(Security_Factor; "Security Factor")
                {

                }
                column(Guaranteed_Amount; "Guaranteed Amount")
                {

                }

            }
            dataitem("Loan Refinancing Entry"; "Loan Refinancing Entry")
            {
                DataItemLink = "Loan No." = field("No.");
                column(Description3; Description)
                {

                }
                column(Outstanding_Balance; "Outstanding Balance")
                {

                }


            }


            trigger OnAfterGetRecord()
            var
                Installments: Integer;
                BosaM: Codeunit "BOSA Management";
                StartDate: Date;

            begin
                CalcFields("No. of Guarantors");
                TotalLoanBalance := BOSAManagement.CalculateOtherLoanBalances("Member No.");
                CalculateTopUpLoan("No.");
                CalculateTotalGuarantorsAmount("No.");
                CalculateTotalCollateralAmount("No.");
                if "Disbursal Date" = 0D then begin
                    StartDate := "Created Date";
                end else begin
                    StartDate := "Disbursal Date";
                end;
                Installments := BosaM.GetNoofInstallments("No.", StartDate, "Date of Completion");

                CalculateFees("Loan Product Type", "Requested Amount", Installments, "Insurrance On IPF", "Processing Fee On IPF");


                //  Message('%1,%2', InsuranceFee, Installments);

                TotalDeductions := InsuranceFee + ProcessingFee + TopupAmount;
                if (TotalGuarantorsAmount + TotalCollateralAmount) > "Requested Amount" then
                    QualifyingAmount := "Requested Amount"
                else
                    QualifyingAmount := (TotalGuarantorsAmount + TotalCollateralAmount);
                loanproductType.Get("Loan Product Type");
                if loanproductType.Code = 'IPF' then begin
                    TotalDeductions := "Interest Charged On IPF" + "Processing Fee On IPF" + "Insurrance On IPF";
                    interestChargedUpfront := "Interest Charged On IPF";
                    QualifyingAmount := "Approved Amount";

                end;
                GetPayableInstallment("No.");
                if "Loan Product Type" = 'IPF' then
                    PayableInstallment := "Monthly installments"
                else
                    PayableInstallment := PayableInstallment;

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
                {/* 
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    local procedure CalculateTopUpLoan(LoanNo: Code[20])
    var
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
    begin
        LoanRefinancingEntry.Reset();
        LoanRefinancingEntry.SetRange("Loan No.", LoanNo);
        LoanRefinancingEntry.SetRange(Select, true);
        LoanRefinancingEntry.CalcSums(LoanRefinancingEntry."Outstanding Balance");
        TopupAmount := LoanRefinancingEntry."Outstanding Balance";
    end;

    local procedure CalculateTotalGuarantorsAmount(LoanNo: Code[20])
    var
        LoanGuarantor: Record "Loan Guarantor";
    begin
        LoanGuarantor.Reset();
        LoanGuarantor.SetRange("Loan No.", LoanNo);
        LoanGuarantor.CalcSums("Amount To Guarantee");
        TotalGuarantorsAmount := LoanGuarantor."Amount To Guarantee";
    end;

    local procedure CalculateTotalCollateralAmount(LoanNo: Code[20])
    var
        LoanCollateral: Record "Loan Collateral";
    begin
        LoanCollateral.Reset();
        LoanCollateral.SetRange("Loan No.", LoanNo);
        LoanCollateral.CalcSums("Guaranteed Amount");
        TotalCollateralAmount := LoanCollateral."Guaranteed Amount";
    end;

    local procedure CalculateFees(LoanProductType: Code[20]; LoanAmount: Decimal; Instalments: Integer; ipfinsurrance: Decimal; ipfprocessingFee: Decimal)
    var
        LoanProductTypeRec: Record "Loan Product Type";
        LoanProductCharge: Record "Loan Product Charge";
        LoanChargeSetup: Record "Loan Charge Setup";
        BosaM: Codeunit "BOSA Management";
    begin
        ProcessingFee := 0;
        InsuranceFee := 0;
        LoanProductTypeRec.Get(LoanProductType);
        LoanProductCharge.Reset();
        LoanProductCharge.SetRange("Loan Product Type", LoanProductType);
        IF LoanProductCharge.FindSet() THEN begin
            repeat
                LoanChargeSetup.Get(LoanProductCharge.Code);
                IF LoanChargeSetup.Type = LoanChargeSetup.Type::"Processing Fee" then begin
                    if LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"Flat Amount" then
                        ProcessingFee := LoanProductCharge.Value;
                    if LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" then
                        ProcessingFee := LoanProductCharge.Value / 100 * LoanAmount;
                    if LoanProductCharge."Loan Product Type" = 'IPF' then begin
                        ProcessingFee := ipfprocessingFee;
                    end;
                    /* if ProcessingFee > LoanProductCharge."Maximum Amount" then
                         ProcessingFee := LoanProductCharge."Maximum Amount"
                     else
                         ProcessingFee := ProcessingFee;
 */
                    if ProcessingFee < LoanProductCharge."Minimum Amount" then
                        ProcessingFee := LoanProductCharge."Minimum Amount"
                    else
                        ProcessingFee := ProcessingFee;
                end;
                IF LoanChargeSetup.Type = LoanChargeSetup.Type::"Insurance Fee" then begin
                    if LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"Flat Amount" then
                        InsuranceFee := LoanProductCharge.Value;
                    if LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" then
                        InsuranceFee := Round(((LoanProductCharge.Value * LoanAmount * Instalments) / 1200), 1, '=');
                    if LoanProductCharge."Loan Product Type" = 'IPF' then begin
                        InsuranceFee := ipfinsurrance;
                    end;
                    if Member.Get("Loan Application"."Member No.") then begin
                        if Member.Category = Member.Category::Group then
                            InsuranceFee := 0;
                    end;
                end;


            UNTIL LoanProductCharge.Next() = 0;
        end;

    end;

    local procedure GetPayableInstallment(LoanNo: Code[20])
    var

    begin
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
        if LoanRepaymentSchedule.FindFirst() then
            PayableInstallment := LoanRepaymentSchedule."Principal Installment" + LoanRepaymentSchedule."Interest Installment";



    end;

    trigger OnPreReport()
    var

    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        TotalLoanBalance: Decimal;
        TopupAmount: Decimal;
        TotalGuarantorsAmount: Decimal;
        TotalCollateralAmount: Decimal;
        ProcessingFee: Decimal;
        InsuranceFee: Decimal;
        TotalDeductions: Decimal;
        QualifyingAmount: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        PayableInstallment: Decimal;
        BOSAManagement: Codeunit "BOSA Management";
        Member: Record Member;
        interestChargedUpfront: Decimal;
        loanproductType: Record "Loan Product Type";
}