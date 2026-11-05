table 50337 "Checkoff Receipt Line"
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
                if "Account Type" in ["Account Type"::Vendor, "Account Type"::Customer, "Account Type"::"Fixed Asset", "Account Type"::"IC Partner"] then
                    Error(AccountTypeNotAllowed, "Account Type");
            end;
        }
        field(5; "Account No."; Code[20])
        {
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

                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BankAccount.Get("Account No.");
                    "Account Name" := BankAccount.Name;
                end;
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    GLAcc.Get("Account No.");
                    "Account Name" := GLAcc.Name;
                end;

                Description := "Account Name";
                CheckoffReceiptHeader.Get("Document No.");
                "Receipt Date" := CheckoffReceiptHeader."Posting Date";
            end;


        }
        field(6; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "External Document No."; Code[50])
        {
            trigger OnValidate()
            var
            begin
                if ExternalDocNoExist() then
                    Error(ExternalDocNoExistMsg);
                if ExternalDocNoExistRecHeader() then
                    Error(ExternalDocNoExistMsg);
            end;
        }

        field(8; "Line Amount"; Decimal)
        {

        }
        field(9; "Receipt Date"; Date)
        {

        }
        field(50; Description; Text[50])
        {
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
        CheckoffReceiptLine.Reset();
        CheckoffReceiptLine.SetRange("Document No.", DocNo);
        CheckoffReceiptLine.DeleteAll();
    end;

    procedure CheckoffReceiptLinesExist(DocNo: Code[20]): Boolean
    var

    begin
        CheckoffReceiptLine.Reset();
        CheckoffReceiptLine.SetRange("Document No.", DocNo);
        exit(CheckoffReceiptLine.FindFirst());
    end;

    local procedure ExternalDocNoExist(): Boolean
    var
    begin
        CheckoffReceiptLine2.Reset();
        CheckoffReceiptLine2.SetRange("External Document No.", "External Document No.");
        exit(CheckoffReceiptLine2.FindFirst());

    end;

    local procedure ExternalDocNoExistRecHeader(): Boolean
    var
    begin
        ReceiptHeader2.Reset();
        ReceiptHeader2.SetRange("External Document No.", "External Document No.");
        exit(ReceiptHeader2.FindFirst());
    end;


    var
        ReceiptHeader2: Record "Receipt Header";
        GenJournalLine: Record "Gen. Journal Line";
        CashManagement: Codeunit "Cash Management";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        GLAcc: Record "G/L Account";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        BankAccount: Record "Bank Account";
        GlobalSetup: Record "Global Setup";
        CheckoffReceiptHeader: Record "Checkoff Receipt Header";
        CheckoffReceiptLine: Record "Checkoff Receipt Line";
        CheckoffReceiptLine2: Record "Checkoff Receipt Line";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;
        ExternalDocNoExistMsg: Label 'This External Document No. is already used';



}

