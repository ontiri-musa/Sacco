table 59608 "Default Notification Header"
{

    fields
    {
        field(1; No; Code[10])
        {
            Editable = false;
        }
        field(25; "Member No"; Code[10])
        {
            TableRelation = Member;
        }
        field(30; "Loan No"; Code[30])
        {
            TableRelation = "Loan Application" WHERE("Member No." = FIELD("Member No"), "Outstanding Balance" = filter(> 0));
            trigger OnValidate()
            var
                defaultLine: Record "Default Notification Line";
                loanGuarantors: Record "Loan Guarantor";
            begin
                loanGuarantors.Reset();
                loanGuarantors.SetRange("Loan No.", "Loan No");
                if loanGuarantors.FindSet() then begin
                    repeat
                        defaultLine.Init();
                        defaultLine."Line No" := fnGetLastLineNo() + 1;
                        defaultLine."Document No" := No;
                        defaultLine."loan No" := "Loan No";
                        defaultLine."Member No" := loanGuarantors."Member No.";
                        defaultLine."Member Name" := loanGuarantors."Member No.";
                        defaultLine."Member Phone No" := fnGetPhoneNo(loanGuarantors."Member No.");
                        defaultLine.Insert();
                    until loanGuarantors.Next() = 0;
                end;
            end;
        }
        field(35; Stage; Option)
        {
            OptionCaption = ' ,Two Months,Three Months,Four Months';
            OptionMembers = " ","Two Months","Three Months","Four Months";
        }
        field(2; "SMS Date"; Date)
        {
        }
        field(3; "SMS Message"; Blob)
        {
        }
        field(22; "Created By"; Code[90])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(23; "SMS Sent"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if No = '' then
            notificationSetup.GET;
        No := NoSeriesManagement.GetNextNo(notificationSetup."Default SMS Nos", 0D, true);

        // "SMS Date" := TODAY;
        "Created By" := USERID;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        notificationSetup: Record "Loan Notification Setup";
        defaultLine: Record "Default Notification Line";
        member: Record Member;

    local procedure fnGetLastLineNo() lineNo: Integer

    begin
        defaultLine.Reset();
        if defaultLine.FindLast() then begin
            lineNo := defaultLine."Line No";
        end;
        exit(lineNo);

    end;

    local procedure fnGetPhoneNo(memberNo: Code[35]) phone: code[45]
    begin
        member.Reset();
        member.SetRange("No.", memberNo);
        if member.FindFirst() then
            phone := member."Phone No.";
        exit(phone);
    end;

    local procedure InsertMemb(DocNo: Code[10]);
    var
        Vehicles: Record "Vehicle Register";
        Memb: Record Member;
        //   BulKSMSLine: Record "Bulk SMS Line";
        LineNo: Integer;
    begin
        LineNo := 1000;

        Memb.RESET;
        Memb.SETFILTER("Phone No.", '<>%1', '');
        if Memb.FINDSET then begin
            repeat

                if StrLen(Memb."Phone No.") = 12 then begin
                    /*   BulKSMSLine.INIT;
                       BulKSMSLine."Document No" := DocNo;
                       BulKSMSLine."Line No" := LineNo;
                       BulKSMSLine."Member No" := Memb."No.";
                       BulKSMSLine."Member Name" := Memb."Full Name";
                       BulKSMSLine."Member Phone No" := Memb."Phone No.";
                       BulKSMSLine.INSERT;
                       LineNo += 1000;*/
                end;
            until Memb.NEXT = 0;
        end
    end;

    procedure SetSMSTemplate(NewSMSTemplate: Text);
    var
        OStream: OutStream;
        Memb: Record Member;
    begin
        CLEAR("SMS Message");
        IF NewSMSTemplate = '' THEN
            EXIT;
        "SMS Message".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewSMSTemplate);
        MODIFY;
    end;

    procedure GetSMSTemplate(): Text;
    var
        IStream: InStream;
        SMSText: Text;
    begin
        CALCFIELDS("SMS Message");
        IF NOT "SMS Message".HASVALUE THEN
            EXIT;
        "SMS Message".CREATEINSTREAM(IStream);
        IStream.READ(SMSText);
        EXIT(SMSText);
    end;
}

