report 50118 "Liquidity Statement Return"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\BOSA\LiquidityStatementReturn.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            // DataItemTableView=sorting()
            column(Number; Number)
            {


            }
            column(LocalNotes; Amount[1])
            {

            }
            column(ForeignNotes; Amount[2])
            {

            }
            column(CommercialBanks; Amount[3])
            {

            }
            column(MLoansAdvances; Amount[4])
            {

            }
            column(SaccoBalances; Amount[5])
            {

            }
            column(OthersBalances; Amount[6])
            {

            }
            column(BalanceDueSacco; Amount[7])
            {

            }
            column(BalanceDueOthers; Amount[8])
            {

            }
            column(TBills; Amount[9])
            {

            }
            column(TBonds; Amount[10])
            {

            }
            column(MemberBal; Amount[11])
            {

            }
            column(OtherDep; Amount[13])
            {

            }


            column(BalancesDueBank; Amount[12])
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
                GLAccount.SetFilter("No.", '%1', SasraSetup."Foreign Notes & Coins");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[2] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5', '2301', '2302', '2303', '2308', '2309');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[3] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', '');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[4] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Sacco Balances");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[5] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3|%4|%5', '2306', '2311', '2312', '2322', '2307');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[6] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Balances Due Saccos");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[7] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Balances Due Others");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[8] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Treasury Bills");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[9] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Treasury Bonds");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[10] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Member Deposits");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[11] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3', '3117', '3118', '3119');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[13] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Balances Due Banks");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[12] += GLAccount."Net Change";
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
        Dfilter: Text;
        SasraSetup: Record SasraReportsMappingSetup;
        Amount: array[150] of Decimal;
        GLAccount: Record "G/L Account";
}