table 50334 "Receipt Header"
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
                if ExternalDocNoExistCheckoffRecLine() then
                    Error(ExternalDocNoExistMsg);
                if ExternalDocNoExistCheckoffRecHeader() then
                    Error(ExternalDocNoExistMsg);
            end;
        }
        field(6; "Payee Name"; Text[50])
        {
        }

        field(7; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";
            trigger OnValidate()
            var
            begin
                BankAccount.Get("Bank Account No.");
                "Bank Account Name" := BankAccount.Name;
            end;

        }


        field(11; Amount; Decimal)
        {
        }
        field(12; Posted; Boolean)
        {
            Editable = false;
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
        field(16; "Bank Account Name"; Code[50])
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
            CalcFormula = sum("Receipt Line"."Line Amount" where("Document No." = field("No.")));
            Editable = false;
        }
        field(27; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Member,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Member,"Bank Account","Fixed Asset","IC Partner";
            trigger OnValidate()
            var
            begin

            end;
        }

        field(29; Reversed; Boolean)
        {

            Editable = false;
        }
        field(30; "Transaction Type"; Option)
        {
            OptionMembers = "Single Member","Multiple Member";
            trigger OnValidate()
            var
            begin
                Clear("Member No.");
                Clear("Member Name");
                Clear("Payee Name");
                ReceiptLine.DeleteRelatedLinks("No.");
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
        field(35; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            var

            begin
                ReceiptLine.DeleteRelatedLinks("No.");
                Member.Get("Member No.");
                "Member Name" := Member."Full Name";
                "Payee Name" := Member."Full Name";
                CashManagement.InsertReceiptLine("No.", "Member No.", 0, '', 0);
            end;
        }
        field(36; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(37; "GL Account No"; Code[20])
        {
            TableRelation = "G/L Account";
            trigger OnValidate()
            var
                GL: Record "G/L Account";
            begin
                GL.Get("GL Account No");
                "GL Account Name" := GL.Name;
            end;
        }
        field(38; "GL Account Name"; Text[200])
        {
            Editable = false;
        }
        field(39; Variance; Decimal)
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

    trigger OnDelete();
    begin
        TestField(Posted, false);
    end;

    trigger OnInsert();
    begin

        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");

        CashMgtSetup.TESTFIELD("Receipt Voucher Nos.");
        NoSeriesMgt.InitSeries(CashMgtSetup."Receipt Voucher Nos.", xRec."No. Series", 0D, "No.", "No. Series");


        "Created By" := USERID;
        "Created Date" := Today;
        "Posting Date" := Today;
        "Created Time" := time;
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
    end;

    var
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashManagement: Codeunit "Cash Management";
        ReceiptLine: Record "Receipt Line";
        BankAccount: Record "Bank Account";
        Member: Record Member;
        GlobalManagement: Codeunit "Global Management";
        UserSetup: Record "User Setup";
        ReceiptHeader2: Record "Receipt Header";
        CheckoffReceiptHeader2: Record "Checkoff Receipt Header";
        CheckoffReceiptLine2: Record "Checkoff Receipt Line";
        ExternalDocNoExistMsg: Label 'This External Document No. is already used';

    procedure ReqLinesExist(): Boolean;
    begin
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.", "No.");
        EXIT(ReceiptLine.FINDFIRST);
    end;

    local procedure ExternalDocNoExist(): Boolean
    var
    begin
        ReceiptHeader2.Reset();
        ReceiptHeader2.SetRange("External Document No.", "External Document No.");
        exit(ReceiptHeader2.FindFirst());
    end;

    local procedure ExternalDocNoExistCheckoffRecLine(): Boolean
    var
    begin
        CheckoffReceiptLine2.Reset();
        CheckoffReceiptLine2.SetRange("External Document No.", "External Document No.");
        exit(CheckoffReceiptLine2.FindFirst());
    end;

    local procedure ExternalDocNoExistCheckoffRecHeader(): Boolean
    var
    begin
        CheckoffReceiptHeader2.Reset();
        CheckoffReceiptHeader2.SetRange("External Document No.", "External Document No.");
        exit(CheckoffReceiptHeader2.FindFirst());
    end;
}

