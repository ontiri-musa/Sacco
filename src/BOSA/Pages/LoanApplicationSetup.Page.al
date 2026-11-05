page 50198 "Loan Application Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Application Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan Application Nos."; "Loan Application Nos.")
                {
                    ApplicationArea = All;
                }
                field("Loan Product Nos."; "Loan Product Nos.")
                {
                    ApplicationArea = All;
                }
                field("Loan Overpayment (Account Type)"; "Loan Overpayment (Account Type)")
                {
                    ApplicationArea = All;
                }
                field("Penalty Calculation Method"; "Penalty Calculation Method")
                {
                    ApplicationArea = All;
                }
                field("Penalty Value"; "Penalty Value")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee"; "Ledger Fee")
                {
                    ApplicationArea = All;
                }
                field("Pinno Comm On Mobile Loan Int Account"; "Pinno Comm On Mobile Loan Int Account")
                {
                    ApplicationArea = All;
                }
                field("Mobile Loan DCharges Account"; "Mobile Loan DCharges Account")
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
                field("Email Template (Pending Appr.)"; "Email Template (Pending Appr.)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Pending Appr.)"; "SMS Template (Pending Appr.)")
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
                field("Email Template (Rejected)"; "Email Template (Rejected)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Rejected)"; "SMS Template (Rejected)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Cleared)"; "SMS Template (Cleared)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Disbursed)"; "SMS Template (Disbursed)")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Notify Guarantor"; "Notify Guarantor")
                {
                    ApplicationArea = All;
                }
                field("Email Template (Guarantor)-New"; "Email Template (Guarantor)-New")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Guarantor)-New"; "SMS Template (Guarantor)-New")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Email Template (Guarantor)-Approved"; "Email Template (Guarantor)-Approved")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template (Guarantor)-Approved"; "SMS Template (Guarantor)-Approved")
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

                field("Loan Disbursal Template Name"; "Loan Disbursal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Disbursal Batch Name"; "Loan Disbursal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Interest Template Name"; "Loan Interest Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Interest Batch Name"; "Loan Interest Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Template Name"; "Ledger Fee Template Name")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Batch Name"; "Ledger Fee Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Penalty Template Name"; "Penalty Template Name")
                {
                    ApplicationArea = All;
                }
                field("Penalty Batch Name"; "Penalty Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery Template Name"; "Loan Recovery Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery Batch Name"; "Loan Recovery Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Repayment Template Name"; "Loan Repayment Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Repayment Batch Name"; "Loan Repayment Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Overpayment Template Name"; "Loan Overpayment Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Overpayment Batch Name"; "Loan Overpayment Batch Name")
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

