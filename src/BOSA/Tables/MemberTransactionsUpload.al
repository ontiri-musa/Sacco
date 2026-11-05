table 50013 MemberTransactionsUpload
{
    Caption = 'MemberTransactionsUpload';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
        }
        field(2; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(3; "Doc No"; Code[20])
        {
            Caption = 'Doc No';
            DataClassification = ToBeClassified;
        }
        field(4; Narration; Text[250])
        {
            Caption = 'Narration';
            DataClassification = ToBeClassified;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(7; "Transaction Type"; Code[50])
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
        }
        field(8; "Loan No"; Code[20])
        {
            Caption = 'Loan No';
            DataClassification = ToBeClassified;
        }
        field(9; "New Memb No"; Code[20])
        {
            Caption = 'New Memb No';
            DataClassification = ToBeClassified;
        }
        field(19; CustTrans; Boolean)
        {
            Caption = 'CustTrans';
            DataClassification = ToBeClassified;
        }
        field(11; BankTrans; Boolean)
        {
            Caption = 'BankTrans';
            DataClassification = ToBeClassified;
        }
        field(12; Reversed; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = ToBeClassified;
        }
        field(13; "KAG Transaction Types"; Option)
        {
            OptionCaption = ' ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account,Interest Due,Penalty Charged,Penalty Paid,Ledger Fee Due,Ledger Fee Paid,Boresha A/C,Next GEN Vision A/C';
            OptionMembers = " ","Registration Fee","Share Capital","Interest Paid","Loan Repayment","Deposit Contribution","Insurance Contribution","Benevolent Fund",Loan,"Unallocated Funds",Dividend,"FOSA Account","Interest Due","Penalty Charged","Penalty Paid","Ledger Fee Due","Ledger Fee Paid","Boresha A/C","Next GEN Vision A/C";

        }
        field(14; "Log Posted"; Boolean)
        {
            Caption = 'Log Posted';
            DataClassification = ToBeClassified;
        }
        field(15; Posted; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

}
