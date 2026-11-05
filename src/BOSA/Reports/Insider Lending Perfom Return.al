report 51117 "Insider Lending Perfom Return"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\BOSA\Insider Lending Perfom Return.rdl';
    Caption = 'Insider Lending Loan Return';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = WHERE(Status = FILTER(Approved), Posted = FILTER(true), "Sub Category" = FILTER(Staff | "Board Member"), "Outstanding Balance" = filter(> 0));
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(MemberName_LoanApplication; "Loan Application"."Member Name")
            {
            }
            column(MemberNo_LoanApplication; "Loan Application"."Member No.")
            {
            }
            column(PostionHeld_LoanApplication; "Loan Application"."Sub Category")
            {
            }
            column(Description_LoanApplication; "Loan Application".Description)
            {
            }
            column(RequestedAmount_LoanApplication; "Loan Application"."Requested Amount")
            {
            }
            column(ApprovedAmount_LoanApplication; "Loan Application"."Approved Amount")
            {
            }
            column(ApprovedDate_LoanApplication; "Loan Application"."Disbursal Date")
            {
            }
            column(Deposits; Deposits)
            {
            }
            column(Security; Security)
            {
            }
            column(NextDueDate_LoanApplication; "Loan Application"."Next Due Date")
            {
            }
            column(RepaymentPeriod_LoanApplication; "Loan Application"."Repayment Period")
            {
            }
            column(Outbal; Outbal)
            {
            }
            column(LineNo; LineNo)
            {
            }
            column(Class; Class)
            {
            }
            column(FirstDayOfLastMonth; FirstDayOfLastMonth)
            {
            }
            column(FirstDayOfLastMonthTotalApproved; FirstDayOfLastMonthTotalApproved)
            {
            }
            column(LastDayOfLastMonth; LastDayOfLastMonth)
            {
            }
            trigger OnAfterGetRecord();
            begin
                Deposits := 0;
                Class := '';
                LineNo += 1;

                //Message('GEN Approved Amount %1', "Loan Application"."Approved Amount");
                FirstDayOfLastMonthTotalApproved := FirstDayOfLastMonthTotalApproved + "Loan Application"."Approved Amount";
                CalcFields("Total Collateral Amount", "Total Guaranteed Amount");
                If "Total Collateral Amount" > 0 then
                    Security := Security::Collateral;
                If "Total Guaranteed Amount" > 0 then
                    Security := Security::Guarantors;
                If ("Total Collateral Amount" > 0) and ("Total Guaranteed Amount" > 0) then
                    Security := Security::Both;
                //IF "Loan Application"."Member Category"="Loan Application"."Member Category"::"Board Member" THEN BEGIN
                MembAcc.RESET;
                MembAcc.SETRANGE(MembAcc."Member No.", "Loan Application"."Member No.");
                MembAcc.SETRANGE(MembAcc."Account Type", '02');
                if MembAcc.FINDFIRST then begin
                    MembAcc.CALCFIELDS(MembAcc.Balance);
                    Deposits := MembAcc.Balance;
                end;
                //END;
                Outbal := 0;

                /*
                Loans.RESET;
                Loans.SETRANGE(Loans."No.", "Loan Application"."No.");
                Loans.SETRANGE(Loans."Customer Type", Loans."Customer Type"::Loan);
                if Loans.FINDFIRST then begin
                    Loans.CALCFIELDS(Loans.Balance);
                   // Outbal := Loans.Balance;
                end;
                */
                if "Loan Application"."Approved Date" < FirstDayOfLastMonth then begin
                    DCust.Reset();
                    DCust.SetRange("Customer No.", "Loan Application"."No.");
                    DCust.SetFilter("Posting Date", Dfilter);
                    if DCust.FindSet() then begin
                        DCust.CalcSums(DCust.Amount);
                        Outbal := DCust.Amount;
                    end;
                    // Message('Approved Amount %1', "Loan Application"."Approved Amount");
                end;

                if ("Loan Application"."Approved Date" >= FirstDayOfLastMonth) and ("Loan Application"."Approved Date" <= LastDayOfLastMonth) then begin
                    //Message('Approved Amount %1', "Loan Application"."Approved Amount");
                    FirstDayOfLastMonthTotalApproved := FirstDayOfLastMonthTotalApproved + "Loan Application"."Approved Amount";
                end;


                LoanClass.RESET;
                LoanClass.SETRANGE(LoanClass."Loan No.", "Loan Application"."No.");
                if LoanClass.FINDFIRST then begin
                    Class := LoanClass."Class Description";
                end else begin
                    Class := 'PERFORMING';
                end;
            end;

            trigger OnPreDataItem();
            var
                LoanApp: Record "Loan Application";
                Memb: Record Member;
            begin
                LoanApp.Reset();
                LoanApp.SetRange(Posted, true);
                if LoanApp.FindSet() then begin
                    repeat
                        If (LoanApp."Sub Category" = LoanApp."Sub Category"::"Board Member") or (LoanApp."Sub Category" = LoanApp."Sub Category"::Staff) then begin
                            Memb.Reset();
                            Memb.SetRange("No.", LoanApp."Member No.");
                            if Memb.FindFirst() then begin
                                LoanApp."Sub Category" := Memb."Sub Category";
                                LoanApp.Modify();
                            end;
                        end;
                    until LoanApp.Next = 0;
                end;
                If AsAt = 0D then
                    AsAt := Today;

                FirstDayOfLastMonth := CalcDate('-CM', AsAt);
                LastDayOfLastMonth := CalcDate('CM', FirstDayOfLastMonth);
                LineNo := 0;
                FirstDayOfLastMonthTotalApproved := 0;
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
                    field(AsAt; AsAt)
                    {
                        ApplicationArea = All;
                        Caption = 'As At Date';
                    }
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

    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        GlBalance: array[50] of Decimal;
        AsAt: Date;
        GL: Record "G/L Account";
        GL2: Record "G/L Account";
        Bank: Record "Bank Account";
        BankBal: Decimal;
        DCust: Record "Detailed Cust. Ledg. Entry";
        Deposits: Decimal;
        MembAcc: Record Vendor;
        Outbal: Decimal;
        Dfilter: Text;
        Security: Option " ",Guarantors,Collateral,Both;
        Loans: Record Customer;
        LineNo: Integer;
        LoanClass: Record "Loan Classification Entry";
        Class: Text;
        FirstDayOfLastMonth: Date;
        LastDayOfLastMonth: Date;
        FirstDayOfLastMonthTotalApproved: Decimal;
        PrevousLoansOutBal: Decimal;
}

