report 50005 "Member Listing Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/Member Listing.rdl';


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
            column(RegFeePaid; RegFeePaid)
            { }
            column(LoanBal; LoanBal)
            { }
            column(LastTransDate; LastTransDate)
            { }
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
                GetAccountBalances("No.");
                if ChurchSection.Get("Church Section Code") then
                    SectionName := ChurchSection.Name;
                if (DataItemName."Registration Date" = 0D) And (DataItemName."Created Date" <> 0D) then begin
                    DataItemName."Registration Date" := DataItemName."Created Date";
                    DataItemName.Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
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
        DormancyStatus: Text;
        RegFeePaid: Decimal;
        LastTransDateN: array[17] of Date;
        LastTransDate: Date;
        LoanBal: Decimal;
        Cust: Record Customer;


    procedure GetAccountBalances(var MemberNo: Code[20])
    var
        DetVend: Record "Detailed Vendor Ledg. Entry";
        VendL: Record "Vendor Ledger Entry";
        CustL: Record "Cust. Ledger Entry";
        Member: Record Member;
    begin
        Clear(AccountBal);
        Clear(LastTransDateN);
        RegFeePaid := 0;
        LoanBal := 0;
        LastTransDate := 0D;

        AccountType.Reset();
        AccountType.SetFilter(Type, '%1|%2|%3', AccountType.Type::"Member Deposit", AccountType.Type::Savings, AccountType.Type::"Share Capital");
        if AccountType.FindSet() then begin
            repeat
                Vendor.Reset();
                Vendor.SetRange("Member No.", MemberNo);
                Vendor.SetRange("Account Type", AccountType.Code);
                Vendor.SetFilter("Date Filter", '..%1', AsAtDate);
                if Vendor.FindFirst() then begin
                    Vendor.CalcFields(Balance, "Net Change");
                    if AccountType.Type = AccountType.Type::"Member Deposit" then begin
                        /*
                        DetVend.Reset();
                        DetVend.SetRange("Vendor No.", Vendor."No.");
                        DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                        if DetVend.FindSet then begin
                            DetVend.CalcSums(Amount);
                            AccountBal[1] := ABS(DetVend.Amount);
                        end;*/
                        AccountBal[1] := Vendor."Net Change";

                        VendL.Reset();
                        VendL.SetRange("Vendor No.", Vendor."No.");
                        VendL.SetFilter("Posting Date", '<=%1', AsAtDate);
                        VendL.SetRange(Reversed, false);
                        VendL.SetFilter("Credit Amount", '>%1', 0);
                        if VendL.FindLast() then begin
                            LastTransDateN[1] := VendL."Posting Date";
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
                                end else begin
                                    DormancyStatus := 'Active';
                                end;
                            end;


                            DetVend.Reset();
                            DetVend.SetRange(DetVend."Vendor No.", Vendor."No.");
                            DetVend.SetFilter(DetVend."Credit Amount", '>%1', 0);
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            If not DetVend.FindLast() then begin
                                if CalcDate('-3M', AsAtDate) >= Member."Registration Date" then begin
                                    DormancyStatus := 'Dormant';
                                end else begin
                                    DormancyStatus := 'Active';
                                end;
                            end;
                        end;
                        if (Member.Status = Member.Status::Withdrawn) or (Member.Status = Member.Status::Deceased) or (Member.Status = Member.Status::Suspended) then begin
                            DormancyStatus := 'Closed';
                        end;
                    end;


                    if AccountType.Type = AccountType.Type::Savings then begin
                        if AccountType."Sub Type" = AccountType."Sub Type"::Boresha then begin
                            /*DetVend.Reset();
                            DetVend.SetRange("Vendor No.", Vendor."No.");
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            if DetVend.FindSet then begin
                                DetVend.CalcSums(Amount);
                                AccountBal[2] := ABS(DetVend.Amount);
                            end;*/
                            AccountBal[2] := Vendor."Net Change";

                            VendL.Reset();
                            VendL.SetRange("Vendor No.", Vendor."No.");
                            VendL.SetFilter("Posting Date", '<=%1', AsAtDate);
                            VendL.SetRange(Reversed, false);
                            VendL.SetFilter("Credit Amount", '>%1', 0);
                            if VendL.FindLast() then begin
                                LastTransDateN[2] := VendL."Posting Date";
                            end;
                        end;
                    end;

                    if AccountType.Type = AccountType.Type::"Share Capital" then begin
                        /*DetVend.Reset();
                        DetVend.SetRange("Vendor No.", Vendor."No.");
                        DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                        if DetVend.FindSet then begin
                            DetVend.CalcSums(Amount);
                            AccountBal[3] := ABS(DetVend.Amount);
                        end;*/
                        AccountBal[3] := Vendor."Net Change";
                        VendL.Reset();
                        VendL.SetRange("Vendor No.", Vendor."No.");
                        VendL.SetFilter("Posting Date", '<=%1', AsAtDate);
                        VendL.SetRange(Reversed, false);
                        VendL.SetFilter("Credit Amount", '>%1', 0);
                        if VendL.FindLast() then begin
                            LastTransDateN[3] := VendL."Posting Date";
                        end;
                    end;

                    if AccountType.Type = AccountType.Type::Savings then begin
                        if AccountType."Sub Type" = AccountType."Sub Type"::NXTGen then begin
                            /*DetVend.Reset();
                            DetVend.SetRange("Vendor No.", Vendor."No.");
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            if DetVend.FindSet then begin
                                DetVend.CalcSums(Amount);
                                AccountBal[4] := ABS(DetVend.Amount);
                            end;*/
                            AccountBal[4] := Vendor."Net Change";
                            VendL.Reset();
                            VendL.SetRange("Vendor No.", Vendor."No.");
                            VendL.SetFilter("Posting Date", '<=%1', AsAtDate);
                            VendL.SetRange(Reversed, false);
                            VendL.SetFilter("Credit Amount", '>%1', 0);
                            if VendL.FindLast() then begin
                                LastTransDateN[4] := VendL."Posting Date";
                            end;
                        end;

                        if AccountType."Sub Type" = AccountType."Sub Type"::Virtual then begin
                            /*DetVend.Reset();
                            DetVend.SetRange("Vendor No.", Vendor."No.");
                            DetVend.SetFilter("Posting Date", '<=%1', AsAtDate);
                            if DetVend.FindSet then begin
                                DetVend.CalcSums(Amount);
                                RegFeePaid := ABS(DetVend.Amount);
                            end;*/
                            RegFeePaid := Vendor."Net Change";
                            VendL.Reset();
                            VendL.SetRange("Vendor No.", Vendor."No.");
                            VendL.SetFilter("Posting Date", '<=%1', AsAtDate);
                            VendL.SetRange(Reversed, false);
                            VendL.SetFilter("Credit Amount", '>%1', 0);
                            if VendL.FindLast() then begin
                                LastTransDateN[5] := VendL."Posting Date";
                            end;
                        end;

                    end;
                end;
            until AccountType.Next() = 0;
        end;

        Cust.Reset();
        Cust.SetRange("Member No.", MemberNo);
        If Cust.FindSet() then begin
            repeat
                Cust.CalcFields(Balance);
                If Cust.Balance > 0 then begin
                    LoanBal += Cust.Balance;

                    If LastTransDateN[6] = 0D then begin
                        CustL.Reset();
                        CustL.SetRange("Customer No.", Cust."No.");
                        CustL.SetFilter("Posting Date", '<=%1', AsAtDate);
                        CustL.SetRange(Reversed, false);
                        CustL.SetFilter("Credit Amount", '>%1', 0);
                        if CustL.FindLast() then begin
                            LastTransDateN[6] := CustL."Posting Date";
                        end;
                    end else begin
                        CustL.Reset();
                        CustL.SetRange("Customer No.", Cust."No.");
                        CustL.SetFilter("Posting Date", '<=%1', AsAtDate);
                        CustL.SetRange(Reversed, false);
                        CustL.SetFilter("Credit Amount", '>%1', 0);
                        if CustL.FindLast() then begin
                            If CustL."Posting Date" > LastTransDateN[6] then
                                LastTransDateN[6] := CustL."Posting Date"
                            Else
                                LastTransDateN[6] := LastTransDateN[6];
                        end;
                    end;

                end;
            until Cust.Next = 0;
        end;

        if (LastTransDateN[1] <> 0D) OR (LastTransDateN[2] <> 0D) OR (LastTransDateN[3] <> 0D) OR (LastTransDateN[4] <> 0D) OR (LastTransDateN[5] <> 0D) OR (LastTransDateN[6] <> 0D) then begin

            If LastTransDateN[1] > LastTransDateN[2] then
                LastTransDate := LastTransDateN[1]
            else
                LastTransDate := LastTransDateN[2];

            If LastTransDateN[3] > LastTransDate then
                LastTransDate := LastTransDateN[3];

            If LastTransDateN[4] > LastTransDate then
                LastTransDate := LastTransDateN[4];

            If LastTransDateN[5] > LastTransDate then
                LastTransDate := LastTransDateN[5];

            If LastTransDateN[6] > LastTransDate then
                LastTransDate := LastTransDateN[6];
        end;
    end;
}