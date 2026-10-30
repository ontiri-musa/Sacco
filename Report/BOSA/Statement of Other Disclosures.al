report 51125 "Statemnt of Other Disclosures"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\BOSA\Statement of Other Disclosures.rdl';
    Caption = 'Statement of Other Disclosures Return';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Integer"; "Integer")
        {
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(ShareCap; Amount[9])
            {
            }
            column(StatutoryRes; Amount[5])
            {
            }
            column(ProLoanLoss; Amount[10])
            {
            }

            column(REarning; Amount[3])
            {
            }
            column(OtherRes; Amount[6])
            {
            }
            column(Investment; Amount[7])
            {
            }
            column(Property_Equipment; GlBalance[7])
            {
            }
            column(Net_Suplus; Amount[4])
            {
            }
            column(BankBalances; BankBal)
            {
            }
            column(NonPeforming; NonPeforming)
            {
            }
            column(InsiderLoans; InsiderLoans[1])
            {
            }
            column(InsiderLoans2; InsiderLoans[2])
            {
            }
            column(LGuarAmount; LGuarAmount)
            {
            }

            trigger OnAfterGetRecord();
            begin
                SasraSetup.Get();
                Dfilter := '..' + Format(AsAt);

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Share Capital");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[1] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Capital Grants");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[2] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Retained Earnings");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[3] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Net Surplus after tax");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[4] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Statutory Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[5] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Other Reserves");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[6] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Investments in Subsidiary");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[7] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset();
                GLAccount.SetFilter("No.", '%1', SasraSetup."Other Deductions");
                GLAccount.SetFilter("Date Filter", Dfilter);
                if GLAccount.FindSet() then begin
                    repeat
                        GLAccount.CalcFields(Balance);
                        Amount[8] += GLAccount.Balance;
                    until GLAccount.Next = 0;
                end;


                Amount[9] := (Amount[1] + Amount[2] + Amount[3] + Amount[4] + Amount[5] + Amount[6]) - (Amount[7] + Amount[8]);

                LCEntries.RESET;
                LCEntries.SETFILTER(LCEntries."Classification Code", '<>%1', 'PERFORMING');
                LCEntries.SETFILTER(LCEntries."Classification Date", '<=%1', AsAt);
                if LCEntries.FINDSET then begin
                    repeat
                        NonPeforming += LCEntries."Outstanding Balance";
                    until LCEntries.NEXT = 0;
                end;


                Loan.RESET;
                Loan.SETRANGE(Loan.Posted, true);
                Loan.SetFilter(Loan."Member Category", '%1|%2', Loan."Sub Category"::"Board Member", Loan."Sub Category"::Staff);
                //Loan.SETFILTER()
                if Loan.FINDSET then begin
                    repeat
                        Loan.CALCFIELDS(Loan."Outstanding Balance");
                        if Loan."Outstanding Balance" > 0 then begin
                            if Loan."Sub Category" = Loan."Sub Category"::"Board Member" then
                                InsiderLoans[1] += Loan."Outstanding Balance";
                            if Loan."Sub Category" = Loan."Sub Category"::Staff then
                                InsiderLoans[2] += Loan."Outstanding Balance";

                            LGuar.RESET;
                            LGuar.SETRANGE(LGuar."Loan No.", Loan."No.");
                            if LGuar.FINDSET then begin
                                repeat
                                    LGuarAmount += LGuar."Amount To Guarantee";
                                until LGuar.NEXT = 0;
                            end;

                        end;
                    until Loan.NEXT = 0;
                end;

                //MESSAGE('Share Cap %1',GlBalance[1]);
            end;

            trigger OnPreDataItem();
            begin
                Integer.SETRANGE(Number, -999999999);
                if AsAt = 0D then AsAt := TODAY;
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
    }

    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        GlBalance: array[50] of Decimal;
        GL: Record "G/L Account";
        GL2: Record "G/L Account";
        Bank: Record "Bank Account";
        BankBal: Decimal;
        LCEntries: Record "Loan Classification Entry";
        Loan: Record "Loan Application";
        NonPeforming: Decimal;
        InsiderLoans: array[10] of Decimal;
        LGuar: Record "Loan Guarantor";
        LGuarAmount: Decimal;
        AsAt: Date;
        Dfilter: Text[100];
        SasraSetup: Record SasraReportsMappingSetup;
        Amount: array[150] of Decimal;
        GLAccount: Record "G/L Account";
}

