table 50042 "Teller Transaction Header"
{
    // version TL2.0


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
        field(2; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction -Type" where("Application Area" = filter(Teller));
            trigger OnValidate()
            var

            begin
                ValidateTillLimit();

                TellerUserSetup.Get(UserId);
                TransactionType.Get("Transaction Type");
                if TransactionType."Application Area" = TransactionType."Application Area"::Teller then begin
                    if TransactionType.Type = TransactionType.Type::"Teller Cash Withdrawal" then begin
                        if not TellerUserSetup."Withdrawal Allowed" then
                            Error(WithdrawalNotAllowedErr);
                    end;
                    if TransactionType.Type = TransactionType.Type::"Teller Cash Deposit" then begin
                        if not TellerUserSetup."Deposit Allowed" then
                            Error(DepositNotAllowedErr);
                    end;
                end;
            end;
        }
        field(3; Description; Text[50])
        {

        }
        field(4; "Teller User ID"; Text[50])
        {
            Editable = false;
        }

        field(5; "Till Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Bank Account Ledger Entry".Amount where("Bank Account No." = field("Till No.")));
        }
        field(6; "Total Line Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Teller Transaction Line"."Line Amount" where("Transaction No." = field("No.")));

        }
        field(7; "No. Series"; Code[20])
        {
        }
        field(8; "Till No."; Code[20])
        {
            Editable = false;
            TableRelation = "Bank Account";
        }
        field(9; "Till Name"; Text[50])
        {
            Editable = false;
        }
        field(10; "Transaction Date"; Date)
        {
            //Editable = false;
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
        field(16; "Transaction Amount"; Decimal)
        {

        }
        field(20; "Teller Host IP"; Code[20])
        {
            Editable = false;
        }
        field(21; "Teller Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(22; "Teller Host Name"; Code[30])
        {
            Editable = false;
        }
        field(23; "Posted By"; Code[30])
        {
            Editable = false;
        }
        field(24; "Posted Date"; Date)
        {
            Editable = false;
        }
        field(25; "Posted Time"; Time)
        {
            Editable = false;
        }

    }
    local procedure PopulateCoinageSetup()
    var
        CoinageSetup: Record "Coinage Setup";
        TransactionCoinageSetup: Record "Transaction Coinage Setup";
        TransactionCoinageSetup2: Record "Transaction Coinage Setup";
        LineNo: Integer;
    begin
        if "Coinage Breakdown" then begin
            CoinageSetup.Reset();
            CoinageSetup.SetCurrentKey("Line No.");
            if CoinageSetup.FindSet() then begin
                repeat
                    TransactionCoinageSetup.Init();
                    TransactionCoinageSetup."Coinage Source" := TransactionCoinageSetup."Coinage Source"::Teller;
                    TransactionCoinageSetup."Transaction No." := "No.";
                    TransactionCoinageSetup2.Reset();
                    TransactionCoinageSetup2.SetRange("Transaction No.", "No.");
                    if TransactionCoinageSetup2.FindLast() then
                        LineNo := TransactionCoinageSetup2."Line No."
                    else
                        LineNo := 0;
                    TransactionCoinageSetup."Line No." := LineNo + 10000;
                    TransactionCoinageSetup."Coinage Code" := CoinageSetup.Code;
                    TransactionCoinageSetup."Coinage Value" := CoinageSetup.Value;
                    TransactionCoinageSetup.Insert();
                until CoinageSetup.Next() = 0;
            end;

        end else begin
            TransactionCoinageSetup.Reset();
            TransactionCoinageSetup.SetRange("Transaction No.", "No.");
            TransactionCoinageSetup.DeleteAll();
        end;

    end;

    procedure ValidateTellerTransaction()
    var
    begin
        TestField("Transaction Type");
        TestField(Description);
        CalcFields("Total Line Amount", "Total Coinage Amount");
        if "Transaction Amount" <> "Total Line Amount" then
            Error(HeaderAmountNotEqualConfirmMsg, FieldCaption("Total Line Amount"), FieldCaption("Transaction Amount"));

        if "Coinage Breakdown" then begin
            if "Total Coinage Amount" = 0 then
                Error(PopulateCoinageErr);
        end;

        TransactionType.Get("Transaction Type");
        if TransactionType."Application Area" = TransactionType."Application Area"::Teller then begin
            if TransactionType.Type = TransactionType.Type::"Teller Cash Withdrawal" then begin
                TellerUserSetup.Get("Teller User ID");
                if "Total Line Amount" > TellerUserSetup."Maximum Withdrawal" then
                    Error(ExceededWithdrawalLimitErr);
                if "Total Line Amount" > Abs("Till Balance") then
                    Error(ExceededTillBalanceErr);

            end;
            if TransactionType.Type = TransactionType.Type::"Teller Cash Deposit" then begin
                TellerUserSetup.Get("Teller User ID");
                if "Total Line Amount" > TellerUserSetup."Maximum Withdrawal" then
                    Error(ExceededDepositLimitErr);
            end;
        end;

    end;




    local procedure ValidateTeller()
    var

    begin
        if TellerUserSetup.get(UserId) then begin
            if not TellerUserSetup.Active then
                Error(TellerNotActivatedErr, UserId);
            BankAccount.get(TellerUserSetup."Till No.");
            "Till No." := TellerUserSetup."Till No.";
            "Till Name" := BankAccount.Name;
        end else
            Error(UserNotSetupAsTellerErr, UserId);

    end;

    local procedure ValidateTillLimit()
    var

    begin
        CalcFields("Till Balance");
        TellerUserSetup.get(UserId);
        if abs("Till Balance") >= TellerUserSetup."Till Maximum Amount" then begin
            if Confirm(TillExceededMaxLimitMsg, true) then
                TelleringTreasury.CreateTellerReturnToTreasury(Rec)
            else
                exit;
        end;
        if abs("Till Balance") <= TellerUserSetup."Till Minimum Amount" then begin
            if Confirm(TillBelowMinLimitMsg, true) then
                TelleringTreasury.CreateTellerRequestFromTreasury(Rec)
            else
                exit;
        end;
    end;

    trigger OnInsert()
    var

    begin
        TelleringSetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(TelleringSetup."Teller Transaction Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        GlobalManagement.GetHostInfo(HostName, HostMac, HostIP);

        "Teller Host IP" := HostIP;
        "Teller Host MAC" := HostMac;
        "Teller Host Name" := HostName;
        "Teller User ID" := UserId;
        "Transaction Date" := Today;
        "Transaction Time" := Time;

        ValidateTeller();
    end;

    trigger OnDelete()
    var
        myInt: Integer;
    begin
        DeleteRelatedLinks();
    end;

    local procedure DeleteRelatedLinks()
    var
        myInt: Integer;
    begin
        TellerTransactionLine.Reset();
        TellerTransactionLine.SetRange("Transaction No.", "No.");
        TellerTransactionLine.DeleteAll();

        TransactionCoinageSetup.Reset();
        TransactionCoinageSetup.SetRange("Transaction No.", "No.");
        TransactionCoinageSetup.DeleteAll();

        TellerMemberStatistic.Reset();
        TellerMemberStatistic.SetRange("Transaction No.", "No.");
        TellerMemberStatistic.DeleteAll();
    end;

    var
        TelleringSetup: Record "Tellering Setup";
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalManagement: Codeunit "Global Management";
        BankAccount: Record "Bank Account";
        TellerUserSetup: Record "Teller User Setup";
        TelleringTreasury: Codeunit "Tellering & Treasury";
        TransactionType: Record "Transaction -Type";
        PopulateCoinageErr: Label 'You must populate the Transaction Coinage section';
        ExceededWithdrawalLimitErr: Label 'You have exceeded the maximum withdrawal amount allowed for this Teller';
        ExceededDepositLimitErr: Label 'You have exceeded the maximum deposit amount allowed for this Teller';
        ExceededTillBalanceErr: Label 'You have exceeded Till balance';
        WithdrawalNotAllowedErr: Label 'Withdrawal service is not allowed for this Teller';
        DepositNotAllowedErr: Label 'Deposit service is not allowed for this Teller';

        TellerNotActivatedErr: Label 'Teller %1 is not active';
        UserNotSetupAsTellerErr: Label 'User %1 has not been setup as a Teller';
        TillExceededMaxLimitMsg: Label 'Till Balance has exceeded the Maximum Allowed Limit,\Do you wish to create a Return to Treasury request?';
        TillBelowMinLimitMsg: Label 'Till Balance has is below the  the Minimum Allowed Limit,\Do you wish to create a Request from Treasury?';
        HeaderAmountNotEqualConfirmMsg: Label '%1 and %2 must be equal';
        TellerTransactionLine: Record "Teller Transaction Line";
        TransactionCoinageSetup: Record "Transaction Coinage Setup";
        TellerMemberStatistic: Record "Teller Member Statistic";
}

