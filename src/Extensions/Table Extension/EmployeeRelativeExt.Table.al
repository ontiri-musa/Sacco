tableextension 50217 "Employee Relative Ext" extends "Employee Relative"
{

    fields
    {
        field(50000; "Relation Type"; Option)
        {
            OptionMembers = "Next of Kin",Dependant,"Emergency Contact";
        }
    }
    keys
    {
    }

}
