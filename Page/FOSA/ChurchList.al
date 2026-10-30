page 50159 "Church List"
{
    ApplicationArea = All;
    Caption = 'Church List';
    PageType = List;
    SourceTable = Church;
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
                field("Church Section Code"; Rec."Church Section Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Church Section Code field.';
                    trigger OnValidate()
                    begin
                        TestField("Church District Code");
                    end;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                    trigger OnValidate()
                    begin
                        TestField("Church District Code");
                        TestField("Church Section Code");
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                    trigger OnValidate()
                    begin
                        TestField("Church District Code");
                        TestField("Church Section Code");
                        TestField(Rec.Code);
                    end;
                }
            }
        }
    }
}
