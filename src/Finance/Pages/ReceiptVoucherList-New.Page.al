page 50624 "Receipt Voucher List-New"
{
    // version TL2.0
    Caption = 'New Receipt Vouchers';
    CardPageID = "Receipt Voucher";
    PageType = List;
    SourceTable = "Receipt Header";
    SourceTableView = WHERE(Status = FILTER(New),
                            Posted = filter(false));
    Editable = false;

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


            }
        }
    }

    actions
    {
    }
}

