page 50448 "Employees Due For Confirmation"
{
    // version TL2.0

    Caption = 'Employees Due For Confirmation';
    CardPageID = "Employee Card TL";
    Editable = false;
    PageType = List;
    SourceTable = Employee;
    SourceTableView = WHERE("Employee Status" = filter('Probation'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a number for the employee.';
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = BasicHR;
                    NotBlank = true;
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s middle name.';
                    Visible = false;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = BasicHR;
                    NotBlank = true;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field(FullName; FullName)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the employee.';
                    Visible = false;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Employment Date"; "Employment Date")
                {
                }
                field("Probation End Date"; "Probation End Date")
                {
                }
            }
        }

    }


    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        SETFILTER("Probation End Date", '<=%1', TODAY);
        FILTERGROUP(0);
    end;

    var
        StyleText: Text;
}

