codeunit 50031 "Update Defaulter Loans"
{
    trigger OnRun()
    begin
        Loan.Reset();
        Loan.SetRange("Loan Product Type", 'DL');
        Loan.SetRange(Posted, true);
        if Loan.FindSet() then begin
            repeat
                CustL.Reset();
                CustL.SetRange("Customer No.", Loan."No.");
                CustL.SetRange(Reversed, false);
                if CustL.FindSet() then begin
                    if CustL.Count = 1 then begin
                        CustL2.Reset();
                        CustL2.SetRange("Customer No.", Loan."No.");
                        CustL2.SetRange(Reversed, false);
                        if CustL2.FindFirst() then begin
                            ReversalEntry.SetHideWarningDialogs();
                            ReversalEntry.SetHideDialog(true);
                            ReversalEntry.ReverseTransaction(CustL2."Transaction No.");
                        end;
                        Loan.Status := Loan.Status::New;
                        Loan.Posted := false;
                        Loan.Modify();
                    end else begin
                        if CustL.Count > 1 then begin
                            CustL2.Reset();
                            CustL2.SetRange("Customer No.", Loan."No.");
                            CustL2.SetRange(Reversed, false);
                            if CustL2.FindFirst() then begin
                                CustL4.Reset();
                                CustL4.SetRange("Transaction No.", CustL2."Transaction No.");
                                CustL4.SetFilter("Customer No.", '<>%1', CustL2."Customer No.");
                                If CustL4.FindFirst() then begin
                                    CustL3.Reset();
                                    CustL3.SetRange("Customer No.", Loan."No.");
                                    CustL3.SetFilter("Entry No.", '<>%1', CustL2."Entry No.");
                                    if CustL3.FindSet() then begin
                                        repeat
                                            CustL3."Customer No." := CustL4."Customer No.";
                                            CustL3.Modify();

                                            DCustL.Reset();
                                            DCustL.SetRange("Cust. Ledger Entry No.", CustL3."Entry No.");
                                            if DCustL.FindSet() then begin
                                                repeat
                                                    DCustL."Customer No." := CustL3."Customer No.";
                                                    DCustL.Modify();
                                                until DCustL.Next() = 0;
                                            end;
                                        until CustL3.Next() = 0;
                                    end;
                                    ReversalEntry.SetHideWarningDialogs();
                                    ReversalEntry.SetHideDialog(true);
                                    ReversalEntry.ReverseTransaction(CustL2."Transaction No.");
                                end;
                            end;
                            Loan.Status := Loan.Status::New;
                            Loan.Posted := false;
                            Loan.Modify();
                        end;
                    end;
                end;
            until Loan.Next() = 0;
        end;
    end;

    var
        Loan: Record "Loan Application";
        CustL: Record "Cust. Ledger Entry";
        CustL2: Record "Cust. Ledger Entry";
        CustL3: Record "Cust. Ledger Entry";
        CustL4: Record "Cust. Ledger Entry";
        DCustL: Record "Detailed Cust. Ledg. Entry";
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";

}
