page 58155 "Mobile Bk Deactiv List-Apprved"
{
    // version TL2.0

    Caption = 'Approved Mobile Banking Deactivations';
    CardPageID = "Mobile Banking Deactivation";
    PageType = List;
    SourceTable = "Mobile Banking Activ. Header";
    SourceTableView = WHERE(Status = FILTER(Approved), "Application Option" = Filter(Deactivation));

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

