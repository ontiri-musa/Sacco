tableextension 50015 GeneralJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Type Code"; Code[20])
        {
            TableRelation = "Transaction Type";
            trigger OnValidate()
            var
                PostingGroup: Code[100];
                LoanApplication: Record "Loan Application";
                LoanProd: Record "Loan Product Type";
                TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
                TType: Record "Transaction Type";
            begin
                PostingGroup := '';
                TransactionTypeCodeSetup.Get();
                If ("Account Type" = "Account Type"::Customer) and ("Member No" <> '') then begin
                    TestField("Account No.");
                    if TType.Get("Transaction Type Code") then begin
                        If TType."Is Loan Transaction Type" = false then
                            Error('%1 is not a loan transaction type code', "Transaction Type Code");
                    end;

                    LoanApplication.Reset();
                    LoanApplication.SetRange("No.", "Account No.");
                    if LoanApplication.FindFirst() then begin
                        LoanProd.Get(LoanApplication."Loan Product Type");
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" then
                            PostingGroup := LoanProd."Interest Due Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" then
                            PostingGroup := LoanProd."Interest Paid Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Paid" then
                            PostingGroup := LoanProd."Ledger Fee Due Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Ledger Fee Due" then
                            PostingGroup := LoanProd."Ledger Fee Paid Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Penalty Paid" then
                            PostingGroup := LoanProd."Penalty Due Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Penalty Due" then
                            PostingGroup := LoanProd."Penalty Paid Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Principal Paid" then
                            PostingGroup := LoanProd."Loan Posting Group";
                        If "Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment" then
                            PostingGroup := LoanProd."Loan Prepayment Posting Group";

                        "Posting Group" := PostingGroup;
                    end;
                    // Message('PG %1', PostingGroup);
                end;
            end;
        }
        field(50005; "Member No"; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            begin
                if "Member No" <> '' then begin

                end;
            end;

        }
        field(50002; "Account No. 2"; code[20])
        {
            Caption = 'Account No';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false))
            else
            IF ("Member No" = filter(''), "Account Type" = CONST(Customer)) Customer
            else
            IF ("Member No" = filter(''), "Account Type" = CONST(Vendor)) Vendor
            else
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            else
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            else
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            else
            IF ("Account Type" = CONST(Employee)) Employee
            else
            if ("Member No" = filter(<> ''), "Account Type" = CONST(Customer)) "Loan Application" where(Posted = filter(true), "Member No." = field("Member No"))
            else
            if ("Member No" = filter(<> ''), "Account Type" = CONST(Vendor)) Vendor where("Member No." = field("Member No"));
            trigger OnValidate()
            begin
                "Account No." := "Account No. 2";
                Validate("Account No.");
            end;
        }
    }

    var
        myInt: Integer;
}