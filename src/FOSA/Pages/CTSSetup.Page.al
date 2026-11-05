page 50157 "CTS Setup"
{
    // version CTS2.0

    PageType = Card;
    SourceTable = "CTS Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Cheque Book Nos."; "Cheque Book Nos.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Book Application Nos."; "Cheque Book Application Nos.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Clearance Nos."; "Cheque Clearance Nos.")
                {
                    ApplicationArea = All;
                }

                field("Charges Per Leaf"; "Charges Per Leaf")
                {
                    ApplicationArea = All;
                }
                field("Charges G/L Account"; "Charges G/L Account")
                {
                    ApplicationArea = All;
                }

                field("Cheque Clearance Account"; "Cheque Clearance Account")
                {
                    ApplicationArea = All;
                }
                field("Clearance Charges"; "Clearance Charges")
                {
                    ApplicationArea = All;
                }

                field("Commission G/L Account"; "Commission G/L Account")
                {
                    ApplicationArea = All;
                }

                field("SMS Charges"; "SMS Charges")
                {
                    ApplicationArea = All;
                }
                field("SMS G/L Account"; "SMS G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Penalty G/L Account"; "Penalty G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Charge Excise Duty"; "Charge Excise Duty")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Cheque Template Name"; "Cheque Template Name")
                {
                    ApplicationArea = All;
                }
                field("Cheque Batch Name"; "Cheque Batch Name")
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

