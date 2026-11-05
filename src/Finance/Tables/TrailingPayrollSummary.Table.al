table 50350 "Trailing Payroll Summary Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Text[132])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(3; "Show Payroll"; Option)
        {
            Caption = 'Show Payroll';
            OptionCaption = 'Payroll Summary,Gross Earnings,Gross Deductions,Net Pay';
            OptionMembers = "Payroll Summary","Gross Earnings","Gross Deductions","Net Pay";
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
        field(5; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount Excl. VAT,No. of Members';
            OptionMembers = "Amount Excl. VAT","No. of Members";
        }
        field(6; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = "Stacked Area","Stacked Area (%)","Stacked Column","Stacked Column (%)";
        }

    }

    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }

    var
        Text001: Label 'Updated at %1.';

    procedure GetCurrentSelectionText(): Text[100]
    begin
        exit(Format("Show Payroll") + '|'
        + ' View By: ' +
          Format("Period Length") + '|' +
          StrSubstNo(Text001, Time) + ')');
    end;

    procedure GetStartDate(): Date
    var
        StartDate: Date;
        FirstDateyear: Date;
    begin
        StartDate := GetPayrollPeriod();
        FirstDateyear := CalcDate('-CY', Today);
        if StartDate = 0D then begin
            StartDate := CalcDate('-CM', Today);
        end;
        exit(StartDate);
    end;

    local procedure GetPayrollPeriod(): Date
    var
        PayrollPeriod: Record "Payroll Period";
    begin
        PayrollPeriod.Reset();
        PayrollPeriod.SetRange(Closed, false);
        if PayrollPeriod.FindFirst() then
            exit(PayrollPeriod."Starting Date")
    end;

    procedure GetChartType(): Integer
    var
        BusinessChartBuf: Record "Business Chart Buffer";
    begin
        case "Chart Type" of
            "Chart Type"::"Stacked Area":
                exit(BusinessChartBuf."Chart Type"::StackedArea);
            "Chart Type"::"Stacked Area (%)":
                exit(BusinessChartBuf."Chart Type"::StackedArea100);
            "Chart Type"::"Stacked Column":
                exit(BusinessChartBuf."Chart Type"::StackedColumn);
            "Chart Type"::"Stacked Column (%)":
                exit(BusinessChartBuf."Chart Type"::StackedColumn100);
        end;
    end;

    procedure SetPeriodLength(PeriodLength: Option)
    begin
        "Period Length" := PeriodLength;
        Modify;
    end;

    procedure SetShowPayroll(ShowPayroll: Integer)
    begin
        "Show Payroll" := ShowPayroll;
        Modify;
    end;

    procedure SetValueToCalcuate(ValueToCalc: Integer)
    begin
        "Value to Calculate" := ValueToCalc;
        Modify;
    end;

    procedure SetChartType(ChartType: Integer)
    begin
        "Chart Type" := ChartType;
        Modify;
    end;




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