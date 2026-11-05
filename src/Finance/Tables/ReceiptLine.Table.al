table 50335 "Receipt Line"
{

    fields
    {

        field(1; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            trigger OnValidate()
            var

            begin
                Clear("Account No.");
                Clear("Account Name");
                Clear("Line Amount");
                Clear("Account Balance");

                if "Account Type" in ["Account Type"::"Bank Account", "Account Type"::"Fixed Asset", "Account Type"::"IC Partner"] then
                    Error(AccountTypeNotAllowed, "Account Type");

            end;
        }
        field(5; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = filter(Customer)) "Loan Application" where(Posted = filter(true), "Member No." = field("Member No."), "Outstanding Balance" = filter(> 0))
            ELSE
            IF ("Account Type" = filter(Vendor)) Vendor WHERE("Vendor Type" = filter(1), "Member No." = field("Member No."))
            ELSE
            IF ("Account Type" = filter("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = filter("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = filter("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin
                If "Member No." <> '' then begin
                    if "Account Type" = "Account Type"::Vendor then begin
                        Vendor.Get("Account No.");
                        If "Member No." <> Vendor."Member No." then
                            Error('Account No %1 does not belong to member %2', "Account No.", "Member No.");
                    end;
                    if "Account Type" = "Account Type"::Customer then begin
                        Customer.Get("Account No.");
                        If "Member No." <> Customer."Member No." then
                            Error('Account No %1 does not belong to member %2', "Account No.", "Member No.");
                    end;
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    Vendor.Get("Account No.");
                    "Account Name" := Vendor.Name;
                    "Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Vendor, "Account No.");
                end;
                if "Account Type" = "Account Type"::Customer then begin
                    Customer.Get("Account No.");
                    "Account Name" := Customer.Name;
                    "Account Balance" := GlobalManagement.GetAccountBalance(AccountTypeEnum::Customer, "Account No.");
                end;

                Description := "Account Name";
            end;


        }
        field(6; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(7; Description; Text[50])
        {
        }

        field(8; "Line Amount"; Decimal)
        {

        }
        field(9; "Account Balance"; Decimal)
        {
            Editable = false;

        }
        field(12; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            var
                Rcpt: Record "Receipt Line";
            begin
                Clear("Account No.");
                Clear("Account Type");
                Clear("Member Name");
                Clear("Account Name");
                Clear(Description);
                Clear("Line Amount");

                Member.Get("Member No.");
                "Member Name" := Member."Full Name";
                ReceiptHeader.Get("Document No.");
                if ReceiptHeader."Transaction Type" = ReceiptHeader."Transaction Type"::"Single Member" then begin
                    ReceiptHeader.TestField("Member No.");
                    Rec.TestField("Member No.", ReceiptHeader."Member No.");
                end;
            end;
        }
        field(13; "Member Name"; Text[50])
        {
            Editable = false;
        }





    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }


    procedure DeleteRelatedLinks(DocNo: Code[20])
    var

    begin
        ReceiptLine.Reset();
        ReceiptLine.SetRange("Document No.", DocNo);
        ReceiptLine.DeleteAll();
    end;

    procedure ReceiptLinesExist(DocNo: Code[20]): Boolean
    var

    begin
        ReceiptLine.Reset();
        ReceiptLine.SetRange("Document No.", DocNo);
        exit(ReceiptLine.FindFirst());
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        CashManagement: Codeunit "Cash Management";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;

        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        GlobalSetup: Record "Global Setup";
        ReceiptHeader: Record "Receipt Header";
        ReceiptLine: Record "Receipt Line";
        ReceiptLine2: Record "Receipt Line";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;
        GlobalManagement: Codeunit "Global Management";
        AccountTypeEnum: Enum "Gen. Journal Account Type";



}

