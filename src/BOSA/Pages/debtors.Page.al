page 51099 "debtors"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = List;
    SourceTable = debtors;
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {

            repeater(Group)
            {
                field("User Input"; "User Input")
                {
                    Editable = recEditable;

                }
                field("Next Action Date"; "Next Action Date")
                {
                    Editable = recEditable;

                }
                field("Amount Promised To Pay"; "Amount Promised To Pay")
                {
                    Editable = recEditable;
                }
                field("Last Amount Paid"; "Last Amount Paid")
                {
                    Editable = recEditable;
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                    Editable = recEditable;
                }
                field("USER ID"; "USER ID")
                {
                    Visible = false;
                    Editable = false;
                }




            }

        }

    }


    actions
    {
    }
    trigger OnOpenPage()
    begin
        LoanPosted := false;
    end;

    trigger OnInit()
    begin

    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."USER ID" = '' then begin
            recEditable := true
        end else begin
            if Rec."USER ID" <> '' then
                if UserId <> Rec."USER ID" then
                    recEditable := false
                else
                    recEditable := true;
        end;


    end;

    var
        LoanPosted: Boolean;
        LoanApp: Record "Loan Application";
        [InDataSet]
        recEditable: Boolean;
        objDetailedCustLedg: Record "Detailed Cust. Ledg. Entry";

}

