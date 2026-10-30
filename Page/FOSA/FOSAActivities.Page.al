page 50354 "FOSA Activities"
{
    PageType = CardPart;
    SourceTable = "FOSA Cue";

    layout
    {
        area(content)
        {

            cuegroup(AccountBalanceCueContainer)
            {
                Caption = 'Account Balances';
                CuegroupLayout = Wide;
                field(TotalOrdinarySavings; ABS(TotalOrdinarySavings))
                {
                    Caption = 'Total Savings';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var

                    begin
                        Page.Run(50033);
                    end;
                }
                field(TotalDeposits; ABS(TotalDeposits))
                {
                    Caption = 'Total Deposits';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var

                    begin
                        Page.Run(50033);
                    end;
                }
                field(TotalShares; ABS(TotalShares))
                {
                    Caption = 'Total Shares';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var

                    begin
                        Page.Run(50033);
                    end;
                }
                field(TotalFixedDeposits; ABS(TotalFixedDeposits))
                {
                    Caption = 'Total Fixed Deposits';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var

                    begin
                        Page.Run(50033);
                    end;
                }
                // field(TotalLoans; ABS(TotalLoans))
                // {
                //     Caption = 'Total Loans';
                //     ApplicationArea = All;
                //     trigger OnDrillDown()
                //     var
                //         Vendor: Record Vendor;
                //     begin
                //         Vendor.Reset();
                //         Page.Run(50033);
                //     end;
                // }
            }
            cuegroup(MemberCueContainer)
            {
                Caption = 'Members';
                //CuegroupLayout = Wide;
                field("Member-Active"; "Member-Active")
                {
                    Caption = 'Active';
                    DrillDownPageId = "Member List";
                    ApplicationArea = All;
                }
                field("Member-Dormant"; "Member-Dormant")
                {
                    Caption = 'Dormant';
                    DrillDownPageId = "Member List";
                    ApplicationArea = All;
                }
                field("Member-Withdrawn"; "Member-Withdrawn")
                {
                    Caption = 'Withdrawn';
                    DrillDownPageId = "Member List";
                    ApplicationArea = All;
                }
                field("Member-Suspended"; "Member-Suspended")
                {
                    Caption = 'Suspended';
                    DrillDownPageId = "Member List";
                    ApplicationArea = All;
                }


            }
            cuegroup(MobileBankingMemberCueContainer)
            {
                Caption = 'Mobile Banking Members';
                //CuegroupLayout = Wide;
                field("MobileBankingMember-Active"; "MobileBankingMember-Active")
                {
                    Caption = 'Active';
                    DrillDownPageId = "Mobile Banking Members List";
                    ApplicationArea = All;
                }
                field("MobileBankingMember-Inactive"; "MobileBankingMember-Inactive")
                {
                    Caption = 'Inactive';
                    DrillDownPageId = "Mobile Banking Members List";
                    ApplicationArea = All;
                }


            }
            cuegroup(ChequeBookCueContainer)
            {
                Caption = 'Cheque Books';
                Visible = false;
                //CuegroupLayout = Wide;
                field("ChequeBook-New"; "ChequeBook-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Cheque Book List-New";
                    ApplicationArea = All;
                }
                field("ChequeBook-Issued"; "ChequeBook-Issued")
                {
                    Caption = 'Issued';
                    DrillDownPageId = "Cheque Book List-Issued";
                    ApplicationArea = All;
                }
            }





            cuegroup(MemberApplicationActionContainer)
            {
                Caption = 'Member Application';

                actions
                {

                    action("New Member Application")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Member Application Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(AccountOpeningActionContainer)
            {
                Caption = 'Account Opening';

                actions
                {

                    action("New Account Opening")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Account Opening Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(MobileBankingApplicationActionContainer)
            {
                Caption = 'Mobile Banking Application';

                actions
                {

                    action("New Mobile Banking Application")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Mobile Banking Appl. Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }

            cuegroup(ATMApplicationActionContainer)
            {
                Caption = 'ATM Application';
                Visible = false;
                actions
                {

                    action("New ATM Application")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "ATM Application Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(AgentApplicationActionContainer)
            {
                Caption = 'Agent Application';
                Visible = false;
                actions
                {

                    action("New Agent Application")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Agent Application";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        RESET;
        if not get then begin
            INIT;
            INSERT;
        end;

    end;

    local procedure CalculateAccountBalance()
    var
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
    begin
        AccountType.Reset();
        if AccountType.FindSet() then begin
            repeat
                Vendor.Reset();
                Vendor.SetRange("Account Type", AccountType.Code);
                if Vendor.FindSet() then begin
                    repeat
                        Vendor.CalcFields("Balance (LCY)");
                        if AccountType.Type = AccountType.Type::Savings then
                            TotalOrdinarySavings += Vendor."Balance (LCY)";
                        if AccountType.Type = AccountType.Type::"Member Deposit" then
                            TotalDeposits += Vendor."Balance (LCY)";
                        if AccountType.Type = AccountType.Type::"Share Capital" then
                            TotalShares += Vendor."Balance (LCY)";
                        if AccountType.Type = AccountType.Type::"Fixed Deposit" then
                            TotalFixedDeposits += Vendor."Balance (LCY)";

                    until Vendor.Next() = 0
                end;
            until AccountType.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        CalculateAccountBalance();
    end;

}