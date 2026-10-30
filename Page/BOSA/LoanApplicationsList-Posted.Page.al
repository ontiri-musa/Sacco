page 50207 "Loan Applications List-Posted"
{
    // version TL2.0

    Caption = 'Posted Loans';
    CardPageID = "Loan Application Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = FILTER(Approved), Posted = FILTER(true), "Outstanding Balance" = filter(> 0), Cleared = filter(false));//
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Phone No"; PhoneNo)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = All;
                }
                field("Church District Code"; "Church District Code")
                {
                    Caption = 'District';
                }
                field("Church Section Code"; "Church Section Code")
                {
                    Caption = 'Section';
                }
                field("Church Code"; "Church Code")
                {
                    Caption = 'Church';
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Disbursal Date"; "Disbursal Date")
                {
                    ApplicationArea = All;
                }
                field("Date of Completion"; "Date of Completion")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Principal"; "Outstanding Principal")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Interest"; "Outstanding Interest")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Penalty"; "Outstanding Penalty")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Ledger Fee"; "Outstanding Ledger Fee")
                {
                    ApplicationArea = All;
                }
                field(Prepayment; Prepayment)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Total Arrears"; "Total Arrears")
                {
                    ApplicationArea = All;
                }
                field("Days In Arrears"; "Days In Arrears")
                {
                    ApplicationArea = All;
                }
                field("Installment In Arrears"; "Installment In Arrears")
                {
                    ApplicationArea = All;
                }
                field(Classification; Classification)
                {
                    ApplicationArea = All;
                }

                field("Last Payment Date"; LastPDate)
                {
                    ApplicationArea = All;
                }

                field("Top-up"; "Top-up")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By"; "Disbursed By")
                {

                }
                field("Economic Sector"; "Economic Sector")
                { }
                field("Economic Sector Category"; "Economic Sector Category")
                { }
                field("Economic Sector Sub-Category"; "Economic Sector Sub-Category")
                { }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(updatePrepayment)
            {
                Caption = 'Run Automations';
                ApplicationArea = Basic, Suite;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = codeunit Automations;
                Visible = true;
            }
            action(LoanUpdate1)
            {
                Caption = 'Check trans';
                ApplicationArea = Basic, Suite;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                //RunObject = report "Run Monthly Penalty";
                trigger OnAction()
                var
                    Loans: Record "Loan Application";
                    BOSAManagement: Codeunit "BOSA Management";
                    GlobalManagement: Codeunit "Global Management";
                    LoanApplicationSetup: Record "Loan Application Setup";
                    RunDate: Date;
                    PostingDate: Date;
                    Customer: Record Customer;
                    LoanRepSch: Record "Loan Repayment Schedule";
                    DcustL: Record "Detailed Cust. Ledg. Entry";
                    GlEntry: Record "G/L Entry";
                    Lprod: Record "Loan Product Type";
                    CustPG: Record "Customer Posting Group";
                    CustL: Record "Cust. Ledger Entry";
                    Pdesc: Label 'Interest Charged Paid from Prepayment-';
                begin

                    Loans.Reset();
                    Loans.SetRange(Posted, true);
                    If Loans.FindSet() then begin
                        repeat
                            Lprod.Get(Loans."Loan Product Type");

                            CustL.Reset();
                            CustL.SetRange("Customer No.", Loans."No.");
                            CustL.SetRange(Description, Pdesc + Loans."No.");
                            If CustL.FindSet() then begin
                                repeat
                                    CustL.CalcFields(Amount);

                                    GlEntry.Reset();
                                    GlEntry.SetRange("Posting Date", CustL."Posting Date");
                                    GlEntry.SetRange("Document No.", CustL."Document No.");
                                    GlEntry.SetRange(Description, CustL.Description);
                                    GlEntry.SetRange("Transaction No.", CustL."Transaction No.");
                                    GlEntry.SetRange(Amount, CustL.Amount);
                                    If GlEntry.FindFirst() then begin
                                        If GlEntry."Posting Date" < 20230101D then begin
                                            GlEntry."G/L Account No." := Lprod."Interest Paid Posting Group";
                                            GlEntry.Modify();
                                        end else begin
                                            GlEntry."G/L Account No." := Lprod."Interest Due Posting Group";
                                            GlEntry.Modify();
                                        end;
                                    end;
                                until CustL.Next = 0;
                            end;
                        until Loans.Next = 0;
                    end;
                    /*
                                        GlEntry.Reset();
                                        GlEntry.SetRange("Member No.", '');
                                        GlEntry.SetFilter("G/L Account No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11', '2101', '2102', '2103', '2104', '2105', '2106', '2107', '2108', '2110', '2112', '2113');
                                        If GlEntry.FindSet() then begin
                                            repeat
                                                DcustL.Reset();
                                                DcustL.SetRange("Posting Date", GlEntry."Posting Date");
                                                DcustL.SetRange("Document No.", GlEntry."Document No.");
                                                DcustL.SetRange("Transaction No.", GlEntry."Transaction No.");
                                                DcustL.SetRange(Amount, GlEntry.Amount);
                                                If DcustL.FindFirst() then begin
                                                    IF Customer.Get(DcustL."Customer No.") then
                                                        GlEntry."Member No." := Customer."Member No.";
                                                    GlEntry."Posting Loan No." := DcustL."Customer No.";
                                                    GlEntry."Transaction Type Code" := DcustL."Transaction Type Code";
                                                    GlEntry.Modify();
                                                    DcustL."GL Transaction Found" := true;
                                                    DcustL."GL Account" := GlEntry."G/L Account No.";
                                                    DcustL.Modify();
                                                end;
                                            until GlEntry.Next = 0;
                                        end;
                                        GlEntry.Reset();
                                        GlEntry.SetRange("Member No.", '');
                                        GlEntry.SetFilter("G/L Account No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12|%13', '2211', '2212', '2213', '2214', '2215', '2216', '2217', '2218', '2219', '2220', '2221', '2222', '2223');
                                        If GlEntry.FindSet() then begin
                                            repeat
                                                DcustL.Reset();
                                                DcustL.SetRange("Posting Date", GlEntry."Posting Date");
                                                DcustL.SetRange("Document No.", GlEntry."Document No.");
                                                DcustL.SetRange("Transaction No.", GlEntry."Transaction No.");
                                                DcustL.SetRange(Amount, GlEntry.Amount);
                                                If DcustL.FindFirst() then begin
                                                    IF Customer.Get(DcustL."Customer No.") then
                                                        GlEntry."Member No." := Customer."Member No.";
                                                    GlEntry."Posting Loan No." := DcustL."Customer No.";
                                                    GlEntry."Transaction Type Code" := DcustL."Transaction Type Code";
                                                    GlEntry.Modify();
                                                    DcustL."GL Transaction Found" := true;
                                                    DcustL."GL Account" := GlEntry."G/L Account No.";
                                                    DcustL.Modify();
                                                end;
                                            until GlEntry.Next = 0;
                                        end;
                                        GlEntry.Reset();
                                        GlEntry.SetRange("Member No.", '');
                                        GlEntry.SetFilter("G/L Account No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12|%13', '2261', '2262', '2263', '2264', '2265', '2266', '2267', '2268', '2269', '2270', '2271', '2272', '2273');
                                        If GlEntry.FindSet() then begin
                                            repeat
                                                DcustL.Reset();
                                                DcustL.SetRange("Posting Date", GlEntry."Posting Date");
                                                DcustL.SetRange("Document No.", GlEntry."Document No.");
                                                DcustL.SetRange("Transaction No.", GlEntry."Transaction No.");
                                                DcustL.SetRange(Amount, GlEntry.Amount);
                                                If DcustL.FindFirst() then begin
                                                    IF Customer.Get(DcustL."Customer No.") then
                                                        GlEntry."Member No." := Customer."Member No.";
                                                    GlEntry."Posting Loan No." := DcustL."Customer No.";
                                                    GlEntry."Transaction Type Code" := DcustL."Transaction Type Code";
                                                    GlEntry.Modify();
                                                    DcustL."GL Transaction Found" := true;
                                                    DcustL."GL Account" := GlEntry."G/L Account No.";
                                                    DcustL.Modify();
                                                end;
                                            until GlEntry.Next = 0;
                                        end;
                    */

                    Message('Done!!');
                end;
            }

            action("Loan Guarantors")
            {
                ApplicationArea = Basic, Suite;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    LoanGuarantor.FILTERGROUP(10);
                    LoanGuarantor.SETRANGE("Loan No.", Rec."No.");
                    LoanGuarantor.FILTERGROUP(0);
                    PAGE.RUN(50210, LoanGuarantor);
                end;
            }
            action("post penalties")
            {
                ApplicationArea = Basic, Suite;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = false;
                trigger OnAction()
                var
                    LoanApplicationSetup: Record "Loan Application Setup";
                    GlobalManagement: Codeunit "Global Management";
                    postingDate: Date;
                    RunDate: Date;
                    "Loan Application": Record "Loan Application";
                    LoanProductType: Record "Loan Product Type";
                    custRec: Record Customer;
                    LoanRepSch: record "Loan Repayment Schedule";
                    GenJournalLine: record "Gen. Journal Line";
                    correctWrongPenalties: Codeunit "PenaltyMobileLoans-Correction";
                    GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";




                begin
                    LoanApplicationSetup.Get();

                    GlobalManagement.ClearJournal(LoanApplicationSetup."Penalty Template Name", LoanApplicationSetup."Penalty Batch Name");
                    for postingDate := 20241230D To 20250106D do begin
                        //  RunDate := 0D;
                        RunDate := Calcdate('-1D', PostingDate);
                        "Loan Application".Reset();
                        "Loan Application".SetFilter(Posted, '%1', true);
                        // "Loan Application".SetFilter("No.", '%1', 'BCL03849');
                        if "Loan Application".FindSet() then begin
                            repeat

                                LoanProductType.Get("Loan Application"."Loan Product Type");
                                If LoanProductType."E-Loan" = true then begin
                                    "Loan Application".CalcFields("Outstanding Balance");

                                    if "Loan Application"."Outstanding Balance" > 0 then begin

                                        custRec.Get("Loan Application"."No.");

                                        // if "Loan Application"."Date of Completion" >= postingDate then begin

                                        LoanRepSch.Reset();
                                        LoanRepSch.SetRange("Loan No.", "Loan Application"."No.");
                                        LoanRepSch.SetRange("Repayment Date", RunDate);
                                        if LoanRepSch.FindFirst() then begin
                                            // Message('%1,%2', LoanRepSch."Loan No.", custRec."No.");
                                            // Message('%1', "Loan Application"."Outstanding Balance");
                                            LoanApp.Reset();
                                            LoanApp.SetRange("No.", "Loan Application"."No.");
                                            LoanApp.SetFilter("Date Filter", '..%1', postingDate);
                                            If LoanApp.FindFirst() then begin
                                                LoanApp.CalcFields("Outstanding Balance");
                                                //  Message('%1,%2', custRec."No.", LoanRepSch."Repayment Date");
                                                correctWrongPenalties.CapitalizePenaltyMob(custRec, RunDate, postingDate, LoanRepSch."Total Installment", LoanApp);
                                            end;
                                        end;
                                    end;


                                end;
                            //  end;
                            until "Loan Application".Next() = 0;
                        end;
                        GenJournalLine.RESET;
                        GenJournalLine.SETRANGE("Journal Template Name", LoanApplicationSetup."Penalty Template Name");
                        GenJournalLine.SETRANGE("Journal Batch Name", LoanApplicationSetup."Penalty Batch Name");
                        IF GenJournalLine.FINDSET THEN BEGIN
                            GenJnlPostBatch.RUN(GenJournalLine);
                        end;
                        Commit();


                    end;

                end;
            }
            action("Reverse Wrong Penalties")
            {
                ApplicationArea = Basic, Suite;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                //  ToolTip = 'Request approval of the document.';
                Visible = false;
                trigger OnAction()
                var
                    custRec1: Record Customer;
                    cust: Record "Cust. Ledger Entry";
                    GLEntry: Record "G/L Entry";
                    ReversalEntry: Record "Reversal Entry";

                begin
                    custRec1.Reset();
                    custRec1.setfilter("Customer Posting Group", '%1', 'MB');
                    if custRec1.FindSet() then begin
                        repeat
                            cust.Reset();
                            cust.SetRange("Customer No.", custRec1."No.");
                            cust.SetRange("Transaction Type Code", 'PENDUE');
                            cust.SetFilter(Reversed, '%1', false);
                            cust.SetFilter("Posting Date", '%1..%2', 20240326D, Today);
                            if cust.FindSet() then begin
                                repeat
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Transaction No.", cust."Transaction No.");
                                    GLEntry.SetRange(Reversed, false);
                                    if GLEntry.FindSet() then begin
                                        repeat
                                            ReversalEntry.SetHideWarningDialogs();
                                            ReversalEntry.SetHideDialog(true);
                                            ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                                        until GLEntry.Next() = 0;
                                    end;
                                until cust.next() = 0;
                            end;
                        until custRec1.next = 0;
                    end;
                end;
            }


            action("Loan Collateral")
            {
                ApplicationArea = Basic, Suite;
                Image = Lock;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    LoanCollateral.FILTERGROUP(10);
                    LoanCollateral.SETRANGE("Loan No.", Rec."No.");
                    LoanCollateral.FILTERGROUP(0);
                    PAGE.RUN(50209, LoanCollateral);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var

    begin
        CurrPage.Editable(false);
    end;

    trigger OnAfterGetRecord()
    var
        GlobalM: Codeunit "Global Management";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        BosaM: Codeunit "BOSA Management";
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationCode: Code[100];
        ClassificationDesc: Text;
        ProvisioningPercent: Decimal;
        LRstrc: Record "Loan Restructuring";
    Begin
        LClassCode := '';
        PhoneNo := '';
        LastPDate := 0D;
        ArrearsAmount[1] := 0;
        ArrearsAmount[2] := 0;
        ArrearsAmount[3] := 0;
        ArrearsAmount[4] := 0;
        OverpaymentAmount[1] := 0;
        OverpaymentAmount[2] := 0;
        OverpaymentAmount[3] := 0;
        OverpaymentAmount[4] := 0;
        NoofDaysInArrears := 0;
        NoofInstallmentInArrears := 0;
        ClassificationDesc := '';

        CalcFields("Outstanding Balance");
        if "Outstanding Balance" > 0 then begin
            if "Loan Restructured" = true then begin
                "Economic Sector" := '0000';
                "Economic Sector Category" := '0000';
                "Economic Sector Sub-Category" := '0000';
                LRstrc.Reset();
                LRstrc.SetRange("Loan No.", "No.");
                LRstrc.SetRange(Status, LRstrc.Status::Approved);
                if LRstrc.FindLast() then begin
                    "Disbursal Date" := LRstrc."Approved Date";
                    "Next Due Date" := CalcDate('1M', LRstrc."Approved Date");
                    "Date of Completion" := CalcDate(LRstrc."New Repayment Period", LRstrc."Approved Date");
                    Modify();
                    BosaM.CreateRepaymentSchedule("No.", "Approved Amount");
                end;
            end;//
            GlobalM.CalculateLoanArrearsAndOverpaymentFactbox("No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
            "Principal Arrears" := ArrearsAmount[1];
            "Interest Arrears" := ArrearsAmount[2];
            "Ledger Fee Arrears" := ArrearsAmount[3];
            "Penalty Arrears" := ArrearsAmount[4];
            "Principal Overpayment" := OverpaymentAmount[1];
            "Interest Overpayment" := OverpaymentAmount[2];
            "Ledger Fee Overpayment" := OverpaymentAmount[3];
            "Penalty Overpayment" := OverpaymentAmount[4];
            "Total Arrears" := ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4];
            BosaM.CalculateDaysAndInstallmentsInArrearsDefaulter("No.", (ArrearsAmount[1] + ArrearsAmount[2]), NoofDaysInArrears, NoofInstallmentInArrears, Today);
            BosaM.GetClassificationClassDetails(NoofDaysInArrears, ClassificationCode, ClassificationDesc, ProvisioningPercent);
            "Days In Arrears" := NoofDaysInArrears;
            "Installment In Arrears" := NoofInstallmentInArrears;
            Classification := ClassificationDesc;

            Modify();
        end else begin
            if "Loan Restructured" = true then begin
                "Economic Sector" := '0000';
                "Economic Sector Category" := '0000';
                "Economic Sector Sub-Category" := '0000';
                LRstrc.Reset();
                LRstrc.SetRange("Loan No.", "No.");
                LRstrc.SetRange(Status, LRstrc.Status::Approved);
                if LRstrc.FindLast() then begin
                    "Disbursal Date" := LRstrc."Approved Date";
                    "Next Due Date" := CalcDate('1M', LRstrc."Approved Date");
                    "Date of Completion" := CalcDate(LRstrc."New Repayment Period", LRstrc."Approved Date");
                end;
            end;
            GlobalM.CalculateLoanArrearsAndOverpaymentFactbox("No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2], OverpaymentAmount[3], OverpaymentAmount[4]);
            "Principal Arrears" := 0;
            "Interest Arrears" := 0;
            "Ledger Fee Arrears" := 0;
            "Penalty Arrears" := 0;
            "Total Arrears" := 0;
            "Days In Arrears" := 0;
            "Installment In Arrears" := 0;
            Classification := '';
            "Principal Overpayment" := OverpaymentAmount[1];
            "Interest Overpayment" := OverpaymentAmount[2];
            "Ledger Fee Overpayment" := OverpaymentAmount[3];
            "Penalty Overpayment" := OverpaymentAmount[4];
            Modify();
        end;

        Dcust.Reset();
        Dcust.SetRange("Customer No.", "No.");
        Dcust.SetFilter("Credit Amount", '>%1', 0);
        if Dcust.FindLast() then begin
            LastPDate := Dcust."Posting Date";
        end;


        //LoanClass.Reset();
        //LoanClass.SetRange("Loan No.", "No.");
        //If LoanClass.FindFirst() then begin
        //LClassCode := LoanClass."Class Description";
        //ArrearsAmount := LoanClass."Total Arrears";
        // LastPDate := LoanClass."Last Payment Date";
        //end;
        if Memb.Get("Member No.") then
            PhoneNo := Memb."Phone No.";
    End;

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanCollateral: Record "Loan Collateral";
        LoanApp: Record "Loan Application";
        DateForm: DateFormula;
        LoanUpd: Record LoansUpdate;
        LoanProd: Record "Loan Product Type";
        LoanClass: Record "Loan Classification Entry";
        LClassCode: Code[100];
        ArrearsAmount: Decimal;
        LastPDate: Date;
        Dcust: Record "Detailed Cust. Ledg. Entry";
        PhoneNo: Code[50];
        Memb: Record Member;
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoanAccount: Integer;
        Text000: Label 'Processing Principal Transactions..\';
        Text001: Label 'Posting Date.   #1#############################\';
        Text002: Label 'Document No  #2#############################\';
        Text003: Label 'Loan No.     #3#############################\\';
        Text004: Label 'Processed Transactions  #4#############################\';
        Text005: Label 'Total Transactions  #5#############################\';
        Text006: Label 'Progress          @6@@@@@@@@@@@@@@@@@@@@@@@\';
    //LoanOffset: Record "50106";
}

