page 55180 "Automations Log Entries"
{
    ApplicationArea = All;
    Caption = 'Automations Log Entries';
    PageType = List;
    SourceTable = "Automation Log Entries";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Automation Code"; Rec."Automation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Automation Code field.';
                }
                field("Run Date"; Rec."Run Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Run Date field.';
                }
                field("Next Run Date"; Rec."Next Run Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Run Date field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
            }
        }
    }
}
