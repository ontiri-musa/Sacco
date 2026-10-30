page 50135 "Church District List"
{
    ApplicationArea = All;
    Caption = 'Church District List';
    PageType = List;
    SourceTable = "Church District";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                    trigger OnValidate()
                    begin
                        TestField(Code);
                    end;
                }
            }
        }
    }
}
