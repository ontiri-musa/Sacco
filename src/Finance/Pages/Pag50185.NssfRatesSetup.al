page 50185 "Nssf Rates Setup"
{
    ApplicationArea = All;
    Caption = 'Nssf Rates Setup';
    PageType = List;
    SourceTable = "NSSF Rates";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field("Tier I Lower Limit"; Rec."Tier I Lower Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tier I Lower Limit field.';
                }
                field("Tier II Upper Limit"; Rec."Tier II Upper Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tier II Upper Limit field.';
                }
                field("% Of Gross Pay"; Rec."% Of Gross Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the % Of Gross Pay field.';
                }
            }
        }
    }
}
