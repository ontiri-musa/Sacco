table 50134 "Fund Transfer"
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
        field(2; "Member No."; Code[30])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                ClearSourceField;
                Member.GET("Member No.");
                "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Source Account Type"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;

            trigger OnValidate()
            begin
                clear("Source Account No.");
                clear("Source Account Name");
                //IF (("Source Account Type" = "Source Account Type"::Customer)) AND (("Destination Account Type" = "Destination Account Type"::Vendor)) THEN
                //ERROR(Error003);
            end;
        }
        field(6; "Source Account No."; Code[30])
        {
            TableRelation = IF ("Source Account Type" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Member No."))
            //ELSE
            //IF ("Source Account Type" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Member No."));
            ELSE
            IF ("Source Account Type" = filter(Customer)) "Loan Application" where(Posted = filter(true), "Member No." = field("Member No."));

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
                IF "Source Account Type" = "Source Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Source Account No.") THEN
                        "Source Account Name" := Vendor.Name;
                    "Source Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, "Source Account No.");
                END;
                IF "Source Account Type" = "Source Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Source Account No.") THEN
                        "Source Account Name" := Customer.Name;
                    "Source Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Customer, "Source Account No.");
                    if "Source Account Balance" <> 0 then
                        "Source Account Balance" := "Source Account Balance";
                END;

                IF "Source Account No." = "Destination Account No." THEN
                    ERROR(Error010, FIELDCAPTION("Source Account No."), FIELDCAPTION("Destination Account No."));
            end;
        }
        field(7; "Source Account Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Destination Account No."; Code[30])
        {
            TableRelation = IF ("Destination Account Type" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Destination Member No."))
            ELSE
            IF ("Destination Account Type" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Destination Member No."));

            trigger OnValidate()
            begin
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Destination Account No.") THEN
                        "Destination Account Name" := Vendor.Name;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Destination Account No.") THEN
                        "Destination Account Name" := Customer.Name;

                END;
                IF "Source Account No." = "Destination Account No." THEN
                    ERROR(Error010, FIELDCAPTION("Source Account No."), FIELDCAPTION("Destination Account No."));
            end;
        }
        field(9; "Destination Account Name"; Text[50])
        {
            Editable = false;
        }
        field(10; "Source Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(11; "Source Transaction Type"; code[100])
        {
            TableRelation = "Transaction Type";
            trigger OnValidate()
            var
                TransType: Record "Transaction Type";
            begin
                if TransType.Get("Source Transaction Type") then begin
                    if "Source Account Type" = "Source Account Type"::Customer then begin
                        if TransType."Is Loan Transaction Type" = false then
                            Error('Transaction type %1 is not a loan transaction type kindly select the correct transaction type', "Source Transaction Type");
                    end;
                    if "Source Account Type" = "Source Account Type"::Vendor then begin
                        if TransType."Is Loan Transaction Type" = True then
                            Error('Transaction type %1 is a loan transaction type indly select the correct transaction type', "Source Transaction Type");
                    end;
                end;
            end;
        }
        field(13; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }

        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(16; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(17; "Created Date"; Date)
        {
            Editable = false;
        }
        field(18; "Created Time"; Time)
        {
            Editable = false;
        }

        field(20; "Amount to Transfer"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Funds Transfer Line"."Line Amount" where("Document No." = field("No.")));
            Editable = false;
            trigger OnValidate()
            begin
                /*
                FundTransferSetup.GET;
                if "Source Account Type" <> "Source Account Type"::Customer then
                    IF ("Source Account Balance" < "Amount to Transfer") THEN
                        ERROR(Error000, FIELDCAPTION("Amount to Transfer"), FIELDCAPTION("Source Account Balance"));
                        */
            end;
        }

        field(23; Posted; Boolean)
        {
        }

        field(27; Description; Text[50])
        {
            Editable = false;
        }

        field(31; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(32; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(33; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(34; "Destination Account Type"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;

            trigger OnValidate()
            begin
                clear("Destination Account No.");
                clear("Destination Account Name");

                //IF (("Source Account Type" = "Source Account Type"::Customer)) AND (("Destination Account Type" = "Destination Account Type"::Vendor)) THEN
                //ERROR(Error003);
            end;
        }
        field(35; "Destination Account Ownership"; Option)
        {
            OptionCaption = ' ,Self,Other Member';
            OptionMembers = " ",Self,"Other Member";

            trigger OnValidate()
            begin
                IF "Destination Account Ownership" = "Destination Account Ownership"::Self THEN BEGIN
                    "Destination Member No." := "Member No.";
                    "Destination Member Name" := "Member Name";
                END ELSE BEGIN
                    clear("Destination Member No.");
                    clear("Destination Member Name");
                END;
                clear("Destination Account No.");
                clear("Destination Account Name");

            end;
        }
        field(36; "Destination Member No."; Code[30])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
                TESTFIELD("Source Account No.");
                TESTFIELD("Destination Account Ownership");
                Member.GET("Destination Member No.");
                IF "Destination Account Ownership" = "Destination Account Ownership"::Self THEN BEGIN
                    IF "Destination Member No." <> "Member No." THEN
                        ERROR(Error008, FIELDCAPTION("Destination Member No."), "Member No.", "Member Name");

                END;
                IF "Destination Account Ownership" = "Destination Account Ownership"::"Other Member" THEN BEGIN
                    IF "Destination Member No." = "Member No." THEN
                        ERROR(Error009, FIELDCAPTION("Destination Member No."), "Member No.", "Member Name");
                END;
                "Destination Member Name" := Member."Full Name";
                //if "Source Account Type" = "Source Account Type"::Customer then
                //"Destination Account Type" := "Destination Account Type"::Customer;
            END;
        }

        field(37; Remarks; Text[150])
        {
        }
        field(38; "Posting Date"; Date)
        {

        }
        field(40; "Destination Member Name"; Text[50])
        {
            Editable = false;
        }
        field(41; "Transaction Type"; Option)
        {
            OptionMembers = "Single Member","Multiple Member";
            trigger OnValidate()
            var
            begin
                Clear("Member No.");
                Clear("Member Name");
                FundsTransLine.DeleteRelatedLinks("No.");
            end;
        }
        field(42; "Posted By"; Code[30])
        {
            Editable = false;
        }
        field(43; "Transaction Type Code"; Code[100])
        {
            TableRelation = "Transaction Type";
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
        FundTransferSetup.GET;
        FundTransferSetup.TestField("Fund Transfer Nos.");
        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(FundTransferSetup."Fund Transfer Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
            Description := Text000 + "No."
        END;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        Vendor: Record Vendor;
        //FundTransferSetup: Record "Fund Transfer Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;

        ArrearsAmount: array[6] of Decimal;
        OverpaymentAmount: array[6] of Decimal;
        Customer: Record "Customer";
        Member: Record Member;
        FundsTransLine: Record "Funds Transfer Line";
        Error000: Label '%1 cannot exceed %2';
        Text000: Label 'Fund Transfer ';
        Error003: Label 'Loan to Savings Transfer is not allowed';
        Error004: Label '%1 must be a Loan Account';
        Error005: Label '%1 must NOT be a Loan Account';
        Error006: Label 'Loan %1 has no overpayment';
        Error007: Label '%1 cannot exceed the %2';
        Error008: Label '%1 must be %2 %3';
        Error009: Label '%1 must NOT be %2 %3';
        Error010: Label '%1 and %2 cannot be the same';
        FundTransferSetup: Record "Fund Transfer Setup";
        GlobalManagement: Codeunit "Global Management";
        AccountTypeEnum: Enum "Gen. Journal Account Type";

    procedure ClearSourceField()
    begin
        //"Member No.":='';
        clear("Member Name");
        clear("Source Account No.");
        clear("Source Account Name");
        clear("Source Account Balance");

    end;


}

