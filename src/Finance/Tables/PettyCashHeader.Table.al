table 50362 "PettyCash Header"
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

        field(7; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";
            Editable = false;
            trigger OnValidate()
            var
            begin
                BankAccount.Get("Bank Account No.");
                "Bank Account Name" := BankAccount.Name;
            end;

        }
        field(8; "Total VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PettyCash Line"."VAT Amount" where("Document No." = field("No.")));
            Editable = false;
        }
        field(9; "Total W/Tax Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PettyCash Line"."W/Tax Amount" where("Document No." = field("No.")));
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
            CalcFormula = sum("PettyCash Line"."Line Amount" where("Document No." = field("No.")));
            Editable = false;
        }
        field(27; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            trigger OnValidate()
            var

            begin

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
            OptionMembers = "Single Vendor","Multiple Vendor";
            trigger OnValidate()
            var
            begin
                Clear("Vendor No.");
                Clear("Vendor Name");
                Clear("Payee Name");
                PettyCashLine.DeleteRelatedLinks("No.");
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
                PettyCashLine.DeleteRelatedLinks("No.");
                Vendor.Get("Vendor No.");
                "Vendor Name" := Vendor.Name;
                "Payee Name" := Vendor.Name;
                CashManagement.InsertPettyCashLine("No.", "Vendor No.", '', 0);
            end;
        }
        field(36; "Vendor Name"; Text[50])
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
        TestField(Status, Status::New);
    end;

    trigger OnInsert();
    begin

        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");

        CashMgtSetup.TESTFIELD("PettyCash Nos.");
        CashMgtSetup.TESTFIELD("PettyCash Bank");
        NoSeriesMgt.InitSeries(CashMgtSetup."PettyCash Nos.", xRec."No. Series", 0D, "No.", "No. Series");


        "Created By" := USERID;
        "Created Date" := Today;
        "Posting Date" := Today;
        "Created Time" := time;
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        validate("Bank Account No.", CashMgtSetup."PettyCash Bank");
    end;

    var
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashManagement: Codeunit "Cash Management";
        PettyCashLine: Record "PettyCash Line";
        BankAccount: Record "Bank Account";
        Vendor: Record Vendor;
        GlobalManagement: Codeunit "Global Management";
        UserSetup: Record "User Setup";
        PettyCashHeader2: Record "PettyCash Header";
        ExternalDocNoExistMsg: Label 'This External Document No. is already used';

    procedure ReqLinesExist(): Boolean;
    begin
        PettyCashLine.RESET;
        PettyCashLine.SETRANGE("Document No.", "No.");
        EXIT(PettyCashLine.FINDFIRST);
    end;

    local procedure ExternalDocNoExist(): Boolean
    var
    begin
        PettyCashHeader2.Reset();
        PettyCashHeader2.SetRange("External Document No.", "External Document No.");
        exit(PettyCashHeader2.FindFirst());
    end;
}

