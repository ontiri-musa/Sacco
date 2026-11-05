table 50067 "Mobile Banking Application"
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
                MobileMemb: Record "Mobile Banking Member";
            begin
                Member.GET("Member No.");
                if Member.Status <> Member.Status::Active then
                    Error('Member is not active');

                "Member Name" := Member."Full Name";
                Member.TESTFIELD("Phone No.");

                If "Application Type" = "Application Type"::New then begin
                    MobileMemb.Reset();
                    MobileMemb.SetRange(MobileMemb."Member No.", "Member No.");
                    if MobileMemb.FindLast() then
                        Error(MemberExistErr, "Member No.");
                end else begin
                    MobileMemb.Reset();
                    MobileMemb.SetRange(MobileMemb."Member No.", "Member No.");
                    MobileMemb.SetRange(MobileMemb."Phone No.", Member."Phone No.");
                    if MobileMemb.FindLast() then begin
                        Error('Kindly change the member phone no first %1', Member."Phone No.");
                    end;
                end;

                MemberApplicationSetup.Get;
                if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"07XXXXXXXX" then begin
                    IF STRLEN(Member."Phone No.") > 10 THEN
                        ERROR(ExceedCharErr, 10);
                    IF STRLEN(Member."Phone No.") < 10 THEN
                        ERROR(NotLessThanCharErr, 10);
                end;
                if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"2547XXXXXXXX" then begin
                    IF STRLEN(Member."Phone No.") > 12 THEN
                        ERROR(ExceedCharErr, 12);
                    IF STRLEN(Member."Phone No.") < 12 THEN
                        ERROR(NotLessThanCharErr, 12, '254');
                end;
                "Phone No." := Member."Phone No.";

                If "Application Type" = "Application Type"::"Phone No Change" then begin
                    MobileMemb.Reset();
                    MobileMemb.SetRange(MobileMemb."Member No.", Member."No.");
                    if MobileMemb.FindLast() then
                        "Old Phone No." := MobileMemb."Phone No.";
                end;
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Account No."; Code[20])
        {
            // TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN
                    "Account Name" := Vendor.Name;
            end;
        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Created Date"; Date)
        {
            Editable = false;
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(8; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; "Phone No."; Code[20])
        {
            Editable = false;
        }
        field(11; "Service Type"; Option)
        {
            OptionCaption = 'Mobile Banking,Agency Banking';
            OptionMembers = "Mobile Banking","Agency Banking";
        }
        field(12; "SMS Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(13; "E-Mail Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(14; "Created Time"; Time)
        {
            Editable = false;
        }
        field(15; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(16; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(18; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(19; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(20; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(21; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(22; "Created By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(23; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(24; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(25; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(26; "Last Modified By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(27; "Last Modified By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(28; "Last Modified By Host MAC"; Code[30])
        {
            Editable = false;
        }

        field(30; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(31; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(32; "Updated On Portal"; Boolean)
        {
            Editable = false;
        }
        field(33; "Uploaded from Excel"; Boolean)
        {
            Editable = false;
        }
        field(34; "Application Type"; Option)
        {
            OptionCaption = 'New,Phone No Change';
            OptionMembers = New,"Phone No Change";
            trigger OnValidate()
            begin
                Clear("Member No.");
                Clear("Member Name");
                Clear("Phone No.");
                Clear("Old Phone No.");
            end;
        }
        field(35; "Old Phone No."; Code[20])
        {
            Editable = false;
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
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(MobileBankingSetup."Mobile Banking Appl. Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Created By" := USERID;
        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    trigger OnModify()
    begin
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Last Modified By Host IP" := HostIP;
        "Last Modified By Host MAC" := HostMac;
        "Last Modified By Host Name" := HostName;
        "Last Modified Date" := TODAY;
        "Last Modified Time" := TIME;
        "Last Modified By" := USERID;
    end;



    var
        Member: Record Member;
        Vendor: Record Vendor;
        MobileBankingSetup: Record "Mobile Banking Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        GlobalManagement: Codeunit "Global Management";
        MemberApplicationSetup: Record "Member Application Setup";
        ExceedCharErr: Label 'Phone No. cannot exceed %1 characters.';
        NotLessThanCharErr: Label 'Phone No. cannot be less than %1 characters. use pre fix %2.';
        MemberExistErr: Label 'Member %1 is already registered.';

}

