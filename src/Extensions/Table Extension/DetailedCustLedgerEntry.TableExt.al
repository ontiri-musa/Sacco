tableextension 50017 DetailedCustLedgerEntryExt extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";

        }
        field(50001; "Principal Transaction"; Boolean)
        {
            Editable = false;
        }

        field(50002; "GL Transaction Found"; Boolean)
        {
            Editable = false;
        }
        field(50003; "GL Account"; code[30])
        {
            Editable = false;
        }
        field(50005; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(50008; "Posting Description"; Text[300])
        {
            Editable = false;
        }
        field(50009; "Posting Transaction No."; Integer)
        {
            Caption = 'Posting Transaction No.';
            Editable = false;
        }
        field(50011; "Posting Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Posting Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(50012; "Posting Loan No."; Code[20])
        {
        }
        field(50013; "Posting Reversal"; Boolean)
        {
        }
        field(50014; "Posting Amount"; Decimal)
        {
        }
        field(50015; "Detailed Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ',Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment)';
            OptionMembers = ,"Initial Entry",Application,"Unrealized Loss","Unrealized Gain","Realized Loss","Realized Gain","Payment Discount","Payment Discount (VAT Excl.)","Payment Discount (VAT Adjustment)","Appln. Rounding","Correction of Remaining Amount","Payment Tolerance","Payment Discount Tolerance","Payment Tolerance (VAT Excl.)","Payment Tolerance (VAT Adjustment)","Payment Discount Tolerance (VAT Excl.)","Payment Discount Tolerance (VAT Adjustment)";
        }
    }

    var
        myInt: Integer;
}