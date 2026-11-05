table 50092 "Agent Application"
{
    DataClassification = ToBeClassified;

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
            begin
                Member.GET("Member No.");
                "Member Name" := Member."Full Name";
                "Phone No." := Member."Phone No.";
                "National ID" := Member."National ID";
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                    Blocked = CONST(false))

            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor where("Member No." = field("Member No."))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";
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
        field(8; Location; Code[20])
        {

        }
        field(9; "Business Name"; Code[20])
        {

        }
        field(10; "Phone No."; Code[20])
        {

        }
        field(11; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(12; "No. Series"; Code[20])
        {
        }
        field(13; "Created Time"; Time)
        {
            Editable = false;
        }
        field(14; "Device Phone No."; Code[20])
        {

        }
        field(15; "Device Serial No."; Code[20])
        {

        }
        field(16; "Account Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("Account No.")));
            Editable = false;

        }
        field(17; "Agent Type"; Option)
        {
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
        field(18; "National ID"; Code[20])
        {

        }
        field(19; "Allow Withdrawal"; Boolean)
        {

        }
        field(20; "Allow Deposit"; Boolean)
        {

        }
        field(21; "Allow Ministatement"; Boolean)
        {

        }
        field(22; "Allow Airtime"; Boolean)
        {

        }
        field(23; "Allow Utility Services"; Boolean)
        {

        }
        FIELD(24; "Allow Balance Inquiry"; Boolean)
        {

        }
        field(26; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Vendor,Bank Account';
            OptionMembers = "G/L Account",Vendor,"Bank Account";
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }

    }


    trigger OnInsert()
    begin
        AgencyBankingSetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(AgencyBankingSetup."Agent Application Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Created By" := USERID;
        // "Created By Host IP" := HostIP;
        // "Created By Host MAC" := HostMac;
        // "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    trigger OnModify()
    begin
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        // "Last Modified By Host IP" := HostIP;
        // "Last Modified By Host MAC" := HostMac;
        // "Last Modified By Host Name" := HostName;
        // "Last Modified Date" := TODAY;
        // "Last Modified Time" := TIME;
        // "Last Modified By" := USERID;
    end;



    var
        Member: Record Member;
        Vendor: Record Vendor;
        AgencyBankingSetup: Record "Agency Banking Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        GlobalManagement: Codeunit "Global Management";

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}