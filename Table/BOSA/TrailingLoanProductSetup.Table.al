table 50090 "Trailing Loan Product Setup"
{
    Caption = 'Trailing Loan Products Setup';

    fields
    {
        field(1; "User ID"; Text[132])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }

        field(2; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = "Stacked Area","Stacked Area (%)","Stacked Column","Stacked Column (%)";
        }
        field(3; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Updated at %1.';

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

    procedure SetChartType(ChartType: Integer)
    begin
        "Chart Type" := ChartType;
        Modify;
    end;

    procedure SetPeriodLength(PeriodLength: Option)
    begin
        "Period Length" := PeriodLength;
        Modify;
    end;

    procedure GetStartDate(): Date
    var
        StartDate: Date;
        FirstDateyear: Date;
    begin
        //StartDate := GetPayrollPeriod();
        FirstDateyear := CalcDate('-CY', Today);
        if StartDate = 0D then begin
            StartDate := CalcDate('-CM', Today);
        end;
        exit(StartDate);
    end;

    procedure GetCurrentSelectionText(): Text[100]
    begin
        exit('Loan Approved Amount Per Product' + '|'
        + ' View By: ' +
          Format("Period Length") + '|' +
          StrSubstNo(Text001, Time) + ')');
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
