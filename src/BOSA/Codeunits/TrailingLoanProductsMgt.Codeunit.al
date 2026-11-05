codeunit 50020 "Trailing Loan Products Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        TrailingLoanProductSetup: Record "Trailing Loan Product Setup";
        LoanProductType: Record "Loan Product Type";

    procedure OnOpenPage(var TrailingLoanProductSetup: Record "Trailing Loan Product Setup")
    begin
        with TrailingLoanProductSetup do
            if not Get(UserId) then begin
                LockTable;
                "User ID" := UserId;
                "Chart Type" := "Chart Type"::"Stacked Column";
                Insert;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        LoanProductType: Record "Loan Product Type";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingLoanProductSetup.Get(UserId);
        if Evaluate(LoanProductType.Description, BusChartBuf.GetMeasureValueString(Measure), 9) then
            LoanProductType.SetRange(Code, LoanProductType.Code);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        //LoanProductType.SetRange("Created Date", 0D, ToDate);
        // PAGE.Run(PAGE::"LoanProductType List", LoanProductType);
    end;
    /*
        procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
        var
            DimensionValue: Record "Dimension Value";
            TotalDV: Integer;
            TotalAC: Integer;
            ChartMap: Integer;
            i: Integer;
            j: Integer;
            k: Integer;
        begin
            TrailingLoanProductSetup.Get(UserId);
            with BusChartBuf do begin
                Initialize;
                i := 0;
                if LoanProductType.FindSet() then begin
                    repeat
                        i += 1;
                        AddMeasure(LoanProductType.Description, i, "Data Type"::Decimal, "Chart Type"::StackedColumn);
                    until LoanProductType.Next() = 0;
                end;
                j := 0;
                SetXAxis('BranchCode', "Data Type"::String);
                DimensionValue.SetRange("Dimension Code", 'BRANCH');
                TotalDV := DimensionValue.Count;
                if DimensionValue.FindSet() then begin
                    repeat
                        j += 1;
                        AddColumn(DimensionValue.Name);
                    //FOR k := 1 TO i do
                    //   SetValueByIndex(k - 1, j - 1, GetLoanProductBalance(k, DimensionValue.Code));
                    until DimensionValue.Next() = 0;
                end;
            end;
        end;*/

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToStatusMap: Text;
        ToDate: array[4] of Date;
        FromDate: array[4] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        EarnNumber: Integer;
        PayrollPeriod: Record "Payroll Period";
        TotalMonths: Integer;
        TotalAC: Integer;
        ChartMap: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
        EarningCode: array[100] of Code[200];
        TotalEarning: Decimal;

    begin
        TrailingLoanProductSetup.Get(UserId);
        with BusChartBuf do begin
            Initialize;
            "Period Length" := TrailingLoanProductSetup."Period Length";
            SetPeriodXAxis;
            i := 0;
            if LoanProductType.FindSet() then begin
                repeat
                    i += 1;
                    AddMeasure(LoanProductType.Description, i, "Data Type"::Decimal, "Chart Type"::Column);
                until LoanProductType.Next() = 0;
            end;

            if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
                AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
                for EarnNumber := 1 to i do begin
                    for ColumnNo := 1 to ArrayLen(ToDate) do begin
                        TotalValue := 0;
                        Value := GetTotalEarnings(FromDate[ColumnNo], ToDate[ColumnNo], EarningCode[EarnNumber]);
                        if ColumnNo = 1 then
                            TotalValue := Value
                        else
                            TotalValue += Value;
                        SetValueByIndex(EarnNumber - 1, ColumnNo - 1, TotalValue);
                    end;
                end;
            end;
        end;
    end;

    local procedure GetTotalEarnings(FromDate: Date; ToDate: Date; EarningCode: Code[200]): Decimal
    var
        PayrollEntries: record "Payroll Entries";
        EarningsSetup: Record "Earnings Setup";
        AccountBalance: Decimal;
        LoanApp: Record "Loan Application";
    begin
        LoanApp.Reset();
        LoanApp.SetRange("Disbursal Date", FromDate, ToDate);
        LoanApp.SetRange(Posted, true);
        LoanApp.SetRange("Loan Product Type", EarningCode);
        if LoanApp.FindSet() then begin
            LoanApp.CalcSums("Approved Amount");
            AccountBalance := LoanApp."Approved Amount";
        end;
        exit(AccountBalance)
    end;

    local procedure CalcPeriods(var FromDate: array[4] of Date; var ToDate: array[4] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := TrailingLoanProductSetup.GetStartDate;
        if ToDate[MaxPeriodNo] = 0D then
            exit(false);
        for i := MaxPeriodNo downto 1 do begin
            if i > 1 then begin
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            end else
                FromDate[i] := 0D
        end;
        exit(true);
    end;

    local procedure GetLoanProductBalance(Index: Integer; BranchCode: Code[20]) AccountBalance: Decimal
    var
        Customer: record Customer;
        LoanProductType2: Record "Loan Product Type";
        l: Integer;
    begin
        l := 0;
        if LoanProductType2.FindSet() then begin
            repeat
                l += 1;
                if l = Index then begin
                    AccountBalance := 0;
                    Customer.Reset();
                    Customer.SetRange("Customer Posting Group", LoanProductType2.Code);
                    if Customer.FindSet() then begin
                        repeat
                            AccountBalance += SumCLE(Customer."No.", BranchCode);
                        until Customer.Next() = 0;
                    end;
                end;
            until LoanProductType2.Next() = 0;
        end;
        exit(Abs(AccountBalance))
    end;

    procedure SumCLE(AccountNo: Code[20]; BranchCode2: Code[20]) TotalAmount: Decimal
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustomerLedgerEntry.Reset();
        CustomerLedgerEntry.SetRange("Customer No.", AccountNo);
        CustomerLedgerEntry.SetRange("Global Dimension 1 Code", BranchCode2);
        if CustomerLedgerEntry.FindSet() then begin
            repeat
                CustomerLedgerEntry.CalcFields("Amount (LCY)");
                TotalAmount += CustomerLedgerEntry.Amount;
            until CustomerLedgerEntry.Next() = 0;
        end;
        exit(Abs(TotalAmount))
    end;
}

