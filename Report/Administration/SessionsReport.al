report 50026 "Sessions Report"
{
    ApplicationArea = All;
    Caption = 'Sessions Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report\Administration\Sessions Report.rdl';
    dataset
    {
        dataitem(Session; Session)
        {
            column(UserID; "User ID")
            {
            }
            column(ApplicationName; "Application Name")
            {
            }
            column(DatabaseName; "Database Name")
            {
            }
            column(HostName; "Host Name")
            {
            }
            column(LoginDate; "Login Date")
            {
            }
            column(LoginTime; "Login Time")
            {
            }
            column(LoginType; "Login Type")
            {
            }
            column(ConnectionID; "Connection ID")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
