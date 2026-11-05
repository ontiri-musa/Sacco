page 50214 "Loan Product Charges"
{
    // version TL2.0

    Caption = 'Loan Product Charges';
    PageType = List;
    SourceTable = "Loan Product Charge";
    AutoSplitKey = true;
    RefreshOnActivate = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = true;
    Editable = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Minimum Amount"; "Minimum Amount")
                {
                    ApplicationArea = All;
                }

                field("Maximum Amount"; "Maximum Amount")
                {
                    ApplicationArea = All;
                }

                field("Calculation Mode"; "Calculation Mode")
                {
                    ApplicationArea = All;
                }
                field(Value; Value)
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Pinno Value"; "Pinno Value")
                {
                    ApplicationArea = All;
                }
                field("Pinno Account No"; "Pinno Account No")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
}

