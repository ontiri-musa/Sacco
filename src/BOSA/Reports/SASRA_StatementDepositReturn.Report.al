report 50119 "Statement of Deposit Return"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\BOSA\StatementofDepositReturn.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            column(StartDate; StartDate)
            {

            }
            column(EndDate; EndDate)
            {

            }
            column(TotalNoofAccounts_1; TotalNoofAccounts[1])
            {

            }
            column(TotalNoofAccounts_2; TotalNoofAccounts[2])
            {

            }
            column(TotalNoofAccounts_3; TotalNoofAccounts[3])
            {

            }
            column(TotalNoofAccounts_4; TotalNoofAccounts[4])
            {

            }
            column(TotalNoofAccounts_5; TotalNoofAccounts[5])
            {

            }
            column(TotalAccountBalance_1; TotalAccountBalance[1])
            {

            }
            column(TotalAccountBalance_2; TotalAccountBalance[2])
            {

            }
            column(TotalAccountBalance_3; TotalAccountBalance[3])
            {

            }
            column(TotalAccountBalance_4; TotalAccountBalance[4])
            {

            }
            column(TotalAccountBalance_5; TotalAccountBalance[5])
            {

            }
            column(TotalAccountBalance_6; TotalAccountBalance[6])
            {

            }
            trigger OnPreDataItem()
            var

            begin
                SetRange(Number, 1, 1);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                //if StartDate = 0D then
                //Error('Start Date cannot be blank');
                if EndDate = 0D then
                    Error('End Date cannot be blank');

                CalculateMemberDepositsAccountsData();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    /*field(StartDate; StartDate)
                    {
                        ApplicationArea = All;

                    }*/
                    field(EndDate; EndDate)
                    {
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
    local procedure CalculateMemberDepositsAccountsData()
    var

    begin
        TotalNoofAccounts[1] := 0;
        TotalNoofAccounts[2] := 0;
        TotalNoofAccounts[3] := 0;
        TotalNoofAccounts[4] := 0;
        TotalNoofAccounts[5] := 0;

        TotalAccountBalance[1] := 0;
        TotalAccountBalance[2] := 0;
        TotalAccountBalance[3] := 0;
        TotalAccountBalance[4] := 0;
        TotalAccountBalance[5] := 0;
        TotalAccountBalance[6] := 0;

        AccountType.Reset();
        AccountType.SetRange(Type, AccountType.Type::"Member Deposit");
        if AccountType.FindFirst() then begin
            Vendor.Reset();
            Vendor.SetRange("Account Type", AccountType.Code);
            Vendor.SetFilter("Date Filter", '..%1', EndDate);
            if Vendor.FindSet() then begin
                repeat
                    Vendor.CalcFields("Net Change");
                    if (abs(Vendor."Net Change") >= 0) and (abs(Vendor."Net Change") <= 50000) then begin
                        TotalNoofAccounts[1] += 1;
                        TotalAccountBalance[1] += Vendor."Net Change";
                    end;
                    if (abs(Vendor."Net Change") >= 50001) and (abs(Vendor."Net Change") <= 100000) then begin
                        TotalNoofAccounts[2] += 1;
                        TotalAccountBalance[2] += Vendor."Net Change";
                    end;
                    if (abs(Vendor."Net Change") >= 100001) and (abs(Vendor."Net Change") <= 300000) then begin
                        TotalNoofAccounts[3] += 1;
                        TotalAccountBalance[3] += Vendor."Net Change";
                    end;
                    if (abs(Vendor."Net Change") >= 300001) and (abs(Vendor."Net Change") <= 1000000) then begin
                        TotalNoofAccounts[4] += 1;
                        TotalAccountBalance[4] += Vendor."Net Change";
                    end;
                    if (abs(Vendor."Net Change") > 1000000) then begin
                        TotalNoofAccounts[5] += 1;
                        TotalAccountBalance[5] += Vendor."Net Change";
                    end;
                    TotalAccountBalance[6] += Vendor."Net Change";
                until Vendor.Next() = 0;
            end;
        end;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        Vendor: Record Vendor;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AccountType: Record "Account Type";

        TotalAccountBalance: array[10] of Decimal;
        TotalNoofAccounts: array[10] of Integer;

}