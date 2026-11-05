page 55705 "Registry Approvals"
{
    // version CBS-TL,REG

    PageType = List;
    SourceTable = "Registry Requests Approval";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                }
                field("HOD Approval"; "HOD Approval")
                {
                    ApplicationArea = All;
                }
                field("HOD Approver"; "HOD Approver")
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

