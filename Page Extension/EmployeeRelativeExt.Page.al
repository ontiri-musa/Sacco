pageextension 50408 "Employee Relative Ext" extends "Employee Relatives"
{
    layout
    {
        addafter("Middle Name")
        {
            field("Last Name"; "Last Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Phone No.")
        {
            field("Relation Type"; "Relation Type")
            {
                ApplicationArea = All;
            }
        }
    }
}