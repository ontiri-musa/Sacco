tableextension 50021 CheckLedgerEntryExt extends "Check Ledger Entry"
{
    fields
    {

        field(50000; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";

        }
        field(50001; "KAG Transaction Types"; Option)
        {
            OptionCaption = ' ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account,Interest Due,Penalty Charged,Penalty Paid,Ledger Fee Due,Ledger Fee Paid,Boresha A/C,Next GEN Vision A/C';
            OptionMembers = " ","Registration Fee","Share Capital","Interest Paid","Loan Repayment","Deposit Contribution","Insurance Contribution","Benevolent Fund",Loan,"Unallocated Funds",Dividend,"FOSA Account","Interest Due","Penalty Charged","Penalty Paid","Ledger Fee Due","Ledger Fee Paid","Boresha A/C","Next GEN Vision A/C";

        }
    }

    var
        myInt: Integer;
}