codeunit 50021 Internet_Banking
{
    trigger OnRun();
    begin

    end;

    var
        Member: Record Member;
        GlobalM: Codeunit "Global Management";
        DimensionValue: Record "Dimension Value";
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        LoanClassifications: Record "Loan Classification Entry";
        LoanApp: Record "Loan Application";
        LoanGuarantors: Record "Loan Guarantor";
        i: Integer;
        MessageResponse: Text;
        CodeResponse: Text;
        Member2: Record Member;
        Customer: Record Customer;
        NextofKin: Record "Beneficiary Type";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        CustomerLedgerEntry2: Record "Cust. Ledger Entry";
        OpeningBal: Decimal;
        TransTypeCodeSetup: Record "Transaction Type Code Setup";
        date2: Date;
        LoanProductTypes: Record "Loan Product Type";
        RSchedule: Record "Loan Repayment Schedule";
        LoanAmount: Decimal;
        RepayPeriod: Integer;

        LoanSetup: Record "Loan Application Setup";
        InstalNo: Integer;
        Balance: Decimal;
        Insurance: Decimal;
        Interest: Decimal;
        Principal: Decimal;
        PrincipalInterest: Decimal;
        Principal1: Decimal;
        LBalance: Decimal;
        RunDate: Date;
        RepayInterval: Code[20];
        chaitotal: Decimal;
        RepayCode: Integer;
        chaipower: Decimal;
        GetLoanNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CustomerBD: Record Customer;
        Loanstring: Text;
        RunningBal: Decimal;
        j: Integer;
        rebatedate: Date;
        QualifyingAmount: Decimal;
        GrossRebates: Decimal;
        CompanyInformation: Record "Company Information";
        RebateDate2: Date;
        RebateDate3: Date;
        RebateAmount1: Decimal;
        RebateAmount2: Decimal;
        TotalDeposit: Decimal;
        TotalQualifyingAmount: Decimal;
        TotalGrossRebates: Decimal;
        RebateDate4: Date;
        MemberDividends: Record "Dividend Line";
        BOSAManagement: Codeunit "BOSA Management";
        CBSSetup: Record "Global Setup";
        UserActivateDate: Date;
        Status: Integer;
        OTP: Text;
        OTPTime: Time;
        Password: Text;
        EconomicSector: Record "Economic Sector";
        EconomicSectorCategory: Record "Economic Sector Category";
        EconomicSectorSubCategory: Record "Economic Sector Sub-Category";
        OtherGuaranteedAmt: Decimal;
        AccBal: Decimal;
        NetAccBal: Decimal;
        Security: Record "Security Type";
        CustL: Record "Cust. Ledger Entry";
        LoanPrincipal: Decimal;
        LoanInterest: Decimal;
        DepositBalance: Decimal;
        SavingsBalance: Decimal;
        AccountType: Record "Account Type";
        MBanking: Record "Mobile Banking Member";
        RegisteredMembers: Integer;
        MobileMembers: Integer;
        NewApplications: Integer;
        PendingDisbursals: Integer;
        DisbursedLoans: Integer;
        RejectedLoans: Integer;
        No: Integer;
        Int: Integer;
        MembBal: Decimal;
        Loans: Record "Loan Application";
        LoanBalances: Decimal;
        LoanTopup: Record "Loan Refinancing Entry";
        LoanSecurity: Record "Loan Collateral";
        AppraisalComments: Record "Loan Appraisal Comment";
        FILESPATH: Label 'C:\BOSA\';
        myReport: Report "Loan Appraisal Report";
        EmptyData: Text;
        SelectPictureTxt: Label 'Select a file to upload';

    procedure SelfRegistration(var FirstMemberName: Text; var SecondMemberName: Text; var MemberID: Text; var MemberPhone: Text; var MemberEmail: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
        EntryNo: Integer;
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            if Member."National ID" = '' then begin
                ResponseCode := '01';
                ResponseMessage := 'Member ID must have a value. Kindly Update!';
                exit;
            end;
        end;
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            if Member."Phone No." <> MemberPhone then begin
                ResponseCode := '01';
                ResponseMessage := 'Mobile Number :' + MemberPhone + ' Provided is not Correct. Please update it!';
                exit;
            end;
        end;


        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE("National ID", MemberID);
        InternetBankingApp.SETRANGE(Activated, false);
        if InternetBankingApp.FINDFIRST then begin
            ResponseCode := '00';
            ResponseMessage := 'Member Internet Banking Application Already Exist Pending Activation!';
            exit;
        end;

        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE("National ID", MemberID);
        InternetBankingApp.SETRANGE(Activated, true);
        if InternetBankingApp.FINDFIRST then begin
            ResponseCode := '00';
            ResponseMessage := 'Member Internet Banking Application Already Activated!';
            exit;
        end;

        //Register Member============================================================================
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
            ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
            ResponseMessage := ResponseMessage + '"IdentificationNo":"' + Member."National ID" + '",';
            ResponseMessage := ResponseMessage + '"Address":"' + Member."Postal Address" + '",';
            ResponseMessage := ResponseMessage + '"City":"' + Member."Physical Address" + '",';
            ResponseMessage := ResponseMessage + '"Nationality":"' + 'KE",';
            ResponseMessage := ResponseMessage + '"MobileNo":"' + Member."Phone No." + '",';
            ResponseMessage := ResponseMessage + '"Gender":"' + FORMAT(Member.Gender) + '",';
            ResponseMessage := ResponseMessage + '"eMail":"' + MemberEmail + '",';
            ResponseMessage := ResponseMessage + '"DateOfBirth":"' + FORMAT(Member."Date of Birth") + '"';
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", 1);
            DimensionValue.SETRANGE(Code, Member."Global Dimension 1 Code");
            if DimensionValue.FINDSET then begin
                ResponseMessage := ResponseMessage + ',"BranchCode":"' + Member."Global Dimension 1 Code" + '",';
                ResponseMessage := ResponseMessage + '"BranchName":"' + DimensionValue.Name + '"';
            end;

            //Insert Member IB App============================================================================
            InternetBankingApp.RESET;
            if InternetBankingApp.FINDLAST then begin
                EntryNo := InternetBankingApp."Entry No" + 1;
            end else begin
                EntryNo := 1;
            end;

            Member.RESET;
            Member.SETRANGE("National ID", MemberID);
            if Member.FINDFIRST then begin
                InternetBankingApp.INIT;
                InternetBankingApp."Entry No" := EntryNo;
                InternetBankingApp."Member no" := Member."No.";
                InternetBankingApp."Member Name" := Member."Full Name";
                InternetBankingApp."National ID" := MemberID;
                InternetBankingApp."Phone No" := MemberPhone;
                InternetBankingApp.Email := MemberEmail;
                InternetBankingApp."Application Date" := TODAY;
                InternetBankingApp."Served By" := USERID;
                if InternetBankingApp.INSERT(true) then begin
                    ResponseMessage := ResponseMessage + ',"Application Created Successfuly"}';
                end;
            end;
            ResponseCode := '00';
            //End Insert Member IB App========================================================================
        end;

        //End Register Member========================================================================
    end;

    local procedure CreateIBApplication(var FirstMemberName: Text; var SecondMemberName: Text; var MemberID: Text; var MemberPhone: Text; var MemberEmail: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
        EntryNo: Integer;
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            if Member."Phone No." <> MemberPhone then begin
                ResponseCode := '01';
                ResponseMessage := 'Mobile Number :' + MemberPhone + ' Provided is not Correct. Please update it!';
                exit;
            end;
        end;

        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE("National ID", MemberID);
        InternetBankingApp.SETRANGE(Activated, false);
        if InternetBankingApp.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Internet Banking Application Already Exist!';
            exit;
        end;

        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE("National ID", MemberID);
        InternetBankingApp.SETRANGE(Activated, true);
        if InternetBankingApp.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member Already Activated For Internet Banking!';
            exit;
        end;
        //Insert Member IB App============================================================================

        InternetBankingApp.RESET;
        if InternetBankingApp.FINDLAST then begin
            EntryNo := InternetBankingApp."Entry No" + 1;
        end else begin
            EntryNo := 1;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDFIRST then begin
            InternetBankingApp.INIT;
            InternetBankingApp."Entry No" := EntryNo;
            InternetBankingApp."Member no" := Member."No.";
            InternetBankingApp."Member Name" := Member."Full Name";
            InternetBankingApp."National ID" := MemberID;
            InternetBankingApp."Phone No" := MemberPhone;
            InternetBankingApp.Email := MemberEmail;
            InternetBankingApp."Application Date" := TODAY;
            InternetBankingApp."Served By" := USERID;
            if InternetBankingApp.INSERT(true) then begin
                ResponseMessage := 'Application Created Successfuly';
                ResponseCode := '00';
            end;
        end;
        //End Insert Member IB App========================================================================
    end;

    procedure UpdateIBApplicationActDate(var MemberID: Text; var UserActivateDate: Date; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDFIRST then begin
            InternetBankingApp.RESET;
            InternetBankingApp.SETRANGE("National ID", MemberID);
            if InternetBankingApp.FINDFIRST then begin
                InternetBankingApp.Activated := true;
                InternetBankingApp."User Activation Date" := UserActivateDate;
                InternetBankingApp."User Activation Time" := TIME;
                InternetBankingApp.MODIFY;
                ResponseMessage := 'Update Successful';
                ResponseCode := '00';
            end;
        end;
    end;

    procedure UpdateIBApplicationStatus(var MemberID: Text; var Status: Integer; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDFIRST then begin
            InternetBankingApp.RESET;
            InternetBankingApp.SETRANGE("National ID", MemberID);
            if InternetBankingApp.FINDFIRST then begin
                InternetBankingApp.Activated := true;
                InternetBankingApp.Status := Status;
                InternetBankingApp.MODIFY;
                ResponseMessage := 'Update Successful';
                ResponseCode := '00';
            end;
        end;
    end;

    procedure UpdateIBApplicationOTP(var MemberID: Text; var OTP: Text; var OTPTime: Time; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDFIRST then begin
            InternetBankingApp.RESET;
            InternetBankingApp.SETRANGE("National ID", MemberID);
            if InternetBankingApp.FINDFIRST then begin
                InternetBankingApp.Activated := true;
                InternetBankingApp.OTP := OTP;
                InternetBankingApp."OTP Time" := OTPTime;
                InternetBankingApp.MODIFY;
                ResponseMessage := 'Update Successful';
                ResponseCode := '00';
            end;
        end;
    end;

    procedure UpdateIBApplicationPassword(var MemberID: Text; var Password: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDFIRST then begin
            InternetBankingApp.RESET;
            InternetBankingApp.SETRANGE("National ID", MemberID);
            if InternetBankingApp.FINDFIRST then begin
                InternetBankingApp.Activated := true;
                InternetBankingApp.Status := 2;
                InternetBankingApp.Password := Password;
                InternetBankingApp.MODIFY;
                ResponseMessage := 'Update Successful';
                ResponseCode := '00';
            end;
        end;
    end;

    procedure MemberDetails(var MemberID: Text; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            if Member."National ID" = '' then begin
                ResponseCode := '01';
                ResponseMessage := 'Member ID must have a value. Kindly Update!';
                exit;
            end;
        end;
        //Register Member============================================================================
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
            ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
            ResponseMessage := ResponseMessage + '"MemberStatus":"' + FORMAT(Member.Status) + '",';
            IF Member."Sub Category" <> Member."Sub Category"::" " then
                ResponseMessage := ResponseMessage + '"MemberType":"' + FORMAT(Member."Sub Category") + '",'
            else
                ResponseMessage := ResponseMessage + '"MemberType":"' + FORMAT(Member.Category) + '",';
            //Next Of Kin =======================================================================================
            ResponseMessage := ResponseMessage + '"NextOfKin":[';
            NextofKin.RESET;
            NextofKin.SETRANGE(NextofKin."Application No.", Member."Application No.");
            NextofKin.SETRANGE(Type, NextofKin.Type::"Next of Kin");
            if NextofKin.FINDSET then begin
                repeat
                    ResponseMessage := ResponseMessage + '{"Name":"' + NextofKin.Name + '",';
                    //ResponseMessage:=ResponseMessage+'"Address":"' '",';
                    ResponseMessage := ResponseMessage + '"Telephone":"' + NextofKin."Phone No." + '",';
                    ResponseMessage := ResponseMessage + '"eMail":"' + ' ' + '",';
                    ResponseMessage := ResponseMessage + '"ID_Passport":"' + Format(NextofKin."National ID") + '",';
                    ResponseMessage := ResponseMessage + '"Date_of_Birth":"' + FORMAT(TODAY) + '",';
                    ResponseMessage := ResponseMessage + '"Relationship":"' + FORMAT(NextofKin.Relationship) + '"},';
                until NextofKin.NEXT = 0;
                if STRPOS(ResponseMessage, 'Relationship') <> 0 then begin
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
            end;
            ResponseMessage := ResponseMessage + ']';
            //End Next of Kin====================================================================================
            //Nominee =======================================================================================
            ResponseMessage := ResponseMessage + ',"Nominee":[';
            NextofKin.RESET;
            NextofKin.SETRANGE(NextofKin."Application No.", Member."Application No.");
            NextofKin.SETRANGE(Type, NextofKin.Type::Nominee);
            if NextofKin.FINDSET then begin
                repeat
                    ResponseMessage := ResponseMessage + '{"Name":"' + NextofKin.Name + '",';
                    ResponseMessage := ResponseMessage + '"Address":"' + ' ' + '",';
                    ResponseMessage := ResponseMessage + '"Telephone":"' + NextofKin."Phone No." + '",';
                    ResponseMessage := ResponseMessage + '"eMail":"' + ' ' + '",';
                    ResponseMessage := ResponseMessage + '"ID_Passport":"' + Format(NextofKin."National ID") + '",';
                    ResponseMessage := ResponseMessage + '"Date_of_Birth":"' + FORMAT(TODAY) + '",';
                    ResponseMessage := ResponseMessage + '"Nominee_Relationship":"' + FORMAT(NextofKin.Relationship) + '"},';
                until NextofKin.NEXT = 0;
                if STRPOS(ResponseMessage, 'Nominee_Relationship') <> 0 then begin
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
            end;
            ResponseMessage := ResponseMessage + ']';

            //Nominees & Next of Kin==================================================================
            //Non Loans==============================================================================================
            ResponseMessage := ResponseMessage + ',"MemberAccounts":[';
            AccountTypes.RESET;
            if AccountTypes.FINDSET then begin
                repeat
                    Vendor.RESET;
                    Vendor.SETCURRENTKEY("Account Type");
                    Vendor.SETRANGE("Member No.", Member."No.");
                    Vendor.SETRANGE("Account Type", AccountTypes.Code);
                    if Vendor.FINDSET then begin
                        repeat
                            Vendor.CALCFIELDS("Balance (LCY)", Balance);
                            ResponseMessage := ResponseMessage + '{"AccountNo":"' + Vendor."No." + '",';
                            ResponseMessage := ResponseMessage + '"ProductName":"' + Vendor.Name + '",';
                            ResponseMessage := ResponseMessage + '"Status":"' + FORMAT(Vendor.Status) + '",';
                            ResponseMessage := ResponseMessage + '"Balance":"' + FORMAT(Vendor.Balance - AccountTypes."Minimum Balance") + '"},';
                        until Vendor.NEXT = 0;
                    end;
                until AccountTypes.NEXT = 0;
                if STRPOS(ResponseMessage, 'ProductName') <> 0 then begin
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
                ResponseMessage := ResponseMessage + ']';
            end;
            //End Non Loans==============================================================================================
            //Loans==============================================================================================

            ResponseMessage := ResponseMessage + ',"LoanAccounts":[';
            Loanstring := '';
            Customer.RESET;
            Customer.SETRANGE("Member No.", Member."No.");
            if Customer.FINDSET then begin
                repeat
                    Customer.CALCFIELDS(Balance);
                    if Customer.Balance > 0 then begin
                        ResponseMessage := ResponseMessage + '{"AccountNo":"' + Customer."No." + '",';
                        ResponseMessage := ResponseMessage + '"ProductName":"' + Customer.Name + '",';
                        ResponseMessage := ResponseMessage + '"Status":"' + FORMAT(Customer.Status) + '",';
                        ResponseMessage := ResponseMessage + '"Balance":"' + FORMAT(Customer.Balance) + '",';
                        Loanstring := 'LoanNo';
                        LoanClassifications.RESET;
                        LoanClassifications.SETCURRENTKEY("Classification Date");
                        LoanClassifications.SETRANGE("Loan No.", Customer."No.");
                        if LoanClassifications.FINDSET then begin
                            ResponseMessage := ResponseMessage + '"Classification":"' + FORMAT(LoanClassifications."Classification Code") + '",';
                            ResponseMessage := ResponseMessage + '"ClassificationDate":"' + FORMAT(LoanClassifications."Classification Date") + '"},';
                        end;
                        if not LoanClassifications.FINDSET then begin
                            ResponseMessage := ResponseMessage + '"Classification":"Not Classified Yet",';
                            ResponseMessage := ResponseMessage + '"ClassificationDate":"NULL"},';
                        end;
                    end;
                until Customer.NEXT = 0;
            end;
            if STRLEN(Loanstring) > 1 then begin
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
            end;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end;
        //End Register Member========================================================================
    end;

    procedure MemberStatement(var AccountNo: Code[20]; var StartDate: Date; var EndDate: Date; var ResponseMessage: Text; var ResponseCode: Text);
    begin

        /*Vendor.RESET;
        Vendor.SETRANGE("No.",AccountNo);
        IF NOT Vendor.FINDSET THEN BEGIN
           ResponseCode:='01';
           ResponseMessage:='Account No is not Valid!';
           EXIT;
        END;*/
        if StartDate = 0D then begin
            ResponseCode := '01';
            ResponseMessage := 'Start Date is not Valid!';
            exit;
        end;
        if EndDate = 0D then begin
            ResponseCode := '01';
            ResponseMessage := 'End Date is not Valid!';
            exit;
        end;

        if Vendor.GET(AccountNo) then begin
            Member.GET(Vendor."Member No.");
            date2 := CALCDATE('1D', StartDate);

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
            VendorLedgerEntry.SETFILTER("Posting Date", '%1..%2', date2, EndDate);
            if not VendorLedgerEntry.FINDSET then begin
                ResponseCode := '01';
                ResponseMessage := 'No Transactions found within ' + FORMAT(StartDate) + ' _ ' + FORMAT(EndDate);
                exit;
            end;
        end;

        if Customer.GET(AccountNo) then begin
            Member.GET(Customer."Member No.");
            date2 := CALCDATE('1D', StartDate);

            CustomerLedgerEntry.RESET;
            CustomerLedgerEntry.SETRANGE("Customer No.", Customer."No.");
            CustomerLedgerEntry.SETFILTER("Posting Date", '%1..%2', date2, EndDate);
            if not CustomerLedgerEntry.FINDSET then begin
                ResponseCode := '01';
                ResponseMessage := 'No Transactions found within ' + FORMAT(StartDate) + ' _ ' + FORMAT(EndDate);
                exit;
            end;
        end;
        //Member Statement==============================================================================================

        if Vendor.GET(AccountNo) then begin
            Member.GET(Vendor."Member No.");
            date2 := CALCDATE('1D', StartDate);

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
            VendorLedgerEntry.SETCURRENTKEY("Posting Date");
            VendorLedgerEntry.SETASCENDING("Posting Date", true);
            VendorLedgerEntry.SETFILTER("Posting Date", '%1..%2', date2, EndDate);
            //VendorLedgerEntry.SETRANGE(Reversed,FALSE);
            if VendorLedgerEntry.FINDSET then begin

                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
                ResponseMessage := ResponseMessage + '"MemberStatus":"' + FORMAT(Member.Status) + '",';
                ResponseMessage := ResponseMessage + '"AccountStatus":"' + FORMAT(Vendor.Status) + '",';
                ResponseMessage := ResponseMessage + '"AccountNo":"' + FORMAT(Vendor."No.") + '",';
                ResponseMessage := ResponseMessage + '"AccountName":"' + FORMAT(Vendor.Name) + '",';
                OpeningBal := 0;
                RunningBal := 0;
                VendorLedgerEntry2.RESET;
                VendorLedgerEntry2.SETRANGE("Vendor No.", Vendor."No.");
                VendorLedgerEntry2.SETFILTER("Posting Date", '%1..%2', 0D, StartDate);
                if VendorLedgerEntry2.FINDSET then begin
                    repeat
                        VendorLedgerEntry2.CALCFIELDS(Amount);
                        OpeningBal += VendorLedgerEntry2.Amount;
                    until VendorLedgerEntry2.NEXT = 0;
                end;
                ResponseMessage := ResponseMessage + '"OpeningBalance":"' + FORMAT(OpeningBal) + '",';
                ResponseMessage := ResponseMessage + '"Transactions":[';
                RunningBal := OpeningBal;
                // RunningBal+=RunningBal;
                repeat
                    //REPEAT
                    VendorLedgerEntry.CALCFIELDS(Amount);
                    RunningBal += VendorLedgerEntry.Amount;
                    ResponseMessage := ResponseMessage + '{"PostingDate":"' + FORMAT(VendorLedgerEntry."Posting Date") + '",';
                    ResponseMessage := ResponseMessage + '"DocumentNo":"' + VendorLedgerEntry."Document No." + '",';
                    ResponseMessage := ResponseMessage + '"Description":"' + FORMAT(VendorLedgerEntry.Description) + '",';
                    if VendorLedgerEntry.Amount > 0 then begin
                        ResponseMessage := ResponseMessage + '"Debit":"' + FORMAT(VendorLedgerEntry.Amount) + '",';
                        ResponseMessage := ResponseMessage + '"Credit":"0"';
                    end;
                    if VendorLedgerEntry.Amount < 0 then begin
                        ResponseMessage := ResponseMessage + '"Debit":"0",';
                        ResponseMessage := ResponseMessage + '"Credit":"' + FORMAT(-VendorLedgerEntry.Amount) + '"';
                    end;
                    ResponseMessage := ResponseMessage + ',"RunningBal":"' + FORMAT(ABS(RunningBal), 0, '<Precision,2:2><Standard,0>') + '"';
                    ResponseMessage := ResponseMessage + '},';
                // UNTIL Vendor.NEXT=0;

                until VendorLedgerEntry.NEXT = 0;
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                ResponseMessage := ResponseMessage + ']';
                ResponseMessage := ResponseMessage + '}';
                ResponseCode := '00';
            end;
        end;


        if Customer.GET(AccountNo) then begin
            Member.GET(Customer."Member No.");
            date2 := CALCDATE('1D', StartDate);

            CustomerLedgerEntry.RESET;
            CustomerLedgerEntry.SETRANGE("Customer No.", Customer."No.");
            CustomerLedgerEntry.SETCURRENTKEY("Posting Date");
            CustomerLedgerEntry.SETASCENDING("Posting Date", true);
            CustomerLedgerEntry.SETFILTER("Posting Date", '%1..%2', date2, EndDate);
            //CustomerLedgerEntry.SETRANGE(Reversed,FALSE);
            if CustomerLedgerEntry.FINDSET then begin

                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
                ResponseMessage := ResponseMessage + '"MemberStatus":"' + FORMAT(Member.Status) + '",';
                ResponseMessage := ResponseMessage + '"AccountStatus":"' + FORMAT(Customer.Status) + '",';
                ResponseMessage := ResponseMessage + '"AccountNo":"' + FORMAT(Customer."No.") + '",';
                ResponseMessage := ResponseMessage + '"AccountName":"' + FORMAT(Customer.Name) + '",';
                OpeningBal := 0;
                RunningBal := 0;
                CustomerLedgerEntry2.RESET;
                CustomerLedgerEntry2.SETRANGE("Customer No.", Customer."No.");
                CustomerLedgerEntry2.SETFILTER("Posting Date", '%1..%2', 0D, StartDate);
                if CustomerLedgerEntry2.FINDSET then begin
                    repeat
                        CustomerLedgerEntry2.CALCFIELDS(Amount);
                        OpeningBal += CustomerLedgerEntry2.Amount;
                    until CustomerLedgerEntry2.NEXT = 0;
                end;
                ResponseMessage := ResponseMessage + '"OpeningBalance":"' + FORMAT(OpeningBal) + '",';
                ResponseMessage := ResponseMessage + '"Transactions":[';
                RunningBal := OpeningBal;
                // RunningBal+=RunningBal;
                repeat
                    //REPEAT
                    CustomerLedgerEntry.CALCFIELDS(Amount);
                    RunningBal += CustomerLedgerEntry.Amount;
                    ResponseMessage := ResponseMessage + '{"PostingDate":"' + FORMAT(CustomerLedgerEntry."Posting Date") + '",';
                    ResponseMessage := ResponseMessage + '"DocumentNo":"' + CustomerLedgerEntry."Document No." + '",';
                    ResponseMessage := ResponseMessage + '"Description":"' + FORMAT(CustomerLedgerEntry.Description) + '",';
                    if CustomerLedgerEntry.Amount > 0 then begin
                        ResponseMessage := ResponseMessage + '"Debit":"' + FORMAT(CustomerLedgerEntry.Amount) + '",';
                        ResponseMessage := ResponseMessage + '"Credit":"0"';
                    end;
                    if CustomerLedgerEntry.Amount < 0 then begin
                        ResponseMessage := ResponseMessage + '"Debit":"0",';
                        ResponseMessage := ResponseMessage + '"Credit":"' + FORMAT(-CustomerLedgerEntry.Amount) + '"';
                    end;
                    ResponseMessage := ResponseMessage + ',"RunningBal":"' + FORMAT(ABS(RunningBal), 0, '<Precision,2:2><Standard,0>') + '"';
                    ResponseMessage := ResponseMessage + '},';
                // UNTIL Customer.NEXT=0;

                until CustomerLedgerEntry.NEXT = 0;
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                ResponseMessage := ResponseMessage + ']';
                ResponseMessage := ResponseMessage + '}';
                ResponseCode := '00';
            end;
        end;
        //End Member Statement==============================================================================================

    end;

    procedure LoanProductsList(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        LoanProductTypes.RESET;
        LoanProductTypes.SETFILTER(Code, '<>%1', '');
        //LoanProductTypes.SETRANGE(Active, true);
        if LoanProductTypes.FINDSET then begin
            //Loan Listing============================================================================

            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"LoanListing":[';
            repeat
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(LoanProductTypes.Code) + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + LoanProductTypes.Description + '",';
                ResponseMessage := ResponseMessage + '"PaybillShortCode":"' + FORMAT(LoanProductTypes."Paybill Short Code") + '",';
                ResponseMessage := ResponseMessage + '"InterestRatePerAnnum":"' + FORMAT(LoanProductTypes."Interest Rate") + '",';
                ResponseMessage := ResponseMessage + '"InterestRatePerMonth":"' + FORMAT(LoanProductTypes."Interest Rate" / 12) + '",';
                ResponseMessage := ResponseMessage + '"MaximumRepaymentPeriod":"' + FORMAT(LoanProductTypes."Repayment Period") + '",';
                if LoanProductTypes."Based on Deposits" = false then begin
                    ResponseMessage := ResponseMessage + '"BasedOnDeposits":"Yes",';
                    ResponseMessage := ResponseMessage + '"LoanDepositsRatio":"0",';
                    ResponseMessage := ResponseMessage + '"BasedOnSavings":"No",';
                    ResponseMessage := ResponseMessage + '"LoanSavingsRation":"' + FORMAT(LoanProductTypes."Loan Deposit Ratio") + '",';
                end;
                if LoanProductTypes."Based on Savings" = true then begin
                    ResponseMessage := ResponseMessage + '"BasedOnDeposits":"No",';
                    ResponseMessage := ResponseMessage + '"LoanDepositsRatio":"0",';
                    ResponseMessage := ResponseMessage + '"BasedOnSavings":"Yes",';
                    ResponseMessage := ResponseMessage + '"LoanSavingsRation":"' + FORMAT(LoanProductTypes."Loan Savings Ratio") + '",';
                end;
                ResponseMessage := ResponseMessage + '"MinimumAmountToBorrow":"' + FORMAT(LoanProductTypes."Min. Loan Amount") + '",';
                ResponseMessage := ResponseMessage + '"MaximumAmountToBorrow":"' + FORMAT(LoanProductTypes."Max. Loan Amount") + '",';
                ResponseMessage := ResponseMessage + '"eLoan":"' + FORMAT(LoanProductTypes."E-Loan") + '",';
                ResponseMessage := ResponseMessage + '"AmountGoesToMPESA":"' + FORMAT(LoanProductTypes."E-Loan") + '",';
                ResponseMessage := ResponseMessage + '"TurnAroundTime":"' + FORMAT(LoanProductTypes."E-Loan Threshold") + '"';
                ResponseMessage := ResponseMessage + '},';
            until LoanProductTypes.NEXT = 0;
            ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
            //End Member Statement==============================================================================================

            //End Loan Listing========================================================================
        end;
    end;

    procedure CreateSchedule(var LoanProduct: Text; var AmountRequested: Decimal; var DateRequested: Date; var ResponseMessage: Text; var ResponseCode: Text);
    var
        RequestedAmount: Decimal;
        RequestedDate: Date;
    begin
        LoanProductTypes.RESET;
        LoanProductTypes.SETRANGE(Code, LoanProduct);
        if not LoanProductTypes.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Invalid Loan Product ' + LoanProduct;
            exit;
        end;
        //EVALUATE(RequestedAmount,AmountRequested);
        //EVALUATE(RequestedDate,DateRequested);
        LoanSetup.GET;

        GetLoanNo := NoSeriesManagement.GetNextNo(LoanSetup."Loan Application Nos.", TODAY, true);

        CalculateSchedule(GetLoanNo, AmountRequested, LoanProductTypes."IB Repay Period", LoanProductTypes."Interest Rate", DateRequested);
        COMMIT;

        RSchedule.RESET;
        RSchedule.SETRANGE("Loan No.", GetLoanNo);
        if RSchedule.FINDSET then begin
            //Loan Listing============================================================================
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"RepaymentSchedule":[';
            //Member Statement==============================================================================================
            repeat
                ResponseMessage := ResponseMessage + '{"StartingBalance":"' + FORMAT(RSchedule."Loan Amount", 0, '<Precision,2:2><Standard,0>') + '",';
                ResponseMessage := ResponseMessage + '"InstallmentNo":"' + FORMAT(RSchedule."Instalment No.") + '",';
                ResponseMessage := ResponseMessage + '"RepaymentDate":"' + FORMAT(RSchedule."Repayment Date") + '",';
                ResponseMessage := ResponseMessage + '"Principal":"' + FORMAT(RSchedule."Principal Installment", 0, '<Precision,2:2><Standard,0>') + '",';
                ResponseMessage := ResponseMessage + '"Interest":"' + FORMAT(RSchedule."Interest Installment", 0, '<Precision,2:2><Standard,0>') + '",';
                ResponseMessage := ResponseMessage + '"Principal_N_Interest":"' + FORMAT((RSchedule."Principal Installment" + RSchedule."Interest Installment"), 0, '<Precision,2:2><Standard,0>') + '",';
                ResponseMessage := ResponseMessage + '"Insurance":"' + FORMAT(0) + '",';
                ResponseMessage := ResponseMessage + '"TotalRepayment":"' + FORMAT(RSchedule."Total Installment", 0, '<Precision,2:2><Standard,0>') + '",';
                ResponseMessage := ResponseMessage + '"Balance":"' + FORMAT(RSchedule."Loan Amount", 0, '<Precision,2:2><Standard,0>') + '",';
                ResponseMessage := ResponseMessage + '"BorrowedAmount":"' + FORMAT(RSchedule."Loan Amount", 0, '<Precision,2:2><Standard,0>') + '"';
                ResponseMessage := ResponseMessage + '},';
            until RSchedule.NEXT = 0;
            ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
            //End Member Statement==============================================================================================
            //End Loan Listing========================================================================
        end;
    end;

    local procedure CalculateSchedule(var LoanNo: Code[20]; var Amount: Decimal; var Period: Integer; var InterestRate: Decimal; var DateTaken: Date);
    var
        TotalAmount: Decimal;
        PowerValue: Decimal;
        PeriodTxt: Text;
    begin

        RSchedule.RESET;
        RSchedule.SETRANGE(RSchedule."Loan No.", LoanNo);

        RSchedule.DELETEALL;

        LoanAmount := Amount;
        InterestRate := InterestRate;
        RepayPeriod := Period;
        LBalance := Amount;
        RunDate := DateTaken;
        InstalNo := 0;
        RepayInterval := '1M';
        //========================== Sacco Specific================They use  Excel's PMT Function //Brian Kibet 03/08/18
        Balance := Amount;
        Insurance := 0;
        Interest := 0;
        Principal := 0;
        PrincipalInterest := 0;
        Principal1 := 0;
        //End  Sacco Specific======================================

        repeat
            InstalNo := InstalNo + 1;
            RunDate := CALCDATE(RepayInterval, RunDate); //MESSAGE('%1',RunDate);
            TotalAmount := 0;
            Insurance := 0;
            Interest := 0;
            Principal := 0;
            PrincipalInterest := 0;


            EVALUATE(RepayCode, FORMAT(InstalNo));
            //===== Sacco Specific====================
            Principal := (Amount * InterestRate / 100) / 12; //ERROR('%1',Principal);
            PowerValue := 0;
            PowerValue := POWER((1 + (InterestRate / 100 / 12)), Period);// ERROR('%1',PowerValue);
            PowerValue := 1 - PowerValue; //ERROR('%1',PowerValue);
            if InterestRate = 0 then begin
                PowerValue := 1;
            end;
            //PowerValue:=1-PowerValue;
            Principal := Principal / PowerValue;
            Principal := Principal * -1;
            if InterestRate = 0 then begin
                Principal := Amount / Period;
            end;
            //Principal:=ROUND(Principal,1);
            //ERROR('First Principal: %1',Principal);
            Interest := InterestRate / 12 / 100 * Balance;
            //Interest:=ROUND(Interest,1);
            PrincipalInterest := Principal + Interest;
            CBSSetup.GET;
            Insurance := 0;
            Insurance := Insurance * -1;
            if InstalNo = 1 then begin
                Principal1 := PrincipalInterest;
            end;
            Principal := Principal1 - Interest; //Principal:=ROUND(Principal,1);
            PrincipalInterest := Principal1;  //PrincipalInterest:=ROUND(PrincipalInterest,1);
            TotalAmount := PrincipalInterest + Insurance; //total:=ROUND(total,1);
            Balance := Balance - Principal; //Balance:=ROUND(Balance,1);
                                            //=====End  Sacco Specific================

            RSchedule.INIT;
            //RSchedule.:=RepayCode;
            RSchedule."Loan No." := LoanNo;
            RSchedule."Loan Amount" := Amount;
            RSchedule."Instalment No." := InstalNo;
            RSchedule."Repayment Date" := RunDate;
            RSchedule."Principal Installment" := Principal;
            RSchedule."Interest Installment" := Interest;
            RSchedule."Total Installment" := TotalAmount;
            //RSchedule.Balance := Balance;
            //RSchedule."Starting Balance" := Balance + Principal;
            RSchedule.INSERT;
        until (InstalNo = Period);//LBalance < 1
    end;

    procedure DividendSlip(var MemberID: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        DividendLine: Record "Dividend Line";
        DividendHeader: Record "Dividend Header";
    begin

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        //Dividend Slip============================================================================
        DividendHeader.RESET;
        DividendHeader.SETCURRENTKEY("No.");
        DividendHeader.SETASCENDING("No.", false);
        if not DividendHeader.FINDFIRST then begin
            ResponseMessage := 'Dividend Details Not Found';
            ResponseCode := '01';
        end;


        DividendHeader.RESET;
        DividendHeader.SETCURRENTKEY("No.");
        DividendHeader.SETASCENDING("No.", false);
        if DividendHeader.FINDFIRST then begin
            Member.RESET;
            Member.SETRANGE("National ID", MemberID);
            if Member.FINDSET then begin
                MemberDividends.RESET;
                MemberDividends.SETRANGE("Member No.", Member."No.");
                MemberDividends.SETRANGE("Document No.", DividendHeader."No.");
                if not MemberDividends.FINDSET then begin
                    ResponseMessage := 'Member Dividend Details Not Found';
                    ResponseCode := '01';
                end;
            end;
        end;

        CBSSetup.GET;
        CompanyInformation.GET;
        DividendHeader.RESET;
        DividendHeader.SETCURRENTKEY("No.");
        DividendHeader.SETASCENDING("No.", false);
        if DividendHeader.FINDFIRST then begin
            Member.RESET;
            Member.SETRANGE("National ID", MemberID);
            if Member.FINDSET then begin
                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
                ResponseMessage := ResponseMessage + '"MemberStatus":"' + FORMAT(Member.Status) + '",';

                TotalDeposit := 0;
                TotalQualifyingAmount := 0;
                TotalGrossRebates := 0;

                MemberDividends.RESET;
                MemberDividends.SETRANGE("Member No.", Member."No.");
                MemberDividends.SETRANGE("Document No.", DividendHeader."No.");
                if MemberDividends.FINDSET then begin
                    ResponseMessage := ResponseMessage + '"MemberAccounts":[';
                    repeat
                        ResponseMessage := ResponseMessage + '{"AccountTotal":"' + FORMAT(MemberDividends."Account Balance") + '",';
                        ResponseMessage := ResponseMessage + '"CalculatedAmount":"' + FORMAT(MemberDividends."Gross Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"LineTotalDeduction":"' + FORMAT(MemberDividends."Gross Earning Amount" - MemberDividends."Net Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"GrossAmount":"' + FORMAT(MemberDividends."Gross Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"DividendTotalDeductions":"' + FORMAT(MemberDividends."Gross Earning Amount" - MemberDividends."Net Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"AccountType":"' + FORMAT(MemberDividends."Account Type") + '",';
                        ResponseMessage := ResponseMessage + '"AccounNo":"' + FORMAT(MemberDividends."Account No.") + '",';
                        ResponseMessage := ResponseMessage + '"TransactingCurrency":"KSHS.",';
                        ResponseMessage := ResponseMessage + '"CompanyName":"' + CompanyInformation.Name + '",';
                        ResponseMessage := ResponseMessage + '"CompanyAddress":"' + CompanyInformation.Address + '",';
                        ResponseMessage := ResponseMessage + '"ReportHeader":"MEMBER DIVIDEND AND REBATE STATEMENT",';
                        ResponseMessage := ResponseMessage + '"RebateComputation": "",';
                        ResponseMessage := ResponseMessage + '"AccountTotal":"' + FORMAT(MemberDividends."Account Balance") + '",';
                        ResponseMessage := ResponseMessage + '"CalculatedAmount":"' + FORMAT(MemberDividends."Gross Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"LineTotalDeduction":"' + FORMAT(MemberDividends."Gross Earning Amount" - MemberDividends."Net Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"GrossAmount":"' + FORMAT(MemberDividends."Gross Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"DividendTotalDeductions":"' + FORMAT(MemberDividends."Gross Earning Amount" - MemberDividends."Net Earning Amount") + '",';
                        ResponseMessage := ResponseMessage + '"AccountType":"' + FORMAT(MemberDividends."Account Type") + '",';
                        ResponseMessage := ResponseMessage + '"AccountNo":"' + FORMAT(MemberDividends."Account No.") + '"},';
                    until MemberDividends.NEXT = 0;
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                    ResponseMessage := ResponseMessage + ']}';
                    ResponseCode := '00';
                end;
            end;
        end;
        //End Dividend Slip========================================================================
    end;

    procedure GuarantorDetails(var MemberID: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        LoanApplication: Record "Loan Application";
        Response_Message: array[5] of Text;
        FoundGuarantor: Boolean;
    begin
        //MESSAGE('ID %1',MemberID);
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end else begin
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
            ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
            ResponseMessage := ResponseMessage + '"MemberStatus":"' + FORMAT(Member.Status) + '",';
            Customer.RESET;
            Customer.SETRANGE("Member No.", Member."No.");
            Customer.SETRANGE(Status, Customer.Status::Active);
            if Customer.FINDSET then begin
                i := 0;
                FoundGuarantor := false;
                repeat
                    Customer.CALCFIELDS("Balance (LCY)", Balance);
                    if Customer.Balance <> 0 then begin
                        LoanGuarantors.RESET;
                        LoanGuarantors.SETRANGE("Loan No.", Customer."No.");
                        if LoanGuarantors.FINDSET then begin
                            ResponseMessage := ResponseMessage + '"MemberLoans":[';
                            //Loans Being Guaranteed==============================================================================================
                            repeat
                                i += 1;
                                ResponseMessage := ResponseMessage + '{"LoanNo":"' + Customer."No." + '",';
                                ResponseMessage := ResponseMessage + '"ProductName":"' + Customer.Name + '",';
                                ResponseMessage := ResponseMessage + '"Status":"' + FORMAT(Customer.Status) + '",';
                                ResponseMessage := ResponseMessage + '"GuarantorNo":"' + FORMAT(i) + '",';
                                ResponseMessage := ResponseMessage + '"GuarantorName":"' + FORMAT(LoanGuarantors."Member Name") + '",';
                                ResponseMessage := ResponseMessage + '"AmountGuaranteed":"' + FORMAT(LoanGuarantors."Amount To Guarantee") + '",';
                                LoanClassifications.RESET;
                                LoanClassifications.SETCURRENTKEY("Classification Date");
                                LoanClassifications.SETRANGE("Loan No.", Customer."No.");
                                if LoanClassifications.FINDSET then begin
                                    ResponseMessage := ResponseMessage + '"Classification":"' + FORMAT(LoanClassifications."Classification Code") + '",';
                                    ResponseMessage := ResponseMessage + '"ClassificationDate":"' + FORMAT(LoanClassifications."Classification Date") + '",';
                                end;
                                if not LoanClassifications.FINDSET then begin
                                    ResponseMessage := ResponseMessage + '"Classification":"Not Classified Yet",';
                                    ResponseMessage := ResponseMessage + '"ClassificationDate":"NULL",';
                                end;
                                ResponseMessage := ResponseMessage + '"OriginalLoanBalance":"' + FORMAT(LoanGuarantors."Account Balance") + '",';
                                ResponseMessage := ResponseMessage + '"Balance":"' + FORMAT(-Customer.Balance) + '"},';
                                FoundGuarantor := true;
                            until LoanGuarantors.NEXT = 0;
                        end;
                    end;
                until Customer.NEXT = 0;
                if STRPOS(ResponseMessage, '"Balance":"') <> 0 then begin
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end else begin
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                end;
                if FoundGuarantor = true then
                    ResponseMessage := ResponseMessage + ']';
                //ResponseMessage:=ResponseMessage+'}';
                //End Loans Being Guaranteed==============================================================================================
            end;
            //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            i := 0;
            FoundGuarantor := false;
            Response_Message[1] := '';
            Response_Message[2] := '';
            Response_Message[1] := ResponseMessage;
            LoanGuarantors.RESET;
            LoanGuarantors.SETRANGE("Member No.", Member."No.");
            LoanGuarantors.SETFILTER("Loan No.", '<>%1', '');
            if LoanGuarantors.FINDSET then begin
                ResponseMessage := ResponseMessage + ',"LoansGuaranteeingOthers":[';
                //ResponseMessage:=ResponseMessage+'"LoansGuaranteeingOthers":[';
                //Loans Being Guaranteed==============================================================================================
                repeat
                    Customer.RESET;
                    Customer.SETRANGE("No.", LoanGuarantors."Loan No.");
                    if Customer.FINDSET then begin
                        i := 0;
                        repeat
                            i += 1;
                            Customer.CALCFIELDS("Balance (LCY)", Balance);
                            if Customer.Balance < 0 then begin
                                if Customer.Status = Customer.Status::Active then begin
                                    Response_Message[2] := 'Test';
                                    ResponseMessage := ResponseMessage + '{"LoanNo":"' + Customer."No." + '",';
                                    ResponseMessage := ResponseMessage + '"ProductName":"' + Customer.Name + '",';
                                    ResponseMessage := ResponseMessage + '"Status":"' + FORMAT(Customer.Status) + '",';
                                    ResponseMessage := ResponseMessage + '"GuarantorNo":"' + FORMAT(i) + '",';
                                    ResponseMessage := ResponseMessage + '"GuarantorName":"' + FORMAT(LoanGuarantors."Member Name") + '",';
                                    ResponseMessage := ResponseMessage + '"AmountGuaranteed":"' + FORMAT(LoanGuarantors."Amount To Guarantee") + '",';
                                    LoanClassifications.RESET;
                                    LoanClassifications.SETCURRENTKEY("Classification Date");
                                    LoanClassifications.SETRANGE("Loan No.", Customer."No.");
                                    if LoanClassifications.FINDSET then begin
                                        ResponseMessage := ResponseMessage + '"Classification":"' + FORMAT(LoanClassifications."Classification Code") + '",';
                                        ResponseMessage := ResponseMessage + '"ClassificationDate":"' + FORMAT(LoanClassifications."Classification Date") + '",';
                                    end;
                                    if not LoanClassifications.FINDSET then begin
                                        ResponseMessage := ResponseMessage + '"Classification":"Not Classified Yet",';
                                        ResponseMessage := ResponseMessage + '"ClassificationDate":"NULL",';
                                    end;
                                    ResponseMessage := ResponseMessage + '"OriginalLoanBalance":"' + FORMAT(LoanGuarantors."Account Balance") + '",';
                                    ResponseMessage := ResponseMessage + '"Balance":"' + FORMAT(-Customer.Balance) + '"},';
                                end;
                            end;
                        until Customer.NEXT = 0;
                    end;
                until LoanGuarantors.NEXT = 0;
                if Response_Message[2] = '' then begin
                    ResponseMessage := Response_Message[1];
                end else begin
                    if STRPOS(ResponseMessage, '"Balance":"') <> 0 then begin
                        ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                    end;
                    ResponseMessage := ResponseMessage + ']';
                    ResponseMessage := ResponseMessage + '}';
                end;
                //End Loans Being Guaranteed==============================================================================================
            end;
            ResponseCode := '00';
        end;
    end;

    procedure VerifyMemberNo(var MemberNo: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        DividendLine: Record "Dividend Line";
        DividendHeader: Record "Dividend Header";
    begin

        Member.RESET;
        Member.SETRANGE("No.", MemberNo);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("No.", MemberNo);
        if Member.FINDSET then begin
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
            ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
            ResponseMessage := ResponseMessage + '"IdentificationNo":"' + Member."National ID" + '",';
            ResponseMessage := ResponseMessage + '"Address":"' + Member."Postal Address" + '",';
            ResponseMessage := ResponseMessage + '"City":"' + Member."Physical Address" + '",';
            ResponseMessage := ResponseMessage + '"Nationality":"' + 'KE",';
            ResponseMessage := ResponseMessage + '"MobileNo":"' + Member."Phone No." + '",';
            ResponseMessage := ResponseMessage + '"Gender":"' + FORMAT(Member.Gender) + '",';
            ResponseMessage := ResponseMessage + '"eMail":"' + Member."E-mail" + '",';
            //ResponseMessage:=ResponseMessage+'"PayrollNo":"'+Member."Payroll No."+'",';
            //ResponseMessage:=ResponseMessage+'"SalaryPassesThroughSacco":"'+FORMAT(TRUE)+'",';
            ResponseMessage := ResponseMessage + '"DateOfBirth":"' + FORMAT(Member."Date of Birth") + '"';
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", 1);
            DimensionValue.SETRANGE(Code, Member."Global Dimension 1 Code");
            if DimensionValue.FINDSET then begin
                ResponseMessage := ResponseMessage + ',"BranchCode":"' + Member."Global Dimension 1 Code" + '",';
                ResponseMessage := ResponseMessage + '"BranchName":"' + DimensionValue.Name + '"';
            end;
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end;
    end;

    procedure VerifyMemberID(var MemberID: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        DividendLine: Record "Dividend Line";
        DividendHeader: Record "Dividend Header";
    begin

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            if Member."National ID" = '' then begin
                ResponseCode := '01';
                ResponseMessage := 'Member ID must have a value. Kindly Update!';
                exit;
            end;
        end;

        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if Member.FINDSET then begin
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
            ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
            ResponseMessage := ResponseMessage + '"IdentificationNo":"' + Member."National ID" + '",';
            ResponseMessage := ResponseMessage + '"Address":"' + Member."Postal Address" + '",';
            ResponseMessage := ResponseMessage + '"City":"' + Member."Physical Address" + '",';
            ResponseMessage := ResponseMessage + '"Nationality":"' + 'KE",';
            ResponseMessage := ResponseMessage + '"MobileNo":"' + Member."Phone No." + '",';
            ResponseMessage := ResponseMessage + '"Gender":"' + FORMAT(Member.Gender) + '",';
            ResponseMessage := ResponseMessage + '"eMail":"' + Member."E-mail" + '",';
            //ResponseMessage:=ResponseMessage+'"PayrollNo":"'+Member."Payroll No."+'",';
            //ResponseMessage:=ResponseMessage+'"SalaryPassesThroughSacco":"'+FORMAT(TRUE)+'",';
            ResponseMessage := ResponseMessage + '"DateOfBirth":"' + FORMAT(Member."Date of Birth") + '"';
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", 1);
            DimensionValue.SETRANGE(Code, Member."Global Dimension 1 Code");
            if DimensionValue.FINDSET then begin
                ResponseMessage := ResponseMessage + ',"BranchCode":"' + Member."Global Dimension 1 Code" + '",';
                ResponseMessage := ResponseMessage + '"BranchName":"' + DimensionValue.Name + '"';
            end;
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end;
    end;

    procedure VerifyMemberEmail(var MemberEmail: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        DividendLine: Record "Dividend Line";
        DividendHeader: Record "Dividend Header";
        InternetBankingApp: Record "Internet Banking Application";
    begin

        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE(Email, MemberEmail);
        if not InternetBankingApp.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end;


        /*
        Member.RESET;
        Member.SETRANGE("E-mail",MemberEmail);
        IF Member.FINDSET THEN BEGIN
          IF Member."E-mail"='' THEN BEGIN
           ResponseCode:='01';
           ResponseMessage:='Member Email must have a value. Kindly Update!';
           EXIT;
          END;
        END;
        */
        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE(Email, MemberEmail);
        if InternetBankingApp.FINDFIRST then begin
            if Member.GET(InternetBankingApp."Member no") then begin
                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + Member."No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + Member."Full Name" + '",';
                ResponseMessage := ResponseMessage + '"IdentificationNo":"' + Member."National ID" + '",';
                ResponseMessage := ResponseMessage + '"Address":"' + Member."Postal Address" + '",';
                ResponseMessage := ResponseMessage + '"City":"' + Member."Physical Address" + '",';
                ResponseMessage := ResponseMessage + '"Nationality":"' + 'KE",';
                ResponseMessage := ResponseMessage + '"MobileNo":"' + Member."Phone No." + '",';
                ResponseMessage := ResponseMessage + '"Gender":"' + FORMAT(Member.Gender) + '",';
                ResponseMessage := ResponseMessage + '"eMail":"' + MemberEmail + '",';
                ResponseMessage := ResponseMessage + '"DateOfBirth":"' + FORMAT(Member."Date of Birth") + '"';
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                DimensionValue.SETRANGE(Code, Member."Global Dimension 1 Code");
                if DimensionValue.FINDSET then begin
                    ResponseMessage := ResponseMessage + ',"BranchCode":"' + Member."Global Dimension 1 Code" + '",';
                    ResponseMessage := ResponseMessage + '"BranchName":"' + DimensionValue.Name + '"';
                end;
                ResponseMessage := ResponseMessage + '}';
                ResponseCode := '00';
            end;
        end;

    end;

    procedure VerifyMemberLogin(var MemberID: Text; var Password: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        InternetBankingApp: Record "Internet Banking Application";
    begin
        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE("National ID", MemberID);
        if not InternetBankingApp.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Member Not Registered For Internet Banking!';
            exit;
        end;

        InternetBankingApp.RESET;
        InternetBankingApp.SETRANGE("National ID", MemberID);
        if InternetBankingApp.FINDFIRST then begin
            if (InternetBankingApp.Password <> Password) and (InternetBankingApp.Status = 2) then begin
                ResponseCode := '01';
                ResponseMessage := 'Incorrect Password!';
                exit;
            end;

            if (InternetBankingApp.Password = Password) and (InternetBankingApp.Status <> 2) then begin
                ResponseCode := '01';
                ResponseMessage := 'Please Change Your Password!';
                exit;
            end;

            if (InternetBankingApp.Password = Password) and (InternetBankingApp.Status = 2) then begin
                ResponseCode := '00';
                ResponseMessage := 'Success!';
                exit;
            end;
        end;
    end;

    procedure CreateEmailAlert(var AlertMessage: Text; var MemberID: Text; var MemberEmail: Text; var DateSent: Date; var EmailHeader: Text; var Subject: Text; var ResetToken: Text; var IsTokenValid: Boolean; var UUID: Text; var TimeSent: Time; var UserName: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        ObjEmailAlerts: Record "Email Alerts";
        EntryNo: Integer;
        OStream: OutStream;
        Member: Record Member;
    begin
        Member.RESET;
        Member.SETRANGE("National ID", MemberID);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member with member ID ' + MemberID + ' does not Exist!';
            exit;
        end else begin
            if Member."E-mail" = '' then begin

            end;

            ObjEmailAlerts.RESET;
            if ObjEmailAlerts.FINDLAST then begin
                EntryNo := ObjEmailAlerts."Entry No" + 1;
            end else begin
                EntryNo := 1;
            end;

            ObjEmailAlerts.INIT;
            ObjEmailAlerts."Entry No" := EntryNo;
            ObjEmailAlerts."Alert Message".CREATEOUTSTREAM(OStream);
            OStream.WRITE(AlertMessage);
            ObjEmailAlerts."Member Id" := MemberID;
            ObjEmailAlerts."Email Addres" := MemberEmail;
            ObjEmailAlerts."Date Sent" := DateSent;
            ObjEmailAlerts."Email Header" := EmailHeader;
            ObjEmailAlerts.Subject := Subject;
            ObjEmailAlerts."Is Token valid" := IsTokenValid;
            ObjEmailAlerts.UUID := UUID;
            ObjEmailAlerts."Time Sent" := TimeSent;
            ObjEmailAlerts."Reset Token" := ResetToken;
            ObjEmailAlerts."User ID" := UserName;
            ObjEmailAlerts.INSERT;
            ResponseMessage := 'Email alert created successfuly!';
            ResponseCode := '00';
        end;
    end;

    procedure VerifyEmailToken(var ResetToken: Text; var IsTokenValid: Boolean; var UUID: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        ObjEmailAlerts: Record "Email Alerts";
    begin
        ObjEmailAlerts.RESET;
        ObjEmailAlerts.SETRANGE("Reset Token", ResetToken);
        ObjEmailAlerts.SETRANGE("Is Token valid", IsTokenValid);
        if not ObjEmailAlerts.FINDFIRST then begin
            ResponseCode := '01';
            ResponseMessage := 'Reset Token not found';
        end;

        ObjEmailAlerts.RESET;
        ObjEmailAlerts.SETRANGE("Reset Token", ResetToken);
        ObjEmailAlerts.SETRANGE("Is Token valid", IsTokenValid);
        if ObjEmailAlerts.FINDFIRST then begin
            ResponseCode := '00';
            ResponseMessage := '{';
            //ResponseMessage:='{"Email Token is valid", ';
            ResponseMessage := ResponseMessage + '"MemberId":"' + ObjEmailAlerts."Member Id" + '",';
            ResponseMessage := ResponseMessage + '"EMail":"' + ObjEmailAlerts."Email Addres" + '"}';
        end;
    end;

    local procedure GetAlertMessageTemplate(ObjEmailAlerts: Record "Email Alerts"): Text;
    var
        IStream: InStream;
        AlertMessage: Text;
    begin
        ObjEmailAlerts.CALCFIELDS(ObjEmailAlerts."Alert Message");
        if not ObjEmailAlerts."Alert Message".HASVALUE then
            exit;
        ObjEmailAlerts."Alert Message".CREATEINSTREAM(IStream);
        IStream.READ(AlertMessage);
        exit(AlertMessage);
    end;


    procedure LoanMainSector(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //Loan Main Sector Listing===========================================================================
        EconomicSector.RESET;
        EconomicSector.SETFILTER(Code, '<>%1', '');
        if EconomicSector.FINDSET then begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"EconomicSectorListing":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(EconomicSector.Code) + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + EconomicSector.Description + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                //ResponseMessage:=ResponseMessage+'},';
                if Int = EconomicSector.COUNT then
                    ResponseMessage := ResponseMessage + '}'
                else
                    ResponseMessage := ResponseMessage + '},';
            until EconomicSector.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end
        //Loan Main Sector Listing============================================================================
    end;


    procedure LoanCategory(var MainSector: Code[10]; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //Loan Category Listing===========================================================================
        EconomicSectorCategory.RESET;
        EconomicSectorCategory.SETRANGE("Economic Sector", MainSector);
        if not EconomicSectorCategory.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Invalid Loan Category Sector ' + MainSector;
            exit;
        end else begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"EconomicCategoryListing":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(EconomicSectorCategory.Code) + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + EconomicSectorCategory.Description + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                //ResponseMessage:=ResponseMessage+'},';
                if Int = EconomicSectorCategory.COUNT then
                    ResponseMessage := ResponseMessage + '}' else
                    ResponseMessage := ResponseMessage + '},';
            until EconomicSectorCategory.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end;
        //Loan Category Listing============================================================================
    end;


    procedure LoanSubCategory(var MainSector: Code[10]; var Category: Code[10]; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //Loan SubCategory Listing===========================================================================
        EconomicSectorSubCategory.RESET;
        EconomicSectorSubCategory.SETRANGE("Economic Sector", MainSector);
        if not EconomicSectorSubCategory.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Invalid Economic Sector ' + MainSector;
            exit;
        end else begin
            EconomicSectorSubCategory.RESET;
            EconomicSectorSubCategory.SETRANGE("Economic Sector", MainSector);
            EconomicSectorSubCategory.SETRANGE("Economic Sector Category", Category);
            if not EconomicSectorSubCategory.FINDSET then begin
                Int := 0;
                ResponseCode := '01';
                ResponseMessage := 'Invalid Economic Category Sector ' + Category;
                exit;
            end else begin
                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"EconomicSubCategoryListing":[';
                repeat
                    Int += 1;
                    ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(EconomicSectorSubCategory.Code) + '",';
                    ResponseMessage := ResponseMessage + '"Description":"' + EconomicSectorSubCategory.Description + '",';
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                    if Int = EconomicSectorSubCategory.COUNT then
                        ResponseMessage := ResponseMessage + '}' else
                        ResponseMessage := ResponseMessage + '},'
                until EconomicSectorSubCategory.NEXT = 0;
                ResponseMessage := ResponseMessage + ']';
                ResponseMessage := ResponseMessage + '}';
                ResponseCode := '00';
            end;
        end;
        //Loan SubCategory Listing============================================================================
    end;


    procedure CheckGuarantor(var IdNumber: Text; var Amount: Decimal; var ResponseMessage: Text; var ResponseCode: Text);
    var
        LoanApplication: Record "Loan Application";
        Response_Message: array[5] of Text;
        FoundGuarantor: Boolean;
    begin
        //MESSAGE('ID %1',MemberID);
        Member.RESET;
        Member.SETFILTER("National ID", '<>%1', IdNumber);
        Member.SETRANGE("National ID", IdNumber);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end else begin
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", Member."No.");
            Vendor.SETRANGE("Account Type", '01');
            if Vendor.FINDSET then begin
                AccBal := 0;
                OtherGuaranteedAmt := 0;

                AccBal := GlobalM.GetAccountBalance(0, Vendor."No.");
                OtherGuaranteedAmt := CalculateGuaranteedAmount(Member."No.");
                NetAccBal := AccBal - OtherGuaranteedAmt;
                if NetAccBal <= 0 then begin
                    ResponseCode := '01';
                    ResponseMessage := 'Member does not have enough amount to guarantee!';
                    exit;
                end else begin
                    if Amount > NetAccBal then begin
                        ResponseCode := '01';
                        ResponseMessage := 'Amount Requested cannot be Guaranteed';
                    end else begin
                        ResponseCode := '00';
                        ResponseMessage := ' Amount Requested can be Guaranteed';
                    end;
                end;
            end;
        end;
    end;

    local procedure CalculateGuaranteedAmount(MembNo: Code[10]) Amount: Decimal;
    var
        OtherAmountRatio: Decimal;
    begin
        LoanGuarantors.RESET;
        LoanGuarantors.SETRANGE("Member No.", MembNo);
        if LoanGuarantors.FINDSET then begin
            repeat
                OtherAmountRatio := 0;
                if Customer.GET(LoanGuarantors."Loan No.") then begin
                    Customer.CALCFIELDS(Customer.Balance);
                    LoanApp.GET(LoanGuarantors."Loan No.");
                    OtherAmountRatio := LoanGuarantors."Amount To Guarantee" / LoanApp."Approved Amount";
                    if Customer.Balance > 0 then
                        OtherGuaranteedAmt += (OtherAmountRatio * Customer.Balance);
                end;
            until LoanGuarantors.NEXT = 0;
        end;
    end;


    procedure GetSecurityTypes(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //Security Types===========================================================================
        Security.RESET;
        Security.SETFILTER(Code, '<>%1', '');
        if Security.FINDSET then begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"Security_Type":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(Security.Code) + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + Security.Description + '",';
                ResponseMessage := ResponseMessage + '"Factor":"' + FORMAT(Security.Factor) + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                if Int = Security.COUNT then
                    ResponseMessage := ResponseMessage + '}' else
                    ResponseMessage := ResponseMessage + '},';
            until Security.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end
        //Security Types===========================================================================
    end;


    procedure LoanApplications(var IdNumber: Code[10]; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //New Loan Listing===========================================================================
        Member.RESET;
        Member.SETRANGE("National ID", IdNumber);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not exist ';
            exit;
        end else begin
            LoanApp.RESET;
            LoanApp.SETRANGE(LoanApp."Member No.", Member."No.");
            if LoanApp.FINDSET then begin
                Int := 0;
                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"Newloanslisting":[';
                repeat
                    Int += 1;
                    ResponseMessage := ResponseMessage + '{"LoanNo":"' + FORMAT(LoanApp."No.") + '",';
                    ResponseMessage := ResponseMessage + '"Amount":"' + FORMAT(LoanApp."Approved Amount") + '",';
                    ResponseMessage := ResponseMessage + '"Repayment_Period":"' + FORMAT(LoanApp."Repayment Period") + '",';
                    ResponseMessage := ResponseMessage + '"LoanStatus":"' + FORMAT(LoanApp.Status) + '",';
                    if EconomicSector.GET(LoanApp."Economic Sector") then
                        ResponseMessage := ResponseMessage + '"Loan_Sector":"' + EconomicSector.Description + '",';
                    if EconomicSectorCategory.GET(LoanApp."Economic Sector Category") then
                        ResponseMessage := ResponseMessage + '"Loan_Category":"' + EconomicSectorCategory.Description + '",';
                    if EconomicSectorSubCategory.GET(LoanApp."Economic Sector Sub-Category") then
                        ResponseMessage := ResponseMessage + '"LoanSubCategory":"' + EconomicSectorSubCategory.Description + '",';
                    // ResponseMessage := ResponseMessage + '"Employer":"' + Member.+ '",';
                    ResponseMessage := ResponseMessage + '"Gross_Income":"' + FORMAT(LoanApp."Basic Salary") + '",';
                    ResponseMessage := ResponseMessage + '"Net_Income":"' + FORMAT(LoanApp."Net Amount") + '",';
                    ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                    if Int = LoanApp.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
                until LoanApp.NEXT = 0;

                ResponseMessage := ResponseMessage + ']';
                ResponseMessage := ResponseMessage + '}';
                ResponseCode := '00';
            end;
        end;
        //New Loan Listing============================================================================
    end;


    procedure SaccoActivities(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //Saccom Balances===========================================================================
        TransTypeCodeSetup.Get();
        LoanPrincipal := 0;
        LoanInterest := 0;
        DepositBalance := 0;
        SavingsBalance := 0;
        RegisteredMembers := 0;
        MobileMembers := 0;
        NewApplications := 0;
        PendingDisbursals := 0;
        DisbursedLoans := 0;
        RejectedLoans := 0;
        CustL.RESET;
        if CustL.FINDSET then begin
            repeat
                CustL.CALCFIELDS(CustL.Amount);
                if (CustL."Transaction Type Code" = TransTypeCodeSetup."New Loan") or (CustL."Transaction Type Code" = TransTypeCodeSetup."Principal Paid") then begin
                    LoanPrincipal += CustL.Amount;
                end;
                if (CustL."Transaction Type Code" = TransTypeCodeSetup."Interest Due") or (CustL."Transaction Type Code" = TransTypeCodeSetup."Interest Paid") or (CustL."Transaction Type Code" = TransTypeCodeSetup."Penalty Due")
                  or (CustL."Transaction Type Code" = TransTypeCodeSetup."Penalty Paid") then begin
                    LoanInterest += CustL.Amount;
                end;
            until CustL.NEXT = 0;
        end;
        Vendor.RESET;
        Vendor.SETRANGE(Status, Vendor.Status::Active);
        if Vendor.FINDSET then begin
            repeat
                if AccountType.GET(Vendor."Account Type") then begin
                    Vendor.CALCFIELDS(Balance);
                    if AccountType.Type = AccountType.Type::"Member Deposit" then begin
                        DepositBalance += Vendor.Balance;
                    end else
                        if AccountType.Type = AccountType.Type::"Share Capital" then begin
                            SavingsBalance += Vendor.Balance;
                        end;
                end;
            until Vendor.NEXT = 0;
        end;
        //Registered Members======================================================================
        Member.RESET;
        if Member.FINDSET then begin
            RegisteredMembers := Member.COUNT;
        end;
        //Registered Members======================================================================
        //Mobile Banking Members================================================================================
        MBanking.RESET;
        MBanking.SETRANGE(MBanking.Status, MBanking.Status::Active);
        if MBanking.FINDSET then begin
            MobileMembers := MBanking.COUNT;
        end;
        //Mobile Banking Members================================================================================
        //Loans Statistics==============================================================
        LoanApp.RESET;
        LoanApp.SETRANGE(Status, LoanApp.Status::New);
        if LoanApp.FINDSET then begin
            NewApplications := LoanApp.COUNT;
        end;
        LoanApp.RESET;
        LoanApp.SETRANGE(Status, LoanApp.Status::"Pending Approval");
        if LoanApp.FINDSET then begin
            NewApplications := LoanApp.COUNT;
        end;
        LoanApp.RESET;
        LoanApp.SETRANGE(Posted, true);
        if LoanApp.FINDSET then begin
            DisbursedLoans := LoanApp.COUNT;
        end;
        LoanApp.RESET;
        LoanApp.SETRANGE(Status, LoanApp.Status::Rejected);
        if LoanApp.FINDSET then begin
            RejectedLoans := LoanApp.COUNT;
        end;
        //Loans Statistics==============================================================
        ResponseMessage := '{';
        ResponseMessage := ResponseMessage + '"SACCOACTIVITIES":[';
        ResponseMessage := ResponseMessage + '"SACCOBALANCES",';
        ResponseMessage := ResponseMessage + '{"LoanPrincipal":"' + FORMAT(LoanPrincipal) + '",';
        ResponseMessage := ResponseMessage + '"LoanInterest":"' + FORMAT(LoanInterest) + '",';
        ResponseMessage := ResponseMessage + '"DepositBalance":"' + FORMAT(DepositBalance) + '",';
        ResponseMessage := ResponseMessage + '"SharesBalance":"' + FORMAT(SavingsBalance) + '"';
        ResponseMessage := ResponseMessage + '},';

        ResponseMessage := ResponseMessage + '"MEMBERSHIP",';
        ResponseMessage := ResponseMessage + '{"Registered_Members":"' + FORMAT(RegisteredMembers) + '",';
        ResponseMessage := ResponseMessage + '"Mobile_Members":"' + FORMAT(MobileMembers) + '"';
        ResponseMessage := ResponseMessage + '},';

        ResponseMessage := ResponseMessage + '"LOANS",';
        ResponseMessage := ResponseMessage + '{"NewLoanApplications":"' + FORMAT(NewApplications) + '",';
        ResponseMessage := ResponseMessage + '"PendingDisbursal":"' + FORMAT(PendingDisbursals) + '",';
        ResponseMessage := ResponseMessage + '"DisbursedLoans":"' + FORMAT(DisbursedLoans) + '",';
        ResponseMessage := ResponseMessage + '"RejectedLoans":"' + FORMAT(RejectedLoans) + '"';
        ResponseMessage := ResponseMessage + '}';
        ResponseMessage := ResponseMessage + '}';
        ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
        ResponseMessage := ResponseMessage + ']';
        ResponseMessage := ResponseMessage + '}';
        ResponseCode := '00';

        //Sacco Balances============================================================================
    end;


    procedure NewLoanApplications(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //New Loan Listing===========================================================================
        LoanApp.RESET;
        LoanApp.SETRANGE(LoanApp.Status, LoanApp.Status::New);
        LoanApp.SETRANGE("Created Date", CALCDATE('-3M', TODAY), TODAY);
        if LoanApp.FINDSET then begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"Newloanslisting":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(LoanApp."No.") + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + LoanApp.Description + '",';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + LoanApp."Member No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + LoanApp."Member Name" + '",';
                ResponseMessage := ResponseMessage + '"RequestedAmt":"' + FORMAT(LoanApp."Requested Amount") + '",';
                ResponseMessage := ResponseMessage + '"ApprovedAmt":"' + FORMAT(LoanApp."Approved Amount") + '",';
                ResponseMessage := ResponseMessage + '"Installments":"' + FORMAT(LoanApp."Repayment Period") + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                if Int = LoanApp.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
            until LoanApp.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end
        //New Loan Listing============================================================================
    end;


    procedure LoansDisbursed(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //New Loan Listing===========================================================================
        LoanApp.RESET;
        LoanApp.SETRANGE(LoanApp.Posted, true);
        LoanApp.SETRANGE("Created Date", CALCDATE('-3M', TODAY), TODAY);
        if LoanApp.FINDSET then begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"Disbursedloans":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(LoanApp."No.") + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + LoanApp.Description + '",';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + LoanApp."Member No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + LoanApp."Member Name" + '",';
                ResponseMessage := ResponseMessage + '"RequestedAmt":"' + FORMAT(LoanApp."Requested Amount") + '",';
                ResponseMessage := ResponseMessage + '"ApprovedAmt":"' + FORMAT(LoanApp."Approved Amount") + '",';
                ResponseMessage := ResponseMessage + '"Installments":"' + FORMAT(LoanApp."Repayment Period") + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                if Int = LoanApp.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
            until LoanApp.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end
        //New Loan Listing============================================================================
    end;


    procedure RejectedLoanApplications(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //New Loan Listing===========================================================================
        LoanApp.RESET;
        LoanApp.SETRANGE(LoanApp.Status, LoanApp.Status::Rejected);
        LoanApp.SETRANGE("Created Date", CALCDATE('-3M', TODAY), TODAY);
        if LoanApp.FINDSET then begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"RejectedLoans":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(LoanApp."No.") + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + LoanApp.Description + '",';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + LoanApp."Member No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + LoanApp."Member Name" + '",';
                ResponseMessage := ResponseMessage + '"RequestedAmt":"' + FORMAT(LoanApp."Requested Amount") + '",';
                ResponseMessage := ResponseMessage + '"ApprovedAmt":"' + FORMAT(LoanApp."Approved Amount") + '",';
                ResponseMessage := ResponseMessage + '"Installments":"' + FORMAT(LoanApp."Repayment Period") + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                if Int = LoanApp.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
            until LoanApp.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end
        //New Loan Listing============================================================================
    end;


    procedure PendingLoanApplications(var ResponseMessage: Text; var ResponseCode: Text);
    begin
        //New Loan Listing===========================================================================
        LoanApp.RESET;
        LoanApp.SETRANGE(LoanApp.Status, LoanApp.Status::"Pending Approval");
        LoanApp.SETRANGE("Created Date", CALCDATE('-3M', TODAY), TODAY);
        if LoanApp.FINDSET then begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"Pendingloans":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"Code":"' + FORMAT(LoanApp."No.") + '",';
                ResponseMessage := ResponseMessage + '"Description":"' + LoanApp.Description + '",';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + LoanApp."Member No." + '",';
                ResponseMessage := ResponseMessage + '"MemberName":"' + LoanApp."Member Name" + '",';
                ResponseMessage := ResponseMessage + '"RequestedAmt":"' + FORMAT(LoanApp."Requested Amount") + '",';
                ResponseMessage := ResponseMessage + '"ApprovedAmt":"' + FORMAT(LoanApp."Approved Amount") + '",';
                ResponseMessage := ResponseMessage + '"Installments":"' + FORMAT(LoanApp."Repayment Period") + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                if Int = LoanApp.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
            until LoanApp.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end
        //New Loan Listing============================================================================
    end;


    procedure ApproveGuarantorship(var IDNo: Code[10]; var LoanNo: Code[10]; var Amount: Decimal; var Approve: Boolean; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        Member.RESET;
        Member.SETFILTER("National ID", IDNo);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member Does not Exist ' + IDNo;
            exit;
        end else begin
            LoanApp.RESET;
            LoanApp.SETRANGE("No.", LoanNo);
            if not LoanApp.FINDSET then begin
                ResponseCode := '01';
                ResponseMessage := 'Loan does not exist ' + LoanNo;
                exit;
            end else begin
                LoanGuarantors.RESET;
                LoanGuarantors.SETRANGE("Loan No.", LoanNo);
                LoanGuarantors.SETRANGE("Member No.", Member."No.");
                if LoanGuarantors.FINDSET then begin
                    LoanGuarantors."Amount To Guarantee" := Amount;
                    LoanGuarantors.MODIFY;
                    if Approve = true then begin
                        LoanGuarantors.Status := LoanGuarantors.Status::Approved;
                        LoanGuarantors.MODIFY;
                        ResponseCode := '00';
                        ResponseMessage := 'Amount guaranteed of ' + FORMAT(LoanGuarantors."Amount To Guarantee") + ' approved successfully';
                    end else begin
                        LoanGuarantors.Status := LoanGuarantors.Status::Rejected;
                        LoanGuarantors.MODIFY;
                        ResponseCode := '00';
                        ResponseMessage := 'Amount guaranteed of ' + FORMAT(LoanGuarantors."Amount To Guarantee") + ' rejected';
                    end;
                end else begin
                    ResponseCode := '01';
                    ResponseMessage := 'Member not in the Guarantors List ';
                end;
            end;
        end;
    end;


    procedure GuarantorApprovals(var MembNo: Code[10]; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        Member.RESET;
        Member.SETFILTER("No.", MembNo);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member Does not Exist ' + MembNo;
            exit;
        end else begin
            LoanGuarantors.RESET;
            LoanGuarantors.SETRANGE("Member No.", Member."No.");
            if not LoanGuarantors.FINDSET then begin
                ResponseCode := '01';
                ResponseMessage := 'Member does not exist in the guarantors list ';
                exit;
            end else begin
                Int := 0;
                ResponseMessage := '{';
                ResponseMessage := ResponseMessage + '"Approved_Guaranteed_Loans":[';
                repeat
                    Int += 1;
                    if LoanApp.GET(LoanGuarantors."Loan No.") then begin
                        ResponseMessage := ResponseMessage + '{"LoanNo":"' + FORMAT(LoanGuarantors."Loan No.") + '",';
                        ResponseMessage := ResponseMessage + '"Description":"' + LoanApp.Description + '",';
                        ResponseMessage := ResponseMessage + '"Loanee":"' + LoanApp."Member No." + '",';
                        ResponseMessage := ResponseMessage + '"LoaneeName":"' + LoanApp."Member Name" + '",';
                        ResponseMessage := ResponseMessage + '"GuaranteedAmt":"' + FORMAT(LoanGuarantors."Amount To Guarantee") + '",';
                        ResponseMessage := ResponseMessage + '"Status":"' + FORMAT(LoanGuarantors.Status) + '",';
                        ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                        if Int = LoanGuarantors.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
                    end;
                until LoanGuarantors.NEXT = 0;
                ResponseMessage := ResponseMessage + ']';
                ResponseMessage := ResponseMessage + '}';
                ResponseCode := '00'
            end;
        end;
    end;


    procedure LoanAppraisal(var LoanNo: Code[10]; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        LoanApp.RESET;
        LoanApp.SETRANGE("No.", LoanNo);
        //LoanApp.SETRANGE("Disbursal Date",CALCDATE('-5M',TODAY),TODAY);
        if not LoanApp.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Loan does not exist';
        end else begin
            ResponseCode := '00';
            ResponseMessage := GetStatement(LoanNo, EmptyData, EmptyData, EmptyData);
        end;
    end;


    procedure AppraisalComment(var MembNo: Code[10]; var LoanNo: Code[10]; var Comment: Text; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        Member.RESET;
        Member.SETFILTER("No.", MembNo);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member Does not Exist ' + MembNo;
            exit;
        end else begin
            LoanApp.RESET;
            LoanApp.SETFILTER("No.", LoanNo);
            if not LoanApp.FINDSET then begin
                ResponseCode := '01';
                ResponseMessage := 'Loan does not exist ' + FORMAT(LoanNo);
                exit;
            end else begin
                AppraisalComments.INIT;
                AppraisalComments.RESET;
                AppraisalComments.SETRANGE("Loan No", LoanNo);
                if AppraisalComments.FINDLAST then
                    AppraisalComments.No := AppraisalComments.No + 1000;
                AppraisalComments."Loan No" := LoanNo;
                AppraisalComments."Commented By" := Member."No.";
                AppraisalComments.Name := Member."Full Name";
                AppraisalComments.Comment := Comment;
                AppraisalComments.Date := TODAY;
                AppraisalComments.Time := TIME;
                if AppraisalComments.INSERT then begin
                    ResponseMessage := 'Appraisal Comment Uploaded';
                    ResponseCode := '00';
                end;
            end;
        end;
    end;


    procedure AppraisalCommentList(var LoanNo: Code[10]; var ResponseMessage: Text; var ResponseCode: Text);
    begin
        AppraisalComments.RESET;
        AppraisalComments.SETFILTER(Comment, '<>%1', '');
        AppraisalComments.SETRANGE("Loan No", LoanNo);
        if not AppraisalComments.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Comment does not exist ';
            exit;
        end else begin
            Int := 0;
            ResponseMessage := '{';
            ResponseMessage := ResponseMessage + '"AppraisalCommentList":[';
            repeat
                Int += 1;
                ResponseMessage := ResponseMessage + '{"LoanNo":"' + FORMAT(LoanNo) + '",';
                ResponseMessage := ResponseMessage + '"MemberNo":"' + AppraisalComments."Commented By" + '",';
                if LoanApp.GET(LoanNo) then begin
                    ResponseMessage := ResponseMessage + '"MemberName":"' + LoanApp."Member Name" + '",';
                    ResponseMessage := ResponseMessage + '"LoanType":"' + LoanApp.Description + '",';
                end;
                ResponseMessage := ResponseMessage + '"AppraisalComment":"' + AppraisalComments.Comment + '",';
                ResponseMessage := COPYSTR(ResponseMessage, 1, STRLEN(ResponseMessage) - 1);
                if Int = AppraisalComments.COUNT then ResponseMessage := ResponseMessage + '}' else ResponseMessage := ResponseMessage + '},';
            until AppraisalComments.NEXT = 0;
            ResponseMessage := ResponseMessage + ']';
            ResponseMessage := ResponseMessage + '}';
            ResponseCode := '00';
        end;
    end;


    procedure LoanApplicationProcess(var IdNumber: Code[10]; var LoanType: Code[20]; var Amount: Decimal; var RepaymentPeriod: Decimal; var LoanSector: Code[10]; var LoanSubsector: Code[10]; var LoansubsectorItem: Code[10]; var Employer: Code[10]; var GrossIncome: Decimal; var NetIncome: Decimal; var ResponseMessage: Text; var ResponseCode: Text);
    var
        LoanNo: Code[10];
        RepayPeriodTxt: Text;
    begin
        RepayPeriodTxt := '';
        Member.RESET;
        Member.SETFILTER("National ID", IdNumber);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not exist ' + FORMAT(IdNumber);

            //ResponseMessage:='';
            //ResponseMessage+'{"LoanNo":"'+FORMAT(LoanNo)+'",';
            // ResponseMessage:=ResponseMessage+'"Loan Application Process completed successfully": ,"LoanNo": ';
            // ResponseMessage:=ResponseMessage+'';}

            exit;
        end else begin
            if not LoanProductTypes.GET(LoanType) then begin
                ResponseCode := '01';
                ResponseMessage := 'Loan Product does not exist ' + FORMAT(LoanType);
                exit;
            end else begin
                LoanSetup.GET;
                LoanApp.INIT;
                LoanNo := NoSeriesManagement.GetNextNo(LoanSetup."Loan Application Nos.", TODAY, true);
                LoanApp."No." := LoanNo;
                LoanApp."Member No." := Member."No.";
                LoanApp.VALIDATE("Member No.");
                LoanApp."Member Name" := Member."Full Name";
                LoanApp."Loan Product Type" := LoanType;
                if LoanProductTypes.GET(LoanType) then begin
                    /*if not LoanProductTypes.Active then begin
                        ResponseCode := '01';
                        ResponseMessage := 'Loan Product is Inactive ' + FORMAT(LoanType);
                        exit
                    end else begin*/
                    Loans.RESET;
                    Loans.SETRANGE("Member No.", Member."No.");
                    Loans.SETRANGE("Loan Product Type", LoanType);
                    Loans.SETRANGE(Posted, true);
                    Loans.SETFILTER("Outstanding Balance", '>%1', 0);
                    if Loans.FINDSET then begin
                        ResponseCode := '01';
                        ResponseMessage := 'Loan Product already exists ' + FORMAT(LoanType);
                        exit;
                    end;
                    LoanApp."Interest Rate" := LoanProductTypes."Interest Rate";
                    LoanApp.Description := LoanProductTypes.Description;
                    LoanApp."Requested Amount" := Amount;
                    if Amount > LoanProductTypes."Max. Loan Amount" then begin
                        ResponseCode := '01';
                        ResponseMessage := 'Requested amount cannot be more than loan limit ';
                        exit;
                    end;
                    Evaluate(RepaymentPeriod, RepayPeriodTxt);
                    RepayPeriodTxt := RepayPeriodTxt + 'M';
                    //LoanApp."Repayment Period" := RepayPeriodTxt;
                    LoanApp."Repayment Frequency" := LoanProductTypes."Repayment Frequency";
                    LoanApp."Repayment Method" := LoanProductTypes."Repayment Method";
                    LoanApp."Created Date" := TODAY;
                    LoanApp."Economic Sector" := LoanSector;
                    LoanApp."Economic Sector Category" := LoanSubsector;
                    LoanApp."Economic Sector Sub-Category" := LoansubsectorItem;
                    LoanApp.VALIDATE("Economic Sector Sub-Category");
                    LoanApp."Basic Salary" := GrossIncome;
                    LoanApp."Net Amount" := NetIncome;
                    LoanApp."Portal Loan" := true;
                    if not LoanApp.INSERT then begin
                        ResponseCode := '01';
                        ResponseMessage := 'Loan Application process not successful';
                        exit
                    end else begin
                        ResponseMessage := '{';
                        //ResponseMessage:=ResponseMessage+'"Loan Application Process completed successfully ,"\
                        ResponseMessage := ResponseMessage + '"Response":"Loan Application Process completed successfully",'
                        + '"LoanNo":"' + FORMAT(LoanNo) + '"';
                        ResponseMessage := ResponseMessage + '}';
                        ResponseCode := '00';
                    end
                end;
            end;
        end;
    end;
    //end;


    procedure AddGuarantor(var IdNumber: Text; var LoanNo: Code[10]; var Amount: Decimal; var ResponseMessage: Text; var ResponseCode: Text);
    var
        LoanApplication: Record "Loan Application";
        Response_Message: array[5] of Text;
        FoundGuarantor: Boolean;
    begin
        //MESSAGE('ID %1',MemberID);
        Member.RESET;
        Member.SETRANGE("National ID", IdNumber);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end else begin
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", Member."No.");
            Vendor.SETRANGE("Account Type", '01');
            if Vendor.FINDSET then begin
                AccBal := 0;
                OtherGuaranteedAmt := 0;
                AccBal := GlobalM.GetAccountBalance(0, Vendor."No.");
                OtherGuaranteedAmt := CalculateGuaranteedAmount(Member."No.");
                NetAccBal := AccBal - OtherGuaranteedAmt;
                if NetAccBal <= 0 then begin
                    ResponseCode := '01';
                    ResponseMessage := 'Member does not have enough amount to guarantee!';
                    exit;
                end else begin
                    if Amount > NetAccBal then begin
                        ResponseCode := '01';
                        ResponseMessage := 'Amount guaranteed can not exceed available balance of ' + FORMAT(NetAccBal);
                    end else begin
                        LoanGuarantors.INIT;
                        LoanGuarantors.RESET;
                        LoanGuarantors.SETRANGE("Loan No.", LoanNo);
                        if LoanGuarantors.FINDLAST then
                            LoanGuarantors."Line No." := LoanGuarantors."Line No." + 1000;
                        LoanGuarantors."Loan No." := LoanNo;
                        LoanGuarantors."Member No." := Member."No.";
                        LoanGuarantors.VALIDATE("Member No.");
                        //LoanGuarantors."Member Name":=Member."Full Name";
                        LoanGuarantors."Account No." := Vendor."No.";
                        LoanGuarantors.VALIDATE("Account No.");
                        //LoanGuarantors."Account Name":=Vendor.Name;
                        //LoanGuarantors."Account Balance":=AccBal;
                        LoanGuarantors."Amount To Guarantee" := Amount;
                        LoanGuarantors.VALIDATE("Amount To Guarantee");
                        if LoanGuarantors.INSERT then begin
                            if Loans.GET(LoanNo) then
                                SendSMS(Member."No.", Amount, IdNumber, Loans."Member Name");
                            ResponseCode := '00';
                            ResponseMessage := 'Successfully Guaranteed';
                        end;
                    end;
                end;
            end;
        end;
    end;


    procedure AddSecurity(var IdNumber: Text; var LoanNo: Code[10]; var SecurityType: Code[10]; var Amount: Decimal; var Description: Text; var ResponseMessage: Text; var ResponseCode: Text);
    var
        LoanApplication: Record "Loan Application";
        Response_Message: array[5] of Text;
        FoundGuarantor: Boolean;
    begin
        //MESSAGE('ID %1',MemberID);
        Member.RESET;
        Member.SETRANGE("National ID", IdNumber);
        if not Member.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Member does not Exist!';
            exit;
        end else begin
            LoanApp.RESET;
            LoanApp.SETRANGE("No.", LoanNo);
            if not LoanApp.FINDSET then begin
                ResponseCode := '01';
                ResponseMessage := 'Loan does not exist ' + FORMAT(LoanNo);
                exit;
            end else begin
                LoanSecurity.INIT;
                LoanSecurity.RESET;
                LoanSecurity.SETRANGE("Loan No.", LoanNo);
                if LoanSecurity.FINDLAST then
                    LoanSecurity."Line No." := LoanSecurity."Line No." + 1000;
                LoanSecurity."Loan No." := LoanNo;
                LoanSecurity."Security Register Code" := SecurityType;
                LoanSecurity.VALIDATE("Security Register Code");
                LoanSecurity.Description := Description;
                LoanSecurity."Guaranteed Amount" := Amount;
                //LoanSecurity."Loan Product" := LoanApp.Description;
                if LoanSecurity.INSERT then begin
                    ResponseCode := '00';
                    ResponseMessage := 'Security successfully uploaded';
                end;
            end;
        end;
    end;


    procedure FnGenerateStatement(filenamefromapp: Text; LoanNo: Code[20]) Executed: Boolean;
    var
        filename: Text;
    //charges: Record "Activation Type";
    begin
        Executed := false;
        filename := FILESPATH + filenamefromapp;
        if EXISTS(filename) then
            ERASE(filename);
        //
        LoanApp.RESET;
        LoanApp.SETRANGE("No.", LoanNo);
        if LoanApp.FINDSET then
            myReport.SETTABLEVIEW(LoanApp);
        //
        LoanGuarantors.RESET;
        LoanGuarantors.SETRANGE("Loan No.", LoanNo);
        if LoanGuarantors.FIND('-') then begin
            myReport.SETTABLEVIEW(LoanGuarantors);
        end;
        LoanSecurity.RESET;
        LoanSecurity.SETRANGE("Loan No.", LoanNo);
        if LoanSecurity.FIND('-') then begin
            myReport.SETTABLEVIEW(LoanSecurity);
        end;
        LoanTopup.RESET;
        LoanTopup.SETRANGE("Loan No.", LoanNo);
        if LoanTopup.FIND('-') then begin
            myReport.SETTABLEVIEW(LoanTopup);
        end;
        if myReport.SAVEASPDF(filename) then begin
            Executed := true;
        end;
    end;

    local procedure GetStatement(var LoanNo: Code[10]; var ResponseCode: Text; var ResponseMessage: Text; var ErrorMessage: Text) transactiondata: Text;
    begin
        LoanApp.RESET;
        LoanApp.SETRANGE("No.", LoanNo);
        //LoanApp.SETRANGE("Disbursal Date",CALCDATE('-5M',TODAY),TODAY);
        if LoanApp.FINDSET then begin
            transactiondata := '<html>';
            transactiondata += '<body>';

            transactiondata += ' <h3>LoanInformation </h3>';

            transactiondata += '<p> LoanNo : ' + FORMAT(LoanApp."No.") + ' </p>';
            transactiondata += '<p> ApplicationDate: ' + FORMAT(LoanApp."Created Date") + ' </p>';
            transactiondata += '<p> LoanType: ' + FORMAT(LoanApp.Description) + ' </p>';
            transactiondata += '<p> MemberNo: ' + FORMAT(LoanApp."Member No.") + ' </p>';
            transactiondata += '<p> MemberName: ' + FORMAT(LoanApp."Member Name") + ' </p>';
            transactiondata += '<p> AmountApplied: ' + FORMAT(LoanApp."Requested Amount") + ' </p>';
            transactiondata += '<p> Installments: ' + FORMAT(LoanApp."Repayment Period") + ' </p>';
            transactiondata += '<p> NoofGuarantors ' + FORMAT(LoanApp."No. of Guarantors") + ' </p>';
            // transactiondata += '<p> Repayment: ' + FORMAT(ROUND((LoanApp."Approved Amount" / LoanApp."Repayment Period"), 1, '>')) + ' </p>';
            if Member.GET(LoanApp."Member No.") then
                // transactiondata += '<p>Employer: ' + FORMAT(Member."Company Code") + ' </p>';
                transactiondata += '<br>';
            transactiondata += '</html>';
            transactiondata += '</body>';

            transactiondata += '<html>';
            transactiondata += '<body>';
            transactiondata += '<h3> DepositInformation </h3>';
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", LoanApp."Member No.");
            Vendor.SETRANGE("Account Type", '01');
            if Vendor.FINDSET then begin
                MembBal := 0;
                MembBal := GlobalM.GetAccountBalance(0, Vendor."No.");
                transactiondata += '<p> MemberDeposit ' + FORMAT(MembBal) + ' </p>';
            end;
            transactiondata += '<p> DepositMultiplier ' + FORMAT(MembBal * 3) + ' </p>';
            transactiondata += '<p> LoanBalance ' + FORMAT(BOSAManagement.CalculateOtherLoanBalances(LoanApp."Member No.")) + ' </p>';
            transactiondata += '<p> TopUpAmount ' + FORMAT(LoanApp."Total Refinanced Amount") + ' </p>';
            transactiondata += '<p> BalanceAfterTopup ' + FORMAT(LoanApp."Approved Amount" - LoanApp."Total Refinanced Amount") + ' </p>';
            transactiondata += '<p> AmountAvailable ' + FORMAT((MembBal * 3) - BOSAManagement.CalculateOtherLoanBalances(LoanApp."Member No.")) + ' </p>';
            transactiondata += '<br>';
            transactiondata += '</html>';
            transactiondata += '</body>';

            LoanGuarantors.RESET;
            LoanGuarantors.SETRANGE("Loan No.", LoanApp."No.");
            if LoanGuarantors.FINDSET then begin
                transactiondata += '<html>';
                transactiondata += '<body>';
                transactiondata += '<h3> GuarantorsInformation </h3>';
                repeat
                    transactiondata += '<p> GuarantorNo ' + FORMAT(LoanGuarantors."Member No.") + ' </p>';
                    transactiondata += '<p> TopUpAmount ' + FORMAT(LoanGuarantors."Member Name") + ' </p>';
                    transactiondata += '<p> TopUpAmount ' + FORMAT(LoanGuarantors."Amount To Guarantee") + ' </p>';
                    transactiondata += '<br>';
                until LoanGuarantors.NEXT = 0;
                transactiondata += '<br>';
                transactiondata += '</html>';
                transactiondata += '</body>';
            end;
            LoanTopup.RESET;
            LoanTopup.SETRANGE("Loan To Refinance", LoanApp."No.");
            if LoanTopup.FINDSET then begin
                transactiondata += '<html>';
                transactiondata += '<body>';
                transactiondata += '<h3> TopupInformation </h3>';
                repeat
                    if LoanApp.GET(LoanTopup."Loan No.") then
                        transactiondata += '<p> LoanType ' + FORMAT(LoanApp.Description) + ' </p>';
                    transactiondata += '<p> OutstandingBalance ' + FORMAT(LoanTopup."Outstanding Balance") + ' </p>';
                    //transactiondata += '<p> Interest ' + FORMAT(LoanTopup.Interest) + ' </p>';
                    //transactiondata += '<p> Total ' + FORMAT(LoanTopup.Total) + ' </p>';
                    transactiondata += '<br>';
                until LoanTopup.NEXT = 0;
                transactiondata += '<br>';
                transactiondata += '</html>';
                transactiondata += '</body>';
            end;

            transactiondata += '</html>';
            transactiondata += '</body>';
            transactiondata += '<h3> QualificationCriteria </h3>';
            LoanGuarantors.RESET;
            LoanGuarantors.SETRANGE("Loan No.", LoanApp."No.");
            LoanGuarantors.CALCSUMS("Amount To Guarantee");
            transactiondata += '<p> QualificationbyGuarantors ' + FORMAT(LoanGuarantors."Amount To Guarantee") + ' </p>';
            transactiondata += '<p> QualificationbyDeposits ' + FORMAT(MembBal) + ' </p>';
            transactiondata += '<p> AppliedAmount ' + FORMAT(LoanApp."Requested Amount") + ' </p>';
            transactiondata += '<p> ApprovedAmount ' + FORMAT(LoanApp."Approved Amount") + ' </p>';
            transactiondata += '<br>';
            transactiondata += '<br>';
            transactiondata += '</html>';
            transactiondata += '</body>';

            ResponseCode := '00';
            ResponseMessage := transactiondata;

        end;
    end;

    procedure UploadAttachedDocument(var LoanNo: Code[20]; var FileDescription: Text[250]; var Attachment: BigText; var ResponseCode: Code[10]; var ResponseMessage: Text);
    var
        DocAttachment: Record "Document Attachment";
        TableFound: Boolean;
        FromRecRef: RecordRef;
        FileManagement: Codeunit "File Management";
        Bytes: DotNet SArray;
        Convert: DotNet Convert;
        MemoryStream: DotNet MemoryStream;
        Ostream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        //ObjProfile: Record MemberSharesUpdate;
        //ObjContacts: Record "Activation Charge Line";
        ObjServices: Record "Priority Posting";
    begin
        LoanApp.RESET;
        LoanApp.SETRANGE("No.", LoanNo);
        if not LoanApp.FINDSET then begin
            ResponseCode := '01';
            ResponseMessage := 'Loan does not exist ' + FORMAT(LoanNo);
            exit;
        end else begin
            FromRecRef.GETTABLE(LoanApp);
            Bytes := Convert.FromBase64String(Attachment);
            MemoryStream := MemoryStream.MemoryStream(Bytes);
            TempBlob.CreateOutStream(Ostream);
            MemoryStream.WriteTo(Ostream);
            DocAttachment.SaveAttachment(FromRecRef, FileDescription, TempBlob);
            ResponseCode := '00';
            ResponseMessage := 'Attachment Uploaded';
        end;


    end;

    local procedure SendSMS(MembNo: Code[10]; Amount: Decimal; ID: Code[10]; Name: Text);
    var
        SMSEntry: Record "SMS Entry";
        SMSText: Text;
        OStream: OutStream;
    begin
        if Member.GET(MembNo) then begin
            if Member."Phone No." <> '' then begin
                SMSText := 'Dear ' + Member."Full Name" + ',' + ' You have guaranteed an amount of KES ' + FORMAT(Amount) + ' to ' + Name + ' ID No:' + ID + '. ' +
                         'Please login at https://jachinsaccoportal.com:445/ to approve request.';
                if SMSEntry.FINDLAST then
                    Int := SMSEntry."Entry No."
                else
                    Int := 0;
                SMSEntry.INIT;
                SMSEntry."Entry No." := Int + 1;
                SMSEntry."Phone No." := Member."Phone No.";
                //SMSEntry.Message := SMSText;
                SMSEntry."SMS Text".CREATEOUTSTREAM(OStream);
                OStream.WRITE(SMSText);
                //SMSEntry."SMS Text" := SMSText;
                SMSEntry."Created Date" := TODAY;
                SMSEntry."Created Time" := TIME;
                SMSEntry."Source Code" := 'GUARSMS';
                SMSEntry.INSERT;
            end;
        end;
    end;
}

