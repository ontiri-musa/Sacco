page 50237 "Exit Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Exit Setup";
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Member Exit Nos."; "Member Exit Nos.")
                {
                    ApplicationArea = All;
                }
                field("Member Archive Nos."; "Member Archive Nos.")
                {
                    ApplicationArea = All;
                }
                field("Refund Nos."; "Refund Nos.")
                {
                    ApplicationArea = All;
                }
                field("Insurance Claim Nos."; "Insurance Claim Nos.")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandatory"; "Attachment Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Refund Shares to Shares"; "Refund Shares to Shares")
                {
                    ApplicationArea = All;
                }
                field("Insurance G/L Account"; "Insurance G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Expense Account Type"; "Expense Account Type")
                {
                    ApplicationArea = All;
                }
                field("Expense Account No."; "Expense Account No.")
                {
                    ApplicationArea = All;
                }
                field("Income G/L Account"; "Income G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Debit FOSA Account Type"; "Debit FOSA Account Type")
                {
                    ApplicationArea = All;
                }
                field("Credit FOSA Account Type"; "Credit FOSA Account Type")
                {
                    ApplicationArea = All;
                }
            }
            group(Notification)
            {
                field("Notify Member"; "Notify Member")
                {
                    ApplicationArea = All;
                }
                field("Notification Channel"; "Notification Channel")
                {
                    ApplicationArea = All;
                }
                field("SMS Template"; "SMS Template")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Email Template"; "Email Template")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group(Posting)
            {
                field("Exit Template Name"; "Exit Template Name")
                {
                    ApplicationArea = All;
                }
                field("Exit Batch Name"; "Exit Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Refund Template Name"; "Refund Template Name")
                {
                    ApplicationArea = All;
                }
                field("Refund Batch Name"; "Refund Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Insurace Claim Template Name"; "Insurace Claim Template Name")
                {
                    ApplicationArea = All;
                }
                field("Insurace Claim Batch Name"; "Insurace Claim Batch Name")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
    }
}

