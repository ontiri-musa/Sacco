
report 50121 "Return On Investment"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\BOSA\ReturnOnInvestment.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            // DataItemTableView=sorting()
            column(Number; Number)
            {


            }
            column(CoreCap; Amount[1])
            {

            }
            column(TotalAssets; Amount[2])
            {

            }
            column(TotalDeposits; Amount[3] + Amount[7])
            {

            }
            column(NonEarnAssets; Amount[4])
            {

            }
            column(FinancialInv; Amount[5])
            {

            }
            column(LandBuilding; Amount[6])
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

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3', '3018', '3011', '3015');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[1] += Abs(GLAccount."Net Change");
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', '3016');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[1] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Total Assets");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[2] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Total Deposits");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[3] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;
                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1|%2|%3', '3117', '3118', '3119');
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[7] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Non-Earning Assets");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[4] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Financial Investments");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[5] += GLAccount."Net Change";
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Land & Buildings");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields("Net Change");
                        Amount[6] += GLAccount."Net Change";
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