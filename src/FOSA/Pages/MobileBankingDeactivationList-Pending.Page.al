page 58154 "Mobile Bk Deactiv List-Pending"
{
    // version TL2.0

    Caption = 'Pending Mobile Banking Deactivations';
    CardPageID = "Mobile Banking Deactivation";
    PageType = List;
    SourceTable = "Mobile Banking Activ. Header";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"), "Application Option" = Filter(Deactivation));

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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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

