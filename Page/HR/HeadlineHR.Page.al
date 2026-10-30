page 50938 "Headline HR"
{
    // NOTE: If you are making changes to this page you might want to make changes to all the other Headline RC pages

    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(GreetingText; StrSubstNo(Text000, GetUser.GetUser()))
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Control2)
            {
                field(ActiveEmployeeText; StrSubstNo(Text001, EmployeeCount))
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    trigger OnDrillDown();
                    begin
                        Employee.Reset();
                        if Employee.FindSet() then
                            page.Run(5201, Employee);
                    end;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GetEmployees();
    end;

    var
        [InDataSet]
        DefaultFieldsVisible: Boolean;
        [InDataSet]
        UserGreetingVisible: Boolean;
        Employee: Record Employee;
        EmployeeCount: Integer;
        DimensionValue: Record "Dimension Value";
        HRSummary: Record "HR Summary";
        SeeBirthday: Boolean;
        GetUser: Codeunit "Get User";
        Text000: Label 'Welcome %1 ';
        Text001: Label 'There are %1 active Employees';
        Text002: Label '%1 Employees are on leave today';
        Text003: Label '%1 Employees have their birthday today';

    local procedure GetEmployees()
    begin
        SeeBirthday := false;
        Employee.Reset();
        if Employee.FindSet() then begin
            EmployeeCount := Employee.Count;
        end;
    end;

    local procedure UpdateSummary()
    var
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        HRSummary.Reset();
        HRSummary.DeleteAll();

        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", 'BRANCH');
        if DimensionValue.FindSet() then begin
            repeat
                HRSummary.Init();
                HRSummary.Branch := DimensionValue.Code;
                Employee.Reset();
                Employee.SetRange("Global Dimension 1 Code", DimensionValue.Code);
                if Employee.FindSet() then begin
                    repeat
                        if Employee."Employee Status" = Employee."Employee Status"::Active then
                            i += 1;
                        if Employee."Employee Status" = Employee."Employee Status"::Probation then
                            j += 1;
                    until Employee.Next() = 0;
                    k := Employee.Count;
                end;
                HRSummary."Active Employees" := i;
                HRSummary."Employees on Probation" := j;
                HRSummary."Total Employees" := k;
                HRSummary.Insert();
            until DimensionValue.Next() = 0;
        end;

    end;
}
