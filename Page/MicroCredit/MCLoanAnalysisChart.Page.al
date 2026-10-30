page 55105 "MC PAR Analysis Chart"
{
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
                    LoanAnalysisMgt.DrillDown(Rec);
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    LoanAnalysisMgt.OnOpenPage(LoanAnalysisSetup);
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
        LoanAnalysisSetup: Record "MC Loan Analysis Setup";
        OldLoanAnalysisSetup: Record "MC Loan Analysis Setup";
        LoanAnalysisMgt: Codeunit "Loan Analysis Mgt.";
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
        LoanAnalysisMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldLoanAnalysisSetup."Chart Type" <> LoanAnalysisSetup."Chart Type");

        OldLoanAnalysisSetup := LoanAnalysisSetup;

        if NeedsUpdate then;
        //  StatusText := LoanAnalysisSetup.GetCurrentSelectionText;

    end;

    local procedure RunSetup()
    begin
        // PAGE.RunModal(PAGE::"Trailing Members Setup", LoanAnalysisSetup);
        LoanAnalysisSetup.Get(UserId);
        UpdateStatus;
    end;
}