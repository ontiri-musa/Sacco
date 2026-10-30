page 55103 "Branch Loan Disbursal Chart"
{
    Caption = 'Loan Product Types Analysis';
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
                    BranchAnalysisMgt.DrillDown(Rec);
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    BranchAnalysisMgt.OnOpenPage(BranchAnalysisSetup);
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
        BranchAnalysisSetup: Record "Branch Analysis Setup";
        OldBranchAnalysisSetup: Record "Branch Analysis Setup";
        BranchAnalysisMgt: Codeunit "Branch Analysis Mgt.";
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
        BranchAnalysisMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldBranchAnalysisSetup."Chart Type" <> BranchAnalysisSetup."Chart Type");

        OldBranchAnalysisSetup := BranchAnalysisSetup;

        if NeedsUpdate then;
        //  StatusText := BranchAnalysisSetup.GetCurrentSelectionText;

    end;

    local procedure RunSetup()
    begin
        // PAGE.RunModal(PAGE::"Trailing Members Setup", BranchAnalysisSetup);
        BranchAnalysisSetup.Get(UserId);
        UpdateStatus;
    end;
}