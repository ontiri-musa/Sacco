report 50008 "Bank Recon Posted"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\Finance\Bank Recon PostedNm.rdl';
    Caption = 'Posted Bank Account Reconciliation Report';

    dataset
    {
        dataitem("Bank Account Statement"; "Bank Account Statement")
        {
            RequestFilterFields = "Statement No.";
            column(BankAccountNo_BankAccountStatement; "Bank Account Statement"."Bank Account No.")
            {
            }
            column(StatementNo_BankAccountStatement; "Bank Account Statement"."Statement No.")
            {
            }
            column(StatementEndingBalance_BankAccountStatement; "Bank Account Statement"."Statement Ending Balance")
            {
            }
            column(StatementDate_BankAccountStatement; "Bank Account Statement"."Statement Date")
            {
            }
            column(BalanceLastStatement_BankAccountStatement; "Bank Account Statement"."Balance Last Statement")
            {
            }
            column(CashBookBalance_BankAccountStatement; "Bank Account Statement"."Cash Book Balance")
            {
            }
            column(BankCode; BankCode)
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(BankName; BankName)
            {
            }
            column(BankAccountBalanceasperCashBook; BankAccountBalanceasperCashBook)
            {
            }
            column(UnpresentedChequesTotal; UnpresentedChequesTotal)
            {
            }
            column(ReconCashBBal; ReconCashBBal)
            { }
            column(UncreditedBanking; UncreditedBanking)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            dataitem("Bank Account Statement Line"; "Bank Account Statement Line")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                DataItemTableView = WHERE("Statement Amount" = FILTER(< 0), "Applied Entries" = filter(0));
                column(BankAccountNo_BankAccountStatementLine; "Bank Account Statement Line"."Bank Account No.")
                {
                }
                column(StatementLineNo_BankAccountStatementLine; "Bank Account Statement Line"."Statement Line No.")
                {
                }
                column(StatementNo_BankAccountStatementLine; "Bank Account Statement Line"."Statement No.")
                {
                }
                column(StatementAmount_BankAccountStatementLine; "Bank Account Statement Line"."Statement Amount")
                {
                }
                column(Description_BankAccountStatementLine; "Bank Account Statement Line".Description)
                {
                }
                column(TransactionDate_BankAccountStatementLine; "Bank Account Statement Line"."Transaction Date")
                {
                }
                column(DocumentNo_BankAccountStatementLine; "Bank Account Statement Line"."Document No.")
                {
                }
                //column(Debit_BankAccountStatementLine;"Bank Account Statement Line".Debit)
                // {
                //}
                column(TDate; "Bank Account Statement Line"."Transaction Date")
                {
                }
                column(VendName; VendName)
                {
                }
                //column(Credit_BankAccountStatementLine;"Bank Account Statement Line".Credit)
                //{
                //}
                column(Check_no; "Bank Account Statement Line"."Check No.")
                {
                }
                //column(OpenType_BankAccountStatementLine;"Bank Account Statement Line"."Open Type")
                // {
                // }

                trigger OnAfterGetRecord();
                begin
                    PV.RESET;
                    PV.SETRANGE(PV."No.", "Bank Account Statement Line"."Document No.");
                    if PV.FIND('-') then begin
                        VendName := PV."Payee Name";
                    end;
                end;
            }
            dataitem("<Bank Account Statement Line1>"; "Bank Account Statement Line")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                DataItemTableView = WHERE("Statement Amount" = FILTER(> 0), "Applied Entries" = filter(0));
                column(BankAccountNo_BankAccountStatementLine1; "<Bank Account Statement Line1>"."Bank Account No.")
                {
                }
                column(StatementLineNo_BankAccountStatementLine1; "<Bank Account Statement Line1>"."Statement Line No.")
                {
                }
                column(StatementNo_BankAccountStatementLine1; "<Bank Account Statement Line1>"."Statement No.")
                {
                }
                column(StatementAmount_BankAccountStatementLine1; "<Bank Account Statement Line1>"."Statement Amount")
                {
                }
                column(Description_BankAccountStatementLine1; "<Bank Account Statement Line1>".Description)
                {
                }
                column(TransactionDate_BankAccountStatementLine1; "<Bank Account Statement Line1>"."Transaction Date")
                {
                }
                column(DocumentNo_BankAccountStatementLine1; "<Bank Account Statement Line1>"."Document No.")
                {
                }
                /*column(Debit_BankAccountStatementLine1;"<Bank Account Statement Line1>".Debit)
                {
                }
                column(OpenType_BankAccountStatementLine1;"<Bank Account Statement Line1>"."Open Type")
                {
                }*/
                column(Check2; "<Bank Account Statement Line1>"."Check No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PV.RESET;
                    PV.SETRANGE(PV."No.", "Bank Account Statement Line"."Document No.");
                    if PV.FIND('-') then begin
                        VendName := PV."Payee Name";
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            var
                BankL: Record "Bank Account Ledger Entry";
                Dfilter: Text;
            begin
                BankCode := '';
                BankAccountNo := '';
                BankName := '';
                BankAccountBalanceasperCashBook := 0;
                UnpresentedChequesTotal := 0;
                UncreditedBanking := 0;
                ReconCashBBal := 0;

                Bank.RESET;
                Bank.SETRANGE(Bank."No.", "Bank Account No.");
                if Bank.FIND('-') then begin
                    BankCode := Bank."No.";
                    BankAccountNo := Bank."Bank Account No.";
                    BankName := Bank.Name;
                    "Bank Account Statement"."Cash Book Balance" := 0;
                    "Bank Account Statement".Modify();
                    Dfilter := '..' + Format("Bank Account Statement"."Statement Date");

                    if "Bank Account Statement"."Cash Book Balance" = 0 then begin
                        BankL.Reset();
                        BankL.SetRange(BankL."Bank Account No.", "Bank Account No.");
                        BankL.SetFilter("Posting Date", Dfilter);
                        If BankL.FindSet() then begin
                            BankL.CalcSums(Amount);
                            "Bank Account Statement"."Cash Book Balance" := BankL.Amount;
                            "Bank Account Statement".Modify();
                        end;
                        "Bank Account Statement".CalcFields("Total Reconciled", "Total Unreconciled");
                        If "Bank Account Statement"."Cash Book Balance" <> ("Bank Account Statement"."Balance Last Statement" + "Bank Account Statement"."Total Reconciled" + "Bank Account Statement"."Total Unreconciled") then begin
                            "Bank Account Statement"."Cash Book Balance" := ("Bank Account Statement"."Balance Last Statement" + "Bank Account Statement"."Total Reconciled" + "Bank Account Statement"."Total Unreconciled");
                            "Bank Account Statement".Modify();
                        end;
                    end;

                    BankAccountBalanceasperCashBook := "Bank Account Statement"."Cash Book Balance";

                    BankL.Reset();
                    BankL.SetRange(BankL."Bank Account No.", "Bank Account No.");
                    BankL.SetFilter("Posting Date", Dfilter);
                    If BankL.FindSet() then begin
                        BankL.CalcSums(Amount);
                        // ReconCashBBal := BankL.Amount;
                    end;

                    //ReconCashBBal := "Bank Account Statement"."Balance Last Statement";

                    //Message('ReconCashBBal %1', ReconCashBBal);

                    BankStatementLine.RESET;
                    BankStatementLine.SETRANGE(BankStatementLine."Bank Account No.", Bank."No.");
                    BankStatementLine.SETRANGE(BankStatementLine."Statement No.", "Statement No.");
                    BankStatementLine.SETRANGE(BankStatementLine."Applied Entries", 0);
                    if BankStatementLine.FIND('-') then begin
                        repeat
                            if BankStatementLine."Statement Amount" < 0 then begin
                                UnpresentedChequesTotal := UnpresentedChequesTotal + BankStatementLine."Statement Amount";
                            end else begin
                                if BankStatementLine."Statement Amount" > 0 then begin
                                    UncreditedBanking := UncreditedBanking + BankStatementLine."Statement Amount";
                                end;
                            end;
                        /*
                                                    BankL.Reset();
                                                    BankL.SetRange(BankL."Bank Account No.", BankStatementLine."Bank Account No.");
                                                    BankL.SetRange("Document No.", BankStatementLine."Document No.");
                                                    BankL.SetRange(Description, BankStatementLine.Description);
                                                    BankL.SetRange(Amount, BankStatementLine."Statement Amount");
                                                    BankL.SetRange("Posting Date", BankStatementLine."Transaction Date");
                                                    BankL.SetRange(Reversed, true);
                                                    BankL.SetRange(Open, true);
                                                    If BankL.FindFirst() then begin
                                                        //Message('Document No =%1 Description =%2 Amount =%3 ReconBal =%4', BankL."Document No.", BankL.Description, BankL.Amount, ReconCashBBal);
                                                        ReconCashBBal := ReconCashBBal + BankL.Amount;
                                                    end;
                                                    BankL.Reset();
                                                    BankL.SetRange(BankL."Bank Account No.", BankStatementLine."Bank Account No.");
                                                    BankL.SetRange("Document No.", BankStatementLine."Document No.");
                                                    //BankL.SetRange(Amount, BankStatementLine."Statement Amount", BankStatementLine."Statement Amount" * -1);
                                                    BankL.SetRange("Posting Date", BankStatementLine."Transaction Date");
                                                    BankL.SetRange(Reversed, false);
                                                    BankL.SetRange(Open, true);
                                                    If BankL.FindSet() then begin
                                                        BankL.CalcSums(Amount);
                                                        Message('Document No =%1 Description =%2 Amount =%3 ReconBal =%4', BankL."Document No.", BankL.Description, BankL.Amount, ReconCashBBal);
                                                        if BankL.Amount = 0 then
                                                            ReconCashBBal := ReconCashBBal + BankStatementLine."Statement Amount";
                                                    end;*/
                        until BankStatementLine.NEXT = 0;
                    end;
                    UnpresentedChequesTotal := UnpresentedChequesTotal * -1;

                    //BankStatementLine
                    ReconCashBBal := "Bank Account Statement"."Statement Ending Balance";
                end;
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
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

    var
        Bank: Record "Bank Account";
        BankCode: Code[20];
        BankAccountNo: Code[20];
        BankName: Text;
        BankAccountBalanceasperCashBook: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        BankStatementLine: Record "Bank Account Statement Line";
        CompanyInfo: Record "Company Information";
        PV: Record "Payment Header";
        Vendor: Record Vendor;
        VendName: Text[100];
        ReconCashBBal: Decimal;

}
