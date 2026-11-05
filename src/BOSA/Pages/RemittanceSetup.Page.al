page 50298 "Remittance Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Remittance Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {

                field("Member Remittance Advice Nos."; "Member Remittance Advice Nos.")
                {
                    ApplicationArea = All;
                }

                field("Agency Remittance Advice Nos."; "Agency Remittance Advice Nos.")
                {
                    ApplicationArea = All;
                }
                field("Rem. G/L Control Account"; "Rem. G/L Control Account")
                {
                    ApplicationArea = All;
                }
                field("Rem. Bank Control Account"; "Rem. Bank Control Account")
                {
                    ApplicationArea = All;
                }
            }
            group(External)
            {
                Caption = 'External';
                field("SQL Server"; "SQL Server")
                {
                    ApplicationArea = All;
                }
                field("SQL Database"; "SQL Database")
                {
                    ApplicationArea = All;
                }
                field("SQL User ID"; "SQL User ID")
                {
                    ApplicationArea = All;
                }
                field("SQL Password"; "SQL Password")
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
                field("Email Template"; "Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template"; "SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notification Channel"; "Notification Channel")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

