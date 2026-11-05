page 51205 "Marketing RoleCenter"
{
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {

            part(Part1; "Marketing RoleCenter Headline")
            {
                ApplicationArea = All;
            }

            part(Part2; "FOSA Activities")
            {
                Caption = 'FOSA';
                ApplicationArea = All;
            }
            part(Control1; "Membership Analysis Chart")
            {

                ApplicationArea = Basic, Suite;
            }
            part(Control2; "Branch Analysis-Acc Type Chart")
            {

                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(MembersAndAccounts)
            {
                Caption = 'Members & Member Accounts';
                action(FOSAMembers)
                {
                    Caption = 'Members';
                    RunObject = Page "Member List";
                    ApplicationArea = All;
                }
                action(SDAccounts)
                {
                    Caption = 'Savings Accounts';
                    RunObject = Page "Member S/Dep. Account List";
                    ApplicationArea = All;
                }
                action(LoanAccounts)
                {
                    Caption = 'Loan Accounts';
                    RunObject = Page "Member Loan Account List";
                    ApplicationArea = All;
                }

            }
            group(BusinessRepresentatives)
            {
                Caption = 'Business Representatives/Micro Credit Officers';
                action(BusinessReps)
                {
                    Caption = 'Business Representatives/Micro Credit Officers';
                    RunObject = Page "Loan Recovery Officer Setup";
                    ApplicationArea = All;
                }
                action(RoutePlans)
                {
                    Caption = 'Route Plans';
                    RunObject = Page "Route Plan List";
                    ApplicationArea = All;
                }
                action(SalesPortfolio)
                {
                    Caption = 'Sales Portfolio';
                    RunObject = Page "Sales Portfolio List";
                    ApplicationArea = All;
                }
                action(KPIMC)
                {
                    Caption = 'MicroCredit Officer KPI List';
                    RunObject = Page "Key Perfomance Indicator-MC";
                    ApplicationArea = All;
                }
                action(KPIBR)
                {
                    Caption = 'Business Representative Officer KPI List';
                    RunObject = Page "Key Perfomance Indicator-MC";
                    ApplicationArea = All;
                }

            }
            group("Portfolio Transfer")
            {
                action("New Portfolio Transfer.")
                {
                    Caption = 'New Portfolio Transfer';
                    RunObject = page "Portfolio Transfer List-New";
                    ApplicationArea = All;
                }
                action("Portfolio Transfer Pending Approval")
                {
                    RunObject = page "Portfolio Transfer-Pending";
                    ApplicationArea = All;
                }
                action("Approved Portfolio Transfer")
                {
                    RunObject = page "Portfolio Transfers-Approved";
                    ApplicationArea = All;
                }
                action("Rejected Portfolio Transfer")
                {
                    RunObject = page "Portfolio Transfers-Rejected";
                    ApplicationArea = All;
                }
                action("Portfolio Transfer Entries")
                {
                    RunObject = page "Portfolio Transfer Entries";
                    ApplicationArea = All;
                }
            }

        }
        area(Embedding)
        {
            action(Members)
            {
                Caption = 'Members';
                RunObject = Page "Member List";
                ApplicationArea = All;
            }
            action(MembersSDAccounts)
            {
                Caption = 'Savings Accounts';
                RunObject = Page "Member S/Dep. Account List";
                ApplicationArea = All;
            }
            action(MemberLoanAccount)
            {
                Caption = 'Loan Accounts';
                RunObject = Page "Member Loan Account List";
                ApplicationArea = All;
            }
            action("BusinessRepresentatives/MicroCreditOfficers")
            {
                Caption = 'Business Representatives/Micro Credit Officers';
                RunObject = Page "Loan Recovery Officer Setup";
                ApplicationArea = All;
            }
            action(Portfolio)
            {
                Caption = 'Portfolios';
                RunObject = Page "Sales Portfolio List";
                ApplicationArea = All;
            }
            action(MCKPIList)
            {
                Caption = 'MicroCredit Officer KPI List';
                RunObject = Page "Key Perfomance Indicator-MC";
                ApplicationArea = All;
            }
            action(BRKPIList)
            {
                Caption = 'Business Representative Officer KPI List';
                RunObject = Page "Key Perfomance Indicator-BR";
                ApplicationArea = All;
            }
        }
        area(Reporting)
        {
            action(MemberListing)
            {
                Caption = 'Member Listing';
                Image = "Report";
                RunObject = Report "Member Listing Report";
                ApplicationArea = All;
            }
            action(MemberStatement)
            {
                Caption = 'Member Statement';
                Image = "Report";
                RunObject = Report "Member Statement";
                ApplicationArea = All;
            }
            action(MemberAccountSummary)
            {
                Caption = 'Member Account Summary';
                Image = "Report";
                RunObject = Report "Members & Accounts Summary";
                ApplicationArea = All;
            }

            action(MCCommissionReport)
            {
                Caption = 'MicroCredit Commission Report';
                Image = "Report";
                RunObject = Report "MicroCredit Commission Report";
                ApplicationArea = All;
            }
            action(BRCommissionReport)
            {
                Caption = 'Business Representative Commission Report';
                Image = "Report";
                RunObject = Report "Business Rep Commission Report";
                ApplicationArea = All;
            }
        }
    }
}
// Creates a profile that uses the Role Center
profile MarketingProfile
{
    ProfileDescription = 'Marketing Profile';
    RoleCenter = "Marketing RoleCenter";
    Caption = 'Marketing';
}

