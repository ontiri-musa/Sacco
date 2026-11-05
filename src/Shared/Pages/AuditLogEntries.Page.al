page 50385 "Audit Log Entries"
{
    // version MC2.0

    Editable = false;
    PageType = List;
    SourceTable = "Audit Log Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field(Action; Action)
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("Record ID Key"; "Record ID Key")
                {
                }
                field("Field Name"; "Field Name")
                {
                }
                field("Old Value"; "Old Value")
                {
                }
                field("New Value"; "New Value")
                {
                }
                field("Action Date"; "Action Date")
                {
                }
                field("Action Time"; "Action Time")
                {
                }
                field("User ID"; "User ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

