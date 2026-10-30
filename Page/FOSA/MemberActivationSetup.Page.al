page 50046 "Member Activation Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Member Activation Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Member Activation Nos."; "Member Activation Nos.")
                {
                    ApplicationArea = All;
                }
                field("Charge Registration Fee"; "Charge Registration Fee")
                {
                    ApplicationArea = All;
                }


            }
            group(Posting)
            {
                field("Member Activ. Template Name"; "Member Activ. Template Name")
                {
                    ApplicationArea = All;
                }
                field("Member Activ. Batch Name"; "Member Activ. Batch Name")
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {

    }

    trigger OnOpenPage()
    begin

    end;

    var

}

