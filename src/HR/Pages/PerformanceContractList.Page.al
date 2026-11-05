page 50930 "Performance Contract List"
{
    // version TL2.0

    CardPageID = "Performance Contract Header";
    PageType = List;
    SourceTable = "Performance Contract";
    SourceTableView=where(Submitted=filter('No'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal Year"; "Appraisal Year")
                {
                    ApplicationArea = All;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = All;
                }
                field(Branch;"Branch Name")
                {
                    ApplicationArea = All;
                }
                 field(Department;"Department Name")
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

