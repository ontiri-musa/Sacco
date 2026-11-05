page 50390 "Guarantor Substitution Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Guarantor Substitution Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Guarantor Substitution Nos."; "Guarantor Substitution Nos.")
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
                    MultiLine = true;
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
                field("Notify Guarantor"; "Notify Guarantor")
                {
                    ApplicationArea = All;
                }
                field("Email Template (Guarantor)-New"; "Email Template (Guarantor)-New")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("SMS Template (Guarantor)-New"; "SMS Template (Guarantor)-New")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Email Template (Guarantor)-Approved"; "Email Template (Guarantor)-Approved")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("SMS Template (Guarantor)-Approved"; "SMS Template (Guarantor)-Approved")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            /*  action(ActionName)
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