page 50357 "Classification Summary Chart"
{
    Caption = 'Classification Summary';
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
                    //        SetDrillDownIndexes(point);
                    TrailingLoanClassificationMgt.DrillDown(Rec);
                end;

                // trigger DataPointDoubleClicked(point: DotNet BusinessChartDataPoint)
                // begin
                // end;


                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    TrailingLoanClassificationMgt.OnOpenPage(TrailingClassificationSetup);
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



    trigger OnFindRecord(Which: Text): Boolean
    begin
        UpdateChart;
        IsChartDataReady := true;

        if not IsChartAddInReady then;
    end;

    trigger OnOpenPage()
    begin
        ;
    end;

    var
        TrailingClassificationSetup: Record "Trailing Classification Setup";
        OldTrailingClassificationSetup: Record "Trailing Classification Setup";
        TrailingLoanClassificationMgt: Codeunit "Trailing Loan Class. Mgt.";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]

        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;

    local procedure UpdateChart()
    begin
        if not NeedsUpdate then
            exit;
        if not IsChartAddInReady then
            exit;
        TrailingLoanClassificationMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingClassificationSetup."Chart Type" <> TrailingClassificationSetup."Chart Type");

        OldTrailingClassificationSetup := TrailingClassificationSetup;

        if NeedsUpdate then;
        //  StatusText := TrailingClassificationSetup.GetCurrentSelectionText;

    end;

    local procedure RunSetup()
    begin
        // PAGE.RunModal(PAGE::"Trailing Members Setup", TrailingClassificationSetup);
        TrailingClassificationSetup.Get(UserId);
        UpdateStatus;
    end;
}