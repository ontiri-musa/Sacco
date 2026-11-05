page 50041 MemberStatisticsFactBox
{
    Caption = 'Member Statistics FactBox';
    PageType = CardPart;
    SourceTable = Member;

    layout
    {
        area(content)
        {
            field(Deposit; Deposit)
            {
                Caption = 'Member Deposits';
                ApplicationArea = All;
            }
            field(Shares; Shares)
            {
                Caption = 'Share Capital';
                ApplicationArea = All;
            }
            field(Boresha; Boresha)
            {
                Caption = 'Boresha Savings';
                ApplicationArea = All;
            }
            field(NxtGen; NxtGen)
            {
                Caption = 'Next Gen Savings';
                ApplicationArea = All;
            }
            field("Loan Outstanding Balance"; OutBal)
            {
                ApplicationArea = All;
            }
            field("Loan Outstanding Interest"; OutInt)
            {
                ApplicationArea = All;
            }
            field("Loan Outstanding Ledger Fee"; OutLedg)
            {
                ApplicationArea = All;
            }
            field("Loan Outstanding Penalty"; OutPen)
            {
                ApplicationArea = All;
            }
            field("Loan Outstanding Principal"; OutPrinc)
            {
                ApplicationArea = All;
            }
            field("Total Arrears"; TotalArrears)
            {
                ApplicationArea = All;
            }
            field(LPrePay; LPrePay)
            {
                ApplicationArea = All;
                Caption = 'Loan Prepayment';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Deposit := 0;
        Shares := 0;
        Boresha := 0;
        NxtGen := 0;
        OutBal := 0;
        OutInt := 0;
        OutPrinc := 0;
        OutLedg := 0;
        OutPen := 0;
        TotalArrears := 0;
        LPrePay := 0;


        AccType.Reset();
        AccType.SetRange(AccType.Type, AccType.Type::"Member Deposit");
        if AccType.FindFirst() then begin
            Vend.Reset();
            Vend.SetRange("Member No.", "No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                Vend.CalcFields(Balance);
                Deposit := Vend.Balance;
            end;
        end;
        AccType.Reset();
        AccType.SetRange(AccType.Type, AccType.Type::"Share Capital");
        if AccType.FindFirst() then begin
            Vend.Reset();
            Vend.SetRange("Member No.", "No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                Vend.CalcFields(Balance);
                Shares := Vend.Balance;
            end;
        end;
        AccType.Reset();
        AccType.SetRange(AccType.Type, AccType.Type::Savings);
        AccType.SetRange(AccType."Sub Type", AccType."Sub Type"::Boresha);
        if AccType.FindFirst() then begin
            Vend.Reset();
            Vend.SetRange("Member No.", "No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                Vend.CalcFields(Balance);
                Boresha := Vend.Balance;
            end;
        end;
        AccType.Reset();
        AccType.SetRange(AccType.Type, AccType.Type::Savings);
        AccType.SetRange(AccType."Sub Type", AccType."Sub Type"::NXTGen);
        if AccType.FindFirst() then begin
            Vend.Reset();
            Vend.SetRange("Member No.", "No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                Vend.CalcFields(Balance);
                NxtGen := Vend.Balance;
            end;
        end;

        Tsetup.Get();


        Cust.Reset();
        Cust.SetRange("Member No.", "No.");
        if Cust.FindSet() then begin
            repeat
                Cust.CalcFields(Balance);
                if Cust.Balance > 0 then begin
                    OutBal += Cust.Balance;

                    Dcust.Reset();
                    Dcust.SetRange("Customer No.", Cust."No.");
                    if Dcust.FindSet() then begin
                        repeat
                            if (Dcust."Transaction Type Code" = Tsetup."New Loan") or (Dcust."Transaction Type Code" = Tsetup."Principal Paid") then
                                OutPrinc += Dcust.Amount;
                            if (Dcust."Transaction Type Code" = Tsetup."Interest Due") or (Dcust."Transaction Type Code" = Tsetup."Interest Paid") then
                                OutInt += Dcust.Amount;
                            if (Dcust."Transaction Type Code" = Tsetup."Ledger Fee Due") or (Dcust."Transaction Type Code" = Tsetup."Ledger Fee Paid") then
                                OutLedg += Dcust.Amount;
                            if (Dcust."Transaction Type Code" = Tsetup."Penalty Due") or (Dcust."Transaction Type Code" = Tsetup."Penalty Paid") then
                                OutPen += Dcust.Amount;
                            if (Dcust."Transaction Type Code" = Tsetup."Loan Prepayment") then
                                LPrePay += Dcust.Amount;
                        until Dcust.Next = 0;
                    end;

                    if LPrePay > 0 then
                        LPrePay := 0
                    else
                        LPrePay := LPrePay;

                    GlobalM.CalculateLoanArrearsAndOverpayment(Cust."No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverPAmount[1], OverPAmount[2]);
                    TotalArrears += ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4];
                end;
            until Cust.Next = 0;
        end;

    end;

    var
        Deposit: Decimal;
        TotalArrears: Decimal;
        GlobalM: Codeunit "Global Management";
        ArrearsAmount: array[5] of Decimal;
        OverPAmount: array[5] of Decimal;
        Shares: Decimal;
        NxtGen: Decimal;
        Boresha: Decimal;
        AccType: Record "Account Type";
        Vend: Record Vendor;
        Tsetup: Record "Transaction Type Code Setup";
        OutBal: Decimal;
        OutPrinc: Decimal;
        OutInt: Decimal;
        OutLedg: Decimal;
        OutPen: Decimal;
        Cust: Record Customer;
        LPrePay: Decimal;
        Dcust: Record "Detailed Cust. Ledg. Entry";
}
