page 50013 "Member Application Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Member Application Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Phone No. Format"; "Phone No. Format")
                {
                    ApplicationArea = All;
                }

                field("Member No. Format"; "Member No. Format")
                {
                    ApplicationArea = All;
                }
                field("MA Individual Nos."; "MA Individual Nos.")
                {
                    ApplicationArea = All;
                }
                field("MA Group Nos."; "MA Group Nos.")
                {
                    ApplicationArea = All;
                }
                field("MA Company Nos."; "MA Company Nos.")
                {
                    ApplicationArea = All;
                }
                field("MA Joint Nos."; "MA Joint Nos.")
                {
                    ApplicationArea = All;
                }
                field("Member Nos."; "Member Nos.")
                {
                    ApplicationArea = All;
                }
                field("Junior Member Nos."; "Junior Member Nos.")
                {
                    ApplicationArea = All;
                }
                field("Enforce 18 Years and Above"; "Enforce 18 Years and Above")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee"; "Registration Fee")
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
                field("SMS Template (Dormancy)"; "SMS Template (Dormancy)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (No Savings)"; "SMS Template (No Savings)")
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
                field("Registration (Account Type)"; "Registration (Account Type)")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee Posting Group"; "Registration Fee Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee Template Name"; "Registration Fee Template Name")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee Batch Name"; "Registration Fee Batch Name")
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

