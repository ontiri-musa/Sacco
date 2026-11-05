page 50184 "Standing Order Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Standing Order Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {

                field("Standing Order Nos."; "Standing Order Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group(Charges)
            {

                field("Charge Transaction"; "Charge Transaction")
                {
                    ApplicationArea = All;
                }
                field("Charges Calculation Method"; "Charges Calculation Method")
                {
                    ApplicationArea = All;
                }
                field("Charges Value"; "Charges Value")
                {
                    ApplicationArea = All;
                }

                field("Charges G/L Account"; "Charges G/L Account")
                {
                    ApplicationArea = All;
                }
            }


            group(Penalty)
            {
                Caption = 'Penalty';
                field("Charge Penalty"; "Charge Penalty")
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
                field("Penalty G/L Account"; "Penalty G/L Account")
                {
                    ApplicationArea = All;
                }

            }
            group(Notification)
            {
                Caption = 'Notification';
                field("Notify Source Member"; "Notify Source Member")
                {
                    ApplicationArea = All;
                }
                field("Source SMS Template"; "Source SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Source Email Template"; "Source Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notify Destination Member"; "Notify Destination Member")
                {
                    ApplicationArea = All;
                }
                field("Destination SMS Template"; "Destination SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Destination Email Template"; "Destination Email Template")
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
                field("Standing Order Template Name"; "Standing Order Template Name")
                {
                    ApplicationArea = All;
                }
                field("Standing Order Batch Name"; "Standing Order Batch Name")
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

