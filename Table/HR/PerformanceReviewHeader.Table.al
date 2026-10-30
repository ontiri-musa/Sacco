table 50286 "Performance Review Header"
{
    fields
    {
        field(1; "Review No."; Code[20])
        {
            Editable = false;
        }
        field(2; Period; Code[20])
        {
            Editable = false;
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            var
                AppraisalPeriod: Record "Appraisal Period";
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Full Name" := Employee.FullName();
                    "Branch Code" := Employee."Global Dimension 1 Code";
                    Validate("Branch Code");
                    "Department Code" := Employee."Global Dimension 2 Code";
                    VALIDATE("Department Code");
                    "Employment Date" := Employee."Employment Date";
                    "Job Title" := Employee."Job Title";
                    Period := HRManagement.GetCurrentAppraisalPeriod();
                    Commit();
                    AppraisalPeriod.Reset();
                    AppraisalPeriod.SetRange(Active, true);
                    if AppraisalPeriod.FindFirst() then
                        HRManagement.FetchJobCompetencyLines("Employee No.", "Job Title", AppraisalPeriod.Year, Period, "Review No.");
                END;
            end;
        }
        field(4; "Job Title"; Text[100])
        {
            Editable = false;
        }
        field(5; "Department Code"; Code[20])
        {

            trigger OnValidate();
            begin
                IF DimensionValue.GET('DEPARTMENT', "Department Code") THEN BEGIN
                    "Department Name" := DimensionValue.Name;
                END;
            end;
        }
        field(6; "Appraiser Name"; Text[250])
        {
        }
        field(7; "KPI Score"; Code[20])
        {
        }
        field(8; "Full Name"; Text[100])
        {
        }
        field(9; "Branch Code"; Code[20])
        {
            trigger OnValidate();
            begin
                IF DimensionValue.GET('BRANCH', "Department Code") THEN BEGIN
                    "Branch Name" := DimensionValue.Name;
                END;
            end;
        }
        field(10; "Branch Name"; Text[100])
        {
            Editable = false;
        }
        field(12; "Score is Final"; Boolean)
        {
            trigger OnValidate();
            begin
                Validate("Total Score");
            end;

        }
        field(13; "Total Score"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Performance Competency Line-Qt"."Agreed Score" WHERE("Review No." = FIELD("Review No.")));
            Editable = false;

        }
        field(14; Posted; Boolean)
        {
        }
        field(15; "Posted By"; Code[20])
        {
        }
        field(16; "Posted Date"; Date)
        {
        }
        field(17; "Posted Time"; Time)
        {
        }
        field(18; "Development Needs"; Text[250])
        {
        }
        field(19; "Career Plan"; Text[250])
        {
        }
        field(20; "Employees Comments"; Text[250])
        {
        }
        field(21; "Appraisers Comments"; Text[250])
        {
        }

        field(23; "JD Updated"; Boolean)
        {
        }
        field(24; "Employment Date"; Date)
        {
        }
        field(25; "Appraiser Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Appraiser Employee No.") THEN BEGIN
                    "Appraiser Name" := Employee.FullName;
                    "Appraiser Job Title" := Employee."Job Title";
                END;
            end;
        }
        field(26; "Appraiser Job Title"; Text[100])
        {
        }
        field(27; "KPI Description"; Text[100])
        {
        }
        field(28; "Overall Reviewer Recommend"; Text[250])
        {
        }
        field(29; "KPI Comments"; Text[250])
        {
        }
        field(30; "Development Needs Employee"; Text[250])
        {
        }
        field(31; "Career Plan Employee"; Text[250])
        {
        }
        field(32; "Document Date"; Date)
        {
            Editable = false;
        }
        field(33; "Appraisal Agreement Reached"; Boolean)
        {
        }
        field(34; "Released to Appraiser"; Boolean)
        {
            Editable = false;
        }
        field(35; "Released to HR Admin"; Boolean)
        {
            Editable = false;
        }
        field(36; "Department Name"; Text[100])
        {
        }

    }

    keys
    {
        key(Key1; "Review No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        HumanResourcesSetup.GET;
        "Review No." := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Performance Review Nos.", 0D, TRUE);
    end;


    trigger OnDelete();
    begin
        if "Released to HR Admin" then
            Error(Error000);
    end;

    var
        Error000: Label 'You cannot delete this record!';
        Error001: Label 'You cannot modify this record!';
        NoSeriesManagement: Codeunit 396;
        HRManagement: Codeunit 50050;
        UserSetup: Record 91;
        Employee: Record 5200;
        Position: Record 50230;
        DimensionValue: Record 349;

        HumanResourcesSetup: Record 5218;

        AppraisalPeriod: Record 50260;
        TempPeriod: Integer;
}

