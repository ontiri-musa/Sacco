table 50007 "Member Activation Header"
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
        field(2; Description; Text[50])
        {
        }
        field(3; "Created Date"; Date)
        {
            Editable = false;
        }
        field(4; "Created By"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                Member.GET("Member No.");
                "Member Name" := Member."Full Name";
                "Current Member Status" := Member.Status;
                Description := StrSubstNo(Text000, "Member No.");
                GetMemberAccounts();
            end;
        }
        field(9; "Member Name"; Text[50])
        {
            Editable = false;
        }

        field(10; "Current Member Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(11; "Activation Type"; Option)
        {
            OptionMembers = Reactivation,Reinstatement;
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

        MemberActivationSetup.GET;
        MemberActivationSetup.TestField("Member Activation Nos.");
        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(MemberActivationSetup."Member Activation Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        "Created Date" := TODAY;
        "Created By" := USERID;

    end;

    local procedure GetMemberAccounts()
    var
        Vendor: Record Vendor;
        MemberActivationLine: Record "Member Activation Line";
        MemberActivationLine2: Record "Member Activation Line";
        LineNo: Integer;
    begin
        MemberActivationLine2.Reset();
        MemberActivationLine2.SetRange("Document No.", "No.");
        MemberActivationLine2.DeleteAll();

        Vendor.Reset();
        Vendor.SetRange("Member No.", "Member No.");
        if Vendor.FindSet() then begin
            repeat
                MemberActivationLine.Init();
                MemberActivationLine."Document No." := "No.";
                MemberActivationLine2.Reset();
                MemberActivationLine2.SetRange("Document No.", "No.");
                if MemberActivationLine2.FindLast() then
                    LineNo := MemberActivationLine2."Line No."
                else
                    LineNo := 0;
                MemberActivationLine."Line No." := LineNo + 10000;
                MemberActivationLine."Account Type" := MemberActivationLine."Account Type"::Vendor;
                MemberActivationLine.validate("Account No.", Vendor."No.");
                MemberActivationLine."Current Account Status" := Vendor.Status;
                MemberActivationLine.Insert();
            until Vendor.Next() = 0;
        end;
    end;

    var
        MemberActivationSetup: Record "Member Activation Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Member: Record "member";
        Text000: Label 'Member %1 Activation Request ';

}

