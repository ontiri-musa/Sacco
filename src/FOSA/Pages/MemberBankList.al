page 50043 "Member Bank List"
{
    ApplicationArea = All;
    CardPageID = "Member Bank Card";
    Caption = 'Member Bank List';
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Category 6,Category 7,Category 8';
    PageType = List;
    SourceTable = Bank;
    UsageCategory = Lists;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
