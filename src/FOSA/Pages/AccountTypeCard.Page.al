page 50015 "Account Type Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Account Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Minimum Balance"; "Minimum Balance")
                {
                    ApplicationArea = All;
                }
                field("Dormancy Period"; "Dormancy Period")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee"; "Ledger Fee")
                {
                    ApplicationArea = All;
                }
                field("Can Guarantee Loan"; "Can Guarantee Loan")
                {
                    ApplicationArea = All;
                }

                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                group(SubType)
                {
                    Visible = Type = 1;
                    Caption = '';
                    field("Sub Type"; "Sub Type")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Applies to Member Category"; "Applies to Member Category")
                {
                    ApplicationArea = All;
                }
                field("Applies to Age Class"; "Applies to Age Class")
                {
                    ApplicationArea = All;
                }
                field("Allow Withdrawal"; "Allow Withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Allow Deposit"; "Allow Deposit")
                {
                    ApplicationArea = All;
                }

                field("Earns Interest"; "Earns Interest")
                {
                    ApplicationArea = All;
                }
                group(EarnInterest)
                {
                    Caption = '';
                    Visible = "Earns Interest" = TRUE;
                    field("Earn Commission on Interest"; "Earns Commission on Interest")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Earns Dividend"; "Earns Dividend")
                {
                    ApplicationArea = All;
                }

                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }

                group(Close)
                {
                    Caption = '';
                    Visible = CloseAccount;
                    field("Closing Fees"; "Closing Fees")
                    {
                        ApplicationArea = All;
                    }
                    field("Transfer Account After Closure"; "Transfer Account After Closure")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Maximum No. of Withdrawal"; "Maximum No. of Withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Maximum Withdrawal Amount"; "Maximum Withdrawal Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Deposit Amount"; "Maximum Deposit Amount")
                {
                    ApplicationArea = All;
                }
                field("Allow Multiple Accounts"; "Allow Multiple Accounts")
                {
                    ApplicationArea = All;
                }
                field("Allow Cheque Deposit"; "Allow Cheque Deposit")
                {
                    ApplicationArea = All;
                }
                field("Allow Cheque Withdrawal"; "Allow Cheque Withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Allow InterAccount Transfer"; "Allow InterAccount Transfer")
                {
                    ApplicationArea = All;
                }
                field("Open Automatically"; "Open Automatically")
                {
                    ApplicationArea = All;
                }
                field("Exclude from Closure"; "Exclude from Closure")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ClosingAccount;
                    end;
                }
            }
            group(Posting)
            {
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Posting Group"; "Ledger Fee Posting Group")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ClosingAccount;
    end;

    var
        CloseAccount: Boolean;

    local procedure ClosingAccount()
    begin
        IF "Exclude from Closure" = TRUE THEN BEGIN
            CloseAccount := FALSE;
        END ELSE BEGIN
            CloseAccount := TRUE;
        END;
    end;
}

