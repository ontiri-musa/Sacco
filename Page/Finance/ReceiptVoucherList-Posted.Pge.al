page 50628 "Receipt Voucher List-Posted"
{
    // version TL2.0
    Caption = 'Posted Receipt Vouchers';
    CardPageID = "Receipt Voucher";
    PageType = List;
    SourceTable = "Receipt Header";
    SourceTableView = WHERE(Status = FILTER(New),
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

                field("Payment Method"; "Payment Method")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
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
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = All;
                }
                field("Posted Date"; "Posted Date")
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

