codeunit 50017 "Clean Unused Record"
{
    trigger OnRun()
    begin
        CleanApprovalEntries();
        CleanCheckoff();
        // CleanMemberApplication();
        CleanLoanApplication();
    end;

    procedure CleanApprovalEntries()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset();
        If ApprovalEntry.FindSet() then begin
            repeat
                if (ApprovalEntry.Status = ApprovalEntry.Status::Open) and (ApprovalEntry."Due Date" < CalcDate('-2M', Today)) then
                    ApprovalEntry.Delete();
            until ApprovalEntry.Next = 0;
        end;
    end;

    procedure CleanCheckoff()
    var
        CheckoffH: Record "Checkoff Header";
        CheckoffL: Record "Checkoff Line";
    begin
        CheckoffH.Reset();
        CheckoffH.SetFilter("Created Date", '<%1', CalcDate('-2M', Today));
        CheckoffH.SetRange(Posted, false);
        If CheckoffH.FindSet() then begin
            repeat
                CheckoffL.Reset();
                CheckoffL.SetRange("Document No.", CheckoffH."No.");
                If CheckoffL.FindSet() then begin
                    CheckoffL.DeleteAll();
                end;
                CheckoffH.Delete();
            until CheckoffH.Next = 0;
        end;
    end;

    procedure CleanMemberApplication()
    var
        MemberApp: Record "Member Application";
        Beneficiary: Record "Beneficiary Type";
    begin
        MemberApp.Reset();
        MemberApp.SetFilter("Created Date", '<%1', CalcDate('-2M', Today));
        MemberApp.SetRange(Status, MemberApp.Status::New);
        If MemberApp.FindSet() then begin
            repeat
                Beneficiary.Reset();
                Beneficiary.SetRange("Application No.", MemberApp."No.");
                If Beneficiary.FindSet() then begin
                    Beneficiary.DeleteAll();
                end;
                MemberApp.Delete();
            until MemberApp.Next = 0;
        end;
    end;

    procedure CleanLoanApplication()
    var
        LoanApp: Record "Loan Application";
        LoanGuar: Record "Loan Guarantor";
        LoanSec: Record "Loan Collateral";
        LoanRefinance: Record "Loan Refinancing Entry";
        LoanRep: Record "Loan Repayment Schedule";
    begin
        LoanApp.Reset();
        LoanApp.SetFilter("Created Date", '<%1', CalcDate('-1M', Today));
        LoanApp.SetRange(Status, LoanApp.Status::New);
        If LoanApp.FindSet() then begin
            repeat
                LoanGuar.Reset();
                LoanGuar.SetRange("Loan No.", LoanApp."No.");
                If LoanGuar.FindSet() then begin
                    LoanGuar.DeleteAll();
                end;
                LoanSec.Reset();
                LoanSec.SetRange("Loan No.", LoanApp."No.");
                If LoanSec.FindSet() then begin
                    LoanSec.DeleteAll();
                end;
                LoanRefinance.Reset();
                LoanRefinance.SetRange("Loan No.", LoanApp."No.");
                If LoanRefinance.FindSet() then begin
                    LoanRefinance.DeleteAll();
                end;
                LoanRep.Reset();
                LoanRep.SetRange("Loan No.", LoanApp."No.");
                If LoanRep.FindSet() then begin
                    LoanRep.DeleteAll();
                end;
                LoanApp.Delete();
            until LoanApp.Next = 0;
        end;
    end;
}
