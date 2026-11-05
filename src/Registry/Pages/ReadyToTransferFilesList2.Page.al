page 55701 "Ready To Transfer Files List2"
{
    // version CBS-TL,REG

    CardPageID = "Ready For Transfer File Card";
    PageType = List;
    SourceTable = "File Movement";
    SourceTableView = WHERE(Status = CONST("Ready For Transfer"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("File Movement ID"; "File Movement ID")
                {
                }
                field("File No."; "File No.")
                {
                }
                field("File Name"; "File Name")
                {
                }
                field("From Location"; "From Location")
                {
                }
                field("To Location"; "To Location")
                {
                }
                field("Request Remarks"; "Request Remarks")
                {
                }
                field(Status; Status)
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Approval/Rejection Remarks"; "Approval/Rejection Remarks")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        //SETRANGE("From Location",User."Global Dimension 1 Code");
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.", 1);
        DimensionValue.SETRANGE(Code, User."Global Dimension 1 Code");
        IF DimensionValue.FIND('-') THEN BEGIN
            userbranch := DimensionValue.Name;
        END;
        //SETRANGE("From Location",User."Global Dimension 1 Code");
        SETRANGE("From Location", userbranch);
    end;

    var
        User: Record "User Setup";
        DimensionValue: Record "Dimension Value";
        userbranch: Text[20];
}

