report 58111 "Loan Funds Transfer Report"
{
    ApplicationArea = All;
    Caption = 'Loan Funds Transfer Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Loan Funds Transfer.rdl';
    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            column(No; "No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MemberName; "Member Name")
            {
            }
            column(Description; Description)
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(Church_District_Code; "Church District Code")
            { }
            column(Church_Section_Code; "Church Section Code")
            { }
            column(Church_Code; "Church Code")
            { }
            column(RepaymentPeriod; "Repayment Period")
            {
            }
            column(DisbursalDate; "Disbursal Date")
            {
            }
            column(DateofCompletion; "Date of Completion")
            {
            }
            column(Principal; Principal)
            {
            }
            column(Interest; Interest)
            {
            }
            column(LedgerFee; LedgerFee)
            {
            }
            column(Penalty; Penalty)
            {
            }
            column(OutstandingBalance; OutstandingBalance)
            {
            }
            column(OutstandingPrincipal; OutstandingPrincipal)
            {
            }
            column(Arrears; Arrears)
            { }
            column(EndDate; EndDate)
            { }
            column(FundsTransAmount; FundsTransAmount)
            { }
            trigger OnAfterGetRecord()
            var
                LoanRepSchedule: Record "Loan Repayment Schedule";
                GlobalM: Codeunit "Global Management";
                Amount: array[10] of Decimal;
                TransTypeSetupCode: Record "Transaction Type Code Setup";
                FundsTransfer: Record "Fund Transfer";
                FundsTransferLine: Record "Funds Transfer Line";
            begin
                If LoanApplication."Disbursal Date" > EndDate then
                    CurrReport.Skip();
                TransTypeSetupCode.Get();
                Arrears := 0;
                Principal := 0;
                Interest := 0;
                LedgerFee := 0;
                Penalty := 0;
                OutstandingBalance := 0;
                TransactionCount := 0;
                FundsTransAmount := 0;


                DCustL.Reset();
                DCustL.SetRange("Customer No.", LoanApplication."No.");
                DCustL.SetFilter("Posting Date", '<=%1', EndDate);
                If DCustL.FindSet() then begin
                    DCustL.CalcSums(Amount);
                    OutstandingBalance := DCustL.Amount;
                end;

                FundsTransfer.Reset();
                FundsTransfer.SetRange("Member No.", LoanApplication."Member No.");
                FundsTransfer.SetRange("Source Account Type", FundsTransfer."Source Account Type"::Vendor);
                FundsTransfer.SetRange(Posted, true);
                if FundsTransfer.FindSet() then begin
                    repeat
                        FundsTransferLine.Reset();
                        FundsTransferLine.SetRange("Document No.", FundsTransfer."No.");
                        FundsTransferLine.SetRange("Account Type", FundsTransferLine."Account Type"::Customer);
                        FundsTransferLine.SetRange("Account No.", LoanApplication."No.");
                        if FundsTransferLine.FindSet() then begin
                            FundsTransferLine.CalcSums("Line Amount");
                            FundsTransAmount += FundsTransferLine."Line Amount";
                        end;
                    until FundsTransfer.Next = 0;
                end;
                if FundsTransAmount = 0 then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if EndDate = 0D then
                    EndDate := Today;
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
                    field(EndDate; EndDate)
                    {
                        Caption = 'As At Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }
    var
        Arrears: Decimal;
        Principal: Decimal;
        Interest: Decimal;
        LedgerFee: Decimal;
        Penalty: Decimal;
        EndDate: Date;
        OutstandingBalance: Decimal;
        OutstandingPrincipal: Decimal;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        TransactionCount: Integer;
        FundsTransAmount: Decimal;
}
