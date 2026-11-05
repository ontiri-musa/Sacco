page 57099 "Net Pay Transfer List-Posted"
{
    ApplicationArea = All;
    Caption = 'Net Pay Transfer List Posted';
    PageType = List;
    SourceTable = "Payroll Net Pay Transfer";
    CardPageId = "Net Pay Transfer Card Posted";
    SourceTableView = where(Posted = filter(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field("Paying Bank"; Rec."Paying Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank field.';
                }
                field("Paying Bank Name"; Rec."Paying Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank Name field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Date field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then begin
                Error('You do not have permission to view this page');
            end;
        end;
    end;
}
