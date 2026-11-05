table 50047 "Treasury Transaction Header"
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
        field(4; "Created By"; Text[50])
        {
            Editable = false;
        }
        field(5; "Treasury Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Bank Account Ledger Entry".Amount where("Bank Account No." = field("Treasury Account No.")));
        }
        field(6; "Total Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Treasury Transaction Line"."Line Amount" where("Transaction No." = field("No.")));
        }
        field(7; "No. Series"; Code[20])
        {
        }
        field(8; "Treasury Account No."; Code[20])
        {
            TableRelation = "Bank Account";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if BankAccount.get("Treasury Account No.") then begin
                    "Treasury Account Name." := BankAccount.Name;
                end;

            end;
        }
        field(9; "Treasury Account Name."; Text[50])
        {
            TableRelation = "Bank Account";
        }
        field(10; "Transaction Date"; Date)
        {
            Editable = false;
        }
        field(11; "Transaction Time"; Time)
        {
            Editable = false;
        }
        field(12; "Total Coinage Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Transaction Coinage Setup"."Line Amount" where("Transaction No." = field("No.")));
        }
        field(13; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(14; "Coinage Breakdown"; Boolean)
        {
            trigger OnValidate()
            var

            begin
                PopulateCoinageSetup();
            end;
        }
        field(15; Posted; Boolean)
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



    }
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
                    TreasuryTransCoinageSetup."Coinage Source" := TreasuryTransCoinageSetup."Coinage Source"::Treasury;
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
            NoSeriesManagement.InitSeries(TreasurySetup."Treasury Transaction Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        GlobalManagement.GetHostInfo(HostName, HostMac, HostIP);

        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created By" := UserId;
        "Transaction Date" := Today;
        "Transaction Time" := Time;
        Description := 'Treasury Request'

    end;

    var
        TreasurySetup: Record "Treasury Setup";
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalManagement: Codeunit "Global Management";
        BankAccount: Record "Bank Account";



}