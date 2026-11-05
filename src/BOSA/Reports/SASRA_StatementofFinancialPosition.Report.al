
report 50123 "Statement of Fin. Position"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\BOSA\StatementofFinancialPosition.rdl';
    Caption = 'Statement of Financial Position';

    dataset
    {
        dataitem(Integer; Integer)
        {
            // DataItemTableView=sorting()
            column(Number; Number)
            {


            }
            column(CashInHand; Amount[1])
            {

            }
            column(CashAtBank; Amount[2])
            {

            }
            column(GovSecurities; Amount[3])
            {

            }
            column(OtherSecurities; Amount[4])
            {

            }
            column(InvInCompanies; Amount[5])
            {

            }
            column(GrossLoanPortfolio; Amount[6])
            {

            }
            column(AllowanceForLoanLoss; Amount[7])
            {

            }
            column(TaxRec; Amount[8])
            {

            }
            column(DefTaxAssets; Amount[9])
            {

            }
            column(RetBenAssets; Amount[10])
            {

            }
            column(InvProperties; Amount[11])
            {

            }
            column(Prop_Equipment; Amount[12])
            {

            }
            column(PrePaidLease; Amount[13])
            {

            }
            column(IntanAssets; Amount[14])
            {

            }
            column(OtherAssets; Amount[15])
            {

            }
            column(STDeposits; Amount[16])
            {

            }
            column(NWDeposits; Amount[17])
            {

            }
            column(TaxPayable; Amount[18])
            {

            }
            column(DivPayable; Amount[19])
            {

            }
            column(DefTaxLiability; Amount[20])
            {

            }
            column(RetBenLiability; Amount[21])
            {

            }
            column(OtherLiabilities; Amount[22])
            {

            }
            column(ExtBorrowing; Amount[23])
            {

            }
            column(ShareCap; Amount[24])
            {

            }
            column(CapitalGr; Amount[25])
            {

            }
            column(StatReserve; Amount[26])
            {

            }
            column(OtherResv; Amount[27])
            {

            }
            column(RevReserv; Amount[28])
            {

            }

            column(PrYear; Amount[29])
            {

            }

            column(CurYear; Amount[30])
            {

            }
            column(CollInvest; Amount[31])
            {

            }

            trigger OnPreDataItem()
            var

            begin
                Setrange(Number, 1, 1)
            end;

            trigger OnAfterGetRecord()
            begin
                SasraSetup.Get();
                Dfilter := '..' + Format(AsAt);
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3', '2310', '2314', '2321');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[1] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5', '2301', '2302', '2303', '2308', '2309');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[2] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5', '2306', '2307', '2311', '2312', '2322');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[31] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Government Securities");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[3] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Sacco Balances");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[4] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5', '2012', '2013', '2014', '2015', '2016');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[5] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4', '2101', '2102', '2103', '2110');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[6] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Provision for loan Losses");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[7] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Tax Recoverable");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[8] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Deferred Tax Assets");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[9] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Retirement Benefit Assets");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[10] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', '1059');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[11] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5|%6', '1079', '1099', '1119', '1139', '1159', '1179');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[12] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Prepaid Lease Rentals");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[13] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Intangible Assets");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[14] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                //2259|2279|2441
                GLAccount.SetFilter("No.", '%1|%2|%3', '2259', '2279', '2441');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[15] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Short Term Deposits");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[16] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Member Deposits");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[17] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup.Taxes);
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[18] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Dividends Payable");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[19] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Deferred Tax Liabilty");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[20] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Retirement Benefits Liabilty");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[21] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                //GLAccount.SetFilter("No.", '%1', SasraSetup."Other Liabilties");
                //3117|3118|3119|3310|3319|3359|3361|3362|3363|3364|3365|3366|3369|3371|3372|3373|3374|3375|3499
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12|%13|%14|%15|%16|%16|%17|%18|%19', '3117', '3118', '3119', '3310', '3319'
                , '3359', '3361', '3362', '3363', '3364', '3365', '3366', '3369', '3371', '3372', '3373', '3374', '3375', '3499');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[22] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."External Borrowings");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[23] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Share Capital");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[24] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Capital Grants");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[25] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Statutory Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[26] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Other Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[27] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Revaluation Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[28] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                //3018|3012
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', '3018', '3012');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[29] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', '9999');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[30] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
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
                    field(AsAt; AsAt)
                    {
                        ApplicationArea = All;
                        Caption = 'As At Date';

                    }
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

    var
        myInt: Integer;
        AsAt: Date;
        Dfilter: Text[100];
        SasraSetup: Record SasraReportsMappingSetup;
        Amount: array[150] of Decimal;
        GLAccount: Record "G/L Account";
}