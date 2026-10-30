report 50086 "Loan Guarantors"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Guarantors.rdl';

    dataset
    {
        dataitem(DataItem16; "Loan Application")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            DataItemTableView = WHERE(Posted = FILTER(true), "Outstanding Balance" = filter(> 0));
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
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            dataitem(DataItem14; "Loan Guarantor")
            {
                DataItemLink = "Loan No." = FIELD("No.");
                DataItemTableView = SORTING("Loan No.", "Line No.");
                column(MemberNo_LoanGuarantor; "Member No.")
                {
                }
                column(MemberName_LoanGuarantor; "Member Name")
                {
                }
                column(AccountNo_LoanGuarantor; "Account No.")
                {
                }
                column(AccountName_LoanGuarantor; "Account Name")
                {
                }
                column(AccountBalance_LoanGuarantor; "Account Balance")
                {
                }
                column(OtherGuaranteedAmount_LoanGuarantor; "Other Guaranteed Amount")
                {
                }
                column(NetAccountBalance_LoanGuarantor; "Net Account Balance")
                {
                }
                column(AmountToGuarantee_LoanGuarantor; "Amount To Guarantee")
                {
                }
                column(AmountReleased; AmountReleased)
                {
                }
                column(AmountHeld; AmountHeld)
                {
                }
                column(PhoneNo; PhoneNo)
                {
                }
                trigger OnAfterGetRecord()
                var
                    Memb: record Member;
                begin
                    DataItem16.CalcFields("Outstanding Balance");
                    SumGuar := 0;
                    Ratio := 0;
                    AmountHeld := 0;
                    PhoneNo := '';
                    if Memb.Get(DataItem14."Member No.") then begin
                        PhoneNo := Memb."Phone No.";
                    end;

                    LGuar.Reset();
                    LGuar.SetRange(LGuar."Loan No.", DataItem14."Loan No.");
                    if LGuar.FindSet() then begin
                        LGuar.CalcSums("Amount To Guarantee");
                        SumGuar := LGuar."Amount To Guarantee";
                        Ratio := DataItem14."Amount To Guarantee" / DataItem16."Approved Amount";
                        AmountReleased := DataItem14."Amount To Guarantee" - (Ratio * DataItem16."Outstanding Balance");
                        if AmountReleased > 0 then
                            AmountReleased := AmountReleased
                        else
                            AmountReleased := 0;
                        AmountHeld := DataItem14."Amount To Guarantee" - AmountReleased;
                    end;
                end;
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
        ReportTitle = 'Loan Guarantors';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        AmountReleased: Decimal;
        AmountHeld: Decimal;
        SumGuar: Decimal;
        Ratio: Decimal;
        LGuar: Record "Loan Guarantor";
        Loan: Record "Loan Application";
        PhoneNo: code[100];
}

