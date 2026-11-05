page 50027 "Transaction Charges-Flat"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'Flat Charges Subform';
    PageType = ListPart;
    SourceTable = "Transaction Charge";
    SourceTableView = where("Calculation Method" = filter("Based Flat Amount"));
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
                field("Settlement Amount  (SACCO)"; "Settlement Amount  (SACCO)")
                {

                    ApplicationArea = All;
                }

                field("Settlement Amount  (TL)"; "Settlement Amount  (TL)")
                {
                    ApplicationArea = All;
                }

                field("Settlement Amount (COOP)"; "Settlement Amount (COOP)")
                {
                    ApplicationArea = All;
                }

                field("Settlement Amount (AGENT)"; "Settlement Amount (AGENT)")
                {
                    ApplicationArea = All;
                }
                // field("Total Charge Amount"; "Total Charge Amount")
                // {
                //     ApplicationArea = All;
                // }
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

