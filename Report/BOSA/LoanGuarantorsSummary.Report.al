report 59186 "Loan Guarantor Summary"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Guarantors Summary.rdl';

    dataset
    {
        dataitem(DataItem16; "Loan Application")
        {
            // PrintOnlyIfDetail = true;
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
            column(Approved_Amount; "Approved Amount")
            {

            }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
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
            column(AmountToGuarantee_LoanGuarantor; "Total Guaranteed Amount")
            {
            }
            column(AmountReleased; AmountReleased)
            {
            }
            column(AmountHeld; AmountHeld)
            {
            }
            trigger OnAfterGetRecord()
            begin
                DataItem16.CalcFields("Outstanding Balance", "Total Guaranteed Amount");
                if DataItem16."Total Guaranteed Amount" <= 0 then
                    CurrReport.Skip();

                SumGuar := 0;
                Ratio := 0;
                AmountHeld := 0;
                AmountReleased := 0;

                LGuar.Reset();
                LGuar.SetRange(LGuar."Loan No.", DataItem16."No.");
                if LGuar.FindSet() then begin
                    LGuar.CalcSums("Amount To Guarantee");
                    SumGuar := LGuar."Amount To Guarantee";
                    Ratio := Round(LGuar."Amount To Guarantee" / DataItem16."Approved Amount");
                    AmountReleased := Round(LGuar."Amount To Guarantee" - (Ratio * DataItem16."Outstanding Balance"));
                    if AmountReleased > 0 then
                        AmountReleased := AmountReleased
                    else
                        AmountReleased := 0;
                    AmountHeld := Round(LGuar."Amount To Guarantee" - AmountReleased);
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
        ReportTitle = 'Loan Guarantors Summary';
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
}

