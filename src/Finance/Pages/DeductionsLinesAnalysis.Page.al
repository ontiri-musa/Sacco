page 50649 "Deduction Lines Analysis Chart"
{
    Caption = 'Deduction Lines Analysis Chart';
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
                    TrailingDeductionsMgt.DrillDown(Rec);
                end;


                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    TrailingDeductionsMgt.OnOpenPage(TrailingDeductionsSetup);
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
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Month)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Month';
                    Enabled = MonthEnabled;
                    ToolTip = 'Each stack covers one Month.';

                    trigger OnAction()
                    begin
                        TrailingDeductionsSetup.SetPeriodLength(TrailingDeductionsSetup."Period Length"::Month);
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
                        TrailingDeductionsSetup.SetPeriodLength(TrailingDeductionsSetup."Period Length"::Quarter);
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
                        TrailingDeductionsSetup.SetPeriodLength(TrailingDeductionsSetup."Period Length"::Year);
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
                            TrailingDeductionsSetup.SetChartType(TrailingDeductionsSetup."Chart Type"::"Stacked Area");
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
                            TrailingDeductionsSetup.SetChartType(TrailingDeductionsSetup."Chart Type"::"Stacked Area (%)");
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
                            TrailingDeductionsSetup.SetChartType(TrailingDeductionsSetup."Chart Type"::"Stacked Column");
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
                            TrailingDeductionsSetup.SetChartType(TrailingDeductionsSetup."Chart Type"::"Stacked Column (%)");
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
            SetActionsEnabled();
    end;

    trigger OnOpenPage()
    begin
        SetActionsEnabled();
    end;

    var
        TrailingDeductionsSetup: Record "Trailing Deductions Setup";
        OldTrailingDeductionsSetup: Record "Trailing Deductions Setup";
        TrailingDeductionsMgt: Codeunit "Trailing Deductions Mgt.";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        NoOfMembersEnabled: Boolean;
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
        TrailingDeductionsMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingDeductionsSetup."Period Length" <> TrailingDeductionsSetup."Period Length") or
           (OldTrailingDeductionsSetup."Use Work Date as Base" <> TrailingDeductionsSetup."Use Work Date as Base") or
          (OldTrailingDeductionsSetup."Chart Type" <> TrailingDeductionsSetup."Chart Type");

        OldTrailingDeductionsSetup := TrailingDeductionsSetup;

        if NeedsUpdate then
            StatusText := TrailingDeductionsSetup.GetCurrentSelectionText();

        SetActionsEnabled;

    end;

    local procedure RunSetup()
    begin
        TrailingDeductionsSetup.Get(UserId);
        UpdateStatus;
    end;

    procedure SetActionsEnabled()
    begin

        MonthEnabled := (TrailingDeductionsSetup."Period Length" <> TrailingDeductionsSetup."Period Length"::Month) and IsChartAddInReady;
        QuarterEnabled := (TrailingDeductionsSetup."Period Length" <> TrailingDeductionsSetup."Period Length"::Quarter) and IsChartAddInReady;
        YearEnabled := (TrailingDeductionsSetup."Period Length" <> TrailingDeductionsSetup."Period Length"::Year) and IsChartAddInReady;
        StackedAreaEnabled := (TrailingDeductionsSetup."Chart Type" <> TrailingDeductionsSetup."Chart Type"::"Stacked Area") and IsChartAddInReady;
        StackedAreaPctEnabled := (TrailingDeductionsSetup."Chart Type" <> TrailingDeductionsSetup."Chart Type"::"Stacked Area (%)") and IsChartAddInReady;
        StackedColumnEnabled := (TrailingDeductionsSetup."Chart Type" <> TrailingDeductionsSetup."Chart Type"::"Stacked Column") and IsChartAddInReady;
        StackedColumnPctEnabled := (TrailingDeductionsSetup."Chart Type" <> TrailingDeductionsSetup."Chart Type"::"Stacked Column (%)") and IsChartAddInReady;
    end;

}