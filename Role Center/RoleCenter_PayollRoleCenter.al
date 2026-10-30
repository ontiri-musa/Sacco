page 50507 "Payroll Role Center"
{
    PageType = RoleCenter;
    Caption = 'Payroll Role Center', Comment = '{Dependency=Match,"ProfileDescription_PAYROLLMANAGER"}';
    layout
    {
        area(rolecenter)
        {
            part(Control104; "Payroll RoleCenter Headline")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payroll';
            }
            part(Activities; "Payroll Cue")
            {
                ApplicationArea = All;
                Caption = 'Payroll';
            }
            /*    part("Report Inbox Part"; "Report Inbox Part")
               {
                   ApplicationArea = All;
               } */

            part(EarningLinesAnalysis; "Earning Lines Analysis Chart")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Earnings Analysis';
            }
            part(DeductionLinesAnalysis; "Deduction Lines Analysis Chart")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deductions Analysis';
            }
            part(PayrollSummaryAnalysis; "Payroll Summary Analysis Chart")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payroll Summary Analysis';
            }
        }
    }
    actions
    {
        area(Sections)
        {
            group(Members)
            {
                Caption = 'Staff Members Lists';

                action(MembersStaff)
                {
                    Caption = 'Staff';
                    RunObject = Page MemberListStaff;
                    ApplicationArea = All;

                }
            }
            group("Employees Management")
            {
                Caption = 'Employees';
                action(Employees)
                {
                    Caption = 'HR Employees';
                    RunObject = page "Employee List";
                    ApplicationArea = All;
                }
                action("Payroll Employees")
                {
                    Caption = 'Payroll Employees';
                    RunObject = page "Employee Payroll List";
                    ApplicationArea = All;
                }
            }

            group("Periodic Activities")
            {
                action("Running Payroll")
                {
                    Caption = 'Running Payroll';
                    RunObject = report "Processing Payroll";
                    ApplicationArea = All;
                }
                action("Transfer Payroll To Journal")
                {
                    Caption = 'Transfer Payroll To Journal';
                    RunObject = report "Transfer Payroll To Journal";
                    ApplicationArea = All;
                }
                group(NetPayTransfer)
                {
                    Caption = 'Net Pay Transfer';
                    action(NewNetPayTransfer)
                    {
                        Caption = 'New Net Pay Transfer';
                        RunObject = page "Net Pay Transfer List-New";
                        ApplicationArea = All;
                    }
                    action(PostedNetPayTransfer)
                    {
                        Caption = 'Posted Net Pay Transfer';
                        RunObject = page "Net Pay Transfer List-Posted";
                        ApplicationArea = All;
                    }
                }

            }
            group(PayrollSetups)
            {
                Caption = 'Setups';
                action("Payroll Period Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pay Period Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Pay Period Setup";
                    ToolTip = 'Set up core functionality such as Pay Period Setup';
                }
                action("Payroll Earnings Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Earnings Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Earnings Setup";
                    ToolTip = 'Set up core functionality such as Earning Setup';
                }
                action("Deductions Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Deductions Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Deductions Setup";
                    ToolTip = 'Set up core functionality such as Deductions Setup';
                }
                action("Bracket Table Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bracket Table Setup';
                    Image = TaxPayment;
                    RunObject = Page "Bracket Table Setup";
                    ToolTip = 'Set up core functionality such as Bracket Table Setup';
                }
                action("Nssf Rates Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Nssf Rates Setup';
                    Image = TaxPayment;
                    RunObject = Page "Nssf Rates Setup";
                    ToolTip = 'Set up core functionality such as Nssf Rates Setup';
                }
                action("Payroll Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payroll Setup';
                    Image = Payroll;
                    RunObject = Page "Payroll Setup";
                    ToolTip = 'Set up core functionality such as Payroll Setup';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                action(staffPaySlip)
                {
                    Caption = 'Staff Payslip';
                    RunObject = report "staff PaySlip";
                    ApplicationArea = All;
                }
                action("Payroll Summary Report")
                {
                    Caption = 'Payroll Summary Report';
                    RunObject = report "Payroll Summary Report";
                    ApplicationArea = All;
                }
                action("Earnings Report")
                {
                    Caption = 'Earnings Report';
                    RunObject = report "Earnings Report";
                    ApplicationArea = All;
                }
                action("Deductions Report")
                {
                    Caption = 'Deductions Report';
                    RunObject = report "Deductions Report";
                    ApplicationArea = All;
                }
                action("Payroll Variance Report")
                {
                    Caption = 'Payroll Variance Report';
                    RunObject = report "Payroll Variance Report";
                    ApplicationArea = All;
                }
                action("Non Cash Report")
                {
                    Caption = 'Payroll Variance Report ';
                    RunObject = report "Payroll Variance Report";
                    ApplicationArea = All;
                }
                action("Loan Report")
                {
                    Caption = 'Loan Report';
                    RunObject = report "Loan Report";
                    ApplicationArea = All;
                }
                action("Provident Fund")
                {
                    Caption = 'Provident Fund';
                    RunObject = report "Provident Fund";
                    ApplicationArea = All;
                }
                action("P9A Report")
                {
                    Caption = 'P9A Report';
                    RunObject = report "P9A Report";
                    ApplicationArea = All;
                }
                action("P10 Report")
                {
                    Caption = 'P10 Report';
                    RunObject = report "P10 Report";
                    ApplicationArea = All;
                }
                action("P10A Report")
                {
                    Caption = 'P10A Report';
                    RunObject = report "P10A Report";
                    ApplicationArea = All;
                }
                action("NSSF Report")
                {
                    Caption = 'NSSF Report';
                    RunObject = report "NSSF Report";
                    ApplicationArea = All;
                }
                action("NHIF Report")
                {
                    Caption = 'NHIF Report';
                    RunObject = report "NHIF Report";
                    ApplicationArea = All;
                }
                action("PAYE Report")
                {
                    Caption = 'PAYE Report';
                    RunObject = report "PAYE Report";
                    ApplicationArea = All;
                }
                action("HELB Report")
                {
                    Caption = 'HELB Report';
                    RunObject = report "HELB Report";
                    ApplicationArea = All;
                }
            }
        }
        area(Embedding)
        {
            action("Employee Details")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payroll Employees';
                Image = Employee;
                RunObject = Page "Employee Payroll List";
                ToolTip = 'Open the Employee Details';
            }
            action(EmployeeList)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'HR Employees';
                Image = Employee;
                RunObject = Page "Employee List";
                ToolTip = 'Open the Employee Details';
            }
            action(EarningsList)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Earnings Setup';
                Image = SetupLines;
                RunObject = Page "Earnings Setup";
                ToolTip = 'Open the Employee Details';
            }
            action(DeductionsList)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deduction Setup';
                Image = SetupLines;
                RunObject = Page "Deductions Setup";
                ToolTip = 'Open the Employee Details';
            }
            action(PayrollPeriodList)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pay Period Setup';
                Image = SetupLines;
                RunObject = Page "Pay Period Setup";
                ToolTip = 'Open the Employee Details';
            }
        }
        area(Creation)
        {
            action("Earnings Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Earnings Setup';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "Earnings Setup";
                RunPageMode = Create;
                ToolTip = 'Create a new Earnings Setup';
            }
            action(DeductionsSetup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deductions Setup';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "Deductions Setup";
                RunPageMode = Create;
                ToolTip = 'Create a new Deductions Setup';
            }
            action(PayPeriodSetups)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pay Period Setup';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "Pay Period Setup";
                RunPageMode = Create;
                ToolTip = 'Create a new Pay Period Setup';
            }
            action(BracketTableSetup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bracket Table Setup';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "Bracket Table Setup";
                RunPageMode = Create;
                ToolTip = 'Create a new Bracket Table Setup';
            }
            action(PayrollSetup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payroll Setup';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "Payroll Setup";
                RunPageMode = Create;
                ToolTip = 'Create a new Payroll Setup';
            }
            action(GenJournal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General Journal';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "General Journal";
                ToolTip = 'Create a new Payroll Setup';
            }
        }
        area(Processing)
        {


        }
    }
}
profile PayrollProfile
{
    ProfileDescription = 'Payroll Role Center';
    RoleCenter = "Payroll Role Center";
    Caption = 'PAYROLL';
}