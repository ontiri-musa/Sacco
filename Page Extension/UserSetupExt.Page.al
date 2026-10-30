pageextension 50810 "User Setup Ext" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("Employee No."; "Employee No.")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("User Name"; "User Name")
            {
                ApplicationArea = All;
            }
            field(Signature; Signature)
            {
                ApplicationArea = All;
            }
            field("View Payroll"; "View Payroll")
            {
                ApplicationArea = All;
            }
            field("View Companies"; "View Companies")
            {
                ApplicationArea = All;
            }
            field("System Admin"; "System Admin")
            {
                ApplicationArea = All;
            }
            field("Approve Board Payments"; "Approve Board Payments")
            {
                ApplicationArea = All;
            }
            field("Edit Member Details"; "Edit Member Details")
            {
                ApplicationArea = All;
            }
            field("Allow Recover Loan From Deposits"; "Allow Recover Loan From Deposits")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."System Admin" = false then begin
                Error('You do not have permission to view this page');
            end;
        end;
    end;
}