report 50019 "Loan Totals"
{
    ApplicationArea = All;
    Caption = 'Loan Totals';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            DataItemTableView = where(Posted = filter(true));
            column(No; "No.")
            {
            }
            trigger OnPreDataItem()
            begin
                PrincBal := 0;
                UnknownBalDebit := 0;
                UnknownBalCredit := 0;
            end;

            trigger OnAfterGetRecord()
            var
                DCustL: Record "Detailed Cust. Ledg. Entry";
                TType: Record "Transaction Type Code Setup";
            begin
                TType.Get();

                DCustL.Reset();
                DCustL.SetRange("Customer No.", LoanApplication."No.");
                DCustL.SetFilter("Posting Date", '..%1', 20221231D);
                if DCustL.FindSet() then begin
                    repeat
                        if (DCustL."Transaction Type Code" = TType."New Loan") or (DCustL."Transaction Type Code" = TType."Principal Paid") then begin
                            PrincBal += DCustL.Amount;
                        end;
                        if DCustL."Transaction Type Code" = '' then begin
                            UnknownBalDebit += DCustL."Debit Amount";
                            UnknownBalCredit += DCustL."Credit Amount";
                        end;
                    until DCustL.Next = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Total Princ Loan %1 Unknown Debit  %2 Unknown Credit %3', PrincBal, UnknownBalDebit, UnknownBalCredit);
            end;
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

    var
        PrincBal: Decimal;
        UnknownBalDebit: Decimal;
        UnknownBalCredit: Decimal;
}
