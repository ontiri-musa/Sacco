codeunit 50025 "Update Reversed Checkoff"
{
    trigger OnRun()
    begin
        UpdateReversedCheckoff();
        UpdateReversedGLEntries();
    end;

    procedure UpdateReversedCheckoff()
    var
        CheckoffH: Record "Checkoff Header";
        CheckoffL: Record "Checkoff Line";
    begin
        CheckoffH.Reset();
        CheckoffH.SetFilter("Posted Date", '>=%1', CalcDate('-2M', Today));
        CheckoffH.SetRange(Posted, true);
        CheckoffH.SetRange(Reversed, true);
        If CheckoffH.FindSet() then begin
            repeat
                ReverseCheckoff(CheckoffH);
            until CheckoffH.Next = 0;
        end;
    end;

    procedure ReverseCheckoff(var CheckoffHeader: Record "Checkoff Header")
    var
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
    begin
        with CheckoffHeader do begin
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", "No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet() then begin
                repeat
                    ReversalEntry.SetHideWarningDialogs();
                    ReversalEntry.SetHideDialog(true);
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                until GLEntry.Next() = 0;
            end;
        end;
    end;

    procedure UpdateReversedGLEntries()
    var
        GLEntry: Record "G/L Entry";
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        GLEntry.Reset();
        GLEntry.SetFilter("Source No.", '<>%1', '');
        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer, GLEntry."Source Type"::Vendor);
        If GLEntry.FindSet() then begin
            repeat
                if GLEntry."Source Type" = GLEntry."Source Type"::Customer then begin
                    IF Cust.Get(GLEntry."Source No.") Then begin
                        IF GLEntry."Member No." <> Cust."Member No." then begin
                            GLEntry."Member No." := Cust."Member No.";
                            GLEntry.Modify();
                        end;
                    end;
                end;
                if GLEntry."Source Type" = GLEntry."Source Type"::Vendor then begin
                    IF Vend.Get(GLEntry."Source No.") then begin
                        IF GLEntry."Member No." <> Vend."Member No." then begin
                            GLEntry."Member No." := Vend."Member No.";
                            GLEntry.Modify();
                        end;
                    end;
                end;
            until GLEntry.Next = 0;
        end;
    end;
}
