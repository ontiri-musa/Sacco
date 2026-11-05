report 59285 "Member Dormancy Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/Member Dormancy.rdl';


    dataset
    {
        dataitem(DataItemName; Member)
        {
            RequestFilterFields = "No.", Status, "Dormancy Status", Gender, Category, "Registration Date";

            column(No_; "No.")
            {
            }
            column(Full_Name; "Full Name")
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(Date_of_Birth; "Date of Birth")
            {
            }
            column(National_ID; "National ID")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Status; Status)
            {
            }
            column(DormancyStatus; DormancyStatus)
            {
            }
            column(NoOfDaysDormant; NoOfDaysDormant)
            { }
            column(AsAtDate; AsAtDate)
            { }
            column(Approval_Date; "Approval Date")
            {
            }
            column(Introducer_Member_No_; "Introducer Member No.")
            {
            }
            column(Introducer_Member_Name; "Introducer Member Name")
            {
            }
            column(AccountBal_Deposit; AccountBal[1])
            {
            }
            column(AccountBal_Savings; AccountBal[2])
            {
            }
            column(AccountBal_ShareCapital; AccountBal[3])
            {
            }
            column(AccountBal_NXTGen; AccountBal[4])
            {
            }
            column(Registration_Date; "Registration Date")
            {

            }
            column(Church_District_Code; "Church District Code")
            {

            }
            column(Church_Code; "Church Code")
            {

            }
            column(Church_Section_Code; "Church Section Code")
            {

            }
            column(SectionName; SectionName)
            {

            }
            column(Phone_No_; "Phone No.")
            {

            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(City; CompanyInformation.City)
            {
            }
            column(Post_Code; CompanyInformation."Post Code")
            {
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(NoOfActiveLoans; NoOfActiveLoans)
            { }
            column(TotalLoanBal; TotalLoanBal)
            { }
            column(LastDepositDate; LastDepositDate)
            { }
            trigger OnAfterGetRecord()
            begin
                LastDepositDate := 0D;
                NoOfActiveLoans := 0;
                TotalLoanBal := 0;

                GetAccountBalances("No.");
                if ChurchSection.Get("Church Section Code") then
                    SectionName := ChurchSection.Name;
                if (DataItemName."Registration Date" = 0D) And (DataItemName."Created Date" <> 0D) then begin
                    DataItemName."Registration Date" := DataItemName."Created Date";
                    DataItemName.Modify();
                end;
                If (DormancyStatus = 'Active') or (DormancyStatus = 'Closed') then
                    CurrReport.Skip();
                if DormancyPeriodFilter = DormancyPeriodFilter::"Less Than 1Y" then begin
                    if NoOfDaysDormant > 365 then
                        CurrReport.Skip();
                end;
                if DormancyPeriodFilter = DormancyPeriodFilter::"Greater Than 1Y" then begin
                    if NoOfDaysDormant <= 365 then
                        CurrReport.Skip();
                end;

            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
                if AsAtDate = 0D then
                    Error('Kindly indicate As At Date!!!!');
            end;
        }
    }

    requestpage
    {


        layout
        {
            area(content)
            {
                field(AsAtDate; AsAtDate)
                {
                    Caption = 'As At Date';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(DormancyPeriodFilter; DormancyPeriodFilter)
                {
                    Caption = 'Dormancy Period Filter';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        AccountBal: array[7] of Decimal;
        AccountType: Record "Account Type";
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        AsAtDate: date;
        SectionName: text[150];
        ChurchSection: Record "Church Section";
        DormancyStatus: Text;
        DormancyPeriodFilter: Option " ","Less Than 1Y","Greater Than 1Y";
        NoOfDaysDormant: Integer;
        NoOfActiveLoans: Integer;
        TotalLoanBal: Decimal;
        LastDepositDate: Date;

    procedure GetAccountBalances(var MemberNo: Code[20])
    var
        DetVend: Record "Detailed Vendor Ledg. Entry";
        Member: Record Member;
        LoanApp: Record "Loan Application";
    begin
        LoanApp.Reset();
        LoanApp.SetRange("Member No.", MemberNo);
        LoanApp.SetRange(Posted, true);
        if LoanApp.FindSet() then begin
            repeat
                LoanApp.CalcFields("Outstanding Balance");
                If LoanApp."Outstanding Balance" > 0 then begin
                    NoOfActiveLoans += 1;
                    TotalLoanBal += LoanApp."Outstanding Balance";
                end;
            until LoanApp.Next = 0;
        end;

        Clear(AccountBal);
        AccountType.Reset();
        AccountType.SetFilter(Type, '%1|%2|%3', AccountType.Type::"Member Deposit", AccountType.Type::Savings, AccountType.Type::"Share Capital");
        if AccountType.FindSet() then begin
            repeat
                Vendor.Reset();
                Vendor.SetRange("Member No.", MemberNo);
                Vendor.SetRange("Account Type", AccountType.Code);
                if Vendor.FindFirst() then begin
                    Vendor.CalcFields(Balance);
                    if AccountType.Type = AccountType.Type::"Member Deposit" then begin
                        DetVend.Reset();
                        DetVend.SetRange("Vendor No.", Vendor."No.");
                        DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                        if DetVend.FindSet then begin
                            DetVend.CalcSums(Amount);
                            AccountBal[1] := ABS(DetVend.Amount);
                        end;

                        Member.Get(Vendor."Member No.");
                        if (Member.Status = Member.Status::Active) or (Member.Status = Member.Status::Dormant) then begin
                            DetVend.Reset();
                            DetVend.SetRange(DetVend."Vendor No.", Vendor."No.");
                            DetVend.SetFilter(DetVend."Credit Amount", '>%1', 0);
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            If DetVend.FindLast() then begin
                                if CalcDate('-3M', AsAtDate) >= DetVend."Posting Date" then begin
                                    DormancyStatus := 'Dormant';
                                    NoOfDaysDormant := AsAtDate - DetVend."Posting Date";
                                    LastDepositDate := DetVend."Posting Date";
                                end else begin
                                    DormancyStatus := 'Active';
                                end;
                            end;


                            DetVend.Reset();
                            DetVend.SetRange(DetVend."Vendor No.", Vendor."No.");
                            DetVend.SetFilter(DetVend."Credit Amount", '>%1', 0);
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            If not DetVend.FindLast() then begin
                                if Member."Registration Date" <> 0D then begin
                                    if CalcDate('-3M', AsAtDate) >= Member."Registration Date" then begin
                                        DormancyStatus := 'Dormant';
                                        NoOfDaysDormant := AsAtDate - Member."Registration Date";
                                    end else begin
                                        DormancyStatus := 'Active';
                                    end;
                                end else begin
                                    DormancyStatus := 'Dormant';
                                end;
                            end;
                        end;
                        if (Member.Status = Member.Status::Withdrawn) or (Member.Status = Member.Status::Deceased) or (Member.Status = Member.Status::Suspended) then begin
                            DormancyStatus := 'Closed';
                        end;
                    end;


                    if AccountType.Type = AccountType.Type::Savings then begin
                        if AccountType."Sub Type" = AccountType."Sub Type"::Boresha then begin
                            DetVend.Reset();
                            DetVend.SetRange("Vendor No.", Vendor."No.");
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            if DetVend.FindSet then begin
                                DetVend.CalcSums(Amount);
                                AccountBal[2] := ABS(DetVend.Amount);
                            end;
                        end;
                    end;
                    if AccountType.Type = AccountType.Type::"Share Capital" then begin
                        DetVend.Reset();
                        DetVend.SetRange("Vendor No.", Vendor."No.");
                        DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                        if DetVend.FindSet then begin
                            DetVend.CalcSums(Amount);
                            AccountBal[3] := ABS(DetVend.Amount);
                        end;
                    end;

                    if AccountType.Type = AccountType.Type::Savings then begin
                        if AccountType."Sub Type" = AccountType."Sub Type"::NXTGen then begin
                            DetVend.Reset();
                            DetVend.SetRange("Vendor No.", Vendor."No.");
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            if DetVend.FindSet then begin
                                DetVend.CalcSums(Amount);
                                AccountBal[4] := ABS(DetVend.Amount);
                            end;
                        end;
                    end;
                end;
            until AccountType.Next() = 0;
        end;
    end;
}