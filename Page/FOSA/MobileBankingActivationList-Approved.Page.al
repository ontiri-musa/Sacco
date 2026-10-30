page 50155 "Mobile Bk Activ. List-Approved"
{
    // version TL2.0

    Caption = 'Approved Mobile Banking Activations';
    CardPageID = "Mobile Banking Activation";
    PageType = List;
    SourceTable = "Mobile Banking Activ. Header";
    SourceTableView = WHERE(Status = FILTER(Approved), "Application Option" = Filter(Activation));

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

