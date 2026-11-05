codeunit 99999 Login
{
    Permissions = tabledata "Active Session" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnBeforeLogInStart', '', true, true)]
    local procedure HandleOnBeforeLogInStart()
    var

    begin
        //  Report.Run(Report::Login);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterLogInStart', '', true, true)]
    local procedure HandleOnAfterLogInStart()
    var

    begin
        //  ManageLogins();
    end;

    procedure ManageLogins();
    var
        UserSetup: Record "User Setup";
        TLUser: Record "TL User";
        User: Record User;
        ActiveSession: Record "Active Session";
    begin
        TLUser.Reset();
        if TLUser.FindFirst() then begin
            ActiveSession.Reset();
            ActiveSession.SetRange("Session ID", SessionId());
            if ActiveSession.FindFirst() then begin
                User.Reset();
                User.SetRange("User Name", TLUser."User Id");
                if User.FindFirst() then begin
                    ActiveSession."User SID" := User."User Security ID";
                    ActiveSession."User ID" := TLUser."User Id";
                    ActiveSession.Modify();
                end;
            end;
        end;
    end;
}