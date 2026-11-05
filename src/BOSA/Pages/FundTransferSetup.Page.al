page 50226 "Fund Transfer Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Fund Transfer Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fund Transfer Nos."; "Fund Transfer Nos.")
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
                field("Fund Transfer Template Name"; "Fund Transfer Template Name")
                {
                    ApplicationArea = All;
                }
                field("Fund Transfer Batch Name"; "Fund Transfer Batch Name")
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

