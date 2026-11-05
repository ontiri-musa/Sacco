page 50108 "Mobile Banking Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Mobile Banking Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Mobile Banking Appl. Nos."; "Mobile Banking Appl. Nos.")
                {
                    ApplicationArea = All;
                }
                field("Mobile Banking Activation Nos."; "Mobile Banking Activation Nos.")
                {
                    ApplicationArea = All;
                }
                field("Loan Repay SMS Template"; "Loan Repay SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Mobile Banking Template Name"; "Mobile Banking Template Name")
                {
                    ApplicationArea = All;
                }
                field("Mobile Banking Batch Name"; "Mobile Banking Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Paybill Bank"; "Paybill Bank")
                {
                    ApplicationArea = All;
                }
                field("Mpesa B2C"; "Mpesa B2C")
                {
                    ApplicationArea = All;
                }
                field("KCB Bank"; "KCB Bank")
                {
                    ApplicationArea = All;
                }
                field("Co-operative Bank"; "Co-operative Bank")
                {
                    ApplicationArea = All;
                }
                field("Equity Bank"; "Equity Bank")
                {
                    ApplicationArea = All;
                }
                field("Old Paybill"; "Old Paybill")
                {
                    ApplicationArea = All;
                }
                Field(Suspense; Suspense)
                {
                    ApplicationArea = All;
                }
                Field("KCB Bank Suspense"; "KCB Bank Suspense")
                {
                    ApplicationArea = All;
                }
                Field("Co-operative Bank Suspense"; "Co-operative Bank Suspense")
                {
                    ApplicationArea = All;
                }
                Field("Equity Bank Suspense"; "Equity Bank Suspense")
                {
                    ApplicationArea = All;
                }
                Field("Old Paybill Suspense"; "Old Paybill Suspense")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            /* action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            } */
        }
    }

    var
        myInt: Integer;
}