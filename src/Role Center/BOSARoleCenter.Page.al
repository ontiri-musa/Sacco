page 50346 "BOSA RoleCenter"
{
    PageType = RoleCenter;
    Caption = 'BOSA Role Center';
    layout
    {
        area(RoleCenter)
        {

            part(Part1; "BOSA RoleCenter Headline")
            {
                ApplicationArea = All;
            }

            part(Part2; "BOSA Activities")
            {
                Caption = 'BOSA';
                ApplicationArea = All;
            }
            part(Control1; "Branch Analysis-LProduct Chart")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control2; "Classification Summary Chart")
            {
                ApplicationArea = Basic, Suite;
            }

        }
    }

    actions
    {
        area(Sections)
        {

            group(LoanApplication)
            {
                Caption = 'Loan Application';

                action("New Loan Application")
                {
                    RunObject = Page "Loan Application List-New";
                    ApplicationArea = All;
                }
                action("Loans Pending Appraisal")
                {
                    RunObject = Page "Loan Appl. List-Pending Apprsl";
                    ApplicationArea = All;
                }
                action("Loans Pending Disbursal")
                {
                    RunObject = Page "Loan Appl. List-Pending Dbsl";
                    ApplicationArea = All;
                }
                action("Rejected Loans")
                {
                    RunObject = Page "Loans Appl. List-Rejected";
                    ApplicationArea = All;
                }
                action("Posted Loans")
                {
                    RunObject = Page "Loan Applications List-Posted";
                    ApplicationArea = All;
                }
                action("Cleared Loans")
                {
                    RunObject = Page "Loan Applications List-Cleared";
                    ApplicationArea = All;
                }
                action("Loans Debt Collection")
                {
                    RunObject = Page "Loans Debt Collection List";
                    ApplicationArea = All;
                }
                action("All Posted Loans")
                {
                    RunObject = Page "Loans Posted All";
                    ApplicationArea = All;
                }
                group(LASetup)
                {
                    Caption = 'Setup';
                    action("Loan Application Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Application Setup";
                    }
                    action("Loan Charges Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Charge Setup";
                    }
                    action("Loan Securities Register")
                    {
                        ApplicationArea = All;
                        RunObject = page "Securiy Register";
                    }
                    action("Loan Automations")
                    {
                        ApplicationArea = All;
                        RunObject = page "Automations Log Entries";
                    }
                    group("Sectoral Setup")
                    {
                        action("Economic Sectors")
                        {
                            ApplicationArea = All;
                            RunObject = page "Economic Sectors";
                        }
                        action("Economic Sector Categories")
                        {
                            ApplicationArea = All;
                            RunObject = page "Economic Sector Categories";
                        }
                        action("Economic Sector Sub-Categories")
                        {
                            ApplicationArea = All;
                            RunObject = page "Economic Sector Sub-Categories";
                        }
                    }

                }
            }


            group(LoanRecovery)
            {
                Visible = true;
                Caption = 'Loan Recovery From Deposits';
                action("New Loan Recovery")
                {
                    RunObject = Page "Loan Recovery List-New";
                    ApplicationArea = All;
                }
                action("Posted Loan Recovery")
                {
                    RunObject = Page "Loan Recovery List-Posted";
                    ApplicationArea = All;
                }
                action("Reversed Loan Recovery")
                {
                    RunObject = Page "LoanRecov List-Posted-Reversed";
                    ApplicationArea = All;
                }
                group(LoanProcess)
                {
                    Visible = false;
                    action(LoanRecoveryFromDepositsEntries)
                    {
                        Caption = 'Loans Recovered From Deposits Entries';
                        ApplicationArea = All;
                        RunObject = page "Loan Recovered Entries";
                    }
                    action(RunLoanRecoveryFromDeposits)
                    {
                        Caption = 'Run Loan Recovery From Deposits';
                        ApplicationArea = All;
                        RunObject = codeunit "Recover Loans From Deposits";
                    }
                    action(RunLoanRecoveryFromPrepayments)
                    {
                        Caption = 'Run Loan Recovery From Prepayments';
                        ApplicationArea = All;
                        RunObject = page "Loan Prepayment Recovery List";
                    }
                }
            }
            group(Recovery)
            {
                Visible = true;
                Caption = 'Recoveries';
                action("Recovery1")
                {
                    Caption = 'Recovery';
                    RunObject = Page "Recovery List-New";
                    ApplicationArea = All;
                }
                action("Recovery2")
                {
                    Caption = 'Posted Recoveries';
                    RunObject = Page "Recovery List-Posted";
                    ApplicationArea = All;
                }


            }
            group(LoanClassification)
            {
                Caption = 'Loan Classification';
                action("Classification Entries")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Classification Entries";
                }
                action("Classification Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Classification Setup";
                }
                action("Generate Classification")
                {
                    ApplicationArea = All;
                    RunObject = report "Generate Loan Classification";
                }
            }
            group(FundTransfer)
            {
                Caption = 'Fund Transfer';
                action("New Fund Transfer")
                {
                    ApplicationArea = All;
                    RunObject = page "Fund Transfer List-New";

                }
                action("Pending Fund Transfer")
                {
                    ApplicationArea = All;
                    RunObject = page "Fund Transfer List-Pending";

                }
                action("Approved Fund Transfer")
                {
                    ApplicationArea = All;
                    RunObject = page "Fund Transfer List-Approved";

                }
                action("Rejected Fund Transfer")
                {
                    ApplicationArea = All;
                    RunObject = page "Fund Transfer List-Rejected";

                }
                action("Posted Fund Transfer")
                {
                    ApplicationArea = All;
                    RunObject = page "Fund Transfer List-Posted";

                }
                group(FTSetup)
                {
                    Caption = 'Setup';
                    action("Fund Transfer Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Fund Transfer Setup";
                    }

                }
            }
            group(LoanRescheduling)
            {
                Caption = 'Loan Rescheduling';
                action("New Loan Rescheduling")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Rescheduling List-New";
                }
                action("Pending Loan Rescheduling")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Rescheduling List-Pending";
                }
                action("Approved Loan Rescheduling")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Resched. List-Approved";
                }
                action("Rejected Loan Rescheduling")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Resched. List-Rejected";
                }
                group(LSSetup)
                {
                    Caption = 'Setup';
                    action("Loan Rescheduling Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Rescheduling Setup";
                    }
                }
            }
            group(LoanRestructuring)
            {
                Caption = 'Loan Restructuring';
                action("New Loan Restructuring")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Restruct List-New";
                }
                action("Pending Loan Restructuring")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Restruct List-Pending";
                }
                action("Approved Loan Restructuring")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Restruct List-Approved";
                }
                action("Rejected Loan Restructuring")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Restruct List-Rejected";
                }
                group(LSRSetup)
                {
                    Caption = 'Setup';
                    action("Loan Restructuring Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Restructuring Setup";
                    }
                }
            }
            group(LoanNotification)
            {
                Caption = 'Loan Notification';
                action("Default Notification")
                {
                    ApplicationArea = All;
                    RunObject = page "Default Notification List";
                }
                action("Notification Entries")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Notification Entries";
                }
                action("Notification Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Notification Setup";
                }
            }
            group(GuarantorSubstitution)
            {
                Caption = 'Guarantor Substitution';
                action("New Guarantor Substitution")
                {
                    ApplicationArea = All;
                    RunObject = page "Guarantor Subst. List-New";
                }
                action("Pending Guarantor Substitution")
                {
                    ApplicationArea = All;
                    RunObject = page "Guarantor Sub. List-Pending";
                }
                action("Approved Guarantor Substitution")
                {
                    ApplicationArea = All;
                    RunObject = page "Guarantor Subst. List-Approved";
                }
                action("Rejected Guarantor Substitution")
                {
                    ApplicationArea = All;
                    RunObject = page "Guarantor Sub. List-Rejected";
                }
                action("GuarantorSubstitutionEntries")
                {
                    Caption = 'Guarantor Substitution Entries';
                    ApplicationArea = All;
                    RunObject = page "Guarantor Substitution Entries";
                }
                group(GuarantorSubstitutionSetup)
                {
                    Caption = 'Setup';
                    action("GuarantorSubstitutionSetup2")
                    {
                        Caption = 'Guarantor Substitution Setup';
                        ApplicationArea = All;
                        RunObject = page "Guarantor Substitution Setup";
                    }
                }
            }
            group(Payout)
            {
                Caption = 'Payout Processing';
                Visible = false;
                action("New Payout")
                {
                    ApplicationArea = All;
                    RunObject = page "Payout List-New";
                }
                action("Pending Payout")
                {
                    ApplicationArea = All;
                    RunObject = page "Payout List-Pending";
                }
                action("Approved Payout")
                {
                    ApplicationArea = All;
                    RunObject = page "Payout List-Approved";
                }
                action("Rejected Payout")
                {
                    ApplicationArea = All;
                    RunObject = page "Payout List-Rejected";
                }
                action("Posted Payout")
                {
                    ApplicationArea = All;
                    RunObject = page "Payout List-Posted";
                }
                group(PayoutSetup)
                {
                    Caption = 'Setup';
                    action("Payout Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Payout Setup";
                    }
                    action("Payout Types")
                    {
                        ApplicationArea = All;
                        RunObject = page "Payout Types List";
                    }
                }
            }
            group(LoanSelloff)
            {
                Caption = 'Loan Selloff';
                Visible = false;
                action("New Loan Selloff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Selloff List-New";
                }
                action("Pending Loan Selloff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Selloff List-Pending";
                }
                action("Approved Loan Selloff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Selloff List-Approved";
                }
                action("Rejected Loan Selloff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Selloff List-Rejected";
                }
                action("Posted Loan Selloff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Selloff List-Posted";
                }
                group(LoanSelloffSetup)
                {
                    Caption = 'Setup';
                    action("Loan Selloff Charges")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Selloff Charges";
                    }
                    action("Loan Selloff Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Selloff Setup";
                    }
                }
            }
            group(LoanWriteofff)
            {
                Caption = 'Loan Writeoff';
                action("New Loan Writeofff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Writeoff List-New";
                }
                action("Pending Loan Writeoff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Writeoff List-Pending";
                }
                action("Approved Loan Writeoff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Writeoff List-Approved";
                }
                action("Rejected Loan Writeoff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Writeoff List-Rejected";
                }
                action("Posted Loan Writeoff")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Writeoff List-Posted";
                }
                group(LWSetup)
                {
                    Caption = 'Setup';
                    action("Loan Writeoff Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Writeoff Setup";
                    }
                }
            }
            group(Remittance)
            {
                Caption = 'Remittance Processing';
                action("Member Advice")
                {
                    ApplicationArea = All;
                    RunObject = page "Member Remittance Advice List";
                }
                action("Agency Advice")
                {
                    ApplicationArea = All;
                    RunObject = page "Agency Remittance Advice List";
                }
                action("Generate Member Advice")
                {
                    ApplicationArea = All;
                    RunObject = report "Generate Member Advice";
                }
                action("Generate Agency Advice")
                {
                    ApplicationArea = All;
                    RunObject = report "Generate Agency Advice";
                }
                group(RemittanceSetup)
                {
                    Caption = 'Setup';
                    action("Remittance Codes")
                    {
                        ApplicationArea = All;
                        RunObject = page "Remittance Codes";
                    }
                    action("Remittance Periods")
                    {
                        ApplicationArea = All;
                        RunObject = page "Remittance Periods";
                    }
                    action("Remittance Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Remittance Setup";
                    }
                    action("Agencies")
                    {
                        ApplicationArea = All;
                        RunObject = page "Remittance Agent Setup";
                    }
                }
            }
            group(ExitManagement)
            {
                Caption = 'Exit Management';
                group(ExitProcessing)
                {
                    Caption = 'Exit Processing';
                    action("New Member Exit")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Exit List-New";

                    }
                    action("Pending Member Exit")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Exit List-Pending";

                    }
                    action("Approved Member Exit")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Exit List-Approved";

                    }
                    action("Posted Member Exit")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Exit List-Posted";

                    }
                    action("Rejected Member Exit")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Exit List-Rejected";

                    }
                    group(ExitReports)
                    {
                        Caption = 'Exit Reports';
                        action("Member Exit Summary Report")
                        {
                            ApplicationArea = All;
                            RunObject = report "Member Exit Summary";

                        }

                    }
                }
                group(RefundProcessing)
                {
                    Caption = 'Refund Processing';
                    Visible = false;
                    action("New Member Refund")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Refund List-New";

                    }
                    action("Pending Member Refund")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Refund List-Pending";

                    }
                    action("Approved Member Refund")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Refund List-Approved";

                    }
                    action("Posted Member Refund")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Refund List-Posted";

                    }

                }
                group(ClaimProcessing)
                {
                    Caption = 'Claim Processing';
                    Visible = false;
                    action("New Member Claim")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Claim List-New";

                    }
                    action("Pending Member Claim")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Claim List-Pending";

                    }
                    action("Approved Member Claim")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Claim List-Approved";

                    }
                    action("Posted Member Claim")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Claim List-Posted";

                    }

                }
                group(ExitSetup)
                {
                    Caption = 'Setup';
                    action("Exit Fees")
                    {
                        ApplicationArea = All;
                        RunObject = page "Exit Fees";
                    }
                    action("Exit Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Exit Setup";
                    }
                }
            }
            group(ArchiveManagement)
            {
                Caption = 'Archive Management';
                group(ArchiveProcessing)
                {
                    Caption = 'Archive Processing';
                    action("New Member Archive")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Achive List-New";

                    }
                    action("Pending Member Archive")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Achive List-Pending";

                    }
                    action("Approved Member Archive")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Achive List-Approved";

                    }
                    action("Archived Members")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Achive List-Posted";

                    }
                }
            }
            group(DividendProcessing)
            {
                Caption = 'Dividend Processing';
                group(SharesDeposits)
                {
                    Caption = 'Share Capital & Member Deposits';
                    action("New Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividends List-New";
                    }
                    action("Pending Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividends List-Pending";
                    }
                    action("Approved Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividends List-Approved";
                    }
                    action("Posted Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividends List-Posted";
                    }
                }
                group(BoreshaInterest)
                {
                    Caption = 'Boresha Savings';
                    action("New Boresha Interest")
                    {
                        ApplicationArea = All;
                        RunObject = page "BoreshaSavingsInterestList-New";
                    }
                    action("Posted Boresha Interest")
                    {
                        ApplicationArea = All;
                        RunObject = page "BoreshaSavingsIntList-Posted";
                    }
                }
                group(DividendsSetup)
                {
                    Caption = 'Setup';
                    action("Dividends Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividend Setup";
                    }
                    action("Dividend Loan Products")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividend Loan Products";
                    }
                }
            }
            group(DefaulterManagement)
            {
                Caption = 'Defaulter Management';
                action("Loan Defaulter Entries")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Defaulter Entries";
                }
                group(DefaulterPeriodicActivities)
                {
                    Caption = 'Periodic Activities';
                    action("Generate Defaulted Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Generate Defaulted Loans";
                    }

                    action("Send Defaulter Notice")
                    {
                        ApplicationArea = All;
                        RunObject = report "Send Defaulter Notice";
                    }
                    action("Recover Loan From Guarantor Deposits")
                    {
                        ApplicationArea = All;
                        RunObject = report RecoverLoanFromGuarantor;
                    }
                    action("Attach Loan to Guarantor")
                    {
                        ApplicationArea = All;
                        RunObject = report "Attach Loan to Guarantor";
                    }
                    action("Reverse Attached Loan")
                    {
                        ApplicationArea = All;
                        RunObject = report "Reverse Attached Loan";
                    }
                }
                group(LoanDefaulterSetup)
                {
                    Caption = 'Setup';
                    action("Loan Defaulter Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Defaulter Setup";
                    }
                }
            }
            group(PeriodicActivities)
            {
                Caption = 'Periodic Activities';
                action("CapitalizeInterest2")
                {
                    Caption = 'Run Monthly Interest';
                    ApplicationArea = All;
                    RunObject = report "Run Monthly Interest";
                }
                action(CapitalizeLedgerFee)
                {
                    Caption = 'Capitalize Ledger Fee';
                    ApplicationArea = All;
                    Visible = false;
                    RunObject = report "Capitalize Ledger Fee";
                }
                action(CapitalizePenalty2)
                {
                    Caption = 'Run Monthly Penalty';
                    ApplicationArea = All;
                    RunObject = report "Run Monthly Penalty";
                }
                action(RecoverPenalty)
                {
                    Caption = 'Recover Penalty';
                    ApplicationArea = All;
                    Visible = false;
                    RunObject = report "Recover Penalty Charges.";
                }
                action(RecoverFromPrepayments)
                {
                    Caption = 'Prepayment Recovery';
                    ApplicationArea = All;
                    Visible = false;
                    RunObject = report "Run Prepayment Recovery";
                }
                action("Run Standing Order")
                {
                    ApplicationArea = All;
                    RunObject = report "Run Standing Order";
                }
                action("Run Loan Recovery")
                {
                    ApplicationArea = All;
                    RunObject = report "Run Loan Recovery";
                }
                action(OverpaymentTransfer2)
                {
                    Caption = 'Overpayment Transfer';
                    RunObject = report "Overpayment Transfer";
                    ApplicationArea = All;
                }
                action("Share Deposits")
                {
                    ApplicationArea = All;
                    RunObject = report "Share Capital End Month";
                }
                action("Benevolent Deposits")
                {
                    ApplicationArea = All;
                    RunObject = report "Benevolent  End Month";
                }

            }
            group(Notification)
            {
                action("SMS Entries")
                {
                    ApplicationArea = All;
                    RunObject = page "SMS Entries";
                }
                action("Bulk SMS Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Bulk SMS Setup";
                }
            }
            group(BOSAReports)
            {
                Caption = 'Reports';
                action("Loan Repayment Schedule")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Repament Schedule";
                }
                action("Branch Performance")
                {
                    ApplicationArea = All;
                    RunObject = report "Branch Performance";
                }
                action("Branch Portfolio")
                {
                    ApplicationArea = All;
                    RunObject = report "Branch Portfolio Report";
                }
                action("Loan Securities")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Securities";
                }
                action("Loan Guarantors")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Guarantors";
                }

                action("Loan Provisioning")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Provisioning Report";
                }
                action("Loan Classification")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Classification Report";
                }
                action("Loan Classification Custom")
                {
                    ApplicationArea = All;
                    RunObject = report "LoanClassificati CustomReport";
                }
                action("Disbursed Loans")
                {
                    ApplicationArea = All;
                    RunObject = report "Disbursed Loans";
                }
                action("Defaulted Loans")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Defaulters";
                }
                action("Loan Insurrance Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Insurrance Report";
                }
                action("Classification Summary")
                {
                    ApplicationArea = All;
                    RunObject = report "Classification Summary";
                }
                action("Classification Summary Custom")
                {
                    ApplicationArea = All;
                    RunObject = report "Classification Summary Custom";
                }
                action("Classification Summary-Per Branch")
                {
                    ApplicationArea = All;
                    RunObject = report "Classification Summary- Branch";
                }
                action("Loan Arrears")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Arrears";
                }
                action("NWDs vs Loan Book")
                {
                    ApplicationArea = All;
                    RunObject = report "NWDs vs Loan Book";
                }
                action("Loan Status")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Status";
                }
                action("Loan Funds Transfer Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Funds Transfer Report";
                }
                action("Loan Principal Repayments Report")
                {
                    ApplicationArea = All;
                    RunObject = report "LoanPrincipalRepayments Report";
                }
                action("Loan Interest Payments Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Interest Payments Report";
                }
                action("Loan Penalty Payments Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Penalty Payments Report";
                }
                action("Loan Ledger Fee Payments Report")
                {
                    ApplicationArea = All;
                    RunObject = report LoanLedgerFeePaymentsReport;
                }
                action("Expired Loan Charged Interest Listing Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Expired Loan Listing Report";
                }
                action("Loan Listing")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Listing Report";
                }
                action("Loan Statement")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Loan Statement";
                }
                action("Member Listing")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Listing Report";
                }
                action("Member Statement")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Statement";
                }
                action("Member Statement-Combined")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Statement-Combined";
                }
                action("LoanEligibility")
                {
                    ApplicationArea = All;
                    RunObject = report "Mobile Loan Eligibilty Report";
                }
                action("Loan Movement")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Movement";
                }
                action("G/L vs MPA per Branch")
                {
                    ApplicationArea = All;
                    RunObject = report "G/L vs MPA By Branch";
                }
                action("G/L vs MPA per Product")
                {
                    ApplicationArea = All;
                    RunObject = report "G/L vs MPA By Product";
                }
                action("Loan Securities2")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Securities";
                }
                action("CRB Report")
                {
                    ApplicationArea = All;
                    RunObject = report "CRB Report org";
                }
                action("Demand Letter")
                {
                    ApplicationArea = All;
                    RunObject = report "Demand Letter";
                }
                action("Account Types Listing")
                {
                    ApplicationArea = All;
                    RunObject = report "Account Types Listing";
                }
                action("Share Certificate")
                {
                    ApplicationArea = All;
                    RunObject = report "Share Certificate";
                }
                action("Product Matrix")
                {
                    ApplicationArea = All;
                    RunObject = report "Products Matrix";
                }
                action("Yield Analysis")
                {
                    ApplicationArea = All;
                    RunObject = report "Yield Analysis";
                }
                action("Accounts Movement")
                {
                    ApplicationArea = All;
                    RunObject = report "Accounts Movement";
                }
                action("Rescheduled Loans")
                {
                    ApplicationArea = All;
                    RunObject = report "Rescheduled Loans";
                }
                action("Sold Loans")
                {
                    ApplicationArea = All;
                    RunObject = report "Sold Loans";
                }
                action("Guarantor Substitution Entries")
                {
                    ApplicationArea = All;
                    RunObject = report "Guarantor Substitution Entries";
                }
                action("Standing Orders")
                {
                    ApplicationArea = All;
                    RunObject = report "Standing Orders";
                }
                action("Payout Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Payout Report";
                }
                action("Dividend Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Dividends Report";
                }
                action("Member Remittance Advice")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Remittance Advice";
                }
                action("Agency Remittance Advice")
                {
                    ApplicationArea = All;
                    RunObject = report "Agency Remittance Advice";
                }
                action("Member Refunds")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Refund";
                }
                action("Exit Requests")
                {
                    ApplicationArea = All;
                    RunObject = report "Exit Request";
                }
                action("Member Claims")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Claim";
                }
                action("Written off Loans")
                {
                    ApplicationArea = All;
                    RunObject = report "Written off Loans";
                }
                action("Members & Accounts Summary per Branch")
                {
                    ApplicationArea = All;
                    RunObject = report "Members & Accounts Summary";
                }
                action("Boresha Movement")
                {
                    ApplicationArea = All;
                    RunObject = report "Boresha Movements Reports";
                }




            }
            group(BOSASetup)
            {
                Caption = 'Setup';
                action("Global Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Global Setup";
                }
                action("Loan Product Types")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Product Type List";
                }
                action("Source Codes")
                {
                    ApplicationArea = All;
                    RunObject = page "Source Code List";
                }
                action("Source Code Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Source Code Setup";
                }
                action("Loan Officer Recovery")
                {
                    Caption = 'Loan Recivery Officer SetUp';
                    ApplicationArea = All;
                    RunObject = page "Recovery Officer Setup";
                }

            }

        }
        area(Embedding)
        {

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
            action(LoanProductType)
            {
                Caption = 'Loan Product Types';
                RunObject = Page "Loan Product Type List";
                ApplicationArea = All;
            }


            action(GlobalSetup)
            {
                Caption = 'Global Setup';
                RunObject = Page "Global Setup";
                ApplicationArea = All;
            }
            action(LoanOfficerSetup)
            {
                Caption = 'Loan Officer Setup';
                RunObject = Page "Loan Recovery Officer Setup";
                ApplicationArea = All;
            }
            action(SMSEntries)
            {
                Caption = 'SMS Entries';
                RunObject = Page "SMS Entries";
                ApplicationArea = All;
            }
            action(PostedLoanEntries)
            {
                Caption = 'Posted Loan Entries';
                RunObject = Page "Posted Loan Ledger Entries";
                ApplicationArea = All;
            }
            action("Requests To Approve")
            {
                RunObject = Page "Requests to Approve";
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
                    Caption = 'Run Monthly Interest';
                    RunObject = report "Run Monthly Interest";
                    ApplicationArea = All;
                }
                action(CapitalizePenalty)
                {
                    Caption = 'Run Monthly Penalty';
                    RunObject = report "Run Monthly Penalty";
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
                action(OverpaymentTransfer)
                {
                    Caption = 'Overpayment Transfer';
                    RunObject = report "Overpayment Transfer";
                    ApplicationArea = All;
                }
                action(SMSProcesing)
                {
                    Caption = 'SMS Processing';
                    RunObject = report "SMS Processing";
                    ApplicationArea = All;
                }
                action(RecalculateSchedule)
                {
                    Caption = 'Recalculate Schedule';
                    RunObject = report "Recalculate Schedule";
                    ApplicationArea = All;
                }
            }
            group("SASRA Reports")
            {
                action(LoanSecurities2)
                {
                    Caption = 'Loan Securities';
                    Image = "Report";
                    RunObject = Report "Loan Securities";
                    ApplicationArea = All;
                }
                action(BranchPortfolio2)
                {
                    Caption = 'Branch Portfolio';
                    Image = "Report";
                    RunObject = Report "Branch Portfolio Report";
                    ApplicationArea = All;
                }

                action(LiquidityStatementReturn)
                {
                    Caption = 'Liquidity Statement Return';
                    Image = "Report";
                    RunObject = Report "Liquidity Statement Return";
                    ApplicationArea = All;
                }
                action(StatementDepositReturn)
                {
                    Caption = 'Statement of Deposit Return';
                    Image = "Report";
                    RunObject = Report "Statement of Deposit Return";
                    ApplicationArea = All;
                }
                action(RiskClassificationofAssetsProvisioning)
                {
                    Caption = 'Risk Classification of Assets and Provisioning';
                    Image = "Report";
                    RunObject = Report "Risk Class. of Assets Prov.";
                    ApplicationArea = All;
                }
                action(RiskClassificationofAssetsProvisioningCustom)
                {
                    Caption = 'Risk Classification of Assets and Provisioning Custom';
                    Image = "Report";
                    RunObject = Report "Risk Class. of Assets Prov.2";
                    ApplicationArea = All;
                }
                action(ReturnOnInvestment)
                {
                    Caption = 'Return On Investment';
                    Image = "Report";
                    RunObject = Report "Return On Investment";
                    ApplicationArea = All;
                }
                action(StatementComprehensiveIncome)
                {
                    Caption = 'Statement of Comprehensive Income';
                    Image = "Report";
                    RunObject = Report "Statement of Compre. Income";
                    ApplicationArea = All;
                }
                action(StatementFinancialPosition)
                {
                    Caption = 'Statement of Financial Position';
                    Image = "Report";
                    RunObject = Report "Statement of Fin. Position";
                    ApplicationArea = All;
                }
                action(StatementOtherDisclosures)
                {
                    Caption = 'Statement of Other Disclosures';
                    Image = "Report";
                    RunObject = Report "Statemnt of Other Disclosures";
                    ApplicationArea = All;
                }
                action(CapitalAdequacyReturn)
                {
                    Caption = 'Capital Adequacy Return';
                    Image = "Report";
                    RunObject = Report "Capital Adequacy Return";
                    ApplicationArea = All;
                }
                action(InsiderLendingPerformanceReturn)
                {
                    Caption = 'Insider Lending and Performance Return';
                    Image = "Report";
                    RunObject = Report "Insider Lending Perfom Return";
                    ApplicationArea = All;
                }
                action(SectoralLendingLoanClassificationReturn)
                {
                    Caption = 'Sectoral Lending Loan Classification Return';
                    Image = "Report";
                    RunObject = Report "Sectoral Lending Report";
                    ApplicationArea = All;
                }
                group(ReportSetup)
                {
                    Caption = 'Sasra Reports Mapping Setup';
                    action(SasraSetup)
                    {
                        ApplicationArea = All;
                        Caption = 'Setup';
                        Image = Setup;
                        RunObject = page "Sasra Reports Mapping Setup";

                    }
                }
            }
            group("Loan Reports")
            {
                Visible = false;
                action(LoanProvisioning)
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Provisioning Report";
                }
                action(LoanClassifications)
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Classification Report";
                }
                action(DisbursedLoans)
                {
                    ApplicationArea = All;
                    RunObject = report "Disbursed Loans";
                }
                action(DefaultedLoans)
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Defaulters";
                }
                action(ClassificationSummary)
                {
                    ApplicationArea = All;
                    RunObject = report "Classification Summary";
                }
                action(ClassificationSummaryPerBranch)
                {
                    ApplicationArea = All;
                    RunObject = report "Classification Summary- Branch";
                }
                action("Loan Movement Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Movement Report New";
                }
                action("LoanArrears")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Arrears";
                }
                action("NWDs vsLoan Book")
                {
                    ApplicationArea = All;
                    RunObject = report "NWDs vs Loan Book";
                }
                action("LoanStatus")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Status";
                }
                action("LoanListing")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Listing Report";
                }
                action("LoanStatementA")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Loan Statement";
                }
                action("MemberListing")
                {
                    ApplicationArea = All;
                    RunObject = report "Member Listing Report";
                }

                action("G/Lvs MPA per Branch")
                {
                    ApplicationArea = All;
                    RunObject = report "G/L vs MPA By Branch";
                }
                action("G/Lvs MPA per Product")
                {
                    ApplicationArea = All;
                    RunObject = report "G/L vs MPA By Product";
                }
                action("LoanSecurities2N")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan Securities";
                }
                action("CRBReport")
                {
                    ApplicationArea = All;
                    RunObject = report "CRB Report org";
                }
                action("DemandLetter")
                {
                    ApplicationArea = All;
                    RunObject = report "Demand Letter";
                }

                action("ProductMatrix")
                {
                    ApplicationArea = All;
                    RunObject = report "Products Matrix";
                }
                action("YieldAnalysis")
                {
                    ApplicationArea = All;
                    RunObject = report "Yield Analysis";
                }
                action("AccountsMovement")
                {
                    ApplicationArea = All;
                    RunObject = report "Accounts Movement";
                }
                action("RescheduledLoans")
                {
                    ApplicationArea = All;
                    RunObject = report "Rescheduled Loans";
                }
                action("GuarantorSubstitution Entries")
                {
                    ApplicationArea = All;
                    RunObject = report "Guarantor Substitution Entries";
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
            action(NewLoanApplication)
            {
                Caption = 'New Loan Application';
                RunObject = page "Loan Application Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewStandingOrder)
            {
                Caption = 'New Standing Order';
                RunObject = page "Standing Order Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewFundTransfer)
            {
                Caption = 'New Fund Transfer';
                RunObject = page "Fund Transfer";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanRescheduling)
            {
                Caption = 'New Loan Rescheduling';
                RunObject = page "Loan Rescheduling";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewPayout)
            {
                Caption = 'New Payout';
                RunObject = page Payout;
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewDividend)
            {
                Caption = 'New Dividend';
                RunObject = page Dividend;
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewGuarantorSubstitution)
            {
                Caption = 'New Guarantor Substitution';
                RunObject = page "Guarantor Substitution";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanSelloff)
            {
                Caption = 'New Loan Selloff';
                RunObject = page "Loan Selloff";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanWriteoff)
            {
                Caption = 'New Loan Writeoff';
                RunObject = page "Loan Writeoff";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewExitRequest)
            {
                Caption = 'New Exit Request';
                RunObject = page "Member Exit";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(GenJournal)
            {
                Caption = 'General Journal';
                RunObject = Page "General Journal";
                ApplicationArea = All;
            }
        }
        area(Reporting)
        {
            action(MemberStatement)
            {
                Caption = 'Member Statement';
                Image = "Report";
                RunObject = Report "Member Statement";
                ApplicationArea = All;
            }
            action(LoanStatement)
            {
                Caption = 'Loan Statement';
                Image = "Report";
                RunObject = Report "Member Loan Statement";
                ApplicationArea = All;
            }
            action(MemberStatementCombined)
            {
                Caption = 'Member Statement-Combined';
                Image = "Report";
                RunObject = Report "Member Statement-Combined";
                ApplicationArea = All;
            }
            action(LoanRepaymentSchedule)
            {
                Caption = 'Loan Repayment Schedule';
                Image = "Report";
                RunObject = Report "Loan Repament Schedule";
                ApplicationArea = All;
            }
            action(LoanAppraisalReport)
            {
                Caption = 'Loan Appraisal Report';
                Image = "Report";
                RunObject = Report "Loan Appraisal Report";
                ApplicationArea = All;
            }
            action(LoanCalculator)
            {
                Caption = 'Loan Calculator';
                Image = Calculator;
                RunObject = Report "Loan Calculator";
                ApplicationArea = All;
            }
            Action("Mobile Banking Suspense")
            {
                Caption = 'Mobile Banking Suspense Report';
                Image = "Report";
                ApplicationArea = All;
                RunObject = Report "Mobile Banking Suspense Report";
            }
            Action("Member's Check-Off advice")
            {
                Caption = 'Member''s Check-Off advice';
                Image = "Report";
                ApplicationArea = All;
                RunObject = Report membersCheckOffAdvice;
            }
        }
    }




}
// Creates a profile that uses the Role Center
profile BOSAProfile
{
    ProfileDescription = 'BOSA Profile';
    RoleCenter = "BOSA RoleCenter";
    Caption = 'BOSA';
}

