table 50219 "HR Cue"
{

    fields
    {
        field(1; PK; Code[10])
        {

        }
        field(2; "Active Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where("Employee Status" = filter('Active|Confirmed')));
        }
        field(3; "Employees on Probation"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where("Employee Status" = filter('Probation')));
        }
        field(4; "Total Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee);
        }
        field(5; "New Leave Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Leave Application" where(Status = filter('New')));
        }
        field(6; "Leave Appl. Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Leave Application" where(Status = filter('Pending Approval')));
        }
        field(7; "Approved Leave Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Leave Application" where(Status = filter('Released')));
        }
        field(8; "New Training Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Training Request" where(Status = filter('New')));
        }
        field(9; "Training Req. Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Training Request" where(Status = filter('Pending Approval')));
        }
        field(10; "Approved Training Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Training Request" where(Status = filter('Released')));
        }
    }
    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}