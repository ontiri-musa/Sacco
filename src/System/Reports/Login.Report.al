report 70000 "Login"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Login)
                {
                    field(UserName; UserName)
                    {
                        caption = 'User Name';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            User.Reset();
                            User.SetRange("User Id", UserName);
                            if not User.FindFirst() then begin
                                Error('Invalid Username!');
                            end;
                        end;
                    }
                    field(Password; Password)
                    {
                        ApplicationArea = All;
                        ExtendedDatatype = Masked;
                        trigger OnValidate()
                        begin
                            User.Reset();
                            User.SetRange("User Id", UserName);
                            if User.FindFirst() then begin
                                /*  if User."Default Password" <> Password then
                                     StopSession(SessionId())
                                 else */
                                ManageLogins(User."User Id");

                            end;
                        end;
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if UserName = '' then
                exit(false);
        end;
    }

    var
        UserName: Code[100];
        Password: Text[50];
        User: Record "TL User";

    procedure ManageLogins(UserName: Code[100]);
    var
        UserSetup: Record "User Setup";
        TLUser: Record "TL User";
        User: Record User;
        ActiveSession: Record "Active Session";
    begin
        TLUser.Reset();
        TLUser.SetRange("User Id", UserName);
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

    local procedure ValidateLogin()
    begin

    end;
}