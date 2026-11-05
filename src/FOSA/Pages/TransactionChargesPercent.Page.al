page 50023 "Transaction Charges-Percent"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'Percent Charges Subform';
    PageType = ListPart;
    SourceTable = "Transaction Charge";
    SourceTableView = where("Calculation Method" = filter("Based on %"));
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Amount"; "Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Settlement %"; "Settlement %")
                {
                    ApplicationArea = All;
                }

                field("Settlement % (TL)"; "Settlement % (TL)")
                {
                    ApplicationArea = All;
                }

                field("Settlement % (COOP)"; "Settlement % (COOP)")
                {
                    ApplicationArea = All;
                }
                field("Settlement % (AGENT)"; "Settlement % (AGENT)")
                {
                    ApplicationArea = All;
                }

                field("Total Charge Amount"; "Total Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Agent Type"; "Agent Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnOpenPage()
    begin
    end;

    var
}

