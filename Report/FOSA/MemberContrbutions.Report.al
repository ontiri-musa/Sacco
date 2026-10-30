report 50007 "Member Contributions"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/MemberContribution.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", Status, "Registration Date";
            column(No_; "No.")
            {

            }
            column(Full_Name; "Full Name")
            {

            }
            column(Status; Status)
            {

            }
            column(Registration_Date; "Registration Date")
            {

            }
            column(StartDate; StartDate)
            {

            }
            column(EndDate; EndDate)
            {

            }
            column(Picture; CompInfo.Picture)
            {

            }
            column(CompName; CompInfo.Name)
            {

            }
            column(ContributionAmount_1; ContributionAmount[1])
            {

            }

            column(ContributionAmount_2; ContributionAmount[2])
            {

            }
            column(ContributionAmount_3; ContributionAmount[3])
            {

            }
            column(ContributionAmount_4; ContributionAmount[4])
            {

            }
            column(ContributionAmount_5; ContributionAmount[5])
            {

            }

            trigger OnAfterGetRecord()
            var

            begin
                CalculateMemberContribution("No.", ContributionAmount[1], ContributionAmount[2], ContributionAmount[3], ContributionAmount[4], ContributionAmount[5]);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;

                    }



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
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture)
    end;

    local procedure CalculateMemberContribution(MemberNo: Code[20]; var SharesAmount: Decimal; var DepositAmount: Decimal; var BoreshaAmount: Decimal; var NXTGenAmount: Decimal; var RegFeeAmount: Decimal)
    var
        myInt: Integer;
    begin
        BoreshaAmount := 0;
        NXTGenAmount := 0;
        RegFeeAmount := 0;
        DepositAmount := 0;
        SharesAmount := 0;

        Vendor.Reset();
        Vendor.SetRange("Member No.", MemberNo);
        if Vendor.FindSet() then begin
            repeat
                AccountType.Get(Vendor."Account Type");
                if AccountType.Type = AccountType.Type::Savings then begin
                    if (AccountType."Sub Type" = AccountType."Sub Type"::Boresha) then
                        BoreshaAmount += CalculateVLE(Vendor."No.");
                    if (AccountType."Sub Type" = AccountType."Sub Type"::NXTGen) then
                        NXTGenAmount += CalculateVLE(Vendor."No.");
                    if (AccountType."Sub Type" = AccountType."Sub Type"::Virtual) then
                        RegFeeAmount += CalculateVLE(Vendor."No.");
                end;
                if AccountType.Type = AccountType.Type::"Member Deposit" then begin
                    DepositAmount += CalculateVLE(Vendor."No.");
                end;
                if AccountType.Type = AccountType.Type::"Share Capital" then begin
                    SharesAmount += CalculateVLE(Vendor."No.");
                end;
            until Vendor.Next() = 0;
        end;
    end;

    local procedure CalculateVLE(AccountNo: Code[20]): Decimal
    var
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
        VendorLedgerEntry.SetRange("Vendor No.", AccountNo);
        if VendorLedgerEntry.FindSet() then begin
            repeat
                VendorLedgerEntry.CalcFields(Amount);
                TotalAmount += VendorLedgerEntry.Amount;
            until ((VendorLedgerEntry.Next() = 0))
        end;
        exit(Abs(TotalAmount))
    end;

    local procedure CalculateTellerTrx(MemberNo: Code[20]): Decimal
    var
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        TellerTransactionHeader.Reset();
        TellerTransactionHeader.SetRange(Posted, true);
        TellerTransactionHeader.SetRange("Transaction Date", StartDate, EndDate);
        if TellerTransactionHeader.FindSet() then begin
            repeat
                TellerTransactionLine.Reset();
                TellerTransactionLine.SetRange("Transaction No.", TellerTransactionHeader."No.");
                TellerTransactionLine.SetRange("Member No.", MemberNo);
                TellerTransactionLine.SetFilter("Account No.", '003');
                if TellerTransactionLine.FindSet() then begin
                    repeat
                        TotalAmount += TellerTransactionLine."Line Amount"
                    until ((TellerTransactionLine.Next() = 0))
                end;

            until TellerTransactionHeader.Next() = 0;
        end;
        exit(Abs(TotalAmount))
    end;

    var
        StartDate: Date;
        EndDate: Date;


        MemberContribution: Record "Member Contribution";
        Vendor: Record Vendor;
        VendorLedgerEntry: Record "Vendor Ledger Entry";

        ContributionAmount: array[6] of Decimal;
        CompInfo: Record "Company Information";
        AccountType: Record "Account Type";

        TellerTransactionLine: Record "Teller Transaction Line";
        TellerTransactionHeader: Record "Teller Transaction Header";

}