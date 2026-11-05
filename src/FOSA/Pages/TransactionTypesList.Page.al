page 50026 "Transaction Types List"
{
    // version TL2.0

    CardPageID = "Transaction Types Card";
    Caption = 'Transaction Types';
    PageType = List;
    SourceTable = "Transaction -Type";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Service ID"; "Service ID")
                {
                    ApplicationArea = All;
                }
                field("Application Area"; "Application Area")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

