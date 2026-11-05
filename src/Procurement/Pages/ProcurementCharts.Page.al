page 50821 "Procurement Charts"
{

    Caption = 'Procurement Charts';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText; StatusText)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Status Text';
                Editable = false;
                ShowCaption = false;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic, Suite;

                trigger DataPointClicked(point: JsonObject)
                begin
                    ProcurementChartsMgt.DrillDown(Rec);
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    ProcurementChartsMgt.OnOpenPage(ProcurementCharts);
                    UpdateStatus;
                    if IsChartDataReady then
                        UpdateChart;
                end;

                trigger Refresh()
                begin
                    if IsChartAddInReady and IsChartDataReady then begin
                        NeedsUpdate := true;
                        UpdateChart
                    end;
                end;
            }

        }
    }
    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action(AllRequests)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Requests';
                    Enabled = AllRequestsEnabled;
                    ToolTip = 'View all Procurement requisitions Made';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetShowRequests(ProcurementCharts."Show Requests"::"All Requests");
                        UpdateStatus;
                    end;
                }
                action(MembersUntilToday)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Requests Until Today';
                    Enabled = RequestsUntilTodayEnabled;
                    ToolTip = 'View all requisitions until todays date.';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetShowRequests(ProcurementCharts."Show Requests"::"Requests Until Today");
                        UpdateStatus;
                    end;
                }

            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Day)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Day';
                    Enabled = DayEnabled;
                    ToolTip = 'Each stack covers one day.';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetPeriodLength(ProcurementCharts."Period Length"::Day);
                        UpdateStatus;
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Week';
                    Enabled = WeekEnabled;
                    ToolTip = 'Each stack except for the last stack covers one week. The last stack contains data from the start of the week until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetPeriodLength(ProcurementCharts."Period Length"::Week);
                        UpdateStatus;
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Month';
                    Enabled = MonthEnabled;
                    ToolTip = 'Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetPeriodLength(ProcurementCharts."Period Length"::Month);
                        UpdateStatus;
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;
                    ToolTip = 'Each stack except for the last stack covers one quarter. The last stack contains data from the start of the quarter until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetPeriodLength(ProcurementCharts."Period Length"::Quarter);
                        UpdateStatus;
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Year';
                    Enabled = YearEnabled;
                    ToolTip = 'Each stack except for the last stack covers one year. The last stack contains data from the start of the year until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        ProcurementCharts.SetPeriodLength(ProcurementCharts."Period Length"::Year);
                        UpdateStatus;
                    end;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Image = SelectChart;
                group(ValueToCalculate)
                {
                    Caption = 'Value to Calculate';
                    Image = Calculate;
                    action(Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Update Graph';
                        Enabled = AmountEnabled;
                        ToolTip = 'The Y-axis shows the totaled LCY amount of the Requests.';
                        Visible = false;

                        trigger OnAction()
                        begin
                            // TrailingEmployeeSetup.SetValueToCalcuate(TrailingEmployeeSetup."Value to Calculate"::"Amount Excl. VAT");
                            UpdateStatus;
                        end;
                    }
                    action(NoOfRequests)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Requests';
                        Enabled = NoOfRequestsEnabled;
                        ToolTip = 'The Y-axis shows the number of Requests.';

                        trigger OnAction()
                        begin
                            ProcurementCharts.SetValueToCalcuate(ProcurementCharts."Value to Calculate"::"No. of Requests");
                            UpdateStatus;
                        end;
                    }
                }
                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(StackedArea)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Area';
                        Enabled = StackedAreaEnabled;
                        ToolTip = 'View the data in area layout.';

                        trigger OnAction()
                        begin
                            ProcurementCharts.SetChartType(ProcurementCharts."Chart Type"::"Stacked Area");
                            UpdateStatus;
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;
                        ToolTip = 'view the percentage distribution of the four member statuses in area layout.';

                        trigger OnAction()
                        begin
                            ProcurementCharts.SetChartType(ProcurementCharts."Chart Type"::"Stacked Area (%)");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;
                        ToolTip = 'view the data in column layout.';

                        trigger OnAction()
                        begin
                            ProcurementCharts.SetChartType(ProcurementCharts."Chart Type"::"Stacked Column");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumnPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Column (%)';
                        Enabled = StackedColumnPctEnabled;
                        ToolTip = 'view the percentage distribution of the four member statuses in column layout.';

                        trigger OnAction()
                        begin
                            ProcurementCharts.SetChartType(ProcurementCharts."Chart Type"::"Stacked Column (%)");
                            UpdateStatus;
                        end;
                    }
                }
            }
            separator(Action25)
            {
            }
            action(Setup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Setup';
                Image = Setup;
                ToolTip = 'Specify if the chart will be based on a work date other than today''s date. This is mainly relevant in demonstration databases with fictitious Members.';

                trigger OnAction()
                begin
                    RunSetup;
                end;
            }
        }
    }
    trigger OnFindRecord(Which: Text): Boolean
    begin
        UpdateChart;
        IsChartDataReady := true;

        if not IsChartAddInReady then
            SetActionsEnabled;
    end;

    trigger OnOpenPage()
    begin
        SetActionsEnabled;
        ProcurementChartsMgt.OnOpenPage(ProcurementCharts);
    end;

    var
        //ProcurementCharts: Record "Trailing HR Setup";
        //OldTrailingEmployeeSetup: Record "Trailing HR Setup";
        //TrailingEmployeeMgt: Codeunit "Trailing HR Setup Mgt.";
        ProcurementCharts: Record "Procurement Graphs";
        OldProcurementCharts: Record "Procurement Graphs";
        ProcurementChartsMgt: Codeunit "Procurement Charts Mgt.";

        ChartMgt: Codeunit "Chart Management";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        AllRequestsEnabled: Boolean;
        RequestsUntilTodayEnabled: Boolean;
        [InDataSet]
        MembersUntilTodayEnabled: Boolean;
        [InDataSet]

        DayEnabled: Boolean;
        [InDataSet]
        WeekEnabled: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        NoOfRequestsEnabled: Boolean;
        [InDataSet]
        StackedAreaEnabled: Boolean;
        [InDataSet]
        StackedAreaPctEnabled: Boolean;
        [InDataSet]
        StackedColumnEnabled: Boolean;
        [InDataSet]
        StackedColumnPctEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;

    local procedure UpdateChart()
    begin
        if not NeedsUpdate then
            exit;
        if not IsChartAddInReady then
            exit;
        //TrailingEmployeeMgt.UpdateData(Rec);
        ProcurementChartsMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldProcurementCharts."Period Length" <> ProcurementCharts."Period Length") or
          (OldProcurementCharts."Show Requests" <> ProcurementCharts."Show Requests") or
           (OldProcurementCharts."Use Work Date as Base" <> ProcurementCharts."Use Work Date as Base") or
          (OldProcurementCharts."Value to Calculate" <> ProcurementCharts."Value to Calculate") or
          (OldProcurementCharts."Chart Type" <> ProcurementCharts."Chart Type");

        OldProcurementCharts := ProcurementCharts;

        if NeedsUpdate then
            StatusText := ProcurementCharts.GetCurrentSelectionText;

        SetActionsEnabled;
    end;

    local procedure RunSetup()
    begin
        /* ProcurementCharts.Reset();
        ProcurementCharts.setrange("User ID", UserId); */
        ProcurementCharts.Get(UserId);
        UpdateStatus;
    end;

    procedure SetActionsEnabled()
    begin
        AllRequestsEnabled := (ProcurementCharts."Show Requests" <> ProcurementCharts."Show Requests"::"Requests Until Today") and
          IsChartAddInReady;
        DayEnabled := (ProcurementCharts."Period Length" <> ProcurementCharts."Period Length"::Day) and
         IsChartAddInReady;
        WeekEnabled := (ProcurementCharts."Period Length" <> ProcurementCharts."Period Length"::Week) and
          IsChartAddInReady;
        MonthEnabled := (ProcurementCharts."Period Length" <> ProcurementCharts."Period Length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (ProcurementCharts."Period Length" <> ProcurementCharts."Period Length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (ProcurementCharts."Period Length" <> ProcurementCharts."Period Length"::Year) and
          IsChartAddInReady;
        NoOfRequestsEnabled :=
         (ProcurementCharts."Value to Calculate" <> ProcurementCharts."Value to Calculate"::"No. of Requests") and
         IsChartAddInReady;
        StackedAreaEnabled := (ProcurementCharts."Chart Type" <> ProcurementCharts."Chart Type"::"Stacked Area") and
          IsChartAddInReady;
        StackedAreaPctEnabled := (ProcurementCharts."Chart Type" <> ProcurementCharts."Chart Type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnEnabled := (ProcurementCharts."Chart Type" <> ProcurementCharts."Chart Type"::"Stacked Column") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (ProcurementCharts."Chart Type" <> ProcurementCharts."Chart Type"::"Stacked Column (%)") and
          IsChartAddInReady;
    end;


}
