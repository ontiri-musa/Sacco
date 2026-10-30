table 50011 "Account Opening"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
            Editable = false;
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";// where("Open Automatically" = filter(false));

            trigger OnValidate()
            begin
                Clear("Member No.");
                Clear("Member Name");
                Clear("Global Dimension 1 Code");
                Clear("Source FOSA Account");
                Clear("Maturity FOSA Account");
                Clear("Fixed Deposit Amount");
                Clear("Fixed Period");
                Clear("Source FOSA Account");

                AccountType.RESET;
                AccountType.GET("Account Type");
                /*  if AccountType.Type = AccountType.Type::Loan then
                     Error(LoanAccNotAllowedErr, "Account Type"); */
                Description := AccountType.Description;


                if ((AccountType.Type = AccountType.Type::"Fixed Deposit") or (AccountType.Type = AccountType.Type::"Call Deposit")) then begin
                    "Interest Rate" := AccountType."Interest Rate";
                end;
            end;
        }
        field(3; Description; Text[50])
        {
            Editable = false;
        }
        field(4; "Member No."; Code[30])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                TestField("Account Type");
                AccountType.Get("Account Type");
                if HasSimilarAccount("Member No.") then begin
                    if not AccountType."Allow Multiple Accounts" then
                        Error(HasSimilarAccountErr, Description);
                end;
                Member.RESET;
                Member.SETRANGE("No.", "Member No.");
                IF Member.FINDFIRST THEN BEGIN
                    if Member.Status <> Member.Status::Active then
                        Error(MemberNotActiveErr);
                    "Member Name" := Member."Full Name";
                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                END;
                CLEAR(RecRef);
                CLEAR(XRecRef);
                RecRef.GETTABLE(Rec);
                XRecRef.GETTABLE(xRec);
                //CBSManagement.CreateLogEntry(RecRef, XRecRef, 4, Rec.FIELDNAME("Member No."));
            end;
        }
        field(5; "Member Name"; Text[40])
        {
            Editable = false;
        }
        field(6; "Account No."; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                // CreateAccountMember("No.", "Member No.", "Account No.");
            end;
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(8; "Created By"; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                CLEAR(RecRef);
                CLEAR(XRecRef);
                RecRef.GETTABLE(Rec);
                XRecRef.GETTABLE(xRec);

            end;
        }
        field(9; "Created Date"; Date)
        {
            Editable = false;
        }
        field(10; "Created Time"; Time)
        {
            Editable = false;
        }
        field(11; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(12; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(13; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(14; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(15; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(16; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(17; "Approved By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(18; "Created By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(19; "Created By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(20; "Last Modified By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(21; "Last Modified By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(22; "Last Modified By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(23; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(24; "Approved By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(25; "Approved By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            Editable = false;
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));


        }
        field(27; "Child's Name"; Text[50])
        {
        }
        field(28; "Child's Gender"; Option)
        {
            OptionMembers = ,Male,Female;
        }
        field(29; "Child,s Date of Birth"; Date)
        {
        }
        field(30; "Child's Birth Cert No."; Code[50])
        {
        }
        field(31; "Relationship with Child"; Option)
        {
            OptionMembers = ,Parent,Guardian,Other;
        }

        field(36; "Source FOSA Account"; Code[50])
        {

            TableRelation = Vendor where("Member No." = field("Member No."));
            trigger OnValidate()
            var

            begin
                TestField("Account Type");
                Vendor.Get("Source FOSA Account");
                AccountType.Get(Vendor."Account Type");
                if AccountType.Type <> AccountType.Type::Savings then
                    Error(NotSavingsAccErr, FieldCaption("Source FOSA Account"));
                "Source Acccount Name" := AccountType.Description;
                "Source Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, "Source FOSA Account");
            end;

        }
        field(37; "Source Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(38; "Source Acccount Name"; Text[50])
        {
            Editable = false;
        }
        field(40; "Fixed Deposit Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Source FOSA Account");
                if "Fixed Deposit Amount" > "Source Account Balance" then
                    Error(InsuffBalanceErr, FieldCaption("Fixed Deposit Amount"), FieldCaption("Source Account Balance"));
                "Start Date" := Today;
            end;
        }
        field(41; "Total Interest To Earn"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Fixed/Call Deposit Schedule"."Interest To Earn" where("Account Opening No." = field("No."), Posted = filter(false)));
        }
        field(42; "Total Amount To Earn"; Decimal)
        {
            Editable = false;

        }
        field(43; "Fixed Period"; DateFormula)
        {

            trigger OnValidate()
            begin
                //TestField("Start Date");
                "Maturity Date" := CalcDate("Fixed Period", "Start Date");
            end;
        }

        field(44; "Maturity FOSA Account"; Code[50])
        {
            TableRelation = Vendor where("Member No." = field("Member No."));
            trigger OnValidate()
            var

            begin
                TestField("Account Type");
                Vendor.Get("Maturity FOSA Account");
                AccountType.Get(Vendor."Account Type");
                "Maturity Acccount Name" := AccountType.Description;
            end;
        }


        field(46; "Interest Rate"; Decimal)
        {
            Editable = false;
        }
        field(47; "Maturity Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(48; "Start Date"; Date)
        {

            trigger OnValidate()
            var

            begin

            end;
        }

        field(49; "SMS Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(50; "E-Mail Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(51; "Capitalization Frequency"; Option)
        {
            OptionCaption = 'Monthly,Fortnightly,Weekly,Daily';
            OptionMembers = Monthly,Fortnightly,Weekly,Daily;

        }
        field(52; "Interest To Earn"; Decimal)
        {
            Editable = false;
        }
        field(53; "Maturity Acccount Name"; Text[50])
        {
            Editable = false;
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
    }

    trigger OnInsert()
    begin
        AccountOpeningSetup.GET;
        AccountOpeningSetup.TestField("Account Opening Nos.");
        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(AccountOpeningSetup."Account Opening Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Created By" := USERID;
        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    trigger OnModify()
    begin
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Last Modified By Host IP" := HostIP;
        "Last Modified By Host MAC" := HostMac;
        "Last Modified By Host Name" := HostName;
        "Last Modified Date" := TODAY;
        "Last Modified Time" := TIME;
        "Last Modified By" := USERID;
    end;




    procedure ValidateFields()
    begin
        TESTFIELD("Member No.");
        TESTFIELD("Account Type");
        TESTFIELD("Global Dimension 1 Code");
        TESTFIELD("Account No.");
    end;

    procedure GenerateAccountNo()
    var
    begin
        TESTFIELD("Member No.");
        TESTFIELD("Account Type");
        TESTFIELD("Global Dimension 1 Code");
        AccountOpeningSetup.GET;
        IF AccountOpeningSetup."Account No. Format" = AccountOpeningSetup."Account No. Format"::"No. Series Only" THEN
            AccountNo := "No.";
        IF AccountOpeningSetup."Account No. Format" = AccountOpeningSetup."Account No. Format"::"Member No.+Account Type" THEN
            AccountNo := "Member No." + "Account Type";

        "Account No." := AccountNo + GetNextFDAccount();
        VALIDATE("Account No.");
        IF "Account No." <> '' THEN
            MESSAGE(Text004, "Account No.");

    end;

    local procedure GetNextFDAccount(): Code[20]
    begin
        TestField("Member No.");
        AccountType.Get("Account Type");
        if ((AccountType.Type = AccountType.Type::"Fixed Deposit") or (AccountType.Type = AccountType.Type::"Call Deposit")) then begin
            Vendor.Reset();
            Vendor.SetRange("Account Type", AccountType.Code);
            Vendor.SetRange("Member No.", "Member No.");
            if Vendor.FindLast() then
                if INCSTR(Vendor."Account Type") = '' then
                    exit(INCSTR(Vendor."Account Type") + '1')
                else
                    exit(INCSTR(Vendor."Account Type"))
            else
                exit('')
        end;
    end;

    local procedure HasSimilarAccount(MemberNo: Code[20]): Boolean
    var

    begin
        TestField("Account Type");
        Vendor.Reset();
        Vendor.SetRange("Member No.", MemberNo);
        Vendor.SetRange("Account Type", "Account Type");
        exit(Vendor.FindFirst());
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        FOSAManagement: Codeunit "FOSA Management";
        AccountOpeningSetup: Record "Account Opening Setup";
        AccountType: Record "Account Type";
        Member: Record "Member";
        AccountNo: Code[20];
        Vendor: Record Vendor;
        Text004: Label 'Account %1 has been created.';
        InsuffBalanceErr: Label '%1 cannot exceed %2';
        NotSavingsAccErr: Label '%1 must be a Savings Account';
        HasSimilarAccountErr: Label 'Member has another %1 account';
        MemberNotActiveErr: Label 'Member not active';
        LoanAccNotAllowedErr: Label 'Account Type %1 is not allowed';
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;
        "No. Of Days": DateFormula;

        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        GlobalManagement: Codeunit "Global Management";
        AccountTypeEnum: Enum "Gen. Journal Account Type";

}

