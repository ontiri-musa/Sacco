table 50352 "Payroll Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PCode; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Total Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count (Employee);
        }
        field(3; "Total Earnings"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Earnings Setup" where("Non-Cash Benefit" = const(false)));
        }
        field(4; "Total Deductions"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Deductions Setup");
        }
    }

    keys
    {
        key(PK; PCode)
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