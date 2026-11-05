page 50483 RecruitmentApproved
{
    // version TL2.0

    CardPageID = "Recruitment Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = 50246;
    SourceTableView = WHERE(Status = FILTER(Released));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Job ID"; "Job ID")
                {
                    ApplicationArea = All;
                }
                field("Department Requested"; "Department Requested")
                {
                    ApplicationArea = All;
                }
                field("Requested Positions"; "Requested Positions")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Date"; "Recruitment Date")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Type"; "Recruitment Type")
                {
                    ApplicationArea = All;
                }
                field("Request Done By"; "Request Done By")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
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


