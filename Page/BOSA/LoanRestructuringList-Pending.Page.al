page 51603 "Loan Restruct List-Pending"
{
    // version TL2.0

    Caption = 'Pending Loan Restructuring';
    CardPageID = "Loan Restructuring";
    PageType = List;
    SourceTable = "Loan Restructuring";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"));
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Approved Loan Amount"; "Approved Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Loan Balance"; "Outstanding Loan Balance")
                {
                    ApplicationArea = All;
                }
                field("Restructuring Type"; "Restructuring Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
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

