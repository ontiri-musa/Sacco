page 50438 "Submitted Leave Plan"
{
    CardPageID = "Leave Plan Card";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 50210;
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
                field("Application Date"; "Application Date")
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
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; "Department Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
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

