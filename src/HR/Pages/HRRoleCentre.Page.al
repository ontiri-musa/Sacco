page 50935 "HR Role Center"
{
    PageType = RoleCenter;
    Caption = 'HR RoleCenter';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Headline RC HR")
            {
                ApplicationArea = All;
            }
            part(Activities; HRCuePage)
            {
                ApplicationArea = All;
            }
            part("Report Inbox Part"; "Report Inbox Part")
            {
                Visible = false;
                ApplicationArea = All;
            }
            part(EmployeeChart; "Employee Analysis Chart")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("New Employee")
            {
                RunPageMode = Create;
                Caption = 'New Employee';
                ToolTip = 'Click here to create a new employee';
                Image = New;
                RunObject = page "Employee Card TL";
                ApplicationArea = All;
            }
            action("New Leave Application")
            {
                RunPageMode = Create;
                Caption = 'New Leave Application';
                ToolTip = 'Click here to create a new leave application';
                Image = New;
                RunObject = page "Leave Application Card";
                ApplicationArea = All;
            }
            action("New Job")
            {
                RunPageMode = Create;
                Caption = 'New Job';
                ToolTip = 'Click here to create a new job';
                Image = New;
                RunObject = page "Position Card";
                ApplicationArea = All;
            }
            action("New Training Request")
            {
                RunPageMode = Create;
                Caption = 'New  Training Request';
                Image = New;
                RunObject = page "Training Requests Card";
                ApplicationArea = All;
            }
            action("New Recruitment Request")
            {
                RunPageMode = Create;
                Image = New;
                RunObject = page "Recruitment Card";
                ApplicationArea = All;
            }
        }
        area(Processing)
        {
            group(Setups)
            {
                action("HR Setup")
                {
                    Caption = 'HR Setup';
                    RunObject = page "Human Resources Setup";
                    Image = Setup;
                    ApplicationArea = All;
                }
            }
            group(Tasks)
            {
                action("Create New Leave Period")
                {
                    Caption = 'Create New Leave Period';
                    Image = Process;
                    RunObject = page "Leave Periods";
                    ApplicationArea = All;
                }
            }
            group(Reports)
            {
                group("Leave Reports")
                {
                    action("Leave Balance Report")
                    {
                        Caption = 'Leave Balance Report';
                        ToolTip = 'Leave Balance Report';
                        Image = Report;
                        RunObject = report "Leave Balance";
                        ApplicationArea = All;
                    }
                    action("Leave Balance Quarterly Report")
                    {
                        Caption = 'Leave Balance Quarterly Report';
                        ToolTip = 'Leave Balance Quarterly Report';
                        Image = Report;
                        RunObject = report "Leave Balance Quarterly";
                        ApplicationArea = All;
                    }
                    action("Leave Utilization Report.")
                    {
                        Caption = 'Leave Utilization Report';
                        Image = Report;
                        RunObject = report "Leave Utilization Report";
                        ApplicationArea = All;
                    }
                    action("Leave Plan Report")
                    {
                        Caption = 'Leave Plan Report';
                        Image = Report;
                        RunObject = report "Leave Calendar Plan";
                        ApplicationArea = All;
                    }
                    action("Leave Recall Report.")
                    {
                        Caption = 'Leave Recall Report';
                        Image = Report;
                        RunObject = report "Leave Recall Report";
                        ApplicationArea = All;
                    }
                }
                group("Training Reports")
                {
                    action("Training Needs Report")
                    {
                        Caption = 'Training Needs Report';
                        Image = Report;
                        RunObject = report "Training Needs";
                        ApplicationArea = All;
                    }
                    action("Staff Training Report")
                    {
                        Caption = 'Staff Training Report';
                        ToolTip = 'Staff Training Report';
                        Image = Report;
                        RunObject = report "Staff Trained";
                        ApplicationArea = All;
                    }
                    action("Employee Training Report.")
                    {
                        Caption = 'Employee Training Report';
                        Image = Report;
                        RunObject = report "Employee Training Report";
                        ApplicationArea = All;
                    }
                    action("Monthly Staff Training Report.")
                    {
                        Caption = 'Monthly Staff Training Report';
                        Image = Report;
                        RunObject = report "Monthly Staff Training Report";
                        ApplicationArea = All;
                    }
                    action("Annual Staff Training Report.")
                    {
                        Caption = 'Annual Staff Training Report';
                        Image = Report;
                        RunObject = report "Annual Staff Training Report";
                        ApplicationArea = All;
                    }
                }

            }
            group(History)
            {
                action("Approved Leave Applications")
                {
                    RunPageMode = View;
                    Image = ListPage;
                    RunObject = page "Approved Leave Application";
                    ApplicationArea = All;
                }
                action("Approved Training Requests.")
                {
                    Caption = 'Approved Training Requests';
                    RunPageMode = View;
                    Image = ListPage;
                    RunObject = page "Approved Training Requests";
                    ApplicationArea = All;
                }
                action("Approved Recruitment Requests")
                {
                    RunPageMode = View;
                    Image = ListPage;
                    RunObject = page RecruitmentApproved;
                    ApplicationArea = All;
                }
            }
        }
        area(Reporting)
        {
            action("Employee Listing")
            {
                Caption = 'Employee Listing Report';
                ToolTip = 'Employee Listing';
                Image = Report;
                RunObject = report "Employee Report";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Report per Employee")
            {
                Caption = 'Report per Employee';
                ToolTip = 'Report per Employee';
                Image = Report;
                RunObject = report "Report Per Employee";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }

        }
        area(Embedding)
        {
            action("Employee List")
            {
                RunObject = page "Employee List TL";
                ApplicationArea = All;
            }
            action("Jobs List")
            {
                RunObject = page "Position List";
                ApplicationArea = All;
            }
            action("Leave Applications")
            {
                RunObject = page "Leave Application List";
                ApplicationArea = All;
            }
            action("Training Requests")
            {
                RunObject = page "Training Request List";
                ApplicationArea = All;
            }
            action("Position List")
            {
                RunObject = page "Position List";
                ApplicationArea = All;
            }
            action("Recruitment Requests")
            {
                RunObject = page "Recruitment List";
                ApplicationArea = All;
            }
            action("Performance Contracts.")
            {
                Caption = 'Performance Contracts';
                RunObject = page "Submitted Performance Contract";
                ApplicationArea = All;
            }

        }
        area(Sections)
        {
            group("Employee Management")
            {
                action("Active Employee List")
                {
                    RunObject = page "Employee List TL";
                    ApplicationArea = All;
                }
                action("Inactive Employee List")
                {
                    RunObject = page "Inactive Employee List TL";
                    ApplicationArea = All;
                }
                action("Employee Relatives")
                {
                    RunObject = page "Employee Relatives";
                    ApplicationArea = All;
                }
                group("Employee Reports")
                {
                    action("Employee Report")
                    {
                        RunObject = report "Employee Report";
                        ApplicationArea = All;
                    }

                    action("Employee Detail Report")
                    {
                        RunObject = report "Employee Details Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Probation Management")
            {
                action("Employees On Probation")
                {
                    RunObject = page "Employees On Probation";

                    ApplicationArea = All;
                }
                action("Employees Due For Confirmation")
                {
                    RunObject = page "Employees Due For Confirmation";
                    ApplicationArea = All;
                }

                action("Confirmed Employees")
                {
                    RunObject = page "Confirmed Employees";

                    ApplicationArea = All;
                }
                group("Probation Reports")
                {
                    action("Reference Check Report")
                    {
                        RunObject = report "Reference Check Report";
                        ApplicationArea = All;
                    }
                    action("Confirmed Employee Report")
                    {
                        RunObject = report "Confirmed Employee Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Leave Management")
            {
                group("Leave Application")
                {
                    action("Leave Application List")
                    {
                        RunObject = Page "Leave Application List";
                        ApplicationArea = All;
                    }
                    action("Leave Application Pending Approval")
                    {
                        RunObject = page "Leave App. Pending Approval";
                        ApplicationArea = All;
                    }
                    action("Approved Leave")
                    {
                        RunObject = Page "Approved Leave Application";
                        ApplicationArea = All;
                    }
                    action("Rejected Leave")
                    {
                        RunObject = Page "Rejected  Leave Application";
                        ApplicationArea = All;
                    }
                    action("Leave Journal")
                    {
                        RunObject = page "Leave Journal";
                        ApplicationArea = All;
                    }
                    action("Leave Period")
                    {
                        RunObject = page "Leave Periods";
                        ApplicationArea = All;
                    }
                    action("Leave Ledger Entry")
                    {
                        RunObject = page "Leave Ledger Entry";
                        ApplicationArea = All;
                    }
                }
                group("Leave Plan")
                {
                    action("Create Leave Plan")
                    {
                        RunObject = Page "Leave Plan List";
                        ApplicationArea = All;
                    }
                    action("Submitted Leave Plan")
                    {
                        RunObject = page "Submitted Leave Plan";
                        ApplicationArea = All;
                    }
                }

                group("Leave Recalls")
                {
                    action("Leave Recall")
                    {
                        RunObject = Page "Leave Recalls List";
                        ApplicationArea = All;
                    }
                    action("Submitted Leave Recall")
                    {
                        RunObject = page "Submitted Leave Recalls";
                        ApplicationArea = All;
                    }

                }
                group("Leave Report")
                {
                    action("Leave Balance")
                    {
                        RunObject = report "Leave Balance";
                        ApplicationArea = All;
                    }

                    action("Leave Balance Quarterly")
                    {
                        RunObject = report "Leave Balance Quarterly";
                        ApplicationArea = All;
                    }

                    action("Leave Recall Report")
                    {
                        RunObject = report "Leave Recall Report";
                        ApplicationArea = All;
                    }

                    action("Leave Calender Plan Report")
                    {
                        RunObject = report "Leave Calendar Plan";
                        ApplicationArea = All;
                    }

                    action("Leave Utilization Report")
                    {
                        RunObject = report "Leave Utilization Report";

                        ApplicationArea = All;
                    }
                    action("Calculate Leave Days")
                    {
                        RunObject = report "Calculate Leave Days Earned";

                        ApplicationArea = All;
                    }

                }
            }

            group("Staff Movements")
            {
                action("Staff Movement")
                {
                    RunObject = page "Employee Movement List";
                    ApplicationArea = All;
                }
                action("Posted Staff Movement")
                {
                    RunObject = page "Posted Employee Movement";
                    ApplicationArea = All;
                }
                group("Staff Movement Reports")
                {
                    action("Staff Posting")
                    {
                        RunObject = report "Staff Postings";
                        ApplicationArea = All;
                    }
                    action("Staff Transfer")
                    {
                        RunObject = report "Staff Transfers";
                        ApplicationArea = All;
                    }
                    action("Staff Promotions")
                    {
                        RunObject = report "Staff Promotions";
                        ApplicationArea = All;
                    }

                }
            }
            group("Job Management")
            {
                action("Job List")
                {
                    RunObject = page "Position List";
                    ApplicationArea = All;
                }

                action("Job Report")
                {
                    RunObject = report Positions;
                    ApplicationArea = All;
                }
                action("Job Description")
                {
                    RunObject = report "Job Description";
                    ApplicationArea = All;
                }
            }
            group("Training Management")
            {
                group("Employee Training Requests")
                {
                    action("Employee Training Request")
                    {
                        RunObject = page "Training Request List";
                        ApplicationArea = All;
                    }
                    action("Submitted Training Requests")
                    {
                        RunObject = page "Submitted Training Requests";
                        ApplicationArea = All;
                    }
                    action("Training Calendar")
                    {
                        RunObject = page "Training Calendar";
                        ApplicationArea = All;
                    }
                    action("Training Requests Pending Approval")
                    {
                        RunObject = page "Training Req. Pending Approval";
                        ApplicationArea = All;
                    }
                    action("Approved Training Requests")
                    {
                        RunObject = page "Approved Training Requests";
                        ApplicationArea = All;
                    }
                }
                group("Training Evaluation")
                {
                    action("Employee Training Evaluation")
                    {
                        RunObject = page "Employee Training Eval. List";
                        ApplicationArea = All;
                    }
                    action("Submitted Training Evaluation")
                    {
                        RunObject = page "Submitted Employee Eval.";
                        ApplicationArea = All;
                    }
                }
                group("Training Report")
                {
                    action("Training Need Report")
                    {
                        RunObject = report "Training Needs";
                        ApplicationArea = All;
                    }
                    action("Staff Trained Report")
                    {
                        RunObject = report "Staff Trained";

                        ApplicationArea = All;
                    }
                    action("Employee Training Report")
                    {
                        RunObject = report "Employee Training Report";
                        ApplicationArea = All;
                    }
                    action("Monthly Staff Training Report")
                    {
                        RunObject = report "Monthly Staff Training Report";
                        ApplicationArea = All;
                    }
                    action("Annual Staff Training Report")
                    {
                        RunObject = report "Annual Staff Training Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Separation Management")
            {
                action("Separation Application")
                {
                    RunObject = page "Separation List";
                    ApplicationArea = All;
                }
                action("Separation List-Processing")
                {
                    RunObject = page "Separation List-Processing";
                    ApplicationArea = All;
                }
                action("Processed Separations")
                {
                    RunObject = page "Approved Separation List";
                    ApplicationArea = All;
                }
                action("Separation Types Setup")
                {
                    RunObject = page "Separation Type Setup";
                    ApplicationArea = All;
                }
            }
            group("Recruitment & Selection")
            {
                group("Recruitement Request")
                {
                    action("Recruitment Request")
                    {
                        RunObject = page "Recruitment List";
                        ApplicationArea = All;
                    }
                    action("Recruitment Request Pending Approval")
                    {
                        RunObject = page "Recruitment Pending Approval";
                        ApplicationArea = All;
                    }
                    action("Recruitment Request Approved")
                    {
                        RunObject = page RecruitmentApproved;
                        ApplicationArea = All;
                    }
                    action("Recruitment Request Rejected")
                    {
                        RunObject = page "Recruitment Rejected";
                        ApplicationArea = All;
                    }
                }
                group("Job Applications")
                {
                    action("Job Application List")
                    {
                        RunObject = page "Job Application List";
                        ApplicationArea = All;
                    }
                    action("Shortlisted Job Applications")
                    {
                        RunObject = page "Short Listed Job Application";
                        ApplicationArea = All;
                    }
                    action("Recruitment Report")
                    {
                        RunObject = report "Recruitment Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Performance Management")
            {
                group("Performance Contracts")
                {
                    action("New Performance Contract")
                    {
                        RunObject = page "Performance Contract List";
                        ApplicationArea = All;
                    }
                    action("Submitted Performance Contract")
                    {
                        RunObject = page "Submitted Performance Contract";
                        ApplicationArea = All;
                    }
                }
                group("Performance Reviews")
                {
                    action("Performance Review")
                    {
                        RunObject = page "Performance Review List";
                        ApplicationArea = All;
                    }
                    action("Appraiser's Review List")
                    {
                        RunObject = page "Appraiser's Review List";
                        ApplicationArea = All;
                    }
                    action("Performance Review HR")
                    {
                        RunObject = page "Performance Review HR List";
                        ApplicationArea = All;
                    }
                }
                group("Performance Setup")
                {
                    Caption = 'Setups';
                    action("Quantitative Goals")
                    {
                        RunObject = page "Quantitative Goals";
                        ApplicationArea = All;
                    }
                    action("Qualitative Goals")
                    {
                        RunObject = page "Qualitative Goals";
                        ApplicationArea = All;
                    }
                }
                group("Performance Reports")
                {
                    Caption = 'Reports';
                    action("Performance Objective Guide")
                    {
                        RunObject = report "Performance Objectives Guide";
                        ApplicationArea = All;
                    }
                    action("Performance Contract")
                    {
                        RunObject = report "Performance Contract";
                        ApplicationArea = All;
                    }
                    action("Performance Appraisal Form")
                    {
                        RunObject = report "Performance Appraisal Form";
                        ApplicationArea = All;
                    }
                }
            }
            group("Disciplinary Management")
            {
                action("Disciplinary Cases")
                {
                    RunObject = page "Disciplinary Case List";
                    ApplicationArea = All;
                }

                action("Current Cases")
                {
                    RunObject = page "Current Cases";
                    ApplicationArea = All;
                }

                action("Legal Cases")
                {
                    RunObject = page "Legal Cases";
                    ApplicationArea = All;
                }

                action("Closed Cases")
                {
                    RunObject = page "Closed Cases";
                    ApplicationArea = All;
                }
                action("Appealed Cases")
                {
                    RunObject = page "Appealed Cases";
                    ApplicationArea = All;
                }
            }
            group(Audit)
            {
                group("HR Audit")
                {
                    action("Employee Data Change Request")
                    {
                        RunObject = page "Employee Data Change Request";
                        ApplicationArea = All;
                    }
                    action("Employee Data View")
                    {
                        RunObject = page "Employee Data View List";
                        ApplicationArea = All;
                    }
                    action("Employee Data Changes")
                    {
                        RunObject = page "Employee Data Changes";
                        ApplicationArea = All;
                    }
                }
                group("Audit Reports")
                {
                    action("Employee Data Change Report")
                    {
                        RunObject = report "Employee Data Change Report";
                        ApplicationArea = All;
                    }
                }
                action("Employee Data Changes Approval")
                {
                    RunObject = report "Employee Data Changes Approval";
                    ApplicationArea = All;
                }
            }
            group("HR Documents")
            {
                action("Documents")
                {
                    RunObject = page "Human Resource Doc";
                    ApplicationArea = All;
                }
                group("HR Reports")
                {
                    action("HR Uploaded Documents")
                    {
                        RunObject = report "HR Documents Report";
                        ApplicationArea = All;
                    }
                    action("HR Documents View")
                    {
                        RunObject = report "HR Documents View";
                        ApplicationArea = All;
                    }
                }
            }
            group("HR Setups")
            {
                action("Human Resources Setup")
                {
                    RunObject = page "Human Resources Setup";
                    ApplicationArea = All;
                }
                action("Leave Types Setup")
                {
                    RunObject = page "Leave Types";
                    ApplicationArea = All;
                }
                action("Training Evaluation Question")
                {
                    RunObject = page "Select Evaluation Questions";
                    ApplicationArea = All;
                }

            }
        }
    }

}
profile HRProfile
{
    ProfileDescription = 'HUMAN RESOURCES';
    RoleCenter = "HR Role Center";
    Caption = 'HUMAN RESOURCES';
}
