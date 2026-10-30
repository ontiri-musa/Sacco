codeunit 99997 "Get User"
{
    trigger OnRun()
    begin

    end;

    procedure GetUser(): Code[100]
    begin
        ActiveSession.Reset();
        ActiveSession.SetRange("Session ID", SessionId());
        if ActiveSession.FindFirst() then begin
            exit(ActiveSession."User ID");
        end;
    end;

    var
        ActiveSession: Record "Active Session";
}