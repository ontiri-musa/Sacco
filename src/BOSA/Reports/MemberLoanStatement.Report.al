report 50081 "Member Loan Statement"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Loan Statement.rdl';

    dataset
    {
        dataitem(DataItem1; Member)
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
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Phone_No_; "Phone No.")
            {
            }
            column(National_ID; "National ID")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem7; "Loan Application")
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
                dataitem(DataItem6; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Posting Date") order(ascending);
                    //RequestFilterFields = "Posting Date";
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
                    column(RunningBalance; RunningBalance)
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
                    trigger OnPreDataItem()
                    var
                        CustLEntry: Record "Cust. Ledger Entry";
                    begin
                        if (StartDate <> 0D) or (EndDate <> 0D) THEN
                            SetRange("Posting Date", StartDate, EndDate);
                        If StartDate <> 0D then begin
                            CustLEntry.Reset();
                            CustLEntry.SetRange("Customer No.", DataItem7."No.");
                            CustLEntry.SetFilter("Posting Date", '<%1', StartDate);
                            If CustLEntry.FindSet() then begin
                                repeat
                                    CustLEntry.CalcFields(Amount);
                                    RunningBalance += CustLEntry.Amount;
                                until CustLEntry.Next = 0;
                            end;
                        end;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        Text0001: Label 'Interest Recovered from Prepayment-';
                        Text0002: Label 'Interest Charged Paid from Prepayment-';
                        Text0003: Label 'Principal Recovered from Prepayment-';
                        Text0004: Label 'Principal Paid from Prepayment-';
                        Text0005: Label 'Penalty Recovered from Prepayment-';
                        Text0006: Label 'Penalty Paid from Prepayment-';
                    begin
                        RunningBalance += Amount;
                        if Reversed then
                            CurrReport.Skip();

                        if (Text0001 + DataItem6."Customer No." = DataItem6.Description) or
                        (Text0002 + DataItem6."Customer No." = DataItem6.Description) or
                        (Text0003 + DataItem6."Customer No." = DataItem6.Description) or
                        (Text0004 + DataItem6."Customer No." = DataItem6.Description) or
                        (Text0005 + DataItem6."Customer No." = DataItem6.Description) or
                        (Text0006 + DataItem6."Customer No." = DataItem6.Description) then
                            CurrReport.Skip();
                    end;

                }
                trigger OnAfterGetRecord()
                var
                begin
                    GetPayableInstallment("No.");
                    CalculateBalanceBF("No.");
                    RunningBalance := 0;
                end;
            }
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
        ReportTitle = 'Loan Statement';
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

    local procedure CalculateBalanceBF(LoanNo: Code[20])
    var

        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        BalanceBF := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", LoanNo);
        if CustLedgerEntry.FindFirst() then begin
            //  Error(LoanNo);
            repeat
                CustLedgerEntry.CalcFields(Amount);
                BalanceBF += CustLedgerEntry.Amount;
            until CustLedgerEntry.Next() = 0;
        end;

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

}

