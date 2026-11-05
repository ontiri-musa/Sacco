table 50088 "Trailing Member Setup"
{
    Caption = 'Trailing Members Setup';

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
        field(3; "Show Members"; Option)
        {
            Caption = 'Show Members';
            OptionCaption = 'All Members,Members Until Today';
            OptionMembers = "All Members","Members Until Today";
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
        field(7; "Latest Member Created Date"; Date)
        {
            // AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Max (Member."Created Date");
            Caption = 'Latest Member Created Date';
            FieldClass = FlowField;
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

    procedure GetCurrentSelectionText(): Text[100]
    begin
        exit(Format("Show Members") + '|' +
          Format("Period Length") + '|' +
         Format("Value to Calculate") + '|. (' +
          StrSubstNo(Text001, Time) + ')');
    end;

    procedure GetStartDate(): Date
    var
        StartDate: Date;
    begin
        if "Use Work Date as Base" then
            StartDate := WorkDate()
        else
            StartDate := Today;
        if "Show Members" = "Show Members"::"All Members" then begin
            CalcFields("Latest Member Created Date");
            StartDate := "Latest Member Created Date";
        end;

        exit(StartDate);
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

    procedure SetShowMembers(ShowMembers: Integer)
    begin
        "Show Members" := ShowMembers;
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
}
