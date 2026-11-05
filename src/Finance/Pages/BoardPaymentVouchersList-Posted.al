page 56607 "Board PaymentV List-Posted"
{
    // version TL2.0

    CardPageID = "Board Payment Voucher";
    DataCaptionFields = "No.";
    PageType = List;
    SourceTable = "Board Payment Header";
    SourceTableView = WHERE(Status = filter(Approved),
                            Posted = filter(true));
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; "Payee Name")
                {
                    ApplicationArea = All;
                }

                field("Payment Mode"; "Payment Method")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Total Line Amount"; "Total Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Total VAT Amount"; "Total VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Tax Amount"; "Total Tax Amount")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; "Posted By")
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

