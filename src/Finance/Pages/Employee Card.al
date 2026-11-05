page 50508 "Employee Payroll Card"
{
    Caption = 'Employee Payroll Card';
    CardPageID = "Employee Payroll Card";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Employee;
    layout
    {
        area(Content)
        {
            group(General)
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
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Marital Status"; "Marital Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Confirmation Status"; "Confirmation Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            group(Payroll)
            {
                field("Basic Pay"; "Basic Pay")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("FOSA Account"; "FOSA Account")
                {
                    ApplicationArea = All;
                }
                field("Pay Tax"; "Pay Tax")
                {
                    ApplicationArea = All;
                }
                field("Pension Non Contributor"; "Pension Non Contributor")
                {
                    ApplicationArea = All;
                }
                field(NHIF; NHIF)
                {
                    ApplicationArea = All;
                }
                field("PIN Number"; "PIN Number")
                {
                    ApplicationArea = All;
                }
                field("Employee Type"; "Employee Type")
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
    actions
    {
        area(Creation)
        {
            action(Print)
            {
                Caption = 'Pay Slip';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.SETRANGE("No.", "No.");
                    REPORT.RUN(50415, TRUE, TRUE, Rec);
                end;
            }
        }
        area(Processing)
        {
            action("Assign Earning")
            {
                Caption = 'Assign Earning';
                Image = Cost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "HR Earnings & Deductions";
                RunPageLink = "Employee No" = field("No."), Type = const(Payment), Closed = const(false);
                ApplicationArea = All;

            }
            action("Assign Deductions")
            {
                Caption = 'Assign Deductions';
                Image = CostCenter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "HR Earnings & Deductions";
                RunPageLink = "Employee No" = field("No."), Type = const(Deduction), Closed = const(false);
                ApplicationArea = All;

            }
            action(Imprest)
            {
                Caption = 'Create Imprest A/C';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    //CashManagement.CreateCustomer(Rec, AccountType::Imprest);
                end;

            }
            action(Salary)
            {
                Caption = 'Create Salary Advance A/C';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    //CashManagement.CreateCustomer(Rec, AccountType::"Salary Advance");
                end;
            }
        }

    }
    var
        AccountType: Option Imprest,"Salary Advance";
        CashManagement: Codeunit "Cash Management";
}

