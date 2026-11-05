page 51332 "LP Special DSS Ratio"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LP Special DSS Ratio";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Applies to Borrower Type"; "Applies to Borrower Type")
                {
                    ApplicationArea = All;

                }
                field(Ratio; Ratio)
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
            /*   action(ActionName)
              {
                  ApplicationArea = All;

                  trigger OnAction();
                  begin

                  end;
              } */
        }
    }
}