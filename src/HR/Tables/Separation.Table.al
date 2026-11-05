table 50237 Separation
{
    // version TL2.0


    fields
    {
        field(1; "Separation No"; Code[10])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            var
                Employee: Record 5200;
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee.FullName;
                    Department := Employee.Department;
                    Branch := Employee."Global Dimension 1 Code";
                    "Job Title" := Employee."Job Title";
                    "Employment Date" := Employee."Employment Date";
                    "Department Name" := Employee."Department Name";
                    "Basic Salary" := Employee."Basic Pay";
                    //InsertClearanceLines;
                    // InsertExitInterviewQuestions;
                END;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Separation Date"; Date)
        {
        }

        field(5; "Last Working Date"; Date)
        {
            trigger OnValidate();
            var
                NoofDays: Integer;
            begin
                IF "Last Working Date" < "Notification End Date" THEN
                    "Days In Lieu of Notice" := "Notification End Date" - "Last Working Date"
                ELSE
                    "Days In Lieu of Notice" := 0;
                Validate("Days In Lieu of Notice");

                if "Last Working Date" <> CalcDate('CM', "Last Working Date") then begin
                    "Part Salary Start Date" := CALCDATE('-CM', "Last Working Date");
                    "Part Salary End Date" := "Last Working Date";
                    "Salary For Extra Days" := "Part Salary End Date" - "Part Salary Start Date" + 1;
                end;
            end;
        }
        field(6; Department; Code[20])
        {
            Editable = false;
        }

        field(21; "Separation Type"; Text[100])
        {
            TableRelation = "Separation Type";

            trigger OnValidate();
            begin
                IF SeperationTypes.GET("Separation Type") THEN BEGIN
                    EVALUATE("Notice Period", FORMAT(FORMAT(SeperationTypes."Notice Period") + FORMAT('D')));
                    "Golden Handshake" := SeperationTypes."Golden Handshake";
                    "Transport Allowance" := SeperationTypes."Transport Allowance";
                    if SeperationTypes."Service Pay" = "Service Pay"::Yes then
                        "Severence Pay" := (Date2DMY(Today, 3) - Date2DMY("Employment Date", 3)) * "Basic Salary";
                END;
            end;
        }
        field(22; "Notification Start Date"; Date)
        {

            trigger OnValidate();
            begin
                VALIDATE("Notice Period");
                "Last Working Date" := "Notification End Date";
            end;
        }
        field(23; "Notification End Date"; Date)
        {
            Editable = false;
        }

        field(25; "In Lieu of Notice"; Decimal)
        {
        }
        field(26; "Notice Period"; DateFormula)
        {

            trigger OnValidate();
            begin
                "Notification End Date" := CALCDATE("Notice Period", "Notification Start Date");
            end;
        }
        field(27; "Golden Handshake"; Decimal)
        {
        }
        field(28; "Transport Allowance"; Decimal)
        {
        }
        field(29; "Service Pay"; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
        }
        field(30; "No. Of Months Salary"; Integer)
        {
            trigger OnValidate();
            begin
                "Salary For Full Month" := "No. Of Months Salary" * "Basic Salary";
            end;
        }
        field(33; "Leave balance"; Decimal)
        {
        }
        field(36; "Leave Accrual End Date"; Date)
        {
            trigger OnValidate()
            begin
                "Leave Days Earned to Date" := HRManagement.GetLeaveBalance("Employee No.", 'ANNUAL', "Leave Accrual End Date");
                "Outstanding Leave Days" := "Leave Days Earned to Date";
                Validate("Outstanding Leave Days");
            end;
        }
        field(37; "Reason for Separation"; Text[250])
        {
        }
        field(38; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }

        field(42; "Separation Status"; Option)
        {
            OptionCaption = 'New,Processing,Processed';
            OptionMembers = New,Processing,Processed;
        }
        field(44; "Employment Date"; Date)
        {
        }
        field(45; Branch; Text[50])
        {
        }
        field(47; "Job Title"; Text[100])
        {
        }

        field(49; "Department Name"; Text[100])
        {
        }
        field(51; "Leave Days Earned to Date"; Decimal)
        {
        }
        field(52; "Leave Days in Notice"; Decimal)
        {
            trigger OnValidate()
            begin
                "Outstanding Leave Days" := "Leave Days Earned to Date" - "Leave Days in Notice";
                "Pay for Outstanding Leave Days" := ("Outstanding Leave Days" * "Basic Salary" * 12) / 365;
                "Days In Lieu of Notice" := "Days In Lieu of Notice" - "Leave Days in Notice";
                ComputeTotal();
            end;
        }
        field(53; "Outstanding Leave Days"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pay for Outstanding Leave Days" := ("Outstanding Leave Days" * "Basic Salary" * 12) / 365;
                ComputeTotal();
            end;
        }
        field(54; "Basic Salary"; Decimal)
        {
        }
        field(55; "Salary For Full Month"; Decimal)
        {
        }
        field(56; "Salary For Extra Days"; Decimal)
        {

            trigger OnValidate();
            begin
                Validate("Part Salary to be paid");
            end;
        }
        field(57; "Leave Allowance Paid"; Decimal)
        {
        }
        field(58; "Car Allowance"; Decimal)
        {
        }
        field(59; "Days In Lieu of Notice"; Decimal)
        {
            trigger OnValidate()
            begin
                "Amount In Lieu of Notice" := ("Days In Lieu of Notice" * "Basic Salary" * 12) / 365;
            end;
        }
        field(60; "PAYE Due"; Decimal)
        {
        }
        field(64; "Part Salary to be paid"; Decimal)
        {

            trigger OnValidate();
            var
                NoofDays: Integer;
            begin
                NoofDays := CALCDATE('CM', "Part Salary End Date") - "Part Salary Start Date" + 1;
                "Part Salary to be paid" := ("Salary For Extra Days" / NoofDays) * "Basic Salary";
                ComputeTotal();
            end;
        }
        field(65; "Pay for Outstanding Leave Days"; Decimal)
        {
        }
        field(66; "Pay Car Allowance"; Boolean)
        {
            trigger OnValidate()
            begin
                if not "Pay Car Allowance" then begin
                    "No of Days for Car Allowance" := 0;
                    "No of Months Car Allowance" := 0;
                    "Car Allowance" := 0;
                    "Car Allowance(Months)" := 0;
                    "Part Car Allowance End Date" := 0D;
                    "Part Car Allowance Start Date" := 0D;
                end;
            end;
        }
        field(67; "No of Days for Car Allowance"; Decimal)
        {

        }
        field(68; "Pay Leave Allowance"; Boolean)
        {
            trigger OnValidate()
            var
                EarningsSetup: Record "Earnings Setup";
            begin
                if "Pay Leave Allowance" then begin
                    EarningsSetup.Reset();
                    EarningsSetup.SetRange(Description, 'Leave Allowance');
                    if EarningsSetup.FindFirst() then
                        "Leave Allowance Paid" := EarningsSetup."Flat Amount";
                end else
                    "Leave Allowance Paid" := 0;
                ComputeTotal();
            end;
        }
        field(69; "Total Deductions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Deduction Line".Amount WHERE("Employee No" = FIELD("Employee No.")));
            Editable = false;

        }
        field(70; Total; Decimal)
        {
            trigger OnValidate()
            begin
                ComputeTotal();
            end;
        }
        field(71; "Amount Payable"; Decimal)
        {
        }
        field(72; "Offset Leave Days"; Boolean)
        {
            trigger OnValidate();
            begin
                IF "Offset Leave Days" THEN BEGIN
                    IF "Days In Lieu of Notice" < "Outstanding Leave Days" THEN BEGIN
                        "Outstanding Leave Days" := "Outstanding Leave Days" - "Days In Lieu of Notice";
                        "Days In Lieu of Notice" := 0;
                        "Amount In Lieu of Notice" := ("Days In Lieu of Notice" * "Basic Salary" * 12) / 365;
                    END ELSE BEGIN
                        "Days In Lieu of Notice" := "Days In Lieu of Notice" - "Outstanding Leave Days";
                        "Amount In Lieu of Notice" := ("Days In Lieu of Notice" * "Basic Salary" * 12) / 365;
                        "Outstanding Leave Days" := 0;
                    END;
                    VALIDATE("Outstanding Leave Days");
                END ELSE BEGIN
                    Validate("Last Working Date");
                    "Outstanding Leave Days" := "Leave Days Earned to Date" - "Leave Days in Notice";
                    VALIDATE("Outstanding Leave Days");
                    "Amount In Lieu of Notice" := ("Days In Lieu of Notice" * "Basic Salary" * 12) / 365;
                END;
                ComputeTotal();
            end;
        }
        field(73; "Amount In Lieu of Notice"; Decimal)
        {
        }
        field(77; "Severence Pay"; Decimal)
        {
            trigger OnValidate()
            begin
                ComputeTotal();
            end;
        }
        field(78; "No of Years Worked"; Integer)
        {
        }
        field(79; "No of Months Car Allowance"; Decimal)
        {
        }
        field(80; "Car Allowance(Months)"; Decimal)
        {
        }
        field(81; "Total after PAYE"; Decimal)
        {
        }
        field(82; "Leave Start Date"; Date)
        {
            trigger OnValidate();
            begin
                "Leave End Date" := HRManagement.CalculateLeaveEndDate("Leave Days in Notice", "Leave Start Date");
                ComputeTotal();
            end;
        }
        field(83; "Leave End Date"; Date)
        {
        }
        field(84; "Part Salary Start Date"; Date)
        {
            trigger OnValidate();
            begin
                "Part Salary End Date" := CALCDATE(FORMAT("Salary For Extra Days" - 1) + 'D', "Part Salary Start Date");
                ComputeTotal();
            end;
        }
        field(85; "Part Salary End Date"; Date)
        {
        }
        field(86; "Part Car Allowance Start Date"; Date)
        {
            trigger OnValidate()
            begin
                "Part Car Allowance End Date" := (CalcDate(Format("No of Days for Car Allowance") + 'D', "Part Car Allowance Start Date"));
                ComputeTotal();
            end;
        }
        field(87; "Part Car Allowance End Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Separation No")
        {
        }
    }



    trigger OnInsert();
    begin
        HumanResSetup.GET;
        "Separation No" := NoSeriesMgt.GetNextNo(HumanResSetup."Separation No", 0D, TRUE);
    end;

    trigger OnModify();
    begin
        ComputeTotal();
    end;

    trigger OnDelete();
    begin
        if "Separation Status" <> "Separation Status"::New then
            Error(Error000);
    end;

    var
        Error000: Label 'You cannot delete this record!';
        Error001: Label 'You cannot modify this record!';
        NoSeriesMgt: Codeunit 396;
        CalMgt: Codeunit 7600;
        HRManagement: Codeunit 50050;
        SeperationTypes: Record 50238;
        HumanResSetup: Record 5218;
        HRSeparation: Record 50237;
        MonthBegin: Date;
        MonthEnd: Date;
        DaysInMonth: Integer;
        cDay: Date;
        CalendarCode: Code[10];
        DescriptionText: Text;
        MonthNo: Integer;
        YearNo: Integer;
        days: Integer;
        year: Integer;

        Employee: Record 5200;


    local procedure InsertClearanceLines();
    begin
    end;

    local procedure InsertExitInterviewQuestions();
    begin
    end;

    procedure ComputeTotal()
    var
        LookupTableLines: Record "Bracket Line";
        DeductionSetup: Record "Deductions Setup";
    begin
        Total := "Pay for Outstanding Leave Days" + "Salary For Full Month" + "Part Salary to be paid" + "Golden Handshake" + "Transport Allowance" + "Car Allowance(Months)" + "Car Allowance" + "Leave Allowance Paid";

        "PAYE Due" := 0;
        DeductionSetup.RESET;
        DeductionSetup.SETRANGE("PAYE Code", TRUE);
        IF DeductionSetup.FINDFIRST THEN BEGIN
            LookupTableLines.RESET;
            LookupTableLines.SETRANGE("Table Code", DeductionSetup."Deduction Table");
            IF LookupTableLines.FINDSET THEN BEGIN
                REPEAT
                    IF LookupTableLines."Upper Limit" < Total THEN BEGIN
                        "PAYE Due" += LookupTableLines."Amount Charged";
                    END;
                    IF (LookupTableLines."Lower Limit" < Total) AND (LookupTableLines."Upper Limit" > Total) THEN BEGIN
                        "PAYE Due" += (((Total - LookupTableLines."Lower Limit") * LookupTableLines.Percentage) / 100);
                    END;
                UNTIL LookupTableLines.NEXT = 0;
            END;
        END;
        //=====================subtract Relief================================
        LookupTableLines.RESET;
        LookupTableLines.SETRANGE("Table Code", 'RELIEF');
        IF LookupTableLines.FINDFIRST THEN BEGIN
            "PAYE Due" := "PAYE Due" - LookupTableLines."Amount Charged";
        END;
        //===================================================================
        "Total after PAYE" := Total - "PAYE Due";
        "Amount Payable" := "Total after PAYE" - "Amount In Lieu of Notice" - "Total Deductions";

    end;
}

