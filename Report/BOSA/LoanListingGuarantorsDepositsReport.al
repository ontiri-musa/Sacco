report 55211 "LoanListingGuarDepReport"
{
    ApplicationArea = All;
    Caption = 'Loan Listing Guarantors Deposits Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Loan Listing Guarantors Deposits Report.rdl';
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
            column(ClassificationDesc; ClassificationDesc)
            { }
            column(DepositsBal; DepositsBal)
            { }
            column(Arrears; Arrears)
            { }
            column(EndDate; EndDate)
            { }
            dataitem("Loan Guarantor"; "Loan Guarantor")
            {
                DataItemLink = "Loan No." = FIELD("No.");
                DataItemTableView = SORTING("Loan No.", "Line No.");
                column(Member_No_; "Member No.")
                {

                }
                column(Member_Name; "Member Name")
                { }
                column(GuarDepBal; GuarDepBal)
                { }
                trigger OnAfterGetRecord()
                begin
                    GuarDepBal := 0;

                    AccType.Reset();
                    AccType.SetRange(Type, AccType.Type::"Member Deposit");
                    if AccType.FindFirst() then begin
                        Vend.Reset();
                        Vend.SetRange("Member No.", "Loan Guarantor"."Member No.");
                        Vend.SetRange("Account Type", AccType.Code);
                        if Vend.FindFirst() then begin
                            DVendL.Reset();
                            DVendL.SetRange("Vendor No.", Vend."No.");
                            DVendL.SetFilter("Posting Date", '<=%1', EndDate);
                            if DVendL.FindSet() then begin
                                DVendL.CalcSums(Amount);
                                GuarDepBal := DVendL.Amount * -1;
                            end;
                        end;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                LoanRepSchedule: Record "Loan Repayment Schedule";
                GlobalM: Codeunit "Global Management";
                Amount: array[10] of Decimal;
                TransTypeSetupCode: Record "Transaction Type Code Setup";
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

                DCustL.Reset();
                DCustL.SetRange("Customer No.", LoanApplication."No.");
                DCustL.SetFilter("Posting Date", '<=%1', EndDate);
                If DCustL.FindSet() then begin
                    DCustL.CalcSums(Amount);
                    OutstandingBalance := DCustL.Amount;
                end;

                GlobalM.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, EndDate, Amount[1], Amount[2], Amount[3], Amount[4], Amount[5], Amount[6]);

                DCustL.Reset();
                DCustL.SetRange("Customer No.", LoanApplication."No.");
                DCustL.SetFilter("Posting Date", '<=%1', EndDate);
                If DCustL.FindSet() then begin
                    repeat
                        If (DCustL."Transaction Type Code" = TransTypeSetupCode."New Loan") or (DCustL."Transaction Type Code" = TransTypeSetupCode."Principal Paid") then begin
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
                    if Vend.FindFirst() then begin
                        DVendL.Reset();
                        DVendL.SetRange("Vendor No.", Vend."No.");
                        DVendL.SetFilter("Posting Date", '<=%1', EndDate);
                        if DVendL.FindSet() then begin
                            DVendL.CalcSums(Amount);
                            DepositsBal := DVendL.Amount * -1;
                        end;
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
        GuarDepBal: Decimal;
        Principal: Decimal;
        Interest: Decimal;
        LedgerFee: Decimal;
        Penalty: Decimal;
        EndDate: Date;
        OutstandingBalance: Decimal;
        OutstandingPrincipal: Decimal;
        DCustL: Record "Detailed Cust. Ledg. Entry";
        TransactionCount: Integer;
        DepositsBal: Decimal;
        Vend: Record Vendor;
        DVendL: Record "Detailed Vendor Ledg. Entry";
        AccType: Record "Account Type";
}
