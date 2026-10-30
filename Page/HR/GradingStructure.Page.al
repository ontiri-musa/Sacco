page 50407 "Grading Structure"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Grading Structure";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Rating; Rating)
                {
                    ApplicationArea = All;
                }
                field("Lower Value"; "Lower Value")
                {
                    ApplicationArea = All;
                }
                field("Higher Value"; "Higher Value")
                {
                    ApplicationArea = All;
                }
                field("Total (Out of 5)"; "Total (Out of 5)")
                {
                    ApplicationArea = All;
                }
                field("% Bonus Payment"; "% Bonus Payment")
                {
                    ApplicationArea = All;
                }
                field("% Salary Increment"; "% Salary Increment")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}