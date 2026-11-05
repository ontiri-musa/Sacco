codeunit 50001 "FOSA Management"
{
    trigger OnRun()
    begin

    end;

    var
        GlobalSetup: Record "Global Setup";
        CTSSetup: Record "CTS Setup";
        MicrocreditSetup: Record "Microcredit Setup";
        Vendor: Record Vendor;
        GenJournalLine: Record "Gen. Journal Line";
        InsufficientAccBalErr: Label 'Insufficient Account Balance';
        AccountType: Record "Account Type";
        ReasonCode: Code[10];
        Indicator: Code[10];
        CCReasonCode: Record "CC Reason Code";
        GLAccount: array[8] of Code[20];
        SmsTextMsg: Label 'Dear Member, Your Cheque No. %1 has been cleared successfully. Your Account No. %2 %3 has been debited with KES %4';
        SourceCodeSetup: Record "Source Code Setup";
        SMTPMailSetup: record "SMTP Mail Setup";
        AccountOpeningSetup: Record "Account Opening Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalManagement: Codeunit "Global Management";
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        MemberApplicationSetup: Record "Member Application Setup";

    procedure CreateMember(var MemberApplication: Record "Member Application")
    var
        Member: Record Member;

        MemberNo: Code[20];
        Member2: Record Member;
        MemberApplicationSetup: Record "Member Application Setup";
        RecRef: RecordRef;
    begin
        with MemberApplication do begin
            if MicrocreditSetup.GET then;
            MemberApplicationSetup.Get();
            If (MemberApplication."Age Classification" = MemberApplication."Age Classification"::Junior) then begin
                MemberNo := NoSeriesManagement.GetNextNo(MemberApplicationSetup."Junior Member Nos.", TODAY, TRUE);
                MemberNo := MemberApplication."Parent Member No." + '-' + MemberNo;
                MemberApplication.Category := MemberApplication.Category::Individual;
                MemberApplication.Modify();
            end else begin
                If MemberApplicationSetup."Member No. Format" = MemberApplicationSetup."Member No. Format"::"No. Series Only" then
                    MemberNo := NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);
                If MemberApplicationSetup."Member No. Format" = MemberApplicationSetup."Member No. Format"::"Branch Code+No. Series" then
                    MemberNo := "Global Dimension 1 Code" + NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);
            end;
            Member.TRANSFERFIELDS(MemberApplication);
            Member."No." := MemberNo;

            If Category = Category::Individual then begin
                Member2.Reset();
                Member2.SetRange("Application No.", "Group Link No.");
                If Member2.FindFirst() then
                    Member."Group Link No." := Member2."No.";
            end;
            //if Category = Category::Group then
            //Member."Group Paybill Code" := NoSeriesManagement.GetNextNo(MicrocreditSetup."Group Paybill Nos.", TODAY, TRUE);

            /*  MemberApplication.Picture.EXPORTFILE(GlobalSetup."Image Path Local Directory" + MemberNo + 'PIC.jpg');
             Member."Picture Path" := GlobalSetup."Image Path IP Address" + MemberNo + 'PIC.jpg';

             MemberApplication."Front ID".EXPORTFILE(GlobalSetup."Image Path Local Directory" + MemberNo + 'FID.jpg');
             Member."Front ID Path" := GlobalSetup."Image Path IP Address" + MemberNo + 'FID.jpg';

             MemberApplication."Back ID".EXPORTFILE(GlobalSetup."Image Path Local Directory" + MemberNo + 'BID.jpg');
             Member."Back ID Path" := GlobalSetup."Image Path IP Address" + MemberNo + 'BID.jpg';

             MemberApplication.Signature.EXPORTFILE(GlobalSetup."Image Path Local Directory" + MemberNo + 'SIG.jpg');
             Member."Signature Path" := GlobalSetup."Image Path IP Address" + MemberNo + 'SIG.jpg'; */

            Member."Application No." := MemberApplication."No.";
            Member."Approval Date" := Today;
            Member."Approved Time" := Time;
            Member."Approved By" := UserId;
            Member.Status := Member.Status::Active;
            If Member.INSERT then
                CreateDefaultAccount(Member);

            RecRef.GetTable(Member);
            SendNotification(RecRef);

            CapitalizeRegistrationFee(Member);
        end;
    end;

    procedure CreateDefaultAccount(var Member: Record Member)
    var
        AccountType: Record "Account Type";
        GlobalSetup: Record "Global Setup";
        AccountNo: Code[20];
        Customer: Record Customer;
        Vendor: Record Vendor;
        AccountOpeningSetup: Record "Account Opening Setup";

    begin
        with Member do begin
            AccountOpeningSetup.Get();
            AccountType.RESET;
            AccountType.SETRANGE("Open Automatically", TRUE);
            /* if Member.Category = Member.Category::Individual then begin
                AccountType.SetFilter("Applies to Member Category", '%1&&%2', AccountType."Applies to Member Category"::Individual, AccountType."Applies to Member Category"::All);

                if Member."Age Classification" = Member."Age Classification"::Adult then
                    AccountType.SetFilter("Applies to Age Class", '%1&&%2', AccountType."Applies to Age Class"::Adult, AccountType."Applies to Age Class"::Both)
                else
                    if Member."Age Classification" = Member."Age Classification"::Junior then
                        AccountType.SetFilter("Applies to Age Class", '%1&&%2', AccountType."Applies to Age Class"::Junior, AccountType."Applies to Age Class"::Both);
            end;
            if Member.Category = Member.Category::Group then
                AccountType.SetFilter("Applies to Member Category", '%1&&%2', AccountType."Applies to Member Category"::Group, AccountType."Applies to Member Category"::All);

            if Member.Category = Member.Category::Company then
                AccountType.SetFilter("Applies to Member Category", '%1&&%2', AccountType."Applies to Member Category"::Company, AccountType."Applies to Member Category"::All);

            if Member.Category = Member.Category::Joint then
                AccountType.SetFilter("Applies to Member Category", '%1&&%2', AccountType."Applies to Member Category"::Joint, AccountType."Applies to Member Category"::All); */

            If AccountType.FINDSET then begin
                REPEAT
                    If AccountOpeningSetup."Account No. Format" = AccountOpeningSetup."Account No. Format"::"No. Series Only" then
                        AccountNo := NoSeriesManagement.GetNextNo(AccountOpeningSetup."Account Opening Nos.", TODAY, TRUE);

                    If AccountOpeningSetup."Account No. Format" = AccountOpeningSetup."Account No. Format"::"Member No.+Account Type" then
                        AccountNo := "No." + AccountType.Code;
                    Vendor.Reset();
                    Vendor.SetRange("No.", AccountNo);
                    if not Vendor.FindFirst() then begin
                        Vendor.INIT;
                        Vendor."No." := AccountNo;
                        Vendor.Name := AccountType.Description;
                        Vendor."Vendor Posting Group" := AccountType."Posting Group";
                        Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        Vendor."Phone No." := "Phone No.";
                        Vendor."E-Mail" := "E-mail";
                        Vendor."Account Type" := AccountType.Code;
                        Vendor."Member No." := "No.";
                        Vendor.Status := Vendor.Status::Active;
                        Vendor."Member Name" := "Full Name";
                        Vendor."Vendor Type" := Vendor."Vendor Type"::FOSA;
                        Vendor.INSERT;
                    end;
                UNTIL AccountType.NEXT = 0;
            end;
        end;
    end;

    procedure CreateBoardMemberAccount(var Member: Record Member)
    var
        AccountType: Record "Account Type";
        GlobalSetup: Record "Global Setup";
        AccountNo: Code[20];
        Customer: Record Customer;
        Vendor: Record Vendor;
        AccountOpeningSetup: Record "Account Opening Setup";

    begin
        with Member do begin
            AccountOpeningSetup.Get();
            AccountType.RESET;
            AccountType.SETRANGE(Type, AccountType.Type::Board);
            If AccountType.FindFirst() then begin
                If AccountOpeningSetup."Account No. Format" = AccountOpeningSetup."Account No. Format"::"No. Series Only" then
                    AccountNo := NoSeriesManagement.GetNextNo(AccountOpeningSetup."Account Opening Nos.", TODAY, TRUE);

                If AccountOpeningSetup."Account No. Format" = AccountOpeningSetup."Account No. Format"::"Member No.+Account Type" then
                    AccountNo := "No." + AccountType.Code;

                Vendor.INIT;
                Vendor."No." := AccountNo;
                Vendor.Name := "Full Name";
                Vendor."Vendor Posting Group" := AccountType."Posting Group";
                Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Vendor."Phone No." := "Phone No.";
                Vendor."E-Mail" := "E-mail";
                Vendor."Account Type" := AccountType.Code;
                Vendor."Member No." := "No.";
                Vendor.Status := Vendor.Status::Active;
                Vendor."Member Name" := "Full Name";
                Vendor."Vendor Type" := Vendor."Vendor Type"::Normal;
                Vendor.INSERT;
            end;
        end;
    end;

    procedure CreateAccount(var AccountOpening: Record "Account Opening")
    var
        Member: Record Member;
        AccountType: Record "Account Type";
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        with AccountOpening do begin
            Member.GET("Member No.");
            If AccountType.GET("Account Type") then begin
                Vendor.INIT;
                Vendor."No." := "Account No.";
                Vendor.Name := Description;
                Vendor."Vendor Posting Group" := AccountType."Posting Group";
                Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Vendor."Phone No." := Member."Phone No.";
                Vendor."E-Mail" := Member."E-mail";
                Vendor."Account Type" := "Account Type";
                Vendor."Member No." := "Member No.";
                Vendor."Member Name" := "Member Name";
                Vendor."Vendor Type" := Vendor."Vendor Type"::"FOSA";
                Vendor.Status := Vendor.Status::Active;
                Vendor.INSERT;
            end;
        end;
    end;

    procedure CreateMobileBankingMember(var MobileBankingAplication: Record "Mobile Banking Application")
    var
        MobileBankingMember: Record "Mobile Banking Member";
    begin
        with MobileBankingAplication do begin
            if MobileBankingAplication."Application Type" = MobileBankingAplication."Application Type"::"Phone No Change" then begin
                MobileBankingMember.Reset();
                MobileBankingMember.SetRange("Phone No.", MobileBankingAplication."Old Phone No.");
                If MobileBankingMember.FindFirst() then begin
                    MobileBankingMember.Status := MobileBankingMember.Status::Inactive;
                    MobileBankingMember.Modify();
                end;
            end;
            MobileBankingMember.Init();
            MobileBankingMember."Member No." := "Member No.";
            MobileBankingMember."Member Name" := "Member Name";
            MobileBankingMember."Account No." := "Account No.";
            MobileBankingMember."Account Name" := "Account Name";
            MobileBankingMember."Phone No." := "Phone No.";
            MobileBankingMember.Status := MobileBankingMember.Status::Active;
            MobileBankingMember."Service Type" := "Service Type";
            MobileBankingMember."Created By" := "Created By";
            MobileBankingMember."Created Date" := Today;
            MobileBankingMember."Created Time" := Time;
            MobileBankingMember."Created By Host IP" := "Created By Host IP";
            MobileBankingMember."Created By Host MAC" := "Created By Host MAC";
            MobileBankingMember."Created By Host Name" := "Created By Host Name";
            GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
            MobileBankingMember."Approved By Host IP" := HostIP;
            MobileBankingMember."Approved By Host MAC" := HostMac;
            MobileBankingMember."Approved By Host Name" := HostName;
            MobileBankingMember.Insert();
        end;
    end;

    procedure CreateATMMember(var ATMCollection: Record "ATM Collection")
    var
        ATMMember: Record "ATM Member";
        ATMApplication: Record "ATM Application";
    begin
        with ATMCollection do begin
            ATMMember.Init();
            ATMMember."Card No." := "Card No.";
            ATMMember."Member No." := "Member No.";
            ATMMember."Member Name" := "Member Name";
            ATMMember."Account No." := "Account No.";
            ATMMember."Account Name" := "Account Name";
            ATMMember.Status := ATMMember.Status::Active;
            IF ATMApplication.Get("Application No.") THEN begin
                ATMMember."SMS Alert on" := ATMApplication."SMS Alert on";
                ATMApplication."E-Mail Alert on" := ATMApplication."E-Mail Alert on";
            END;
            ATMMember."Application No." := "Application No.";
            ATMMember."Collection No." := "No.";
            ATMMember.Insert();
        end;
    end;

    procedure CreateAgent(var AgentApplication: Record "Agent Application")
    var
        Agent: Record Agent;
    begin
        with AgentApplication do begin
            Agent."No." := '';
            Agent."Member No." := "Member No.";
            Agent."Member Name" := "Member Name";
            Agent."Account No." := "Account No.";
            Agent."Account Name" := "Account Name";
            Agent."National ID" := "National ID";
            Agent."Device Phone No." := "Device Phone No.";
            Agent."Device Serial No." := "Device Serial No.";
            Agent.Location := Location;
            Agent."Business Name" := "Business Name";
            Agent."Phone No." := "Phone No.";
            Agent."Agent Type" := "Agent Type";
            Agent."Allow Withdrawal" := "Allow Withdrawal";
            Agent."Allow Deposit" := "Allow Deposit";
            Agent."Allow Airtime" := "Allow Airtime";
            Agent."Allow Balance Inquiry" := "Allow Balance Inquiry";
            Agent."Allow Ministatement" := "Allow Ministatement";
            Agent."Allow Utility Services" := "Allow Utility Services";
            Agent.Insert(true);
        end;
    end;


    procedure PostChequeBook(var ChequeBookApplication: Record "Cheque Book Application")
    var
        ChequeBook: Record "Cheque Book";
        AccountBalance: Decimal;
        ExciseDuty: Decimal;
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        WITH ChequeBookApplication DO BEGIN
            GlobalSetup.Get();
            SourceCodeSetup.Get();
            CTSSetup.Get();
            GlobalManagement.ClearJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name");
            IF CTSSetup."Charge Excise Duty" then
                ExciseDuty := GlobalSetup."Excise Duty %" / 100 * (CTSSetup."Charges Per Leaf" * "No. of Leaves");
            AccountBalance := GetAccountBalance("Account No.") - GetMinimumBalance("Account No.");
            IF AccountBalance >= (CTSSetup."Charges Per Leaf" * "No. of Leaves") THEN BEGIN
                /* GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor, "Account No.", Description + '-Charges',
                               (CTSSetup."Charges Per Leaf" * "No. of Leaves"), '', '', SourceCodeSetup.CTS, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                 GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account", CTSSetup."Charges G/L Account", Description + '-Charges',
                               -(CTSSetup."Charges Per Leaf" * "No. of Leaves"), '', '', SourceCodeSetup.CTS, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                 */
                AccountBalance -= (CTSSetup."Charges Per Leaf" * "No. of Leaves");

                /* IF AccountBalance>=ExciseDuty THEN BEGIN
                   GlobalManagement.CreateJournal(GlobalSetup."Cheque Template Name",GlobalSetup."Cheque Batch Name","No.","No.",TODAY,GenJournalLine."Account Type"::Vendor,"Account No.",Description+'-Excise Duty',
                                 ExciseDuty,0,"Global Dimension 1 Code");
                   GlobalManagement.CreateJournal(GlobalSetup."Cheque Template Name",GlobalSetup."Cheque Batch Name","No.","No.",TODAY,GenJournalLine."Account Type"::"G/L Account",GlobalSetup."Excise Duty G/L Account",Description+'-Excise Duty',
                                 -ExciseDuty,0,"Global Dimension 1 Code");
                 END ELSE
                   CreateCTSEntry(ChequeClearanceLine,'Cheque Book Excise Duty',3,ExciseDuty);*/

            END ELSE
                ERROR(InsufficientAccBalErr);

            CLEARLASTERROR;
            IF GlobalManagement.PostJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name") THEN BEGIN
                ChequeBook.GET("Cheque Book No.");
                ChequeBook.Status := ChequeBook.Status::Issued;
                ChequeBook."Issued By" := USERID;
                ChequeBook."Issued Date" := TODAY;
                ChequeBook."Issued Time" := TIME;
                ChequeBook.MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;

    end;

    procedure FlagChequeBook(var ChequeBookApplication: Record "Cheque Book Application")
    var
        ChequeBook: Record "Cheque Book";
    begin
        with ChequeBookApplication do begin
            ChequeBook.Reset();
            ChequeBook.SetRange("No.", "Cheque Book No.");
            IF ChequeBook.FindFirst() THEN begin
                ChequeBook.Status := ChequeBook.Status::Issued;
                ChequeBook.Modify();
            END;
        end;
    end;

    local procedure GetReasonCode(AccountNo: Code[20]; Amount: Decimal)
    begin
        Vendor.RESET;
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Vendor.Status = Vendor.Status::Active THEN BEGIN
                ReasonCode := '';
                Indicator := 'PAID';
            END ELSE BEGIN
                IF Vendor.Status = Vendor.Status::Dormant THEN BEGIN
                    ReasonCode := '64';
                    Indicator := 'UNPAID';
                END ELSE
                    IF Vendor.Status = Vendor.Status::Closed THEN BEGIN
                        ReasonCode := '74';
                        Indicator := 'UNPAID';
                    END ELSE
                        IF Vendor.Status = Vendor.Status::Frozen THEN BEGIN
                            ReasonCode := '77';
                            Indicator := 'UNPAID';
                        END ELSE BEGIN
                            ReasonCode := '77';
                            Indicator := 'UNPAID';
                        END;
            END;
            IF (GetAccountBalance(AccountNo) - Amount) < GetMinimumBalance(AccountNo) THEN BEGIN
                ReasonCode := '63';
                Indicator := 'UNPAID';
            END;
        END ELSE BEGIN
            ReasonCode := '69';
            Indicator := 'UNPAID';
        END;
    end;

    local procedure GetAccountNo(MemberNo: Code[20]): Code[20]
    var
        ChequeBook: Record "Cheque Book";
    begin
        ChequeBook.RESET;
        ChequeBook.SETRANGE("Member No.", MemberNo);
        ChequeBook.SETRANGE(Status, ChequeBook.Status::Issued);
        ChequeBook.SETRANGE(Active, TRUE);
        IF ChequeBook.FINDLAST THEN
            EXIT(ChequeBook."Account No.");
    end;

    local procedure GetAccountBalance(AccountNo: Code[20]) AccountBalance: Decimal
    begin
        Vendor.RESET;
        IF Vendor.GET(AccountNo) THEN BEGIN
            Vendor.CALCFIELDS("Balance (LCY)");
            AccountBalance := Vendor."Balance (LCY)";
            EXIT(AccountBalance);
        END;
    end;

    local procedure GetMinimumBalance(AccountNo: Code[20]) MinimumBalance: Decimal
    var
        AccountType: Record "Account Type";
    begin
        Vendor.RESET;
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF AccountType.GET(Vendor."Account Type") THEN
                MinimumBalance := AccountType."Minimum Balance";
            EXIT(MinimumBalance);
        END;
    end;

    procedure ValidatePRMEntry(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        ChequeClearanceLine.RESET;
        ChequeClearanceLine.SETRANGE("Document No.", ChequeClearanceHeader."No.");
        ChequeClearanceLine.SetRange(Select, true);
        IF ChequeClearanceLine.FINDSET THEN BEGIN
            REPEAT
                ChequeClearanceLine.TESTFIELD("Member No.");
                GetReasonCode(GetAccountNo(ChequeClearanceLine."Member No."), ChequeClearanceLine.Amount);
                ChequeClearanceLine."Unpaid Code" := ReasonCode;
                ChequeClearanceLine.VALIDATE("Unpaid Code");
                ChequeClearanceLine.Indicator := Indicator;
                ChequeClearanceLine.Validated := TRUE;
                ChequeClearanceLine.MODIFY;
            UNTIL ChequeClearanceLine.NEXT = 0;
        END;
    end;

    procedure PostChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
        Amount: array[8] of Decimal;
        AccountBalance: Decimal;
        CTSEntry: Record "CTS Entry";
        Member: Record Member;
        Vendor2: Record Vendor;
        SMSText: Text;
        AccountNo: Code[20];
        PhoneNo: Code[20];
        PhoneNoTxt: Text;
    begin
        WITH ChequeClearanceHeader DO BEGIN
            GlobalSetup.GET;
            CTSSetup.Get();
            SourceCodeSetup.Get();
            GlobalManagement.ClearJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name");
            ChequeClearanceLine.RESET;
            ChequeClearanceLine.SETRANGE("Document No.", "No.");
            ChequeClearanceLine.SetRange(Select, true);
            IF ChequeClearanceLine.FINDSET THEN BEGIN
                REPEAT
                    IF ChequeClearanceLine.Indicator = 'PAID' THEN BEGIN
                        ChequeClearanceLine.TESTFIELD("Member No.");
                        ChequeClearanceLine.TESTFIELD(Description);
                        /*
                                                AccountNo := GetAccountNo(ChequeClearanceLine."Member No.");
                                                GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                              AccountNo, 'Cheque Clearance', ChequeClearanceLine.Amount, '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                                              CTSSetup."Cheque Clearance Account", 'Cheque Clearance', -ChequeClearanceLine.Amount, '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                AccountBalance := GetAccountBalance(GetAccountNo(ChequeClearanceLine."Member No.")) - (GetMinimumBalance(GetAccountNo(ChequeClearanceLine."Member No.")) + ChequeClearanceLine.Amount);

                                                IF AccountBalance >= CTSSetup."Clearance Charges" THEN BEGIN
                                                    GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                                  AccountNo, 'Cheque Clearance Charges', CTSSetup."Clearance Charges", '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                    GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                                                  CTSSetup."Commission G/L Account", 'Cheque Clearance Charges', -CTSSetup."Clearance Charges", '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                    AccountBalance -= CTSSetup."Clearance Charges";
                                                END ELSE
                                                    CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Charges', 0, CTSSetup."Clearance Charges");

                                                Amount[2] := GlobalSetup."Excise Duty %" / 100 * CTSSetup."Clearance Charges";

                                                IF AccountBalance >= Amount[2] THEN BEGIN
                                                    GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                                  AccountNo, 'Cheque Clearance Excise Duty', Amount[2], '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                    GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                                                  GlobalSetup."Excise Duty G/L Account", 'Cheque Clearance Excise Duty', -Amount[2], '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                    AccountBalance -= Amount[2];
                                                END ELSE
                                                    CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Excise Duty', 3, Amount[2]);

                                                IF AccountBalance >= CTSSetup."SMS Charges" THEN BEGIN
                                                    GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                                  AccountNo, 'Cheque Clearance SMS Charges', CTSSetup."SMS Charges", '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                    GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                                                  CTSSetup."SMS G/L Account", 'Cheque Clearance SMS Charges', -CTSSetup."SMS Charges", '', '', SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                                                END ELSE
                                                    CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance SMS Charges', 2, CTSSetup."SMS Charges");
                        */
                        //Send SMS
                        Vendor2.GET(AccountNo);
                        Member.GET(ChequeClearanceLine."Member No.");
                        PhoneNo := Member."Phone No.";



                        PhoneNoTxt := FORMAT(PhoneNo);
                        SMSText := STRSUBSTNO(SmsTextMsg, ChequeClearanceLine."Serial No.", ChequeClearanceLine."Account No.", Vendor2.Name, ChequeClearanceLine.Amount);
                        // SendSms.Send(PhoneNoTxt, SMSText);
                    END ELSE BEGIN
                        IF CCReasonCode.GET(ChequeClearanceLine."Unpaid Code") THEN
                            Amount[1] := CCReasonCode."Charge Amount"
                        ELSE
                            Amount[1] := 0;

                        CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Penalty Charges', 1, Amount[1]);
                        CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Excise Duty on Penalty', 3, Amount[1] * GlobalSetup."Excise Duty %" / 100);
                    END;
                UNTIL ChequeClearanceLine.NEXT = 0;
            END;

            CLEARLASTERROR;
            IF GlobalManagement.PostJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name") THEN BEGIN
                Posted := TRUE;
                "Cleared By" := USERID;
                "Cleared Date" := TODAY;
                "Cleared Time" := TIME;
                IF MODIFY THEN
                    UpdateNextLeaf(ChequeClearanceHeader);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure CreateCTSEntry(var ChequeClearanceLine: Record "Cheque Clearance Line"; Description2: Text[50]; TransactionType: Integer; AmountToPay: Decimal)
    var
        CTSEntry: Record "CTS Entry";
        CTSEntry2: Record "CTS Entry";
        EntryNo: Integer;
        ChequeClearanceHeader: Record "Cheque Clearance Header";
    begin
        WITH ChequeClearanceLine DO BEGIN
            GlobalSetup.GET;
            ChequeClearanceHeader.GET("Document No.");
            CTSEntry.INIT;
            IF CTSEntry2.FINDLAST THEN
                EntryNo := CTSEntry2."Entry No."
            ELSE
                EntryNo := 0;
            CTSEntry."Entry No." := EntryNo + 1;
            CTSEntry."Document No." := ChequeClearanceHeader."No.";
            CTSEntry."Clearance Date" := ChequeClearanceHeader."Created Date";
            CTSEntry."Cheque No." := "Serial No.";
            CTSEntry."Member No." := "Member No.";
            CTSEntry."Member Name" := "Member Name";
            CTSEntry."Account No." := "Account No.";
            CTSEntry."Account Name" := "Account Name";
            CTSEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
            CTSEntry.Description := Description2;
            CTSEntry."Amount To Pay" := AmountToPay;
            CTSEntry."Unpaid Code" := "Unpaid Code";
            CTSEntry."Unpaid Reason" := "Unpaid Reason";
            IF TransactionType = 0 THEN
                CTSEntry."G/L Account" := CTSSetup."Commission G/L Account";
            IF TransactionType = 1 THEN
                CTSEntry."G/L Account" := CTSSetup."Penalty G/L Account";
            IF TransactionType = 2 THEN
                CTSEntry."G/L Account" := CTSSetup."SMS G/L Account";
            IF TransactionType = 3 THEN
                CTSEntry."G/L Account" := GlobalSetup."Excise Duty G/L Account";
            IF CTSEntry."Amount To Pay" <> 0 THEN
                CTSEntry.INSERT;
        END;
    end;

    local procedure UpdateNextLeaf(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
        ChequeBook: Record "Cheque Book";
        LastLeafUsed: Integer;
    begin
        WITH ChequeClearanceHeader DO BEGIN
            ChequeClearanceLine.RESET;
            ChequeClearanceLine.SETRANGE("Document No.", "No.");
            ChequeClearanceLine.SetRange(Select, true);
            IF ChequeClearanceLine.FINDSET THEN BEGIN
                REPEAT
                    ChequeBook.RESET;
                    ChequeBook.SETRANGE("Member No.", ChequeClearanceLine."Member No.");
                    ChequeBook.SETRANGE(Status, ChequeBook.Status::Issued);
                    IF ChequeBook.FINDFIRST THEN BEGIN
                        //EVALUATE(LastLeafUsed,ChequeBook."Last Leaf Used");
                        IF ChequeBook."Last Leaf Used" <> '' then
                            ChequeBook."Last Leaf Used" := INCSTR(ChequeBook."Last Leaf Used")
                        else
                            ChequeBook."Last Leaf Used" := ChequeBook."Start Leaf No.";
                        ChequeBook.MODIFY;

                        /* IF ChequeBook."End Leaf No."=ChequeBook."Last Leaf Used" THEN BEGIN
                           CreateChequeBook(ChequeBook."Member No.");
                           ChequeBook.Active:=FALSE;
                           ChequeBook.MODIFY;
                         END;*/
                    END;
                UNTIL ChequeClearanceLine.NEXT = 0;
            END;
        END;

    end;

    procedure RecoverUnpaidCTSEntries(var CTSEntry: Record "CTS Entry")
    var
        AccountBalance: Decimal;
    begin
        WITH CTSEntry DO BEGIN
            CTSSetup.GET;
            AccountBalance := GetAccountBalance("Account No.") - GetMinimumBalance("Account No.");
            IF AccountBalance >= "Amount To Pay" THEN BEGIN
                /* GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "Document No.", "Document No.", TODAY, GenJournalLine."Account Type"::Vendor,
                               "Account No.", Description, "Amount To Pay", '', '', SourceCodeSetup.CTS, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                 GlobalManagement.CreateJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name", "Document No.", "Document No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                               "G/L Account", Description, -"Amount To Pay", '', '', SourceCodeSetup.CTS, "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                 */
                AccountBalance -= "Amount To Pay";
            END;
            IF GlobalManagement.PostJournal(CTSSetup."Cheque Template Name", CTSSetup."Cheque Batch Name") THEN BEGIN
                Paid := TRUE;
                "Paid Date" := TODAY;
                "Paid Time" := TIME;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;


    procedure SendNotification(var RecRef: RecordRef)
    var
        MemberApplicationSetup: Record "Member Application Setup";
        AccountOpeningSetup: Record "Account Opening Setup";
        MemberApplication: Record "Member Application";
        AccountOpening: Record "Account Opening";
        SMSText: BigText;
        SMSText2: BigText;
        EmailText: BigText;
        EmailText2: BigText;
        FldRef: FieldRef;
        Member: Record Member;
        Vendor: Record Vendor;
    begin
        SMTPMailSetup.GET;
        SourceCodeSetup.Get();
        CASE RecRef.NUMBER OF
            DATABASE::"Member Application":
                BEGIN
                    RecRef.SETTABLE(MemberApplication);
                    MemberApplicationSetup.Get();
                    SourceCodeSetup.TestField("Member Application");
                    IF MemberApplicationSetup."Notify Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        MemberApplicationSetup.TestField("SMS Template (PendingApprov)");
                        MemberApplicationSetup.TestField("SMS Template (Approved)");
                        MemberApplicationSetup.TestField("SMS Template (Additional)");
                        MemberApplicationSetup.TestField("Email Template (PendingApprov)");
                        MemberApplicationSetup.TestField("Email Template (Approved)");
                        MemberApplicationSetup.TestField("Email Template (Additional)");

                        if MemberApplication.Status = MemberApplication.Status::"Pending Approval" then begin
                            IF ((MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::Email) OR (MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(MemberApplicationSetup."Email Template (PendingApprov)", MemberApplication."No.", MemberApplication."Full Name", 0));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::SMS) OR (MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(MemberApplicationSetup."SMS Template (PendingApprov)", MemberApplication."No.", MemberApplication."Full Name", 0));

                                GlobalManagement.CreateSMSEntry(MemberApplication."Phone No.", SMSText, SourceCodeSetup."Member Application");
                            END;
                        end;
                    END;
                END;
            DATABASE::Member:
                BEGIN
                    RecRef.SETTABLE(Member);
                    MemberApplicationSetup.Get();
                    SourceCodeSetup.TestField("Member Application");
                    IF MemberApplicationSetup."Notify Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);

                        IF ((MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::Email) OR (MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(MemberApplicationSetup."Email Template (Approved)", Member."No."));
                            EmailText2.ADDTEXT(STRSUBSTNO(MemberApplicationSetup."Email Template (Additional)"));

                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::SMS) OR (MemberApplicationSetup."Notification Channel" = MemberApplicationSetup."Notification Channel"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(MemberApplicationSetup."SMS Template (Approved)", Member."No."));
                            SMSText2.ADDTEXT(STRSUBSTNO(MemberApplicationSetup."SMS Template (Additional)", Member."No."));

                            GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Member Application");
                            GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText2, SourceCodeSetup."Member Application");
                        END;
                    END;
                END;
            DATABASE::"Account Opening":
                BEGIN
                    RecRef.SETTABLE(AccountOpening);
                    Member.Get(AccountOpening."Member No.");
                    AccountOpeningSetup.Get();
                    SourceCodeSetup.TestField("Account Opening");
                    IF AccountOpeningSetup."Notify Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        AccountOpeningSetup.TestField("SMS Template (PendingApprov)");
                        AccountOpeningSetup.TestField("SMS Template (Approved)");
                        AccountOpeningSetup.TestField("SMS Template (Additional)");
                        AccountOpeningSetup.TestField("Email Template (PendingApprov)");
                        AccountOpeningSetup.TestField("Email Template (Approved)");
                        AccountOpeningSetup.TestField("Email Template (Additional)");

                        if AccountOpening.Status = AccountOpening.Status::"Pending Approval" then begin
                            IF ((AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::Email) OR (AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::Both)) THEN BEGIN
                                EmailText.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."Email Template (PendingApprov)", AccountOpening.Description));
                                EmailText2.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."Email Template (Additional)", AccountOpening.Description));
                                //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                //SMTPMail.Send;
                            END;
                            IF ((AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::SMS) OR (AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::Both)) THEN BEGIN
                                SMSText.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."SMS Template (PendingApprov)", AccountOpening."Member Name", AccountOpening.Description));
                                // SMSText2.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."SMS Template (Additional)", AccountOpening.Description));

                                GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Account Opening");
                                //GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText2, SourceCodeSetup."Account Opening");
                            END;
                        end else
                            if AccountOpening.Status = AccountOpening.Status::Approved then begin
                                Vendor.Reset();

                                IF ((AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::Email) OR (AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::Both)) THEN BEGIN
                                    EmailText.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."Email Template (PendingApprov)", AccountOpening.Description, AccountOpening."No."));
                                    EmailText2.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."Email Template (Additional)", AccountOpening.Description, AccountOpening."No."));

                                    //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                    //SMTPMail.Send;
                                END;
                                IF ((AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::SMS) OR (AccountOpeningSetup."Notification Channel" = AccountOpeningSetup."Notification Channel"::Both)) THEN BEGIN
                                    SMSText.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."SMS Template (Approved)", AccountOpening."Member Name", AccountOpening.Description));
                                    //SMSText2.ADDTEXT(STRSUBSTNO(AccountOpeningSetup."SMS Template (Additional)", AccountOpening."No.", AccountOpening.Description));

                                    GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Account Opening");
                                    // GlobalManagement.CreateSMSEntry(Member."Phone No.", SMSText2, SourceCodeSetup."Account Opening");
                                END;
                            end;
                    END;
                END;
        end;
    end;

    local procedure PopulateFixedCallDepositSchedule(AccountOpening: Record "Account Opening"; NextDueDate: Date; InterestToEarn: Decimal)
    var
        FixedCallDepositSchedule: Record "Fixed/Call Deposit Schedule";
        FixedCallDepositSchedule2: Record "Fixed/Call Deposit Schedule";
        LineNo: Integer;
    begin
        with AccountOpening do begin

            FixedCallDepositSchedule.Init();
            FixedCallDepositSchedule."FD Account No." := "Account No.";
            FixedCallDepositSchedule2.Reset();
            FixedCallDepositSchedule2.SetRange("Account Opening No.", "No.");
            if FixedCallDepositSchedule2.FindLast() then
                LineNo := FixedCallDepositSchedule2."Line No."
            else
                LineNo := 0;
            FixedCallDepositSchedule."Line No." := LineNo + 10000;
            FixedCallDepositSchedule."Fixed Deposit Amount" := "Fixed Deposit Amount";
            FixedCallDepositSchedule."Interest Rate" := "Interest Rate";
            FixedCallDepositSchedule."Start Date" := "Start Date";
            FixedCallDepositSchedule."Maturity Date" := "Maturity Date";
            FixedCallDepositSchedule."Fixed Period" := "Fixed Period";
            FixedCallDepositSchedule."Capitalization Frequency" := "Capitalization Frequency";
            FixedCallDepositSchedule."Source FOSA Account" := "Source FOSA Account";
            FixedCallDepositSchedule."Maturity FOSA Account" := "Maturity FOSA Account";
            FixedCallDepositSchedule."Next Due Date" := NextDueDate;
            FixedCallDepositSchedule."Interest To Earn" := InterestToEarn;
            FixedCallDepositSchedule."Account Opening No." := "No.";
            FixedCallDepositSchedule."Member No." := "Member No.";
            FixedCallDepositSchedule.Status := FixedCallDepositSchedule.Status::"To Earn";
            FixedCallDepositSchedule.Insert();
        end;
    end;

    procedure CreateFixedCallDepositSchedule(AccountOpening: Record "Account Opening")
    var
        PeriodCount: array[10] of Integer;
        NoofPeriods: Integer;
        i: Integer;
        NextDueDate: Date;
        PeriodDateFormula: DateFormula;
        InterestToEarn: Decimal;
        FixedCallDepositSchedule: Record "Fixed/Call Deposit Schedule";
    begin
        with AccountOpening do begin
            TestField("Fixed Deposit Amount");
            TestField("Fixed Period");
            TestField("Start Date");
            TestField("Maturity Date");
            TestField("Source FOSA Account");
            TestField("Maturity FOSA Account");
            TestField("Account No.");
            TestField("Member No.");

            FixedCallDepositSchedule.Reset();
            FixedCallDepositSchedule.SetRange("Account Opening No.", "No.");
            FixedCallDepositSchedule.DeleteAll();

            CalculateNoofPeriods("Start Date", "Maturity Date", PeriodCount[1], PeriodCount[2], PeriodCount[3], PeriodCount[4]);

            if "Capitalization Frequency" = "Capitalization Frequency"::Monthly then begin
                NoofPeriods := PeriodCount[2];
            end;
            if "Capitalization Frequency" = "Capitalization Frequency"::Fortnightly then begin
                NoofPeriods := PeriodCount[2] * 2;
            end;
            if "Capitalization Frequency" = "Capitalization Frequency"::Weekly then begin
                NoofPeriods := PeriodCount[3];
            end;
            if "Capitalization Frequency" = "Capitalization Frequency"::Daily then begin
                NoofPeriods := PeriodCount[4];
            end;

            GetDateFormula(AccountOpening, PeriodDateFormula);
            NextDueDate := CalcDate(PeriodDateFormula, "Start Date");

            InterestToEarn := "Interest Rate" / 100 * "Fixed Deposit Amount";
            FOR i := 1 to NoofPeriods do begin
                NextDueDate := CalcDate(PeriodDateFormula, NextDueDate);
                PopulateFixedCallDepositSchedule(AccountOpening, NextDueDate, InterestToEarn);
            end;

            FixedCallDepositSchedule.Reset();
            FixedCallDepositSchedule.SetRange("Account Opening No.", "No.");
            Page.Run(50389, FixedCallDepositSchedule);

            CalcFields("Total Interest To Earn");
            "Total Amount To Earn" := "Total Interest To Earn" + "Fixed Deposit Amount";
            "Interest To Earn" := InterestToEarn;
            Modify();

        end;
    end;

    procedure GetDateFormula(AccountOpening: Record "Account Opening"; var PeriodDateFormula: DateFormula)
    var
    begin
        with AccountOpening do begin
            if "Capitalization Frequency" = "Capitalization Frequency"::Monthly then
                Evaluate(PeriodDateFormula, '1M');
            if "Capitalization Frequency" = "Capitalization Frequency"::Fortnightly then
                Evaluate(PeriodDateFormula, '2W');
            if "Capitalization Frequency" = "Capitalization Frequency"::Weekly then
                Evaluate(PeriodDateFormula, '1W');
            if "Capitalization Frequency" = "Capitalization Frequency"::Daily then
                Evaluate(PeriodDateFormula, '1D')
        end;
    end;

    local procedure CalculateNoofPeriods(StartDate: Date; EndDate: Date; var YearsCount: Integer; var MonthsCount: Integer; var WeeksCount: Integer; var DaysCount: Integer)
    var
        RecDate: Record Date;
        TempDate: Date;
        LastFoundDate: Date;
        TotalDays: Integer;
        Found: Boolean;
    begin
        RecDate.RESET;
        RecDate.SETRANGE("Period Type", RecDate."Period Type"::Date);
        RecDate.SETRANGE("Period Start", StartDate, EndDate);

        TotalDays := RecDate.COUNT;          // only for information

        IF RecDate.FINDSET THEN BEGIN

            //Years Count
            LastFoundDate := StartDate;
            TempDate := CALCDATE('+1Y', StartDate);
            Found := TRUE;
            REPEAT
                IF (TempDate <= EndDate) AND (RecDate.GET(RecDate."Period Type"::Date, TempDate)) THEN BEGIN
                    YearsCount += 1;
                    LastFoundDate := TempDate;
                    TempDate := CALCDATE('+1Y', TempDate);
                END ELSE
                    Found := FALSE;
            UNTIL NOT Found;

            // Months Count
            LastFoundDate := StartDate;
            TempDate := CALCDATE('+1M', LastFoundDate);
            Found := TRUE;
            REPEAT
                IF (TempDate <= EndDate) AND (RecDate.GET(RecDate."Period Type"::Date, TempDate)) THEN BEGIN
                    MonthsCount += 1;
                    LastFoundDate := TempDate;
                    TempDate := CALCDATE('+1M', TempDate);
                END ELSE
                    Found := FALSE;
            UNTIL NOT Found;

            // Weeks Count
            LastFoundDate := StartDate;
            TempDate := CALCDATE('+1W', LastFoundDate);
            Found := TRUE;
            REPEAT
                IF (TempDate <= EndDate) AND (RecDate.GET(RecDate."Period Type"::Date, TempDate)) THEN BEGIN
                    WeeksCount += 1;
                    LastFoundDate := TempDate;
                    TempDate := CALCDATE('+1W', TempDate);
                END ELSE
                    Found := FALSE;
            UNTIL NOT Found;

            // Days Count
            LastFoundDate := StartDate;
            TempDate := CALCDATE('+1D', LastFoundDate);
            Found := TRUE;
            REPEAT
                IF (TempDate <= EndDate) AND (RecDate.GET(RecDate."Period Type"::Date, TempDate)) THEN BEGIN
                    DaysCount += 1;
                    LastFoundDate := TempDate;
                    TempDate := CALCDATE('+1D', TempDate);
                END ELSE
                    Found := FALSE;
            UNTIL NOT Found;
        END;

    end;

    procedure MatureFixedCallDeposit(var FixedCallDepositSummary: Record "Fixed/Call Deposit Summary")
    var
        WTaxAmount: Decimal;
        FixedCallDepositSchedule: Record "Fixed/Call Deposit Schedule";
        AccountOpeningSetup: Record "Account Opening Setup";

    begin
        GlobalSetup.Get();
        SourceCodeSetup.Get();
        AccountOpeningSetup.Get();
        with FixedCallDepositSummary do begin

            GlobalManagement.ClearJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name");
            if "Maturity Date" = Today then begin
                CalcFields("Total Interest To Earn");
                /*
                //Post FD Amount
                GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, AccountTypeEnum::"G/L Account", "Maturity FOSA Account",
                            'FD Maturity', "Fixed Deposit Amount", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "Maturity FOSA Account",
                            'FD Maturity', -"Fixed Deposit Amount", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                //Post Interest Earned
                GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, AccountTypeEnum::"G/L Account", "Maturity FOSA Account",
                           'FD-Interest Earned', "Total Interest To Earn", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "Maturity FOSA Account",
                            'FD-Interest Earned', -"Total Interest To Earn", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                GlobalManagement.PostJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name");

                //Witholding Tax
                WTaxAmount := GlobalSetup."Withholding Tax %" / 100 * "Fixed Deposit Amount";
                GlobalSetup.TestField("Withholding Tax G/L Account");
                GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "Maturity FOSA Account",
                            'Withholding Tax', WTaxAmount, '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::"G/L Account", GlobalSetup."Withholding Tax G/L Account",
                            'Withholding Tax', -WTaxAmount, '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
*/
                GlobalManagement.PostJournal(AccountOpeningSetup."Account Closure Template Name", AccountOpeningSetup."Account Closure Batch Name");
                Status := Status::Matured;
                if Modify() then;
            end;
        end;
    end;

    procedure RevokeFixedCallDeposit(var FixedCallDepositSummary: Record "Fixed/Call Deposit Summary")
    var
        CDInterest: Decimal;
        NoofDays: array[4] of Integer;
        Description: array[4] of Text[100];
        AccountOpeningSetup: Record "Account Opening Setup";
    begin
        GlobalSetup.Get();
        AccountOpeningSetup.Get();
        with FixedCallDepositSummary do begin
            if "Maturity Date" <> Today then begin
                AccountType.Get("Account Type");
                CalcFields("Total Interest To Earn");
                GlobalManagement.ClearJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name");
                /*
                if AccountType.Type = AccountType.Type::"Fixed Deposit" then begin
                    GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "FD Account No.",
                                'FD Revoke', "Fixed Deposit Amount", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "Maturity FOSA Account",
                                'FD Revoke', -"Fixed Deposit Amount", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                    GlobalManagement.PostJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name");
                end;
                if AccountType.Type = AccountType.Type::"Call Deposit" then begin
                    NoofDays[1] := "Maturity Date" - "Start Date";
                    NoofDays[2] := Today - "Start Date";
                    CDInterest := NoofDays[1] / NoofDays[2] * "Total Interest To Earn";
                    GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "FD Account No.",
                                'CD Revoke', "Fixed Deposit Amount", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "Maturity FOSA Account",
                                'CD Revoke', -"Fixed Deposit Amount", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                    GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, AccountTypeEnum::"G/L Account", "Maturity FOSA Account",
                                'CD Revoke', CDInterest, '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
                    GlobalManagement.CreateJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name", "FD Account No.", "FD Account No.", Today, GenJournalLine."Account Type"::Vendor, "Maturity FOSA Account",
                                'CD Revoke', -CDInterest, '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');

                    GlobalManagement.PostJournal(AccountOpeningSetup."Fixed/Call Dep. Template Name", AccountOpeningSetup."Fixed/Call Dep. Batch Name");
                end;
*/
                Status := Status::Revoked;
                if Modify() then;
            end;
        end;
    end;

    procedure CreateFixedCallDepositSummary(AccountOpening: Record "Account Opening")
    var
        FixedCallDepositSummary: Record "Fixed/Call Deposit Summary";
        AccountType: Record "Account Type";
        EntryNo: Integer;
    begin
        with AccountOpening do begin
            AccountType.Get("Account Type");
            FixedCallDepositSummary.Init();
            FixedCallDepositSummary."FD Account No." := "Account No.";

            if FixedCallDepositSummary.FindLast() then
                EntryNo := FixedCallDepositSummary."Entry No."
            else
                EntryNo := 0;
            FixedCallDepositSummary."Entry No." := EntryNo + 10000;
            FixedCallDepositSummary."Fixed Deposit Amount" := "Fixed Deposit Amount";
            FixedCallDepositSummary."Interest Rate" := "Interest Rate";
            FixedCallDepositSummary."Start Date" := "Start Date";
            FixedCallDepositSummary."Maturity Date" := "Maturity Date";
            FixedCallDepositSummary."Fixed Period" := "Fixed Period";
            FixedCallDepositSummary."Capitalization Frequency" := "Capitalization Frequency";
            FixedCallDepositSummary."Source FOSA Account" := "Source FOSA Account";
            FixedCallDepositSummary."Maturity FOSA Account" := "Maturity FOSA Account";
            CalcFields("Total Interest To Earn");
            FixedCallDepositSummary."Total Interest To Earn" := "Total Interest To Earn";
            FixedCallDepositSummary."Total Amount To Earn" := "Total Amount To Earn";
            FixedCallDepositSummary."Account Opening No." := "No.";
            FixedCallDepositSummary."Member No." := "Member No.";
            FixedCallDepositSummary."Member Name" := "Member Name";
            FixedCallDepositSummary.Status := FixedCallDepositSummary.Status::"Pending Maturity";
            FixedCallDepositSummary."Account Type" := "Account Type";
            FixedCallDepositSummary.Description := Description;
            if FixedCallDepositSummary.Insert() then
                CreateFixedCallDepositSchedule(AccountOpening);
        end;
    end;

    procedure CloseAccount(var Vendor: Record Vendor)
    var

    begin
        with Vendor do begin
            AccountType.Get("Account Type");
            GlobalManagement.ClearJournal(AccountOpeningSetup."Account Closure Template Name", AccountOpeningSetup."Account Closure Batch Name");
            /* GlobalManagement.CreateJournal(AccountOpeningSetup."Account Closure Template Name", AccountOpeningSetup."Account Closure Batch Name", "No.", "No.", Today, GenJournalLine."Account Type"::Vendor, "No.",
                                            'Closing Account' + "No.", AccountType."Closing Fees", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
             GlobalManagement.CreateJournal(AccountOpeningSetup."Account Closure Template Name", AccountOpeningSetup."Account Closure Batch Name", "No.", "No.", Today, GenJournalLine."Account Type"::"G/L Account", AccountOpeningSetup."Closure Fee GL Account",
                                             'Closing Account' + "No.", -AccountType."Closing Fees", '', '', SourceCodeSetup."Fixed Deposit", GlobalManagement.GetBranchCode("Member No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '');
 */
            GlobalManagement.PostJournal(AccountOpeningSetup."Account Closure Template Name", AccountOpeningSetup."Account Closure Batch Name");
            Status := Status::Closed;
            if Modify() then
                Message('Account Closed Successfully');

        end;

    end;

    procedure CheckDormancy(var Member: Record Member)
    var
        TotalAccount: Integer;
        DormantAccountCount: Integer;
    begin
        with Member do begin
            DormantAccountCount := 0;
            TotalAccount := 0;

            Vendor.Reset();
            Vendor.SetRange("Member No.", "No.");
            if Vendor.FindSet() then begin
                repeat
                    AccountType.Reset();
                    AccountType.Get(Vendor."Account Type");
                    if AccountType.Type in [AccountType.Type::"Member Deposit"] then begin
                        AccountType.TestField("Dormancy Period");
                        TotalAccount += 1;
                        if not HasTransactionsWithinDormancyPeriod(Vendor."No.", AccountType."Dormancy Period") then begin
                            DormantAccountCount += 1;
                            Vendor.Status := Vendor.Status::Dormant;
                            Vendor.Modify();
                        end;
                    end;
                until Vendor.Next() = 0;
            end;
            if DormantAccountCount = TotalAccount then begin
                if not HasActiveLoan("No.") then
                    Status := Status::Dormant;
            end;

        end;
    end;

    local procedure HasTransactionsWithinDormancyPeriod(VendorNo: Code[20]; DormacyPeriod: DateFormula): Boolean
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CutoffDate: Date;
    begin
        CutoffDate := CalcDate('-' + format(DormacyPeriod), Today);

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgerEntry.SetRange("Posting Date", CutoffDate, Today);
        exit(VendorLedgerEntry.FindFirst());
    end;

    local procedure HasActiveLoan(MemberNo: Code[20]): Boolean
    var
        Customer: Record Customer;
        LoanCount: Integer;
    begin
        LoanCount := 0;
        Customer.Reset();
        Customer.SetRange("Member No.", MemberNo);
        if Customer.FindSet() then begin
            repeat
                Customer.CalcFields("Balance (LCY)");
                if Customer."Balance (LCY)" > 0 then
                    LoanCount += 1;
            until Customer.Next() = 0;
        end;
        if LoanCount > 0 then
            exit(true);
    end;

    procedure ActivateMember(MemberActivationHeader: Record "Member Activation Header")
    var
        Member: Record Member;
        MemberActivationLine: Record "Member Activation Line";
    begin
        with MemberActivationHeader do begin
            Member.Get("Member No.");
            Member.Status := Member.Status::Active;
            Member.Modify();

            MemberActivationLine.Reset();
            MemberActivationLine.SetRange("Document No.", "No.");
            if MemberActivationLine.FindSet() then begin
                repeat
                    Vendor.Get(MemberActivationLine."Account No.");
                    Vendor.Status := Vendor.Status::Active;
                    Vendor.blocked := Vendor.blocked::" ";
                    Vendor.Modify();
                until MemberActivationLine.Next() = 0;
            end;
        end;
    end;

    procedure CapitalizeRegistrationFee(var Member: Record Member)
    var
        Text000: Label 'Registration Fee Charged-';
        VendorPostingGroup: Record "Vendor Posting Group";
        RegistrationFeeDue: Decimal;

    begin
        with Member do begin
            MemberApplicationSetup.GET;
            SourceCodeSetup.GET;
            TransactionTypeCodeSetup.Get();

            SourceCodeSetup.TestField("Member Application");
            TransactionTypeCodeSetup.TestField("Registration Fee");

            MemberApplicationSetup.TestField("Registration Fee Template Name");
            MemberApplicationSetup.TestField("Registration Fee Batch Name");

            RegistrationFeeDue := MemberApplicationSetup."Registration Fee";

            if GlobalSetup."Income Realization Method" = GlobalSetup."Income Realization Method"::"On Accrual" then begin
                VendorPostingGroup.Get(MemberApplicationSetup."Registration Fee Posting Group");
                VendorPostingGroup.TestField("Payables Account");
                GlobalManagement.CreateJournal(MemberApplicationSetup."Registration Fee Template Name", MemberApplicationSetup."Registration Fee Batch Name", "No.", "No.", Today, AccountTypeEnum::Vendor, GetRegistrationFeeAccount("No."), Text000 + "No.", RegistrationFeeDue, MemberApplicationSetup."Registration Fee Posting Group",
                                               TransactionTypeCodeSetup."Registration Fee", SourceCodeSetup."Member Application", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "No.");

                GlobalManagement.CreateJournal(MemberApplicationSetup."Registration Fee Template Name", MemberApplicationSetup."Registration Fee Batch Name", "No.", "No.", Today, AccountTypeEnum::"G/L Account", VendorPostingGroup."Payables Account", Text000 + "No.", -RegistrationFeeDue, '',
                                               TransactionTypeCodeSetup."Registration Fee", SourceCodeSetup."Member Application", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "No.");
            end;
            if GlobalSetup."Income Realization Method" = GlobalSetup."Income Realization Method"::"On Payment" then begin
                VendorPostingGroup.Get(MemberApplicationSetup."Registration Fee Posting Group");
                VendorPostingGroup.TestField("Payables Account");
                GlobalManagement.CreateJournal(MemberApplicationSetup."Registration Fee Template Name", MemberApplicationSetup."Registration Fee Batch Name", "No.", "No.", Today, AccountTypeEnum::Vendor, GetRegistrationFeeAccount("No."), Text000 + "No.", RegistrationFeeDue, MemberApplicationSetup."Registration Fee Posting Group",
                                               TransactionTypeCodeSetup."Registration Fee", SourceCodeSetup."Member Application", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "No.");

                GlobalManagement.CreateJournal(MemberApplicationSetup."Registration Fee Template Name", MemberApplicationSetup."Registration Fee Batch Name", "No.", "No.", Today, AccountTypeEnum::"G/L Account", VendorPostingGroup."Payables Account", Text000 + "No.", -RegistrationFeeDue, '',
                                               TransactionTypeCodeSetup."Registration Fee", SourceCodeSetup."Member Application", "Global Dimension 1 Code", BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', "No.");
            end;
        end;
    end;

    local procedure GetRegistrationFeeAccount(MemberNo: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
    begin
        MemberApplicationSetup.Get();
        MemberApplicationSetup.TestField("Registration (Account Type)");

        Vendor.Reset();
        Vendor.SetRange("Member No.", MemberNo);
        Vendor.SetRange("Account Type", MemberApplicationSetup."Registration (Account Type)");
        if Vendor.FindFirst() then
            exit(Vendor."No.");
    end;

    local procedure RecoverMonthlyContribution(var Member: Record Member)
    var

    begin

    end;
}