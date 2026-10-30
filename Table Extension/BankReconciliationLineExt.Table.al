tableextension 50175 BankReconciliationLineExt extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Debit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50001; "Credit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50002; "External Doc No"; Code[250])
        {
            Caption = 'External Doc No';

        }
        field(50003; Reconciled; Boolean)
        {
            Caption = 'Reconciled';

        }
        field(50004; "Ledger Entry No"; Integer)
        {
            Caption = 'Ledger Entry No';
        }
    }

    var
        myInt: Integer;
}