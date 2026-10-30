page 50439 "Submitted Leave Recalls"
{
    CardPageID = "Leave Recall Card";
    Editable = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = 50222;
    SourceTableView = WHERE(Status = FILTER('Released'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                    ApplicationArea = All;
                }
                field("Days Applied"; "Days Applied")
                {
                    ApplicationArea = All;
                }
                field("Leave Ending Date"; "Leave Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Recall Date"; "Recall Date")
                {
                    ApplicationArea = All;
                }
                field("Recalled By"; "Recalled By")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Recall Department"; "Recall Department")
                {
                    ApplicationArea = All;
                }
                field("Recall Branch"; "Recall Branch")
                {
                    ApplicationArea = All;
                }
                field("Reason for Recall"; "Reason for Recall")
                {
                    ApplicationArea = All;
                }
                field("Recalled To"; "Recalled To")
                {
                    ApplicationArea = All;
                }
                field("Recalled From"; "Recalled From")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        CurrPage.EDITABLE(FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Error(Error000);
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        Error(Error001);
    end;

    var
        Error000: Label 'You cannot create a new record!';
        Error001: Label 'You cannot modify this record!';
}

