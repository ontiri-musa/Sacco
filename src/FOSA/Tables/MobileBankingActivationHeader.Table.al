table 50070 "Mobile Banking Activ. Header"
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
        field(3; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                MobileBankingMember.Reset();
                MobileBankingMember.SetRange("Member No.", Rec."Member No.");
                if not MobileBankingMember.FindFirst() then begin
                    Error('Member is not registered for mobile banking');
                end else begin
                    "Member Name" := MobileBankingMember."Member Name";
                end;
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Current Member Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Frozen';
            OptionMembers = Active,Frozen;
        }
        field(7; "New Member Status"; Option)
        {
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(9; "Account No."; Code[30])
        {
        }
        field(11; "Account Name"; Text[50])
        {
        }
        field(12; "Phone No."; Code[20])
        {
            TableRelation = "Mobile Banking Member" where("Member No." = field("Member No."));
        }
        field(13; Description; Text[50])
        {
        }
        field(14; "Created Date"; Date)
        {
            Editable = false;
        }
        field(15; "Created By"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(16; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(17; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Application Option"; Option)
        {
            OptionCaption = 'Activation,Deactivation';
            OptionMembers = Activation,Deactivation;
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
        MobileBankingSetup.GET;
        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(MobileBankingSetup."Mobile Banking Activation Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        "Created Date" := TODAY;
        "Created By" := USERID;
        If "Application Option" = "Application Option"::Activation then
            Description := Text000 + "No."
        else
            Description := Text001 + "No.";
    end;

    var
        MobileBankingSetup: Record "Mobile Banking Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text000: Label 'Mobile Banking Activation Request ';
        Text001: Label 'Mobile Banking Deactivation Request ';
        MobileBankingMember: Record "Mobile Banking Member";
}

