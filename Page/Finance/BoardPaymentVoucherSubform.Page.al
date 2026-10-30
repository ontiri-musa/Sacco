page 56603 "Board Payment Voucher Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Board Payment Line";
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No"; "Member No")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update()
                    end;

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Suggest Lines")
            {
                Image = SuggestLines;
                Visible = false;

                trigger OnAction();
                begin
                    //CashManagement.SuggestPaymentLines(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

    end;

    var
        CashManagement: Codeunit "Cash Management";

}

