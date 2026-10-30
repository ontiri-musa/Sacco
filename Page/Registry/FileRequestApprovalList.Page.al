page 55708 "File Request Approval List"
{
    // version CBS-TL,REG

    CardPageID = "File Request Approval Card";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "File Issuance";
    SourceTableView = WHERE("Request Status" = CONST("Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request ID"; "Request ID")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Required Date"; "Required Date")
                {
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Requisiton By"; "Requisiton By")
                {
                }
                field(Reason; Reason)
                {
                }
                field("Request Status"; "Request Status")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field("Approval Comment"; "Approval Comment")
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
        //SETRANGE("HOD Approver",USERID);
        FILTERGROUP(2);
        //SETRANGE("Branch Code",User."Global Dimension 1 Code");
        FILTERGROUP(2);
    end;

    var
        User: Record "User Setup";
}

