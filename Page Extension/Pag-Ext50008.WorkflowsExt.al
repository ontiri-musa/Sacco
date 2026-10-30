pageextension 50008 WorkflowsExt extends Workflows
{
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."System Admin" = false then
                Error('You do not have permission to view this page');
        end;
    end;
}
