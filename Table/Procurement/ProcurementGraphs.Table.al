table 50426 "Procurement Graphs"
{
    Caption = 'Procurement Graphs';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            Caption = 'Key';
            DataClassification = ToBeClassified;
        }

        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(3; "Show Requests"; Option)
        {
            Caption = 'Show Requests';
            OptionCaption = 'All Requests,Requests Until Today';
            OptionMembers = "All Requests","Requests Until Today";
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
        field(5; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount Excl. VAT,No. of Requests';
            OptionMembers = "Amount Excl. VAT","No. of Requests";
        }
        field(6; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = "Stacked Area","Stacked Area (%)","Stacked Column","Stacked Column (%)";
        }
        field(7; "Latest Order Document Date"; Date)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Max ("Sales Header"."Document Date" WHERE("Document Type" = CONST(Order)));
            Caption = 'Latest Order Document Date';
            FieldClass = FlowField;
        }
        field(8; "User ID"; Text[132])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9; "Latest Requisition Date"; Date)
        {
            // AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Max ("Requisition Header"."Requisition Date");
            Caption = 'Latest Requisition Date';
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
        exit(Format("Show Requests") + '|' +
          Format("Period Length") + '|. (' +
          StrSubstNo(Text001, Time) + ')');
    end;

    procedure GetStartDate(): Date
    var
        StartDate: Date;
    begin
        if "Use Work Date as Base" then
            StartDate := WorkDate
        else
            StartDate := Today;
        if "Show Requests" = "Show Requests"::"All Requests" then begin
            CalcFields("Latest Requisition Date");
            StartDate := "Latest Requisition Date";
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

    procedure SetShowRequests(ShowRequests: Integer)
    begin
        "Show Requests" := ShowRequests;
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
