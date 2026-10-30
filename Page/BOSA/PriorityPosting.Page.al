page 50291 "Priority Posting"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Priority Posting";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(PriorityPosting)
            {

                field("Priority Type"; "Priority Type")
                {
                    ApplicationArea = All;
                }
                field("Priority Code"; "Priority Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Deduction Type"; "Deduction Type")
                {
                    ApplicationArea = All;
                }
                field("Calculatation Type"; "Calculation Type")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;

                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                }
                field("Overdraw Savings"; "Overdraw Savings")
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

                trigger OnAction();
                begin

                end;
            }
        }
    }
}