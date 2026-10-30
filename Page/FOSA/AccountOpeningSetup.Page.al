page 50014 "Account Opening Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Account Opening Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account No. Format"; "Account No. Format")
                {
                    ApplicationArea = All;
                }

                field("Account Opening Nos."; "Account Opening Nos.")
                {
                    ApplicationArea = All;
                }
                field("Account Activation Nos."; "Account Activation Nos.")
                {
                    ApplicationArea = All;
                }
                field("Closing Account Nos."; "Closing Account Nos.")
                {
                    ApplicationArea = All;
                }
                field("Closure Fee GL Account"; "Closure Fee GL Account")
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
                field("Email Template (PendingApprov)"; "Email Template (PendingApprov)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (PendingApprov)"; "SMS Template (PendingApprov)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Email Template (Approved)"; "Email Template (Approved)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Approved)"; "SMS Template (Approved)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Email Template (Additional)"; "Email Template (Additional)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Additional)"; "SMS Template (Additional)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notification Channel"; "Notification Channel")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Ledger Fee Template Name"; "Ledger Fee Template Name")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Batch Name"; "Ledger Fee Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Fixed/Call Dep. Template Name"; "Fixed/Call Dep. Template Name")
                {
                    ApplicationArea = All;
                }
                field("Fixed/Call Dep. Batch Name"; "Fixed/Call Dep. Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Account Closure Template Name"; "Account Closure Template Name")
                {
                    ApplicationArea = All;
                }
                field("Account Closure Batch Name"; "Account Closure Batch Name")
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

