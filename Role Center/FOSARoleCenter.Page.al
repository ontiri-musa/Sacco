page 50351 "FOSA RoleCenter"
{
    PageType = RoleCenter;
    Caption = 'FOSA Role Center';
    layout
    {
        area(RoleCenter)
        {

            part(Part1; "FOSA RoleCenter Headline")
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
            group(MemberApplication)
            {
                Caption = 'Member Application';

                action("New Member Applications")
                {
                    RunObject = Page "Member Application List-New";
                    ApplicationArea = All;
                }
                action("Pending Member Applications")
                {
                    RunObject = Page "Member Appl. List-Pending";
                    ApplicationArea = All;
                }
                action("Approved Member Applications")
                {
                    RunObject = Page "Member Appl. List-Approved";
                    ApplicationArea = All;
                }
                action("Rejected Member Applications")
                {
                    //  RunObject = Page
                    ApplicationArea = All;
                }
                group(MemberApplicationSetup)
                {
                    Caption = 'Setup';
                    action("Member Application Setup")
                    {
                        RunObject = Page "Member Application Setup";
                        ApplicationArea = All;
                    }
                    group("Church Setup")
                    {
                        action("Church Districts")
                        {
                            RunObject = Page "Church Districts";
                            ApplicationArea = All;
                        }
                        action("Church Sections")
                        {
                            RunObject = Page "Church Sections";
                            ApplicationArea = All;
                        }
                        action("Churches")
                        {
                            RunObject = Page Churches;
                            ApplicationArea = All;
                        }
                    }
                }

            }
            group(MembersAndAccounts)
            {
                Caption = 'Members & Member Accounts';
                action(FOSAMembers)
                {
                    Caption = 'Members';
                    RunObject = Page MemberListAll;
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

                action("Fixed/Call Deposits Summary")
                {
                    RunObject = Page "Fixed/Call Deposit Summary";
                    ApplicationArea = All;
                }

                action("Requests To Approve")
                {
                    RunObject = Page "Requests to Approve";
                    ApplicationArea = All;
                }
                group(FOSAReports)
                {
                    Caption = 'Reports';
                    action("Member Statement")
                    {
                        RunObject = report "Member Statement";
                        ApplicationArea = All;
                    }
                    action("Loan Statement")
                    {
                        RunObject = report "Member Loan Statement";
                        ApplicationArea = All;
                    }
                    action("Fixed/Call Deposit Summary")
                    {
                        RunObject = report "Fixed/Call Deposit Summary";
                        ApplicationArea = All;
                    }
                }
            }
            group(AccountOpening)
            {
                Caption = 'Account Opening';
                action("New Account Opening")
                {
                    RunObject = Page "Account Opening List-New";
                    ApplicationArea = All;
                }
                action("Pending Account Opening")
                {
                    RunObject = Page "Account Opening List-Pending";
                    ApplicationArea = All;
                }
                action("Approved Account Opening")
                {
                    RunObject = Page "Account Opening List-Approved";
                    ApplicationArea = All;
                }
                action("Rejected Account Opening")
                {
                    RunObject = Page "Account Opening List-Rejected";
                    ApplicationArea = All;
                }
                group(AccountOpeningSetup)
                {
                    Caption = 'Setup';
                    action("Account Opening Setup")
                    {
                        RunObject = Page "Account Opening Setup";
                        ApplicationArea = All;
                    }
                }
            }
            group(MemberActivation)
            {
                Caption = 'Member Activation';
                action("New Member Activations")
                {
                    RunObject = Page "Member Activation List";
                    ApplicationArea = All;
                }
                action("Pending Member Activations")
                {
                    RunObject = Page "Member Activation List-Pending";
                    ApplicationArea = All;
                }
                action("Approved Member Activations")
                {
                    RunObject = Page "Member Activ. List-Approved";
                    ApplicationArea = All;
                }
                action("Rejected Member Activations")
                {
                    RunObject = Page "Member Activ. List-Rejected";
                    ApplicationArea = All;
                }
                group(MemberActivationSetup)
                {
                    Caption = 'Setup';
                    action("Member Activation Setup")
                    {
                        RunObject = Page "Member Activation Setup";
                        ApplicationArea = All;
                    }
                }

            }

            group(Tellering)
            {
                Visible = false;
                group("Teller Transaction")
                {
                    action("New Teller Transactions")
                    {
                        RunObject = Page "Teller Transactions List-New";
                        ApplicationArea = All;
                    }
                    action("Pending Teller Transactions")
                    {
                        RunObject = Page "Teller Transactions-Pending";
                        ApplicationArea = All;
                    }
                    action("Approved Teller Transactions")
                    {
                        RunObject = Page "Teller Transactions-Approved";
                        ApplicationArea = All;
                    }
                    action("Rejected Teller Transactions")
                    {
                        RunObject = Page "Teller Transactions-Rejected";
                        ApplicationArea = All;
                    }
                    action("Posted Teller Transactions")
                    {
                        RunObject = Page "Teller Transactions-Posted";
                        ApplicationArea = All;
                    }
                }
                group("Return To Treasury")
                {
                    action("New Return To Treasury")
                    {
                        RunObject = Page "Teller Return Treasury-New";
                        ApplicationArea = All;
                    }
                    action("Pending Return To Treasury")
                    {
                        RunObject = Page "Teller Return Treasury-Pending";
                        ApplicationArea = All;
                    }
                    action("Approved Return To Treasury")
                    {
                        RunObject = Page "Teller Ret. Treasury-Approved";
                        ApplicationArea = All;
                    }
                    action("Rejected Return To Treasury")
                    {
                        RunObject = Page "Teller Ret. Treasury-Rejected";
                        ApplicationArea = All;
                    }
                    action("Posted Return To Treasury")
                    {
                        RunObject = Page "Teller Ret. Treasury-Posted";
                        ApplicationArea = All;
                    }


                }
                group("InterTeller Transfer")
                {
                    action("New InterTeller Transfers")
                    {
                        RunObject = Page "InterTeller Transfers-New";
                        ApplicationArea = All;
                    }
                    action("Pending InterTeller Transfers")
                    {
                        RunObject = Page "InterTeller Transfers-Pending";
                        ApplicationArea = All;
                    }
                    action("Approved InterTeller Transfers")
                    {
                        RunObject = Page "InterTeller Transfers-Approved";
                        ApplicationArea = All;
                    }
                    action("Rejected InterTeller Transfers")
                    {
                        RunObject = Page "InterTeller Transfers-Rejected";
                        ApplicationArea = All;
                    }
                    action("Posted InterTeller Transfers")
                    {
                        RunObject = Page "InterTeller Transfers-Approved";
                        ApplicationArea = All;
                    }


                }
                group("Teller Close Till")
                {
                    action("New Teller Close Till")
                    {
                        RunObject = Page "Teller Close Till List-New";
                        ApplicationArea = All;
                    }
                    action("Pending Teller Close Till")
                    {
                        RunObject = Page "Teller Close Till-Pending";
                        ApplicationArea = All;
                    }
                    action("Approved Teller Close Till")
                    {
                        RunObject = Page "Teller Close Till-Approved";
                        ApplicationArea = All;
                    }
                    action("Rejected Teller Close Till")
                    {
                        RunObject = Page "Teller Close Till-Rejected";
                        ApplicationArea = All;
                    }
                    action("Posted Teller Close Till")
                    {
                        RunObject = Page "Teller Close Till-Approved";
                        ApplicationArea = All;
                    }


                }
                group(TellerSetup)
                {
                    Caption = 'Setup';
                    action("Teller User Setup")
                    {
                        RunObject = Page "Teller User Setup";
                        ApplicationArea = All;
                    }
                    action("Coinage Setup")
                    {
                        RunObject = Page "Coinage Setup";
                        ApplicationArea = All;
                    }
                    action("Tellering Setup")
                    {
                        RunObject = Page "Tellering Setup";
                        ApplicationArea = All;
                    }
                }
            }
            group(Treasury)
            {
                Visible = false;
                group("Treasury Transaction")
                {
                    action("New Treasury Transactions")
                    {
                        RunObject = Page "Treasury Transactions List-New";
                        ApplicationArea = All;
                    }
                    action("Pending Treasury Transactions")
                    {
                        RunObject = Page "Treasury Transactions-Pending";
                        ApplicationArea = All;
                    }
                    action("Approved Treasury Transactions")
                    {
                        RunObject = Page "Treasury Transactions-Approved";
                        ApplicationArea = All;
                    }
                    action("Rejected Treasury Transactions")
                    {
                        RunObject = Page "Treasury Transactions-Rejected";
                        ApplicationArea = All;
                    }
                    action("Posted Treasury Transactions")
                    {
                        RunObject = Page "Treasury Transactions-Posted";
                        ApplicationArea = All;
                    }
                }
                group("Treasury Return To Bank")
                {
                    action("New Treasury Return To Bank")
                    {
                        RunObject = Page "Treasury Return Bank List-New";
                        ApplicationArea = All;
                    }
                    action("Pending Treasury Return To Bank")
                    {
                        RunObject = Page "Treasury Return Bank-Pending";
                        ApplicationArea = All;
                    }
                    action("Approved Treasury Return To Bank")
                    {
                        RunObject = Page "Treasury Return Bank-Approved";
                        ApplicationArea = All;
                    }
                    action("Rejected Treasury Return To Bank")
                    {
                        RunObject = Page "Treasury Return Bank-Rejected";
                        ApplicationArea = All;
                    }
                    action("Posted Treasury Return To Bank")
                    {
                        RunObject = Page "Treasury Return Bank-Posted";
                        ApplicationArea = All;
                    }
                }
                group(TreasurySetup)
                {
                    Caption = 'Setup';

                    action("Treasury Setup")
                    {
                        RunObject = Page "Treasury Setup";
                        ApplicationArea = All;
                    }
                }

            }

            group("Agency Banking")
            {
                Caption = 'Agency Banking';
                Visible = false;
                Enabled = false;
                group(AgentApplication)
                {
                    Caption = 'Agent Application';
                    action(NewAgentApplication)
                    {
                        Caption = 'New Agent Applications';
                        RunObject = page "Agent Application List-New";
                        ApplicationArea = All;
                    }
                    action(PendingAgentApplication)
                    {
                        Caption = 'Pending Agent Applications';
                        RunObject = page "Agent Applications-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedAgentApplication)
                    {
                        Caption = 'Approved Agent Applications';
                        RunObject = page "Agent Applications-Approved";
                        ApplicationArea = All;
                    }
                    action(RejectedAgentApplication)
                    {
                        Caption = 'Rejected Agent Applications';
                        RunObject = page "Agent Applications-Rejected";
                        ApplicationArea = All;
                    }
                }
                group(Agents)
                {
                    action(ActiveAgents)
                    {
                        Caption = 'Agents';
                        RunObject = page "Agent List";
                        ApplicationArea = All;
                    }
                }
                group(AgencyLedgerEntries)
                {
                    Caption = 'Ledger Entries';
                    action(LedgerEntries)
                    {
                        Caption = 'Ledger Entries';
                        RunObject = page "Agency Ledger Entries";
                        ApplicationArea = All;
                    }
                }
                group(AgencyBankingSetup)
                {
                    Caption = 'Agency Setup';
                    action(AgencyBankingSetupAction)
                    {
                        Caption = 'Agency Setup';
                        RunObject = page "Agency Banking Setup";
                        ApplicationArea = All;
                    }
                }
            }
            group(MobileBanking)
            {
                Caption = 'Mobile Banking';
                group(MobileBankingApplication)
                {
                    Caption = 'Mobile Banking Application';
                    action(NewMobileBankingpplication)
                    {
                        Caption = 'New Mobile Banking Applications';
                        RunObject = page "Mobile Banking Appl. List-NEw";
                        ApplicationArea = All;
                    }
                    action(PendingMobileBankingApplication)
                    {
                        Caption = 'Pending Mobile Banking Applications';
                        RunObject = page "Mobile Bk Appl. List-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedMobileBankingApplication)
                    {
                        Caption = 'Approved Mobile Banking Applications';
                        RunObject = page "Mobile Bk Appl. List-Approved";
                        ApplicationArea = All;
                    }
                    action(RejectedMobileBankingApplication)
                    {
                        Caption = 'Rejected Mobile Banking Applications';
                        RunObject = page "Mobile Bk Appl. List-Rejected";
                        ApplicationArea = All;
                    }
                }

                action(MobileBankingMember)
                {
                    Caption = 'Mobile Banking Members';
                    RunObject = page "Mobile Banking Members List";
                    ApplicationArea = All;
                }

                action(MobileBankingUnregMember)
                {
                    Caption = 'Unregistered Mobile Banking Members Report';
                    RunObject = report MobileUnregMemberList;
                    ApplicationArea = All;
                }

                group(MobileBankingActivation)
                {
                    Caption = 'Mobile Banking Activation';
                    action(NewMobileBankingActivation)
                    {
                        Caption = 'New Mobile Banking Activations';
                        RunObject = page "Mobile Banking Activ. List-New";
                        ApplicationArea = All;
                    }
                    action(PendingMobileBankingActivation)
                    {
                        Caption = 'Pending Mobile Banking Activations';
                        RunObject = page "Mobile Bk Activ. List-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedMobileBankingActivation)
                    {
                        Caption = 'Approved Mobile Banking Activations';
                        RunObject = page "Mobile Bk Activ. List-Approved";
                        ApplicationArea = All;
                    }
                    action(RejectedMobileBankingActivation)
                    {
                        Caption = 'Rejected Mobile Banking Activations';
                        RunObject = page "Mobile Bk Activ. List-Rejected";
                        ApplicationArea = All;
                    }
                }
                group(MobileBankingDeactivation)
                {
                    Caption = 'Mobile Banking Deactivation';
                    action(NewMobileBankingDeactivation)
                    {
                        Caption = 'New Mobile Banking Deactivations';
                        RunObject = page "Mobile Bk Deactiv List-New";
                        ApplicationArea = All;
                    }
                    action(PendingMobileBankingDeactivation)
                    {
                        Caption = 'Pending Mobile Banking Deactivations';
                        RunObject = page "Mobile Bk Deactiv List-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedMobileBankingDeactivation)
                    {
                        Caption = 'Approved Mobile Banking Deactivations';
                        RunObject = page "Mobile Bk Deactiv List-Apprved";
                        ApplicationArea = All;
                    }
                    action(RejectedMobileBankingDeactivation)
                    {
                        Caption = 'Rejected Mobile Banking Deactivations';
                        RunObject = page "Mobile Bk Deactiv List-Reject";
                        ApplicationArea = All;
                    }
                }
                action(MobileBankingLedgerEntries)
                {
                    Caption = 'Mobile Banking Ledger Entries';
                    RunObject = page "Mobile Banking Ledger Entries";
                    ApplicationArea = All;
                }

                group(MobileBankingSetup)
                {
                    Caption = 'Setup';
                    action(MobileBankingSetup2)
                    {
                        Caption = 'Mobile Banking Setup';
                        RunObject = page "Mobile Banking Setup";
                        ApplicationArea = All;
                    }
                }
            }
            group(ATMManagement)
            {
                Caption = 'ATM Management';
                Visible = false;
                Enabled = false;
                group(ATMApplication)
                {
                    Caption = 'ATM Application';
                    action(NewATMApplication)
                    {
                        Caption = 'New ATM Applications';
                        RunObject = page "ATM Application List-New";
                        ApplicationArea = All;
                    }
                    action(PendingATMApplication)
                    {
                        Caption = 'Pending ATM Applications';
                        RunObject = page "ATM Application List-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedATMApplication)
                    {
                        Caption = 'Approved ATM Applications';
                        RunObject = page "ATM Application List-Approved";
                        ApplicationArea = All;
                    }
                    action(RejectedATMApplication)
                    {
                        Caption = 'Rejected ATM Applications';
                        RunObject = page "ATM Application List-Rejected";
                        ApplicationArea = All;
                    }

                }
                group(ATMCollection)
                {
                    Caption = 'ATM Collection';
                    action(NewATMCollection)
                    {
                        Caption = 'New ATM Collections';
                        RunObject = page "ATM Collection List-New";
                        ApplicationArea = All;
                    }
                    action(PendingATMCollection)
                    {
                        Caption = 'Pending ATM Collections';
                        RunObject = page "ATM Collection List-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedATMCollection)
                    {
                        Caption = 'Approved ATM Collections';
                        RunObject = page "ATM Collection List-Pending";
                        ApplicationArea = All;
                    }
                    action(RejectedATMCollection)
                    {
                        Caption = 'Rejected ATM Collections';
                        RunObject = page "ATM Collection List-Pending";
                        ApplicationArea = All;
                    }

                }
                group(ATMMembers)
                {
                    Caption = 'Members';
                    action("ATM Members")
                    {
                        RunObject = page "ATM Members List";
                        ApplicationArea = All;
                    }

                }
                group(ATMActivation)
                {
                    Caption = 'ATM Activation';
                    action(NewATMActivation)
                    {
                        Caption = 'New ATM Activations';
                        RunObject = page "ATM Activation List-New";
                        ApplicationArea = All;
                    }
                    action(PendingATMActivation)
                    {
                        Caption = 'Pending ATM Activations';
                        RunObject = page "ATM Activation List-Pending";
                        ApplicationArea = All;
                    }
                    action(ApprovedATMActivation)
                    {
                        Caption = 'Approved ATM Activations';
                        RunObject = page "ATM Activation List-Approved";
                        ApplicationArea = All;
                    }
                    action(RejectedATMActivation)
                    {
                        Caption = 'Rejected ATM Activations';
                        RunObject = page "ATM Activation List-Rejected";
                        ApplicationArea = All;
                    }

                }

                group(ATMLedgerEntries)
                {
                    Caption = 'Ledger Entries';
                    action(ATMLedgerEntries2)
                    {
                        Caption = 'ATM Ledger Entries';
                        RunObject = page "ATM Ledger Entries";
                        ApplicationArea = All;
                    }
                }
                group(ATMSetup)
                {
                    Caption = 'Setup';
                    action(ATMSetup2)
                    {
                        Caption = 'ATM Setup';
                        RunObject = page "ATM Setup";
                        ApplicationArea = All;
                    }
                }
            }
            group(CTSManagement)
            {
                Caption = 'CTS Management';
                Visible = false;
                Enabled = false;
                group(ChequeBooks)
                {
                    Caption = 'Cheque Books';
                    action("New Cheque Books")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Book List-New";
                    }
                    action("Issued Cheque Books")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Book List-Issued";
                    }
                }
                group(ChequeBookApplication)
                {
                    Caption = 'Cheque Book Application';
                    action("New Cheque Book Appications")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Book Appl. List-New";
                    }
                    action("Pending Cheque Book Applications")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Bk Appl. List-Pending";
                    }
                    action("Approved Cheque Book Applications")
                    {
                        ApplicationArea = All;
                        RunObject = Page "ChequeBook Appl. List-Approved";
                    }
                    action("Rejected Cheque Book Applications")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Bk Appl. List-Rejected";
                    }
                }
                group(ChequeClearance)
                {
                    Caption = 'Cheque Clearance';
                    action("New Cheque Clearance")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Clearance List-New";
                    }
                    action("Pending Cheque Clearance")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheq. Clearance List-Pending";
                    }
                    action("Approved Cheque Clearance")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Clearance List-Approved";
                    }
                    action("Rejected Cheque Clearance")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheq. Clearance List-Rejected";
                    }
                    action("Posted Cheque Clearance")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheq. Clearance List-Posted";
                    }

                }
                group(PeriodicActivities)
                {
                    Caption = 'Periodic Activities';

                    /*   action("Check Dormancy")
                      {
                          ApplicationArea = All;
                          RunObject = report "Check Dormancy";
                      } */

                    action("Mature Fixed Deposit")
                    {
                        ApplicationArea = All;
                        RunObject = report "Move Negative Purchase Lines";
                    }

                }
                group(CTSSetup)
                {
                    Caption = 'Setup';
                    action("CTS Setup")
                    {
                        ApplicationArea = All;
                        RunObject = Page "CTS Setup";
                    }
                    action("Cheque Reason Codes")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheq. Reason Codes";
                    }

                }
                group(CTSHistory)
                {
                    Caption = 'History';
                    action("Pending CTS Entries")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Pending CTS Entries";
                    }
                }
                group(CTSPeriodicActivities)
                {
                    Caption = 'Periodic Activities';
                    action("Recover CTS Entries")
                    {
                        ApplicationArea = All;
                        RunObject = report "Recover CTS Entries";
                    }
                }
                group(CTSReports)
                {
                    Caption = 'Reports';
                    action("Cheque Books")
                    {
                        ApplicationArea = All;
                        RunObject = report "Cheque Books";
                    }
                    action("Cheque Clearance")
                    {
                        ApplicationArea = All;
                        RunObject = report "Cheque Clearance";
                    }
                    action("CTS Entries")
                    {
                        ApplicationArea = All;
                        RunObject = report "CTS Entries";
                    }
                }

            }
            group(Audit)
            {
                action(AuditLogEntries)
                {
                    Caption = 'Audit Log Entries';
                    ApplicationArea = All;
                    RunObject = Page "Audit Log Entries";

                }
            }
            // group(GroupAttendance)
            // {
            //     Caption = 'Group Attendance';
            //     action(NewGroupAttenance)
            //     {
            //         Caption = 'New Group Attendance';
            //         RunObject = Page "Group Attendance List";
            //         ApplicationArea = All;

            //     }
            //     action(ValidatedGroupAttenance)
            //     {
            //         Caption = 'Validated Group Attendance';
            //         RunObject = Page "Validated Grp Attendance List";
            //         ApplicationArea = All;

            //     }
            //     action(GroupAttenanceReport)
            //     {
            //         Caption = 'Group Attendance Report';
            //         RunObject = report "Group Attendance";
            //         ApplicationArea = All;

            //     }
            // }
            // group(GroupCollection)
            // {
            //     Caption = 'Group Collection';
            //     action(GroupCollectionEntry)
            //     {
            //         Caption = 'Group Collection Entries';
            //         RunObject = Page "Group Collection Entries";
            //         ApplicationArea = All;

            //     }
            //     group(GroupCollectionReports)
            //     {
            //         Caption = 'Reports';
            //         action(GroupCollectionEntrie)
            //         {
            //             Caption = 'Group Collection Entries Report';
            //             RunObject = Report "Group Collection Entries";
            //             ApplicationArea = All;

            //         }
            //         action(GroupCollectionSheet)
            //         {
            //             Caption = 'Group Collection Sheet Report';
            //             RunObject = Report "Group Collection Sheet";
            //             ApplicationArea = All;

            //         }
            //         action(GroupReport)
            //         {
            //             Caption = 'Group Report';
            //             RunObject = Report "Group Report";
            //             ApplicationArea = All;

            //         }
            //     }
            // }

            // group(GroupAllocation)
            // {
            //     Caption = 'Group Allocation';
            //     action(NewGroupAllocation)
            //     {
            //         Caption = 'New Group Allocations';
            //         RunObject = Page "Group Allocations List";
            //         ApplicationArea = All;

            //     }
            //     action(PendingGroupAllocation)
            //     {
            //         Caption = 'Pending Group Allocations';
            //         RunObject = Page "Pending GP Allocations List";
            //         ApplicationArea = All;

            //     }
            //     action(ApprovedGroupAllocation)
            //     {
            //         Caption = 'Approved Group Allocations';
            //         RunObject = Page "Approved GP Allocations List";
            //         ApplicationArea = All;

            //     }
            //     action(RejectedGroupAllocation)
            //     {
            //         Caption = 'Rejected Group Allocations';
            //         RunObject = Page "Rejected GP Allocations List";
            //         ApplicationArea = All;

            //     }
            //     action(PostedGroupAllocation)
            //     {
            //         Caption = 'Posted Group Allocations';
            //         RunObject = Page "Posted GP Allocations List";
            //         ApplicationArea = All;

            //     }
            // }
            // group(PortfolioTransfer)
            // {
            //     Caption = 'Portfolio Transfer';
            //     action(NewPortfolioTransfer)
            //     {
            //         Caption = 'New Portfolio Transfer';
            //         RunObject = Page "Portfolio Transfer List";
            //         ApplicationArea = All;

            //     }
            //     action(PendingPortfolioTransfer)
            //     {
            //         Caption = 'Pending Portfolio Transfer';
            //         RunObject = Page "Pending Portfolio Transfer";
            //         ApplicationArea = All;

            //     }
            //     action(ApprovedPortfolioTransfer)
            //     {
            //         Caption = 'Approved Portfolio Transfer';
            //         RunObject = Page "Approved Portfolio Transfer";
            //         ApplicationArea = All;

            //     }
            //     action(RejectedPortfolioTransfer)
            //     {
            //         Caption = 'Rejected Portfolio Transfer';
            //         RunObject = Page "Rejected Portfolio Transfer";
            //         ApplicationArea = All;

            //     }
            //     group(History)
            //     {
            //         action(PortfolioTransferEntry)
            //         {
            //             Caption = 'Portfolio Transfer Entries';
            //             RunObject = Page "Portfolio Transfer Entries";
            //             ApplicationArea = All;

            //         }
            //     }
            // }
            group(FOSAPeriodicActivities)
            {
                Caption = 'Periodic Activities';
                action("Check Dormancy")
                {
                    ApplicationArea = All;
                    RunObject = report "Check Dormancy";
                }
                action("Mature Fixed/Call Deposit")
                {
                    ApplicationArea = All;
                    RunObject = report "Mature Fixed/Call Deposit";

                }
            }
            group(FOSAReports2)
            {
                Caption = 'Reports';
                action(MemberStatement)
                {
                    Caption = 'Members Statement';
                    ApplicationArea = All;
                    RunObject = report "Member Statement";
                }
                action(LoanStatement)
                {
                    Caption = 'Loan Statement';
                    ApplicationArea = All;
                    RunObject = report "Member Loan Statement";
                }
                action(MemberStatementCombined)
                {
                    Caption = 'Member Statement-Combined';
                    ApplicationArea = All;
                    RunObject = report "Member Statement-Combined";
                }
                action(MemberListingReport)
                {
                    Caption = 'Member Listing Report';
                    ApplicationArea = All;
                    RunObject = report "Member Listing Report";
                }
                action(MemberDormancyReport)
                {
                    Caption = 'Member Dormancy Report';
                    ApplicationArea = All;
                    RunObject = report "Member Dormancy Report";
                }
                action(MemberNomineeReport)
                {
                    Caption = 'Member Nominee Report';
                    ApplicationArea = All;
                    RunObject = report "Member Nominee Report";
                }
                action(MemberAccountsSummary)
                {
                    Caption = 'Members & Accounts Summary';
                    ApplicationArea = All;
                    RunObject = report "Members & Accounts Summary";
                }
                action(MobileBankingReport)
                {
                    Caption = 'Mobile Banking Transactions';
                    ApplicationArea = All;
                    RunObject = report "Mobile Banking Transactions";
                }
            }
            group(Setup)
            {
                action("Account Types")
                {
                    ApplicationArea = All;
                    RunObject = Page "Account Type List";

                }
                action("Transaction Types")
                {
                    ApplicationArea = All;
                    RunObject = Page "Transaction Types List";

                }


                action("Cheque Types")
                {
                    ApplicationArea = All;
                    RunObject = Page "Cheque Types";

                }

                action("Banks")
                {
                    ApplicationArea = All;
                    RunObject = Page Banks;

                }
                action("Bank Branches")
                {
                    ApplicationArea = All;
                    RunObject = Page "Banks Branch";

                }
                action("Member Categories")
                {
                    ApplicationArea = All;
                    RunObject = Page "Member Categories";

                }
                action(FOSAAgencies)
                {
                    Caption = 'Agencies';
                    ApplicationArea = All;
                    RunObject = page "Remittance Agent Setup";

                }
                action(AuditLogSetup)
                {
                    Caption = 'Audit Log Setup';
                    ApplicationArea = All;
                    RunObject = Page "Audit Log Table Setup";

                }

            }

        }
        area(Embedding)
        {
            group(Members)
            {
                Caption = 'Members';
                group(IndividualMembers)
                {
                    action(MembersIndividual)
                    {
                        Caption = 'Individuals';
                        RunObject = Page "Member List";
                        ApplicationArea = All;
                    }
                    action(MembersPastors)
                    {
                        Caption = 'Pastors';
                        RunObject = Page MemberListPastor;
                        ApplicationArea = All;

                    }
                }
                group(GroupMembers)
                {
                    action(MembersGroup)
                    {
                        Caption = 'Groups';
                        RunObject = Page MemberListGroup;
                        ApplicationArea = All;

                    }
                    action(MembersChurches)
                    {
                        Caption = 'Churches';
                        RunObject = Page MemberListChurch;
                        ApplicationArea = All;

                    }
                }
                action(MembersJunior)
                {
                    Caption = 'Junior Members';
                    RunObject = Page MemberListJunior;
                    ApplicationArea = All;

                }
                action(MembersStaff)
                {
                    Caption = 'Staff';
                    RunObject = Page MemberListStaff;
                    ApplicationArea = All;

                }
                action(MembersBoard)
                {
                    Caption = 'Board';
                    RunObject = Page MemberListBoard;
                    ApplicationArea = All;

                }
            }
            action(RequestApproval)
            {
                Caption = 'Requests To Approve';
                RunObject = Page "Requests to Approve";
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
            action(AccountTypes)
            {
                Caption = 'Account Types';
                RunObject = Page "Account Type List";
                ApplicationArea = All;

            }


            action(LoanOfficerSetup)
            {
                Caption = 'Loan Officer Setup';
                RunObject = Page "Loan Recovery Officer Setup";
                ApplicationArea = All;
            }
            action(CTSSetup2)
            {
                Caption = 'CTS Setup';
                Visible = false;
                Enabled = false;
                RunObject = Page "CTS Setup";
                ApplicationArea = All;
            }

            action(GlobalSetup)
            {
                Caption = 'Global Setup';
                RunObject = Page "Global Setup";
                ApplicationArea = All;
            }
            action("SMSEntries")
            {
                Caption = 'SMS Entries';
                RunObject = Page "SMS Entries";
                ApplicationArea = All;
            }
            action("Districts")
            {
                Caption = 'Church Districts List';
                RunObject = Page "Church District List";
                ApplicationArea = All;
            }
            action("CSections")
            {
                Caption = 'Church Sections List';
                RunObject = Page "Church Section List";
                ApplicationArea = All;
            }
            action("Church")
            {
                Caption = 'Church List';
                RunObject = Page "Church List";
                ApplicationArea = All;
            }


        }
        area(Processing)
        {
            group(PeriodActivities)
            {
                Caption = 'Periodic Activities';
                action(CheckDormancy)
                {
                    Caption = 'Check Dormancy';
                    RunObject = report "Check Dormancy";
                    ApplicationArea = All;
                }
                action(MatureFixedCallDeposit)
                {
                    Caption = 'Mature Fixed/Call Deposit';
                    RunObject = report "Mature Fixed/Call Deposit";
                    ApplicationArea = All;
                }

            }
            group(Reports)
            {
                action(MemberStatement3)
                {
                    Caption = 'Members Statement';
                    ApplicationArea = All;
                    RunObject = report "Member Statement";
                }
                action(LoanStatement3)
                {
                    Caption = 'Loan Statement';
                    ApplicationArea = All;
                    RunObject = report "Member Loan Statement";
                }
                action(MemberStatementCombined3)
                {
                    Caption = 'Member Statement-Combined';
                    ApplicationArea = All;
                    RunObject = report "Member Statement-Combined";
                }
                action(MemberListingReport3)
                {
                    Caption = 'Member Listing Report';
                    ApplicationArea = All;
                    RunObject = report "Member Listing Report";
                }
                action(JuniorMemberListingReport)
                {
                    Caption = 'Junior Member Listing Report';
                    ApplicationArea = All;
                    RunObject = report "Junior Member Listing Report";
                }
                action(MemberContribution2)
                {
                    Caption = 'Member Contributions';
                    Image = "Report";
                    RunObject = Report "Member Contributions";
                    ApplicationArea = All;
                }
                action(DailyCashAnalysis2)
                {
                    Caption = 'Daily Cash Analysis';
                    Image = "Report";
                    RunObject = Report "Daily Cash Analysis";
                    ApplicationArea = All;
                }

            }
        }
        area(Creation)
        {
            action(NewMemberApplication)
            {
                Caption = 'New Member Application';
                Image = NewInvoice;
                RunObject = Page "Member Application Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewAccountOpening)
            {
                Caption = 'New Account Opening';
                Image = NewInvoice;
                RunObject = Page "Account Opening Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewMobileBankingApplication)
            {
                Caption = 'New Mobile Banking Application';
                Image = NewInvoice;
                RunObject = Page "Mobile Banking Appl. Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewMobileBankingActivation2)
            {
                Caption = 'New Mobile Banking Activation';
                Image = NewInvoice;
                RunObject = Page "Mobile Banking Activation";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewATMApplication2)
            {
                Caption = 'New ATM Application';
                Image = NewInvoice;
                Visible = false;
                Enabled = false;
                RunObject = Page "ATM Application Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewATMCollection2)
            {
                Caption = 'New ATM Collection';
                Image = NewInvoice;
                Visible = false;
                Enabled = false;
                RunObject = Page "ATM Collection Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewATMActivation2)
            {
                Caption = 'New ATM Activation';
                Image = NewInvoice;
                Visible = false;
                Enabled = false;
                RunObject = Page "ATM Activation";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewChequeBook)
            {
                Caption = 'New Cheque Book';
                Image = NewInvoice;
                Visible = false;
                Enabled = false;
                RunObject = Page "Cheque Book";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewChequeBookApplication)
            {
                Caption = 'New Cheque Book Application';
                Image = NewInvoice;
                Visible = false;
                Enabled = false;
                RunObject = Page "Cheque Book Application";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewChequeClearance)
            {
                Caption = 'New Cheque Clearance';
                Image = NewInvoice;
                Visible = false;
                Enabled = false;
                RunObject = Page "Cheque Clearance";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            // action(NewGroupAttendance)
            // {
            //     Caption = 'New Group Attendance';
            //     Image = NewInvoice;
            //     RunObject = Page "Group Attendance";
            //     RunPageMode = Create;
            //     ApplicationArea = All;
            // }
            // action(NewGroupAllocation2)
            // {
            //     Caption = 'New Group Allocation';
            //     Image = NewInvoice;
            //     RunObject = Page "Group Allocation";
            //     RunPageMode = Create;
            //     ApplicationArea = All;
            // }
            // action(NewPortfolioTransfer2)
            // {
            //     Caption = 'New Portfolio Transfer';
            //     Image = NewInvoice;
            //     RunObject = Page "Portfolio Transfer Card";
            //     RunPageMode = Create;
            //     ApplicationArea = All;
            // }
        }
        /*  area(Reporting)
         {
             action(MemberContribution)
             {
                 Caption = 'Member Contributions';
                 Image = "Report";
                 RunObject = Report "Member Contributions";
                 ApplicationArea = All;
             }
             action(DailyCashAnalysis)
             {
                 Caption = 'Daily Cash Analysis';
                 Image = "Report";
                 RunObject = Report "Daily Cash Analysis";
                 ApplicationArea = All;
             }


         } */
    }
}
// Creates a profile that uses the Role Center
profile FOSAProfile
{
    ProfileDescription = 'FOSA Profile';
    RoleCenter = "FOSA RoleCenter";
    Caption = 'FOSA';
}

