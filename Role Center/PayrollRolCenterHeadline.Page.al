page 50652 "Payroll RoleCenter Headline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                Visible = UserGreetingVisible;
                field(GreetingText; RCHeadlinesPageCommon.GetGreetingText())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Greeting headline';
                    Editable = false;
                }
            }
            group(Control2)
            {
                ShowCaption = false;
                Visible = DefaultFieldsVisible;
                field(DocumentationText; GetCurrentPayPeriod())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documentation headline';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        HyperLink(RCHeadlinesPageCommon.DocumentationUrlTxt());
                    end;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Order Processor");
        DefaultFieldsVisible := RCHeadlinesPageCommon.AreDefaultFieldsVisible();
        UserGreetingVisible := RCHeadlinesPageCommon.IsUserGreetingVisible();
    end;

    var
        [InDataSet]
        DefaultFieldsVisible: Boolean;
        [InDataSet]
        UserGreetingVisible: Boolean;
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
        PayrollPeriod: Record "Payroll Period";

    local procedure GetCurrentPayPeriod(): Text
    var

    begin
        PayrollPeriod.Reset();
        PayrollPeriod.SetRange(Closed, false);
        if PayrollPeriod.FindFirst() then begin
            exit('The current open Pay period is: ' + PayrollPeriod.Name + ' ' + Format(DATE2DMY(PayrollPeriod."Starting Date", 3)));
        end;
    end;

}