table 56150 "Loan Notification Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Notification Date"; Date)
        {
        }
        field(3; "Notification Time"; Time)
        {
        }
        field(4; "Loan No."; Code[20])
        {
        }
        field(5; Description; Text[50])
        {
        }
        field(6; "Member No."; Code[20])
        {
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
        field(21; "Provisioning Amount"; Decimal)
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
        field(27; "Principal Overpayment"; Decimal)
        {
        }
        field(28; "Interest Overpayment"; Decimal)
        {
        }
        field(29; "Total Overpayment"; Decimal)
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Class Description"; Text[50])
        {
            Editable = false;
        }
        field(32; "Ledger Fee Arrears"; Decimal)
        {
        }
        field(33; "Penalty Arrears"; Decimal)
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
        field(42; "Notification Sent"; Blob)
        {

        }
        field(43; "Due Date"; Date)
        {

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
    procedure GetSMSTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        SMSText: Text;
        IStream: InStream;
    begin
        CALCFIELDS("Notification Sent");
        IF NOT "Notification Sent".HASVALUE THEN
            EXIT('');
        "Notification Sent".CREATEinSTREAM(IStream);
        IStream.READ(SMSText);
        exit(SMSText);
    end;
}

