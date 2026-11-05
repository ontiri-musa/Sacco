report 59205 MobileUnregMemberList
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Mobile Banking Unregistered Member List';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/MobileUnregMemberList.rdl';


    dataset
    {
        dataitem(DataItemName; Member)
        {
            //DataItemTableView = where(Category = filter('Individual'));
            RequestFilterFields = "No.", "Global Dimension 1 Code", Status, Gender;

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
            trigger OnAfterGetRecord()
            begin
                if (Status = Status::Deceased) or (Status = Status::Withdrawn) then begin
                    CurrReport.Skip();
                end else begin
                    MobileBanking.Reset();
                    MobileBanking.SetRange("Member No.", "No.");
                    if MobileBanking.FindFirst() then
                        CurrReport.Skip();

                    GetAccountBalances("No.");
                    if ChurchSection.Get("Church Section Code") then
                        SectionName := ChurchSection.Name;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
                if AsAtDate = 0D then
                    AsAtDate := Today;
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
        MobileBanking: Record "Mobile Banking Member";

    procedure GetAccountBalances(var MemberNo: Code[20])
    var
        DetVend: Record "Detailed Vendor Ledg. Entry";
    begin
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