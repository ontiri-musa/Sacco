codeunit 50018 "Trailing Account Types Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        TrailingAccountTypeSetup: Record "Trailing Account Type Setup";
        AccountType: Record "Account Type";

    procedure OnOpenPage(var TrailingAccountTypeSetup: Record "Trailing Account Type Setup")
    begin
        with TrailingAccountTypeSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        AccountType: Record "Account Type";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingAccountTypeSetup.Get(UserId);
        if Evaluate(AccountType.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            AccountType.SetRange(Code, AccountType.Code);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        //AccountType.SetRange("Created Date", 0D, ToDate);
        // PAGE.Run(PAGE::"AccountType List", AccountType);
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: Text;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        AccountTypeCode: code[20];
        DimensionValue: Record "Dimension Value";
        TotalDV: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        TrailingAccountTypeSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            i := 0;
            if AccountType.FindSet() then begin
                repeat
                    i += 1;
                    AddMeasure(AccountType.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                until AccountType.Next() = 0;
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
                        SetValueByIndex(k - 1, j - 1, GetAccountTypeBalance(k, DimensionValue.Code));
                until DimensionValue.Next() = 0;
            end;
        end;
    end;

    local procedure GetAccountTypeBalance(Index: Integer; BranchCode: Code[20]) AccountBalance: Decimal
    var
        Vendor: record Vendor;
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
                    if Vendor.FindSet() then begin
                        repeat
                            AccountBalance += SumVLE(Vendor."No.", BranchCode);
                        until Vendor.Next() = 0;
                    end;
                end;
            until AccountType2.Next() = 0;
        end;
        exit(Abs(AccountBalance))
    end;

    procedure SumVLE(AccountNo: Code[20]; BranchCode2: Code[20]) TotalAmount: Decimal
    var
        VendorLEdgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLEdgerEntry.Reset();
        VendorLEdgerEntry.SetRange("Vendor No.", AccountNo);
        VendorLEdgerEntry.SetRange("Global Dimension 1 Code", BranchCode2);
        if VendorLEdgerEntry.FindSet() then begin
            repeat
                VendorLEdgerEntry.CalcFields("Amount (LCY)");
                TotalAmount += VendorLEdgerEntry.Amount;
            until VendorLEdgerEntry.Next() = 0;
        end;
        exit(Abs(TotalAmount))
    end;
}

