table 50043 "Teller Transaction Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Member No."))
            ELSE
            IF ("Account Type" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Member No."))
            ELSE
            IF ("Account Type" = FILTER("G/L Account")) "G/L Account" WHERE("Account Category" = filter(Income));
            trigger OnValidate()
            begin
                ValidateTransactionHeader;
                ValidateAccountType();
                ValidateAccountNo();
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN begin
                        "Account Name" := Vendor.Name;
                        // "Member No." := Vendor."Member No.";
                        // "Member Name" := Vendor."Member Name";
                    end;
                end;

                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN begin
                        "Account Name" := Customer.Name;
                        // "Member No." := Customer."Member No.";
                        // "Member Name" := Customer."Member Name";
                    end;
                END;
                IF "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
                    IF GLAccount.GET("Account No.") THEN begin
                        "Account Name" := GLAccount.Name;
                        // "Member No." := Customer."Member No.";
                        // "Member Name" := Customer."Member Name";
                    end;
                END;
            end;
        }
        field(4; "Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(5; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                ValidateAccountNo();
                ValidateTotalAmount();
            end;
        }
        field(7; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'Vendor,Customer,G/L Account';
            OptionMembers = Vendor,Customer,"G/L Account";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateTransactionHeader();
                ValidateAccountType();

            end;
        }
        field(8; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Member;
            trigger OnValidate()
            var

            begin
                ValidateTransactionHeader();
                "Account No." := '';
                "Account Name" := '';
                Member.GET("Member No.");
                "Member Name" := Member."Full Name";

                DeleteRelatedLinks(xRec."Member No.");
                CalculateMemberStatistics();

            end;


        }
        field(9; "Member Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }

    }

    keys
    {
        key(PK; "Transaction No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure ValidateTotalAmount()
    var
        myInt: Integer;
    begin
        TellerTransactionHeader.Get("Transaction No.");
        TellerTransactionHeader.CalcFields("Total Line Amount");
        TellerUserSetup.Get(TellerTransactionHeader."Teller User ID");
        if TellerTransactionHeader."Total Line Amount" + "Line Amount" >= TellerUserSetup."Withdrawal Limit (Approval)" then begin
            if Confirm(RequireApprovalConfirmMsg, true) then begin
                IF ApprovalsMgmt.CheckTellerTransactionApprovalPossible(TellerTransactionHeader) THEN begin
                    ApprovalsMgmt.OnSendTellerTransactionForApproval(TellerTransactionHeader);

                end;
            end else
                exit;
        end;
    end;

    local procedure ValidateTransactionHeader()
    var
        myInt: Integer;
    begin
        TellerTransactionHeader.Get("Transaction No.");
        TellerTransactionHeader.TestField("Transaction Amount");
        TellerTransactionHeader.TestField(Description);
        TellerTransactionHeader.TestField("Transaction Type");
    end;

    local procedure ValidateAccountType()
    var

        OptionValue: Text;
    begin

        OPtionValue := Format("Account Type");//GlobalManagement.GetOptionValues(50043, 7);

        TellerTransactionHeader.Get("Transaction No.");
        TransactionType.Get(TellerTransactionHeader."Transaction Type");
        case TransactionType.Type of
            TransactionType.Type::"Teller Cash Deposit":
                begin

                end;
            TransactionType.Type::"Teller Cash Withdrawal":
                begin
                    if (("Account Type" = "Account Type"::Customer) or ("Account Type" = "Account Type"::"G/L Account")) then
                        Error(ValidateAccountTypeErrMsg, OptionValue, TellerTransactionHeader."Transaction Type");
                end;
        end;
    end;

    local procedure ValidateAccountNo()
    var
        myInt: Integer;
    begin
        TestField("Member No.");
        TellerTransactionHeader.Get("Transaction No.");
        TransactionType.Get(TellerTransactionHeader."Transaction Type");
        case TransactionType.Type of
            TransactionType.Type::"Teller Cash Deposit":
                begin
                    if "Account Type" = "Account Type"::Vendor then begin
                        Vendor.get("Account No.");
                        AccountType.Get(Vendor."Account Type");

                        if not AccountType."Allow Deposit" then
                            Error(DepositNotAllowedErr);
                        if "Line Amount" > AccountType."Maximum Deposit Amount" then
                            Error(DepositExceededErr, FieldCaption("Line Amount"));
                    end;
                end;
            TransactionType.Type::"Teller Cash Withdrawal":
                begin
                    if "Account Type" = "Account Type"::Vendor then begin
                        Vendor.get("Account No.");
                        AccountType.Get(Vendor."Account Type");
                        if not AccountType."Allow Withdrawal" then
                            Error(WithdrawalNotAllowedErr);
                        if "Line Amount" > AccountType."Maximum Withdrawal Amount" then
                            Error(WithdrawalExceededErr, FieldCaption("Line Amount"));
                    end;
                end;

        end;
    end;

    procedure CalculateMemberStatistics()
    var
        i: Integer;
    begin
        i := 0;
        Customer.Reset();
        Customer.SetRange("Member No.", "Member No.");
        if Customer.FindSet() then begin
            repeat
                Customer.CalcFields("Balance (LCY)");
                CreateTellerMemberStatistics(Customer.Name, Customer."Balance (LCY)");
            until Customer.Next() = 0;
        end;

        AccountType.Reset();
        //AccountType.SetRange(Type, AccountType.Type::"Share Capital");
        if AccountType.FindSet() then begin
            repeat
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Member No.");
                Vendor.SetRange("Account Type", AccountType.Code);
                if Vendor.FindFirst() then begin
                    Vendor.CalcFields("Balance (LCY)");
                    CreateTellerMemberStatistics(Vendor.Name, abs(Vendor."Balance (LCY)"));
                end;
            until AccountType.Next() = 0
        end;
        TellerTransactionLine.Reset();
        TellerTransactionLine.SetRange("Account Type", TellerTransactionLine."Account Type"::"G/L Account");
        TellerTransactionLine.SetRange("Member No.", "Member No.");
        TellerTransactionLine.setrange("Account No.", '003');
        TellerTransactionLine.CalcSums("Line Amount");

        CreateTellerMemberStatistics('Service Charge', TellerTransactionLine."Line Amount")
    end;

    local procedure CreateTellerMemberStatistics(Description: Text[50]; Amount: Decimal)
    var
        TellerMemberStatistic2: Record "Teller Member Statistic";
        LineNo: Integer;
    begin
        TellerMemberStatistic.Init();
        TellerMemberStatistic2.Reset();
        TellerMemberStatistic2.SetRange("Transaction No.", "Transaction No.");
        if TellerMemberStatistic2.FindLast() then
            LineNo := TellerMemberStatistic2."Line No."
        else
            LineNo := 0;
        TellerMemberStatistic."Transaction No." := "Transaction No.";
        TellerMemberStatistic."Line No." := LineNo + 10000;
        TellerMemberStatistic."Member No." := "Member No.";
        TellerMemberStatistic.Description := Description;
        TellerMemberStatistic.Amount := Amount;
        TellerMemberStatistic.Insert();
    end;

    local procedure DeleteRelatedLinks(MemberNo: Code[20])
    var
        myInt: Integer;
    begin
        TellerMemberStatistic.Reset();
        TellerMemberStatistic.SetRange("Transaction No.", "Transaction No.");
        TellerMemberStatistic.SetRange("Member No.", MemberNo);
        TellerMemberStatistic.DeleteAll();
    end;

    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        Member: Record Member;
        TellerUserSetup: Record "Teller User Setup";
        TellerTransactionHeader: Record "Teller Transaction Header";
        RequireApprovalConfirmMsg: Label 'This transaction require approval, Do you wish to send for approval?';
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        TransactionType: Record "Transaction -Type";
        ValidateAccountTypeErrMsg: Label 'Option %1 is not allowed for Transaction Type %2';
        GlobalManagement: Codeunit "Global Management";
        AccountType: Record "Account Type";
        WithdrawalNotAllowedErr: Label 'Withdrawal is not allowed for this account';
        WithdrawalExceededErr: Label '%1 has exceeded the Maximum Withdrawal allowed';
        DepositNotAllowedErr: Label 'Deposit is not allowed for this account';
        DepositExceededErr: Label '%1 has  exceeded the Maximum Deposit allowed';
        TellerTransactionLine: Record "Teller Transaction Line";

        TellerMemberStatistic: Record "Teller Member Statistic";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        DeleteRelatedLinks("Member No.");
    end;

    trigger OnRename()
    begin

    end;

}