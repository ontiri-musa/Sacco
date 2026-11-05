codeunit 50009 "Mobile Banking"
{
    trigger OnRun()
    begin

    end;

    procedure SendGETSMSRequest(var SMSEntry: Record "SMS Entry")
    var
        URI: Text;
        ResponseCode: Code[20];
        ResponseMessage: Text[50];
    begin
        with SMSEntry do begin
            BulkSMSSetup.Get();
            URI := 'https://mysms.celcomafrica.com/api/services/sendsms/?apikey=%1&partnerID=%2&message=%3&shortcode=%4&mobile=%5';
            JSONText := StrSubstNo(URI, BulkSMSSetup."API Key", BulkSMSSetup."Partner ID", GetSMSTemplate(), BulkSMSSetup."Short Code", "Phone No.");
            //  Message(JSONText);
            if HttpClient.Get(JSONText, HttpResponseMessage) then begin
                HttpResponseMessage.Content.ReadAs(JSONText);
                ReadJSON(JSONText, ResponseCode, ResponseMessage);
                if ((ResponseCode = '200') and (ResponseMessage = 'Success')) then begin
                    Sent := true;
                    modify;
                end;
            end;
        end;
    end;

    local procedure SendPOSTSMSRequest(URI: Text; QueryObject: Text) responseText: Text;

    var

        client: HttpClient;

        request: HttpRequestMessage;

        response: HttpResponseMessage;

        contentHeaders: HttpHeaders;

        content: HttpContent;

    begin
        // Add the payload to the content
        content.WriteFrom(QueryObject);
        // Retrieve the contentHeaders associated with the content
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in
        // the content associated with the request message
        request.Content := content;
        request.SetRequestUri(uri);
        request.Method := 'POST';
        client.Send(request, response);
        // Read the response content as json.
        response.Content().ReadAs(responseText);

    end;

    local procedure ReadJSON(JsonString: Text; var ResponseCode: Code[20]; var ResponseMessage: Text[50])
    var
        myInt: Integer;
    begin
        //Create JSONArray String
        //Read and Parse JSONArray
        CLEAR(JSONManagement);
        CLEAR(JObject);

        // JsonString := '{"responses":[{"respose-code":200,"response-code":200,"response-description":"Success","mobile":"254728687217","messageid":213088439,"networkid":"1"}]}';
        JSONManagement.InitializeFromString(JsonString);
        JSONManagement.GetJSONObject(JObject);
        ArrayString := JObject.SelectToken('responses').ToString;

        JSONManagement.InitializeCollection(ArrayString);
        JSONManagement.GetJsonArray(JSONArray);

        //loop and can do insert
        foreach JObject in JSONArray do begin
            ResponseCode := format(JObject.GetValue('respose-code'));
            ResponseMessage := format(JObject.GetValue('response-description'));
        end;
    end;

    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        JSONText: Text;
        HttpContent: HttpContent;
        JSONObject: JsonObject;
        BulkSMSSetup: record "Bulk SMS Setup";
        ArrayString: Text;
        JSONManagement: Codeunit "JSON Management";
        JSONArray: DotNet JArray;
        JObject: DotNet JObject;

    procedure FetchSMSToSend(var ResponseCode: Text; var ResponseMessage: Text; var ErrorMessage: Text)
    var
        SMSEntry: Record "SMS Entry";
        JSONSMSText: Text;
        JSONSMSText2: Text;
        JSONSMSText3: Text;
        Instr: InStream;
    begin
        SMSEntry.RESET;
        SMSEntry.SETRANGE(Sent, FALSE);
        IF SMSEntry.FINDSET THEN BEGIN
            JSONSMSText := '{"PendingSMS": [';
            REPEAT
                JSONSMSText += '{';
                JSONSMSText += '"Key":';
                JSONSMSText += '"' + FORMAT(SMSEntry."Entry No.") + '",';
                JSONSMSText += '"PhoneNo":';
                JSONSMSText += '"' + FORMAT(SMSEntry."Phone No.") + '",';
                JSONSMSText += '"Message":';
                SMSEntry.CalcFields("SMS Text");
                SMSEntry."SMS Text".CreateInStream(Instr);
                Instr.ReadText(JSONSMSText3);
                JSONSMSText += '"' + JSONSMSText3 + '"},';
            UNTIL SMSEntry.NEXT = 0;
            JSONSMSText2 := COPYSTR(JSONSMSText, 1, STRLEN(JSONSMSText) - 1);
            JSONSMSText2 += ']}';
            ResponseCode := '00';
            ResponseMessage := JSONSMSText2;
            EXIT;
        END ELSE BEGIN
            ResponseCode := '14';
            ResponseMessage := 'No SMS found';
            ErrorMessage := 'No SMS found';
            EXIT;
        END;
    end;

    procedure UpdateSentSMS(VAR SMSKey: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        SMSEntry: Record "SMS Entry";
        SMSKey1: Integer;
    begin
        EVALUATE(SMSKey1, SMSKey);
        SMSEntry.RESET;
        SMSEntry.SETRANGE(Sent, FALSE);
        //SMSEntry.SETRANGE("Phone No",MobilePhoneNo);
        SMSEntry.SETRANGE("Entry No.", SMSKey1);
        IF SMSEntry.FINDSET THEN BEGIN
            SMSEntry.Sent := TRUE;
            SMSEntry.MODIFY(TRUE);
            ResponseCode := '00';
            ResponseMessage := 'Success';
            EXIT;
        END ELSE BEGIN
            SMSEntry.Sent := TRUE;
            ResponseCode := '14';
            ResponseMessage := 'No SMS Found';
            ErrorMessage := 'No SMS Found';
            EXIT;
        END;
    end;

    procedure VerifyMember(Var phoneNumber: Text; Var idNumber: Text; Var memberNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text)
    var
        Member: Record Member;
    begin
        Member.RESET;
        Member.SetRange("No.", memberNo);
        Member.SETRANGE("Phone No.", phoneNumber);
        Member.SetRange("National ID", idNumber);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ResponseMessage := 'Member does not exist';
            EXIT;
        END else begin
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ResponseMessage := 'Member not active';
                EXIT;
            END ELSE BEGIN
                ResponseCode := '000';
                ResponseMessage := '{"member" :{' +
                                '"MemberNo" :"' + Member."No." +
                                '"name" :"' + Member."Full Name" +
                                '","nationalId" : "' + Member."National ID" +
                                '"PhoneNo" :"' + Member."Phone No." +
                                '"}}';
                EXIT;
            END;
        end;
    end;

    procedure memberDetails(Var phoneNumber: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text)
    Var
        Member: Record Member;
        Member2: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", phoneNumber);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ResponseMessage := 'Member does not exist';
            EXIT;
        END else begin
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ResponseMessage := 'Member not active';
                EXIT;
            END ELSE BEGIN
                ResponseCode := '000';
                ResponseMessage := '{"member" :{' +
                                '"name" :"' + Member."Full Name" +
                                '","nationalId" : "' + Member."National ID" +
                                '","MemberNo" :"' + Member."No." +
                                 '","DateofBirth" :"' + Format(Member."Date of Birth") +
                                  '","EmailAddress" :"' + Member."E-Mail" +
                                '"}}';
            END;
        END;
    end;

    procedure GetJuniorAccounts(Var phoneNumber: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text)
    Var
        Member: Record Member;
        Member2: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", phoneNumber);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ResponseMessage := 'Member does not exist';
            EXIT;
        END else begin
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ResponseMessage := 'Member not active';
                EXIT;
            END ELSE BEGIN
                Member2.RESET;
                Member2.SETRANGE("Parent Phone No.", Member."Phone No.");
                Member2.SetRange(Category, Member2.Category::Junior);
                IF NOT Member.FindSet() THEN BEGIN
                    ResponseCode := '14';
                    ResponseMessage := 'No Junior Acc linked to this member';
                    EXIT;
                END;

                ResponseCode := '000';
                ResponseMessage := '{"member" :{' +
                                '"MemberNo" :"' + Member."No." +
                                '","name" :"' + Member."Full Name" +
                                '","nationalId" : "' + Member."National ID" +
                                '","PhoneNo" :"' + Member."Phone No." +
                                '"}, "JuniorMembers" :[';

                Member2.RESET;
                Member2.SETRANGE("Parent Phone No.", Member."Phone No.");
                Member2.SetRange(Category, Member2.Category::Junior);
                IF Member2.FindSet() THEN begin
                    repeat
                        ResponseMessage += '{' +
                                        '"JMemberNo" :"' + Member2."No." +
                                        '","Jname" :"' + Member2."Full Name" +
                                        '",';
                        Vendor.RESET;
                        Vendor.SETRANGE("Member No.", Member2."No.");
                        IF Vendor.FindSet() THEN BEGIN
                            REPEAT
                                Vendor.CalcFields(Balance);
                                accountTypes.RESET;
                                accountTypes.SETRANGE(Code, Vendor."Account Type");
                                accountTypes.SETRANGE(Type, accountTypes.Type::"Member Deposit");
                                AccountTypes.SetFilter("Sub Type", '<>%1', AccountTypes."Sub Type"::Virtual);
                                IF accountTypes.FINDFIRST THEN BEGIN
                                    ResponseMessage +=
                                                        '"accountNo": "' + Vendor."No." +
                                                        '","accountName": "' + Vendor.Name +
                                                        '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                                        '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                                        '","isLoanAccount": "' + FORMAT(FALSE) +
                                                        '","isNWD": "' + FORMAT(FALSE) +
                                                        '","isShareCapital": "' + FORMAT(FALSE) +
                                                        '","isSavingsAccount": "' + FORMAT(TRUE) +
                                                        '","balance" : "' + FORMAT(Vendor.Balance) +
                                                        '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                                    '"},';
                                END;
                            UNTIL Vendor.NEXT = 0;
                            ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                            ResponseMessage += ',';
                            //ResponseMessage += '"},';
                        end;
                    until Member2.Next = 0;
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
                ResponseMessage += ']}';
                EXIT;
            END;
        end;
    end;

    Procedure GetSavingsAccounts(VAR MobilePhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text) Success: Integer
    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        Found: Boolean;
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", MobilePhoneNo);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member does not exist';
            EXIT;
        END else begin
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member not active';
                EXIT;
            END;
        end;
        Found := false;
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", Member."No.");
        IF NOT Vendor.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member has no accounts attached';
            EXIT;
        END ELSE BEGIN
            ResponseCode := '000';
            ResponseMessage := '{"member" :{';
            ResponseMessage +=
                            '"name" :"' + Member."Full Name" +
                            '","nationalId" : "' + Member."National ID" +
                            '"}, "accounts" :[';

            REPEAT
                Vendor.CalcFields(Balance);
                accountTypes.RESET;
                accountTypes.SETRANGE(Code, Vendor."Account Type");
                accountTypes.SETRANGE(Type, accountTypes.Type::Savings);
                AccountTypes.SetFilter("Sub Type", '<>%1', AccountTypes."Sub Type"::Virtual);
                IF accountTypes.FINDFIRST THEN BEGIN
                    Found := true;
                    ResponseMessage +=
                                    '{' +
                                        '"accountNo": "' + Vendor."No." +
                                        '","accountName": "' + Vendor.Name +
                                        '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                        '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                        '","isLoanAccount": "' + FORMAT(FALSE) +
                                        '","isNWD": "' + FORMAT(FALSE) +
                                        '","isShareCapital": "' + FORMAT(FALSE) +
                                        '","isSavingsAccount": "' + FORMAT(TRUE) +
                                        '","balance" : "' + FORMAT(Vendor.Balance) +
                                        '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                    '"},';

                END;
            UNTIL Vendor.NEXT = 0;
            if Found = true then
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
            ResponseMessage += ']}';
            EXIT;
        end;
    end;

    Procedure GetNWDAccounts(VAR MobilePhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text) Success: Integer
    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        Found: Boolean;

    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", MobilePhoneNo);
        Member.SetRange(Status, Member.Status::Active);

        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member does not exist';
            EXIT;
        END else begin
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member not active';
                EXIT;
            END;
        end;
        Found := false;
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", Member."No.");
        IF NOT Vendor.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member has no accounts attached';
            EXIT;
        END ELSE BEGIN
            ResponseCode := '000';
            ResponseMessage := '{"member" :{';
            ResponseMessage +=
                            '"name" :"' + Member."Full Name" +
                            '","nationalId" : "' + Member."National ID" +
                            '"}, "accounts" :[';

            REPEAT
                Vendor.CalcFields(Balance);
                accountTypes.RESET;
                accountTypes.SETRANGE(Code, Vendor."Account Type");
                accountTypes.SetFilter(Type, '%1|%2|%3', accountTypes.Type::"Call Deposit", AccountTypes.Type::"Fixed Deposit", AccountTypes.Type::"Member Deposit");
                IF accountTypes.FINDFIRST THEN BEGIN
                    Found := true;
                    ResponseMessage +=
                                    '{' +
                                        '"accountNo": "' + Vendor."No." +
                                        '","accountName": "' + Vendor.Name +
                                        '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                        '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                        '","isLoanAccount": "' + FORMAT(FALSE) +
                                        '","isNWD": "' + FORMAT(TRUE) +
                                        '","isShareCapital": "' + FORMAT(FALSE) +
                                        '","isSavingsAccount": "' + FORMAT(FALSE) +
                                        '","balance" : "' + FORMAT(Vendor.Balance) +
                                        '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                    '"},';

                END;
            UNTIL Vendor.NEXT = 0;
            if Found = true then
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
            ResponseMessage += ']}';
            EXIT;
        end;
    end;

    Procedure GetShareCapitalAccounts(VAR MobilePhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text) Success: Integer
    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        Found: Boolean;

    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", MobilePhoneNo);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member does not exist';
            EXIT;
        END else begin
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member not active';
                EXIT;
            END;
        end;
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", Member."No.");
        IF NOT Vendor.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member has no accounts attached';
            EXIT;
        END ELSE BEGIN
            Found := false;
            ResponseCode := '000';
            ResponseMessage := '{"member" :{';
            ResponseMessage +=
                            '"name" :"' + Member."Full Name" +
                            '","nationalId" : "' + Member."National ID" +
                            '"}, "accounts" :[';

            REPEAT
                Vendor.CalcFields(Balance);
                accountTypes.RESET;
                accountTypes.SETRANGE(Code, Vendor."Account Type");
                accountTypes.SETRANGE(Type, accountTypes.Type::"Share Capital");
                IF accountTypes.FINDFIRST THEN BEGIN
                    Found := true;
                    ResponseMessage +=
                                    '{' +
                                        '"accountNo": "' + Vendor."No." +
                                        '","accountName": "' + Vendor.Name +
                                        '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                        '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                        '","isLoanAccount": "' + FORMAT(FALSE) +
                                        '","isNWD": "' + FORMAT(FALSE) +
                                        '","isShareCapital": "' + FORMAT(TRUE) +
                                        '","isSavingsAccount": "' + FORMAT(FALSE) +
                                        '","balance" : "' + FORMAT(Vendor.Balance) +
                                        '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                    '"},';

                END;
            UNTIL Vendor.NEXT = 0;
            if Found = true then
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
            ResponseMessage += ']}';
            EXIT;
        end;
    end;

    procedure GetLoanAccounts(VAR MobilePhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text) Success: Integer
    var
        Member: Record Member;
        //CustomerRec: Record Customer;
        hasaccounts: Boolean;
        LoanProductTypes: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        InstallmentAmount: Decimal;
        BosaMgt: Codeunit "BOSA Management";
        Found: Boolean;
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", MobilePhoneNo);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member does not exist';
            EXIT;
        END ELSE BEGIN
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member not active';
                EXIT;
            END;
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", Member."No.");
            LoanApplication.SetRange(Posted, true);
            if LoanApplication.FindSet() then begin
                Found := false;
                ResponseCode := '000';
                ResponseMessage := '{"member" :{';
                ResponseMessage +=
                                    '"name" :"' + Member."Full Name" +
                                    '","nationalId" : "' + Member."National ID" +
                                    //'","MemberImage" : "'+convert.ToBase64String(bytes)+
                                    '"}, "accounts" :[';

                hasaccounts := FALSE;
                REPEAT
                    InstallmentAmount := 0;
                    if LoanApplication."Disbursal Date" = 0D then begin
                        LoanApplication."Disbursal Date" := LoanApplication."Approved Date";
                        LoanApplication.Modify();
                        Commit();
                    end;
                    //Error('Loan %1..disb %2...comple %3..appr %4', LoanApplication."No.", LoanApplication."Disbursal Date", LoanApplication."Date of Completion", LoanApplication."Approved Date");
                    InstallmentAmount := GetNoofInstallments(LoanApplication."No.", LoanApplication."Disbursal Date", LoanApplication."Date of Completion");

                    IF LoanProductTypes.GET(LoanApplication."Loan Product Type") THEN BEGIN
                        IF (GetCustomerBalance(LoanApplication."No.") > 0) THEN BEGIN
                            ResponseMessage +=
                                            '{' +
                                                '"accountNo": "' + LoanApplication."No." +
                                                '","accountName": "' + LoanApplication.Description +
                                                '","canWithdraw" : "' + FORMAT(FALSE) +
                                                '","canDeposit": "' + FORMAT(TRUE) +
                                                '","isLoanAccount": "' + FORMAT(TRUE) +
                                                '","isNWD": "' + FORMAT(FALSE) +
                                                '","isShareCapital": "' + FORMAT(FALSE) +
                                                '","isSavingsAccount": "' + FORMAT(FALSE) +
                                                '","balance" : "' + FORMAT(GetCustomerBalance(LoanApplication."No.")) +
                                                '","maxWithdrawable" : "' + FORMAT(0) +
                                                //'","maxDeposit" : "'+FORMAT(accountTypes."Maximum Allowable Deposit")+
                                                '","createdDate" : "' + FORMAT(LoanApplication."Approved Date") +
                                                '","installmentAmount" : "' + FORMAT(InstallmentAmount) +
                                                '","tofinishdate" : "' + FORMAT(LoanApplication."Date of Completion") +
                                            '"},';
                            hasaccounts := TRUE;
                        END;
                    END;
                UNTIL LoanApplication.NEXT = 0;
                IF hasaccounts THEN BEGIN
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                END;
                ResponseMessage += ']}';
                EXIT;
            END;
        END;
    end;

    procedure GetMemberAccounts(VAR MobilePhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text) Success: Integer
    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", MobilePhoneNo);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FIND('-') THEN BEGIN
            ResponseCode := '14';
            ErrorMessage := 'Member does not exist';
            EXIT;
        END ELSE BEGIN
            IF Member.Status <> Member.Status::Active THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member not active';
                EXIT;
            END;

            Vendor.RESET;
            Vendor.SETRANGE("Member No.", Member."No.");
            Vendor.SETFILTER(Status, '%1|%2|%3', Vendor.Status::Dormant, Vendor.Status::Active, Vendor.Status::Frozen);
            IF NOT Vendor.FIND('-') THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member has no accounts attached';
                EXIT;
            END ELSE BEGIN
                ResponseCode := '000';
                ResponseMessage := '{"member" :{';
                ResponseMessage +=
                                '"name" :"' + Member."Full Name" +
                                '","nationalId" : "' + Member."National ID" +
                                //'","MemberImage" : "'+convert.ToBase64String(bytes)+
                                '"}, "accounts" :[';

                REPEAT
                    Vendor.CalcFields(Balance);
                    accountTypes.RESET;
                    accountTypes.SETRANGE(Code, Vendor."Account Type");
                    IF accountTypes.FINDFIRST THEN BEGIN
                        // IF (accountTypes.Type = accountTypes.Type::Loan) AND (Vendor.Balance>0) THEN BEGIN
                        //     ResponseMessage += 
                        //                     '{'+
                        //                         '"accountNo": "'+Vendor."No."+
                        //                         '","accountName": "'+Vendor.Name+
                        //                         '","canWithdraw" : "'+ FORMAT(accountTypes."Allow Withdrawal")+
                        //                         '","canDeposit": "'+FORMAT(accountTypes."Allow Deposit")+
                        //                         '","isLoanAccount": "'+FORMAT(TRUE)+
                        //                         '","isNWD": "'+FORMAT(FALSE)+
                        //                         '","isShareCapital": "'+FORMAT(FALSE)+
                        //                         '","isSavingsAccount": "'+FORMAT(FALSE)+
                        //                         '","balance" : "'+FORMAT(Vendor.Balance)+
                        //                         '","maxWithdrawable" : "'+FORMAT(accountTypes."Maximum No. of Withdrawal")+
                        //                         //'","maxDeposit" : "'+FORMAT(accountTypes.ma)+
                        //                     '"},';
                        // END;
                        IF (accountTypes.Type = accountTypes.Type::Savings) THEN BEGIN
                            ResponseMessage +=
                                            '{' +
                                                '"accountNo": "' + Vendor."No." +
                                                '","accountName": "' + Vendor.Name +
                                                '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                                '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                                '","isLoanAccount": "' + FORMAT(FALSE) +
                                                '","isNWD": "' + FORMAT(FALSE) +
                                                '","isShareCapital": "' + FORMAT(FALSE) +
                                                '","isSavingsAccount": "' + FORMAT(TRUE) +
                                                '","balance" : "' + FORMAT(Vendor.Balance) +
                                                '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                            '"},';
                        END;
                        IF (accountTypes.Type = accountTypes.Type::"Share Capital") THEN BEGIN
                            ResponseMessage +=
                                            '{' +
                                                '"accountNo": "' + Vendor."No." +
                                                '","accountName": "' + Vendor.Name +
                                                '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                                '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                                '","isLoanAccount": "' + FORMAT(FALSE) +
                                                '","isNWD": "' + FORMAT(FALSE) +
                                                '","isShareCapital": "' + FORMAT(TRUE) +
                                                '","isSavingsAccount": "' + FORMAT(FALSE) +
                                                '","balance" : "' + FORMAT(Vendor.Balance) +
                                                '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                            '"},';
                        END;
                        IF (accountTypes.Type = accountTypes.Type::"Member Deposit") THEN BEGIN
                            ResponseMessage +=
                                            '{' +
                                                '"accountNo": "' + Vendor."No." +
                                                '","accountName": "' + Vendor.Name +
                                                '","canWithdraw" : "' + FORMAT(accountTypes."Allow Withdrawal") +
                                                '","canDeposit": "' + FORMAT(accountTypes."Allow Deposit") +
                                                '","isLoanAccount": "' + FORMAT(FALSE) +
                                                '","isNWD": "' + FORMAT(TRUE) +
                                                '","isShareCapital": "' + FORMAT(FALSE) +
                                                '","isSavingsAccount": "' + FORMAT(FALSE) +
                                                '","balance" : "' + FORMAT(Vendor.Balance) +
                                                '","maxWithdrawable" : "' + FORMAT(accountTypes."Maximum No. of Withdrawal") +
                                            '"},';
                        END;

                    END;
                UNTIL Vendor.NEXT = 0;
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                ResponseMessage += ']}';
                EXIT;
            end;
        end
    end;

    procedure PinnoCashPostToSuspense(VAR request_id: Code[10]; VAR phone_no: Code[50]; VAR transaction_type: Integer; VAR amount: Text; VAR trnx_charges: Text; VAR "account _number": Code[100]; VAR cr_account: Code[50]; VAR status: Text[200]; VAR f_key: Code[200]; VAR balance: Text;
                        VAR message: Text[500]; VAR response: Text[200]; VAR "response message": Text[1024]; VAR customerType: Code[20]; VAR description: Text[100]; VAR startDate: Text; VAR endDate: Text; VAR startTime: Text; VAR endTime: Text; VAR emailaddress: Text)
    var
        LoanAccount: Boolean;
        BankAccount: Record "Bank Account";
        TransactionAmount: Decimal;
        Acctype: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner","Suspense Account";
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner","Suspense Account";
        PostDesc: Text;
        Member: Record Member;
        MobileBankingSuspense: Record "Mobile Banking Suspense";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        JournalTemplateName: Code[50];
        JournalBatchName: Code[50];
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        Mobilesetup: Record "Mobile Banking Setup";
        AccountTypes: Record "Account Type";
        Customer: Record Customer;
        ChargeAmount: Decimal;
        CustomerRec: Record Customer;
        TotalMiniTransactions: BigText;
        MobileBankingMember: Record "Mobile Banking Member";
        MemberJ: Record Member;
    begin
        Mobilesetup.Get();

        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'PINNOCASH';

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJournalLine.FindSet() then begin
            GenJournalLine.DeleteAll();
        end;

        IF NOT GenJournalBatch.GET(JournalTemplateName, JournalBatchName) THEN BEGIN
            GenJournalBatch.INIT;
            GenJournalBatch."Journal Template Name" := JournalTemplateName;
            GenJournalBatch.Name := JournalBatchName;
            GenJournalBatch.INSERT;
        END;

        IF transaction_type = 760 THEN BEGIN
            PostDesc := 'KCB Bank - ' + Format(f_key) + ' ' + customerType + ' ' + phone_no + ' ' + "account _number";

            BankAccount.RESET;
            BankAccount.SETRANGE("No.", Mobilesetup."KCB Bank");
            IF BankAccount.FINDSET THEN BEGIN
                response := '00';
                "response message" := 'Deposit Successful to suspense';
                EVALUATE(TransactionAmount, amount);
                Acctype := Acctype::"Bank Account";
                BalAccType := BalAccType::"G/L Account";

                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                    TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, Mobilesetup."KCB Bank Suspense", '', PostDesc,
                                -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                CreateMobileEntriesToSuspense(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                PostTransaction(JournalTemplateName, JournalBatchName);

                EXIT;
            END;
            EXIT;
        END;

        IF transaction_type = 761 THEN BEGIN
            PostDesc := 'Co-operative Bank - ' + Format(f_key) + ' ' + customerType + ' ' + phone_no + ' ' + "account _number";

            BankAccount.RESET;
            BankAccount.SETRANGE("No.", Mobilesetup."Co-operative Bank");
            IF BankAccount.FINDSET THEN BEGIN
                response := '00';
                "response message" := 'Deposit Successful to suspense';
                EVALUATE(TransactionAmount, amount);
                Acctype := Acctype::"Bank Account";
                BalAccType := BalAccType::"G/L Account";

                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                    TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, Mobilesetup."Co-operative Bank Suspense", '', PostDesc,
                                -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                CreateMobileEntriesToSuspense(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                PostTransaction(JournalTemplateName, JournalBatchName);

                EXIT;
            END;
            EXIT;
        END;

        IF transaction_type = 762 THEN BEGIN
            PostDesc := 'Equity Bank - ' + Format(f_key) + ' ' + customerType + ' ' + phone_no + ' ' + "account _number";

            BankAccount.RESET;
            BankAccount.SETRANGE("No.", Mobilesetup."Equity Bank");
            IF BankAccount.FINDSET THEN BEGIN
                response := '00';
                "response message" := 'Deposit Successful to suspense';
                EVALUATE(TransactionAmount, amount);
                Acctype := Acctype::"Bank Account";
                BalAccType := BalAccType::"G/L Account";

                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                    TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, Mobilesetup."Equity Bank Suspense", '', PostDesc,
                                -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                CreateMobileEntriesToSuspense(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                PostTransaction(JournalTemplateName, JournalBatchName);

                EXIT;
            END;
            EXIT;
        END;

        IF transaction_type = 763 THEN BEGIN
            PostDesc := 'Old PayBill - ' + Format(f_key) + ' ' + customerType + ' ' + phone_no + ' ' + "account _number";

            BankAccount.RESET;
            BankAccount.SETRANGE("No.", Mobilesetup."Old Paybill");
            IF BankAccount.FINDSET THEN BEGIN
                response := '00';
                "response message" := 'Deposit Successful to suspense';
                EVALUATE(TransactionAmount, amount);
                Acctype := Acctype::"Bank Account";
                BalAccType := BalAccType::"G/L Account";

                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                    TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, Mobilesetup.Suspense, '', PostDesc,
                                -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                CreateMobileEntriesToSuspense(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                PostTransaction(JournalTemplateName, JournalBatchName);

                EXIT;
            END;
            EXIT;
        END;
    END;

    procedure PinnoCash(VAR request_id: Code[10]; VAR phone_no: Code[50]; VAR transaction_type: Integer; VAR amount: Text; VAR trnx_charges: Text; VAR "account _number": Code[100]; VAR cr_account: Code[50]; VAR status: Text[50]; VAR f_key: Code[50]; VAR balance: Text;
                        VAR message: Text[500]; VAR response: Text[50]; VAR "response message": Text[1024]; VAR customerType: Code[20]; VAR description: Text[100]; VAR startDate: Text; VAR endDate: Text; VAR startTime: Text; VAR endTime: Text; VAR emailaddress: Text)

    var
        LoanAccount: Boolean;
        BankAccount: Record "Bank Account";
        TransactionAmount: Decimal;
        Acctype: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner","Suspense Account";
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner","Suspense Account";
        PostDesc: Text;
        Member: Record Member;
        MobileBankingEntries: Record "Mobile Banking Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        Mobilesetup: Record "Mobile Banking Setup";
        AccountTypes: Record "Account Type";
        Customer: Record Customer;
        ChargeAmount: Decimal;
        CustomerRec: Record Customer;
        TotalMiniTransactions: BigText;
        MobileBankingMember: Record "Mobile Banking Member";
        MemberJ: Record Member;
    begin
        Mobilesetup.Get();

        Member.RESET;
        Member.SETRANGE("Phone No.", phone_no);
        Member.SetRange(Status, Member.Status::Active);
        IF NOT Member.FindFirst() THEN BEGIN
            "response message" := 'Provided Phone: ' + phone_no + ' is invalid!';
            response := '10';
            EXIT;
        END else begin
            JournalTemplateName := 'GENERAL';
            JournalBatchName := 'PINNOCASH';

            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
            GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
            if GenJournalLine.FindSet() then begin
                GenJournalLine.DeleteAll();
            end;

            IF NOT GenJournalBatch.GET(JournalTemplateName, JournalBatchName) THEN BEGIN
                GenJournalBatch.INIT;
                GenJournalBatch."Journal Template Name" := JournalTemplateName;
                GenJournalBatch.Name := JournalBatchName;
                GenJournalBatch.INSERT;
            END;

            IF transaction_type = 760 THEN BEGIN
                PostDesc := 'KCB Bank deposit - ' + Format(f_key);
                LoanAccount := FALSE;
                LoanAccount := IsLoanAccount("account _number");
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."KCB Bank");
                IF BankAccount.FINDSET THEN BEGIN
                    response := '00';
                    "response message" := 'Deposit Successful';
                    EVALUATE(TransactionAmount, amount);
                    AccType := AccType::"Bank Account";
                    IF LoanAccount = TRUE THEN BEGIN
                        BalAccType := BalAccType::Customer;
                    END ELSE
                        BalAccType := BalAccType::Vendor;
                    IF LoanAccount = TRUE THEN BEGIN
                        PrepareLoanJournal(AccType, BankAccount."No.", BalAccType, "account _number", TransactionAmount, request_id, PostDesc, phone_no, f_key);
                    END ELSE BEGIN
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                            TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                        -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                    END;
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);

                    IF LoanAccount = TRUE THEN BEGIN
                        SendLoanNotification("account _number", TransactionAmount);
                    END;
                    EXIT;
                END;
                EXIT;
            END;
            IF transaction_type = 761 THEN BEGIN
                PostDesc := 'Co-operative Bank Deposit - ' + Format(f_key);
                LoanAccount := FALSE;
                LoanAccount := IsLoanAccount("account _number");
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."Co-operative Bank");
                IF BankAccount.FINDSET THEN BEGIN
                    response := '00';
                    "response message" := 'Deposit Successful';
                    EVALUATE(TransactionAmount, amount);
                    AccType := AccType::"Bank Account";
                    IF LoanAccount = TRUE THEN BEGIN
                        BalAccType := BalAccType::Customer;
                    END ELSE
                        BalAccType := BalAccType::Vendor;

                    IF LoanAccount = TRUE THEN BEGIN
                        PrepareLoanJournal(AccType, BankAccount."No.", BalAccType, "account _number", TransactionAmount, request_id, PostDesc, phone_no, f_key);
                    END ELSE BEGIN
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                            TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                        -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                    END;
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);

                    IF LoanAccount = TRUE THEN BEGIN
                        SendLoanNotification("account _number", TransactionAmount);
                    END;
                    EXIT;
                END;
                EXIT;
            END;

            IF transaction_type = 762 THEN BEGIN
                PostDesc := 'Equity Bank Deposit - ' + Format(f_key);
                LoanAccount := FALSE;
                LoanAccount := IsLoanAccount("account _number");
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."Equity Bank");
                IF BankAccount.FINDSET THEN BEGIN
                    response := '00';
                    "response message" := 'Deposit Successful';
                    EVALUATE(TransactionAmount, amount);
                    AccType := AccType::"Bank Account";
                    IF LoanAccount = TRUE THEN BEGIN
                        BalAccType := BalAccType::Customer;

                    END ELSE
                        BalAccType := BalAccType::Vendor;
                    IF LoanAccount = TRUE THEN BEGIN
                        PrepareLoanJournal(AccType, BankAccount."No.", BalAccType, "account _number", TransactionAmount, request_id, PostDesc, phone_no, f_key);
                    END ELSE BEGIN
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                            TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                        -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                    END;
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);

                    IF LoanAccount = TRUE THEN BEGIN
                        SendLoanNotification("account _number", TransactionAmount);
                    END;
                    EXIT;
                END;
                EXIT;
            END;

            IF transaction_type = 763 THEN BEGIN
                PostDesc := 'Old PayBill Deposit - ' + Format(f_key);
                LoanAccount := FALSE;
                LoanAccount := IsLoanAccount("account _number");
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."Old Paybill");
                IF BankAccount.FINDSET THEN BEGIN
                    response := '00';
                    "response message" := 'Deposit Successful';
                    EVALUATE(TransactionAmount, amount);
                    AccType := AccType::"Bank Account";
                    IF LoanAccount = TRUE THEN BEGIN
                        BalAccType := BalAccType::Customer;

                    END ELSE
                        BalAccType := BalAccType::Vendor;

                    IF LoanAccount = TRUE THEN BEGIN
                        PrepareLoanJournal(AccType, BankAccount."No.", BalAccType, "account _number", TransactionAmount, request_id, PostDesc, phone_no, f_key);
                    END ELSE BEGIN
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                            TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                        -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                    END;
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);

                    IF LoanAccount = TRUE THEN BEGIN
                        SendLoanNotification("account _number", TransactionAmount);
                    END;
                    EXIT;
                END;
                EXIT;
            END;

            MobileBankingMember.RESET;
            MobileBankingMember.SETRANGE("Phone No.", Member."Phone No.");
            MobileBankingMember.SETRANGE(Status, MobileBankingMember.Status::Active);
            IF NOT MobileBankingMember.FINDFIRST THEN begin
                "response message" := 'Provided Phone: ' + phone_no + ' is not registered for mobile banking';
                response := '10';
                EXIT;
            END;

            if "account _number" <> '' then begin
                if Vendor.get("account _number") then begin
                    MemberJ.Reset();
                    MemberJ.SetRange("No.", Vendor."Member No.");
                    MemberJ.SetRange("Age Classification", MemberJ."Age Classification"::Junior);
                    if not MemberJ.FindSet() then begin
                        if Vendor."Member No." <> Member."No." then begin
                            response := '14';
                            "response message" := 'The Phone no. and Account No. do not belong to the same member';
                            EXIT;
                        end;
                    end;
                end;
            end;

            if cr_account <> '' then begin
                if Vendor.get(cr_account) then begin
                    MemberJ.Reset();
                    MemberJ.SetRange("No.", Vendor."Member No.");
                    MemberJ.SetRange("Age Classification", MemberJ."Age Classification"::Junior);
                    if not MemberJ.FindSet() then begin
                        if Vendor."Member No." <> Member."No." then begin
                            response := '14';
                            "response message" := 'The Phone no. and Account No. do not belong to the same member';
                            EXIT;
                        end;
                    end;
                end;
            end;
            //end;
            //CBSSetup.GET;

            MobileBankingEntries.RESET;
            MobileBankingEntries.SETRANGE("Transaction No.", request_id);
            IF MobileBankingEntries.FINDFIRST THEN BEGIN
                response := '14';
                "response message" := 'Duplicate transaction';
                EXIT;
            END;
            IF f_key <> '' THEN BEGIN
                IF transaction_type IN [705] THEN BEGIN
                    MobileBankingEntries.RESET;
                    MobileBankingEntries.SETRANGE(FKey, f_key);
                    IF MobileBankingEntries.FINDFIRST THEN BEGIN
                        response := '14';
                        "response message" := 'Duplicate transaction';
                        EXIT;
                    END;
                END;
            END;

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Document No.", request_id);
            IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                response := '14';
                "response message" := 'Duplicate transaction';
                EXIT;
            END;

            IF transaction_type IN [706] THEN BEGIN
                Vendor.RESET;
                Vendor.SETRANGE("No.", "account _number");
                IF NOT Vendor.FINDFIRST THEN BEGIN
                    response := '14';
                    "response message" := 'Account number does not exist';
                    EXIT;
                END;
            END;



            //Member Balance Inquiry
            IF transaction_type = 700 THEN BEGIN
                Vendor.RESET;
                IF Vendor.GET("account _number") THEN BEGIN
                    AccountTypes.RESET;
                    AccountTypes.SETRANGE(Code, Vendor."Account Type");
                    AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
                    IF NOT AccountTypes.FINDSET THEN BEGIN
                        response := '14';
                        "response message" := 'This Account is not a Savings Account';
                        EVALUATE(TransactionAmount, amount);
                        CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                        EXIT;
                    END;
                END;
                EVALUATE(TransactionAmount, amount);
                IF checkTotalCharges(700, TransactionAmount) > CheckAvailableAmount(700, phone_no, 1, "account _number") THEN BEGIN
                    response := '01';
                    "response message" := 'Insufficient Balance';
                    EXIT;
                END;
                response := '00';
                "response message" := FORMAT(GetMemberBalance("account _number"));
                EVALUATE(TransactionAmount, amount);
                CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                EXIT;
            END;

            IF transaction_type = 701 THEN BEGIN
                IF Vendor.GET("account _number") THEN BEGIN
                    AccountTypes.RESET;
                    AccountTypes.SETRANGE(Code, Vendor."Account Type");
                    AccountTypes.SETRANGE(Type, AccountTypes.Type::"Share Capital");
                    IF NOT AccountTypes.FINDSET THEN BEGIN
                        response := '14';
                        "response message" := 'This Account is not a share capital Account';
                        EVALUATE(TransactionAmount, amount);
                        CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                        EXIT;
                    END;
                END;
                response := '00';
                "response message" := FORMAT(GetMemberBalance("account _number"));
                EVALUATE(TransactionAmount, amount);
                CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                EXIT;
            END;

            //Loan Balance
            IF transaction_type = 702 THEN BEGIN
                IF Vendor.GET("account _number") THEN BEGIN
                    response := '14';
                    "response message" := 'This Account is not a Loan Account';
                    EVALUATE(TransactionAmount, amount);
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                    EXIT;
                END;
                IF CustomerRec.GET("account _number") THEN BEGIN
                    response := '00';
                    "response message" := FORMAT(GetCustomerBalance("account _number"));
                    EVALUATE(TransactionAmount, amount);
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                    EXIT;
                END ELSE BEGIN
                    response := '14';
                    "response message" := 'This Account is not a Loan Account';
                    EVALUATE(TransactionAmount, amount);
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                    EXIT;
                END;
            END;

            IF transaction_type = 703 THEN BEGIN
                IF Vendor.GET("account _number") THEN BEGIN
                    AccountTypes.RESET;
                    AccountTypes.SETRANGE(Code, Vendor."Account Type");
                    AccountTypes.SETRANGE(Type, AccountTypes.Type::"Member Deposit");
                    IF NOT AccountTypes.FINDSET THEN BEGIN
                        response := '14';
                        "response message" := 'This Account is not a Deposit Account';
                        EVALUATE(TransactionAmount, amount);
                        CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                        EXIT;
                    END;
                END;
                response := '00';
                "response message" := FORMAT(GetMemberBalance("account _number"));
                EVALUATE(TransactionAmount, amount);
                CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                EXIT;
            END;
            IF transaction_type = 704 THEN BEGIN
                IF CustomerRec.GET("account _number") THEN BEGIN
                    GetLast5LoanTransactions("account _number", TotalMiniTransactions);
                END ELSE BEGIN
                    GetLast5Transactions("account _number", TotalMiniTransactions);
                END;
                response := '00';
                "response message" := FORMAT(TotalMiniTransactions);
                EVALUATE(TransactionAmount, amount);
                CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, ChargeAmount, "account _number", cr_account, f_key);
                EXIT;
            END;
            IF transaction_type = 705 THEN BEGIN
                PostDesc := 'Mobile Banking deposit - ' + Format(f_key);
                LoanAccount := FALSE;
                LoanAccount := IsLoanAccount("account _number");
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."Paybill Bank");
                IF BankAccount.FINDSET THEN BEGIN
                    response := '00';
                    "response message" := 'Deposit Successful';
                    EVALUATE(TransactionAmount, amount);
                    AccType := AccType::"Bank Account";
                    IF LoanAccount = TRUE THEN BEGIN
                        BalAccType := BalAccType::Customer
                    END ELSE
                        BalAccType := BalAccType::Vendor;
                    IF LoanAccount = TRUE THEN BEGIN
                        PrepareLoanJournal(AccType, BankAccount."No.", BalAccType, "account _number", TransactionAmount, request_id, PostDesc, phone_no, f_key);
                    END ELSE BEGIN
                        ///PrepareJournal(AccType, BankAccount."No.", BalAccType, "account _number", TransactionAmount, request_id, PostDesc, phone_no);
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                            TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                        CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                        -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');
                    END;
                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);

                    IF LoanAccount = TRUE THEN BEGIN
                        SendLoanNotification("account _number", TransactionAmount);
                    END;
                    EXIT;
                END;
                EXIT;
            END;

            IF transaction_type = 706 THEN BEGIN
                PostDesc := 'Mobile Banking Withdrawal ';
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."Paybill Bank");
                IF BankAccount.FINDSET THEN BEGIN
                    EVALUATE(TransactionAmount, amount);
                    IF GetMemberBalance("account _number") < TransactionAmount THEN BEGIN
                        response := '01';
                        "response message" := 'Insufficient Balance';
                        CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);
                        EXIT;
                    END;
                    response := '00';
                    "response message" := 'Withdrawal Successful';
                    AccType := AccType::"Bank Account";
                    BalAccType := BalAccType::Vendor;
                    CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                                    -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                    CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                    TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');

                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);
                end;
            end;
            //Airtime
            IF transaction_type = 707 THEN BEGIN
                PostDesc := 'Airtime Purchase ';
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", Mobilesetup."Paybill Bank");
                IF BankAccount.FINDSET THEN BEGIN
                    EVALUATE(TransactionAmount, amount);
                    IF GetMemberBalance("account _number") < TransactionAmount THEN BEGIN
                        response := '01';
                        "response message" := 'Insufficient Balance';
                        CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);
                        EXIT;
                    END;
                    response := '00';
                    "response message" := 'Airtime Purchase Successful';
                    AccType := AccType::"Bank Account";
                    BalAccType := BalAccType::Vendor;
                    CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, AccType, BankAccount."No.", '', PostDesc,
                                    -TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 1, f_key, '');
                    CreateJnlLine(JournalTemplateName, JournalBatchName, request_id, BalAccType, "account _number", '', PostDesc,
                                    TransactionAmount, Member."Global Dimension 1 Code", BalAccType::"G/L Account", '', Member."No.", Today, 2, f_key, '');

                    CreateMobileBankingEntries(request_id, message, phone_no, transaction_type, TransactionAmount, 0, "account _number", cr_account, f_key);

                    PostTransaction(JournalTemplateName, JournalBatchName);
                end;
            end;
        end;
    end;

    Local procedure isLoanAccount(VAR AccountNo: Code[20]) isLoan: boolean
    var
        CustomerRec: Record Customer;

    begin
        CustomerRec.RESET;
        CustomerRec.SETRANGE("No.", AccountNo);
        CustomerRec.SETRANGE(Status, CustomerRec.Status::Active);
        IF CustomerRec.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure SendLoanNotification(AccountNo: Code[20]; TransAmount: Decimal)
    var
        MobileSetup: Record "Mobile Banking Setup";
        GlobalM: Codeunit "Global Management";
        SMSText: BigText;
        LoanApp: Record "Loan Application";
        Member: Record Member;
        SourceCodeSetup: Record "Source Code Setup";
        MemberName: array[5] of Text;
    begin
        SourceCodeSetup.Get();
        MobileSetup.Get();
        MemberName[2] := '';
        LoanApp.Get(AccountNo);
        LoanApp.CalcFields("Outstanding Balance");
        SourceCodeSetup.TestField(Loan);
        Member.GET(LoanApp."Member No.");
        MemberName[2] := COPYSTR(Member."Full Name", 1, STRPOS(Member."Full Name", ' '));
        CLEAR(SMSText);

        SMSText.ADDTEXT(STRSUBSTNO(MobileSetup."Loan Repay SMS Template", MemberName[2], TransAmount, LoanApp.Description, LoanApp."Outstanding Balance"));
        GlobalM.CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
    end;

    local procedure PrepareJournal(AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",; AccNo: Code[20]; BalType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",; BalAccNo: Code[20]; TransAmount: Decimal; RequestID2: Code[20]; DescriptionTxt: Text; PhoneNo: Text)
    var
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        Customer: Record Customer;
    begin
        JournalTemplateName := JournalTemplateName;
        JournalBatchName := JournalBatchName;

        CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID2, AccType, AccNo, '', DescriptionTxt,
                        TransAmount, Customer."Global Dimension 1 Code", BalType::"G/L Account", '', Customer."Member No.", Today, 1, RequestID2, '');
        CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID2, BalType, BalAccNo, '', DescriptionTxt,
                        -TransAmount, Customer."Global Dimension 1 Code", BalType::"G/L Account", '', Customer."Member No.", Today, 2, RequestID2, '');

    end;

    local procedure CreateNewJnlLine(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; RequestID: Code[20]; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",; AccountNo: Code[30]; TransactionTypes: Code[10]; Description: Text[50]; PostingAmount: Decimal; GlobalDimensionCode: Code[20]; BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",; BalAccountNo: Code[30]; MemberNo: Code[20]; PostingDate: Date; LineNo: Integer; F_key: code[40])
    var
        TempGenJournalLine: Record "Gen. Journal Line";

    begin
        TempGenJournalLine.INIT;
        TempGenJournalLine."Journal Template Name" := JournalTemplateName;
        TempGenJournalLine."Journal Batch Name" := JournalBatchName;
        TempGenJournalLine."Document No." := RequestID;
        TempGenJournalLine."External Document No." := F_key;
        TempGenJournalLine."Member No" := MemberNo;
        TempGenJournalLine."Line No." := LineNo;
        TempGenJournalLine."Account Type" := AccountType;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Account No.", AccountNo);
        TempGenJournalLine."Posting Date" := PostingDate;
        TempGenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Shortcut Dimension 1 Code");
        TempGenJournalLine.Description := Description;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Currency Code", '');
        TempGenJournalLine."Transaction Type Code" := TransactionTypes;
        TempGenJournalLine.VALIDATE(TempGenJournalLine.Amount, PostingAmount);
        //TempGenJournalLine.VALIDATE("Shortcut Dimension 1 Code",Globaldim);s
        IF TempGenJournalLine.Amount <> 0 THEN BEGIN
            TempGenJournalLine.INSERT;
        END;
        LineNo += 1;

    end;

    local procedure CreateJnlLine(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; RequestID: Code[20]; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",; AccountNo: Code[100]; TransactionTypes: Code[10]; Description: Text[100]; PostingAmount: Decimal; GlobalDimensionCode: Code[20]; BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",; BalAccountNo: Code[30]; MemberNo: Code[20]; PostingDate: Date; LineNo: Integer; F_key: code[55]; PostingGP: Code[100])
    var
        TempGenJournalLine: Record "Gen. Journal Line";

    begin
        TempGenJournalLine.INIT;
        TempGenJournalLine."Journal Template Name" := JournalTemplateName;
        TempGenJournalLine."Journal Batch Name" := JournalBatchName;
        TempGenJournalLine."Document No." := RequestID;
        TempGenJournalLine."External Document No." := F_key;
        TempGenJournalLine."Line No." := LineNo;
        TempGenJournalLine."Member No" := MemberNo;
        TempGenJournalLine."Account Type" := AccountType;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Account No.", AccountNo);
        TempGenJournalLine."Posting Date" := PostingDate;
        TempGenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Shortcut Dimension 1 Code");
        TempGenJournalLine.Description := Description;
        TempGenJournalLine.VALIDATE(TempGenJournalLine."Currency Code", '');
        TempGenJournalLine."Transaction Type Code" := TransactionTypes;
        If PostingGP <> '' then
            TempGenJournalLine."Posting Group" := PostingGP;
        TempGenJournalLine.VALIDATE(TempGenJournalLine.Amount, PostingAmount);
        //TempGenJournalLine.VALIDATE("Shortcut Dimension 1 Code",Globaldim);s
        IF TempGenJournalLine.Amount <> 0 THEN BEGIN
            TempGenJournalLine.INSERT;
        END;
        LineNo += 1;

    end;

    local procedure PostTransaction(JournalTemplateName: Code[20]; JournalBatchName: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";

    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", JournalBatchName);
        IF GenJournalLine.FINDSET THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
        END;
    end;

    local procedure PostAmount(JournalTemplateName: Code[20]; JournalBatchName: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";

    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", JournalBatchName);
        IF GenJournalLine.FINDSET THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
        END;
    end;

    procedure ProcessReversal(VAR RequestID: Code[20]; VAR ResponseCode: Code[20]; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        MobileBankingEntries: Record "Mobile Banking Ledger Entry";
    begin
        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", RequestID);
        GLEntry.SETRANGE(Reversed, FALSE);
        IF NOT GLEntry.FINDSET THEN BEGIN
            ResponseCode := '59';
            ErrorMessage := 'Document No: ' + RequestID + ' not Found!';
            EXIT;
        END;

        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", RequestID);
        GLEntry.SETRANGE(Reversed, FALSE);
        IF GLEntry.FINDSET THEN BEGIN
            REPEAT
                ReversalEntry.SetHideWarningDialogs();
                ReversalEntry.SetHideDialog(true);
                ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
            UNTIL GLEntry.NEXT = 0;
        END;

        ResponseCode := '00';
        ResponseMessage := 'Successfully Reversed ' + RequestID;
        EXIT;
    end;

    local procedure CreateMobileBankingEntries(RequestID: Code[20]; Message: Text; PhoneNo: Code[20]; TransactionType: Integer; AmountT: Decimal; ChargesT: Decimal; Account_number: Code[100]; Cr_Account: Code[50]; F_Key: code[55])
    var
        MobileBankingEntries: Record "Mobile Banking Ledger Entry";
        MobileBankingEntries2: Record "Mobile Banking Ledger Entry";
        LastEntryNo: Integer;
    begin
        LastEntryNo := 1;
        MobileBankingEntries2.Reset();
        MobileBankingEntries2.SetFilter("Entry No.", '<>%1', 0);
        if MobileBankingEntries2.FindLast() then begin
            LastEntryNo := MobileBankingEntries2."Entry No." + 1;
        end;
        MobileBankingEntries.INIT;
        MobileBankingEntries."Entry No." := LastEntryNo;
        MobileBankingEntries."Transaction No." := RequestID;
        MobileBankingEntries.Description := Message;
        //MobileBankingEntries."Charge Description":=PhoneNo;lg
        MobileBankingEntries."Service ID" := TransactionType;
        // MobileBankingEntries.Validate("Service ID");
        MobileBankingEntries.Amount := AmountT;
        MobileBankingEntries."Phone No." := PhoneNo;
        MobileBankingEntries."Account No." := Account_number;
        MobileBankingEntries."CR Account No." := Cr_Account;
        MobileBankingEntries."Transaction Date" := TODAY;
        MobileBankingEntries."Transaction Time" := TIME;
        MobileBankingEntries."Transacted By" := USERID;
        MobileBankingEntries.FKey := F_Key;
        MobileBankingEntries.INSERT;
    end;

    local procedure CreateMobileEntriesToSuspense(RequestID: Code[20]; Message: Text; PhoneNo: Code[20]; TransactionType: Integer; AmountT: Decimal; ChargesT: Decimal; Account_number: Code[100]; Cr_Account: Code[50]; F_Key: code[55])
    var
        MobileBankingSuspense: Record "Mobile Banking Suspense";
        MobileBankingSuspense2: Record "Mobile Banking Suspense";
        LastEntryNo: Integer;
    begin
        LastEntryNo := 1;
        MobileBankingSuspense2.Reset();
        MobileBankingSuspense2.SetFilter("Entry No.", '<>%1', 0);
        if MobileBankingSuspense2.FindLast() then begin
            LastEntryNo := MobileBankingSuspense2."Entry No." + 1;
        end;
        MobileBankingSuspense.INIT;
        MobileBankingSuspense."Entry No." := LastEntryNo;
        MobileBankingSuspense."Transaction No." := RequestID;
        MobileBankingSuspense.Description := Message;
        //MobileBankingEntries."Charge Description":=PhoneNo;lg
        MobileBankingSuspense."Service ID" := TransactionType;
        // MobileBankingEntries.Validate("Service ID");
        MobileBankingSuspense.Amount := AmountT;
        MobileBankingSuspense."Phone No." := PhoneNo;
        MobileBankingSuspense."Account No." := Account_number;
        MobileBankingSuspense."CR Account No." := Cr_Account;
        MobileBankingSuspense."Transaction Date" := TODAY;
        MobileBankingSuspense."Transaction Time" := TIME;
        MobileBankingSuspense."Transacted By" := USERID;
        MobileBankingSuspense.FKey := F_Key;
        MobileBankingSuspense.INSERT;
    end;

    local procedure CreateMobileBanking(RequestID: Code[20]; PhoneNo: Code[20]; AmountT: Decimal; ChargesT: Decimal; Account_number: Code[50]; Cr_Account: Code[50]; F_Key: code[55])
    var
        MobileBankingEntries: Record "Mobile Banking Ledger Entry";
        MobileBankingEntries2: Record "Mobile Banking Ledger Entry";
        LastEntryNo: Integer;
    begin
        LastEntryNo := 1;
        MobileBankingEntries2.Reset();
        MobileBankingEntries2.SetFilter("Entry No.", '<>%1', 0);
        if MobileBankingEntries2.FindLast() then begin
            LastEntryNo := MobileBankingEntries2."Entry No." + 1;
        end;
        MobileBankingEntries.INIT;
        MobileBankingEntries."Entry No." := LastEntryNo;
        MobileBankingEntries."Transaction No." := RequestID;
        //MobileBankingEntries."Charge Description":=PhoneNo;lg
        MobileBankingEntries.Validate("Service ID");
        MobileBankingEntries.Amount := AmountT;
        MobileBankingEntries."Phone No." := PhoneNo;
        MobileBankingEntries."Account No." := Account_number;
        MobileBankingEntries."CR Account No." := Cr_Account;
        MobileBankingEntries."Transaction Date" := TODAY;
        MobileBankingEntries."Transaction Time" := TIME;
        MobileBankingEntries."Transacted By" := USERID;
        MobileBankingEntries.FKey := F_Key;
        MobileBankingEntries.INSERT;
    end;


    local procedure checkTotalCharges(Transaction_Type: Integer; Amount: Decimal) TotalCharges: Decimal
    var
        TransactionTypes: Record "Transaction Type";
    begin
        /*TotalCharges:=0;
        TransactionTypes.RESET;
        IF Transaction_Type=700 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Balance Inquiry");
        END;;
        IF Transaction_Type=701 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Balance Inquiry");
        END;
        IF Transaction_Type=702 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Balance Inquiry");
        END;
        IF Transaction_Type=703 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Balance Inquiry");
        END;
        IF Transaction_Type=704 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Ministatement");
        END;
        IF Transaction_Type=705 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Deposit");
        END;
        IF Transaction_Type=706 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Mobile Banking Withdrawal");
        END;
        IF Transaction_Type=707 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Agency Airtime");
        END;
        IF Transaction_Type=708 THEN BEGIN
        TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Inter-Account");
        END;
        IF TransactionTypes.FINDSET THEN BEGIN
        Charge.RESET;
        Charge.SETRANGE(Type,TransactionTypes.Type);
        Charge.SETFILTER("Minimum Amount",'<=%1',Amount);
        Charge.SETFILTER("Maximum Amount",'>=%1',Amount);
        IF Charge.FINDSET THEN BEGIN
            SaccoCharges:=Charge."Charge Amount";
            SaccoGL:=Charge."GL Account";
            ExciseAmount:=(Charge."Excise %"*Charge."Charge Amount")/100;
            ExciseGL:=Charge."Excise G/L Account";
            SettlementAmount:=Charge."Settlement Amount";
            BankAccount.RESET;
            BankAccount.SETRANGE("Paybill Bank",TRUE);
            IF BankAccount.FINDFIRST THEN BEGIN 
            SettlementGL:=BankAccount."No.";;
            END;
            ChargeAmount:=SaccoCharges+ExciseAmount+SettlementAmount;
            //TotalCharges:=TransactionCharges."Apportionment Amount"+TransactionCharges."Settlement Amount  (SACCO)";
        END;
        END;*/
    end;

    LOCAL procedure CheckAvailableAmount(Transaction_type: Integer; PhoneNo: Code[20]; CheckAccountType: Integer; CheckAccountNo: Code[20]) AvailableAmount: Decimal
    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";

    begin
        AvailableAmount := 0;
        Member.RESET;
        Member.SETRANGE("Phone No.", PhoneNo);
        Member.SetRange(Status, Member.Status::Active);
        IF Member.FINDSET THEN BEGIN
            IF CheckAccountNo <> '' THEN BEGIN
                IF Vendor.GET(CheckAccountNo) THEN BEGIN
                    Vendor.CALCFIELDS(Balance);
                    ;
                    AvailableAmount := Vendor.Balance;
                    AccountTypes.RESET;
                    AccountTypes.SETRANGE(Code, Vendor."Account Type");
                    IF AccountTypes.FINDFIRST THEN BEGIN
                        AvailableAmount := AvailableAmount - AccountTypes."Minimum Balance";
                        //IF AvailableAmount>0 THEN BEGIN
                        EXIT(AvailableAmount);
                    END;
                END;
            END;
            AccountTypes.RESET;
            IF CheckAccountType = 1 THEN
                AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
            IF AccountTypes.FINDSET THEN BEGIN
                REPEAT
                    Vendor.RESET;
                    Vendor.SETRANGE("Member No.", Member."No.");
                    Vendor.SETRANGE("Account Type", AccountTypes.Code);
                    IF Vendor.FINDSET THEN BEGIN
                        Vendor.CALCFIELDS(Balance);
                        AvailableAmount := Vendor.Balance;
                        AvailableAmount := AvailableAmount - AccountTypes."Minimum Balance";
                        IF AvailableAmount > 0 THEN BEGIN
                            EXIT(AvailableAmount);
                        END;
                    END;
                UNTIL AccountTypes.NEXT = 0;
            END;
        END;
    end;

    LOCAL procedure GetMemberBalance(AccountNo: Code[20]) MemberAccountBalance: Decimal
    var
        Vendor: Record Vendor;

    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            Vendor.CALCFIELDS("Balance (LCY)");
            MemberAccountBalance := ABS(Vendor."Balance (LCY)");
            EXIT(MemberAccountBalance);
        END;
    end;

    LOCAL procedure GetCustomerBalance(AccountNo: Code[20]) MemberAccountBalance: Decimal
    var
        CustomerRec: Record Customer;
    begin
        IF CustomerRec.GET(AccountNo) THEN BEGIN
            CustomerRec.CALCFIELDS("Balance (LCY)");
            MemberAccountBalance := ABS(CustomerRec."Balance (LCY)");
            EXIT(MemberAccountBalance);
        END;
    end;

    LOCAL procedure PostAmount(AccountNo: Code[20]) AccountBalance: Decimal
    var
        Vendor: Record Vendor;

    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            Vendor.CALCFIELDS("Balance (LCY)");
            AccountBalance := ABS(Vendor."Balance (LCY)");
            EXIT(AccountBalance);
        END;
    end;

    procedure GetRepaymentFrequencyDateFormula(LoanApplication: Record "Loan Application") DateFormula: Code[20]
    var
        LoanProductType: Record "Loan Product Type";
    begin
        with LoanApplication DO begin
            IF LoanProductType.GET("Loan Product Type") THEN BEGIN
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Annually THEN
                    DateFormula := '1Y';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Quarterly THEN
                    DateFormula := '3M';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Monthly THEN
                    DateFormula := '1M';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Fortnightly THEN
                    DateFormula := '2W';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Weekly THEN
                    DateFormula := '1W';
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Daily THEN
                    DateFormula := '1D';
            END;
            EXIT(DateFormula);
        END;
    end;

    local procedure GetNoofInstallments(LoanNo: Code[20]; StartDate: Date; EndDate: Date): Integer
    var
        LoanApplication: Record "Loan Application";
        j: Integer;
        LastRepaymentDate: Date;
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
    begin
        j := 0;
        LoanApplication.GET(LoanNo);
        EVALUATE(DateFormula, GetRepaymentFrequencyDateFormula(LoanApplication));
        LastRepaymentDate := EndDate;
        NextRepaymentDate := StartDate;
        WHILE NextRepaymentDate <= LastRepaymentDate DO BEGIN
            NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
            j += 1;
        END;
        EXIT(j - 1);
    end;

    local procedure GetLast5Transactions(AccountNo: Code[20]; VAR TotalMiniTransactions: BigText)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        i: Integer;
        TransactionType: Code[10];
        MiniTransactions: Text[1024];
    begin
        i := 0;
        MiniTransactions := '';
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Vendor No.", AccountNo);
        VendorLedgerEntry.SETFILTER(Description, '<>%1', '@*charges*');
        VendorLedgerEntry.SETASCENDING("Entry No.", FALSE);
        VendorLedgerEntry.SETRANGE(Reversed, FALSE);
        IF VendorLedgerEntry.FINDSET() THEN BEGIN
            REPEAT
                i += 1;
                VendorLedgerEntry.CALCFIELDS(Amount);
                IF VendorLedgerEntry.Amount < 0 THEN
                    TransactionType := 'CR'
                ELSE
                    IF VendorLedgerEntry.Amount > 0 THEN
                        TransactionType := 'DR';
                MiniTransactions := FORMAT(VendorLedgerEntry."Posting Date") + ' ' + COPYSTR(VendorLedgerEntry.Description, 1, 12) + ' KES:' + FORMAT(-1 * VendorLedgerEntry.Amount) + ' |' + MiniTransactions;
            UNTIL ((VendorLedgerEntry.NEXT = 0) OR (i = 10));

        END;
        TotalMiniTransactions.ADDTEXT((MiniTransactions));
    end;

    LOCAL procedure GetLast5LoanTransactions(AccountNo: Code[20]; VAR TotalMiniTransactions: BigText)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        i: Integer;
        TransactionType: Code[10];
        MiniTransactions: Text;
    begin
        MiniTransactions := '';
        i := 0;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", AccountNo);
        CustLedgerEntry.SETASCENDING("Entry No.", FALSE);
        CustLedgerEntry.SETRANGE(Reversed, FALSE);
        if CustLedgerEntry.FindSet() then begin
            REPEAT
                i += 1;
                CustLedgerEntry.CALCFIELDS(Amount);
                IF CustLedgerEntry.Amount < 0 THEN
                    TransactionType := 'CR'
                ELSE
                    IF CustLedgerEntry.Amount > 0 THEN
                        TransactionType := 'DR';
                MiniTransactions := FORMAT(CustLedgerEntry."Posting Date") + ' ' + COPYSTR(CustLedgerEntry.Description, 1, 12) + ' KES:' + FORMAT(-1 * CustLedgerEntry.Amount) + ' |' + MiniTransactions;
            UNTIL ((CustLedgerEntry.NEXT = 0) OR (i = 10));
        END;
        TotalMiniTransactions.ADDTEXT((MiniTransactions));
    end;

    procedure FetchNewRegistrations(VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        Member: Record Member;
        MobileApp: Record "Mobile Banking Application";
        JsonSMSText1: Text;
        JsonSMSText2: Text;
        MobileBankingMember: Record "Mobile Banking Member";
    begin
        MobileBankingMember.Reset();
        MobileBankingMember.SetRange("Updated On Portal", false);
        MobileBankingMember.SetRange(Status, MobileBankingMember.Status::Active);
        if MobileBankingMember.FindSet() then begin
            JsonSMSText1 := '{"NewRegistrations": [';
            repeat
                Member.RESET;
                Member.SETRANGE("No.", MobileBankingMember."Member No.");
                IF Member.FindFirst() THEN BEGIN
                    JsonSMSText1 += '{';
                    JsonSMSText1 += '"customer_No":';
                    JsonSMSText1 += '"' + FORMAT(Member."No.") + '",';
                    JsonSMSText1 += '"customer_name":';
                    JsonSMSText1 += '"' + FORMAT(Member."Full Name") + '",';
                    JsonSMSText1 += '"msisdn":';
                    JsonSMSText1 += '"' + FORMAT(Member."Phone No.") + '",';
                    JsonSMSText1 += '"idno":';
                    JsonSMSText1 += '"' + FORMAT(Member."National ID") + '",';
                    JsonSMSText1 += '"customer_email":';
                    JsonSMSText1 += '"' + FORMAT(Member."E-mail") + '"},';
                END;
            Until MobileBankingMember.Next = 0;
            JsonSMSText2 := COPYSTR(JsonSMSText1, 1, STRLEN(JsonSMSText1) - 1);
            JsonSMSText2 += ']}';
            ResponseCode := '00';
            ResponseMessage := JsonSMSText2;
            EXIT;
        END ELSE BEGIN
            ResponseCode := '14';
            ResponseMessage := 'No SMS found';
            ErrorMessage := 'No SMS found';
            EXIT;
        END;
    end;

    procedure UpdateRegisteredMembers(VAR PhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        Member: Record Member;
        PhoneNo_: Code[20];
        MobileApp: Record "Mobile Banking Application";
        MobileBankingMember: Record "Mobile Banking Member";
    begin
        EVALUATE(PhoneNo_, PhoneNo);
        MobileBankingMember.RESET;
        MobileBankingMember.SETRANGE("Phone No.", PhoneNo_);
        IF MobileBankingMember.FINDFIRST THEN BEGIN
            MobileBankingMember."Updated on Portal" := TRUE;
            MobileBankingMember.MODIFY(TRUE);
            if Member.Get(MobileBankingMember."Member No.") then begin
                Member."Updated On Portal" := true;
                Member.Modify();
            end;
            ResponseCode := '00';
            ResponseMessage := 'Success';
            EXIT;
        END ELSE BEGIN
            ResponseCode := '14';
            ResponseMessage := 'Member Not Found';
            ErrorMessage := 'Member Not Found';
            EXIT;
        END;
    end;

    local procedure PrepareLoanJournal(AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccNo: Code[20]; BalType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; BalAccNo: Code[20]; TransAmount: Decimal; RequestID2: Code[20]; DescriptionTxt: text; PhoneNo: Text; f_key: Text)

    var
        InterestDue: decimal;
        LedgerFeeDue: decimal;
        PenaltyDue: decimal;
        PrincipalDue: Decimal;
        PrePayment: Decimal;
        AccountBal: Decimal;
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        Customer: Record Customer;
        AmountBalance: Decimal;
        ToSavings: Decimal;
        RequestID: code[20];
        AccountNo: Code[20];
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        TransactionType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        Description: Text;
        Amount: Decimal;
        GlobalDimensionCode: code[20];
        BalAccountNo: Code[20];
        BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        MemberNo: code[20];
        LoanAc: Record "Loan Application";
        LProdSetup: Record "Loan Product Type";
        postingDate: Date;
        Member: Record Member;
        SavingsAcc: Code[20];
        TotalPaid: Decimal;
        LoanOverPaid: Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        TType: Option " ",Deposit,Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Shares Contribution","Welfare Contribution","Registration Fee","Administration Fee",Dividend,"Withholding Tax","Loan Adjustment";
        mobileSetup: Record "Mobile Banking Setup";
    begin
        //CBSSetup.GET;
        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'PINNOCASH';
        GetLoanBalances(BalAccNo, PrincipalDue, InterestDue, LedgerFeeDue, PenaltyDue, PrePayment);
        LoanOverPaid := 0;
        ToSavings := 0;
        TotalPaid := 0;
        AmountBalance := TransAmount;

        //ERROR('Interest %1,prin %2,Sav %3, savin acc %4',InterestDue,PrincipalDue,ToSavings,SavingsAcc);
        IF InterestDue > 0 THEN BEGIN
            IF InterestDue >= AmountBalance THEN BEGIN
                InterestDue := AmountBalance;
                LedgerFeeDue := 0;
                PenaltyDue := 0;
                PrincipalDue := 0;
                AmountBalance := 0;
            END ELSE BEGIN
                AmountBalance -= InterestDue;
            END;
        END ELSE BEGIN
            InterestDue := 0;
        END;

        IF LedgerFeeDue > 0 THEN BEGIN
            IF LedgerFeeDue >= AmountBalance THEN BEGIN
                LedgerFeeDue := AmountBalance;
                PenaltyDue := 0;
                PrincipalDue := 0;
                AmountBalance := 0;
            END ELSE BEGIN
                AmountBalance -= LedgerFeeDue;
            END;
        END ELSE BEGIN
            LedgerFeeDue := 0;
        END;

        IF PenaltyDue > 0 THEN BEGIN
            IF PenaltyDue >= AmountBalance THEN BEGIN
                PenaltyDue := AmountBalance;
                PrincipalDue := 0;
                AmountBalance := 0;
            END ELSE BEGIN
                AmountBalance -= PenaltyDue;
            END;
        END ELSE BEGIN
            PenaltyDue := 0;
        END;

        IF PrincipalDue > 0 THEN BEGIN
            IF PrincipalDue >= AmountBalance THEN BEGIN
                PrincipalDue := AmountBalance;
                AmountBalance := 0;
            END ELSE BEGIN
                AmountBalance -= PrincipalDue;
            END;
        END ELSE BEGIN
            PrincipalDue := 0;
        END;
        TotalPaid := InterestDue + LedgerFeeDue + PenaltyDue + PrincipalDue;

        //ERROR('Interest %1,prin %2,Sav %3, savin acc %4',InterestDue,PrincipalDue,ToSavings,SavingsAcc);
        RequestID := RequestID2;
        AccountType := AccType;
        AccountNo := AccNo;
        BalAccountType := BalAccountType::"G/L Account";
        BalAccountNo := '';
        PostingDate := TODAY;
        Amount := TransAmount;
        Member.RESET;
        Member.SETRANGE("Phone No.", PhoneNo);
        Member.SetRange(Status, Member.Status::Active);
        IF Member.FINDSET THEN BEGIN
            MemberNo := Member."No.";
            GlobalDimensionCode := Member."Global Dimension 1 Code";
        END;

        TransactionTypeCodeSetup.Get();
        SavingsAcc := GetSavingsAccount(MemberNo);
        If LoanAc.Get(BalAccNo) THEN
            LProdSetup.Get(LoanAc."Loan Product Type");

        IF InterestDue > 0 THEN BEGIN
            /* CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, TransactionTypeCodeSetup."Interest Paid", 'Mobile Interest Repayment - ' + Format(f_key),
                             InterestDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 1, f_key, '');*/
            CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Interest Paid", 'Mobile Interest Repayment - ' + Format(f_key),
                            -InterestDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 2, f_key, LProdSetup."Interest Due Posting Group");
        END;

        IF LedgerFeeDue > 0 THEN BEGIN
            /* CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, TransactionTypeCodeSetup."Ledger Fee Paid", 'Mobile Ledger Fee Repayment - ' + Format(f_key),
                             LedgerFeeDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 3, f_key, '');*/
            CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Ledger Fee Paid", 'Mobile Ledger Fee Repayment - ' + Format(f_key),
                            -LedgerFeeDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 4, f_key, LProdSetup."Ledger Fee Due Posting Group");
        END;

        IF PenaltyDue > 0 THEN BEGIN
            /* CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, TransactionTypeCodeSetup."Penalty Paid", 'Mobile Penalty Repayment - ' + Format(f_key),
                             PenaltyDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 5, f_key, '');*/
            CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Penalty Paid", 'Mobile Penalty Repayment - ' + Format(f_key),
                            -PenaltyDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 6, f_key, LProdSetup."Penalty Due Posting Group");
        END;
        IF PrincipalDue > 0 THEN BEGIN
            /* CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, TransactionTypeCodeSetup."Principal Paid", 'Mobile Principal Repayment - ' + Format(f_key),
                             PrincipalDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 7, f_key, '');*/
            CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Principal Paid", 'Mobile Principal Repayment - ' + Format(f_key),
                            -PrincipalDue, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 8, f_key, LProdSetup."Loan Posting Group");
        END;

        If AmountBalance > 0 then begin
            Customer.get(BalAccNo);
            Customer.CalcFields(Balance);
            if ((Customer.Balance - TotalPaid) > 0) then begin
                if AmountBalance > (Customer.Balance - TotalPaid) then begin
                    LoanOverPaid := (Customer.Balance - TotalPaid);
                    AmountBalance -= (Customer.Balance - TotalPaid);
                end else begin
                    LoanOverPaid := AmountBalance;
                    AmountBalance := 0;
                end;

                if Customer.Balance - (TotalPaid + LoanOverPaid) = 0 then begin
                    /* CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, TransactionTypeCodeSetup."Principal Paid", 'Mobile Principal Advance Repayment - ' + Format(f_key),
                     LoanOverPaid, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 9, f_key, '');*/
                    CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Principal Paid", 'Mobile Principal Advance Repayment - ' + Format(f_key),
                    -LoanOverPaid, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 10, f_key, LProdSetup."Loan Posting Group");

                    IF (-PrePayment > 0) THEN BEGIN
                        CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Loan Prepayment", 'PrePayment Recovery Mobile - ' + Format(f_key),
                        -PrePayment, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 11, f_key, LProdSetup."Loan Prepayment Posting Group");
                        CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Principal Paid", 'PrePayment Recovery Mobile- ' + Format(f_key),
                        PrePayment, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 12, f_key, LProdSetup."Loan Posting Group");
                    END;
                end;
                if Customer.Balance - (TotalPaid + LoanOverPaid) > 0 then begin
                    /* CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, TransactionTypeCodeSetup."Principal Paid", 'Mobile Loan Prepayment - ' + Format(f_key),
                     LoanOverPaid, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 13, f_key, '');*/
                    CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Customer, BalAccNo, TransactionTypeCodeSetup."Loan Prepayment", 'Mobile Loan Prepayment - ' + Format(f_key),
                    -LoanOverPaid, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 14, f_key, LProdSetup."Loan Prepayment Posting Group");
                end;
            end;
        end;
        ToSavings := AmountBalance;
        IF (ToSavings > 0) AND (SavingsAcc <> '') THEN BEGIN
            /*  CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType, AccountNo, '', STRSUBSTNO('Loan %1 OverRecovery - ', BalAccNo) + Format(f_key),
                              ToSavings, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 15, f_key, '');*/
            CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::Vendor, SavingsAcc, '', STRSUBSTNO('Loan %1 OverRecovery - ', BalAccNo) + Format(f_key),
                            -ToSavings, GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 16, f_key, '');
        END;
        CreateJnlLine(JournalTemplateName, JournalBatchName, RequestID, AccountType::"Bank Account", AccNo, TransactionTypeCodeSetup."Principal Paid", 'Loan Repayment - ' + Format(f_key),
                            (InterestDue + LedgerFeeDue + PenaltyDue + PrincipalDue + LoanOverPaid + ToSavings), GlobalDimensionCode, BalAccountType, BalAccountNo, MemberNo, PostingDate, 17, f_key, fnGetBnkAcctPostingGrp(AccNo));

    end;

    local procedure fnGetBnkAcctPostingGrp(acctNo: Code[35]) pstGrp: Code[35]
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Reset();
        BankAccount.SetRange("No.", acctNo);
        if BankAccount.find('-') then
            pstGrp := BankAccount."Bank Acc. Posting Group";
        exit(pstGrp);

    end;

    local procedure GetLoanBalances(LoanNo: Code[20]; VAR PrincipalDue: Decimal; VAR InterestDue: Decimal; VAR LedgerFeeDue: Decimal; VAR PenaltyDue: Decimal; VAR Prepayment: Decimal)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
        TransactionTypeSetup: Record "Transaction Type Code Setup";
        LRepPrincAmount: Decimal;
        LRepSch: Record "Loan Repayment Schedule";
        GlobalManagement: Codeunit "Global Management";
        OverpaymentAmount: array[2] of Decimal;
    begin
        TransactionTypeSetup.Get();

        DetailedCustLedger.RESET;
        DetailedCustLedger.SETRANGE("Customer No.", LoanNo);
        IF DetailedCustLedger.FINDSET THEN BEGIN
            REPEAT
                IF DetailedCustLedger."Transaction Type Code" IN [TransactionTypeSetup."Loan Prepayment"] THEN BEGIN
                    Prepayment += DetailedCustLedger.Amount;
                END;
            UNTIL DetailedCustLedger.NEXT = 0;
        END;
        GlobalManagement.CalculateLoanArrearsAndOverpayment(LoanNo, 0D, Today, PrincipalDue, InterestDue, LedgerFeeDue, PenaltyDue, OverpaymentAmount[1], OverpaymentAmount[2]);
    end;

    local procedure GetSavingsAccount(VAR MemberNo: Code[20]) SavingsAccount: Code[20]
    var
        AccountTypes: Record "Account Type";
        Vendor: Record Vendor;
    begin
        AccountTypes.RESET;
        AccountTypes.SETRANGE(Type, AccountTypes.Type::"Member Deposit");
        IF AccountTypes.FINDSET then begin
            REPEAT
                Vendor.RESET;
                Vendor.SETRANGE("Account Type", AccountTypes.Code);
                Vendor.SETRANGE("Member No.", MemberNo);
                IF Vendor.FINDSET THEN BEGIN
                    Vendor.Blocked := Vendor.Blocked::" ";
                    Vendor.MODIFY;
                    SavingsAccount := Vendor."No.";
                    EXIT(SavingsAccount);
                END;
            UNTIL AccountTypes.NEXT = 0;
        END;
    end;

    procedure ApplyLoan(VAR requestid: Text; VAR PhoneNo: Code[20]; VAR eLoanCode: Code[20]; VAR Amount: Decimal; VAR Installments: Decimal; VAR TChargeAmount: Decimal; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        MemberNo: code[25];
        LoanProductTypes: Record "Loan Product Type";
        NextDate: Date;
        BankAccount: Record "Bank Account";
        Member: Record Member;
        LoanBalance: Decimal;
        NoOfLoans: Decimal;
        AccBalance: array[5] of decimal;
        PostDesc: Text;
        MobileBankingEntries: Record "Mobile Banking Ledger Entry";
        LoanApplication: Record "Loan Application";
        PArrears: Decimal;
        IArrears: Decimal;
        NoOfInstallments: Integer;
        LoanNo: Code[20];
        BosaManagement: Codeunit "BOSA Management";
        TotalBalance: Decimal;
        CustRec: Record Customer;
        MobileBankingMember: Record "Mobile Banking Member";
        GuaranteedAmount: Decimal;
        Text001: TextConst ENU = 'Loan Application & Disbursement to MPESA';
        Mobilesetup: Record "Mobile Banking Setup";
        GraduationAmount: array[5] of Decimal;
        memberDeposits: Decimal;
        mobileLnBalance: Decimal;
        availableDeposits: Decimal;
        eligibleAmt: Decimal;
        loanSerries: Integer;
        availableAmt: Decimal;
    begin
        TotalBalance := 0;
        Mobilesetup.Get();
        Member.RESET;
        Member.SETRANGE(member."Phone No.", PhoneNo);
        IF NOT Member.FINDSET THEN BEGIN
            ResponseCode := '08';
            ErrorMessage := 'Member with phone no ' + PhoneNo + ' not found';
            EXIT;
        END ELSE BEGIN
            /*if Member."Dormancy Status" <> Member."Dormancy Status"::Active then begin
                ResponseCode := '63';
                ErrorMessage := 'Member with phone no ' + PhoneNo + ' dormancy status is not active';
                EXIT;
            end;*/
            if Member.Category <> Member.Category::Individual then begin
                ResponseCode := '52';
                ErrorMessage := 'You do not Qualify for this Loan!';
                EXIT;
            end;
            MemberNo := Member."No.";
            MobileBankingMember.RESET;
            MobileBankingMember.SETRANGE("Phone No.", Member."Phone No.");
            MobileBankingMember.SETRANGE(Status, MobileBankingMember.Status::Active);
            IF NOT MobileBankingMember.FINDFIRST THEN BEGIN
                ErrorMessage := 'Provided Phone: ' + PhoneNo + ' is not registered for mobile banking';
                ResponseCode := '10';
                EXIT;
            END;
            LoanProductTypes.RESET;
            LoanProductTypes.SETRANGE(Code, eLoanCode);
            IF NOT LoanProductTypes.FINDSET THEN BEGIN
                ResponseCode := '08';
                ErrorMessage := 'Loan Product ' + eLoanCode + ' not found';
                EXIT;
            END;
            IF Member."Date of Registration" <> 0D THEN
                NextDate := Member."Date of Registration";

            LoanProductTypes.GET(eLoanCode);
            IF NextDate <> 0D THEN BEGIN
                IF CALCDATE(LoanProductTypes."Min. Membership period", NextDate) > TODAY THEN BEGIN
                    ResponseCode := '52';
                    ErrorMessage := 'You do not qualify for this Loan.';
                    EXIT;
                END;
            END;
            LoanBalance := 0;
            NoOfLoans := 0;
            availableDeposits := 0;
            loanSerries := 0;
            CustRec.RESET;
            CustRec.SETRANGE("Member No.", Member."No.");
            CustRec.SETRANGE("Customer Posting Group", LoanProductTypes.Code);
            CustRec.SETRANGE(Status, CustRec.Status::Active);
            IF CustRec.FINDSET THEN BEGIN
                REPEAT
                    CustRec.CALCFIELDS(Balance);

                    LoanBalance += CustRec.Balance;
                    IF CustRec.Balance > 0 THEN
                        NoOfLoans += 1;
                UNTIL CustRec.NEXT = 0;
            END;
            CustRec.RESET;
            CustRec.SETRANGE("Member No.", Member."No.");
            CustRec.SETRANGE("Customer Posting Group", LoanProductTypes.Code);
            CustRec.SETRANGE(Status, CustRec.Status::Active);
            IF CustRec.FINDSET THEN BEGIN
                REPEAT
                    CustRec.CALCFIELDS(Balance);

                    //  LoanBalance += CustRec.Balance;
                    IF CustRec.Balance > 0 THEN
                        loanSerries += 1;
                UNTIL CustRec.NEXT = 0;
            END;
            IF (LoanProductTypes."Allow Multiple Loans" = false) AND (NoOfLoans >= 1) THEN BEGIN

                IF NoOfLoans >= LoanProductTypes."No. of Loans at a Time" then BEGIN
                    ResponseCode := '23';
                    ErrorMessage := 'You have an existing mobile loan with a balance of Ksh ' + FORMAT(LoanBalance) + '. Clear it today and take another loan immediately';

                    EXIT;
                END;
            END;
            /* IF Amount > LoanProductTypes."Max. Loan Amount" THEN BEGIN
                 ResponseCode := '55';
                 ErrorMessage := 'You have Applied More than Max Required';
                 EXIT;
             END;
             IF Amount < LoanProductTypes."Min. Loan Amount" THEN BEGIN
                 ResponseCode := '54';
                 ErrorMessage := 'You have Applied Less than Min Required';
                 EXIT;
             END;*/
            IF Amount > LoanProductTypes."Max. Loan Amount" THEN BEGIN
                ResponseCode := '55';
                ErrorMessage := 'You have Applied More than Max Required';
                EXIT;
            END;
            IF Amount < LoanProductTypes."Min. Loan Amount" THEN BEGIN
                ResponseCode := '54';
                ErrorMessage := 'You have Applied Less than Min Required';
                EXIT;
            END;
            AccBalance[1] := 0;
            AccBalance[2] := 0;

            LoanApplication.RESET;
            LoanApplication.SETRANGE(Posted, TRUE);
            LoanApplication.SETRANGE("Member No.", MemberNo);
            IF LoanApplication.FINDSET THEN BEGIN
                REPEAT
                    PArrears := 0;
                    IArrears := 0;
                    LedgerFeeArr := 0;
                    PenaltyFeeArr := 0;
                    NoOfInstallments := 0;
                    TotalArrears := 0;
                    LoanApplication.CALCFIELDS("Outstanding Balance");
                    IF LoanApplication."Outstanding Balance" > 0 THEN BEGIN
                        //CalculateLoanArrears(LoanApplication."No.", 0D, TODAY, PArrears, IArrears, POverpayment, IOverpayment);
                        GlobalManagement.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, Today, PArrears, IArrears, LedgerFeeArr, PenaltyFeeArr, POverpayment, IOverpayment);
                        TotalArrears := PArrears + IArrears + LedgerFeeArr + PenaltyFeeArr;
                        IF TotalArrears > 0 THEN BEGIN
                            ResponseCode := '23';
                            ErrorMessage := 'Your ' + LoanApplication.Description + ' loan is in default. Please clear Ksh. ' + FORMAT(TotalArrears) + ' to qualify.';
                            EXIT;
                        END;
                    END;
                UNTIL LoanApplication.NEXT = 0;
            END;

            IF LoanProductTypes."Based on Deposits" THEN BEGIN
                AccBalance[1] := GetMemberAccBalance(Member."No.", 'DEP');
                //AccBalance[1] += GetMemberAccBalance(Member."No.", 'SAV');
                IF AccBalance[1] < LoanProductTypes."Minimum Deposit Amount" THEN BEGIN
                    ResponseCode := '24';
                    ErrorMessage := 'You have not reached the minimum required deposits';
                    EXIT;
                END;
                //Available
                CalculateGuaranteedAmount(Member."No.", GuaranteedAmount);
                /*  IF GuaranteedAmount > 0 THEN BEGIN
                      AccBalance[3] := AccBalance[1] - GuaranteedAmount;
                      IF AccBalance[3] < LoanProductTypes."Max. Loan Amount" THEN BEGIN
                          AccBalance[1] *= LoanProductTypes."Loan Deposit Ratio";
                          AccBalance[3] := AccBalance[1] - GuaranteedAmount;
                          AccBalance[2] := AccBalance[3];
                      END ELSE
                          AccBalance[2] := AccBalance[3];
                  END ELSE BEGIN
                      AccBalance[2] := AccBalance[1];
                  END;*///qualifying Amount


                /* END ELSE BEGIN
                     if GuaranteedAmount > AccBalance[1] then
                         AccBalance[2] := 80 / 100 * AccBalance[1]
                     else
                         AccBalance[2] := AccBalance[1];

                 END;*/
                availableDeposits := LoanProductTypes."Loan Deposit Ratio" * AccBalance[1];
                if availableDeposits < GuaranteedAmount then
                    AccBalance[2] := availableDeposits
                else
                    AccBalance[2] := availableDeposits - GuaranteedAmount;

                IF AccBalance[2] <= 0 THEN BEGIN
                    ResponseCode := '39';
                    ErrorMessage := 'You do not have adequate Available Deposits';
                    //  ErrorMessage := Format(AccBalance[2]) + '|' + format(AccBalance[1]) + '|' + Format(GuaranteedAmount) + '|' + Format(LoanProductTypes."Max. Loan Amount") + '|' + Format(AccBalance[3]);
                    EXIT;
                END;

                IF Amount > AccBalance[2] THEN BEGIN
                    ResponseCode := '39';
                    ErrorMessage := 'You have Applied more than Available Deposits';
                    EXIT;
                END;

                IF LoanBalance > 0 THEN BEGIN
                    IF LoanBalance > AccBalance[2] THEN BEGIN
                        ResponseCode := '39';
                        ErrorMessage := 'You have Applied more than Available Deposits';
                        EXIT;
                    END;
                    IF LoanBalance > (AccBalance[2] + Amount) THEN BEGIN
                        ResponseCode := '39';
                        ErrorMessage := 'You have Applied more than Available Deposits';
                        EXIT;
                    END;
                END;
            end;
            IF LoanProductTypes."Graduation Based On" = LoanProductTypes."Graduation Based On"::Deposits THEN BEGIN
                GraduationAmount[1] := AccBalance[2];
                IF (LoanProductTypes."Graduation Qualifying Amount" <> 0) AND (LoanProductTypes."Graduation Factor" <> 0) THEN BEGIN
                    IF GraduationAmount[1] > 0 THEN BEGIN
                        GraduationAmount[2] := GraduationAmount[1] * (LoanProductTypes."Graduation Factor" / 100);
                        GraduationAmount[3] := GraduationAmount[2];
                        GraduationAmount[3] := GraduationAmount[2] * (LoanProductTypes."Graduation Qualifying Amount" / 100);
                        GraduationAmount[3] := GraduationAmount[3];
                        /*  IF GraduationAmount[3] < Amount THEN BEGIN
                              ResponseCode := '52';
                              ErrorMessage := 'You do not qualify for this Loan.';
                              EXIT;
                          END;*/
                        case true of
                            (loanSerries >= 0) and (loanSerries <= 10):
                                eligibleAmt := Round(0.75 * GraduationAmount[3], 0.01, '>');
                            (loanSerries > 10) and (loanSerries <= 20):
                                eligibleAmt := Round(0.80 * GraduationAmount[3], 0.01, '>');
                            (loanSerries > 20) and (loanSerries <= 30):
                                eligibleAmt := Round(0.90 * GraduationAmount[3], 0.001, '>');
                            (loanSerries > 30) and (loanSerries <= 40):
                                eligibleAmt := Round(0.95 * GraduationAmount[3], 0.001, '>');
                            (loanSerries > 40):
                                eligibleAmt := GraduationAmount[3];
                            else
                                eligibleAmt := 0;

                        end;


                        /* if eligibleAmt < LoanProductTypes."Min. Loan Amount" then begin
                             ResponseCode := '52';
                             ErrorMessage := 'You do not qualify for this Loan.';
                         end;*/
                        /* IF Amount < eligibleAmt THEN BEGIN
                             ResponseCode := '52';
                             ErrorMessage := 'You do not qualify for this Loan.';
                             EXIT;
                             ROUND(GraduationAmount[3], 0.01, '>')
                         END;*/
                        IF Amount > eligibleAmt THEN BEGIN
                            ResponseCode := '55';
                            ErrorMessage := 'MB' + Format(MemberNo) + ' You have Applied More than Max Required.You are eligible for Ksh. ' + Format(eligibleAmt);
                            EXIT;
                        END;

                    END ELSE BEGIN
                        ResponseCode := '52';
                        ErrorMessage := 'You do not qualify for this Loan.';
                        EXIT;
                    END;
                END;
            END;
            TotalBalance := LoanBalance + Amount;
            IF LoanProductTypes."Interest Due Posting Group" = '' THEN BEGIN
                ResponseCode := '50';
                ErrorMessage := 'eLoan code does not have Loan Interest Account setup';
                EXIT;
            END;

            BankAccount.RESET;
            BankAccount.SETRANGE("No.", Mobilesetup."Paybill Bank");
            IF not BankAccount.FINDSET THEN BEGIN
                ResponseCode := '51';
                ErrorMessage := 'No Bank has been setup in CBS as Paybill Bank.';
                EXIT;
            END;

            LoanNo := BOSAManagement.postEloan(requestid, MemberNo, Amount, TChargeAmount);

            IF LoanNo <> '' THEN BEGIN
                ResponseCode := '00';
                //  ResponseMessage := '{"Response":"Loan application process completed succesfully", "LoanNo": "' + FORMAT(LoanNo) + '"}';
                ResponseMessage := 'Dear ' + format(Member."Full Name") + '. Your Mobile Loan has been processed. Your total loan balance of Ksh. ' + Format(fnGetLoanOutstandingBalance(LoanNo)) + ' is due on ' + fnGetExpectedDateOfCompletion(LoanNo) + '. Facility fee charged is Ksh. ' + Format(fnGetLoanOutstandingInterest(LoanNo)) + '.';
                CreateMobileBankingEntries(requestid, Text001, PhoneNo, 730, Amount, TChargeAmount, LoanNo, '', '');
                EXIT;
            END ELSE BEGIN
                ResponseCode := '48';
                ErrorMessage := 'eLoan Account not Created';

                EXIT;
            END;
        end;
    end;

    local procedure fnGetLoanOutstandingBalance(loanNo: code[39]) outbal: Decimal
    var
        lnApplication: Record "Loan Application";
    begin
        lnApplication.Reset();
        lnApplication.SetRange("No.", loanNo);
        if lnApplication.Find('-') then
            lnApplication.CalcFields("Outstanding Balance");
        outbal := lnApplication."Outstanding Balance";
        exit(outbal);
    end;

    local procedure fnGetLoanOutstandingInterest(loanNo: code[39]) outint: Decimal
    var
        lnApplication: Record "Loan Application";
    begin
        lnApplication.Reset();
        lnApplication.SetRange("No.", loanNo);
        if lnApplication.Find('-') then
            lnApplication.CalcFields("Outstanding Interest");
        outint := lnApplication."Outstanding Interest";
        exit(outint);
    end;

    local procedure fnGetExpectedDateOfCompletion(loanNo: code[39]) dueDate: Text
    var
        lnApplication: Record "Loan Application";
    begin
        lnApplication.Reset();
        lnApplication.SetRange("No.", loanNo);
        if lnApplication.Find('-') then
            dueDate := Format(lnApplication."Date of Completion", 0, '<Day,2>/<Month,2>/<Year4>');
        exit(dueDate);
    end;

    local procedure GetMemberAccBalance(MemberNo: Code[20]; AccountTypeCode: Code[20]) TotalBalance: Decimal
    var
        TotalBalances: Decimal;
        AccountTypes: Record "Account Type";
        Vendor: Record Vendor;
    begin
        TotalBalances := 0;
        AccountTypes.RESET;
        IF AccountTypeCode = 'DEP' THEN
            AccountTypes.SETRANGE(Type, AccountTypes.Type::"Member Deposit");
        IF AccountTypeCode = 'SAV' THEN
            AccountTypes.SETFILTER(Type, '%1', AccountTypes.Type::Savings);

        IF AccountTypes.FINDSET THEN BEGIN
            REPEAT
                Vendor.RESET;
                Vendor.SETRANGE("Member No.", MemberNo);
                Vendor.SETRANGE("Account Type", AccountTypes.Code);
                IF Vendor.FINDSET THEN BEGIN
                    REPEAT
                        Vendor.CALCFIELDS(Balance);
                        TotalBalances += Vendor.Balance;
                    UNTIL Vendor.NEXT = 0;
                END;
            UNTIL AccountTypes.NEXT = 0;
        END;
        EXIT(TotalBalances);
    end;

    procedure GetCustomerAccounts(VAR MemberID: Text[200]; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text) Success: Integer
    var
        Member: Record Member;
        Member2: Record Member;
        LoanProductTypes: Record "Loan Product Type";
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        LoanApp: Record "Loan Application";
        Found: Boolean;
        hasaccounts: Boolean;

    begin
        //Member.RESET;
        //Member.SETRANGE("No.", MemberID);

        //Member.SetRange(Status, Member.Status::Active);

        if StrLen(MemberID) > 20 then begin
            ResponseCode := '14';
            ErrorMessage := 'Member does not exist';
            EXIT;
        end else begin

            IF NOT Member.GET(MemberID) THEN BEGIN
                ResponseCode := '14';
                ErrorMessage := 'Member does not exist';
                EXIT;
            END else begin
                IF Member.Status <> Member.Status::Active THEN BEGIN
                    ResponseCode := '14';
                    ErrorMessage := 'Member not active';
                    EXIT;
                END;


                Found := false;
                Vendor.RESET;
                Vendor.SETRANGE("Member No.", Member."No.");
                IF NOT Vendor.FIND('-') THEN BEGIN
                    ResponseCode := '14';
                    ErrorMessage := 'Member has no accounts attached';
                    EXIT;
                END ELSE BEGIN
                    ResponseCode := '000';
                    ResponseMessage := '{"member" :{';
                    ResponseMessage +=
                                    '"name" :"' + Member."Full Name" +
                                    '","nationalId" : "' + Member."National ID" +
                                    '","mobileNo" : "' + Member."Phone No." +
                                    '"}, "accounts" :[';

                    REPEAT
                        Vendor.CalcFields(Balance);
                        accountTypes.RESET;
                        accountTypes.SETRANGE(Code, Vendor."Account Type");
                        accountTypes.SetFilter(Type, '%1|%2|%3', accountTypes.Type::Savings, AccountTypes.Type::"Share Capital", AccountTypes.Type::"Member Deposit");
                        IF accountTypes.FINDFIRST THEN BEGIN
                            Found := true;
                            ResponseMessage +=
                                            '{' +
                                                '"accountNo": "' + Vendor."No." +
                                                '","accountName": "' + Vendor.Name +
                                                '","balance" : "' + FORMAT(Vendor.Balance) +
                                                    '"},';
                        END;
                    UNTIL Vendor.NEXT = 0;
                    if Found = true then
                        ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
                // ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                ResponseMessage += ',';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);


                ResponseMessage += '], "loans":[';
                LoanApp.Reset();
                LoanApp.SetFilter("Outstanding Balance", '>%1', 0);
                LoanApp.SetRange("Member No.", Member."No.");
                LoanApp.SetRange(Posted, true);
                if LoanApp.FindSet() then begin
                    Found := False;
                    repeat

                        ResponseMessage += '{' +
                                                '"loanNo": "' + LoanApp."No." +
                                                '","loanProductType": "' + LoanApp."Loan Product Type" +
                                                '","loanName": "' + LoanApp."Description" +

                                            '"},';

                    until LoanApp.next = 0;
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1)
                End;
                //ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                // ResponseMessage += ',';
                // ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);

                ResponseMessage += '], "juniormembers":[';
                Member2.RESET;
                Member2.SETRANGE("Parent Phone No.", Member."Phone No.");
                // Member2.SetRange(Category, Member2.Category::Individual);
                Member2.SetRange("Age Classification", Member2."Age Classification"::Junior);
                IF Member2.FindSet() THEN begin
                    repeat
                        ResponseMessage += '{' +
                                        '"JMemberNo": "' + Member2."No." +
                                        '","Jname": "' + Member2."Full Name" +
                                        '",';
                        Vendor.RESET;
                        Vendor.SETRANGE("Member No.", Member2."No.");
                        IF Vendor.FindSet() THEN BEGIN
                            REPEAT
                                // ResponseMessage += '];"JuniorMembers":[';
                                Vendor.CalcFields(Balance);
                                accountTypes.RESET;
                                accountTypes.SETRANGE(Code, Vendor."Account Type");
                                accountTypes.SETRANGE(Type, accountTypes.Type::"Member Deposit");
                                AccountTypes.SetFilter("Sub Type", '<>%1', AccountTypes."Sub Type"::Virtual);
                                IF accountTypes.FINDFIRST THEN BEGIN
                                    ResponseMessage +=
                                                        '"accountNo": "' + Vendor."No." +
                                                        '","accountName": "' + Vendor.Name +
                                                        '","balance" : "' + FORMAT(Vendor.Balance) +
                                                    '"},';
                                END;
                            UNTIL Vendor.NEXT = 0;
                            ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                            ResponseMessage += ',';
                            //ResponseMessage += '"},';
                        end;
                    until Member2.Next = 0;
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
                ResponseMessage += ']}';
                EXIT;
            end;
        end;
    end;

    local procedure CalculateGuaranteedAmount(MemberNo: Code[20]; VAR
                                                                      GuaranteedAmount: Decimal)
    var
        LoanGuarantor: Record "Loan Guarantor";
        OtherAmountRatio: Decimal;
        Cust: Record Customer;
        LoanApplication: Record "Loan Application";
    begin
        GuaranteedAmount := 0;
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Member No.", MemberNo);
        IF LoanGuarantor.FINDSET THEN BEGIN
            REPEAT
                OtherAmountRatio := 0;
                IF Cust.GET(LoanGuarantor."Loan No.") THEN BEGIN
                    Cust.CALCFIELDS(Cust.Balance);
                    LoanApplication.GET(LoanGuarantor."Loan No.");
                    IF (LoanApplication."Approved Amount" > 0) AND (LoanApplication.Posted = TRUE) THEN
                        OtherAmountRatio := LoanGuarantor."Amount To Guarantee" / LoanApplication."Approved Amount";
                    IF Cust.Balance > 0 THEN
                        GuaranteedAmount += (OtherAmountRatio * Cust.Balance);
                END;
            UNTIL LoanGuarantor.NEXT = 0;
        END;
    end;



    procedure GetMemberEligibility(VAR PhoneNo: Code[20]; VAR eLoanCode: Code[20]; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        Member: Record Member;
        MemberNo: Code[20];
        MobileBankingMember: Record "Mobile Banking Member";
        RemainingBalance: Decimal;
        LoanProductTypes: Record "Loan Product Type";
        EligibleAmount: Decimal;
        NextDate: Date;
        LoanDefaultRecovery: Record "Loan Defaulter Entry";
        OutsLoanBalances: Decimal;
        LoanApplication: Record "Loan Application";
        AccBalance: array[5] of Decimal;
        GuaranteedAmount: decimal;
        PArrears: Decimal;
        IArrears: Decimal;
        NoOfInstallments: Integer;
        LoanNo: Code[20];
        BosaManagement: Codeunit "BOSA Management";
        TotalBalance: Decimal;
        CustRec: Record Customer;
        Text001: TextConst ENU = 'Loan Application & Disbursement to MPESA';
        Mobilesetup: Record "Mobile Banking Setup";
        GraduationAmount: array[5] of Decimal;
        MemberEligibleAmount: array[5] of Decimal;
        POverpayment: Decimal;
        IOverpayment: Decimal;
        memberDeposits: Decimal;
        availableDeposits: Decimal;
        loanSerries: Integer;
        eligbleAmount: Decimal;
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", PhoneNo);
        //  Member.SetFilter(Status, '%1', Member."Dormancy Status"::Active);
        IF Member.FINDSET THEN BEGIN
            MemberNo := Member."No.";
            /*IF Member."Dormancy Status" <> Member."Dormancy Status"::Active THEN begin
                ResponseCode := '00';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            end;*/
            if Member.Category <> Member.Category::Individual then begin
                ResponseCode := '52';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            end;

            MobileBankingMember.RESET;
            MobileBankingMember.SETRANGE("Phone No.", Member."Phone No.");
            MobileBankingMember.SETRANGE(Status, MobileBankingMember.Status::Active);
            IF NOT MobileBankingMember.FINDFIRST THEN BEGIN
                ResponseCode := '00';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            END;

            MemberNo := Member."No.";
            NextDate := 0D;
            IF LoanProductTypes.GET(eLoanCode) THEN BEGIN
                EligibleAmount := LoanProductTypes."Max. Loan Amount";
            END ELSE BEGIN
                ResponseCode := '00';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            END;
            LoanProductTypes.GET(eLoanCode);
            IF Member."Date of Registration" <> 0D THEN
                NextDate := Member."Date of Registration";

            IF NextDate <> 0D THEN BEGIN
                IF CALCDATE(LoanProductTypes."Min. Membership period", NextDate) > TODAY THEN BEGIN
                    ResponseCode := '00';
                    RemainingBalance := 0;
                    ResponseMessage := FORMAT(RemainingBalance);
                    EXIT;
                END;
            END;

            OutsLoanBalances := 0;
            RemainingBalance := 0;
            memberDeposits := 0;
            availableDeposits := 0;
            loanSerries := 0;
            eligbleAmount := 0;
            AccBalance[2] := 0;

            AccBalance[1] := GetMemberAccBalance(Member."No.", 'DEP');
            availableDeposits := AccBalance[1] * LoanProductTypes."Loan Deposit Ratio";


            CustRec.RESET;
            CustRec.SETRANGE("Member No.", Member."No.");
            CustRec.SETRANGE("Customer Posting Group", LoanProductTypes.Code);
            CustRec.SETRANGE(Status, CustRec.Status::Active);
            IF CustRec.FINDSET THEN BEGIN
                REPEAT
                    CustRec.CALCFIELDS(Balance);

                    //  LoanBalance += CustRec.Balance;
                    IF CustRec.Balance > 0 THEN
                        loanSerries += 1;
                UNTIL CustRec.NEXT = 0;
            END;


            LoanApplication.RESET;
            LoanApplication.SETRANGE(Posted, TRUE);
            LoanApplication.SETRANGE("Member No.", MemberNo);
            IF LoanApplication.FINDSET THEN BEGIN
                TotalArrears := 0;
                REPEAT
                    PArrears := 0;
                    IArrears := 0;
                    LedgerFeeArr := 0;
                    PenaltyFeeArr := 0;

                    NoOfInstallments := 0;
                    LoanApplication.CALCFIELDS("Outstanding Balance");
                    IF LoanApplication."Outstanding Balance" > 0 THEN BEGIN

                        IF LoanApplication."Loan Product Type" = eLoanCode THEN BEGIN
                            OutsLoanBalances += LoanApplication."Outstanding Balance";
                        END else begin
                            //CalculateLoanArrears(LoanApplication."No.", 0D, TODAY, PArrears, IArrears, POverpayment, IOverpayment);
                            GlobalManagement.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, Today, PArrears, IArrears, LedgerFeeArr, PenaltyFeeArr, POverpayment, IOverpayment);
                            TotalArrears += PArrears + IArrears + LedgerFeeArr + PenaltyFeeArr;
                        end;
                    END;
                UNTIL LoanApplication.NEXT = 0;
                IF TotalArrears > 0 THEN BEGIN
                    ResponseCode := '00';
                    RemainingBalance := 0;
                    ResponseMessage := FORMAT(RemainingBalance);
                    EXIT;
                END;
            END;

            IF AccBalance[1] <= 0 THEN BEGIN
                ResponseCode := '00';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            END;

            //Available
            CalculateGuaranteedAmount(Member."No.", GuaranteedAmount);

            /*  IF GuaranteedAmount > 0 THEN BEGIN
                  AccBalance[3] := AccBalance[1] - GuaranteedAmount;
                  IF AccBalance[3] < LoanProductTypes."Max. Loan Amount" THEN BEGIN
                      AccBalance[1] := AccBalance[1] * LoanProductTypes."Loan Deposit Ratio";
                      AccBalance[3] := AccBalance[1] - GuaranteedAmount;
                      AccBalance[2] := AccBalance[3];
                  END ELSE
                      AccBalance[2] := AccBalance[3];
                  //AccBalance[2] := AccBalance[1] - GuaranteedAmount;
              END ELSE BEGIN
                  AccBalance[2] := AccBalance[1];
              END;*/

            /*  memberDeposits := GetMemberAccBalance(Member."No.", 'DEP');
              if GuaranteedAmount > memberDeposits then
                  AccBalance[2] := 80 / 100 * memberDeposits
              else
                  AccBalance[2] := AccBalance[2];
  */
            if availableDeposits < GuaranteedAmount then
                AccBalance[2] := availableDeposits
            else
                AccBalance[2] := availableDeposits - GuaranteedAmount;
            IF AccBalance[2] <= 0 THEN BEGIN
                ResponseCode := '00';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            END;
            IF AccBalance[2] < LoanProductTypes."Min. Loan Amount" THEN BEGIN
                ResponseCode := '00';
                RemainingBalance := 0;
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            END ELSE BEGIN
                //    IF AccBalance[2] > LoanProductTypes."Max. Loan Amount" THEN
                //      AccBalance[2] := LoanProductT  ypes."Max. Loan Amount";
                MemberEligibleAmount[1] := LoanProductTypes."Min. Loan Amount";
                MemberEligibleAmount[2] := LoanProductTypes."Max. Loan Amount";
                IF LoanProductTypes."Graduation Based On" = LoanProductTypes."Graduation Based On"::Deposits THEN BEGIN
                    IF AccBalance[2] <= 0 THEN BEGIN
                        ResponseCode := '00';
                        RemainingBalance := 0;
                        ResponseMessage := FORMAT(RemainingBalance);
                        EXIT;
                    END;
                    IF AccBalance[2] < LoanProductTypes."Minimum Deposit Amount" THEN BEGIN
                        ResponseCode := '00';
                        RemainingBalance := 0;
                        ResponseMessage := FORMAT(RemainingBalance);
                        EXIT;
                    END;
                    GraduationAmount[1] := AccBalance[2];
                    /*  IF (LoanProductTypes."Graduation Factor" > 0) AND (LoanProductTypes."Graduation Qualifying Amount" > 0) THEN BEGIN
                          GraduationAmount[2] := GraduationAmount[1] * (LoanProductTypes."Graduation Factor" / 100);
                          IF GraduationAmount[2] < LoanProductTypes."Max. Loan Amount" * 2 THEN
                              GraduationAmount[3] := GraduationAmount[2];

                          GraduationAmount[3] := GraduationAmount[2] * (LoanProductTypes."Graduation Qualifying Amount" / 100);
                          IF GraduationAmount[3] < MemberEligibleAmount[1] THEN BEGIN
                              ResponseCode := '00';
                              RemainingBalance := 0;
                              ResponseMessage := FORMAT(RemainingBalance);
                              EXIT;
                          END ELSE BEGIN
                              IF GraduationAmount[3] > MemberEligibleAmount[2] THEN
                                  GraduationAmount[3] := MemberEligibleAmount[2]
                              ELSE
                                  GraduationAmount[3] := GraduationAmount[3];
                              ResponseCode := '00';
                              RemainingBalance := ROUND(GraduationAmount[3], 0.01, '>');
                              ResponseMessage := FORMAT(RemainingBalance);

                              EXIT;
                          END;
                      END;*/
                    IF (LoanProductTypes."Graduation Factor" > 0) AND (LoanProductTypes."Graduation Qualifying Amount" > 0) THEN BEGIN
                        GraduationAmount[2] := GraduationAmount[1] * (LoanProductTypes."Graduation Factor" / 100);
                        /* IF GraduationAmount[2] < LoanProductTypes."Max. Loan Amount" * 2 THEN
                             GraduationAmount[3] := GraduationAmount[2];*/

                        GraduationAmount[3] := GraduationAmount[2] * (LoanProductTypes."Graduation Qualifying Amount" / 100);
                        /* IF GraduationAmount[3] < MemberEligibleAmount[1] THEN BEGIN
                             ResponseCode := '00';
                             RemainingBalance := 0;
                             ResponseMessage := FORMAT(RemainingBalance);
                             EXIT;
                         END ELSE BEGIN
                             IF GraduationAmount[3] > MemberEligibleAmount[2] THEN
                                 GraduationAmount[3] := MemberEligibleAmount[2]
                             ELSE
                                 GraduationAmount[3] := GraduationAmount[3];
                             ResponseCode := '00';
                             RemainingBalance := ROUND(GraduationAmount[3], 0.01, '>');
                             ResponseMessage := FORMAT(RemainingBalance);

                             EXIT;
                         END;*/
                        case true of
                            (loanSerries >= 0) and (loanSerries <= 10):
                                eligbleAmount := 0.75 * GraduationAmount[3];
                            (loanSerries > 10) and (loanSerries <= 20):
                                eligbleAmount := 0.80 * GraduationAmount[3];
                            (loanSerries > 20) and (loanSerries <= 30):
                                eligbleAmount := 0.90 * GraduationAmount[3];
                            (loanSerries > 30) and (loanSerries <= 40):
                                eligbleAmount := 0.95 * GraduationAmount[3];
                            (loanSerries > 40):
                                eligbleAmount := GraduationAmount[3];
                            else
                                eligbleAmount := 0;

                        end;

                    END;
                END;


                IF eligbleAmount > LoanProductTypes."Max. Loan Amount" THEN
                    EligibleAmount := LoanProductTypes."Max. Loan Amount"
                ELSE
                    if eligbleAmount < LoanProductTypes."Min. Loan Amount" then
                        EligibleAmount := LoanProductTypes."Min. Loan Amount"
                    else
                        EligibleAmount := eligbleAmount;

                ResponseCode := '00';
                RemainingBalance := ROUND(EligibleAmount, 0.01, '>');
                ResponseMessage := FORMAT(RemainingBalance);
                EXIT;
            END;
            //To
        END ELSE BEGIN
            ResponseCode := '08';
            ErrorMessage := 'Member with phone no ' + PhoneNo + ' not found';
            EXIT;
        END;

    end;

    procedure GeteLoanTypes(VAR MobilePhoneNo: Text; VAR ResponseCode: Text; VAR ResponseMessage: Text; VAR ErrorMessage: Text)
    var
        LoanProductTypes: Record "Loan Product Type";
    begin
        LoanProductTypes.RESET;
        LoanProductTypes.SETRANGE("E-Loan", TRUE);
        //LoanProductTypes.SETRANGE(Active,TRUE);
        IF NOT LoanProductTypes.FINDSET THEN BEGIN
            ResponseCode := '09';
            ErrorMessage := 'eLoan Types not setup';
            EXIT;
        END;



        ResponseMessage := '{"eloanTypes" :[';
        LoanProductTypes.RESET;
        LoanProductTypes.SETRANGE("E-Loan", TRUE);
        IF LoanProductTypes.FINDSET THEN BEGIN
            REPEAT

                ResponseMessage +=
                                '{' +
                                    '"LoanCode": "' + LoanProductTypes.Code +
                                    '","LoanName": "' + LoanProductTypes.Description +
                                '"},';

            UNTIL LoanProductTypes.NEXT = 0;
        END;
        ResponseCode := '00';
        ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
        ResponseMessage += ']}';
        EXIT;
    end;

    local PROCEDURE CalculateLoanArrears(LoanNo: Code[20]; StartDate: Date; EndDate: Date; VAR PArrears: Decimal; VAR IArrears: Decimal; VAR POverpayment: Decimal; VAR IOverpayment: Decimal);
    VAR
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InstallmentDue: ARRAY[4] OF Decimal;
        InstallmentPaid: ARRAY[4] OF Decimal;
        PPaidPreMigration: Decimal;
        LoanApp: Record 50101;
        RemainingBalance: Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        HasSchedule: Boolean;
    BEGIN
        InstallmentDue[1] := 0;
        InstallmentDue[2] := 0;
        InstallmentPaid[1] := 0;
        InstallmentPaid[2] := 0;
        PArrears := 0;
        IArrears := 0;
        POverpayment := 0;
        IOverpayment := 0;
        RemainingBalance := 0;
        HasSchedule := false;

        TransactionTypeCodeSetup.Get();
        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.SETFILTER("Repayment Date", '..%1', EndDate);
        IF LoanRepaymentSchedule.FINDLAST THEN BEGIN
            //LoanRepaymentSchedule.CALCSUMS(LoanRepaymentSchedule."Principal Installment");
            InstallmentDue[1] := LoanRepaymentSchedule."Loan Amount";
            //InstallmentDue[2]+=LoanRepaymentSchedule."Interest Installment";
            RemainingBalance := InstallmentDue[1] - LoanRepaymentSchedule."Principal Installment";
            InstallmentDue[1] := RemainingBalance;
            HasSchedule := true;
        END;

        PPaidPreMigration := 0;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Transaction Type Code", TransactionTypeCodeSetup."New Loan");
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            CustLedgerEntry.CALCFIELDS("Amount (LCY)");

            LoanApp.RESET;
            LoanApp.SETRANGE(LoanApp."No.", LoanNo);
            IF LoanApp.FINDFIRST THEN BEGIN
                IF LoanApp."Approved Amount" > CustLedgerEntry."Amount (LCY)" THEN
                    PPaidPreMigration := LoanApp."Approved Amount" - CustLedgerEntry."Amount (LCY)";
            END;
        END;


        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
        IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Amount (LCY)");
                IF (CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") OR
                  (CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment") THEN
                    InstallmentPaid[1] += CustLedgerEntry."Amount (LCY)";
                IF CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                    InstallmentPaid[2] += CustLedgerEntry."Amount (LCY)";
                IF CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                    InstallmentDue[2] += CustLedgerEntry."Amount (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;
        END;
        IF PPaidPreMigration > 0 THEN
            InstallmentPaid[1] := InstallmentPaid[1] + PPaidPreMigration;

        //MESSAGE('Principal Paid Total %1 Interest Paid Total %2',InstallmentPaid[1],InstallmentDue[1]);

        IF (InstallmentDue[1] < ABS(InstallmentPaid[1])) and (HasSchedule = true) THEN BEGIN
            PArrears := ABS(InstallmentPaid[1]) - InstallmentDue[1];
            POverpayment := 0;
        END ELSE BEGIN
            POverpayment := InstallmentDue[1] - ABS(InstallmentPaid[1]);
            PArrears := 0;
        END;
        IF InstallmentDue[2] > ABS(InstallmentPaid[2]) THEN BEGIN
            IArrears := InstallmentDue[2] - ABS(InstallmentPaid[2]);
            IOverpayment := 0;
        END ELSE BEGIN
            IOverpayment := ABS(InstallmentPaid[2]) - InstallmentDue[2];
            IArrears := 0;
        END;
    END;

    var
        GlobalManagement: Codeunit "Global Management";
        POverpayment: Decimal;
        IOverpayment: decimal;
        LedgerFeeArr: Decimal;
        PenaltyFeeArr: Decimal;
        TotalArrears: Decimal;
}