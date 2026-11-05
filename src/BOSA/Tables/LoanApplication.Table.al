table 50101 "Loan Application"
{
    // version TL2.0

    DataCaptionFields = "No.", Description;//, "Member No.", "Member Name";
    DrillDownPageID = 50102;
    LookupPageID = 50102;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = false;
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = IF ("Member Category" = FILTER(Employee)) Employee
            ELSE
            IF ("Member Category" = FILTER(Member)) Member;

            trigger OnValidate()
            begin
                LoanApplication.Reset();
                LoanApplication.SetRange(Posted, false);
                LoanApplication.SetRange(Reversed, false);
                LoanApplication.SetRange("Member No.", Rec."Member No.");
                LoanApplication.SetFilter("Loan Product Type", '<>%1', 'MB');
                if LoanApplication.FindSet() then begin
                    repeat
                        If LoanApplication.Status <> LoanApplication.Status::Rejected then
                            Error('Member has a pending application no %1 product %2 status %3', LoanApplication."No.", LoanApplication."Loan Product Type", LoanApplication.Status);
                    until LoanApplication.Next = 0;
                end;

                IF "Member Category" = "Member Category"::Member THEN BEGIN
                    Member.GET("Member No.");
                    Member.TestField("Global Dimension 1 Code");
                    //if Member.Status <> Member.Status::Active then
                    //Error(NotActiveErr, "Member Category", "Member No.");
                    "Member Name" := Member."Full Name";
                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                    "Church Code" := Member."Church Code";
                    "Church District Code" := Member."Church District Code";
                    "Church Section Code" := Member."Church Section Code";
                    "Sub Category" := Member."Sub Category";
                END;
                IF "Member Category" = "Member Category"::Employee THEN BEGIN
                    Employee.GET("Member No.");
                    Member.GET("Member No.");
                    Employee.TestField("Global Dimension 1 Code");
                    if Employee.Status <> Employee.Status::Active then
                        Error(NotActiveErr, "Member Category", "Member No.");
                    "Member Name" := Employee.FullName;
                    "Church Code" := Member."Church Code";
                    "Church District Code" := Member."Church District Code";
                    "Church Section Code" := Member."Church Section Code";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                END;
                if HasExistingLoan then
                    "Borrower Type" := "Borrower Type"::"Subsequent Borrower"
                else
                    "Borrower Type" := "Borrower Type"::"First-Time Borrower";

                //InsertMemberAsOwnGuarantor("Member No.");

                Clear("Disbursal Account No.");
                Clear("Disbursal Account Name");
                Clear("Top-up");
                Clear("Requested Amount");

            end;

        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type";

            trigger OnValidate()
            begin
                ValidateLoanProduct;

            end;
        }
        field(5; Description; Text[50])
        {
            Editable = false;
        }
        field(6; "Interest Rate"; Decimal)
        {
            Editable = false;
        }
        field(7; "Repayment Period"; DateFormula)
        {
            trigger OnValidate()
            var
            begin
                "Date of Completion" := CalcDate("Repayment Period", "Created Date");
            end;

        }
        field(8; "Repayment Method"; Option)
        {
            Editable = false;
            OptionCaption = 'Straight Line,Reducing Balance,Amortization';
            OptionMembers = "Straight Line","Reducing Balance",Amortization;
        }
        field(10; "Requested Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateRequestedAmount;
            end;
        }
        field(11; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Approved Amount" > "Requested Amount" THEN
                    ERROR(Error005, FIELDCAPTION("Approved Amount"), FIELDCAPTION("Requested Amount"));

                IF Status = Status::"Pending Approval" THEN BEGIN
                    "Appraised By" := USERID;
                    "Appraisal Date" := TODAY;
                    "Appraisal Time" := TIME;

                    GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
                    "Appraised By Host IP" := HostIP;
                    "Appraised By Host MAC" := HostMac;
                    "Appraised By Host Name" := HostName;
                END;

            end;
        }
        field(12; "Total Savings Amount"; Decimal)
        {
            Editable = false;
        }
        field(13; "Total Deposits Amount"; Decimal)
        {
            Editable = false;
        }
        field(14; "Total Shares Amount"; Decimal)
        {
            Editable = false;
        }
        field(15; "Max. Eligible Amount-Deposit"; Decimal)
        {
            Editable = false;
        }
        field(16; "No. Series"; Code[20])
        {

        }
        field(17; "Top-up"; Boolean)
        {
            trigger OnValidate()
            begin
                IF "Top-up" THEN
                    GetLoansToRefinance
                ELSE
                    ClearRefinancingEntry;
            end;
        }
        field(18; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(19; "Date of Completion"; Date)
        {
            Editable = false;
        }
        field(20; "Next Due Date"; Date)
        {
            Editable = false;
        }
        field(21; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(22; "Created Date"; Date)
        {
            Editable = false;
        }
        field(23; "Created Time"; Time)
        {
            Editable = false;
        }
        field(24; "Appraised By"; Code[30])
        {
            Editable = false;
        }
        field(25; "Appraisal Date"; Date)
        {
            Editable = false;
        }
        field(26; "Appraisal Time"; Time)
        {
            Editable = false;
        }
        field(27; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(28; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(29; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(30; Posted; Boolean)
        {
            Editable = false;
        }
        field(31; "Total Guaranteed Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Loan Guarantor"."Amount To Guarantee" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            trigger OnValidate()
            var
            begin
            end;

        }
        field(32; "Total Collateral Amount"; Decimal)
        {
            CalcFormula = Sum("Loan Collateral"."Guaranteed Amount" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; Remarks; Text[50])
        {
        }
        field(34; "No. of Guarantors"; Integer)
        {
            CalcFormula = Count("Loan Guarantor" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "No. of Collaterals"; Integer)
        {
            CalcFormula = Count("Loan Collateral" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "No. of Loans Refinanced"; Integer)
        {
            CalcFormula = Count("Loan Refinancing Entry" WHERE("Loan No." = FIELD("No."),
                                                                Select = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Total Refinanced Amount"; Decimal)
        {
            CalcFormula = Sum("Loan Refinancing Entry"."Outstanding Balance" WHERE("Loan No." = FIELD("No."),
                                                                                    Select = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39; "Repayment Frequency"; Option)
        {
            Editable = false;
            OptionCaption = 'Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(40; "Disbursed By"; Code[30])
        {

        }
        field(41; "Disbursal Date"; Date)
        {
            trigger OnValidate()
            begin
                "Next Due Date" := CalcDate('1M', "Disbursal Date");
                "Date of Completion" := CalcDate("Repayment Period", "Disbursal Date");
            end;

        }
        field(42; "Disbursal Time"; Time)
        {
            Editable = true;
        }
        field(43; "Disbursal Account No."; Code[20])
        {
            TableRelation = IF ("Mode of Disbursement" = FILTER("FOSA Account")) Vendor
            ELSE
            IF ("Mode of Disbursement" = FILTER("Mobile Banking")) "Mobile Banking Member"
            else
            IF ("Mode of Disbursement" = FILTER("Bank Account")) "Bank Account";


            trigger OnValidate()
            begin
                if "Mode of Disbursement" = "Mode of Disbursement"::"FOSA Account" then begin
                    IF Vendor.GET("Disbursal Account No.") THEN
                        "Disbursal Account Name" := Vendor.Name;
                end;
                if "Mode of Disbursement" = "Mode of Disbursement"::"Mobile Banking" then begin
                    IF MobileBankingMember.GET("Disbursal Account No.") THEN
                        "Disbursal Account Name" := MobileBankingMember."Member Name";
                end;
                if "Mode of Disbursement" = "Mode of Disbursement"::"Bank Account" then begin
                    IF BankAccount.GET("Disbursal Account No.") THEN
                        "Disbursal Account Name" := BankAccount.Name;
                end;
            end;
        }
        field(44; "Disbursal Account Name"; Text[50])
        {
            Editable = false;
        }

        field(46; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(47; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(48; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(49; "Appraised By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(50; "Appraised By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(51; "Appraised By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(52; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(53; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(54; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(55; "Disbursed By Host Name"; Code[30])
        {

        }
        field(56; "Disbursed By Host IP"; Code[30])
        {

        }
        field(57; "Disbursed By Host MAC"; Code[30])
        {

        }
        field(58; "Basic Salary"; Decimal)
        {

        }
        field(59; "Total Deduction Amount"; Decimal)
        {

        }
        field(60; "Net Amount"; Decimal)
        {

        }
        field(61; "Company Name"; Text[50])
        {

        }
        field(62; "No. of KG"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Payout Amount" := "No. of KG" * "Rate per KG"
            end;
        }
        field(63; "Rate per KG"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Payout Amount" := "No. of KG" * "Rate per KG"
            end;
        }
        field(64; "View Payout History"; Boolean)
        {

        }
        field(65; "Payroll No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(66; "Member Category"; Option)
        {
            OptionCaption = 'Member,Employee';
            OptionMembers = Member,Employee;
        }
        field(67; "Total Payout Amount"; Decimal)
        {
            Editable = false;
        }
        field(68; Cleared; Boolean)
        {

        }
        field(69; "Outstanding Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = field("Date Filter"), "Entry Type" = filter("Initial Entry")));
            Editable = false;
        }

        field(71; "Institution Name"; Text[50])
        {

        }
        field(72; "Institution Branch Name"; Text[50])
        {

        }
        field(74; "Loan Prepayment"; Decimal)
        {

        }
        field(75; "Principal Arrears"; Decimal)
        {

        }
        field(76; "Interest Arrears"; Decimal)
        {

        }
        field(77; "Total Arrears"; Decimal)
        {

        }
        field(78; "Principal Overpayment"; Decimal)
        {

        }
        field(79; "Interest Overpayment"; Decimal)
        {

        }
        field(80; "Total Overpayment"; Decimal)
        {

        }
        field(81; "Mode of Disbursement"; Option)
        {
            OptionCaption = 'G/L,FOSA Account,Mobile Banking,Bank Account,RTGS';
            OptionMembers = "G/L","FOSA Account","Mobile Banking","Bank Account",RTGS;
            trigger OnValidate()
            var
                MobileBankingMember: Record "Mobile Banking Member";
            begin
                "Disbursal Account No." := '';
                "Disbursal Account Name" := '';
                TestField("Member No.");
                TestField("Loan Product Type");
                if "Mode of Disbursement" = "Mode of Disbursement"::"Mobile Banking" then begin
                    MobileBankingMember.Reset();
                    MobileBankingMember.SetRange("Member No.", "Member No.");
                    if MobileBankingMember.FindFirst() then begin
                        if MobileBankingMember.Status = MobileBankingMember.Status::Active then
                            "Disbursal Account No." := MobileBankingMember."Phone No."
                        else
                            Error(Error013);
                    end else
                        Error(Error014);
                end;


            end;
        }

        field(83; "Total Outstanding Loans"; Decimal)
        {
            Editable = false;
        }

        field(91; "External Document No."; code[20])
        {

        }
        field(92; "Economic Sector"; code[20])
        {
            TableRelation = "Economic Sector";
        }
        field(93; "Economic Sector Category"; code[20])
        {
            TableRelation = "Economic Sector Category" where("Economic Sector" = field("Economic Sector"));
        }
        field(94; "Economic Sector Sub-Category"; code[20])
        {
            TableRelation = "Economic Sector Sub-Category" where("Economic Sector" = field("Economic Sector"), "Economic Sector Category" = field("Economic Sector Category"));
        }
        field(96; "Bank Code"; Code[20])
        {
            TableRelation = Bank;
            trigger OnValidate()
            var
                Bank: Record Bank;
            begin
                Bank.Get("Bank Code");
                "Bank Name" := Bank.Name;
            end;
        }
        field(97; "Bank Name"; Text[50])
        {
            Editable = false;
        }
        field(98; "Bank Branch Code"; Code[30])
        {
            TableRelation = "Bank Branch" where("Bank Code" = field("Bank Code"));
            trigger OnValidate()
            var
                BankBranch: Record "Bank Branch";
            begin
                BankBranch.Get("Bank Branch Code");
                "Bank Branch Name" := BankBranch.Name;
            end;
        }
        field(99; "Bank Branch Name"; Code[30])
        {
            Editable = false;
        }
        field(100; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(101; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Apply Special Repayment Rates"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                InterestRate: Decimal;
                RepaymentPeriod: DateFormula;
            begin
                TestField("Loan Product Type");
                LoanProductType.Get("Loan Product Type");
                if "Apply Special Repayment Rates" then begin
                    TestField("Requested Amount");
                    LoanProductType.TestField("Apply Special Repayment Rates");

                    GetSpecialRepaymentRates(InterestRate, RepaymentPeriod);
                    "Interest Rate" := InterestRate;
                    "Repayment Period" := RepaymentPeriod;
                end else begin
                    "Interest Rate" := LoanProductType."Interest Rate";
                    "Repayment Period" := LoanProductType."Repayment Period";
                end;
            end;
        }
        field(103; "Max. Eligible Amount-Savings"; Decimal)
        {
            Editable = false;
        }
        field(104; "Max. Eligible Amount-Shares"; Decimal)
        {
            Editable = false;
        }
        field(105; "Borrower Type"; Option)
        {
            Editable = false;
            OptionMembers = "First-Time Borrower","Subsequent Borrower";
        }
        field(106; "Loan Deposits Ratio"; Integer)
        {
            Editable = false;
        }
        field(107; "Loan Savings Ratio"; Integer)
        {
            Editable = false;
        }
        field(108; "Loan Shares Ratio"; Integer)
        {
            Editable = false;
        }
        field(109; "Repayment Adjustment Amount"; Decimal)
        { }
        field(110; "Repayment Adjustment"; Boolean)
        { }
        field(111; "Church District Code"; Code[150])
        {
            TableRelation = "Church District";
        }
        field(112; "Church Section Code"; Code[150])
        {
            TableRelation = "Church Section" where("Church District Code" = field("Church District Code"));
        }
        field(113; "Church Code"; Code[150])
        {
            TableRelation = Church;
        }
        field(114; "Sub Category"; Option)
        {
            OptionCaption = ' ,Staff,Board Member,Pastor';
            OptionMembers = " ",Staff,"Board Member",Pastor;
        }
        field(115; "Loan Rescheduled"; Boolean)
        {

        }
        field(116; "Loan Restructured"; Boolean)
        {

        }
        field(117; "Penalty Arrears"; Decimal)
        {

        }
        field(118; "Ledger Fee Arrears"; Decimal)
        {

        }
        field(119; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(120; "Classification"; Code[50])
        {

        }
        field(121; "Days In Arrears"; Integer)
        {

        }
        field(122; "Installment In Arrears"; Integer)
        {

        }
        field(123; "Pause Loan Interest"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Int Paused By");
                Clear("Int Paused Date");
                Clear("Int Paused Time");
                Clear("Int Paused By Host IP");
                Clear("Int Paused By Host MAC");
                Clear("Int Paused By Host Name");
                If "Pause Loan Interest" = true then begin
                    GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
                    "Int Paused By" := USERID;
                    "Int Paused Date" := TODAY;
                    "Int Paused Time" := TIME;
                    "Int Paused By Host IP" := HostIP;
                    "Int Paused By Host MAC" := HostMac;
                    "Int Paused By Host Name" := HostName;
                end;
            end;
        }
        field(124; "Pause Loan Penalty"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Pen Paused By");
                Clear("Pen Paused Date");
                Clear("Pen Paused Time");
                Clear("Pen Paused By Host IP");
                Clear("Pen Paused By Host MAC");
                Clear("Pen Paused By Host Name");
                If "Pause Loan Penalty" = true then begin
                    GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
                    "Pen Paused By" := USERID;
                    "Pen Paused Date" := TODAY;
                    "Pen Paused Time" := TIME;
                    "Pen Paused By Host IP" := HostIP;
                    "Pen Paused By Host MAC" := HostMac;
                    "Pen Paused By Host Name" := HostName;
                end;
            end;
        }
        field(125; "Int Paused By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(126; "Int Paused By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(127; "Int Paused By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(128; "Int Paused By"; Code[30])
        {
            Editable = false;
        }
        field(129; "Int Paused Date"; Date)
        {
            Editable = false;
        }
        field(130; "Int Paused Time"; Time)
        {
            Editable = false;
        }
        field(131; "Pen Paused By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(132; "Pen Paused By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(133; "Pen Paused By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(134; "Pen Paused By"; Code[30])
        {
            Editable = false;
        }
        field(135; "Pen Paused Date"; Date)
        {
            Editable = false;
        }
        field(136; "Pen Paused Time"; Time)
        {
            Editable = false;
        }
        field(137; "Guarantors Notified"; Boolean)
        {
            Editable = false;
        }
        field(138; "Portal Loan"; Boolean)
        {

        }
        field(139; Consolidation; Boolean)
        {
        }
        field(140; "Total Consolidated Amount"; Decimal)
        {
            CalcFormula = Sum("Loan Consolidation Entry"."Outstanding Balance" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(141; "No. of Loans Consolidated"; Integer)
        {
            CalcFormula = Count("Loan Consolidation Entry" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(142; "Outstanding Principal"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = field("Date Filter"), "Entry Type" = filter("Initial Entry"), "Transaction Type Code" = filter('NEWLOAN|PPAID|" "')));
            Editable = false;
        }
        field(143; "Outstanding Interest"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = field("Date Filter"), "Entry Type" = filter("Initial Entry"), "Transaction Type Code" = filter('INTDUE|INTPAID')));
            Editable = false;
        }
        field(144; "Outstanding Penalty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = field("Date Filter"), "Entry Type" = filter("Initial Entry"), "Transaction Type Code" = filter('PENDUE|PENPAID')));
            Editable = false;
        }
        field(145; "Outstanding Ledger Fee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = field("Date Filter"), "Entry Type" = filter("Initial Entry"), "Transaction Type Code" = filter('LFEEDUE|LFEE')));
            Editable = false;
        }
        field(146; "Prepayment"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = field("Date Filter"), "Entry Type" = filter("Initial Entry"), "Transaction Type Code" = filter('PREPAY')));
            Editable = false;
        }
        field(147; "Penalty Overpayment"; Decimal)
        {

        }
        field(148; "Ledger Fee Overpayment"; Decimal)
        {

        }
        field(158; "Expected Int"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."), "Transaction Type Code" = filter('INTDUE')));

        }
        field(168; "Actual Int"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."), "Transaction Type Code" = filter('INTPAID')));

        }
        field(178; "Expected Pen"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."), "Transaction Type Code" = filter('PENDUE')));

        }
        field(188; "Actual Pen"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."), "Transaction Type Code" = filter('PENPAID')));
        }
        field(189; "Debt Recovery Officer ID"; Code[100])
        {
            //   TableRelation = "Loan Recovery Officer Setup";
            TableRelation = "Loan  Officer Setup";

            trigger OnValidate()
            var
                LROSetup: Record "Loan  Officer Setup";
            begin
                If LROSetup.Get("Debt Recovery Officer ID") then begin
                    "Debt Recovery Officer Name" := LROSetup."Full Name";
                end;
            end;
        }
        field(190; "Debt Recovery Officer Name"; Text[150])
        {
            Editable = false;
        }
        field(191; "Place Loan Under Debt Collection"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Loan Under Debt Collection By");
                Clear("Loan Under Debt Collection Date");
                Clear("Loan Under Debt Collection Time");
                Clear("Loan Under Debt Collection By Host IP");
                Clear("Loan Under Debt Collection By Host MAC");
                Clear("Loan Under Debt Collection By Host Name");
                Clear("Debt Recovery Officer ID");
                Clear("Debt Recovery Officer Name");
                If "Place Loan Under Debt Collection" = true then begin
                    GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
                    "Loan Under Debt Collection By" := USERID;
                    "Loan Under Debt Collection Date" := TODAY;
                    "Loan Under Debt Collection Time" := TIME;
                    "Loan Under Debt Collection By Host IP" := HostIP;
                    "Loan Under Debt Collection By Host MAC" := HostMac;
                    "Loan Under Debt Collection By Host Name" := HostName;
                end;
            end;
        }
        field(192; "Loan Under Debt Collection By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(193; "Loan Under Debt Collection By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(194; "Loan Under Debt Collection By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(195; "Loan Under Debt Collection By"; Code[30])
        {
            Editable = false;
        }
        field(196; "Loan Under Debt Collection Date"; Date)
        {
            Editable = false;
        }
        field(197; "Loan Under Debt Collection Time"; Time)
        {
            Editable = false;
        }
        field(200; "Guarantorship Mode"; Option)
        {
            OptionCaption = ' ,Deposits,Guarantors';
            OptionMembers = " ",Deposits,Guarantors;
            trigger OnValidate()
            var
                loanGuar: Record "Loan Guarantor";
                lineNo: Integer;
            begin
                if Rec."Guarantorship Mode" = Rec."Guarantorship Mode"::Deposits then begin
                    lineNo := fnGetLastLineNo() + 1;

                    loanGuar.Init();
                    loanGuar."Line No." := lineNo;
                    loanGuar."Loan No." := Rec."No.";
                    loanGuar."Member No." := Rec."Member No.";
                    loanGuar.Validate("Member No.");
                    loanGuar."Account No." := rec."Member No." + '02';
                    loanGuar.Validate("Account No.");
                    loanGuar."Amount To Guarantee" := fnGetDepBal(rec."Member No." + '02');
                    loanGuar.Insert();
                end;

            end;




        }
        field(205; "Insurance Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                validateInsurranceCharges();
            end;

        }
        field(210; "Interest Charged On IPF"; Decimal)
        {
            Editable = false;

        }
        field(215; "Processing Fee On IPF"; Decimal)
        {
            Editable = false;

        }
        field(220; "Insurrance On IPF"; Decimal)
        {
            Editable = false;

        }
        field(225; "Monthly installments"; Decimal)
        {
            Editable = false;
        }
        field(226; "Mobile Loan Transaction Charges"; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {

        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Outstanding Balance", "Date of Completion")
        {

        }
        //Dr "Outstanding Balance", "Date of Completion";
    }

    trigger OnDelete()
    begin
        TestField(Status, Status::New);
        DeleteRelatedLinks;
    end;

    trigger OnInsert()
    begin
        LoanApplicationSetup.GET;
        LoanApplicationSetup.TestField("Loan Application Nos.");
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(LoanApplicationSetup."Loan Application Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);

        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        //"Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
    end;

    procedure fnGetDepBal(acctNo: Code[35]) depBal: Decimal
    var
        accounts: Record Vendor;
    begin
        accounts.Reset();
        accounts.SetRange("No.", acctNo);
        if accounts.FindFirst() then begin
            accounts.CalcFields(Balance);
            depBal := accounts.Balance;
        end;
        exit(depBal);

    end;

    procedure validateInsurranceCharges()
    var
        loanProductType: Record "Loan Product Type";
        LoanCharge: Record "Loan Product Charge";
        StartDate: Date;
        Installments: Decimal;
        BosaM: Codeunit "BOSA Management";
    begin

        if loanProductType.Get("Loan Product Type") then begin

            if loanProductType.code = 'IPF' then begin
                "Interest Charged On IPF" := Round(((loanProductType."Interest Rate" / 100) * "Insurance Cost"), 1, '=');
                //processing fee on IPF
                LoanCharge.Reset();
                LoanCharge.SetRange("Loan Product Type", Rec."Loan Product Type");
                if LoanCharge.FindSet() then begin
                    //  Message('%1', LoanCharge."Loan Product Type");
                    repeat

                        if LoanCharge.code = 'PROCESSSINGFEE' then
                            "Processing Fee On IPF" := Round(((loanCharge.Value / 100) * ("Interest Charged On IPF" + "Insurance Cost")), 1, '=');
                    until LoanCharge.Next() = 0;
                end;
                //insurrance On IPF
                "Insurrance On IPF" := Round(((0.0045 * ("Interest Charged On IPF" + "Insurance Cost"))), 1, '=');

                "Requested Amount" := Round(("Interest Charged On IPF" + "Insurance Cost" + "Processing Fee On IPF" + "Insurrance On IPF"), 1, '=');
                "Approved Amount" := Round("Requested Amount", 1, '=');


            end;
        end;
    end;

    local procedure GetSpecialRepaymentRates(var InterestRate: Decimal; var RepaymentPeriod: DateFormula)
    var
        LPSpecialRepaymentRate: Record "LP Special Repayment Rate";
    begin
        LPSpecialRepaymentRate.Reset();
        LPSpecialRepaymentRate.SetRange("Loan Product Type", "Loan Product Type");
        if LPSpecialRepaymentRate.FindSet() then begin
            repeat
                LPSpecialRepaymentRate.TestField("Minimum Amount");
                LPSpecialRepaymentRate.TestField("Maximum Amount");
                LPSpecialRepaymentRate.TestField("Interest Rate");
                LPSpecialRepaymentRate.TestField("Repayment Period");

                if (("Requested Amount" >= LPSpecialRepaymentRate."Minimum Amount") and ("Requested Amount" <= LPSpecialRepaymentRate."Maximum Amount")) then begin
                    InterestRate := LPSpecialRepaymentRate."Interest Rate";
                    RepaymentPeriod := LPSpecialRepaymentRate."Repayment Period";
                end;
            until LPSpecialRepaymentRate.Next() = 0;
        end;

    end;

    procedure fnGetLastLineNo() lastLineNo: Integer
    var
        loanGuar: Record "Loan Guarantor";
    begin
        loanGuar.Reset();
        if loanGuar.FindLast() then
            lastLineNo := loanguar."Line No.";
        exit(lastLineNo);


    end;

    local procedure CalculateAccountsBalance(var TotalDeposits: Decimal; var TotalSavings: Decimal; var TotalShares: Decimal)
    var
    begin
        TotalDeposits := 0;
        TotalSavings := 0;
        TotalShares := 0;

        AccountType.RESET;
        AccountType.SETFILTER(Type, '%1|%2|%3', AccountType.Type::Savings, AccountType.Type::"Share Capital", AccountType.Type::"Member Deposit");
        IF AccountType.FINDSET THEN BEGIN
            REPEAT
                Vendor.RESET;
                Vendor.SETRANGE("Member No.", "Member No.");
                Vendor.SetRange("Account Type", AccountType.Code);
                IF Vendor.FINDSET THEN BEGIN
                    REPEAT
                        IF AccountType.Type = AccountType.Type::"Member Deposit" THEN
                            TotalDeposits += GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, Vendor."No.");
                        IF AccountType.Type = AccountType.Type::Savings THEN
                            TotalSavings += GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, Vendor."No.");
                        IF AccountType.Type = AccountType.Type::"Share Capital" THEN
                            TotalShares += GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, Vendor."No.");

                    UNTIL Vendor.NEXT = 0;
                END;
            UNTIL AccountType.NEXT = 0;
        END;
    end;

    local procedure InsertMemberAsOwnGuarantor(var MemberNo: Code[20])
    var
        Vend: Record Vendor;
        AccType: Record "Account Type";
        AmountGuar: Decimal;
        LGuar: Record "Loan Guarantor";
        Cust: Record Customer;
    begin
        AmountGuar := 0;

        LGuar.Reset();
        LGuar.SetRange(LGuar."Member No.", MemberNo);
        if LGuar.FindSet() then begin
            repeat
                if Cust.Get(LGuar."Loan No.") then begin
                    Cust.CalcFields(Balance);
                    if Cust.Balance > 0 then begin
                        AmountGuar += LGuar."Amount To Guarantee";
                    end;
                end;
            until LGuar.Next = 0;
        end;

        AccType.Reset();
        AccType.SetRange(AccType.Type, AccType.Type::"Member Deposit");
        if AccType.FindFirst() then begin
            Vend.Reset();
            Vend.SetRange(Vend."Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                Vend.CalcFields(Balance);
                LGuar.Init;
                LGuar."Member No." := Vend."Member No.";
                LGuar."Line No." := 10000;
                LGuar."Member Name" := Vend."Member Name";
                LGuar."Account No." := Vend."No.";
                LGuar."Account Name" := Vend.Name;
                if (Vend.Balance - AmountGuar) > 0 then
                    LGuar."Amount To Guarantee" := (Vend.Balance - AmountGuar);
                LGuar.Insert;
            end;
        end;
    end;

    local procedure CalculateMaxEligibleAmount()
    var

    begin
        TestField("Member No.");
        TestField("Loan Product Type");
    end;

    local procedure GetDSSRatio(LoanProductType: Record "Loan Product Type"; var LoanDepositsRatio: Decimal; var LoanSavingsRatio: Decimal; var LoanSharesRatio: Decimal)
    var
        LPSpecialDSSRatio: Record "LP Special DSS Ratio";
    begin
        with LoanProductType do begin
            if "Based on Deposits" then begin
                if "Apply Special Ratio-Deposits" then begin
                    LPSpecialDSSRatio.Reset();
                    LPSpecialDSSRatio.SetRange("Account Type", LPSpecialDSSRatio."Account Type"::Deposits);
                    if "Borrower Type" = "Borrower Type"::"First-Time Borrower" then
                        LPSpecialDSSRatio.SetRange("Applies to Borrower Type", LPSpecialDSSRatio."Applies to Borrower Type"::"First-Time Borrower")
                    else
                        LPSpecialDSSRatio.SetRange("Applies to Borrower Type", LPSpecialDSSRatio."Applies to Borrower Type"::"Subsequent Borrower");
                    if LPSpecialDSSRatio.FindFirst() then
                        LoanDepositsRatio := LPSpecialDSSRatio.Ratio;
                end else begin
                    LoanDepositsRatio := "Loan Deposit Ratio";
                end;
            end;
            if "Based on Savings" then begin
                if "Apply Special Ratio-Deposits" then begin
                    LPSpecialDSSRatio.Reset();
                    LPSpecialDSSRatio.SetRange("Account Type", LPSpecialDSSRatio."Account Type"::Savings);
                    if "Borrower Type" = "Borrower Type"::"First-Time Borrower" then
                        LPSpecialDSSRatio.SetRange("Applies to Borrower Type", LPSpecialDSSRatio."Applies to Borrower Type"::"First-Time Borrower")
                    else
                        LPSpecialDSSRatio.SetRange("Applies to Borrower Type", LPSpecialDSSRatio."Applies to Borrower Type"::"Subsequent Borrower");
                    if LPSpecialDSSRatio.FindFirst() then
                        LoanSavingsRatio := LPSpecialDSSRatio.Ratio;
                end else begin
                    LoanSavingsRatio := "Loan Deposit Ratio";
                end;

            end;
            if "Based on Shares" then begin
                if "Apply Special Ratio-Deposits" then begin
                    LPSpecialDSSRatio.Reset();
                    LPSpecialDSSRatio.SetRange("Account Type", LPSpecialDSSRatio."Account Type"::Shares);
                    if "Borrower Type" = "Borrower Type"::"First-Time Borrower" then
                        LPSpecialDSSRatio.SetRange("Applies to Borrower Type", LPSpecialDSSRatio."Applies to Borrower Type"::"First-Time Borrower")
                    else
                        LPSpecialDSSRatio.SetRange("Applies to Borrower Type", LPSpecialDSSRatio."Applies to Borrower Type"::"Subsequent Borrower");
                    if LPSpecialDSSRatio.FindFirst() then
                        LoanSharesRatio := LPSpecialDSSRatio.Ratio;
                end else begin
                    LoanSharesRatio := "Loan Deposit Ratio";
                end;
            end;
        end;

    end;

    procedure GetLoansToRefinance()
    var
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
        LineNo: Integer;
        InsertRec: Boolean;
    begin
        LoanRefinancingEntry.Reset();
        LoanRefinancingEntry.SetRange("Loan No.", "No.");
        LoanRefinancingEntry.DeleteAll();

        LoanProductType.Get("Loan Product Type");

        Customer.reset;
        Customer.SetRange("Customer Type", Customer."Customer Type"::Loan);
        Customer.SetRange("Member No.", "Member No.");
        if LoanProductType."Refinancing Mode" = LoanProductType."Refinancing Mode"::"Same Product" then
            Customer.SetRange("Loan Product Type", "Loan Product Type");
        if LoanProductType."Refinancing Mode" = LoanProductType."Refinancing Mode"::"Different Product" then
            Customer.SetFilter("Loan Product Type", '<>%1', "Loan Product Type");
        if LoanProductType."Refinancing Mode" = LoanProductType."Refinancing Mode"::Both then;
        IF Customer.FindSet() THEN BEGIN
            repeat
                Customer.CALCFIELDS("Balance (LCY)");
                IF Customer."Balance (LCY)" > 0 THEN BEGIN
                    LoanRefinancingEntry.INIT;
                    LoanRefinancingEntry."Loan No." := "No.";
                    LoanRefinancingEntry."Line No." := GetLastRefinancingEntryLineNo() + 10000;
                    LoanRefinancingEntry."Loan To Refinance" := Customer."No.";
                    LoanRefinancingEntry.Description := Customer.Name;
                    LoanRefinancingEntry."Outstanding Balance" := ABS(Customer."Balance (LCY)");
                    LoanRefinancingEntry.INSERT;
                END;
            until Customer.Next() = 0;
        END;

        LoanRefinancingEntry.RESET;
        LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
        IF LoanRefinancingEntry.Count > 0 THEN
            PAGE.RUN(0, LoanRefinancingEntry);
    end;

    local procedure GetLastRefinancingEntryLineNo(): Integer
    var
        LoanRefinancingEntry2: Record "Loan Refinancing Entry";
    begin
        LoanRefinancingEntry2.Reset();
        LoanRefinancingEntry2.SetRange("Loan No.", "No.");
        if LoanRefinancingEntry2.FindLast() then
            exit(LoanRefinancingEntry2."Line No.")
        else
            exit(0);
    end;

    local procedure ValidateLoanProduct()
    var
        LoanDepositsRatio: Decimal;
        LoanSavingsRatio: Decimal;
        LoanSharesRatio: Decimal;
        TotalDeposits: Decimal;
        TotalSavings: Decimal;
        TotalShares: Decimal;
        LoanRescheduling: Record "Loan Rescheduling";
    begin
        TESTFIELD("Member No.");

        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF LoanProductType.Status <> LoanProductType.Status::Active THEN
                ERROR(Error006, "Loan Product Type");
            LoanProductType.TestField(Description);
            LoanProductType.TestField("Min. Loan Amount");
            LoanProductType.TestField("Max. Loan Amount");
            if not LoanProductType.Consolidation then
                LoanProductType.TestField("Interest Rate");
            LoanProductType.TestField("Repayment Period");
            if not LoanProductType.Consolidation then
                LoanProductType.TestField("Grace Period");
            LoanProductType.TestField("Loan Posting Group");
            LoanProductType.TestField("Interest Due Posting Group");
            LoanProductType.TestField("Interest Paid Posting Group");
            if not LoanProductType.Consolidation then
                LoanProductType.TestField("Rounding Precision");
            // LoanProductType.TestField("Turn Around Time");

            Description := LoanProductType.Description;
            "Repayment Method" := LoanProductType."Repayment Method";
            "Repayment Period" := LoanProductType."Repayment Period";
            "Repayment Frequency" := LoanProductType."Repayment Frequency";
            "Interest Rate" := LoanProductType."Interest Rate";
            Consolidation := LoanProductType.Consolidation;
            "Date of Completion" := CALCDATE("Repayment Period", "Created Date");

            IF FORMAT(LoanProductType."Grace Period") <> '' THEN BEGIN
                "Next Due Date" := CALCDATE(LoanProductType."Grace Period", "Created Date");
            END ELSE BEGIN
                Evaluate(DateFormula, BosaManagement.GetRepaymentFrequencyDateFormula(Rec));
                "Next Due Date" := CALCDATE(DateFormula, "Created Date");
            END;

            IF LoanProductType."Apply Graduation Schedule" THEN BEGIN

            END;
            CalculateAccountsBalance(TotalDeposits, TotalSavings, TotalShares);
            "Total Deposits Amount" := TotalDeposits;
            "Total Savings Amount" := TotalSavings;
            "Total Shares Amount" := TotalShares;

            GetDSSRatio(LoanProductType, LoanDepositsRatio, LoanSavingsRatio, LoanSharesRatio);
            "Loan Deposits Ratio" := LoanDepositsRatio;
            "Loan Savings Ratio" := LoanSavingsRatio;
            "Loan Shares Ratio" := LoanSharesRatio;

            "Max. Eligible Amount-Deposit" := TotalDeposits * LoanDepositsRatio;
            "Max. Eligible Amount-Savings" := TotalSavings * LoanSavingsRatio;
            "Max. Eligible Amount-Shares" := TotalShares * LoanSharesRatio;
            "Total Outstanding Loans" := BOSAManagement.CalculateOtherLoanBalances("Member No.");

            IF GetNoofExistingSimilarLoan() > 0 then begin
                LoanRescheduling.Reset();
                LoanRescheduling.SetRange(LoanRescheduling."Member No.", "Member No.");
                LoanRescheduling.SetRange(LoanRescheduling.Description, Description);
                LoanRescheduling.SetRange(LoanRescheduling.Status, LoanRescheduling.Status::Approved);
                if not LoanRescheduling.FindFirst() then begin
                    if not LoanProductType."Allow Multiple Loans" then
                        Error(Error009, "Member No.");
                end;
            end;
            If LoanProductType.Consolidation = false then begin
                if GetNoofAllExistingLoan() > 1 then begin
                    "Top-up" := true;
                    Validate("Top-up");
                end else
                    "Top-up" := false;
            end;
        END;
    end;

    procedure GetGuarantors(): Boolean
    var
        LoanGuarantor: Record "Loan Guarantor";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", "No.");
        EXIT(LoanGuarantor.FINDFIRST);
    end;

    procedure GetSecurities(): Boolean
    var
        LoanCollateral: Record "Loan Collateral";
    begin
        LoanCollateral.RESET;
        LoanCollateral.SETRANGE("Loan No.", "No.");
        EXIT(LoanCollateral.FINDFIRST);
    end;

    local procedure DeleteRelatedLinks()
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanCollateral: Record "Loan Collateral";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", "No.");
        LoanGuarantor.DELETEALL;

        LoanCollateral.RESET;
        LoanCollateral.SETRANGE("Loan No.", "No.");
        LoanCollateral.DELETEALL;

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", "No.");
        LoanRepaymentSchedule.DELETEALL;
    end;

    procedure CheckMinimumGuarantors(): Integer
    begin
        IF LoanProductType.GET("Loan Product Type") THEN
            EXIT(LoanProductType."No. of Guarantors");
    end;

    procedure GetTotalSecurityAmount(): Decimal
    begin
        CALCFIELDS("Total Guaranteed Amount", "Total Collateral Amount");
        EXIT("Total Guaranteed Amount" + "Total Collateral Amount")
    end;

    local procedure GetNoofExistingSimilarLoan(): Integer
    var
        NoofLoans: Integer;
    begin
        NoofLoans := 0;
        Customer.RESET;
        Customer.SETRANGE("Member No.", Rec."Member No.");
        Customer.SetRange("Loan Product Type", Rec."Loan Product Type");
        if Customer.FindSet() then begin
            repeat
                Customer.CalcFields("Balance (LCY)");
                if Customer."Balance (LCY)" > 0 then
                    NoofLoans += 1;
            until Customer.Next() = 0;
        end;
        EXIT(Customer.COUNT);
    end;

    local procedure GetNoofAllExistingLoan(): Integer
    var
        NoofLoans: Integer;
    begin
        NoofLoans := 0;
        Customer.RESET;
        Customer.SETRANGE("Member No.", "Member No.");
        if Customer.FindSet() then begin
            repeat
                Customer.CalcFields("Balance (LCY)");
                if Customer."Balance (LCY)" > 0 then
                    NoofLoans += 1;
            until Customer.Next() = 0;
        end;
        EXIT(Customer.COUNT);
    end;

    local procedure HasExistingLoan(): Boolean
    begin
        Customer.RESET;
        Customer.SETRANGE("Member No.", "Member No.");
        EXIT(Customer.FindFirst());
    end;

    local procedure ValidateRequestedAmount()
    begin
        TESTFIELD("Member No.");
        TESTFIELD("Loan Product Type");
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF NOT (LoanProductType."Apply Special Repayment Rates") THEN BEGIN
                IF "Requested Amount" < LoanProductType."Min. Loan Amount" THEN
                    ERROR(Error003, FIELDCAPTION("Requested Amount"));

                IF "Requested Amount" > LoanProductType."Max. Loan Amount" THEN
                    ERROR(Error004, FIELDCAPTION("Requested Amount"));
            END;
            IF LoanProductType."Apply Special Repayment Rates" THEN BEGIN
                LoanProductSpecialRepaymentRate.RESET;
                LoanProductSpecialRepaymentRate.SETRANGE("Loan Product Type", LoanProductType.Code);
                IF LoanProductSpecialRepaymentRate.FINDSET THEN BEGIN
                    REPEAT
                        IF ("Requested Amount" >= LoanProductSpecialRepaymentRate."Minimum Amount") AND ("Requested Amount" <= LoanProductSpecialRepaymentRate."Maximum Amount") THEN BEGIN
                            "Interest Rate" := LoanProductSpecialRepaymentRate."Interest Rate";
                            "Repayment Period" := LoanProductSpecialRepaymentRate."Repayment Period";
                        END;
                    UNTIL LoanProductSpecialRepaymentRate.NEXT = 0;
                END;
            END;

        END;
    end;

    local procedure ClearRefinancingEntry()
    var
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
    begin
        LoanRefinancingEntry.RESET;
        LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
        LoanRefinancingEntry.DELETEALL;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LoanProductType: Record "Loan Product Type";
        Member: Record Member;
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
        LoanApplication: Record "Loan Application";
        Error000: Label 'Member %1 does not have enough Savings';
        Error001: Label 'Member %1 does not have enough Deposits';
        Error002: Label 'Member %1 does not have enough Shares';
        Error003: Label '%1 cannot be be less than the Minimum Amount set for this Loan product';
        Error004: Label '%1 cannot exceed the Maximum Amount set for this Loan product';
        DateFormula: DateFormula;
        Error005: Label '%1 cannot exceed %2';
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        Customer: Record Customer;
        MobileBankingMember: Record "Mobile Banking Member";
        BankAccount: Record "Bank Account";
        Error006: Label 'Loan Product %1 is not Active';
        Error007: Label 'Member %1 has violated 1/3 rule';
        Employee: Record Employee;
        Error008: Label 'Member %1 does not qualify for this Loan product';
        LoanProductSpecialRepaymentRate: Record "LP Special Repayment Rate";
        Error009: Label 'Member %1 has similar loan of this Loan product';
        MembershipDate: Date;
        Error010: Label 'Member %1 has not attained the Minimum Membership period';
        Error011: Label 'Member %1 does not have sufficient Payouts';
        Error012: Label 'You must attach supporting documents';
        Error013: Label 'Member is not Active on Mobile Banking';
        Error014: Label 'Member is not registered on Mobile Banking';
        NotActiveErr: Label '%1 %2 is not Active';
        BosaManagement: Codeunit "BOSA Management";
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        UserSetup: Record "User Setup";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        //   Installments: Integer;
        StartDate: Date;

}

