table 50058 "Treasury Return Bank Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(3; Description; Text[50])
        {

        }
        field(5; "Total Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Treasury Transaction Line"."Line Amount" where("Transaction No." = field("No.")));
        }
        field(6; "Bank Account Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Bank Account Ledger Entry".Amount where("Bank Account No." = field("Bank Account No.")));

        }
        field(7; "No. Series"; Code[20])
        {
        }
        field(8; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account" where("Account Type" = filter("Bank Account"));
            trigger OnValidate()
            var

            begin
                BankAccount.Get("Bank Account No.");
                "Bank Account Name" := BankAccount.Name;
            end;
        }
        field(9; "Bank Account Name"; Text[50])
        {
            Editable = false;

        }
        field(10; "Transaction Date"; Date)
        {
            Editable = false;
        }
        field(11; "Transaction Time"; Time)
        {
            Editable = false;
        }
        field(13; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(15; Posted; Boolean)
        {
            Editable = false;
        }
        field(16; "Created By"; Text[50])
        {
            Editable = false;
        }
        field(20; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(21; "Created By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(22; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(23; "Total Coinage Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Transaction Coinage Setup"."Line Amount" where("Transaction No." = field("No.")));
        }
        field(24; "Coinage Breakdown"; Boolean)
        {
            trigger OnValidate()
            var

            begin
                PopulateCoinageSetup();
            end;
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        BankAccount: Record "Bank Account";
        TreasurySetup: Record "Treasury Setup";
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalManagement: Codeunit "Global Management";


    local procedure PopulateCoinageSetup()
    var
        CoinageSetup: Record "Coinage Setup";
        TreasuryTransCoinageSetup: Record "Transaction Coinage Setup";
        TreasuryTransCoinageSetup2: Record "Transaction Coinage Setup";
        LineNo: Integer;
    begin
        if "Coinage Breakdown" then begin
            CoinageSetup.Reset();
            CoinageSetup.SetCurrentKey("Line No.");
            if CoinageSetup.FindSet() then begin
                repeat
                    TreasuryTransCoinageSetup.Init();
                    TreasuryTransCoinageSetup."Coinage Source" := TreasuryTransCoinageSetup."Coinage Source"::"Treasury Return Bank";
                    TreasuryTransCoinageSetup."Transaction No." := "No.";
                    TreasuryTransCoinageSetup2.Reset();
                    TreasuryTransCoinageSetup2.SetRange("Transaction No.", "No.");
                    if TreasuryTransCoinageSetup2.FindLast() then
                        LineNo := TreasuryTransCoinageSetup2."Line No."
                    else
                        LineNo := 0;
                    TreasuryTransCoinageSetup."Line No." := LineNo + 10000;
                    TreasuryTransCoinageSetup."Coinage Code" := CoinageSetup.Code;
                    TreasuryTransCoinageSetup."Coinage Value" := CoinageSetup.Value;
                    TreasuryTransCoinageSetup.Insert();
                until CoinageSetup.Next() = 0;
            end;

        end else begin
            TreasuryTransCoinageSetup.Reset();
            TreasuryTransCoinageSetup.SetRange("Transaction No.", "No.");
            TreasuryTransCoinageSetup.DeleteAll();
        end;

    end;

    trigger OnInsert()
    var

    begin
        TreasurySetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(TreasurySetup."Treasury Return Bank Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        GlobalManagement.GetHostInfo(HostName, HostMac, HostIP);

        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created By" := UserId;
        "Transaction Date" := Today;
        "Transaction Time" := Time;
        Description := 'Treasury Return Bank'

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}