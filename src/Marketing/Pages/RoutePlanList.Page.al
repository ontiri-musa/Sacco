page 51202 "Route Plan List"
{
    CardPageID = "Route Plan";
    PageType = List;
    SourceTable = "Route Plan";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                }
                field("Sales Person Name"; "Sales Person Name")
                {
                }
                field(Description; Description)
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
        SETRANGE("Created By", USERID);
    end;
}

