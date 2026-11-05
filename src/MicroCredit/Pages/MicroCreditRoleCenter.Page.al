page 55100 "MicroCredit Role Center"
{
    PageType = RoleCenter;
    Caption = 'MicroCredit';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Headline RC MicroCredit")
            {
                ApplicationArea = All;
            }
            part(Activities; "MC Cue")
            {
                ApplicationArea = All;
            }
            part(AccountAnalysis; "MC Account Analysis Chart")
            {
                ApplicationArea = All;
            }
            part(LoansDisbursed; "Branch Loan Disbursal Chart")
            {
                ApplicationArea = All;
            }
            part(PARAnalysis; "MC PAR Analysis Chart")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(Creation)
        {
            action("New Member")
            {
                RunPageMode = Create;
                Caption = 'New Member Application';
                ToolTip = 'Click here to create a new member';
                Image = New;
                RunObject = page "Member Application Card";
                ApplicationArea = All;
            }
            action("New Group Attendance")
            {
                RunPageMode = Create;
                Caption = 'New Group Attendance';
                ToolTip = 'Click here to create a new group attendance';
                Image = New;
                RunObject = page "Group Attendance";
                ApplicationArea = All;
            }
            action("New Allocation")
            {
                RunPageMode = Create;
                Caption = 'New Group Allocation';
                ToolTip = 'Click here to create a new allocation';
                Image = New;
                RunObject = page "Group Allocation";
                ApplicationArea = All;
            }
            action("New Portfolio Transfer")
            {
                RunPageMode = Create;
                Caption = 'New Portfolio Transfer';
                Image = New;
                RunObject = page "Portfolio Transfer Card";
                ApplicationArea = All;
            }
            action("New Loan Application")
            {
                RunPageMode = Create;
                Image = New;
                RunObject = page "Loan Application Card";
                ApplicationArea = All;
            }
            action("New Loan Rescheduling")
            {
                RunPageMode = Create;
                Image = New;
                RunObject = page "Loan Rescheduling";
                ApplicationArea = All;
            }
            action("New Fund Transfer")
            {
                RunPageMode = Create;
                Image = New;
                RunObject = page "Fund Transfer";
                ApplicationArea = All;
            }
            action("New Standing Order")
            {
                RunPageMode = Create;
                Image = New;
                RunObject = page "Standing Order Card";
                ApplicationArea = All;
            }
        }
        area(Processing)
        {
            group(PeriodActivities)
            {
                Caption = 'Periodic Activities';
                action(CapitalizeInterest)
                {
                    Caption = 'Capitalize Interest';
                    RunObject = report "Capitalize Interest";
                    ApplicationArea = All;
                }
                action(RunStaningOrder)
                {
                    Caption = 'Run Standing Order';
                    RunObject = report "Run Standing Order";
                    ApplicationArea = All;
                }
                action(RunLoanRecovery)
                {
                    Caption = 'Run Loan Recovery';
                    RunObject = report "Run Loan Recovery";
                    ApplicationArea = All;
                }
            }
            group(Setups)
            {
                action("Loan Officer Setup.")
                {
                    Caption = 'Loan Officer Setup';
                    RunObject = page "Loan Recovery Officer Setup";
                    Image = Setup;
                    ApplicationArea = All;
                }
                action("Global Setup")
                {
                    Caption = 'CBS Setup';
                    RunObject = page "Global Setup";
                    Image = Setup;
                    ApplicationArea = All;
                }
                action("Loan Product Type.")
                {
                    Caption = 'Loan Product Type';
                    RunObject = page "Loan Product Type List";
                    Image = Setup;
                    ApplicationArea = All;
                }
                action("Account Types.")
                {
                    Caption = 'Account Types';
                    RunObject = page "Account Type List";
                    Image = Setup;
                    ApplicationArea = All;
                }
                action("Standing Order Setup.")
                {
                    Caption = 'Standing Order Setup';
                    RunObject = page "Standing Order Setup";
                    Image = Setup;
                    ApplicationArea = All;
                }
            }
            group(Tasks)
            {

            }

        }
        area(Reporting)
        {
            action("Member Listing Report")
            {
                Image = Report;
                RunObject = report "Members & Accounts Summary";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Member Statement")
            {
                Image = Report;
                RunObject = report "Member Statement";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Group Attendance Report")
            {
                Image = Report;
                RunObject = report "Group Attendance";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Group Collection Sheet")
            {
                Image = Report;
                RunObject = report "Group Collection Sheet";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Group Report")
            {
                Image = Report;
                RunObject = report "Group Report";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Group Collection Entries")
            {
                Image = Report;
                RunObject = report "Group Collection Entries";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
            }

        }
        area(Embedding)
        {
            action("Member List")
            {
                RunObject = page "Member List";
                ApplicationArea = All;
            }
            action("Member Accounts List")
            {
                RunObject = page "Member S/Dep. Account List";
                ApplicationArea = All;
            }
            action("Loan Accounts List")
            {
                RunObject = page "Member Loan Account List";
                ApplicationArea = All;
            }
            action("Validated Group Attendance")
            {
                RunObject = page "Grp Attendance List-Validated";
                ApplicationArea = All;
            }
            action("Group Collection Entries.")
            {
                Caption = 'Group Collection Entries';
                RunObject = page "Group Collection Entries";
                ApplicationArea = All;
            }
            action("Posted Group Allocation")
            {
                RunObject = page "Grp Allocations List-Posted";
                ApplicationArea = All;
            }
            action("Loan Classification.")
            {
                Caption = 'Loan Classification';
                RunObject = page "Loan Classification Entries";
                ApplicationArea = All;
            }
            action("Running Standing Orders")
            {
                RunObject = page "Standing Order List-Running";
                ApplicationArea = All;
            }
        }
        area(Sections)
        {
            group(MemberApplication)
            {
                Caption = 'Member Application';
                action("Member Application List")
                {
                    RunObject = page "Member Application List-New";
                    ApplicationArea = All;
                }
                action("Member Application Pending Approval")
                {
                    RunObject = page "Member Appl. List-Pending";
                    ApplicationArea = All;
                }
                action("Approved Member Application")
                {
                    RunObject = page "Member Appl. List-Approved";
                    ApplicationArea = All;
                }
            }
            group("Members & Accounts")
            {
                action("Member List.")
                {
                    Caption = 'Member List';
                    RunObject = page "Member List";
                    ApplicationArea = All;
                }
                action("Savings Accounts")
                {
                    RunObject = page "Member S/Dep. Account List";
                    ApplicationArea = All;
                }
                action("Loan Accounts")
                {
                    RunObject = page "Member Loan Account List";
                    ApplicationArea = All;
                }

            }

            group(GroupAttendance)
            {
                Caption = 'Group Attendance';
                action(NewGroupAttenance)
                {
                    Caption = 'New Group Attendance';
                    RunObject = Page "Group Attendance List-New";
                    ApplicationArea = All;

                }
                action(ValidatedGroupAttenance)
                {
                    Caption = 'Validated Group Attendance';
                    RunObject = Page "Grp Attendance List-Validated";
                    ApplicationArea = All;

                }
                action(GroupAttenanceReport)
                {
                    Caption = 'Group Attendance Report';
                    RunObject = report "Group Attendance";
                    ApplicationArea = All;

                }
            }
            group("Group Collections")
            {
                action("Group Collection Entries_")
                {
                    Caption = 'Group Collection Entries';
                    RunObject = page "Group Collection Entries";
                    ApplicationArea = All;
                }
                group(GroupCollectionReports)
                {
                    Caption = 'Reports';
                    action(GroupCollectionEntrie)
                    {
                        Caption = 'Group Collection Entries Report';
                        RunObject = Report "Group Collection Entries";
                        ApplicationArea = All;

                    }
                    action(GroupCollectionSheet)
                    {
                        Caption = 'Group Collection Sheet Report';
                        RunObject = Report "Group Collection Sheet";
                        ApplicationArea = All;

                    }
                    action(GroupReport)
                    {
                        Caption = 'Group Report';
                        RunObject = Report "Group Report";
                        ApplicationArea = All;

                    }
                }
            }
            group(GroupAllocation)
            {
                Caption = 'Group Allocation';
                action(NewGroupAllocation)
                {
                    Caption = 'New Group Allocations';
                    RunObject = Page "Group Allocations List-New";
                    ApplicationArea = All;

                }
                action(PendingGroupAllocation)
                {
                    Caption = 'Pending Group Allocations';
                    RunObject = Page "Grp Allocations List-Pending";
                    ApplicationArea = All;

                }
                action(ApprovedGroupAllocation)
                {
                    Caption = 'Approved Group Allocations';
                    RunObject = Page "Grp Allocations List-Approved";
                    ApplicationArea = All;

                }
                action(RejectedGroupAllocation)
                {
                    Caption = 'Rejected Group Allocations';
                    RunObject = Page "Grp Allocations List-Rejected";
                    ApplicationArea = All;

                }
                action(PostedGroupAllocation)
                {
                    Caption = 'Posted Group Allocations';
                    RunObject = Page "Grp Allocations List-Posted";
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
            group("Loan Management")
            {
                action("New Loan Application.")
                {
                    Caption = 'New Loan Application';
                    RunObject = page "Loan Application List-New";
                    ApplicationArea = All;
                }
                action("Loan Application Pending Appraisal")
                {
                    Caption = 'Loans Pending Appraisal';
                    RunObject = page "Loan Appl. List-Pending Apprsl";
                    ApplicationArea = All;
                }
                action("Loan Application Pending Disbursal")
                {
                    Caption = 'Loans Pending Disbursal';
                    RunObject = page "Loan Appl. List-Pending Dbsl";
                    ApplicationArea = All;
                }
                action("Rejected Loans")
                {
                    Caption = 'Rejected Loans';
                    RunObject = page "Loans Appl. List-Rejected";
                    ApplicationArea = All;
                }
                action("Posted Loans")
                {
                    RunObject = page "Loan Applications List-Posted";
                    ApplicationArea = All;
                }

            }
            group("Fund Transfer")
            {
                action("Fund Transfer Application")
                {
                    RunObject = page "Fund Transfer List-New";
                    ApplicationArea = All;
                }
                action("Pending Fund Transfer")
                {
                    RunObject = page "Fund Transfer List-Pending";
                    ApplicationArea = All;
                }
                action("Approved Fund Transfer")
                {
                    RunObject = page "Fund Transfer List-Approved";
                    ApplicationArea = All;
                }
                action("Rejected Fund Transfer")
                {
                    RunObject = page "Fund Transfer List-Rejected";
                    ApplicationArea = All;
                }
                action("Posted Fund Transfer")
                {
                    RunObject = page "Fund Transfer List-Posted";
                    ApplicationArea = All;
                }

            }
            group("Loan Classification")
            {
                action("Loan Classification Entries")
                {
                    RunObject = page "Loan Classification Entries";
                    ApplicationArea = All;
                }
                action("Generate Loan Classification")
                {
                    RunObject = report "Generate Loan Classification";
                    ApplicationArea = All;
                }
            }
            group("Standing Orders")
            {
                action("New Standing Order.")
                {
                    Caption = 'New Standing Order';
                    RunObject = page "Standing Order List-New";
                    ApplicationArea = All;
                }
                action("Pending Standing Order")
                {
                    RunObject = page "Standing Order List-Pending";
                    ApplicationArea = All;
                }
                action("Approved Standing Order")
                {
                    RunObject = page "Standing Order List-Approved";
                    ApplicationArea = All;
                }
                action("Rejected Standing Order")
                {
                    RunObject = page "Standing Order List-Rejected";
                    ApplicationArea = All;
                }
                action("Running Standing Order")
                {
                    RunObject = page "Standing Order List-Running";
                    ApplicationArea = All;
                }
            }
            group("Reports.")
            {
                Caption = 'Reports';
                action("Group Attendance Report.")
                {
                    Caption = 'Group Attendance Report';
                    RunObject = report "Group Attendance";
                    ApplicationArea = All;
                }
                action("Group Collection Sheet Report")
                {
                    RunObject = report "Group Collection Sheet";
                    ApplicationArea = All;
                }
                action("Group Report.")
                {
                    RunObject = report "Group Report";
                    ApplicationArea = All;
                }
                action("Group Collection Entries Report")
                {
                    RunObject = report "Group Collection Entries";
                    ApplicationArea = All;
                }

            }
            group(Setup)
            {
                action("Loan Officer Setup")
                {
                    RunObject = page "Loan Recovery Officer Setup";
                    ApplicationArea = All;
                }
                action("CBS Setup.")
                {
                    Caption = 'CBS Setup';
                    RunObject = page "Global Setup";
                    ApplicationArea = All;
                }
                action("Loan Product Type")
                {
                    RunObject = page "Loan Product Type List";
                    ApplicationArea = All;
                }
                action("Account Types")
                {
                    RunObject = page "Account Type List";
                    ApplicationArea = All;
                }
                action("Standing Order Setup")
                {
                    RunObject = page "Standing Order Setup";
                    ApplicationArea = All;
                }
            }
        }
    }

}
profile MicroCreditProfile
{
    ProfileDescription = 'MicroCredit';
    RoleCenter = "MicroCredit Role Center";
    Caption = 'MICROCREDIT';
}