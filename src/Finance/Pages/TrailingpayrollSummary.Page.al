page 50651 "Payroll Summary Analysis Chart"
{
    Caption = 'Payroll Summary Analysis';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(Content)
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
                    TrailingPayrollSummarysMgt.DrillDown(Rec);
                end;


                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    TrailingPayrollSummarysMgt.OnOpenPage(TrailingPayrollSummarySetup);
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
        area(Processing)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action(AllPayroll)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payroll Summary';
                    Enabled = AllPayrollEnabled;
                    ToolTip = 'View Payroll Summary, even with the future date';

                    trigger OnAction()
                    begin
                        TrailingPayrollSummarySetup.SetShowPayroll(TrailingPayrollSummarySetup."Show Payroll"::"Payroll Summary");
                        UpdateStatus;
                    end;
                }
            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;

                action(Month)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Month';
                    Enabled = MonthEnabled;
                    ToolTip = 'Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        TrailingPayrollSummarySetup.SetPeriodLength(TrailingPayrollSummarySetup."Period Length"::Month);
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
                        TrailingPayrollSummarySetup.SetPeriodLength(TrailingPayrollSummarySetup."Period Length"::Quarter);
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
                        TrailingPayrollSummarySetup.SetPeriodLength(TrailingPayrollSummarySetup."Period Length"::Year);
                        UpdateStatus;
                    end;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Image = SelectChart;
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
                            TrailingPayrollSummarySetup.SetChartType(TrailingPayrollSummarySetup."Chart Type"::"Stacked Area");
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
                            TrailingPayrollSummarySetup.SetChartType(TrailingPayrollSummarySetup."Chart Type"::"Stacked Area (%)");
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
                            TrailingPayrollSummarySetup.SetChartType(TrailingPayrollSummarySetup."Chart Type"::"Stacked Column");
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
                            TrailingPayrollSummarySetup.SetChartType(TrailingPayrollSummarySetup."Chart Type"::"Stacked Column (%)");
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
    end;

    var
        TrailingPayrollSummarySetup: Record "Trailing Payroll Summary Setup";
        OldTrailingPayrollSummarySetup: Record "Trailing Payroll Summary Setup";
        TrailingPayrollSummarysMgt: Codeunit "Trailing Payroll Summary Mgt.";
        StatusText: Text[250];
        AllPayrollEnabled: Boolean;
        [InDataSet]
        NeedsUpdate: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
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
        TrailingPayrollSummarysMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingPayrollSummarySetup."Period Length" <> TrailingPayrollSummarySetup."Period Length") or
          (OldTrailingPayrollSummarySetup."Show Payroll" <> TrailingPayrollSummarySetup."Show Payroll") or
           (OldTrailingPayrollSummarySetup."Use Work Date as Base" <> TrailingPayrollSummarySetup."Use Work Date as Base") or
          (OldTrailingPayrollSummarySetup."Value to Calculate" <> TrailingPayrollSummarySetup."Value to Calculate") or
          (OldTrailingPayrollSummarySetup."Chart Type" <> TrailingPayrollSummarySetup."Chart Type");

        OldTrailingPayrollSummarySetup := TrailingPayrollSummarySetup;

        if NeedsUpdate then
            StatusText := TrailingPayrollSummarySetup.GetCurrentSelectionText;

        SetActionsEnabled;
    end;

    local procedure RunSetup()
    begin
        TrailingPayrollSummarySetup.Get(UserId);
        UpdateStatus;
    end;

    procedure SetActionsEnabled()
    begin

        MonthEnabled := (TrailingPayrollSummarySetup."Period Length" <> TrailingPayrollSummarySetup."Period Length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (TrailingPayrollSummarySetup."Period Length" <> TrailingPayrollSummarySetup."Period Length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (TrailingPayrollSummarySetup."Period Length" <> TrailingPayrollSummarySetup."Period Length"::Year) and
          IsChartAddInReady;

        StackedAreaEnabled := (TrailingPayrollSummarySetup."Chart Type" <> TrailingPayrollSummarySetup."Chart Type"::"Stacked Area") and
          IsChartAddInReady;
        StackedAreaPctEnabled := (TrailingPayrollSummarySetup."Chart Type" <> TrailingPayrollSummarySetup."Chart Type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnEnabled := (TrailingPayrollSummarySetup."Chart Type" <> TrailingPayrollSummarySetup."Chart Type"::"Stacked Column") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (TrailingPayrollSummarySetup."Chart Type" <> TrailingPayrollSummarySetup."Chart Type"::"Stacked Column (%)") and
          IsChartAddInReady;
    end;
}