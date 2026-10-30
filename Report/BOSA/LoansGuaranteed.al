report 50006 "Loans Guaranteed"
{
    ApplicationArea = All;
    Caption = 'Loans Guaranteed';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report\BOSA\LoansGuaranteed.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            column(No; "No.")
            {
            }
            column(FullName; "Full Name")
            {
            }
            column(ChurchCode; "Church Code")
            {
            }
            column(ChurchDistrictCode; "Church District Code")
            {
            }
            column(ChurchSectionCode; "Church Section Code")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }

            dataitem(Guaranteed; "Loan Guarantor")
            {
                DataItemLink = "Member No." = FIELD("No.");
                DataItemTableView = SORTING("Loan No.", "Line No.");

                column(MemberNo; MemberNo)
                {

                }
                column(MemberName; MemberName)
                {
                }
                column(AmountToGuarantee_LoanGuarantor; "Amount To Guarantee")
                {
                }
                column(LoanBal; LoanBal)
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
                    Memb: Record Member;
                begin
                    Loan.Reset();
                    Loan.SetRange(Loan."No.", Guaranteed."Loan No.");
                    if Loan.FindFirst() then begin
                        MemberNo := Loan."Member No.";
                        MemberName := Loan."Member Name";
                        Loan.CalcFields(Loan."Outstanding Balance");
                        if Loan."Outstanding Balance" <= 0 then
                            CurrReport.Skip;
                        LoanBal := Loan."Outstanding Balance";

                        SumGuar := 0;
                        Ratio := 0;
                        if Memb.Get(Loan."Member No.") then begin
                            PhoneNo := Memb."Phone No.";
                        end;

                        LGuar.Reset();
                        LGuar.SetRange(LGuar."Loan No.", Loan."No.");
                        if LGuar.FindSet() then begin
                            LGuar.CalcSums("Amount To Guarantee");
                            SumGuar := LGuar."Amount To Guarantee";
                            Ratio := Guaranteed."Amount To Guarantee" / Loan."Approved Amount";
                            AmountReleased := Guaranteed."Amount To Guarantee" - (Ratio * Loan."Outstanding Balance");
                            if AmountReleased > 0 then
                                AmountReleased := AmountReleased
                            else
                                AmountReleased := 0;
                            AmountHeld := Guaranteed."Amount To Guarantee" - AmountReleased;
                        end;
                    end;

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
                group(GroupName)
                {
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
        ReportTitle = 'Loans Guaranteed';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        AmountReleased: Decimal;
        PhoneNo: code[100];
        AmountHeld: Decimal;
        SumGuar: Decimal;
        Ratio: Decimal;
        LGuar: Record "Loan Guarantor";
        CompanyInfo: Record "Company Information";
        Loan: Record "Loan Application";
        MemberNo: code[20];
        MemberName: Text[150];
        LoanBal: Decimal;
        ReleasedAmount: Decimal;
        GuarRatioAmount: Decimal;
}
