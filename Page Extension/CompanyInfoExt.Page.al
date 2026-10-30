pageextension 50504 "Company Information Ext" extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter(GLN)
        {
            field("Company P.I.N"; "Company P.I.N")
            {
                ApplicationArea = All;
            }
            field("Sacco Number"; "Sacco Number")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Companies" = false then
                Error('You do not have permission to view this page');
        end;
    end;

    var
        myInt: Integer;
}