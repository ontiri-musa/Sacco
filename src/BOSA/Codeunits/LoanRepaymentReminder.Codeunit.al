codeunit 50005 "Loan Repayment Reminder"
{
    trigger OnRun()
    begin
        LoanApp.Reset();
        LoanApp.SetRange(Posted, true);

        if LoanApp.FindSet() then begin
            repeat
                LoanApp.CalcFields("Outstanding Balance");
                if LoanApp."Outstanding Balance" > 0 then begin
                    if LoanApp."Date of Completion" >= Today then begin
                        BosaM.SendLoanNotification(LoanApp);
                    end;
                    /*   if LoanApp."Date of Completion" <= Today then begin
                           //BosaM.SendExpiredLoanNotification(LoanApp);
                       end;*/


                end;
            until LoanApp.Next = 0;
        end;
    end;

    var
        LoanApp: Record "Loan Application";
        BosaM: Codeunit "BOSA Management";
}
