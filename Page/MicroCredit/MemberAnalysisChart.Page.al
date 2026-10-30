page 55104 "MC Account Analysis Chart"
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
                    MemberAnalysisMgt.DrillDown(Rec);
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    MemberAnalysisMgt.OnOpenPage(MemberAnalysisSetup);
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
        MemberAnalysisSetup: Record "Member Analysis Setup";
        OldMemberAnalysisSetup: Record "Member Analysis Setup";
        MemberAnalysisMgt: Codeunit "Member Accounts Analysis Mgt.";
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
        MemberAnalysisMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldMemberAnalysisSetup."Chart Type" <> MemberAnalysisSetup."Chart Type");

        OldMemberAnalysisSetup := MemberAnalysisSetup;

        if NeedsUpdate then;
        //  StatusText := MemberAnalysisSetup.GetCurrentSelectionText;

    end;

    local procedure RunSetup()
    begin
        // PAGE.RunModal(PAGE::"Trailing Members Setup", MemberAnalysisSetup);
        MemberAnalysisSetup.Get(UserId);
        UpdateStatus;
    end;
}