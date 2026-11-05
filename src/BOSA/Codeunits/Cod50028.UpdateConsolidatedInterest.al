codeunit 50028 UpdateConsolidatedInterest
{

    trigger OnRun()
    begin
        RunConsolidatedInterest();
    end;

    procedure RunConsolidatedInterest()
    var
        "Loan Application": Record "Loan Application";
        LoanRepSch: Record "Loan Repayment Schedule";
        RunDate: Date;
        PostingDate: Date;
        Customer: Record Customer;
        GlobalManagement: Codeunit "Global Management";
        LoanApplicationSetup: Record "Loan Application Setup";
        LoanProdType: Record "Loan Product Type";
        BOSAManagement: Codeunit "BOSA Management";
        i: Date;
    begin
        RunDate := 0D;
        LoanApplicationSetup.Get();

        for i := 20230531D TO Today DO begin
            GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
            RunDate := i;
            PostingDate := i;
            "Loan Application".Reset();
            "Loan Application".SetRange("Loan Product Type", 'CON');
            "Loan Application".SetRange(Posted, true);
            "Loan Application".SetRange("Pause Loan Interest", false);
            If "Loan Application".FindSet() then begin
                repeat
                    LoanProdType.Get("Loan Application"."Loan Product Type");
                    "Loan Application"."Interest Rate" := LoanProdType."Interest Rate";
                    "Loan Application"."Loan Restructured" := false;
                    "Loan Application".Modify();
                    "Loan Application".CalcFields("Outstanding Balance");
                    if "Loan Application"."Outstanding Balance" > 0 then begin//
                        if "Loan Application"."Date of Completion" >= RunDate then begin
                            LoanRepSch.Reset();
                            LoanRepSch.SetRange("Loan No.", "Loan Application"."No.");
                            LoanRepSch.SetRange("Repayment Date", i);
                            if LoanRepSch.FindFirst() then begin
                                If Customer.Get("Loan Application"."No.") then begin
                                    BOSAManagement.CapitalizeInterest(Customer, RunDate, PostingDate);
                                end else begin
                                    BOSAManagement.CreateLoanAccount("Loan Application");
                                    if Customer.Get("Loan Application"."No.") then
                                        BOSAManagement.CapitalizeInterest(Customer, RunDate, PostingDate);
                                end;
                            end;
                        end;
                    end;
                until "Loan Application".Next = 0;
            end;
            GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
        end;
    end;
}
