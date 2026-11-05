page 50152 "Church Section List"
{
    ApplicationArea = All;
    Caption = 'Church Section List';
    PageType = List;
    SourceTable = "Church Section";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Church District Code"; Rec."Church District Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Church District Code field.';
                }
                field("Code"; Rec."Code")
                {
                    Caption = 'Section Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                    trigger OnValidate()
                    begin
                        TestField("Church District Code");
                    end;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Section Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                    trigger OnValidate()
                    begin
                        TestField("Church District Code");
                        TestField(Rec.Code);
                    end;
                }
            }
        }
    }
}
