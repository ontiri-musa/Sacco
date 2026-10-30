report 50999 membersCheckOffAdvice
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/membersCheckoffAdvice.rdl';


    dataset
    {
        dataitem(objmember; Member)
        {
            RequestFilterFields = "Church District Code";
            column(No_; "No.")
            {

            }
            column(consolidatedPrinipal; LoanBalnces[1])
            {

            }
            column(consolidatedInt; LoanBalnces[2])
            {

            }
            column(developmentPrinipal; LoanBalnces[3])
            {

            }
            column(developmentInt; LoanBalnces[4])
            {

            }
            column(educationPrinipal; LoanBalnces[5])
            {

            }
            column(educationInt; LoanBalnces[6])
            {

            }
            column(emergencyPrinipal; LoanBalnces[7])
            {

            }
            column(emergencyInt; LoanBalnces[8])
            {

            }
            column(eastRevolvingFundPrinipal; LoanBalnces[9])
            {

            }
            column(eastRevolvingFundInt; LoanBalnces[10])
            {

            }

            column(investmentPrinipal; LoanBalnces[11])
            {

            }
            column(investmentInt; LoanBalnces[12])
            {

            }

            column(konzaPrinipal; LoanBalnces[13])
            {

            }
            column(konzaInt; LoanBalnces[14])
            {

            }
            column(mobilePrinipal; LoanBalnces[15])
            {

            }
            column(mobileInt; LoanBalnces[16])
            {

            }
            column(Full_Name; "Full Name")
            {

            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(picture; CompanyInfo.Picture)
            {
            }
            column(Date; Date)
            {

            }
            column(Deposit; Deposit)
            {

            }
            column(lnTotals; lnTotals)
            {

            }
            column(district; district)
            {

            }

            column(Xhares; Xhares)
            {

            }
            trigger OnPreDataItem()
            begin
                IF Date = 0D THEN ERROR('Kindly Input Date');



            end;

            trigger OnAfterGetRecord()
            begin
                district := "Church District Code";




                lnTotals := 0;
                LoanBalnces[1] := 0;
                LoanBalnces[2] := 0;
                LoanBalnces[3] := 0;
                LoanBalnces[4] := 0;
                LoanBalnces[5] := 0;
                LoanBalnces[6] := 0;
                LoanBalnces[7] := 0;
                LoanBalnces[8] := 0;
                LoanBalnces[9] := 0;
                LoanBalnces[10] := 0;
                LoanBalnces[11] := 0;
                LoanBalnces[12] := 0;
                LoanBalnces[13] := 0;
                LoanBalnces[14] := 0;
                LoanBalnces[15] := 0;
                LoanBalnces[16] := 0;
                Xhares := 0;
                Deposit := 0;

                globalSetup.Get();
                deposit := globalSetup."Monthly deposit contribution";
                actualXshares := fnGetmemberShares("No.");
                if actualXshares < globalSetup."Minimum Share contribution" then
                    Xhares := globalSetup."Minimum Share contribution" - actualXshares
                else
                    Xhares := 0;

                objLoans.RESET;
                objLoans.SETRANGE(objLoans."Member No.", "No.");

                IF objLoans.FINDSET THEN BEGIN
                    REPEAT

                        objLoans.CALCFIELDS("Outstanding Balance");
                        IF objLoans."Outstanding Balance" > 0 THEN BEGIN
                            IF objLoans."Loan Product Type" = 'CON' THEN BEGIN

                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[1], LoanBalnces[2], lbal, lbal, lbal, lbal, lbal, lbal);

                            END;
                            IF objLoans."Loan Product Type" = 'DEV' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[3], LoanBalnces[4], lbal, lbal, lbal, lbal, lbal, lbal);

                            END;
                            IF objLoans."Loan Product Type" = 'EDU' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[5], LoanBalnces[6], lbal, lbal, lbal, lbal, lbal, lbal);
                            END;
                            IF objLoans."Loan Product Type" = 'EL' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[7], LoanBalnces[8], lbal, lbal, lbal, lbal, lbal, lbal);
                            END;
                            IF objLoans."Loan Product Type" = 'ERF' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[8], LoanBalnces[9], lbal, lbal, lbal, lbal, lbal, lbal);
                            END;
                            IF objLoans."Loan Product Type" = 'INV' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[10], LoanBalnces[11], lbal, lbal, lbal, lbal, lbal, lbal);
                            END;
                            IF objLoans."Loan Product Type" = 'KL' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[12], LoanBalnces[13], lbal, lbal, lbal, lbal, lbal, lbal);
                            END;
                            IF objLoans."Loan Product Type" = 'MB' THEN BEGIN
                                cuGlobalMgt.CalculateLoanArrearsAndOverpaymentCheckoffAdvice(objLoans."No.", CalcDate('<-CM>', Date), Date, LoanBalnces[15], LoanBalnces[16], lbal, lbal, lbal, lbal, lbal, lbal);
                            END;
                        END;
                    UNTIL objLoans.NEXT = 0;
                    lnTotals := LoanBalnces[1] + LoanBalnces[2] + LoanBalnces[3] + LoanBalnces[4] + LoanBalnces[5] + LoanBalnces[6] + LoanBalnces[7] + LoanBalnces[8] + LoanBalnces[9] + LoanBalnces[10] +
                                  LoanBalnces[11] + LoanBalnces[12] + LoanBalnces[13] + LoanBalnces[14] + LoanBalnces[15] + LoanBalnces[16];
                END;
            END;



        }
    }

    requestpage
    {


        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Date; Date)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get()

    end;

    trigger OnPreReport()
    begin
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure fnGetmemberShares(code: Code[45]) amt: Decimal
    begin
        actts.Reset();
        actts.SetRange("Member No.", code);
        actts.SetFilter("Account Type", '%1', '01');
        if actts.Find('-') then begin
            actts.CalcFields(Balance);
            amt := actts.Balance;
        end;
        exit(amt);
    end;

    var
        myInt: Integer;
        LoanBalnces: array[24] of Decimal;
        CompanyInfo: Record "Company Information";
        Date: Date;
        Deposit: Decimal;
        lnTotals: Decimal;
        churchDistrictCode: Code[100];
        Member: Record Member;
        district: Code[45];
        Xhares: Decimal;
        membCont: Record "Member Contribution";
        acType: Record "Account Type";
        objLoans: Record "Loan Application";
        cuGlobalMgt: Codeunit "Global Management";
        lbal: Decimal;
        globalSetup: Record "Global Setup";
        actts: Record Vendor;
        actualXshares: Decimal;

}