page 50386 "Audit Log Table Fields Setup"
{
    // version MC2.0

    Caption = 'Table Fields Setup';
    PageType = List;
    SourceTable = "Audit Log Table Field Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table No."; "Table No.")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("Field No."; "Field No.")
                {
                }
                field("Field Name"; "Field Name")
                {
                }
                field("On Insert"; "On Insert")
                {
                }
                field("On Modify"; "On Modify")
                {
                }
                field("On Delete"; "On Delete")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("User Access")
            {
                Image = UserSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Audit Log User Access Setup";
                RunPageLink = "Field No." = FIELD("Field No."),
                              "Field No." = FIELD("Field No.");
            }
        }
    }
}

