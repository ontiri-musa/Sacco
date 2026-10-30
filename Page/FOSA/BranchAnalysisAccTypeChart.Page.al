page 50355 "Branch Analysis-Acc Type Chart"
{
    Caption = 'Account Types Analysis';
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
                    TrailingAccountTypeMgt.DrillDown(Rec);
                end;

                // trigger DataPointDoubleClicked(point: DotNet BusinessChartDataPoint)
                // begin
                // end;


                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    TrailingAccountTypeMgt.OnOpenPage(TrailingAccTypeSetup);
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
        TrailingAccTypeSetup: Record "Trailing Account Type Setup";
        OldTrailingAccTypeSetup: Record "Trailing Account Type Setup";
        TrailingAccountTypeMgt: Codeunit "Trailing Account Types Mgt.";
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
        // TrailingAccountTypeMgt.UpdateData(Rec);
        /*   Update(CurrPage.BusinessChart);
          UpdateStatus;
          NeedsUpdate := false; */
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingAccTypeSetup."Chart Type" <> TrailingAccTypeSetup."Chart Type");

        OldTrailingAccTypeSetup := TrailingAccTypeSetup;

        if NeedsUpdate then;
        //  StatusText := TrailingAccTypeSetup.GetCurrentSelectionText;

    end;

    local procedure RunSetup()
    begin
        // PAGE.RunModal(PAGE::"Trailing Members Setup", TrailingAccTypeSetup);
        TrailingAccTypeSetup.Get(UserId);
        UpdateStatus;
    end;
}