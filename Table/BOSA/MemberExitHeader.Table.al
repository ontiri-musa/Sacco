table 50113 "Member Exit Header"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            var
                ExSetup: Record "Exit Fee";
            begin
                DeleteRelatedLinks;
                DeleteExitLines;

                ExSetup.Reset();
                ExSetup.SetRange("Earning Party", ExSetup."Earning Party"::Sacco);
                if ExSetup.FindSet() then begin
                    repeat

                    until ExSetup.Next = 0;
                end;
                "Exit Fee" := 500;
                GetMemberAccounts("Member No.");
                //GetGuaranteedAccounts("Member No.");

                Member.GET("Member No.");
                "Member Name" := Member."Full Name";
                Description := STRSUBSTNO(Text000, "Member Name");
                "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
            end;
        }
        field(3; "Member Name"; Text[250])
        {
            Editable = false;
        }
        field(4; Description; Text[250])
        {
            Editable = false;
        }
        field(8; "Reason Code"; Code[10])
        {
            TableRelation = "Exit Reason";

            trigger OnValidate()
            begin
                IF ExitReason.GET("Reason Code") THEN
                    "Reason for Exit" := ExitReason.Description;
            end;
        }
        field(9; "Reason for Exit"; Text[50])
        {
            Editable = false;
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(15; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
            Editable = false;
        }
        field(16; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(18; "Created Date"; Date)
        {
            Editable = false;
        }
        field(19; "Created Time"; Time)
        {
            Editable = false;
        }
        field(22; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(23; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(24; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(25; Remarks; Text[50])
        {
        }
        field(26; "Total Outstanding Loan"; Decimal)
        {
            Editable = false;
        }
        field(27; "Member Deposits"; Decimal)
        {
            Editable = false;
        }
        field(28; "Boresha Savings"; Decimal)
        {
            Editable = false;
        }
        field(29; "Next Gen Savings"; Decimal)
        {
            Editable = false;
        }
        field(30; "Paying Bank"; Code[50])
        {
            TableRelation = "Bank Account";
            trigger OnValidate()
            var
                Bank: Record "Bank Account";
            begin
                if Bank.GET("Paying Bank") then
                    "Paying Bank Name" := Bank.Name;
            end;
        }
        field(31; "Paying Bank Name"; Text[100])
        {
            Editable = false;
        }
        field(32; "Payee Name"; Text[100])
        {

        }
        field(33; "Total Deductions"; Decimal)
        {
            Editable = false;
        }
        field(34; "Net Payment"; Decimal)
        {
            Editable = false;
        }
        field(35; "Gross Payment"; Decimal)
        {
            Editable = false;
        }
        field(36; "Exit Fee"; Decimal)
        {
            trigger OnValidate()
            begin
                "Total Deductions" := "Total Outstanding Loan" + "Exit Fee";
                "Net Payment" := "Gross Payment" - "Total Deductions";
            end;
        }
        field(37; "Cheque No"; Text[50])
        {

        }
        field(38; "Payment Date"; Date)
        {

        }
        field(39; "Posted"; Boolean)
        {

        }
        field(40; "Posted By"; Code[100])
        {

        }
        field(41; "Date Posted"; Date)
        {

        }
        field(42; "Time Posted"; Time)
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ExitSetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(ExitSetup."Member Exit Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        Vendor: Record Vendor;
        ExitSetup: Record "Exit Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Member: Record Member;
        Customer: Record "Customer";
        ExitReason: Record "Exit Reason";
        Text000: Label 'Exit request for %1';

    procedure GetMemberAccounts(MemberNo: Code[20])
    var
        MemberExitLine: Record "Member Exit Line";
        Vendor: Record Vendor;
        AccType: Record "Account Type";
    begin
        IF MemberExitLine.GET("No.", 0) THEN
            MemberExitLine.DELETE;

        Vendor.RESET;
        Vendor.SETRANGE("Member No.", MemberNo);
        IF Vendor.FINDSET THEN BEGIN
            REPEAT
                Vendor.CALCFIELDS("Balance (LCY)");
                /*IF Vendor."Balance (LCY)" <> 0 THEN BEGIN
                    MemberExitLine.INIT;
                    MemberExitLine."Document No." := "No.";
                    MemberExitLine."Line No." := GetLastLineNo + 10000;
                    MemberExitLine."Account Category" := MemberExitLine."Account Category"::Vendor;
                    MemberExitLine."Account Type" := Vendor."Account Type";
                    MemberExitLine.VALIDATE("Account No.", Vendor."No.");
                    MemberExitLine."Account Ownership" := MemberExitLine."Account Ownership"::Self;
                    MemberExitLine.INSERT;
                END;*/
                If AccType.Get(Vendor."Account Type") then begin
                    if AccType.Type = AccType.Type::"Member Deposit" then
                        "Member Deposits" := Vendor."Balance (LCY)";
                    if (AccType.Type = AccType.Type::Savings) and (AccType."Sub Type" = AccType."Sub Type"::Boresha) then
                        "Boresha Savings" := Vendor."Balance (LCY)";
                    if (AccType.Type = AccType.Type::Savings) and (AccType."Sub Type" = AccType."Sub Type"::NXTGen) then
                        "Next Gen Savings" := Vendor."Balance (LCY)";
                end;
            UNTIL Vendor.NEXT = 0;
        END;
        "Gross Payment" := "Member Deposits" + "Boresha Savings" + "Next Gen Savings";
        If "Exit Fee" > "Gross Payment" then
            "Exit Fee" := "Gross Payment";

        Customer.RESET;
        Customer.SETRANGE("Member No.", MemberNo);
        IF Customer.FINDSET THEN BEGIN
            REPEAT
                Customer.CALCFIELDS(Balance);
                /*IF Customer."Balance (LCY)" <> 0 THEN BEGIN
                    MemberExitLine.INIT;
                    MemberExitLine."Document No." := "No.";
                    MemberExitLine."Line No." := GetLastLineNo + 10000;
                    MemberExitLine."Account Category" := MemberExitLine."Account Category"::Customer;
                    MemberExitLine."Account Type" := Customer."Loan Product Type";
                    MemberExitLine.VALIDATE("Account No.", Customer."No.");
                    MemberExitLine."Account Ownership" := MemberExitLine."Account Ownership"::Self;
                    MemberExitLine.INSERT;
                END;*/
                If Customer.Balance <> 0 then
                    "Total Outstanding Loan" += Customer.Balance;
            UNTIL Customer.NEXT = 0;
        END;
        "Total Deductions" := "Total Outstanding Loan" + "Exit Fee";
        "Net Payment" := "Gross Payment" - "Total Deductions";
    end;

    procedure GetGuaranteedAccounts(MemberNo: Code[20])
    var
        LoanGuarantor: Record "Loan Guarantor";
        MemberExitLine: Record "Member Exit Line";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Member No.", MemberNo);
        IF LoanGuarantor.FINDSET THEN BEGIN
            REPEAT
                MemberExitLine.INIT;
                MemberExitLine."Document No." := "No.";
                MemberExitLine."Line No." := GetLastLineNo + 10000;
                IF Customer.GET(LoanGuarantor."Loan No.") THEN;
                MemberExitLine."Account Category" := MemberExitLine."Account Category"::Customer;
                MemberExitLine."Account Type" := Customer."Loan Product Type";
                MemberExitLine."Account No." := LoanGuarantor."Loan No.";
                MemberExitLine.VALIDATE("Account No.");
                MemberExitLine."Account Ownership" := MemberExitLine."Account Ownership"::Guaranteed;
                MemberExitLine."Account Balance" := LoanGuarantor."Account Balance";
                MemberExitLine.INSERT;
            UNTIL LoanGuarantor.NEXT = 0;
        END;
    end;

    local procedure DeleteRelatedLinks()
    var
        MemberExitLine: Record "Member Exit Line";
    begin
        MemberExitLine.RESET;
        MemberExitLine.SETRANGE("Document No.", "No.");
        MemberExitLine.DELETEALL;
    end;

    local procedure DeleteExitLines()
    var
        MemberExitLine: Record "Member Exit Line";
    begin
        MemberExitLine.RESET;
        MemberExitLine.SETRANGE("Document No.", "No.");
        MemberExitLine.DELETEALL;
    end;

    local procedure GetLastLineNo(): Integer
    var
        MemberExitLine: Record "Member Exit Line";
        LineNo: Integer;
    begin
        MemberExitLine.RESET;
        MemberExitLine.SETRANGE("Document No.", "No.");
        IF MemberExitLine.FINDLAST THEN
            LineNo := MemberExitLine."Line No."
        ELSE
            LineNo := 0;
        EXIT(LineNo);
    end;
}

