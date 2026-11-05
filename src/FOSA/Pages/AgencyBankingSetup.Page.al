page 50378 "Agency Banking Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Agency Banking Setup";
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Agent Application Nos."; "Agent Application Nos.")
                {
                    ApplicationArea = All;
                }
                field("Agent Nos."; "Agent Nos.")
                {
                    ApplicationArea = All;
                }
                field("Maximum Withdrawal Per day"; "Maximum Withdrawal Per day")
                {
                    ApplicationArea = All;

                }
                field("Internal Agent A/C Type"; "Internal Agent A/C Type")
                {
                    ApplicationArea = All;
                }
                field("Internal Agent Income A/c"; "Internal Agent Income A/C")
                {
                    ApplicationArea = All;

                }
                field("Agency Banking(Non Mobile Banking)"; "Agency Banking(Non Mobile Banking)")
                {
                    ApplicationArea = All;
                }

            }
            group(Posting)
            {
                field("Agency Template Name"; "Agency Template Name")
                {
                    ApplicationArea = All;
                }
                field("Agency Batch Name"; "Agency Batch Name")
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
            /*  action(ActionName)
             {
                 ApplicationArea = All;

                 trigger OnAction()
                 begin

                 end;
             } */
        }
    }

    var
        myInt: Integer;
}