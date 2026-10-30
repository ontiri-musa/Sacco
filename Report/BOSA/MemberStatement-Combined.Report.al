report 50087 "Member Statement-Combined"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/MemberStatement-Combined.rdl';

    dataset
    {
        dataitem(Member; Member)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_Member; "No.")
            {
            }
            column(Surname_Member; Surname)
            {
            }
            column(FullName_Member; "Full Name")
            {
            }
            column(GlobalDimension1Code_Member; "Global Dimension 1 Code")
            {
            }
            column(Phone_No_; "Phone No.")
            {
            }
            column(National_ID; "National ID")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Church_District_Code; "Church District Code")
            { }
            column(Section_Name; "Section Name")
            { }
            column(Church_Code; "Church Code")
            { }
            dataitem(Vendor; Vendor)
            {
                DataItemTableView = where("Vendor Type" = filter(1));
                DataItemLink = "Member No." = FIELD("No.");
                //DataItemTableView = SORTING("No.");
                column(No_Vendor; "No.")
                {
                }
                column(Name_Vendor; Name)
                {
                }
                column(BalanceLCY_Vendor; "Balance (LCY)")
                {
                }
                dataitem(DataItem6; "Vendor Ledger Entry")
                {
                    RequestFilterFields = "Posting Date";
                    DataItemLink = "Vendor No." = FIELD("No.");
                    DataItemTableView = SORTING("Posting Date") order(ascending);
                    column(Entry_No_; "Entry No.")
                    {
                    }
                    column(VendorNo_VendorLedgerEntry; "Vendor No.")
                    {
                    }
                    column(PostingDate_VendorLedgerEntry; "Posting Date")
                    {
                    }
                    column(DocumentType_VendorLedgerEntry; "Document Type")
                    {
                    }
                    column(DocumentNo_VendorLedgerEntry; "Document No.")
                    {
                    }
                    column(Description_VendorLedgerEntry; Description)
                    {
                    }
                    column(CurrencyCode_VendorLedgerEntry; "Currency Code")
                    {
                    }
                    column(Amount_VendorLedgerEntry; Amount)
                    {
                    }
                    column(RemainingAmount_VendorLedgerEntry; "Remaining Amount")
                    {
                    }
                    column(Debit_Amount; "Debit Amount")
                    {
                    }
                    column(Credit_Amount; "Credit Amount")
                    {
                    }
                    column(Reversed; Reversed)
                    {
                    }
                    column(RunningBalance; RunningBalance)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Reversed then
                            CurrReport.Skip();
                        CalcFields(Amount);
                        RunningBalance += Amount;
                    end;


                }
                trigger OnAfterGetRecord()
                begin
                    RunningBalance := 0;
                end;
            }
            dataitem("Loan Application"; "Loan Application")
            {
                RequestFilterFields = "No.", "Loan Product Type";
                DataItemLink = "Member No." = FIELD("No.");
                DataItemTableView = WHERE(Posted = FILTER(true));
                column(No_LoanApplication; "No.")
                {
                }
                column(MemberNo_LoanApplication; "Member No.")
                {
                }
                column(MemberName_LoanApplication; "Member Name")
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
                column(RepaymentMethod_LoanApplication; "Repayment Method")
                {
                }
                column(RequestedAmount_LoanApplication; "Requested Amount")
                {
                }
                column(ApprovedAmount_LoanApplication; "Approved Amount")
                {
                }
                column(TotalSavingsAmount_LoanApplication; "Total Savings Amount")
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
                column(Disbursal_Date; "Disbursal Date")
                {
                }
                column(OutStandingInt; OutStandingInt)
                {

                }

                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Posting Date") order(ascending);
                    RequestFilterFields = "Posting Date";
                    column(Entry_No_2;
                    "Entry No.")
                    {
                    }
                    column(CustomerNo_CustLedgerEntry; "Customer No.")
                    {
                    }
                    column(PostingDate_CustLedgerEntry; "Posting Date")
                    {
                    }
                    column(DocumentType_CustLedgerEntry; "Document Type")
                    {
                    }
                    column(DocumentNo_CustLedgerEntry; "Document No.")
                    {
                    }
                    column(Description_CustLedgerEntry; Description)
                    {
                    }
                    column(CurrencyCode_CustLedgerEntry; "Currency Code")
                    {
                    }
                    column(Amount_CustLedgerEntry; Amount)
                    {
                    }
                    column(RemainingAmount_CustLedgerEntry; "Remaining Amount")
                    {
                    }
                    column(RunningBalance2; RunningBalance2)
                    {
                    }
                    column(Debit_Amount2; DebitA)
                    {
                    }
                    column(Credit_Amount2; CreditA)
                    {
                    }
                    column(Reversed2; Reversed)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        DCustL: Record "Detailed Cust. Ledg. Entry";
                        Text0001: Label 'Interest Recovered from Prepayment-';
                        Text0002: Label 'Interest Charged Paid from Prepayment-';
                        Text0003: Label 'Principal Recovered from Prepayment-';
                        Text0004: Label 'Principal Paid from Prepayment-';
                        Text0005: Label 'Penalty Recovered from Prepayment-';
                        Text0006: Label 'Penalty Paid from Prepayment-';
                    begin
                        DebitA := 0;
                        CreditA := 0;
                        if Reversed then
                            CurrReport.Skip();

                        if (Text0001 + "Cust. Ledger Entry"."Customer No." = "Cust. Ledger Entry".Description) or
                        (Text0002 + "Cust. Ledger Entry"."Customer No." = "Cust. Ledger Entry".Description) or
                        (Text0003 + "Cust. Ledger Entry"."Customer No." = "Cust. Ledger Entry".Description) or
                        (Text0004 + "Cust. Ledger Entry"."Customer No." = "Cust. Ledger Entry".Description) or
                        (Text0005 + "Cust. Ledger Entry"."Customer No." = "Cust. Ledger Entry".Description) or
                        (Text0006 + "Cust. Ledger Entry"."Customer No." = "Cust. Ledger Entry".Description) then
                            CurrReport.Skip();

                        CalcFields(Amount);
                        DCustL.Reset();
                        DCustL.SetRange("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Entry No.");
                        if DCustL.FindFirst() then begin
                            RunningBalance2 += DCustL.Amount;
                            DebitA := DCustL."Debit Amount";
                            CreditA := DCustL."Credit Amount";
                        end;

                    end;


                }
                trigger OnAfterGetRecord()
                begin
                    RunningBalance2 := 0;
                    GetPayableInstallment("Loan Application"."No.");
                    GetOutStandingInt("Loan Application"."No.");
                end;

            }
            trigger OnAfterGetRecord()
            begin
                ChurchSection := '';

                ChrchSect.Reset();
                ChrchSect.SetRange(ChrchSect.Code, Member."Church Section Code");
                if ChrchSect.FindFirst() then begin
                    ChurchSection := ChrchSect.Name;
                end;
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
        ReportTitle = 'Member Statement';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    local procedure GetPayableInstallment(LoanNo: Code[20])
    var

    begin
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoanNo);
        if LoanRepaymentSchedule.FindFirst() then
            PayableInstallment := LoanRepaymentSchedule."Principal Installment" + LoanRepaymentSchedule."Interest Installment";

    end;

    local procedure GetOutStandingInt(LoanNo: Code[20])
    Begin
        OutStandingInt := 0;

        DetailedCustL.Reset();
        DetailedCustL.SetRange("Customer No.", LoanNo);
        if DetailedCustL.FindSet then begin
            repeat
                TransactionCodeSetup.Get();
                if (DetailedCustL."Transaction Type Code" = TransactionCodeSetup."Interest Due") or (DetailedCustL."Transaction Type Code" = TransactionCodeSetup."Interest Paid") then
                    OutStandingInt += DetailedCustL.Amount;
            until DetailedCustL.Next = 0;
        end;
    End;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RunningBalance: Decimal;
        RunningBalance2: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        PayableInstallment: Decimal;
        OutStandingInt: Decimal;
        TransactionCodeSetup: Record "Transaction Type Code Setup";
        TransactionTpe: Record "Transaction Type";
        DetailedCustL: Record "Detailed Cust. Ledg. Entry";
        ChurchSection: text[150];
        MemberN: Record Member;
        ChrchSect: Record "Church Section";
        DebitA: Decimal;
        CreditA: Decimal;
}