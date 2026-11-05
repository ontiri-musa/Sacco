page 50348 "BOSA Activities"
{
    PageType = CardPart;
    SourceTable = "BOSA Cue";

    layout
    {
        area(content)
        {
            cuegroup(LoanApplicationWideLayout)
            {

                Caption = 'Summary';
                CuegroupLayout = Wide;
                // field("Total Requested Amount"; "Total Requested Amount")
                // {
                //     Caption = 'Total Requested Amount';
                //     DrillDownPageId = "Posted Loan List";
                //     ApplicationArea = All;
                // }
                field("Total Disbursed Amount"; "Total Disbursed Amount")
                {
                    Caption = 'Total Disbursed Amount';
                    Image = Calculator;
                    DrillDownPageId = "Loan Applications List-Posted";
                    ApplicationArea = All;
                }
                field(TotalOLB; TotalOLB)

                {
                    Caption = 'Total Oustanding Loan Balance';
                    ApplicationArea = All;
                    Image = Cash;
                    DrillDownPageId = "Loan Applications List-Posted";

                }
                field(ActiveLoansArrears; ActiveLoansArrears)
                {
                    Caption = 'Active Loans Total Arrears';
                    ApplicationArea = All;
                    Image = Receipt;
                    DrillDownPageId = "Loan Applications List-Posted";
                }
                field(ExpiredLoansArrears; ExpiredLoansArrears)
                {
                    Caption = 'Expired Loans Total Arrears';
                    ApplicationArea = All;
                    Image = Receipt;
                    DrillDownPageId = "Loan Applications List-Posted";
                }
                field(TotalArrears; TotalArrears)
                {
                    Caption = 'Total Arrears';
                    ApplicationArea = All;
                    Image = Receipt;
                    DrillDownPageId = "Loan Applications List-Posted";
                }
                field(TotalPAR; TotalPAR)
                {
                    Caption = 'Total PAR';
                    Image = Chart;
                    ApplicationArea = All;
                    DrillDownPageId = "Loan Applications List-Posted";

                }

            }
            cuegroup(LoanApplicationCueContainer)
            {
                Caption = 'Loan Application';
                //CuegroupLayout = Wide;
                field("LoanApplication-New"; "LoanApplication-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Loan Application List-New";
                    ApplicationArea = All;
                }
                field("LoanApplication-Pending"; "LoanApplication-Pending")
                {
                    Caption = 'Pending Appraisal';
                    DrillDownPageId = "Loan Appl. List-Pending Apprsl";
                    ApplicationArea = All;
                }
                field("LoanApplication-Approved"; "LoanApplication-Approved")
                {
                    Caption = 'Pending Disbursal';
                    DrillDownPageId = "Loan Appl. List-Pending Dbsl";
                    ApplicationArea = All;
                }
                field("LoanApplication-Posted"; "LoanApplication-Posted")
                {
                    Caption = 'Posted Loans';
                    DrillDownPageId = "Loan Applications List-Posted";
                    ApplicationArea = All;
                }

            }
            cuegroup(StandingOrderCueContainer)
            {
                Caption = 'Standing Order';
                //CuegroupLayout = Wide;
                field("StandingOrder-New"; "StandingOrder-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Standing Order List-New";
                    ApplicationArea = All;
                }
                field("StandingOrder-Pending"; "StandingOrder-Pending")
                {
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Standing Order List-Pending";
                    ApplicationArea = All;
                }
                field("StandingOrder-Running"; "StandingOrder-Running")
                {
                    Caption = 'Running';
                    DrillDownPageId = "Standing Order List-Running";
                    ApplicationArea = All;
                }
                field("StandingOrder-Approved"; "StandingOrder-Approved")
                {
                    Caption = 'Stopped';
                    DrillDownPageId = "Standing Order List-Approved";
                    ApplicationArea = All;
                }

            }


            cuegroup(LoanApplicationActionContainer)
            {
                Caption = 'Loan Application';

                actions
                {

                    action("New Loan Application")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Loan Application Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(StandingOrderActionContainer)
            {
                Caption = 'Standing Order';

                actions
                {

                    action("New Standing Order")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Standing Order Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(FundTransferActionContainer)
            {
                Caption = 'Fund Transfer';

                actions
                {

                    action("New Funs Transfer")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Fund Transfer";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(GuarantorSubstitutionActionContainer)
            {
                Caption = 'Guarantor Substitution';

                actions
                {

                    action("New Guarantor Substitution")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Guarantor Substitution";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
            cuegroup(LoanReschedulingActionContainer)
            {
                Caption = 'Loan Rescheduling';

                actions
                {

                    action("New Loan Rescheduling")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Loan Rescheduling";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        RESET;
        if not get then begin
            INIT;
            INSERT;
        end;
        CalculateLoanSummary();
        //GetMemberNoInLegderEntries();
    end;

    local procedure GetMemberNoInLegderEntries()
    var
        Member: Record Member;
        BankL: Record "Bank Account Ledger Entry";
        CustL: Record "Cust. Ledger Entry";
        VendL: Record "Vendor Ledger Entry";
        GLentry: Record "G/L Entry";
        Vend: Record Vendor;
        Cust: Record Customer;
    begin
        Member.Reset();
        If Member.FindSet() then begin
            repeat
                Vend.Reset();
                Vend.SetRange("Member No.", Member."No.");
                If Vend.FindSet() then begin
                    repeat
                        VendL.Reset();
                        VendL.SetRange("Vendor No.", Vend."No.");
                        VendL.SetFilter("Posting Date", '>%1', 20211231D);
                        VendL.SetRange("Member No.", '');
                        If VendL.FindSet() then begin
                            repeat
                                VendL.CalcFields(Amount);
                                GLentry.Reset();
                                GLentry.SetRange("Transaction No.", VendL."Transaction No.");
                                GLentry.SetRange(Amount, VendL.Amount);
                                GLentry.SetRange("Member No.", '');
                                If GLentry.FindFirst() then begin
                                    GLentry."Member No." := Member."No.";
                                    GLentry.Modify();
                                end;
                                VendL."Member No." := Member."No.";
                                VendL.Modify();
                            until VendL.Next = 0;
                        end;
                    until Vend.Next = 0;
                end;
                Cust.Reset();
                Cust.SetRange("Member No.", Member."No.");
                If Cust.FindSet() then begin
                    repeat
                        CustL.Reset();
                        CustL.SetRange("Customer No.", Cust."No.");
                        CustL.SetFilter("Posting Date", '>%1', 20211231D);
                        CustL.SetRange("Member No.", '');
                        If CustL.FindSet() then begin
                            repeat
                                CustL.CalcFields(Amount);
                                GLentry.Reset();
                                GLentry.SetRange("Transaction No.", CustL."Transaction No.");
                                GLentry.SetRange(Amount, CustL.Amount);
                                GLentry.SetRange("Member No.", '');
                                If GLentry.FindFirst() then begin
                                    GLentry."Member No." := Member."No.";
                                    GLentry.Modify();
                                end;
                                CustL."Member No." := Member."No.";
                                CustL.Modify();
                            until CustL.Next = 0;
                        end;
                    until Cust.Next = 0;
                end;
            until Member.Next = 0;
        end;
    end;

    local procedure CalculateLoanSummary()
    var
        LoanClassificationEntry: Record "Loan Classification Entry";
        LoanClassificationEntry2: Record "Loan Classification Entry";
        Loan: Record "Loan Application";
        GlobalM: Codeunit "Global Management";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        BosaM: Codeunit "BOSA Management";
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationCode: Code[100];
        ClassificationDesc: Text;
        ProvisioningPercent: Decimal;
    begin
        TotalArrears := 0;
        TotalPAR := 0;
        TotalOLB := 0;
        ArrearsAmount[1] := 0;
        ArrearsAmount[2] := 0;
        ArrearsAmount[3] := 0;
        ArrearsAmount[4] := 0;
        OverpaymentAmount[1] := 0;
        OverpaymentAmount[2] := 0;
        NoofDaysInArrears := 0;
        NoofInstallmentInArrears := 0;
        ClassificationDesc := '';

        Loan.Reset();
        Loan.SetRange(Posted, true);
        Loan.SetRange(Cleared, false);
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    /* GlobalM.CalculateLoanArrearsAndOverpayment(Loan."No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2]);
                     BosaM.CalculateDaysAndInstallmentsInArrearsDefaulter(Loan."No.", (ArrearsAmount[1] + ArrearsAmount[2]), NoofDaysInArrears, NoofInstallmentInArrears, Today);
                     BosaM.GetClassificationClassDetails(NoofDaysInArrears, ClassificationCode, ClassificationDesc, ProvisioningPercent);
                     TotalArrears += ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4];
                     if (ClassificationDesc = 'WATCH') or (ClassificationDesc = 'DOUBTFUL') or (ClassificationDesc = 'SUBSTANDARD') or (ClassificationDesc = 'LOSS') then
                         TotalPAR += Loan."Outstanding Balance";
                         */
                    if (Loan.Classification = 'WATCH') or (Loan.Classification = 'DOUBTFUL') or (Loan.Classification = 'SUBSTANDARD') or (Loan.Classification = 'LOSS') then
                        TotalPAR += Loan."Outstanding Balance";
                    TotalArrears += Loan."Total Arrears";
                    TotalOLB += Loan."Outstanding Balance";
                    if Loan."Date of Completion" <= Today then
                        ExpiredLoansArrears += Loan."Total Arrears"
                    else
                        ActiveLoansArrears += Loan."Total Arrears";
                end;
            until Loan.Next = 0;
        end;
    end;

    var
        TotalArrears: Decimal;
        TotalPAR: Decimal;
        TotalOLB: Decimal;
        ExpiredLoansArrears: Decimal;
        ActiveLoansArrears: Decimal;

}