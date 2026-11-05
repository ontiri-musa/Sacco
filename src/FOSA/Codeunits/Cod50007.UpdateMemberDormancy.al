codeunit 50007 UpdateMemberDormancy
{
    trigger OnRun()
    var
        Member: Record Member;
        Member2: Record Member;
        Vend: Record Vendor;
        DVend: Record "Detailed Vendor Ledg. Entry";
        BosaM: Codeunit "BOSA Management";
        ChurchSection: Record "Church Section";
        ChurchDistrict: Record "Church District";
        Loans: Record "Loan Application";
    begin
        Member.Reset();
        if Member.FindSet() then begin
            repeat
                if (Member.Status = Member.Status::Active) or (Member.Status = Member.Status::Dormant) then begin
                    Member."Dormancy Status" := Member."Dormancy Status"::Active;
                    Member.Modify();

                    Vend.Reset();
                    Vend.SetRange(Vend."Member No.", Member."No.");
                    Vend.SetRange(Vend."Account Type", '02');
                    if Vend.FindFirst() then begin
                        Vend.Status := Vend.Status::Active;
                        Vend.Modify();

                        DVend.Reset();
                        DVend.SetCurrentKey("Posting Date");
                        DVend.SetRange(DVend."Vendor No.", Vend."No.");
                        DVend.SetFilter(DVend."Credit Amount", '>%1', 0);
                        If DVend.FindLast() then begin
                            if DVend."Posting Date" <= CalcDate('-3M', Today) then begin
                                Vend.Status := Vend.Status::Dormant;
                                Vend.Modify();
                            end;
                        end;

                        DVend.Reset();
                        DVend.SetCurrentKey("Posting Date");
                        DVend.SetRange(DVend."Vendor No.", Vend."No.");
                        DVend.SetFilter(DVend."Credit Amount", '>%1', 0);
                        If not DVend.FindLast() then begin
                            if CalcDate('-3M', Today) >= Member."Registration Date" then begin
                                Vend.Status := Vend.Status::Dormant;
                                Vend.Modify();
                            end;
                        end;

                        Member."Dormancy Status" := Vend.Status;
                        Member.Modify();
                    end;
                end else begin
                    if (Member.Status = Member.Status::Withdrawn) or (Member.Status = Member.Status::Deceased) or (Member.Status = Member.Status::Suspended) then begin
                        Vend.Reset();
                        Vend.SetRange(Vend."Member No.", Member."No.");
                        Vend.SetRange(Vend."Account Type", '02');
                        if Vend.FindFirst() then begin
                            Vend.Status := Vend.Status::Closed;
                            Vend.Modify();
                            Member."Dormancy Status" := Vend.Status;
                            Member.Modify();
                        end;
                    end;
                end;
                If ChurchSection.Get(Member."Church Section Code") then begin
                    If (ChurchSection."Church District Code" = 'KIAMBU EAST') or (ChurchSection."Church District Code" = 'KIAMBU WEST') then begin
                        If Member."Church District Code" <> ChurchSection."Church District Code" then begin
                            Member."Church District Code" := ChurchSection."Church District Code";
                            Member.Modify();
                            Loans.Reset();
                            Loans.SetRange("Member No.", Member."No.");
                            if Loans.FindSet() then begin
                                repeat
                                    Loans."Church District Code" := Member."Church District Code";
                                    Loans.Modify();
                                until Loans.Next = 0;
                            end;
                        end;
                    end;
                end;
            until Member.Next = 0;
        end;

        Member2.Reset();
        if Member2.FindSet() then begin
            repeat
                If Member2."Dormancy Status" = Member2."Dormancy Status"::Dormant then begin
                    if Today = CalcDate('4D', CalcDate('-CM', Today)) then begin
                        //if StrLen(Member2."Phone No.") <= 20 then
                        // BosaM.SendDormancyNotification(Member2);
                    end;
                end;
                If Member2."Dormancy Status" = Member2."Dormancy Status"::Active then begin
                    if Today = CalcDate('14D', CalcDate('-CM', Today)) then begin
                        Vend.Reset();
                        Vend.SetRange(Vend."Member No.", Member2."No.");
                        Vend.SetRange(Vend."Account Type", '02');
                        if Vend.FindFirst() then begin
                            DVend.Reset();
                            DVend.SetRange(DVend."Vendor No.", Vend."No.");
                            DVend.SetRange("Posting Date", CalcDate('-CM', Today), Today);
                            If not DVend.FindSet() then begin
                                // BosaM.SendNonSavingNotification(Member2);
                            end;
                        end;
                    end;
                End;
            until Member2.Next = 0;
        end;
    end;
}
