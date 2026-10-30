page 50092 "Banks Branch"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Bank Branch";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; "Bank Name")
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

