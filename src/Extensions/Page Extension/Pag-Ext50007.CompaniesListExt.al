pageextension 50007 CompaniesListExt extends Companies
{
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Companies" = false then
                Error('You do not have permission to view this page');
        end;
    end;
}
