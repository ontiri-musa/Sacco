tableextension 50004 BankAccReconExt extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(50000; "Total Unreconciled"; Decimal)
        {
            Caption = 'Total Unreconciled';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Applied Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), Reconciled = FILTER(false)));
        }
        field(50001; "Total Reconciled"; Decimal)
        {
            Caption = 'Total Reconciled';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Applied Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), Reconciled = FILTER(true)));
        }
        field(50002; "Difference Btw Statements"; Decimal)
        {
            Caption = 'Difference Btwn Statements';

        }
        field(50003; "Cash Book Balance"; Decimal)
        {
            Caption = 'Cash Book Balance';

        }
        field(50004; "Reconciliation Difference"; Decimal)
        {
            Caption = 'Reconciliation Difference';

        }

        modify("Statement Ending Balance")
        {
            trigger OnAfterValidate()
            begin
                "Difference Btw Statements" := "Statement Ending Balance" - "Balance Last Statement";
                Rec.CalcFields(Rec."Total Reconciled");
                Rec."Reconciliation Difference" := Rec."Difference Btw Statements" - Rec."Total Reconciled";
            end;
        }
        modify("Balance Last Statement")
        {
            trigger OnAfterValidate()
            begin
                if "Statement Ending Balance" <> 0 then begin
                    "Difference Btw Statements" := "Statement Ending Balance" - "Balance Last Statement";
                    Rec.CalcFields(Rec."Total Reconciled");
                    Rec."Reconciliation Difference" := Rec."Difference Btw Statements" - Rec."Total Reconciled";
                end;
            end;
        }
        modify("Statement Date")
        {
            trigger OnAfterValidate()
            var
                Dfilter: Text;
                BankLentry: Record "Bank Account Ledger Entry";
            begin
                Dfilter := '..' + Format("Statement Date");
                BankLentry.Reset();
                BankLentry.SetRange(BankLentry."Bank Account No.", "Bank Account No.");
                BankLentry.SetFilter(BankLentry."Posting Date", Dfilter);
                if BankLentry.FindSet() then begin
                    BankLentry.CalcSums(Amount);
                    "Cash Book Balance" := BankLentry.Amount;
                end;
            end;
        }
    }
}
