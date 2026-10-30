page 50424 "Closed Cases"
{
    ApplicationArea = all;
    CardPageID = "Disciplinary Cases Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 50215;
    SourceTableView = WHERE("Case Status" = filter('Closed'));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Case No"; "Case No")
                {
                    ApplicationArea = All;
                }
                field("Case Description"; "Case Description")
                {
                    ApplicationArea = All;
                }
                field("Date of the Case"; "Date of the Case")
                {
                    ApplicationArea = All;
                }
                field("Offense Type"; "Offense Type")
                {
                    ApplicationArea = All;
                }
                field("Offense Name"; "Offense Name")
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
                field("Case Status"; "Case Status")
                {
                    ApplicationArea = All;
                }
                field("HOD Recommendation"; "HOD Recommendation")
                {
                    ApplicationArea = All;
                }
                field("HR Recommendation"; "HR Recommendation")
                {
                    ApplicationArea = All;
                }
                field("Commitee Recommendation"; "Commitee Recommendation")
                {
                    ApplicationArea = All;
                }
                field("Action Taken"; "Action Taken")
                {
                    ApplicationArea = All;
                }
                field(Appealed; Appealed)
                {
                    ApplicationArea = All;
                }
                field("Committee Recon After Appeal"; "Committee Recon After Appeal")
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

