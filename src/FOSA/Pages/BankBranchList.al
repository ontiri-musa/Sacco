page 50047 "Bank Branch List"
{
    CardPageID = "Bank Branch Card";
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Category 6,Category 7,Category 8';
    Caption = 'Bank Branch List';
    PageType = List;
    SourceTable = "Bank Branch";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.';
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
