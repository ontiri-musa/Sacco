page 50653 "Payroll Cue"
{
    PageType = CardPart;

    SourceTable = "Payroll Cue";

    layout
    {
        area(Content)
        {
            cuegroup(PAYROLL)
            {
                field("Total Employees"; "Total Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Total Employees';
                    DrillDownPageId = "Employee Payroll List";

                }
                field("Total Earnings"; "Total Earnings")
                {
                    ApplicationArea = All;
                    Caption = 'Total Earning Lines';
                    DrillDownPageId = "Earnings Setup";
                }
                field("Total Deductions"; "Total Deductions")
                {
                    ApplicationArea = All;
                    Caption = 'Total Deduction Lines';
                    DrillDownPageId = "Deductions Setup";
                }
                field(ActivePayroll; ActivePayroll)
                {
                    ApplicationArea = All;
                    Caption = 'Active Payroll Employees ';
                }
                field(GrossEaning; GrossEaning)
                {
                    ApplicationArea = All;
                    Caption = 'Gross Pay';
                }
                field(Grossdedutoin; Grossdedutoin)
                {
                    ApplicationArea = All;
                    Caption = 'Total Deductions';
                }
                field(Netpay; Netpay)
                {
                    ApplicationArea = All;
                    Caption = 'Total Net Pay';
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        GrossEaning: Decimal;
        Grossdedutoin: Decimal;
        Netpay: Decimal;
        Employee: Record Employee;
        CurrentDate: Date;
        CurrentPayDate: Text;
        ActivePayroll: Integer;
        PayrollProcessing: Codeunit "Payroll Processing";

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then begin
                Error('You do not have permission to view this page');
            end;
        end;

        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
        Getpayroll();
    end;

    local procedure Getpayroll()
    var
        TotelEarn: Decimal;
    begin
        Grossdedutoin := 0;
        GrossEaning := 0;
        Netpay := 0;
        CurrentDate := PayrollProcessing.GetOpenPeriod();
        CurrentPayDate := 'MIKE';
        Employee.Reset();
        if Employee.FindSet(true) then begin
            repeat
                TotelEarn := 0;
                TotelEarn := PayrollProcessing.GetGrossPay(Employee, CurrentDate);
                if TotelEarn <> 0 then begin
                    ActivePayroll += 1;
                end;
                GrossEaning += TotelEarn;
                Grossdedutoin += PayrollProcessing.GetTotalDeductions(Employee, CurrentDate);
            until Employee.Next() = 0;
            Netpay := GrossEaning - Grossdedutoin;
        end;
    end;
}