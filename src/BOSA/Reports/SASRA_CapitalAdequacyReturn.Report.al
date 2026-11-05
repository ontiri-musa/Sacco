
report 50125 "Capital Adequacy Return"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\BOSA\CapitalAdequacyReturn.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            // DataItemTableView=sorting()
            column(Number; Number)
            { }
            column(ShareCap; Amount[1])
            {

            }
            column(CapGrants; Amount[2])
            {

            }
            column(RetEarnings; Amount[3])
            {

            }
            column(NetSurplus; Amount[4])
            {

            }
            column(StatReserves; Amount[5])
            {

            }
            column(OtherReserves; Amount[6])
            {

            }
            column(InvSubsidiary; Amount[7])
            {

            }
            column(OtherDed; Amount[8])
            {

            }
            column(Cash; Amount[9])
            {

            }
            column(GovSercurities; Amount[10])
            {

            }
            column(DepBalances; Amount[11])
            {

            }
            column(LoanAdv; Amount[12])
            {

            }
            column(Investments; Amount[13])
            {

            }
            column(PropEquip; Amount[14])
            {

            }
            column(OtherAssets; Amount[15])
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
                GLAccount.SetFilter("No.", '%1', SasraSetup."Share Capital");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[1] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Capital Grants");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[2] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Retained Earnings");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[3] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Net Surplus after tax");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[4] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Statutory Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[5] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Other Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[6] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Investments in Subsidiary");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[7] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Other Deductions");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[8] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3', '2310', '2314', '2321');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[9] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Government Securities");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[10] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Other Deposits");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[11] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4', '2101', '2102', '2103', '2110');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[12] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5', '2306', '2307', '2311', '2312', '2322');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[13] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5|%6', '1079', '1099', '1119', '1139', '1159', '1179');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[14] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3', '2441', '2259', '2279');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[15] += GLAccount."Net Change";
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
        Dfilter: text;
        SasraSetup: Record SasraReportsMappingSetup;
        Amount: array[150] of Decimal;
        GLAccount: Record "G/L Account";
}