table 50360 "Checkoff Header"

{
    LookupPageId = "Checkoff List-Posted-Reversed";
    DrillDownPageId = "Checkoff List-Posted-Reversed";
    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
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

        field(7; "Agent Code"; Code[20])
        {
            TableRelation = "Remittance Agent Setup";
            ;
            trigger OnValidate()
            var
            begin
                RemittanceAgentSetup.Get("Agent Code");
                // RemittanceAgentSetup.TestField("Account Type");
                RemittanceAgentSetup.TestField("Account No.");

                "Agent Name" := RemittanceAgentSetup.Name;
                "Account Type" := RemittanceAgentSetup."Account Type";
                "Account No." := RemittanceAgentSetup."Account No.";
                validate("Account No.");
            end;

        }
        field(10; "Account Balance"; Decimal)
        {
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
        field(16; "Agent Name"; Code[50])
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
            CalcFormula = sum("Checkoff Line"."Line Amount" where("Document No." = field("No.")));
            Editable = false;
        }


        field(29; Reversed; Boolean)
        {

            Editable = false;
        }



        field(35; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Editable = false;

            trigger OnValidate()
            var

            begin

            end;
        }
        field(36; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = filter(Customer)) Customer
            ELSE
            IF ("Account Type" = filter(Vendor)) Vendor
            ELSE
            IF ("Account Type" = filter("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = filter("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = filter("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    GLAccount.get("Account No.");
                    "Account Name" := GLAccount.Name;
                    "Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::"G/L Account", "Account No.");
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    Vendor.get("Account No.");
                    "Account Name" := Vendor.Name;
                    "Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, "Account No.");
                end;
                if "Account Type" = "Account Type"::Customer then begin
                    Customer.get("Account No.");
                    "Account Name" := Customer.Name;
                    "Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Customer, "Account No.");
                end;
                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BankAccount.get("Account No.");
                    "Account Name" := BankAccount.Name;
                    "Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::"Bank Account", "Account No.");
                end;
            end;


        }

        field(37; "Account Name"; Text[50])
        {
            Editable = false;
        }

        field(38; "Reversed Time"; Time)
        {
        }
        field(39; "Reversed Date"; Date)
        {
        }
        field(40; "Reversed By"; Code[50])
        {
            TableRelation = "User Setup";
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

        CashMgtSetup.TESTFIELD("Checkoff Nos.");
        NoSeriesMgt.InitSeries(CashMgtSetup."Checkoff Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        "External Document No." := "No.";

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
        CheckoffLine: Record "Checkoff Receipt Line";
        RemittanceAgentSetup: Record "Remittance Agent Setup";
        GlobalManagement: Codeunit "Global Management";
        UserSetup: Record "User Setup";
        CheckoffHeader2: Record "Checkoff Receipt Header";
        ExternalDocNoExistMsg: Label 'This External Document No. is already used';
        Vendor: Record Vendor;
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        AccountTypeEnum: Enum "Gen. Journal Account Type";

    procedure CheckoffLinesExist(): Boolean;
    begin
        CheckoffLine.RESET;
        CheckoffLine.SETRANGE("Document No.", "No.");
        EXIT(CheckoffLine.FINDFIRST);
    end;

    local procedure ExternalDocNoExist(): Boolean
    var
    begin
        CheckoffHeader2.Reset();
        CheckoffHeader2.SetRange("External Document No.", "External Document No.");
        exit(CheckoffHeader2.FindFirst());
    end;
}