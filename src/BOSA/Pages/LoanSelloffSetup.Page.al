page 50312 "Loan Selloff Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Selloff Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan Selloff Nos."; "Loan Selloff Nos.")
                {
                    ApplicationArea = All;
                }
                field("Income G/L Account"; "Income G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandatory"; "Attachment Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Receiving Bank Account"; "Receiving Bank Account")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Loan Selloff Template Name"; "Loan Selloff Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Selloff Batch Name"; "Loan Selloff Batch Name")
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
                field("Email Template"; "Email Template")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("SMS Template"; "SMS Template")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Notification Channel"; "Notification Channel")
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

