report 50600 "MicroCredit Commission Report"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Marketing/MicroCredit Commissions.rdl';

    dataset
    {
        dataitem(DataItem1; "Loan Recovery Officer Setup")
        {
            DataItemTableView = WHERE(Role = filter('MicroCredit Officer'));
            RequestFilterFields = "Member No.", "Global Dimension 1 Code";
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(PostCode_CompanyInformation; CompanyInformation."Post Code")
            {
            }
            column(City_CompanyInformation; CompanyInformation.City)
            {
            }
            column(Pic_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(Member_No_; "Member No.")
            {
            }
            column(Full_Name; "Full Name")
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(Payroll_No_; "Payroll No.")
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(Salary_Target; Account[1])
            {
            }
            column(Salary_Actual; Account[2])
            {
            }
            column(Junior_Target; Account[3])
            {
            }
            column(Junior_Actual; Account[4])
            {
            }
            column(Holiday_Target; Account[5])
            {
            }
            column(Holiday_Actual; Account[6])
            {
            }
            column(Biashara_Target; Account[7])
            {
            }
            column(Biashara_Actual; Account[8])
            {
            }
            column(ATM_Target; Account[9])
            {
            }
            column(MobileBanking_Target; Account[10])
            {
            }
            column(FD_Target; Account[11])
            {
            }
            column(FD_Actual; Account[12])
            {
            }
            column(Station_Target; Account[13])
            {
            }
            column(Station_Actual; Account[14])
            {
            }
            column(Members_Performance; Performance[1])
            {
            }
            column(Loans_Performance; Performance[2])
            {
            }
            column(Salary_Performance; Performance[3])
            {
            }
            column(Junior_Performance; Performance[4])
            {
            }
            column(Holiday_Performance; Performance[5])
            {
            }
            column(Biashara_Performance; Performance[6])
            {
            }
            column(Deposits_Performance; Performance[7])
            {
            }
            column(Shares_Performance; Performance[8])
            {
            }
            column(ATM_Performance; Performance[9])
            {
            }
            column(MobileBanking_Performance; Performance[10])
            {
            }
            column(FD_Performance; Performance[11])
            {
            }
            column(Stations_Performance; Performance[12])
            {
            }
            column(Aggregate_Performance; Performance[13])
            {
            }
            column(EntranceFee_Performance; Performance[14])
            {
            }
            column(SCNew_Performance; Performance[15])
            {
            }
            column(DepositsNew_Performance; Performance[16])
            {
            }
            column(Loans_Target; LoanAmount[1])
            {
            }
            column(Loans_Actual; LoanAmount[2])
            {
            }
            column(ATMCount; ATMCount)
            {
            }
            column(MobileBankingCount; MobileBankingCount)
            {
            }
            column(DepositsNew_Target; DepositNew[1])
            {
            }
            column(DepositsNew_Actual; DepositNew[2])
            {
            }
            column(Deposits_Target; Deposits[1])
            {
            }
            column(Deposits_Actual; Deposits[2])
            {
            }
            column(SCNew_Target; ShareCapitalNew[1])
            {
            }
            column(SCNew_Actual; ShareCapitalNew[2])
            {
            }
            column(Shares_Target; Shares[1])
            {
            }
            column(Shares_Actual; Shares[2])
            {
            }
            column(Members_Target; Members[1])
            {
            }
            column(Members_Actual; Members[2])
            {
            }
            column(Members_Paid; Members[3])
            {
            }
            column(Members_Followup; Members[4])
            {
            }
            column(EntranceFee_Target; EntranceFee[1])
            {
            }
            column(EntranceFee_Actual; EntranceFee[2])
            {
            }
            column(Members_Commission; Commissions[1])
            {
            }
            column(Loans_Commission; Commissions[2])
            {
            }
            column(Junior_Commission; Commissions[3])
            {
            }
            column(Holiday_Commission; Commissions[4])
            {
            }
            column(Biashara_Commission; Commissions[5])
            {
            }
            column(Deposits_Commission; Commissions[6])
            {
            }
            column(Shares_Commission; Commissions[7])
            {
            }
            column(ATM_Commission; Commissions[8])
            {
            }
            column(MobileBanking_Commission; Commissions[9])
            {
            }
            column(FD_Commission; Commissions[10])
            {
            }
            column(Aggregate_Commission; Commissions[11])
            {
            }
            column(Retainer; Retainer)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(Account);
                CLEAR(Performance);
                CLEAR(LoanAmount);
                CLEAR(Members);
                CLEAR(Shares);
                CLEAR(Deposits);
                CLEAR(EntranceFee);
                CLEAR(DepositNew);
                CLEAR(ShareCapitalNew);
                CLEAR(Commissions);
                Retainer := 0;
                GetNewMembers("Member No.");
                LoansSold("Member No.");
                SalaryAccounts("Member No.");
                JuniorAccounts("Member No.");
                HolidayAccounts("Member No.");
                BiasharaAccounts("Member No.");
                DepositMobilization("Member No.");
                SharesMobilization("Member No.");
                ATMCards("Member No.");
                MobileBankingRegistrations("Member No.");
                FDAccounts("Member No.");
                CheckOffStations("Member No.");
                GetAggregatePerformance();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; StartDate)
                {
                    ApplicationArea = All;
                }
                field("End Date"; EndDate)
                {
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET();
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CalcFields(Picture);
        if StartDate = 0D then
            ERROR('Please fill in a start date!');
        if EndDate = 0D then
            ERROR('Please fill in an end date!');
    end;

    var
        ATMCardApplications: Record "ATM Application";
        SpotCashRegistration: Record "Mobile Banking Application";
        StartDate: Date;
        EndDate: Date;
        CompanyInformation: Record "Company Information";
        Members: array[4] of Decimal;
        ShareCapitalNew: array[2] of Decimal;
        DepositNew: array[2] of Decimal;
        MCKPISetup: Record "Key Perfomance Indicator Setup";
        AccountTypes: Record "Account Type";
        Account: array[20] of Integer;
        Vendor: Record Vendor;
        ATMCount: Integer;
        MobileBankingCount: Integer;
        Performance: array[20] of Decimal;
        LoanAmount: array[2] of Decimal;
        Deposits: array[2] of Decimal;
        Shares: array[2] of Decimal;
        Member: Record Member;
        EntranceFee: array[2] of Decimal;
        Commissions: array[11] of Decimal;
        Retainer: Decimal;
        NewMemberCommission: Decimal;
        NewMembersExpected: Decimal;
        AccountOpening: Record "Account Opening";

    local procedure GetNewMembers(SalesRepCode: Code[20]);
    var
        Member: Record Member;
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::Member);
        if MCKPISetup.FindSet() then begin
            repeat
                if MCKPISetup."Entrance Fee" <> 0.0 then begin
                    Members[1] := MCKPISetup."No. of Accounts" * GetNoofMonths;
                    NewMembersExpected := MCKPISetup."No. of Accounts";
                    EntranceFee[1] := MCKPISetup."Entrance Fee" * MCKPISetup."No. of Accounts";
                    NewMemberCommission := MCKPISetup."Commission Value";
                    Member.Reset();
                    Member.SetRange("Introducer Member No.", SalesRepCode);
                    if Member.FindSet() then begin
                        repeat
                            Members[2] += 1;
                            if (Member."Approval Date" >= StartDate) AND (Member."Approval Date" <= EndDate) then begin
                                EntranceFee[2] += Member."Registration Fee Paid";
                            end;
                            if (Member."Registration Fee Paid" > 0) AND (GetShareCapitalAmount(Member."No.", Member."Approval Date")) AND
                               (GetDepositAmount(Member."No.", Member."Approval Date")) then begin
                                if Member."Approval Date" < StartDate then begin
                                    Members[4] += 1;
                                end else begin
                                    Members[3] += 1;
                                end;
                            end;
                        until Member.NEXT = 0;
                        if Members[3] > 0 then begin
                            Performance[1] := (Members[3] / Members[1]) * 100;
                        end else begin
                            Performance[1] := 0;
                        end;
                        if EntranceFee[2] > 0 then begin
                            Performance[14] := (EntranceFee[2] / EntranceFee[1]) * 100;
                        end else begin
                            Performance[14] := 0;
                        end;
                        if ShareCapitalNew[2] > 0 then begin
                            Performance[15] := (ShareCapitalNew[2] / ShareCapitalNew[1]) * 100;
                        end else begin
                            Performance[15] := 0;
                        end;
                        if DepositNew[2] > 0 then begin
                            Performance[16] := (DepositNew[2] / DepositNew[1]) * 100;
                        end else begin
                            Performance[16] := 0;
                        end;
                    end;
                    if Members[3] > NewMembersExpected then begin
                        Commissions[1] := ((Members[3] - NewMembersExpected) * NewMemberCommission);
                    end;
                    Commissions[1] := Commissions[1] + (Members[4] * NewMemberCommission);
                end;
            until MCKPISetup.NEXT = 0;
        end;
    end;

    local procedure LoansSold(SalesPerson: Code[20]);
    var
        LoanApplications: Record "Loan Application";
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::Loans);
        if MCKPISetup.FindFirst() then begin
            Member.Reset();
            Member.SetRange("Introducer Member No.", SalesPerson);
            if Member.FindSet() then begin
                repeat
                    LoanAmount[1] := MCKPISetup."Minimum Amount";
                    LoanApplications.Reset();
                    LoanApplications.SETCURRENTKEY("Member No.", "No.");
                    LoanApplications.SetRange("Member No.", Member."No.");
                    LoanApplications.SetRange(Posted, TRUE);
                    if LoanApplications.FindFirst() then begin
                        ComputeCommissionOnLoans(LoanApplications."No.");
                        if (LoanApplications."Disbursal Date" >= StartDate) AND (LoanApplications."Disbursal Date" <= EndDate) then begin
                            LoanAmount[2] += GetLoanBalanceAsAtDate(LoanApplications."No.");
                        end;
                    end;
                until Member.NEXT = 0;
            end;
            Commissions[2] := Commissions[2] * (MCKPISetup."Commission Value" / 100);
            if LoanAmount[2] <> 0 then begin
                Performance[2] := (LoanAmount[2] / LoanAmount[1]) * 100;
            end else begin
                Performance[2] := 0;
            end;
        end;
    end;

    local procedure SalaryAccounts(SalesPersonCode: Code[20]);
    var
        GlobalSetup: Record "Global Setup";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange("FOSA Account", true);
        if AccountTypes.FindSet() then begin
            repeat
                MCKPISetup.Reset();
                MCKPISetup.SetRange(Type, MCKPISetup.Type::Account);
                MCKPISetup.SetRange("Account Type", AccountTypes.Code);
                if MCKPISetup.FindFirst() then begin
                    Account[1] := MCKPISetup."No. of Accounts" * GetNoofMonths;
                    AccountOpening.Reset();
                    AccountOpening.SetRange("Account Type", AccountTypes.Code);
                    //AccountOpening.SetRange("Opened By", SalesPersonCode);
                    AccountOpening.SetRange(Status, AccountOpening.Status::Approved);
                    AccountOpening.SetRange("Approved Date", StartDate, EndDate);
                    if AccountOpening.FindSet() then begin
                        repeat
                            if Vendor.Get(AccountOpening."Account No.") then begin
                                GlobalSetup.Get();
                                VendorLedgerEntry.Reset();
                                VendorLedgerEntry.SetCurrentKey("Vendor No.");
                                VendorLedgerEntry.SetRange("Vendor No.", Vendor."No.");
                                //VendorLedgerEntry.SetRange("Journal Batch Name", GlobalSetup."Payout Batch Name");
                                if VendorLedgerEntry.FindFirst() then
                                    Account[2] += 1;
                            end;
                        until AccountOpening.Next() = 0;
                    end;
                    if Account[2] > 0 then begin
                        Performance[3] := (Account[2] / Account[1]) * 100;
                    end else begin
                        Performance[3] := 0;
                    end;
                end;
            until AccountTypes.NEXT = 0;
        end;
    end;

    local procedure JuniorAccounts(SalesPersonCode: Code[20]);
    var
        Vendor: Record Vendor;
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::Savings);
        AccountTypes.SetRange("Sub Type", AccountTypes."Sub Type"::Junior);
        if AccountTypes.FindFirst() then begin
            MCKPISetup.Reset();
            MCKPISetup.SetRange(Type, MCKPISetup.Type::Account);
            MCKPISetup.SetRange("Account Type", AccountTypes.Code);
            if MCKPISetup.FindFirst() then begin
                Account[3] := MCKPISetup."No. of Accounts" * GetNoofMonths;
                AccountOpening.Reset();
                AccountOpening.SETCURRENTKEY("Account Type");
                AccountOpening.SetRange("Account Type", AccountTypes.Code);
                //AccountOpening.SetRange("Opened By", SalesPersonCode);
                AccountOpening.SetRange(Status, Vendor.Status::Active);
                if AccountOpening.FindSet() then begin
                    repeat
                        if (CheckWhenMinimumAccountBalanceAchieved(AccountOpening."Account No.", MCKPISetup."Minimum Amount") >= StartDate) AND
                           (CheckWhenMinimumAccountBalanceAchieved(AccountOpening."Account No.", MCKPISetup."Minimum Amount") <= EndDate) then begin
                            Account[4] += 1;
                        end;
                    until AccountOpening.NEXT = 0;
                end;
                if Account[4] > 0 then begin
                    Performance[4] := (Account[4] / Account[3]) * 100;
                    Commissions[3] := Account[4] * MCKPISetup."Commission Value";
                end else begin
                    Performance[4] := 0;
                end;

            end;
        end;
    end;

    local procedure HolidayAccounts(SalesPersonCode: Code[20]);
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::Savings);
        AccountTypes.SetRange("Sub Type", AccountTypes."Sub Type"::Holiday);
        if AccountTypes.FindFirst() then begin
            MCKPISetup.Reset();
            MCKPISetup.SetRange(Type, MCKPISetup.Type::Account);
            MCKPISetup.SetRange("Account Type", AccountTypes.Code);
            if MCKPISetup.FindFirst() then begin
                Account[5] := MCKPISetup."No. of Accounts" * GetNoofMonths;
                AccountOpening.Reset();
                AccountOpening.SETCURRENTKEY("Account Type");
                AccountOpening.SetRange("Account Type", AccountTypes.Code);
                AccountOpening.SetRange("Approved Date", StartDate, EndDate);
                //AccountOpening.SetRange("Opened By", SalesPersonCode);
                AccountOpening.SetRange(Status, AccountOpening.Status::Approved);
                if AccountOpening.FindSet() then begin
                    repeat
                        if (CheckWhenMinimumAccountBalanceAchieved(AccountOpening."Account No.", MCKPISetup."Minimum Amount") >= StartDate) AND
                           (CheckWhenMinimumAccountBalanceAchieved(AccountOpening."Account No.", MCKPISetup."Minimum Amount") <= EndDate) then begin
                            Account[6] += 1;
                        end;
                    until AccountOpening.NEXT = 0;
                end;
                if Account[6] > 0 then begin
                    Performance[5] := (Account[6] / Account[5]) * 100;
                    Commissions[4] := Account[6] * MCKPISetup."Commission Value";
                end else begin
                    Performance[5] := 0;
                end;
            end;
        end;
    end;

    local procedure BiasharaAccounts(SalesPersonCode: Code[20]);
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::Savings);
        AccountTypes.SetRange("Sub Type", AccountTypes."Sub Type"::Business);
        if AccountTypes.FindFirst() then begin
            MCKPISetup.Reset();
            MCKPISetup.SetRange(Type, MCKPISetup.Type::Account);
            MCKPISetup.SetRange("Account Type", AccountTypes.Code);
            if MCKPISetup.FindFirst() then begin
                Account[7] := MCKPISetup."No. of Accounts" * GetNoofMonths;
                AccountOpening.Reset();
                AccountOpening.SETCURRENTKEY("Account Type");
                AccountOpening.SetRange("Account Type", AccountTypes.Code);
                AccountOpening.SetRange("Approved Date", StartDate, EndDate);
                //AccountOpening.SetRange("Opened By", SalesPersonCode);
                AccountOpening.SetRange(Status, AccountOpening.Status::Approved);
                if AccountOpening.FindSet() then begin
                    repeat
                        if (CheckWhenMinimumAccountBalanceAchieved(AccountOpening."Account No.", MCKPISetup."Minimum Amount") >= StartDate) AND
                           (CheckWhenMinimumAccountBalanceAchieved(AccountOpening."Account No.", MCKPISetup."Minimum Amount") <= EndDate) then begin
                            Account[8] += 1;
                        end;
                    until AccountOpening.NEXT = 0;
                end;
                if Account[8] > 0 then begin
                    Performance[6] := (Account[8] / Account[7]) * 100;
                    Commissions[5] := Account[8] * MCKPISetup."Commission Value";
                end else begin
                    Performance[6] := 0;
                end;
            end;
        end;
    end;

    local procedure DepositMobilization(SalesPersonCode: Code[20]);
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::Deposits);
        if MCKPISetup.FindFirst() then begin
            Member.Reset();
            Member.SetRange("Introducer Member No.", SalesPersonCode);
            if Member.FindSet() then begin
                Deposits[1] := MCKPISetup."Minimum Amount" * Member.COUNT;
                repeat
                    Vendor.Reset();
                    Vendor.SETCURRENTKEY("Member No.");
                    Vendor.SetRange("Member No.", Member."No.");
                    Vendor.SetRange("Account Type", MCKPISetup."Account Type");
                    if Vendor.FindFirst() then begin
                        Deposits[2] += GetTotalAmountDeposited(Vendor."No.");
                    end;
                    if Deposits[2] > 0 then begin
                        Performance[7] := (Deposits[2] / Deposits[1]) * 100;
                        Commissions[6] := (Deposits[2] * MCKPISetup."Commission Value") / 100;
                    end else begin
                        Performance[7] := 0;
                        Commissions[6] := 0;
                    end;
                until Member.NEXT = 0;
            end;
        end;
    end;

    local procedure SharesMobilization(SalesPersonCode: Code[20]);
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::Shares);
        if MCKPISetup.FindFirst() then begin
            Member.Reset();
            Member.SetRange("Introducer Member No.", SalesPersonCode);
            if Member.FindSet() then begin
                Shares[1] := MCKPISetup."Minimum Amount" * Member.COUNT;
                repeat
                    Vendor.Reset();
                    Vendor.SETCURRENTKEY("Member No.");
                    Vendor.SetRange("Member No.", Member."No.");
                    Vendor.SetRange("Account Type", MCKPISetup."Account Type");
                    if Vendor.FindFirst() then begin
                        Shares[2] += GetTotalAmountDeposited(Vendor."No.");
                    end;
                    if Shares[2] > 0 then begin
                        Performance[8] := (Shares[2] / Shares[1]) * 100;
                        Commissions[7] := (Shares[2] * MCKPISetup."Commission Value") / 100;
                    end else begin
                        Performance[8] := 0;
                        Commissions[7] := 0;
                    end;
                until Member.NEXT = 0;
            end;
        end;
    end;

    local procedure ATMCards(SalesPersonCode: Code[20]);
    var
        ATMMember: Record "ATM Member";
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::ATM);
        if MCKPISetup.FindFirst() then begin
            Account[9] := MCKPISetup."No. of Accounts" * GetNoofMonths;
            Member.Reset();
            Member.SetRange("Introducer Member No.", SalesPersonCode);
            if Member.FindSet() then begin
                repeat
                    ATMMember.Reset();
                    ATMMember.SetRange("Member No.", Member."No.");
                    if ATMMember.FindFirst() then begin
                        ATMCardApplications.Reset();
                        ATMCardApplications.SetRange("Member No.", Member."No.");
                        ATMCardApplications.SetRange("Created Date", StartDate, EndDate);
                        if ATMCardApplications.FindFirst() then begin
                            ATMCount += 1;
                        end;
                    end;
                until Member.Next() = 0;
            end;
            if ATMCount > 0 then begin
                Performance[9] := (ATMCount / Account[9]) * 100;
                Commissions[8] := ATMCount * MCKPISetup."Commission Value";
            end else begin
                Performance[9] := 0;
            end;
        end;
    end;

    local procedure MobileBankingRegistrations(SalesPersonCode: Code[20]);
    var
        SpotCashMember: Record "Mobile Banking Member";
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::MobileBanking);
        if MCKPISetup.FindFirst() then begin
            Account[10] := MCKPISetup."No. of Accounts" * GetNoofMonths;
            Member.Reset();
            Member.SetRange("Introducer Member No.", SalesPersonCode);
            if Member.FindFirst() then begin
                repeat
                    SpotCashMember.Reset();
                    SpotCashMember.SetRange("Member No.", Member."No.");
                    if SpotCashMember.FindFirst() then begin
                        SpotCashRegistration.Reset();
                        SpotCashRegistration.SetRange("Approved Date", StartDate, EndDate);
                        if SpotCashRegistration.FindFirst() then begin
                            MobileBankingCount += 1;
                        end;
                    end;
                until Member.Next() = 0;
            end;
            if MobileBankingCount > 0 then begin
                Performance[10] := (MobileBankingCount / Account[10]) * 100;
                Commissions[9] := MobileBankingCount * MCKPISetup."Commission Value";
            end else begin
                Performance[10] := 0;
            end;
        end;
    end;

    local procedure FDAccounts(SalesPersonCode: Code[20]);
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::"Fixed Deposit");
        if AccountTypes.FindFirst() then begin
            MCKPISetup.Reset();
            MCKPISetup.SetRange(Type, MCKPISetup.Type::Account);
            MCKPISetup.SetRange("Account Type", AccountTypes.Code);
            if MCKPISetup.FindFirst() then begin
                Account[11] := MCKPISetup."No. of Accounts" * GetNoofMonths;
                Member.Reset();
                Member.SetRange("Introducer Member No.", SalesPersonCode);
                if Member.FindSet() then begin
                    repeat
                        AccountOpening.Reset();
                        AccountOpening.SetRange("Member No.", Member."No.");
                        AccountOpening.SetRange("Account Type", AccountTypes.Code);
                        AccountOpening.SetRange(Status, AccountOpening.Status::Approved);
                        AccountOpening.SetRange("Approved Date", StartDate, EndDate);
                        if AccountOpening.FindSet() then begin
                            repeat
                                Vendor.Reset();
                                Vendor.SetRange("No.", AccountOpening."Account No.");
                                Vendor.SetRange(Status, Vendor.Status::Active);
                                if Vendor.FindFirst() then begin
                                    Vendor.CALCFIELDS("Balance (LCY)");
                                    if Vendor."Balance (LCY)" >= MCKPISetup."Minimum Amount" then begin
                                        Account[12] += 1;
                                    end;
                                end;
                            until AccountOpening.Next() = 0;
                        end;
                    until Member.Next() = 0;
                end;
                if Account[12] > 0 then begin
                    Performance[11] := (Account[12] / Account[11]) * 100;
                    Commissions[10] := Account[12] * MCKPISetup."Commission Value";
                end else begin
                    Performance[11] := 0;
                end;
            end;
        end;
    end;

    local procedure CheckOffStations(SalesPersonCode: Code[20]);
    begin
        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::Stations);
        if MCKPISetup.FindFirst() then begin
            Account[13] := MCKPISetup."No. of Accounts" * GetNoofMonths;
            Vendor.Reset();
            Vendor.SetRange("Vendor Posting Group", 'STATION');
            // Vendor.SetRange("Recruited By", SalesPersonCode);
            //  Vendor.SetRange("Approved On", CALCDATE('-' + FORMAT(MCKPISetup.Frequency), StartDate), StartDate);
            if Vendor.FindSet() then begin
                Account[14] := Vendor.COUNT;
                if Account[14] > 0 then begin
                    Performance[12] := (Account[14] / Account[13]) * 100;
                end else begin
                    Performance[12] := 0;
                end;
            end;
        end;
    end;

    local procedure GetShareCapitalAmount(MemberNo: Code[20]; RegDate: Date): Boolean;
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::"Share Capital");
        if AccountTypes.FindFirst() then begin
            MCKPISetup.Reset();
            MCKPISetup.SetRange(Type, MCKPISetup.Type::Member);
            MCKPISetup.SetRange("Account Type", AccountTypes.Code);
            if MCKPISetup.FindFirst() then begin
                ShareCapitalNew[1] := MCKPISetup."Minimum Amount" * Members[1];
                Vendor.Reset();
                Vendor.SETCURRENTKEY("Member No.");
                Vendor.SetRange("Member No.", MemberNo);
                Vendor.SetRange("Account Type", AccountTypes.Code);
                if Vendor.FindFirst() then begin
                    Vendor.CALCFIELDS("Balance (LCY)");
                    if RegDate >= StartDate then begin
                        ShareCapitalNew[2] += Vendor."Balance (LCY)";
                    end;
                    if (CheckWhenMinimumAccountBalanceAchieved(Vendor."No.", MCKPISetup."Minimum Amount") >= StartDate) AND
                        (CheckWhenMinimumAccountBalanceAchieved(Vendor."No.", MCKPISetup."Minimum Amount") <= EndDate) then begin
                        EXIT(TRUE);
                    end else
                        EXIT(FALSE);
                end;
            end;
        end;
    end;

    local procedure GetDepositAmount(MemberNo: Code[20]; RegDate: Date): Boolean;
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::"Member Deposit");
        if AccountTypes.FindFirst() then begin
            MCKPISetup.Reset();
            MCKPISetup.SetRange(Type, MCKPISetup.Type::Member);
            MCKPISetup.SetRange("Account Type", AccountTypes.Code);
            if MCKPISetup.FindFirst() then begin
                DepositNew[1] := MCKPISetup."Minimum Amount" * Members[1];
                Vendor.Reset();
                Vendor.SETCURRENTKEY("Member No.");
                Vendor.SetRange("Member No.", MemberNo);
                Vendor.SetRange("Account Type", AccountTypes.Code);
                if Vendor.FindFirst() then begin
                    Vendor.CALCFIELDS("Balance (LCY)");
                    if RegDate >= StartDate then begin
                        DepositNew[2] += Vendor."Balance (LCY)";
                    end;
                    if (CheckWhenMinimumAccountBalanceAchieved(Vendor."No.", MCKPISetup."Minimum Amount") >= StartDate) AND
                        (CheckWhenMinimumAccountBalanceAchieved(Vendor."No.", MCKPISetup."Minimum Amount") <= EndDate) then begin
                        EXIT(TRUE);
                    end else
                        EXIT(FALSE);
                end;
            end;
        end;
    end;

    local procedure GetAggregatePerformance();
    begin
        MCKPISetup.Reset();
        MCKPISetup.SETFILTER(Type, '<>%1', MCKPISetup.Type::Retainer);
        if MCKPISetup.FindSet() then begin
            Performance[13] := ((Performance[1] + Performance[2] + Performance[3] + Performance[4] + Performance[5] + Performance[6] +
                             Performance[7] + Performance[8] + Performance[9] + Performance[10] + Performance[11] + Performance[12] +
                             Performance[14] + Performance[15] + Performance[16]) / MCKPISetup.COUNT);
        end;

        MCKPISetup.Reset();
        MCKPISetup.SetRange(Type, MCKPISetup.Type::Retainer);
        if MCKPISetup.FindFirst() then begin
            Retainer := MCKPISetup."Commission Value" * GetNoofMonths;
        end;

        Commissions[11] := Commissions[1] + Commissions[2] + Commissions[3] + Commissions[4] + Commissions[5] +
                         Commissions[6] + Commissions[7] + Commissions[8] + Commissions[9] + Commissions[10] + Retainer;
    end;

    local procedure ComputeCommissionOnLoans(LoanNo: Code[20]);
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
        VendorLedgerEntry.SetRange("Vendor No.", LoanNo);
        // VendorLedgerEntry.SetRange("Transaction Type", VendorLedgerEntry."Transaction Type"::"Interest Paid");
        if VendorLedgerEntry.FindFirst() then begin
            if (VendorLedgerEntry."Posting Date" >= StartDate) AND (VendorLedgerEntry."Posting Date" <= EndDate) then begin
                VendorLedgerEntry.CALCFIELDS(Amount);
                Commissions[2] += ABS(VendorLedgerEntry.Amount);
            end;
        end;
    end;

    local procedure GetNoofMonths(): Integer;
    var
        NoofMonths: Integer;
        Year: array[2] of Integer;
    begin
        Year[1] := DATE2DMY(EndDate, 3);
        Year[2] := DATE2DMY(StartDate, 3);
        if Year[1] <> Year[2] then begin
            NoofMonths := ((Year[1] - Year[2] - 1) * 12) + (13 - DATE2DMY(StartDate, 2)) + (DATE2DMY(EndDate, 2));
        end else begin
            NoofMonths := (DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2)) + 1;
        end;
        EXIT(NoofMonths);
    end;

    local procedure CheckWhenMinimumAccountBalanceAchieved(AccountNo: Code[20]; MinimumAmount: Decimal): Date;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AccountBalance: Decimal;
    begin
        AccountBalance := 0;
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
        VendorLedgerEntry.SetRange("Vendor No.", AccountNo);
        if VendorLedgerEntry.FindSet() then begin
            repeat
                VendorLedgerEntry.CALCFIELDS(Amount);
                AccountBalance += ABS(VendorLedgerEntry.Amount);
                if AccountBalance >= MinimumAmount then
                    EXIT(VendorLedgerEntry."Posting Date");
            until VendorLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure GetTotalAmountDeposited(AccountNo: Code[20]): Decimal;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AmountDeposited: Decimal;
    begin
        AmountDeposited := 0;
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
        VendorLedgerEntry.SetRange("Vendor No.", AccountNo);
        VendorLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
        if VendorLedgerEntry.FindSet() then begin
            repeat
                VendorLedgerEntry.CALCFIELDS(Amount);
                AmountDeposited += (-1 * VendorLedgerEntry.Amount);
            until VendorLedgerEntry.NEXT = 0;
        end;
        EXIT(AmountDeposited);
    end;

    local procedure GetLoanBalanceAsAtDate(AccountNo: Code[20]): Decimal;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AccountBalance: Decimal;
    begin
        AccountBalance := 0;
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
        VendorLedgerEntry.SetRange("Vendor No.", AccountNo);
        VendorLedgerEntry.SetRange("Posting Date", 0D, EndDate);
        if VendorLedgerEntry.FindSet() then begin
            repeat
                VendorLedgerEntry.CALCFIELDS(Amount);
                AccountBalance += VendorLedgerEntry.Amount;
            until VendorLedgerEntry.NEXT = 0;
        end;
        EXIT(ABS(AccountBalance));
    end;
}

