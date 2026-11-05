table 50284 "Performance Contract"
{

    fields
    {
        field(1; "No."; Code[20])
        {

        }
        field(2; "Appraisal Year"; Integer)
        {
            TableRelation = "Appraisal Period";

            trigger OnValidate();
            begin
                IF AppraisalPeriod.GET("Appraisal Year") THEN BEGIN
                    "Appraisal Year" := AppraisalPeriod.Year;
                END;
            end;
        }
        field(4; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            var
                Employee: Record Employee;
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee.FullName();
                    "Department Code" := Employee.Department;
                    VALIDATE("Department Code");
                    "Branch Code" := Employee."Global Dimension 2 Code";
                    Validate("Branch Code");
                    "Employment Date" := Employee."Employment Date";
                    "Job Title" := Employee."Job Title";
                    InsertQualitativeGoals();
                    InsertQuantitativeGoals();
                END;
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(6; "Department Code"; Code[20])
        {
            trigger OnValidate()
            begin
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", 'DEPERTMENT');
                DimensionValue.SetRange(Code, "Department Code");
                if DimensionValue.FindFirst() then
                    "Department Name" := DimensionValue.Name;
            end;
        }
        field(7; "Job Title"; Code[20])
        {
            Editable = false;
        }
        field(8; "Employment Date"; date)
        {
            Editable = false;
        }
        field(9; "Branch Code"; Code[20])
        {
            Editable = false;
            trigger OnValidate()
            begin
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", 'BRANCH');
                DimensionValue.SetRange(Code, "Branch Code");
                if DimensionValue.FindFirst() then
                    "Branch Name" := DimensionValue.Name;
            end;
        }
        field(10; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(11; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(12; "Apprasier No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if Employee.Get("Apprasier No.") then begin
                    "Appraiser Name" := Employee.FullName();
                    "Appraiser Job Title" := Employee."Job Title";
                end;
            end;
        }
        field(13; "Appraiser Name"; Text[100])
        {
            Editable = false;
        }
        field(14; "Appraiser Job Title"; Text[100])
        {
            Editable = false;
        }
        field(15; Submitted; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }
    trigger OnInsert()
    begin
        HRSetup.Get();
        "No." := NoSeriesMgt.GetNextNo(HRSetup."Performance Contract Nos.", 0D, true);
    end;

    trigger OnDelete()
    begin
        DeleteQuantitativeLines();
        DeleteQualitativeLines();
    end;

    var
        AppraisalPeriod: Record 50260;
        Position: Record 50230;
        DimensionValue: Record "Dimension Value";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Management";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure InsertQuantitativeGoals()
    var
        QuantitativeGoals: Record "Quantitative Goal";
        QuantitativeLines: Record "Quantitative Goals Line";
    begin
        QuantitativeGoals.Reset();
        if QuantitativeGoals.FindSet() then begin
            repeat
                QuantitativeLines.Init();
                QuantitativeLines."No." := "No.";
                QuantitativeLines.Code := QuantitativeGoals.Code;
                QuantitativeLines.Description := QuantitativeGoals.Description;
                QuantitativeLines.Insert(true);
            until QuantitativeGoals.Next() = 0;
        end;
    end;

    local procedure InsertQualitativeGoals()
    var
        QualitativeGoals: Record "Qualitative Goal";
        QualitativeLines: Record "Qualitative Goals Line";
    begin
        QualitativeGoals.Reset();
        if QualitativeGoals.FindSet() then begin
            repeat
                QualitativeLines.Init();
                QualitativeLines."No." := "No.";
                QualitativeLines.Code := QualitativeGoals.Code;
                QualitativeLines.Description := QualitativeGoals.Description;
                QualitativeLines.Insert(true);
            until QualitativeGoals.Next() = 0;
        end;
    end;

    local procedure DeleteQuantitativeLines()
    var
        QuantitativeLines: Record "Quantitative Goals Line";
    begin
        QuantitativeLines.Reset();
        QuantitativeLines.SetRange("No.", "No.");
        QuantitativeLines.DeleteAll();
    end;

    local procedure DeleteQualitativeLines()
    var
        QualitativeLines: Record "Qualitative Goals Line";
    begin
        QualitativeLines.Reset();
        QualitativeLines.SetRange("No.", "No.");
        QualitativeLines.DeleteAll();
    end;
}

