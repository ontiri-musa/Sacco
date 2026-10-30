tableextension 50003 BankAccStatmntExt extends "Bank Account Statement"
{
    fields
    {
        modify("Statement Date")
        {
            trigger OnAfterValidate()
            var
                Dfilter: Text;
                BankL: Record "Bank Account Ledger Entry";
            begin
                if "Statement Date" <> 0D then begin
                    Dfilter := '..' + Format("Statement Date");
                    BankL.Reset();
                    BankL.SetRange(BankL."Bank Account No.", "Bank Account No.");
                    BankL.SetFilter(BankL."Posting Date", Dfilter);
                    if BankL.FindSet() then begin
                        BankL.CalcSums(Amount);
                        "Cash Book Balance" := BankL.Amount;
                    end;
                end;
            end;
        }
        field(50001; "Cash Book Balance"; Decimal)
        {
            Caption = 'Cash Book Balance';
        }
        field(50002; "Total Unreconciled"; Decimal)
        {
            Caption = 'Total Unreconciled';
            FieldClass = FlowField;
            Editable = false;
            //CalcFormula = Sum("Bank Acc. Reconciliation Line"."Applied Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), Reconciled = FILTER(false)));
            CalcFormula = Sum("Bank Account Statement Line"."Applied Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), "Applied Entries" = filter(0), "Statement No." = field("Statement No.")));
        }
        field(50003; "Total Reconciled"; Decimal)
        {
            Caption = 'Total Reconciled';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula = Sum("Bank Acc. Reconciliation Line"."Applied Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), Reconciled = FILTER(true)));
            CalcFormula = Sum("Bank Account Statement Line"."Applied Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), "Applied Entries" = filter(<> 0), "Statement No." = field("Statement No.")));
        }
    }
}
