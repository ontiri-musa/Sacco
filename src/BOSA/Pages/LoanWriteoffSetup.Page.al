page 50333 "Loan Writeoff Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Writeoff Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan Writeoff Nos."; "Loan Writeoff Nos.")
                {
                    ApplicationArea = All;
                }
                field("LW G/L Control Account"; "LW G/L Control Account")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandatory"; "Attachment Mandatory")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {


                field("Loan Writeoff Template Name"; "Loan Writeoff Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Writeoff Batch Name"; "Loan Writeoff Batch Name")
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

