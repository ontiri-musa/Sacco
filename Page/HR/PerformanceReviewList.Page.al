page 50532 "Performance Review List"
{
    // version TL2.0

    CardPageID = "Performance Review Card";
    PageType = List;
    SourceTable = 50286;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Period; Period)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field(Branch; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field(Department; "Department Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

