page 50322 "Dividend Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Dividend Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Dividend Nos."; "Dividend Nos.")
                {
                    ApplicationArea = All;
                }
                field("Dividend Rate %"; "Dividend Rate %")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate %"; "Interest Rate %")
                {
                    ApplicationArea = All;
                }
                field("Commission Amount"; "Commission Amount")
                {
                    ApplicationArea = All;
                }
                field("Commission G/L Account"; "Commission G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Dividend Control G/L Account"; "Dividend Control G/L Account")
                {
                    ApplicationArea = All;
                }
                field("FOSA Account Type"; "FOSA Account Type")
                {
                    ApplicationArea = All;
                }
                field("Charge Withholdig Tax"; "Charge Withholdig Tax")
                {
                    ApplicationArea = All;
                }
                field("Charge Excise Duty"; "Charge Excise Duty")
                {
                    ApplicationArea = All;
                }
                field("Topup Shares"; "Topup Shares")
                {
                    ApplicationArea = All;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                field("Notify Member"; "Notify Member")
                {
                    ApplicationArea = All;
                }
                field("Notification Channel"; "Notification Channel")
                {
                    ApplicationArea = All;
                }
                field("Dividend SMS Template"; "Dividend SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Dividend Email Template"; "Dividend Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Interest SMS Template"; "Interest SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Interest Email Template"; "Interest Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Dividend Template Name"; "Dividend Template Name")
                {
                    ApplicationArea = All;
                }
                field("Dividend Batch Name"; "Dividend Batch Name")
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

