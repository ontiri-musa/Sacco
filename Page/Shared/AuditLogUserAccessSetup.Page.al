page 50384 "Audit Log User Access Setup"
{
    // version MC2.0

    Caption = 'User Access Setup';
    PageType = List;
    SourceTable = "Audit Log Field User Access";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                }
                field(Allow; Allow)
                {
                }
            }
        }
    }

    actions
    {
    }
}

