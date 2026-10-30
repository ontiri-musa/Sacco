page 50052 "Overdraft Charges"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Overdraft Charge";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Charge %"; "Charge %")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; "G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Normal Overdraft"; "Normal Overdraft")
                {
                    ApplicationArea = All;
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

    var
        myInt: Integer;
}