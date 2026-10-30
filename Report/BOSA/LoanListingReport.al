report 50011 "Loan Listing Report"
{
    ApplicationArea = All;
    Caption = 'Loan Listing Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Loan Listing.rdl';
    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            column(No; "No.")
            {//
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
            column(ClassificationDesc; ClassificationDesc)
            { }
            column(DepositsBal; DepositsBal)
            { }
            column(Arrears; Arrears)
            { }
            column(EndDate; EndDate)
            { }
            trigger OnAfterGetRecord()
            var
                LoanRepSchedule: Record "Loan Repayment Schedule";
                GlobalM: Codeunit "Global Management";
                Amount: array[10] of Decimal;
                TransTypeSetupCode: Record "Transaction Type Code Setup";
                PrincBal: Decimal;
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
                ClassificationDesc := '';
                NoofDaysInArrears := 0;
                NoofInstallmentInArrears := 0;
                ClassificationCode := '';
                ProvisioningPercent := 0;
                PrincBal := 0;

                DCustL.Reset();
                DCustL.SetRange("Customer No.", LoanApplication."No.");
                DCustL.SetRange("Entry Type", DCustL."Entry Type"::"Initial Entry");
                DCustL.SetFilter("Posting Date", '<=%1', EndDate);
                If DCustL.FindSet() then begin
                    DCustL.CalcSums(Amount);
                    OutstandingBalance := DCustL.Amount;
                end;

                /* DCustL.Reset();
                 DCustL.SetRange("Customer No.", LoanApplication."No.");
                 DCustL.SetRange("Entry Type", DCustL."Entry Type"::"Initial Entry");
                 DCustL.SetFilter("Posting Date", '<=%1', EndDate);
                 if DCustL.FindSet() then begin
                     repeat
                         if (DCustL."Transaction Type Code" = TransTypeSetupCode."New Loan") or (DCustL."Transaction Type Code" = TransTypeSetupCode."Principal Paid") or (DCustL."Transaction Type Code" = 'CONT') then
                             PrincBal += DCustL.Amount;
                     until DCustL.Next = 0;
                 end;*/
                //if PrincBal = 0 then
                // CurrReport.Skip();
                GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, EndDate, Amount[1], Amount[2], Amount[3], Amount[4], Amount[5], Amount[6], Amount[7], Amount[8]);

                DCustL.Reset();
                DCustL.SetRange("Customer No.", LoanApplication."No.");
                DCustL.SetRange("Entry Type", DCustL."Entry Type"::"Initial Entry");
                DCustL.SetFilter("Posting Date", '<=%1', EndDate);
                If DCustL.FindSet() then begin
                    repeat
                        If (DCustL."Transaction Type Code" = TransTypeSetupCode."New Loan") or (DCustL."Transaction Type Code" = TransTypeSetupCode."Principal Paid") or (DCustL."Transaction Type Code" = 'CONT') then begin
                            TransactionCount := TransactionCount + 1;
                            Principal := Principal + DCustL.Amount;
                        end;
                    until DCustL.Next = 0;
                end;
                BOSAManagement.CalculateDaysAndInstallmentsInArrearsDefaulter(LoanApplication."No.", (Amount[1]), NoofDaysInArrears, NoofInstallmentInArrears, EndDate);
                BOSAManagement.GetClassificationClassDetails(NoofDaysInArrears, ClassificationCode, ClassificationDesc, ProvisioningPercent);

                //Message('Transaction Count %1', TransactionCount);
                Interest := Amount[2];
                LedgerFee := Amount[3];
                Penalty := Amount[4];
                Arrears := Amount[1];

                AccType.Reset();
                AccType.SetRange(Type, AccType.Type::"Member Deposit");
                if AccType.FindFirst() then begin
                    Vend.Reset();
                    Vend.SetRange("Member No.", LoanApplication."Member No.");
                    Vend.SetRange("Account Type", AccType.Code);
                    Vend.SetFilter("Date Filter", '..%1', EndDate);
                    if Vend.FindFirst() then begin
                        Vend.CalcFields("Net Change");
                        DepositsBal := Vend."Net Change";
                        /*DVendL.Reset();
                        DVendL.SetRange("Vendor No.", Vend."No.");
                        DVendL.SetRange("Entry Type", DVendL."Entry Type"::"Initial Entry");
                        DVendL.SetFilter("Posting Date", '<=%1', EndDate);
                        if DVendL.FindSet() then begin
                            DVendL.CalcSums(Amount);
                            DepositsBal := DVendL.Amount * -1;
                        end;*/
                    end;
                end;

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
        BOSAManagement: Codeunit "BOSA Management";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationCode: Code[100];
        ClassificationDesc: Text;
        ProvisioningPercent: Decimal;
        Arrears: Decimal;
        Principal: Decimal;
        Interest: Decimal;
        LedgerFee: Decimal;
        Penalty: Decimal;
        EndDate: Date;
        OutstandingBalance: Decimal;
        OutstandingPrincipal: Decimal;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        GLEnt: Record "G/L Entry";
        TransactionCount: Integer;
        DepositsBal: Decimal;
        Vend: Record Vendor;
        DVendL: Record "Detailed Vendor Ledg. Entry";
        AccType: Record "Account Type";
}
