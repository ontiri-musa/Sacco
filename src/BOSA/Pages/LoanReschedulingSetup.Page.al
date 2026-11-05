page 50267 "Loan Rescheduling Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Rescheduling Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {


                field("Loan Rescheduling Nos."; "Loan Rescheduling Nos.")
                {
                    ApplicationArea = All;
                }

                field("Rescheduling Type"; "Rescheduling Type")
                {
                    ApplicationArea = All;
                }
                field("Rescheduling Method"; "Rescheduling Method")
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

                field("Loan Resch. Template Name"; "Loan Resch. Template Name")
                {
                    ApplicationArea = All;
                }

                field("Loan Resch. Batch Name"; "Loan Resch. Batch Name")
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

