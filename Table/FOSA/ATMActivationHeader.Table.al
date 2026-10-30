table 50063 "ATM Activation Header"
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
            TableRelation = "ATM Member";

            trigger OnValidate()
            begin
                Member.GET("Member No.");
                "Member Name" := Member."Full Name";
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }

        field(6; "Current ATM Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Frozen';
            OptionMembers = Active,Frozen;
        }

        field(9; "Account No."; Code[30])
        {
            Editable = false;
        }
        field(11; "Account Name"; Text[50])
        {
            Editable = false;

        }
        field(12; "Card No."; Code[20])
        {
            TableRelation = "ATM Member" where("Member No." = field("Member No."));

            trigger OnValidate()
            begin
                IF ATMCard.GET("Card No.") THEN BEGIN
                    "Member No." := ATMCard."Member No.";
                    "Member Name" := ATMCard."Member Name";
                    "Account No." := ATMCard."Account No.";
                    "Account Name" := ATMCard."Account Name";
                    "Current ATM Status" := ATMCard.Status;
                END;
            end;
        }
        field(14; Description; Text[50])
        {
        }
        field(15; "Created Date"; Date)
        {
            Editable = false;
        }
        field(16; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(17; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(18; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
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
        ATMSetup.GET;
        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(ATMSetup."ATM Activation Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        "Created Date" := TODAY;
        "Created By" := USERID;
        Description := Text000 + "No.";
    end;

    var
        ATMSetup: Record "ATM Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text000: Label ' ATM Activation Request ';
        Member: Record Member;
        ATMCard: Record "ATM Member";
}

