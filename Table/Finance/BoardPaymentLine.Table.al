table 56332 "Board Payment Line"
{

    fields
    {

        field(1; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Account Type"; Enum "Gen. Journal Account Type")
        {

            trigger OnValidate()
            var

            begin
                if "Account Type" in ["Account Type"::"Fixed Asset", "Account Type"::"IC Partner"] then
                    Error(AccountTypeNotAllowed, "Account Type");
            end;
        }
        field(5; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = filter(Customer)) Customer
            ELSE
            IF ("Account Type" = filter(Vendor)) Vendor WHERE("Vendor Type" = filter(0))//, "Vendor Type" = CONST(2))
            ELSE
            IF ("Account Type" = filter("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = filter("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = filter("IC Partner")) "IC Partner"
            else
            if ("Member No" = filter(<> ''), "Account Type" = CONST(Customer)) "Loan Application" where(Posted = filter(true), "Member No." = field("Member No"), "Outstanding Balance" = filter(> 0))
            else
            if ("Member No" = filter(<> ''), "Account Type" = CONST(Vendor)) Vendor where("Member No." = field("Member No"));

            trigger OnValidate();
            var
                GL: Record "G/L Account";
                Bank: Record "Bank Account";
                Vend: Record Vendor;
            begin

                //TestField("Account Type", "Account Type"::Vendor);
                If GL.Get("Account No.") then begin
                    "Account Name" := GL.Name;
                    Description := "Account Name";
                end;
                If Bank.Get("Account No.") then begin
                    "Account Name" := Bank.Name;
                    Description := "Account Name";
                end;
                If Vend.Get("Account No.") then begin
                    "Account Name" := Vend.Name;
                    Description := "Account Name";
                end;

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
        field(9; "VAT Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "Tax Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Net Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate();
            begin
            end;
        }


        field(14; "Charge Withholding Tax"; Boolean)
        {
            Caption = 'Charge Tax';
            trigger OnValidate()
            var
            begin
                GlobalSetup.Get();
                if "Charge Withholding Tax" then begin
                    GlobalSetup.TestField("Board Tax %");
                    "Tax Amount" := GlobalSetup."Board Tax %" / 100 * "Line Amount"
                end else
                    "Tax Amount" := 0;
            end;
        }

        field(18; "VAT Business Posting Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
            trigger OnValidate()
            var
            begin
                CalculateVATAmount();
            end;
        }
        field(19; "VAT Product Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";
            trigger OnValidate()
            var
            begin
                CalculateVATAmount();
            end;
        }
        field(20; "Member No"; Code[20])
        {
            TableRelation = Member;
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
    local procedure CalculateVATAmount()
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if VATPostingSetup.get("VAT Business Posting Group", "VAT Product Posting Group") then
            "VAT Amount" := VATPostingSetup."VAT %" / 100 * "Line Amount";
    end;

    procedure DeleteRelatedLinks(DocNo: Code[20])
    var

    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document No.", DocNo);
        PaymentLine.DeleteAll();
    end;

    procedure PaymentLinesExist(DocNo: Code[20]): Boolean
    var

    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document No.", DocNo);
        exit(PaymentLine.FindFirst());
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
        PaymentHeader: Record "Board Payment Header";
        PaymentLine: Record "Board Payment Line";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;



}

