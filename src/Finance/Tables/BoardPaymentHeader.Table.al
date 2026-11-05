table 56331 "Board Payment Header"
{
    // version TL 2.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Payment Method"; Code[20])
        {
            TableRelation = "Payment Method";
        }
        field(5; "External Document No."; Code[20])
        {
            trigger OnValidate()
            var
            begin
                if ExternalDocNoExist() then
                    Error(ExternalDocNoExistMsg);
            end;
        }
        field(6; "Payee Name"; Text[50])
        {
        }

        field(7; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = filter("Bank Account")) "Bank Account";

            trigger OnValidate()
            var
                GLA: Record "G/L Account";
            begin
                If BankAccount.Get("Account No.") Then
                    "Account Name" := BankAccount.Name;
                If GLA.Get("Account No.") then
                    "Account Name" := GLA.Name;
            end;

        }
        field(8; "Total VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Payment Line"."VAT Amount" where("Document No." = field("No.")));
            Editable = false;
        }
        field(9; "Total Tax Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Payment Line"."Tax Amount" where("Document No." = field("No.")));
            Editable = false;
        }

        field(11; Amount; Decimal)
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "Posted Time"; Time)
        {
        }
        field(14; "Posted Date"; Date)
        {
        }
        field(15; "Posted By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(16; "Account Name"; Code[50])
        {
            Editable = false;
        }
        field(17; Description; Text[100])
        {
        }
        field(18; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(20; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }

        field(22; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(23; "Created Date"; Date)
        {
            Editable = false;
        }
        field(24; "Created Time"; Time)
        {
            Editable = false;
        }
        field(25; "No. Series"; Code[20])
        {
        }
        field(26; "Total Line Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Payment Line"."Line Amount" where("Document No." = field("No.")));
            Editable = false;
        }

        field(27; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            trigger OnValidate()
            var
            begin
                Clear("Account No.");
                Clear("Account Name");
            end;
        }
        field(28; "Account Balance"; Decimal)
        {

            Editable = false;
        }
        field(29; Reversed; Boolean)
        {

            Editable = false;
        }
        field(30; "Transaction Type"; Option)
        {
            OptionMembers = "Single Board Member","Multiple Board Members";
            trigger OnValidate()
            var
            begin
                Clear("Vendor No.");
                Clear("Vendor Name");
                Clear("Payee Name");
                PaymentLine.DeleteRelatedLinks("No.");
            end;
        }

        field(32; "Bank Name"; Code[50])
        {
            Editable = false;
        }

        field(34; "Branch Name"; Text[70])
        {
            Editable = false;
        }
        field(35; "Vendor No."; Code[20])
        {
            TableRelation = Vendor where("Vendor Type" = filter(Normal));
            trigger OnValidate()
            var

            begin
                PaymentLine.DeleteRelatedLinks("No.");
                Vendor.Get("Vendor No.");
                "Vendor Name" := Vendor.Name;
                "Payee Name" := Vendor.Name;
                CashManagement.InsertPaymentLine("No.", "Vendor No.", '', 0);
            end;
        }
        field(36; "Vendor Name"; Text[50])
        {
            Editable = false;
        }
        field(37; "Time Approved"; Time)
        {
        }
        field(38; "Date Approved"; Date)
        {
        }
        field(39; "Approved By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(40; "Time Rejected"; Time)
        {
        }
        field(41; "Date Rejected"; Date)
        {
        }
        field(42; "Rejected By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(43; "Gross Board Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Members Payment Line"."Gross Pay" where("Document No." = field("No.")));
            Editable = false;
        }
        field(44; "Total Board Sitting"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Members Payment Line"."Sitting Allowance" where("Document No." = field("No.")));
            Editable = false;
        }
        field(45; "Total Board Transport"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Members Payment Line"."Transport Allowance" where("Document No." = field("No.")));
            Editable = false;
        }
        field(46; "Total Board Hospitality"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Members Payment Line".Hospitality where("Document No." = field("No.")));
            Editable = false;
        }
        field(47; "Total Board Tax"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Members Payment Line"."Sitting Allowance Tax" where("Document No." = field("No.")));
            Editable = false;
        }
        field(48; "Net Board Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Board Members Payment Line"."Net Pay" where("Document No." = field("No.")));
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

    trigger OnDelete();
    begin
        TestField(Status, Status::New);
    end;

    trigger OnInsert();
    var
        BAccNo: Code[20];
        BAccName: Text;
        Member: Record Member;
    begin

        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");

        CashMgtSetup.TESTFIELD("Payment Voucher Nos.");
        NoSeriesMgt.InitSeries(CashMgtSetup."Payment Voucher Nos.", xRec."No. Series", 0D, "No.", "No. Series");


        "Created By" := USERID;
        "Created Date" := Today;
        "Posting Date" := Today;
        "Created Time" := time;
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        //Insert Board members Accounts
        Member.Reset();
        Member.SetRange("Sub Category", Member."Sub Category"::"Board Member");
        if Member.FindSet() then begin
            repeat
                BAccNo := '';
                BAccName := '';
                GetMemberBoardAcc(Member, BAccNo, BAccName);
                InsertBoardMembersPVLines("No.", BAccNo, BAccName, Member."Full Name");
            until Member.Next = 0;
        end;
        //End Insert Board members Accounts
    end;

    procedure InsertBoardMembersPVLines(DocNo: Code[50]; AccountNo: Code[50]; AccName: Text; MembName: Text)
    var
        BoardMembersPVLines: Record "Board Members Payment Line";
        BoardMembersPVLinesN: Record "Board Members Payment Line";
        LineNo: Integer;
    begin
        BoardMembersPVLinesN.Reset();
        BoardMembersPVLinesN.SetRange("Document No.", DocNo);
        if BoardMembersPVLinesN.FindLast() then begin
            LineNo := BoardMembersPVLinesN."Line No." + 1000;
        end else begin
            LineNo := 1000;
        end;


        BoardMembersPVLines.Init();
        BoardMembersPVLines."Document No." := DocNo;
        BoardMembersPVLines."Line No." := LineNo;
        BoardMembersPVLines."Account Type" := BoardMembersPVLines."Account Type"::Vendor;
        BoardMembersPVLines."Account No." := AccountNo;
        BoardMembersPVLines."Account Name" := AccName;
        BoardMembersPVLines.Insert();
    end;

    procedure GetMemberBoardAcc(Memb: Record Member; Var AccNo: Code[20]; Var AccName: Text)
    var
        AccType: Record "Account Type";
        Vend: Record Vendor;
        Fosa: Codeunit "FOSA Management";
    begin
        AccType.Reset();
        AccType.SetRange(Type, AccType.Type::Board);
        If AccType.FindFirst() then begin

            Vend.Reset();
            Vend.SetRange("Member No.", Memb."No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                Vend.Delete();
            end;

            Vend.Reset();
            Vend.SetRange("Member No.", Memb."No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                AccNo := Vend."No.";
                AccName := Vend.Name;
            end else begin
                Fosa.CreateBoardMemberAccount(Memb);
                Vend.Reset();
                Vend.SetRange("Member No.", Memb."No.");
                Vend.SetRange("Account Type", AccType.Code);
                if Vend.FindFirst() then begin
                    AccNo := Vend."No.";
                    AccName := Vend.Name;
                end;
            end;
        end;

    end;

    var
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashManagement: Codeunit "Cash Management";
        PaymentLine: Record "Payment Line";
        BankAccount: Record "Bank Account";
        Vendor: Record Vendor;
        GlobalManagement: Codeunit "Global Management";
        UserSetup: Record "User Setup";
        PaymentHeader2: Record "Payment Header";
        ExternalDocNoExistMsg: Label 'This External Document No. is already used';

    procedure ReqLinesExist(): Boolean;
    begin
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", "No.");
        EXIT(PaymentLine.FINDFIRST);
    end;

    local procedure ExternalDocNoExist(): Boolean
    var
    begin
        PaymentHeader2.Reset();
        PaymentHeader2.SetRange("External Document No.", "External Document No.");
        exit(PaymentHeader2.FindFirst());
    end;
}

