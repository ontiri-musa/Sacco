table 50152 "Loan Defaulter Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(4; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application";
        }
        field(5; Description; Text[50])
        {
        }
        field(6; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(7; "Member Name"; Text[50])
        {
        }
        field(8; "Approved Amount"; Decimal)
        {
        }
        field(9; "Repayment Method"; Option)
        {
            OptionCaption = 'Straight Line,Reducing Balance,Amortization';
            OptionMembers = "Straight Line","Reducing Balance",Amortization;
        }
        field(10; "Repayment Period"; DateFormula)
        {
        }
        field(11; "Remaining Period"; Decimal)
        {
        }
        field(12; "Remaining Principal Amount"; Decimal)
        {
        }
        field(13; "Remaining Interest Amount"; Decimal)
        {
        }
        field(14; "Principal Installment"; Decimal)
        {
        }
        field(15; "Interest Installment"; Decimal)
        {
        }
        field(16; "Total Installment"; Decimal)
        {
        }
        field(17; "Principal Arrears"; Decimal)
        {
        }
        field(18; "Interest Arrears"; Decimal)
        {
        }
        field(19; "Total Arrears"; Decimal)
        {
        }
        field(20; "Outstanding Balance"; Decimal)
        {
        }
        field(22; "Classification Code"; Code[20])
        {
        }
        field(23; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(24; "No. of Days in Arrears"; Integer)
        {
        }
        field(25; "Last Payment Date"; Date)
        {
        }
        field(26; "No. of Defaulted Installment"; Integer)
        {
        }
        field(31; "Class Description"; Text[50])
        {
        }
        field(32; "Ledger Fee Arrears"; Decimal)
        {
        }
        field(33; "Penalty Arrears"; Decimal)
        {
        }
        field(35; "Notice Category"; Option)
        {
            OptionCaption = ' ,First Notice,Second Notice,Third Notice';
            OptionMembers = " ","First Notice","Second Notice","Third Notice";
        }
        field(36; "Notice Date"; Date)
        {

        }
        field(37; "Notice Due Date"; Date)
        {

        }
        field(38; "Loan Start Date"; Date)
        {

        }
        field(39; "Expected Completion Date"; Date)
        {

        }
        field(40; "Church District Code"; Code[150])
        {
            TableRelation = "Church District";
        }
        field(41; "Church Section Code"; Code[150])
        {
            TableRelation = "Church Section" where("Church District Code" = field("Church District Code"));
        }
        field(42; "Phone No"; Code[40])
        { }
        field(43; "Deposit Balance"; Decimal)
        { }
        field(48; "Recovery Officer"; code[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Loan Application"."Debt Recovery Officer ID" where("No." = field("Loan No.")));
        }
        field(55; "Place Loan Under Debt Collection"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Loan Application"."Place Loan Under Debt Collection" where("No." = field("Loan No.")));

        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

