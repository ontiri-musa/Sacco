page 56303 "Loan Notification Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Notification Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Notification Channel"; "Notification Channel")
                {
                    ApplicationArea = All;
                }

                field("First Notification Template"; "First Notification Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Second Notification Template-Member"; "Second Notification Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Third Notification Template"; "Third Notification Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Fourth Notification Template"; "Fourth Notification Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("First Default Template"; "First Default Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Second Default Template"; "Second Default Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Third Default Template"; "Third Default Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Fourth Default Template"; "Fourth Default Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                field("Default SMS Nos"; "Default SMS Nos")
                {
                    //  MultiLine = true;
                    ApplicationArea = All;
                }

            }

        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
    end;

    var
        DemandLetterTemplate: Text;
}

