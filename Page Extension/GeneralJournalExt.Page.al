pageextension 50006 GeneralJournalExt extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Amount)
        {
            field("Debit Amount2"; "Debit Amount")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if ("Account Type" = "Account Type"::Customer) and ("Member No" <> '') then begin
                        TestField("Transaction Type Code");
                    end;
                end;
            }
            field("Credit Amount2"; "Credit Amount")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if ("Account Type" = "Account Type"::Customer) and ("Member No" <> '') then begin
                        TestField("Transaction Type Code");
                    end;
                end;
            }

        }
        modify(Amount)
        {
            trigger OnBeforeValidate()
            begin
                if ("Account Type" = "Account Type"::Customer) and ("Member No" <> '') then begin
                    TestField("Transaction Type Code");
                end;
            end;
        }

        addafter("Document No.")
        {
            field("Member No"; "Member No")
            {
                ApplicationArea = All;
            }
        }
        addafter("Account Type")
        {
            field("Account No. 2"; "Account No. 2")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Clear("Posting Group");
                end;
            }
        }
        modify("Account No.")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }

        addafter(Description)
        {
            field("Transaction Type Code"; "Transaction Type Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    TransCodeSetup: Record "Transaction Type Code Setup";
                    LProd: Record "Loan Product Type";
                    Cust: Record Customer;

                begin
                    TransCodeSetup.Get();
                    if ("Account Type" = "Account Type"::Customer) and ("Member No" <> '') then begin
                        if "Account No." <> '' then begin
                            If Cust.Get("Account No.") then begin
                                LProd.Get(Cust."Customer Posting Group");
                                /*if ("Transaction Type Code" = TransCodeSetup."Interest Due") or ("Transaction Type Code" = TransCodeSetup."Interest Paid") then begin
                                    // Message('Posting Group %1', LProd."Interest Due Posting Group");
                                    "Posting Group" := LProd."Interest Due Posting Group";
                                    Modify();
                                end;
                                if ("Transaction Type Code" = TransCodeSetup."Penalty Due") or ("Transaction Type Code" = TransCodeSetup."Penalty Paid") then begin
                                    "Posting Group" := LProd."Penalty Due Posting Group";
                                    Modify();
                                end;
                                if ("Transaction Type Code" = TransCodeSetup."Ledger Fee Due") or ("Transaction Type Code" = TransCodeSetup."Ledger Fee Paid") then begin
                                    "Posting Group" := LProd."Ledger Fee Due Posting Group";
                                    Modify();
                                end;
                                if ("Transaction Type Code" = TransCodeSetup."Loan Prepayment") then begin
                                    "Posting Group" := LProd."Loan Prepayment Posting Group";
                                    Modify();
                                end;
                                if ("Transaction Type Code" = TransCodeSetup."Insurance Fee") then begin
                                    "Posting Group" := '5534';
                                    Modify();
                                end;*/
                                CurrPage.Update();
                            end;
                            if (Amount <> 0) then
                                TestField("Transaction Type Code");
                        end;
                    end;
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            trigger OnAfterAction()
            begin

            end;
        }
    }

    var
        myInt: Integer;
}