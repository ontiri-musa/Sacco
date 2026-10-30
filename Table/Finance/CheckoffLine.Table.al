table 50361 "Checkoff Line"
{

    fields
    {

        field(1; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Account Type"; enum "Gen. Journal Account Type")
        {

            trigger OnValidate()
            var

            begin
                if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::"Bank Account", "Account Type"::"Fixed Asset", "Account Type"::"IC Partner"] then
                    Error(AccountTypeNotAllowed, "Account Type");
            end;
        }
        field(5; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = filter(Customer)) "Loan Application" where(Posted = filter(true), "Member No." = field("Member No."), "Outstanding Balance" = filter(> 0))
            ELSE
            IF ("Account Type" = filter(Vendor)) Vendor WHERE("Vendor Type" = filter(1), "Member No." = field("Member No."))//, "Vendor Type" = CONST(2))
            ELSE
            IF ("Account Type" = filter("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = filter("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = filter("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin
                if "Account Type" = "Account Type"::Vendor then begin
                    Vendor.Get("Account No.");
                    "Account Name" := Vendor.Name;
                    Description := Vendor.Name;
                    Vendor.CalcFields(Balance);
                    "Account Balance" := Vendor.Balance;
                end;
                if "Account Type" = "Account Type"::Customer then begin
                    Customer.Get("Account No.");
                    "Account Name" := Customer.Name;
                    Description := Customer.Name;
                    Customer.CalcFields(Balance);
                    "Account Balance" := Customer.Balance;
                end;
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    GLAccount.Get("Account No.");
                    "Account Name" := GLAccount.Name;
                    Description := 'Unclaimed Payment';
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
        field(9; "Reference Code"; Code[20])
        {


        }
        field(12; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            var

            begin
                Member.Get("Member No.");
                "Member Name" := Member."Full Name";

            end;
        }
        field(13; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(14; "Account Balance"; Decimal)
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
        CheckoffLine.Reset();
        CheckoffLine.SetRange("Document No.", DocNo);
        CheckoffLine.DeleteAll();
    end;

    procedure CheckoffLinesExist(DocNo: Code[20]): Boolean
    var

    begin
        CheckoffLine.Reset();
        CheckoffLine.SetRange("Document No.", DocNo);
        exit(CheckoffLine.FindFirst());
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
        CheckoffHeader: Record "Checkoff Header";
        CheckoffLine: Record "Checkoff Line";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;



}

