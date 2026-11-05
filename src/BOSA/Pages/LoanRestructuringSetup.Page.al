page 51605 "Loan Restructuring Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Restructuring Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {


                field("Loan Rescheduling Nos."; "Loan Restructuring Nos.")
                {
                    ApplicationArea = All;
                }

                field("Restructuring Type"; "Restructuring Type")
                {
                    ApplicationArea = All;
                }
                field("Restructuring Method"; "Restructuring Method")
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
                field("Email Template (Pending Appr.)"; "Email Template (Pending Appr.)")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("SMS Template (Pending Appr.)"; "SMS Template (Pending Appr.)")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Email Template (Approved)"; "Email Template (Approved)")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("SMS Template (Approved)"; "SMS Template (Approved)")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Email Template (Rejected)"; "Email Template (Rejected)")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("SMS Template (Rejected)"; "SMS Template (Rejected)")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }

            }
            group(Posting)
            {

                field("Loan Restr. Template Name"; "Loan Restr. Template Name")
                {
                    ApplicationArea = All;
                }

                field("Loan Restr. Batch Name"; "Loan Restr. Batch Name")
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

