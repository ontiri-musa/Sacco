table 56333 "Board Members Payment Line"
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
                if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::"Bank Account", "Account Type"::"Fixed Asset", "Account Type"::"IC Partner"] then
                    Error(AccountTypeNotAllowed, "Account Type");
            end;
        }
        field(5; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = filter(Vendor)) Vendor WHERE("Vendor Type" = filter(0));

            trigger OnValidate();
            begin

                TestField("Account Type", "Account Type"::Vendor);
                Vendor.Get("Account No.");
                "Account Name" := Vendor.Name;
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
        field(9; Select; Boolean)
        {

        }
        field(10; "Sitting Allowance"; Decimal)
        {
            trigger OnValidate()
            var
            begin
                GlobalSetup.Get();
                Clear("Gross Pay");
                Clear("Net Pay");
                Clear("Sitting Allowance Tax");

                if "Sitting Allowance" > 0 then
                    "Gross Pay" := "Gross Pay" + "Sitting Allowance";

                if "Transport Allowance" > 0 then
                    "Gross Pay" := "Gross Pay" + "Transport Allowance";

                if Hospitality > 0 then
                    "Gross Pay" := "Gross Pay" + Hospitality;

                if "Sitting Allowance" > 0 then
                    "Sitting Allowance Tax" := "Sitting Allowance" * (GlobalSetup."Board Tax %" / 100);

                "Net Pay" := "Gross Pay" - "Sitting Allowance Tax";

            end;
        }
        field(11; "Transport Allowance"; Decimal)
        {
            Caption = 'Transport Reimbursement';
            trigger OnValidate()
            var
            begin
                Clear("Gross Pay");
                Clear("Net Pay");
                if "Sitting Allowance" > 0 then
                    "Gross Pay" := "Gross Pay" + "Sitting Allowance";

                if "Transport Allowance" > 0 then
                    "Gross Pay" := "Gross Pay" + "Transport Allowance";

                if Hospitality > 0 then
                    "Gross Pay" := "Gross Pay" + Hospitality;

                "Net Pay" := "Gross Pay" - "Sitting Allowance Tax";
            end;
        }
        field(12; "Hospitality"; Decimal)
        {
            trigger OnValidate()
            var
            begin
                Clear("Gross Pay");
                Clear("Net Pay");
                if "Sitting Allowance" > 0 then
                    "Gross Pay" := "Gross Pay" + "Sitting Allowance";

                if "Transport Allowance" > 0 then
                    "Gross Pay" := "Gross Pay" + "Transport Allowance";

                if Hospitality > 0 then
                    "Gross Pay" := "Gross Pay" + Hospitality;

                "Net Pay" := "Gross Pay" - "Sitting Allowance Tax";
            end;
        }
        field(13; "Sitting Allowance Tax"; Decimal)
        {
            Editable = false;
        }
        field(14; "Gross Pay"; Decimal)
        {
            Editable = false;
        }
        field(15; "Net Pay"; Decimal)
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
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;



}

