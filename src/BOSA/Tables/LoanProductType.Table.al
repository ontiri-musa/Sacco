table 50102 "Loan Product Type"
{
    // version TL2.0

    DrillDownPageID = 50213;
    LookupPageID = 50213;

    fields
    {
        field(1; Code; Code[10])
        {
            Editable = true;
        }
        field(2; Description; Text[30])
        {

        }
        field(3; "Interest Rate"; Decimal)
        {
        }
        field(5; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6; "Grace Period"; DateFormula)
        {
        }
        field(7; "Rounding Precision"; Decimal)
        {
            InitValue = 1;
            MaxValue = 1;
            MinValue = 0.01;
        }
        field(8; "Min. Loan Amount"; Decimal)
        {
        }
        field(9; "Max. Loan Amount"; Decimal)
        {
        }
        field(10; Category; Option)
        {
            OptionCaption = 'All,BOSA,FOSA,Micro';
            OptionMembers = All,BOSA,FOSA,Micro;
        }

        field(12; "Interest Paid Posting Group"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Interest Due Posting Group"; Code[20])
        {
            TableRelation = "G/L Account";


        }
        field(15; "Repayment Period"; DateFormula)
        {
        }
        field(16; "Min. Membership period"; DateFormula)
        {
        }
        field(17; "Repayment Method"; Option)
        {
            OptionCaption = 'Straight Line,Reducing Balance,Amortization';
            OptionMembers = "Straight Line","Reducing Balance",Amortization;
        }
        field(18; Status; Option)
        {
            OptionMembers = Active,Blocked;
        }
        field(19; "Recovery Method"; Option)
        {
            OptionCaption = 'On Due Date,On End Month,On Specific Day';
            OptionMembers = "On Due Date","On End Month","On Specific Day";
        }
        field(20; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(21; "E-Loan"; Boolean)
        {
        }
        field(23; "No. of Guarantors"; Integer)
        {
        }

        field(25; "Recovery Day"; integer)
        {
            BlankZero = true;
        }
        field(26; "Apply Special Ratio-Deposits"; Boolean)
        {
        }
        field(27; "Loan Deposit Ratio"; Integer)
        {
        }
        field(29; "Allow Multiple Loans"; Boolean)
        {
        }
        field(30; "Turn Around Time"; DateFormula)
        {
        }
        field(31; "Loan Savings Ratio"; Integer)
        {
        }
        field(32; "Apply Special Repayment Rates"; Boolean)
        {
        }
        field(34; "Based on Savings"; Boolean)
        {
        }

        field(37; "Paybill Short Code"; Code[20])
        {
        }
        field(38; "Based on Deposits"; Boolean)
        {
        }
        field(39; "E-Loan Threshold"; Decimal)
        {
        }
        field(40; "Loan Shares Ratio"; Integer)
        {
        }

        field(41; "Apply Special Recovery Method"; Boolean)
        {
        }

        field(44; "Apply Special Ratio-Savings"; Boolean)
        {
        }
        field(45; "Apply Special Ratio-Shares"; Boolean)
        {
        }
        field(46; "Apply Induplum Rule"; Boolean)
        {
        }
        field(53; "Based on Shares"; Boolean)
        {
        }
        field(54; "Loan Class"; Option)
        {
            OptionCaption = ' ,Farm Produce,Salary Based,Business Based,E-Loan';
            OptionMembers = " ","Farm Produce","Salary Based","Business Based","E-Loan";
        }
        field(55; "Loan Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(56; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }

        // field(57; "Membership Category"; Option)
        // {
        //     OptionCaption = 'All,Individual,Group,Joint,Company';
        //     OptionMembers = "All","Individual","Group","Joint","Company";

        // }
        field(62; "Security Type"; Option)
        {
            OptionCaption = ' ,Both,Guarantors Only,Collaterals Only,Either';
            OptionMembers = " ",Both,"Guarantors Only","Collaterals Only",Either;
        }
        field(63; "Apply Graduation Schedule"; Boolean)
        {
        }
        field(64; "Allow Refinancing"; Boolean)
        {
        }
        field(65; "Refinancing Mode"; Option)
        {
            OptionCaption = 'Same Product,Different Product,Both';
            OptionMembers = "Same Product","Different Product",Both;
        }

        field(67; "Apply 1/3 Rule"; Boolean)
        {
        }
        field(74; "Interest Capitalization Method"; Option)
        {
            OptionCaption = 'On Due Date,On Specific Day';
            OptionMembers = "On Due Date","On Specific Day";
        }
        field(75; "Interest Cap. Day"; Integer)
        {
        }
        field(76; "Boost on Recovery"; Boolean)
        {
        }
        field(77; "Insurance Rate"; Decimal)
        {
        }
        field(78; "Insurance Account"; Code[20])
        {
        }
        field(80; "Apply Special Int. Cap Method"; Boolean)
        {
        }

        field(83; "Penalty Due Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(84; "Penalty Paid Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(85; "Ledger Fee Due Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(86; "Ledger Fee Paid Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }


        field(88; "Charge Penalty on Defaulters"; Boolean)
        {
            trigger OnValidate()
            var
            begin
                Clear("Penalty Due Posting Group");
                Clear("Penalty Paid Posting Group");
            end;
        }
        field(89; "Loan Prepayment Posting Group"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(90; "Graduation Based On"; Option)
        {
            OptionCaption = ' ,Savings,Deposits';
            OptionMembers = " ",Savings,Deposits;
        }
        field(91; "Graduation Factor"; Decimal)
        {

        }
        field(92; "Graduation Qualifying Amount"; Decimal)
        {

        }
        field(93; "Minimum Deposit Amount"; Decimal)
        {

        }
        field(94; "No. of Loans at a Time"; Integer)
        {
        }
        field(96; "IB Repay Period"; Integer)
        {

        }
        field(97; Consolidation; Boolean)
        {
        }
        field(100; ChargeInterestUpfront; Boolean)
        {

        }


    }

    keys
    {
        key(Key1; Code)
        {
        }

    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CreateCustomerPostingGroup(Code);
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalSetup: Record "Global Setup";
        loanproducts: Record "Loan Product Type";
        //MembershipManagement: Codeunit "50000";
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;

        HostMacAddress: Text[100];


    local procedure CreateCustomerPostingGroup(PostingGroupCode: Code[20])
    var
        CustomerPostingGroup: Record "Customer Posting Group";
        GLAccount: Record "G/L Account";
    begin
        IF NOT CustomerPostingGroup.GET(PostingGroupCode) THEN BEGIN
            CustomerPostingGroup.INIT;
            CustomerPostingGroup.Code := PostingGroupCode;
            CustomerPostingGroup."Receivables Account" := PostingGroupCode;
            IF GLAccount.GET(PostingGroupCode) THEN
                CustomerPostingGroup.Description := Description;
            CustomerPostingGroup.INSERT;
        END;
    end;
}

