page 51335 "Attached Guarantor Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Attach Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Attached Loan No."; "Attached Loan No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Attached Amount"; "Attached Amount")
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
        /*   area(Processing)
          {
              action(ActionName)
              {
                  ApplicationArea = All;

                  trigger OnAction();
                  begin

                  end;
              }
          } */
    }
}