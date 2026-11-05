table 59361 "Loan Recovery Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(5; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application" where(Posted = filter(true), "Member No." = field("Member No."), "Outstanding Balance" = filter(> 0));
            trigger OnValidate();
            begin
                Customer.Get("Loan No.");
                "Account Name" := Customer.Name;
                Customer.CalcFields(Balance);
                "Account Balance" := Customer.Balance;
            end;
        }
        field(6; "Account Name"; Text[50])
        {
            Caption = 'Loan Product Name';
        }
        field(8; "Recovery Amount"; Decimal)
        {
        }
        field(9; "Deposits Account No."; Code[50])
        {
            TableRelation = Vendor;
        }
        field(10; "Deposits Balance"; Decimal)
        {
        }
        field(12; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            var
                Vend: Record Vendor;
                GlobalM: Codeunit "Global Management";
            begin
                Member.Get("Member No.");
                "Member Name" := Member."Full Name";
                "Deposits Account No." := GlobalM.GetMemberDepositsAcc(Member."No.");
                Vend.Get(GlobalM.GetMemberDepositsAcc(Member."No."));
                Vend.CalcFields(Balance);
                "Deposits Balance" := Vend.Balance;
            end;
        }
        field(13; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(14; "Account Balance"; Decimal)
        {
            Caption = 'Loan Balance';
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
        LoanRecovLine.Reset();
        LoanRecovLine.SetRange("Document No.", DocNo);
        LoanRecovLine.DeleteAll();
    end;

    procedure LoanRecovLinesExist(DocNo: Code[20]): Boolean
    var
    begin
        LoanRecovLine.Reset();
        LoanRecovLine.SetRange("Document No.", DocNo);
        exit(LoanRecovLine.FindFirst());
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
        LoanRecovLine: Record "Checkoff Line";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;



}

