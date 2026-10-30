codeunit 50091 "Member Accounts Analysis Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        MemberAnalysisSetup: Record "Member Analysis Setup";
        AccountTypes: Record "Account Type";
        Vendor: Record Vendor;
    /*  Vendor: Record "Loan Application";
     LoanProductType: Record "Loan Product Type"; */

    procedure OnOpenPage(var MemberAnalysisSetup: Record "Member Analysis Setup")
    begin
        with MemberAnalysisSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        MemberAnalysisSetup.Get(UserId);
        if Evaluate(AccountTypes.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            AccountTypes.SetRange(Description, AccountTypes.Description);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: Text;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        DimensionValue: Record "Dimension Value";
        TotalDV: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        MemberAnalysisSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            i := 0;
            if AccountTypes.FindSet() then begin
                repeat
                    i += 1;
                    AddMeasure(AccountTypes.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until AccountTypes.Next() = 0;
            end;
            j := 0;
            SetXAxis('BranchCode', "Data Type"::String);
            DimensionValue.SetRange("Dimension Code", 'BRANCH');
            TotalDV := DimensionValue.Count;
            if DimensionValue.FindSet() then begin
                repeat
                    j += 1;
                    AddColumn(DimensionValue.Name);
                    FOR k := 1 TO i do
                        SetValueByIndex(k - 1, j - 1, GetAccountBalances(k, DimensionValue.Code));
                until DimensionValue.Next() = 0;
            end;
        end;
    end;

    local procedure GetAccountBalances(Index: Integer; BranchCode: Code[20]) AccountBalance: Decimal
    var
        AccountType2: Record "Account Type";
        l: Integer;
    begin
        l := 0;
        if AccountType2.FindSet() then begin
            repeat
                l += 1;
                if l = Index then begin
                    AccountBalance := 0;
                    Vendor.Reset();
                    Vendor.SetRange("Account Type", AccountType2.Code);
                    Vendor.SetRange("Global Dimension 1 Code", BranchCode);
                    if Vendor.FindSet() then begin
                        repeat
                            Vendor.CalcFields(Balance);
                            AccountBalance += Vendor.Balance;
                        until Vendor.Next() = 0;
                    end;
                end;
            until AccountType2.Next() = 0;
        end;
        exit(Abs(AccountBalance))
    end;
}
