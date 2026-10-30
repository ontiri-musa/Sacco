page 50509 "Employee Payroll List"
{


    Caption = 'Employee Payroll List';
    CardPageID = "Employee Payroll Card";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Employee;
    layout
    {
        area(Content)
        {
            repeater(group)
            {


                field("Employee No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Link; Links)
            {

            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then begin
                Error('You do not have permission to view this page');
            end;
        end;
    end;
}

