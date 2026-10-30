codeunit 50937 "MicroCredit Management"
{
    trigger OnRun();
    begin

    end;

    var
        Text000: TextConst ENU = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ+,=-)@$%^&*!/\';
        Error000: Label 'Phone No. cannot contain characters.';
        Error001: Label 'Phone No. cannot exceed 10 characters.';
        i: Integer;

        GlobalManagement: Codeunit "Global Management";
        BOSAManagement: Codeunit "BOSA Management";
        MicroCreditSetup: Record "Microcredit Setup";
        FundTransferSetup: Record "Fund Transfer Setup";
        StandingOrderSetup: Record "Standing Order Setup";
        LoanApplicationSetup: Record "Loan Application Setup";
        Error002: Label 'Posting failed';
        Error003: Label 'Email Address is not valid';
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        "InstallmentNo.": Integer;
        LoanBalance: Decimal;
        LoanPrincipal: Decimal;
        LoanInterest: Decimal;
        TotalMonthlyRepayment: Decimal;
        Error004: Label 'Client must be 18 years and above.';
        Error005: Label 'Registration Date cannot be TODAY or future date';
        Vendor: Record Vendor;
        MicroCreditMember: Record Member;
        Text001: Label 'Loan %1 has been disbursed successfully!';
        MicroCreditMember2: Record Member;
        LoanProductType: Record "Loan Product Type";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Error006: Label 'Refund/Membership request for member %1 already exist.';
        RepaymentDate: array[4] of Date;
        RepaymentPeriod: array[4] of Integer;
        IncrementalAmount: Decimal;
        Text002: Label '"Loan Recovery "';
        Error007: Label 'No amount to recover.';
        Text003: Label '"Refund "';
        Text004: Label 'Accounts for member %1 %2 have been closed successfully';
        Error008: Label 'You have another loan(s) with outstanding balance.';
        Error009: Label 'You do not qualify for another loan since the previous loan was no paid on time.';
        Text005: Label '"Payment for "';
        Text006: Label '-Prin. in Arrears';
        Text007: Label '-Int. In Arrears';
        Text008: Label '-Principal Paid';
        Text009: Label '-Interest Paid';
        //   TableSetup : Record "52046";
        //     FieldUserAccess : Record "52047";
        Error010: Label 'You are not allowed to change %1 field.';
        Error011: Label 'You are not allowed to create new record';
        Error012: Label 'You are not allowed to delete this record';
        Error013: Label 'Remarks must be at least 100 characters.';
        Text012: Label '"Standing Order "';
        RemArrearsAmount: array[4] of Decimal;
        RemDueAmount: array[4] of Decimal;
        RemainingAmount: array[4] of Decimal;
        Error014: Label 'Phone No. cannot be less than 10 characters.';
        Text013: Label 'You about to recover arrears from member %1 %2. Click Yes to proceed.';
        Error015: Label '%1 cannot be empty';
        Text015: Label 'Document No. %1 is already posted';
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        SourceCodeSetup: Record "Source Code Setup";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";

    /* [EventSubscriber(ObjectType::Table, 50000, 'OnAfterValidateEvent', 'Phone No.', false, false)]
     local procedure OnAfterMemberApplicationValidatePhoneNo(var Rec: Record 50000; var xRec: Record 50000; CurrFieldNo: Integer);
     begin
         if Rec."Phone No." <> '' then begin
             if IsNumeric(Rec."Phone No.") > 0 then
                 ERROR(Error000);

             if STRLEN(Rec."Phone No.") > 10 then begin
                 if COPYSTR(Rec."Phone No.", 1, 4) = '+254' then begin
                     Rec."Phone No." := '0' + COPYSTR(Rec."Phone No.", 5, 13);
                     Rec.modify;
                end else begin
                     ERROR(Error001);
                end;
            end;

             if STRLEN(Rec."Phone No.") < 10 then
                 ERROR(Error014)
        end;
    end;

     [EventSubscriber(ObjectType::Table, 50006, 'OnAfterValidateEvent', 'Phone No.', false, false)]
     local procedure OnAfterMicroCreditMemberValidatePhoneNo(var Rec: Record Member; var xRec: Record Member; CurrFieldNo: Integer);
     begin
         if Rec."Phone No." <> '' then begin
             if IsNumeric(Rec."Phone No.") > 0 then
                 ERROR(Error000);

             if STRLEN(Rec."Phone No.") > 10 then
                 ERROR(Error001);

             if STRLEN(Rec."Phone No.") < 10 then
                 ERROR(Error014);
        end;
    end;

     [EventSubscriber(ObjectType::Table, 50000, 'OnAfterValidateEvent', 'E-mail', false, false)]
     local procedure OnAfterMemberApplicationValidateEmail(var Rec: Record 50000; var xRec: Record 50000; CurrFieldNo: Integer);
     begin
         if Rec."Email Address" <> '' then begin
             if NOT IsValidEmail(Rec."Email Address") then
                 ERROR(Error003);
        end;
    end;

     [EventSubscriber(ObjectType::Table, 50006, 'OnAfterValidateEvent', 'E-mail', false, false)]
     local procedure OnAfterMicroCreditMemberValidateEmail(var Rec: Record 50006; var xRec: Record 50006; CurrFieldNo: Integer);
     begin
         if Rec."Email Address" <> '' then begin
             if NOT IsValidEmail(Rec."Email Address") then
                 ERROR(Error003);
        end;
    end;

     [EventSubscriber(ObjectType::Table, 50000, 'OnAfterValidateEvent', 'Date of Birth', false, false)]
     local procedure OnAfterMemberApplicationValidateDoB(var Rec: Record 50000; var xRec: Record 50000; CurrFieldNo: Integer);
     var
         Year: array[4] of Integer;
     begin
         if NOT IsClientOver18(Rec."Date of Birth") then
             ERROR(Error004);
    end;

     [EventSubscriber(ObjectType::Table, 50006, 'OnAfterValidateEvent', 'Date of Birth', false, false)]
     local procedure OnAfterMicroCreditMemberValidateDoB(var Rec: Record 50006; var xRec: Record 50006; CurrFieldNo: Integer);
     begin
         if NOT IsClientOver18(Rec."Date of Birth") then
             ERROR(Error004);
    end;

     [EventSubscriber(ObjectType::Table, 50000, 'OnAfterValidateEvent', 'National ID/Passport No.', false, false)]
     local procedure OnAfterMemberApplicationValidateNationalIDPassport(var Rec: Record 50000; var xRec: Record 50000; CurrFieldNo: Integer);
     var
         Year: array[4] of Integer;
     begin
         if Rec."National ID/Passport No." <> '' then begin
             if IsNumeric(Rec."National ID/Passport No.") > 0 then
                 ERROR(Error000);
        end;
    end;

     [EventSubscriber(ObjectType::Table, 50006, 'OnAfterValidateEvent', 'National ID/Passport No.', false, false)]
     local procedure OnAfterMicroCreditMemberValidateNationalIDPassport(var Rec: Record 50006; var xRec: Record 50006; CurrFieldNo: Integer);
     begin
         if Rec."National ID/Passport No." <> '' then begin
             if IsNumeric(Rec."National ID/Passport No.") > 0 then
                 ERROR(Error000);
        end;
    end;

     [EventSubscriber(ObjectType::Table, 50000, 'OnAfterValidateEvent', 'Group Registration Date', false, false)]
     local procedure OnAfterMemberApplicationValidateGroupRegDate(var Rec: Record 50000; var xRec: Record 50000; CurrFieldNo: Integer);
     var
         Year: array[4] of Integer;
     begin
         if Rec."Group Registration Date" >= TODAY then
             ERROR(Error005);
    end;

     [EventSubscriber(ObjectType::Table, 50006, 'OnAfterValidateEvent', 'Group Registration Date', false, false)]
     local procedure OnAfterMicroCreditMemberValidateGroupRegDate(var Rec: Record 50006; var xRec: Record 50006; CurrFieldNo: Integer);
     begin
         if Rec."Group Registration Date" >= TODAY then
             ERROR(Error005);
    end;

     [EventSubscriber(ObjectType::Table, 52026, 'OnAfterValidateEvent', 'Remarks', false, false)]
     local procedure OnAfterMicroCreditLoanReschedulingRemarks(var Rec: Record "52026"; var xRec: Record "52026"; CurrFieldNo: Integer);
     var
         RemarkLen: Integer;
     begin
         RemarkLen := STRLEN(Rec.Remarks);
         if RemarkLen < 100 then
             ERROR(Error013);
    end;

     procedure IsNumeric(Variant: Code[20]): Integer;
     var
         j: Integer;
     begin
         FOR i := 1 TO STRLEN(Variant) DO begin
             if NOT (Variant[i] IN ['0' .. '9', '+']) then
                 j += 1;
        end;
         EXIT(j);
    end;

     local procedure IsValidEmail(EmailAddress: Code[20]): Boolean;
     var
         Email: Code[20];
         Regex: DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
         RegexOptions: DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.RegexOptions";
         Pattern: Text[50];
         Result: Boolean;
     begin
         Pattern := '^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$';

         RegexOptions := 0;
         RegexOptions := RegexOptions.Parse(RegexOptions.GetType(), 'IgnoreCase');

         Result := Regex.IsMatch(EmailAddress, Pattern, RegexOptions);

         EXIT(Result);
    end;

     local procedure IsClientOver18(Variant: Date): Boolean;
     var
         Year: array[4] of Integer;
     begin
         Year[1] := DATE2DMY(Variant, 3);
         Year[2] := DATE2DMY(TODAY, 3);
         if (Year[2] - Year[1]) >= 18 then
             EXIT(TRUE)
         else
             EXIT(FALSE);
    end;

    procedure InitiateRefundMembershipRequest(MicroCreditMember: Record 50006; "Action": Integer);
    var
        MemberExitHeader: Record "52028";
        MemberExitLine: Record "52029";
        MemberRefundMembershipHeader: Record "52032";
        MemberRefundMembershipLine: Record "52033";
    begin
        WITH MicroCreditMember DO begin
            MicroCreditSetup.GET;
            if MemberExitHeader.GET("Exit Application No.") then begin
                MemberRefundMembershipHeader.RESET;
                MemberRefundMembershipHeader.SETRANGE("Exit Application No.", "Exit Application No.");
                if MemberRefundMembershipHeader.FINDFIRST then
                    ERROR(Error006, "No.", "Full Name");
                MemberRefundMembershipHeader.TRANSFERFIELDS(MemberExitHeader);
                if Action = 1 then begin
                    MemberRefundMembershipHeader."No." := NoSeriesManagement.GetNextNo(MicroCreditSetup."Exit Membership Nos.", TODAY, TRUE);
                    MemberRefundMembershipHeader."Action Type" := MemberRefundMembershipHeader."Action Type"::Membership;
                    MemberRefundMembershipHeader."No. Series" := MicroCreditSetup."Exit Membership Nos.";
               end;
                if Action = 2 then begin
                    MemberRefundMembershipHeader."No." := NoSeriesManagement.GetNextNo(MicroCreditSetup."Exit Refund Nos.", TODAY, TRUE);
                    MemberRefundMembershipHeader."Action Type" := MemberRefundMembershipHeader."Action Type"::Refund;
                    MemberRefundMembershipHeader."No. Series" := MicroCreditSetup."Exit Refund Nos.";
               end;
                MemberRefundMembershipHeader."Exit Application No." := "Exit Application No.";
                MemberRefundMembershipHeader."Created By" := USERID;
                MemberRefundMembershipHeader.Status := MemberRefundMembershipHeader.Status::New;
                if MemberRefundMembershipHeader.INSERT then begin
                    MemberExitLine.RESET;
                    MemberExitLine.SETRANGE("Document No.", "Exit Application No.");
                    if MemberExitLine.FINDSET then begin
                        REPEAT
                            MemberRefundMembershipLine.TRANSFERFIELDS(MemberExitLine);
                            MemberRefundMembershipLine."Document No." := MemberRefundMembershipHeader."No.";
                            MemberRefundMembershipLine."Remaining Amount" := MemberExitLine."Account Balance";
                            MemberRefundMembershipLine.INSERT;
                        UNTIL MemberExitLine.NEXT = 0;
                   end;
                    PAGE.RUN(55054, MemberRefundMembershipHeader);
               end;
           end;
       end;
   end;*/

    procedure CopyCollectionEntries(DocumentNo: Code[20]; GroupNo: Code[20]; StartDate: Date; endDate: Date);
    var
        GroupCollectionEntry: Record "Group Collection Entry";
        GroupAllocationLine: Record "Group Allocation Line";
        LineNo: Integer;
    begin
        if GroupAllocationLine.GET(DocumentNo, '') then
            GroupAllocationLine.DELETE;

        GroupCollectionEntry.RESET;
        GroupCollectionEntry.SETRANGE("Group No.", GroupNo);
        //GroupCollectionEntry.SETRANGE("Transaction Date",StartDate,EndDate);
        GroupCollectionEntry.SETRANGE("Posting Status", GroupCollectionEntry."Posting Status"::Success);
        if GroupCollectionEntry.FINDSET then begin
            REPEAT
                if GroupCollectionEntry."Remaining Amount" > 0 then begin
                    GroupAllocationLine."Document No." := DocumentNo;
                    GroupAllocationLine."Transaction No." := GroupCollectionEntry."Transaction No.";
                    GroupAllocationLine."Transaction Date" := GroupCollectionEntry."Transaction Date";
                    GroupAllocationLine."Transaction Time" := GroupCollectionEntry."Transaction Time";
                    GroupAllocationLine.Description := GroupCollectionEntry.Description;
                    GroupAllocationLine."Sender Name" := GroupCollectionEntry."Sender Name";
                    GroupAllocationLine."Deposited Amount" := GroupCollectionEntry."Deposited Amount";
                    GroupAllocationLine."Amount to Allocate" := GroupCollectionEntry."Remaining Amount";
                    GroupAllocationLine.VALIDATE("Phone No.", GroupCollectionEntry."Phone No.");
                    GroupAllocationLine."Group No." := GroupCollectionEntry."Group No.";
                    GroupAllocationLine."Remaining Amount" := GroupCollectionEntry."Remaining Amount";
                    GroupAllocationLine.INSERT;
                end;
            UNTIL GroupCollectionEntry.NEXT = 0;
        end;
    end;



    local procedure GetTotalLoanAllocationAmount(GroupMemberAllocation: Record "Group Member Allocation"): Decimal;
    var
        yGroupMemberAllocation: Record "Group Member Allocation";
    begin
        WITH GroupMemberAllocation DO begin
            yGroupMemberAllocation.RESET;
            yGroupMemberAllocation.SETRANGE("Document No.", "Document No.");
            yGroupMemberAllocation.SETRANGE("Account No.", "Account No.");
            yGroupMemberAllocation.CALCSUMS("Allocation Amount");
            EXIT(yGroupMemberAllocation."Allocation Amount");
        end;
    end;



    procedure PostGroupCollectionEntry(var GroupCollectionEntry: Record "Group Collection Entry"): Boolean;
    var
        GenJournalLine: Record "Gen. Journal Line";
        DebitAccountType: Integer;
    begin
        WITH GroupCollectionEntry DO begin
            MicroCreditSetup.GET;
            if "Source Code" = 'Mobile Banking' then
                DebitAccountType := 0
            else
                DebitAccountType := 3;
            ClearJournal(MicroCreditSetup."GP Collection Template Name", MicroCreditSetup."GP Collection Batch Name");
            GlobalManagement.CreateJournal(MicroCreditSetup."GP Collection Template Name", MicroCreditSetup."GP Collection Batch Name", "Transaction No.", "Transaction No.", "Transaction Date",
                          DebitAccountType, "Debit Account Code", Description, "Deposited Amount", '', '', '', GetBranchCode("Group No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            GlobalManagement.CreateJournal(MicroCreditSetup."GP Collection Template Name", MicroCreditSetup."GP Collection Batch Name", "Transaction No.", "Transaction No.", "Transaction Date",
                          GenJournalLine."Account Type"::Vendor, GetGroupInTransitAccount("Group No."), Description, -"Deposited Amount", '', '', '', GetBranchCode("Group No."), BalAccountTypeEnum::"G/L Account", '', AppliesToDocTypeEnum::" ", '', '');
            if GlobalManagement.PostJournal(MicroCreditSetup."GP Collection Template Name", MicroCreditSetup."GP Collection Batch Name") then
                "Posting Status" := "Posting Status"::Success;
            if modify then
                EXIT(TRUE)
            else
                // EXIT(FALSE)
                ERROR(GETLASTERRORTEXT);
        end;
    end;

    local procedure GetGroupInTransitAccount(MemberNo: Code[20]): Code[20];
    var
        Vendor: Record Vendor;
    begin
        MicroCreditSetup.GET;
        Vendor.RESET;
        Vendor.SETRANGE("Account Type", MicroCreditSetup."Group In-Transit Account Type");
        Vendor.SETRANGE("Member No.", MemberNo);
        if Vendor.FINDFIRST then
            EXIT(Vendor."No.");
    end;

    local procedure GetBranchCode(MemberNo: Code[20]): Code[20];
    var
        MicroCreditMember: Record Member;
    begin
        if MicroCreditMember.GET(MemberNo) then
            EXIT(MicroCreditMember."Global Dimension 1 Code");
    end;

    procedure ClearJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]);
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJournalLine.DELETEALL;
    end;
    /*
    procedure PostRegistrationFee(MicroCreditMember: Record 50006);
    begin
    MicroCreditSetup.GET;
    //GlobalManagement.CreateJournal("No.",GroupMemberAllocation."Transaction No.",GenJournalLine."Account Type"::Vendor,GroupMemberAllocation."Account No.",Description,-GroupMemberAllocation."Allocation Amount",GetBranchCode(GroupMemberAllocation."Member No."),0,'');
   end;

    procedure ValidateMemberApplication(MCMemberApplication: Record 50000);
    begin
    WITH MCMemberApplication DO begin
        CASE Category OF
            Category::Client:
                begin
                    TESTFIELD("Sur Name");
                    TESTFIELD("First Name");
                    TESTFIELD("Last Name");
                    TESTFIELD("National ID/Passport No.");
                    //TESTFIELD("KRA PIN");
                    //TESTFIELD("Huduma No.");
                    TESTFIELD("Phone No.");
                    TESTFIELD("Loan Officer ID");
                    TESTFIELD("Global Dimension 1 Code");
                    TESTFIELD("Postal Address");
                    TESTFIELD("Physical Address");
                    TESTFIELD("Current Residence");
                    TESTFIELD("Home Village");
                    TESTFIELD("Nearest LandMark");
                    TESTFIELD("Group Link No.");
                    if NOT "Profile Picture".HASVALUE then
                        ERROR(Error015, FIELDCAPTION("Profile Picture"));
                    if NOT "ID Front".HASVALUE then
                        ERROR(Error015, FIELDCAPTION("ID Front"));
                    if NOT "ID Back".HASVALUE then
                        ERROR(Error015, FIELDCAPTION("ID Back"));
                    if NOT Signature.HASVALUE then
                        ERROR(Error015, FIELDCAPTION(Signature));
               end;
            Category::Group:
                begin
                    TESTFIELD("Group Name");
                    TESTFIELD("Group Registration No.");
                    TESTFIELD("Group Meeting Frequency");
                    TESTFIELD("Group Meeting Venue");
                    TESTFIELD("Group Meeting Time");
                    TESTFIELD("Group Registration Date");
                    TESTFIELD("Loan Officer ID");
                    TESTFIELD("Global Dimension 1 Code");
                    //TESTFIELD("KRA PIN");
                    TESTFIELD("Phone No.");
                    TESTFIELD("Postal Address");
                    TESTFIELD("Physical Address");
                    TESTFIELD("Group Meeting Frequency Option");
                    if NOT "Profile Picture".HASVALUE then
                        ERROR(Error015, FIELDCAPTION("Profile Picture"));
                    if NOT "Group Certificate".HASVALUE then
                        ERROR(Error015, FIELDCAPTION("Group Certificate"));
               end;
       end;
   end;
   end;*/

    procedure ValidateGroupAttendance(var MCGroupAttendanceHeader: Record "Group Attendance Header"): Boolean;
    begin
        WITH MCGroupAttendanceHeader DO begin
            TESTFIELD("Actual Meeting Date");
            TESTFIELD("Actual Meeting Time");
            Status := Status::Validated;
            "Validated By" := USERID;
            if modify then begin
                if MicroCreditMember.GET("Group No.") then begin
                    MicroCreditMember."Last Meeting Date" := "Current Meeting Date";
                    if MicroCreditMember.modify then
                        EXIT(TRUE)
                    else
                        EXIT(FALSE);
                end;
            end else
                EXIT(FALSE);
        end;
    end;
    /*
    procedure InterestCapitalization(var Vendor: Record "23");
    var
    MCLoanApplication: Record "Loan Application";
    GenJournalLine: Record "81";
    Text000: Label '"MicroCredit Interest Due for Member  "';
    OriginalPostingGroup: Code[20];
    begin
    WITH Vendor DO begin
        MicroCreditSetup.GET;
        if MCLoanApplication.GET("No.") then begin
            if MCLoanApplication."Next Due Date" = TODAY then begin
                if MicroCreditMember.GET("Owner Member No") then;
                if MicroCreditMember2.GET(MicroCreditMember."Group Link No.") then;
                if LoanProductType.GET(MCLoanApplication."Loan Product Type") then;
                OriginalPostingGroup := Vendor."Vendor Posting Group";
                LoanRepaymentSchedule.RESET;
                LoanRepaymentSchedule.SETRANGE("Loan No.", MCLoanApplication."No.");
                LoanRepaymentSchedule.SETRANGE("Repayment Date", MCLoanApplication."Next Due Date");
                if LoanRepaymentSchedule.FINDFIRST then begin
                    ChangeVendorPostingGroup("No.", LoanProductType."Receivable Interest Account");
                    GlobalManagement.CreateJournal(MicroCreditSetup."Loan Interest Template Name", MicroCreditSetup."Loan Interest Batch Name", "No.", "No.", MCLoanApplication."Next Due Date", GenJournalLine."Account Type"::Vendor,
                                  "No.", Text000 + MicroCreditMember."No.", LoanRepaymentSchedule."Monthly Interest", 5, GetBranchCode(MicroCreditMember."No."));
                    GlobalManagement.CreateJournal(MicroCreditSetup."Loan Interest Template Name", MicroCreditSetup."Loan Interest Batch Name", "No.", "No.", MCLoanApplication."Next Due Date", GenJournalLine."Account Type"::"G/L Account",
                                  LoanProductType."Receivable Interest Account", Text000 + MicroCreditMember."No.", -LoanRepaymentSchedule."Monthly Interest", 5, GetBranchCode(MicroCreditMember."No."));
                    ChangeVendorPostingGroup("No.", OriginalPostingGroup);
               end;
           end;
       end;
   end;
   end;
*/
    local procedure ChangeVendorPostingGroup(LoanNo: Code[20]; NewPostingGroup: Code[20]);
    var
        Vendor: Record Vendor;
    begin
        Vendor.RESET;
        Vendor.SETRANGE("No.", LoanNo);
        if Vendor.FINDFIRST then begin
            Vendor."Vendor Posting Group" := NewPostingGroup;
            Vendor.modify;
        end;
    end;

    /*    procedure CreateLoanAccount(MemberNo: Code[20]; LoanNo: Code[20]; LoanType: Code[20]; LoanDescription: Text; LoanOfficer: Code[20]);
        begin
        MicroCreditMember.GET(MemberNo);

        Vendor.INIT;
        Vendor."No." := LoanNo;
        Vendor.Name := LoanDescription;
        Vendor."Account Type" := 'LOAN';
        Vendor."Vendor Posting Group" := LoanType;
        Vendor."Owner Member No" := MemberNo;
        Vendor."Owner Name" := MicroCreditMember."Full Name";
        Vendor."Mobile Phone No" := MicroCreditMember."Phone No.";
        Vendor."ID No" := MicroCreditMember."National ID/Passport No.";
        Vendor."Identification No." := MicroCreditMember."National ID/Passport No.";
        Vendor.Gender := MicroCreditMember.Gender;
        Vendor."Debtor Type" := Vendor."Debtor Type"::"FOSA Account";
        Vendor."Debtors Type" := Vendor."Debtors Type"::Client;
        Vendor."Branch Code" := MicroCreditMember."Global Dimension 1 Code";
        Vendor."Global Dimension 1 Code" := MicroCreditMember."Global Dimension 1 Code";
        Vendor."Loan Account" := TRUE;
        Vendor.Status := Vendor.Status::Active;
        Vendor."Loan Officer ID" := LoanOfficer;
        Vendor."Customer Type" := Vendor."Customer Type"::"MicroCredit Member";
        Vendor.INSERT;
       end;

        procedure PostLoanDisbursement(var MCLoanApplication: Record "Loan Application");
        var
        GenJournalLine: Record "81";
        LoanProcessingCharges: Record "50037";
        RecRef: RecordRef;
        LoanRefinancingEntry: Record "52039";
        DisbursalAmount: Decimal;
        Text000: Label 'Loan Refinancing-';
        LoanNo: Code[20];
        Error020: Label 'Loan No. %1 already exist';
        begin
        WITH MCLoanApplication DO begin

            MicroCreditSetup.GET;
            CALCFIELDS("Total Refinanced Amount");
            DisbursalAmount := "Approved Amount" - "Total Refinanced Amount";
            if NOT Vendor.GET("No.") then
                CreateLoanAccount("Member No.", "No.", "Loan Product Type", Description, "Loan Officer ID")
            else begin
                Vendor.CALCFIELDS("Balance (LCY)");
                if Vendor."Balance (LCY)" <> 0 then
                    ERROR(Error020, Vendor."No.");
           end;
            ClearJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name");
            GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                          GenJournalLine."Account Type"::Vendor, "No.", Description, "Approved Amount", 2, GetBranchCode("Member No."));
            GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                          GenJournalLine."Account Type"::Vendor, GetSavingsAccount("Member No."), Description, -DisbursalAmount, 2, GetBranchCode("Member No."));
            if "Refinance Loan" then begin
                LoanRefinancingEntry.RESET;
                LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
                LoanRefinancingEntry.SETRANGE(Select, TRUE);
                if LoanRefinancingEntry.FINDSET then begin
                    REPEAT
                        GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      LoanRefinancingEntry."Loan to Refinance", Text000 + "No.", -LoanRefinancingEntry."Outstanding Loan Balance", '', GetBranchCode("Member No."));
                    UNTIL LoanRefinancingEntry.NEXT = 0;
               end;
           end;

            LoanProcessingCharges.RESET;
            LoanProcessingCharges.SETRANGE("Loan Type", "Loan Product Type");
            if NOT "Refinance Loan" then
                LoanProcessingCharges.SETRANGE("Refinancing Fee", FALSE);
            if LoanProcessingCharges.FINDSET then begin
                REPEAT
                    if LoanProcessingCharges."Calculation Mode" = LoanProcessingCharges."Calculation Mode"::"% of Loan" then begin
                        GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      GetSavingsAccount("Member No."), LoanProcessingCharges.Description, ((ABS(LoanProcessingCharges.Value) * "Approved Amount") / 100), 0, GetBranchCode("Member No."));
                        GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      LoanProcessingCharges."Account No", LoanProcessingCharges.Description, -((ABS(LoanProcessingCharges.Value) * "Approved Amount") / 100), 0, GetBranchCode("Member No."));
                   end;
                    if LoanProcessingCharges."Calculation Mode" = LoanProcessingCharges."Calculation Mode"::"Flat Amount" then begin
                        GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, GetSavingsAccount("Member No."), LoanProcessingCharges.Description, ABS(LoanProcessingCharges.Value), 0, GetBranchCode("Member No."));
                        GlobalManagement.CreateJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::"G/L Account", LoanProcessingCharges."Account No", LoanProcessingCharges.Description, -(ABS(LoanProcessingCharges.Value)), 0, GetBranchCode("Member No."));
                   end;
                UNTIL LoanProcessingCharges.NEXT = 0;
           end;
            CLEARLASTERROR;

            if GlobalManagement.PostJournal(MicroCreditSetup."Loan Disbursal Template Name", MicroCreditSetup."Loan Disbursal Batch Name") then begin
                Posted := TRUE;
                "Disbursed By" := USERID;
                "Disbursal Date" := TODAY;
                "Disbursal Time" := TIME;
                if modify then begin
                    MESSAGE(Text001, "No.");
                    CalculateRepaymentSchedule("No.", "Approved Amount");

                    CLEAR(RecRef);
                    RecRef.GETTABLE(MCLoanApplication);
                    CreateSMS(RecRef, 1);
               end;
           end else begin
                if GETLASTERRORTEXT <> '' then
                    ERROR(GETLASTERRORTEXT);
           end;
       end;
       end;
    */
    local procedure GetSavingsAccount(MemberNo: Code[20]): Code[20];
    var
        AccountTypes: Record "Account Type";
    begin
        AccountTypes.Reset();
        AccountTypes.SetRange(Type, AccountTypes.Type::Savings);
        if AccountTypes.FindFirst() then begin
            Vendor.RESET;
            Vendor.SetRange("Member No.", MemberNo);
            Vendor.SETRANGE("Account Type", AccountTypes.Code);
            if Vendor.FINDFIRST then
                EXIT(Vendor."No.");
        end;
    end;

    procedure CreatePortfolioEntry("No.": Code[20]; TransferDate: Date; "LoanNo.": Code[20]; Description: Text; "MemberNo.": Code[20]; Name: Text; Amount: Decimal; PreviousLoanOfficerID: Code[20]; CurrentLoanOfficerID: Code[20]; Type: Text; PreviousBranchCode: Code[10]; CurrentBranchCode: Code[10]);
    var
        PortfolioTransferEntry: Record "Portfolio Transfer Entry";
        EntryNo: Integer;
        PortfolioTransferEntry2: Record "Portfolio Transfer Entry";
    begin
        PortfolioTransferEntry.INIT;
        PortfolioTransferEntry2.RESET;
        PortfolioTransferEntry2.SETCURRENTKEY("Entry No.");
        if PortfolioTransferEntry2.FINDLAST then begin
            PortfolioTransferEntry."Entry No." := PortfolioTransferEntry2."Entry No." + 1;
        end else begin
            PortfolioTransferEntry."Entry No." := 1;
        end;
        PortfolioTransferEntry."No." := "No.";
        PortfolioTransferEntry."Transfer Date" := TransferDate;
        PortfolioTransferEntry."Loan No." := "LoanNo.";
        PortfolioTransferEntry.Description := Description;
        PortfolioTransferEntry."Member No." := "MemberNo.";
        PortfolioTransferEntry.Name := Name;
        PortfolioTransferEntry."Transferred Loan Amount" := Amount;
        PortfolioTransferEntry."Previous Loan Officer ID" := PreviousLoanOfficerID;
        PortfolioTransferEntry."Current Loan Officer ID" := CurrentLoanOfficerID;
        if Type = 'Client' then begin
            PortfolioTransferEntry.Type := PortfolioTransferEntry.Type::Client;
        end;
        if Type = 'Group' then begin
            PortfolioTransferEntry.Type := PortfolioTransferEntry.Type::Group;
        end;
        if Type = 'Loan' then begin
            PortfolioTransferEntry.Type := PortfolioTransferEntry.Type::Loan;
        end;
        if Type = 'Loan Officer' then begin
            PortfolioTransferEntry.Type := PortfolioTransferEntry.Type::"Loan Officer";
        end;
        PortfolioTransferEntry."Current Branch Code" := CurrentBranchCode;
        PortfolioTransferEntry."Previous Branch Code" := PreviousBranchCode;
        PortfolioTransferEntry.INSERT;
    end;
    /*
            procedure PostLoanWriteOff(var LoanWriteOffHeader: Record "52037");
            var
            LoanWriteOffLine: Record "52038";
            GenJournalLine: Record "81";
            Text000: Label 'Loan WriteOff has been posted successfully';
            Vendor: Record "23";
            Text001: Label 'Written Off';
            begin
            WITH LoanWriteOffHeader DO begin
                MicroCreditSetup.GET;
                CALCFIELDS("Total Amount");
                ClearJournal(MicroCreditSetup."Loan WriteOff Template Name", MicroCreditSetup."Loan WriteOff Batch Name");
                LoanWriteOffLine.RESET;
                LoanWriteOffLine.SETRANGE("Document No.", "No.");
                if LoanWriteOffLine.FINDSET then begin
                    REPEAT
                        GlobalManagement.CreateJournal(MicroCreditSetup."Loan WriteOff Template Name", MicroCreditSetup."Loan WriteOff Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      LoanWriteOffLine."Loan No.", Description, -LoanWriteOffLine."Defaulted Amount", '', GetBranchCode(LoanWriteOffLine."Member No."));
                        if Vendor.GET(LoanWriteOffLine."Loan No.") then begin
                            Vendor.Status := Vendor.Status::Closed;
                            Vendor."Account Remarks" := Text001;
                            Vendor.modify;
                       end;
                    UNTIL LoanWriteOffLine.NEXT = 0;
                    GlobalManagement.CreateJournal(MicroCreditSetup."Loan WriteOff Template Name", MicroCreditSetup."Loan WriteOff Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                  MicroCreditSetup."Write Off Control Account", Description, ABS("Total Amount"), 0, GetBranchCode(LoanWriteOffLine."Member No."));
               end;
                CLEARLASTERROR;
                if GlobalManagement.PostJournal(MicroCreditSetup."Loan WriteOff Template Name", MicroCreditSetup."Loan WriteOff Batch Name") then begin
                    Posted := TRUE;
                    "Posted By" := USERID;
                    "Posted Date" := TODAY;
                    "Posted Time" := TIME;
                    if modify then
                        MESSAGE(Text000);
               end else begin
                    if GETLASTERRORTEXT <> '' then
                        ERROR(GETLASTERRORTEXT);
               end;
           end;
           end;*/
    /*
            procedure GenerateLoanClassification(var MCLoanApplication: Record "Loan Application"; CalculationDate: Date);
            var
            LoanRepaymentSchedule: Record "Loan Repayment Schedule";
            MCLoanClassificationEntry: Record "Loan Classification Entry";
            VendorLedgerEntry: Record 25;
            ArrearsAmount: array[5] of Decimal;
            LoanClassificationSetup: Record "Loan Classification Setup";
            NoofDaysinArrears: Integer;
            ProvisioningPercent: Decimal;
            MicroCreditMember: Record 50006;
            StartDate: Date;
            AmountPaid: Decimal;
            Variant2: Integer;
            FirstDueDate: Date;
            NoofDefaultedInStallments: Integer;
            begin
            WITH MCLoanApplication DO begin
                NoofDaysinArrears := 0;
                MCLoanClassificationEntry.INIT;
                MCLoanClassificationEntry."Classification Date" := CalculationDate;
                MCLoanClassificationEntry."Loan No." := "No.";
                MCLoanClassificationEntry.Description := Description;
                MCLoanClassificationEntry."Member No." := "Member No.";
                MCLoanClassificationEntry."Member Name" := "Member Name";
                MCLoanClassificationEntry."Approved Amount" := "Approved Amount";
             //   MCLoanClassificationEntry."Group No." := "Group No.";
           //     MCLoanClassificationEntry."Group Name" := "Group Name";
           //     MCLoanClassificationEntry."Loan Officer ID" := GetCurrentLoanOfficer("Member No.");
                MCLoanClassificationEntry."Global Dimension 1 Code" := GetBranchCode("Member No.");
                MCLoanClassificationEntry."Principal Installment" := GetExpectedRepaymentAmount("No.", "Next Due Date", 'P');
                MCLoanClassificationEntry."Interest Installment" := GetExpectedRepaymentAmount("No.", "Next Due Date", 'I');
                AmountPaid := CalculateActualLoanRepayment("No.", CalculationDate, 'P') + CalculateActualLoanRepayment("No.", CalculationDate, 'I');
                MCLoanClassificationEntry."Total Installment" := GetExpectedRepaymentAmount("No.", "Next Due Date", 'P') + GetExpectedRepaymentAmount("No.", "Next Due Date", 'I');

                if CalculateLoanArrearsAndOverpayment("No.", CalculationDate, 'P') > 0 then
                    ArrearsAmount[1] := ROUND(CalculateLoanArrearsAndOverpayment("No.", CalculationDate, 'P'), 0.1, '<')
                else
                    ArrearsAmount[2] := ROUND(ABS(CalculateLoanArrearsAndOverpayment("No.", CalculationDate, 'P')), 0.1, '<');

                if CalculateLoanArrearsAndOverpayment("No.", CalculationDate, 'I') > 0 then
                    ArrearsAmount[3] := ROUND(CalculateLoanArrearsAndOverpayment("No.", CalculationDate, 'I'), 0.1, '<')
                else
                    ArrearsAmount[4] := ROUND(ABS(CalculateLoanArrearsAndOverpayment("No.", CalculationDate, 'I')), 0.1, '<');
                if MicroCreditMember.GET("Group No.") then;
                if GetFirstLastDueDate("No.", 'F') <> 0D then
                    FirstDueDate := GetFirstLastDueDate("No.", 'F')
                else
                    FirstDueDate := CALCDATE("Group Meeting Frequency", "Disbursal Date");
                MCLoanClassificationEntry."Principal In Arrears" := ArrearsAmount[1];
                MCLoanClassificationEntry."Interest in Arrears" := ArrearsAmount[3];
                MCLoanClassificationEntry."Total Arrears" := ArrearsAmount[3] + ArrearsAmount[1];
                MCLoanClassificationEntry."Prepayment Amount" := ArrearsAmount[2] + ArrearsAmount[4];
                if CalculationDate >= FirstDueDate then begin
                    if ArrearsAmount[1] <> 0 then begin
                        NoofDaysinArrears := CalculateNoofDaysinArrears("No.", ArrearsAmount[1], 0, ArrearsAmount[2] + ArrearsAmount[4], CalculationDate);
                        CalculateNoofDaysInstalmentsinArrears2("No.", CalculationDate, ArrearsAmount[1], ArrearsAmount[3], NoofDaysinArrears, NoofDefaultedInStallments);
                   end;
               end;
                MCLoanClassificationEntry."No. of Installments Defaulted" := NoofDefaultedInStallments;
                MCLoanClassificationEntry."No. of Days in Arrears" := NoofDaysinArrears;
                MCLoanClassificationEntry."Total Principal Paid" := CalculateActualLoanRepayment("No.", CalculationDate, 'P');
                MCLoanClassificationEntry."Total Interest Paid" := CalculateActualLoanRepayment("No.", CalculationDate, 'I');
                MCLoanClassificationEntry."Total Amount Paid" := CalculateActualLoanRepayment("No.", CalculationDate, 'P') + CalculateActualLoanRepayment("No.", CalculationDate, 'I');
                MCLoanClassificationEntry."Outstanding Principal Amount" := CalculateExpectedTotalRepayment("No.", 'P') - CalculateActualLoanRepayment("No.", CalculationDate, 'P');
                MCLoanClassificationEntry."Outstanding Interest Amount" := CalculateExpectedTotalRepayment("No.", 'I') - CalculateActualLoanRepayment("No.", CalculationDate, 'I');
                MCLoanClassificationEntry."Disbursal Date" := "Disbursal Date";
                MCLoanClassificationEntry."Repayment Period" := "Repayment Period";
                MCLoanClassificationEntry."No. of Installments" := GetNoofInstallments("No.", FirstDueDate, GetFirstLastDueDate("No.", 'L'));
                MCLoanClassificationEntry."Last Repayment Date" := GetLastRepaymentDate("No.", CalculationDate);
                MCLoanClassificationEntry."Outstanding Loan Balance" := ABS(GetAccountBalance("No."));
                MCLoanClassificationEntry."Classification Code" := GetClassificationCode(NoofDaysinArrears, 'CC');
                if GetClassificationCode(NoofDaysinArrears, 'PP') <> '' then
                    EVALUATE(ProvisioningPercent, GetClassificationCode(NoofDaysinArrears, 'PP'));
                MCLoanClassificationEntry."Provisioning Amount" := ProvisioningPercent / 100 * MCLoanClassificationEntry."Outstanding Loan Balance";
                MCLoanClassificationEntry."Remaining Period" := CalculateNoofMonths(GetFirstLastDueDate("No.", 'F'), GetFirstLastDueDate("No.", 'L'));
                MCLoanClassificationEntry."Expectedend Date" := GetFirstLastDueDate("No.", 'L');

                //CalculateNoofDaysInstalmentsinArrears("No.",AmountPaid-(ArrearsAmount[2]+ArrearsAmount[4]),GetFirstLastDueDate("No.",'F'),CalculationDate,'I');
                if MCLoanClassificationEntry."Outstanding Loan Balance" <> 0 then begin
                    if MCLoanClassificationEntry.INSERT then begin
                      //  CheckIfLoanIsRescheduled(MCLoanClassificationEntry);
                   end;
               end;
           end;
           end;/*

            local procedure CheckIfLoanIsRescheduled(var MCLoanClassificationEntry: Record "52012");
            var
            LoanRescheduling: Record "52026";
            MCLoanClassificationEntry2: Record "52012";
            MicroCreditSetup: Record "52000";
            ClassificationEndDate: Date;
            begin
            WITH MCLoanClassificationEntry DO begin
                LoanRescheduling.RESET;
                LoanRescheduling.SETRANGE("Loan No.", "Loan No.");
                if LoanRescheduling.FINDFIRST then begin
                    MCLoanClassificationEntry2.RESET;
                    MCLoanClassificationEntry2.SETRANGE("Loan No.", "Loan No.");
                    MCLoanClassificationEntry2.SETRANGE("Calculated Date", 0D, LoanRescheduling."Approved Date");
                    if MCLoanClassificationEntry2.FINDLAST then begin
                        ClassificationEndDate := CALCDATE(MicroCreditSetup."Min. Period for Resch. Loan", LoanRescheduling."Approved Date");
                        if ClassificationEndDate <= TODAY then begin
                            MCLoanClassificationEntry."Classification Code" := MCLoanClassificationEntry2."Classification Code";
                            MCLoanClassificationEntry.modify;
                       end;
                   end;
               end;
           end;
           end;

            procedure CalculateRepaymentSchedule(LoanNo: Code[10]; LoanAmount: Decimal);
            var
            MCLoanApplication: Record "Loan Application";
            MicroCreditMember: Record 50006;
            MicroCreditMember2: Record 50006;
            NoOfInstallments: Integer;
            PrincipalAmount: Decimal;
            InterestAmount: Decimal;
            ApprovedLoanAmount: Decimal;
            ConstantAmount: Decimal;
            LastRepaymentDate: Date;
            LoanRepaymentSchedule: Record "50008";
            LoanRepaymentSchedule2: Record "50008";
            RepaymentDate: array[4] of Date;
            FirstRepaymentDate: Date;
            begin
            if MCLoanApplication.GET(LoanNo) then begin
                LoanRepaymentSchedule.RESET;
                LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
                if LoanRepaymentSchedule.FINDFIRST then
                    FirstRepaymentDate := LoanRepaymentSchedule."Repayment Date";

                LoanRepaymentSchedule2.RESET;
                LoanRepaymentSchedule2.SETRANGE("Loan No.", LoanNo);
                LoanRepaymentSchedule2.DELETEALL;

                i := 1;
                if NOT MCLoanApplication.Posted then begin
                    LastRepaymentDate := CALCDATE(FORMAT(MCLoanApplication."Repayment Period") + 'M', MCLoanApplication."Next Due Date");
                    RepaymentDate[1] := MCLoanApplication."Next Due Date";
               end else begin
                    LastRepaymentDate := CALCDATE(FORMAT(MCLoanApplication."Repayment Period") + 'M', FirstRepaymentDate);
                    RepaymentDate[1] := FirstRepaymentDate;
               end;
                NoOfInstallments := GetNoofInstallments(MCLoanApplication."No.", RepaymentDate[1], LastRepaymentDate);
                ApprovedLoanAmount := LoanAmount;
                if MCLoanApplication."Repayment Method" = MCLoanApplication."Repayment Method"::"Straight Line" then begin
                    PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
                    InterestAmount := ApprovedLoanAmount * (MCLoanApplication."Interest Rate" / 12 * MCLoanApplication."Repayment Period" / 100);
                    FOR i := 1 TO NoOfInstallments DO begin
                        CreateRepaymentSchedule(MCLoanApplication, RepaymentDate[1], ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
                        ApprovedLoanAmount -= PrincipalAmount;
                        RepaymentDate[1] := CALCDATE(MCLoanApplication."Group Meeting Frequency", RepaymentDate[1]);
                   end;
               end;

                if MCLoanApplication."Repayment Method" = MCLoanApplication."Repayment Method"::"Reducing Balance" then begin
                    PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
                    FOR i := 1 TO NoOfInstallments DO begin
                        InterestAmount := ApprovedLoanAmount * (MCLoanApplication."Interest Rate" / 12 * MCLoanApplication."Repayment Period" / 100);
                        CreateRepaymentSchedule(MCLoanApplication, RepaymentDate[1], ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
                        ApprovedLoanAmount -= PrincipalAmount;
                        RepaymentDate[1] := CALCDATE(MCLoanApplication."Group Meeting Frequency", RepaymentDate[1]);
                   end;
               end;

                if MCLoanApplication."Repayment Method" = MCLoanApplication."Repayment Method"::Amortization then begin
                    ConstantAmount := ApprovedLoanAmount *
                                    ((MCLoanApplication."Interest Rate" / NoOfInstallments / 100) *
                                    (POWER(1 + (MCLoanApplication."Interest Rate" / NoOfInstallments / 100), NoOfInstallments))) /
                                    (POWER(1 + (MCLoanApplication."Interest Rate" / NoOfInstallments) / 100, NoOfInstallments) - 1);
                    FOR i := 1 TO NoOfInstallments DO begin
                        InterestAmount := (ApprovedLoanAmount) * (MCLoanApplication."Interest Rate" / 12 * MCLoanApplication."Repayment Period" / 100);
                        PrincipalAmount := ConstantAmount - InterestAmount;
                        CreateRepaymentSchedule(MCLoanApplication, RepaymentDate[1], ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
                        ApprovedLoanAmount -= PrincipalAmount;
                        RepaymentDate[1] := CALCDATE(MCLoanApplication."Group Meeting Frequency", RepaymentDate[1]);
                   end;
               end;
           end;
           end;

            local procedure GetNoofInstallments(LoanNo: Code[20]; StartDate: Date;endDate: Date): Integer;
            var
            MCLoanApplication: Record "Loan Application";
            j: Integer;
            LastRepaymentDate: Date;
            begin
            j := 0;
            if MCLoanApplication.GET(LoanNo) then begin
                LastRepaymentDate :=endDate;
                RepaymentDate[1] := StartDate;
                WHILE RepaymentDate[1] <= LastRepaymentDate DO begin
                    RepaymentDate[1] := CALCDATE(MCLoanApplication."Group Meeting Frequency", RepaymentDate[1]);
                    j += 1;
               end;
           end;
            EXIT(j - 1);
           end;

            local procedure CreateRepaymentSchedule(MCLoanApplication: Record "Loan Application"; RepaymentDate: Date; LoanBalance: Decimal; PrincipalAmount: Decimal; InterestAmount: Decimal; InstallmentNo: Integer);
            var
            LoanRepaymentSchedule: Record "50008";
            begin
            LoanRepaymentSchedule.INIT;
            LoanRepaymentSchedule."Loan No." := MCLoanApplication."No.";
            LoanRepaymentSchedule."Repayment Date" := RepaymentDate;
            LoanRepaymentSchedule."Member No." := MCLoanApplication."Member No.";
            LoanRepaymentSchedule."Member Name" := MCLoanApplication."Member Name";
            LoanRepaymentSchedule."Loan Category" := MCLoanApplication."Loan Product Type";
            LoanRepaymentSchedule."Interest Rate" := MCLoanApplication."Interest Rate";
            LoanRepaymentSchedule."Instalment No" := InstallmentNo;
            LoanRepaymentSchedule."Repayment Code" := FORMAT(InstallmentNo);
            LoanRepaymentSchedule."Loan Amount" := LoanBalance;
            LoanRepaymentSchedule."Principal Repayment" := PrincipalAmount;
            LoanRepaymentSchedule."Monthly Interest" := InterestAmount;
            LoanRepaymentSchedule."Monthly Repayment" := PrincipalAmount + InterestAmount;
            LoanRepaymentSchedule.INSERT;
           end;

            local procedure GetLastMeetingDate(GroupNo: Code[20]): Date;
            var
            MCGroupAttendanceHeader: Record "52010";
            begin
            MCGroupAttendanceHeader.RESET;
            MCGroupAttendanceHeader.SETRANGE("Group No.", GroupNo);
            MCGroupAttendanceHeader.SETRANGE(Status, MCGroupAttendanceHeader.Status::Validated);
            if MCGroupAttendanceHeader.FINDLAST then
                EXIT(MCGroupAttendanceHeader."Current Meeting Date");
           end;

            procedure ValidateGraduationSchedule(var MCLoanApplication: Record "Loan Application");
            var
            LoanProductType: Record "50002";
            Vendor: Record "23";
            MCLoanApplication2: Record "Loan Application";
            i: Integer;
            begin
            WITH MCLoanApplication DO begin
                MicroCreditSetup.GET;
                i := 0;
                Vendor.RESET;
                Vendor.SETRANGE("Owner Member No", "Member No.");
                //Vendor.SETRANGE("Vendor Posting Group","Loan Product Type");
                if Vendor.FINDSET then begin
                    REPEAT
                        Vendor.CALCFIELDS("Balance (LCY)");
                        if Vendor."Balance (LCY)" < 0 then
                            i += 1
                    UNTIL Vendor.NEXT = 0;
               end;
                if i > MicroCreditSetup."No. of Loans Per Member" then begin
                    ERROR(Error008);
               end;
                if i = 0 then begin
                    MCLoanApplication2.RESET;
                    MCLoanApplication2.SETRANGE("Member No.", "Member No.");
                    MCLoanApplication2.SETRANGE("Loan Product Type", "Loan Product Type");
                    MCLoanApplication2.SETRANGE(Posted, TRUE);
                    if MCLoanApplication2.FINDLAST then begin
                        if GetNoOfRepaymentPeriod("No.") > "Repayment Period" then
                            ERROR(Error009)
                        else begin
                            "Max. Eligible Amount" := CalculateMaxEligibleLoanAmount(MCLoanApplication2."Approved Amount", GetNoOfRepaymentPeriod("No."));
                       end;
                   end else begin
                        if LoanProductType.GET("Loan Product Type") then begin
                            "Max. Eligible Amount" := LoanProductType."Max. Loan Amount";
                       end;
                   end;
               end;
                modify;
           end;
           end;

            local procedure GetNoOfRepaymentPeriod(LoanNo: Code[20]): Integer;
            var
            Vendor: Record "23";
            VendorLedgerEntry: Record 25;
            Calender: Record "2000000007";
            begin
            GetRepaymentDate(LoanNo);
            Calender.RESET;
            Calender.SETRANGE("Period Start", RepaymentDate[1], RepaymentDate[2]);
            Calender.SETRANGE("Period Type", Calender."Period Type"::Month);
            EXIT(Calender.COUNT);
           end;

            local procedure GetRepaymentDate(LoanNo: Code[20]);
            var
            VendorLedgerEntry: Record 25;
            begin
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
            if VendorLedgerEntry.FINDFIRST then
                RepaymentDate[1] := VendorLedgerEntry."Posting Date";

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
            if VendorLedgerEntry.FINDLAST then
                RepaymentDate[2] := VendorLedgerEntry."Posting Date";
           end;

            local procedure CalculateMaxEligibleLoanAmount(LoanAmount: Decimal; RepaymentPeriod: Integer): Decimal;
            var
            LoanGraduationSchedule: Record "52020";
            EligibleAmount: array[8] of Decimal;
            begin
            LoanGraduationSchedule.RESET;
            if LoanGraduationSchedule.FINDSET then begin
                REPEAT
                    if ((LoanAmount >= LoanGraduationSchedule."Minimum Loan Amount") AND (LoanAmount <= LoanGraduationSchedule."Maximum Loan Amount")) then begin
                        if ((RepaymentPeriod >= LoanGraduationSchedule."Minimum Repayment Period") AND (RepaymentPeriod <= LoanGraduationSchedule."Maximum Repayment Period")) then begin
                            if LoanGraduationSchedule."Incremental Method" = LoanGraduationSchedule."Incremental Method"::Factor then begin
                                EligibleAmount[1] := LoanAmount * LoanGraduationSchedule."Increment Factor";
                                if EligibleAmount[1] > LoanGraduationSchedule."Maximum Amount" then
                                    EligibleAmount[2] := LoanGraduationSchedule."Maximum Amount"
                                else
                                    EligibleAmount[2] := EligibleAmount[1];
                           end;
                            if LoanGraduationSchedule."Incremental Method" = LoanGraduationSchedule."Incremental Method"::"Flat Amount" then begin
                                EligibleAmount[1] := LoanAmount + LoanGraduationSchedule."Increment Amount";
                                if EligibleAmount[1] > LoanGraduationSchedule."Maximum Amount" then
                                    EligibleAmount[2] := LoanGraduationSchedule."Maximum Amount"
                                else
                                    EligibleAmount[2] := EligibleAmount[1];
                           end;
                       end else
                            EligibleAmount[2] := 0;
                   end;
                UNTIL LoanGraduationSchedule.NEXT = 0;
           end;
            EXIT(EligibleAmount[2]);
           end;

        procedure CalculateLoanArrearsAndOverpayment(LoanNo: Code[20];endDate: Date; ArrearType: Code[20]) ArrearAmount: Decimal;
        var
            Vendor: Record Vendor;
            VendorLedgerEntry: Record "Vendor Ledger Entry";
            LoanRepaymentSchedule: Record "Loan Repayment Schedule";
            PrincipalAmount: array[6] of Decimal;
            InterestAmount: array[4] of Decimal;
            LastExpectedRepaymentDate: Date;
            PaidInterest: Decimal;
        begin
            PrincipalAmount[1] := 0;
            PrincipalAmount[2] := 0;
            InterestAmount[1] := 0;
            InterestAmount[2] := 0;
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
            LoanRepaymentSchedule.SETRANGE("Repayment Date", 0D,endDate);
            if LoanRepaymentSchedule.FINDLAST then
                LastExpectedRepaymentDate := LoanRepaymentSchedule."Repayment Date"
            else
                LastExpectedRepaymentDate := TODAY;

            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
            LoanRepaymentSchedule.SETRANGE("Repayment Date", 0D, LastExpectedRepaymentDate);
            if LoanRepaymentSchedule.FINDSET then begin
                REPEAT
                    if ArrearType = 'P' then
                        PrincipalAmount[1] += LoanRepaymentSchedule."Principal Installment";
                    if ArrearType = 'I' then
                        InterestAmount[1] += LoanRepaymentSchedule."Interest Installment";
                UNTIL LoanRepaymentSchedule.NEXT = 0;
           end;

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
            VendorLedgerEntry.SETRANGE("Posting Date", 0D,endDate);
            VendorLedgerEntry.SETRANGE(Reversed, FALSE);
            if VendorLedgerEntry.FINDSET then begin
                REPEAT
                    VendorLedgerEntry.CALCFIELDS(Amount);
                    if ArrearType = 'P' then begin 
                        if VendorLedgerEntry."Transaction Type" = VendorLedgerEntry."Transaction Type"::Repayment then
                            PrincipalAmount[2] += VendorLedgerEntry.Amount;
                   end;
                UNTIL VendorLedgerEntry.NEXT = 0;
           end;

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
            //VendorLedgerEntry.SETRANGE("Posting Date",0D,LastExpectedRepaymentDate);
            VendorLedgerEntry.SETRANGE("Posting Date", 0D,endDate);
            VendorLedgerEntry.SETRANGE(Reversed, FALSE);
            if VendorLedgerEntry.FINDSET then begin
                REPEAT
                    VendorLedgerEntry.CALCFIELDS(Amount);
                    if ArrearType = 'I' then begin
                        if VendorLedgerEntry."Transaction Type" = VendorLedgerEntry."Transaction Type"::"Interest Paid" then begin
                            InterestAmount[2] += ABS(VendorLedgerEntry.Amount);
                       end;
                   end;
                UNTIL VendorLedgerEntry.NEXT = 0;
           end; //MESSAGE('%1, %2\%3, %4',PrincipalAmount[1],PrincipalAmount[2],InterestAmount[1],InterestAmount[2]);
            if ArrearType = 'P' then
                ArrearAmount := PrincipalAmount[1] - ABS(PrincipalAmount[2]);
            if ArrearType = 'I' then
                ArrearAmount := InterestAmount[1] - InterestAmount[2];
            EXIT(ROUND(ArrearAmount, 0.01, '<'));
       end;*/

    local procedure CalculateActualLoanRepayment(LoanNo: Code[20]; endDate: Date; RepaymentType: Code[20]) RepaymentAmount: Decimal;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PrincipalAmount: array[6] of Decimal;
        InterestAmount: array[4] of Decimal;
    begin
        PrincipalAmount[1] := 0;
        InterestAmount[1] := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
        VendorLedgerEntry.SETRANGE("Posting Date", 0D, endDate);
        if VendorLedgerEntry.FINDSET then begin
            REPEAT
                VendorLedgerEntry.CALCFIELDS(Amount);
                if RepaymentType = 'P' then begin
                    //     if VendorLedgerEntry."Transaction Type" = VendorLedgerEntry."Transaction Type"::Repayment then
                    PrincipalAmount[1] += VendorLedgerEntry.Amount;
                end;
                if RepaymentType = 'I' then begin
                    //    if VendorLedgerEntry."Transaction Type" = VendorLedgerEntry."Transaction Type"::"Interest Paid" then
                    InterestAmount[1] += ABS(VendorLedgerEntry.Amount);
                end;
            UNTIL VendorLedgerEntry.NEXT = 0;
        end;
        if RepaymentType = 'P' then
            RepaymentAmount := ABS(PrincipalAmount[1]);
        if RepaymentType = 'I' then
            RepaymentAmount := InterestAmount[1];
        EXIT(RepaymentAmount);
    end;
    /*

        local procedure GetLastRepaymentDate(LoanNo: Code[20];endDate: Date): Date;
        var
            VendorLedgerEntry: Record 25;
        begin
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
            VendorLedgerEntry.SETRANGE("Posting Date", 0D,endDate);
            VendorLedgerEntry.SETFILTER(VendorLedgerEntry."Transaction Type", '%1|%2', VendorLedgerEntry."Transaction Type"::Repayment,
                                                                                    VendorLedgerEntry."Transaction Type"::"Interest Paid");
            if VendorLedgerEntry.FINDLAST then
                EXIT(VendorLedgerEntry."Posting Date");
       end;

        local procedure CalculateExpectedTotalRepayment(LoanNo: Code[20]; RepaymentType: Code[20]) TotalExpectedAmount: Decimal;
        begin
            TotalExpectedAmount := 0;
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
            if LoanRepaymentSchedule.FINDSET then begin
                REPEAT
                    if RepaymentType = 'I' then
                        TotalExpectedAmount += LoanRepaymentSchedule."Monthly Interest";
                    if RepaymentType = 'P' then
                        TotalExpectedAmount += LoanRepaymentSchedule."Principal Repayment"
                UNTIL LoanRepaymentSchedule.NEXT = 0;
           end;
            EXIT(TotalExpectedAmount);
       end;

        local procedure CalculateNoofDaysInstalmentsinArrears2(LoanNo: Code[20];endDate: Date; PAmountInArrears: Decimal; IAmountInArrears: Decimal; var NoofDaysInArrears: Integer; var NoofDefaultedInstallments: Integer): Integer;
        var
            LoanRepaymentSchedule: Record "50008";
            MCLoanApplication: Record "Loan Application";
        begin
            if MCLoanApplication.GET(LoanNo) then begin
                /* LoanRepaymentSchedule.RESET;
                 LoanRepaymentSchedule.SETRANGE("Repayment Date",0D,EndDate);
                 LoanRepaymentSchedule.SETRANGE("Loan No.",LoanNo);
                 if LoanRepaymentSchedule.FINDFIRST then begin
                    if PAmountInArrears=0 then
                       NoofDefaultedInstallments:=ROUND(IAmountInArrears/LoanRepaymentSchedule."Monthly Interest",1,'>')
                    else if IAmountInArrears=0 then
                       NoofDefaultedInstallments:=ROUND(PAmountInArrears/LoanRepaymentSchedule."Principal Repayment",1,'>')
                    else
                       NoofDefaultedInstallments:=ROUND((PAmountInArrears+IAmountInArrears)/LoanRepaymentSchedule."Monthly Repayment",1,'>');
                end else
                    NoofDefaultedInstallments:=ROUND(PAmountInArrears+IAmountInArrears/MCLoanApplication."Approved Amount",1,'>');*/

    // NoofDaysInArrears:=CalculateNoofDaysinArrears(LoanNo,AmountInArrears,EndDate);
    /*     if MicroCreditMember.GET(MCLoanApplication."Group No.") then begin
             if MicroCreditMember."Group Meeting Frequency Option" = MicroCreditMember."Group Meeting Frequency Option"::Weekly then
                 NoofDefaultedInstallments := ROUND(NoofDaysInArrears / 7, 1, '>');
             if MicroCreditMember."Group Meeting Frequency Option" = MicroCreditMember."Group Meeting Frequency Option"::FortNightly then
                 NoofDefaultedInstallments := ROUND(NoofDaysInArrears / 14, 1, '>');
             if MicroCreditMember."Group Meeting Frequency Option" = MicroCreditMember."Group Meeting Frequency Option"::Monthly then
                 NoofDefaultedInstallments := ROUND(NoofDaysInArrears / 30, 1, '>');
        end;
    end;



end;

 local procedure CalculateNoofDaysInstalmentsinArrears(LoanNo: Code[20]; AmountPaid: Decimal; StartDate: Date;endDate: Date; Type: Code[10]): Integer;
 var
     ExpectedAmount: Decimal;
     LastRepaymentDate: Date;
     NoofDaysInArrears: Integer;
     NoofDefaultedInstallments: Integer;
     RemainingAmount: Decimal;
     Found: Boolean;
     LoanRepaymentSchedule: Record "50008";
     AmountPaid2: Decimal;
     LoanRepaymentSchedule2: Record "50008";
     ExpectedRepaymentDate: Date;
 begin
     ExpectedAmount := 0;
     AmountPaid2 := AmountPaid;
     if StartDate <=endDate then begin
         LoanRepaymentSchedule.RESET;
         LoanRepaymentSchedule.SETRANGE("Repayment Date", 0D,endDate);
         LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
         if LoanRepaymentSchedule.FINDSET then begin
             REPEAT
                 ExpectedAmount += LoanRepaymentSchedule."Monthly Repayment";
                 if AmountPaid >= 0 then begin
                     if ExpectedAmount >= AmountPaid then begin
                         Found := TRUE;
                         LoanRepaymentSchedule.MARK(TRUE);
                    end else
                         Found := FALSE;
                end;
                 AmountPaid -= LoanRepaymentSchedule."Monthly Repayment";
             UNTIL (LoanRepaymentSchedule.NEXT = 0);
        end;


         LoanRepaymentSchedule.MARKEDONLY(TRUE);
         LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
         if LoanRepaymentSchedule.FINDLAST then begin
             LastRepaymentDate := LoanRepaymentSchedule."Repayment Date";

             LoanRepaymentSchedule2.RESET;
             LoanRepaymentSchedule2.SETRANGE("Repayment Date", 0D,endDate);
             LoanRepaymentSchedule2.SETRANGE("Loan No.", LoanNo);
             if LoanRepaymentSchedule2.FINDLAST then
                 ExpectedRepaymentDate := LoanRepaymentSchedule2."Repayment Date";

             if Type = 'D' then begin
                 if AmountPaid2 < ExpectedAmount then
                     NoofDaysInArrears := ExpectedRepaymentDate - LastRepaymentDate
                 else
                     NoofDaysInArrears := 0;

                 if NoofDaysInArrears > 0 then
                     EXIT(NoofDaysInArrears)
                 else
                     EXIT(0)
            end;
             if Type = 'I' then begin
                 LoanRepaymentSchedule.RESET;
                 LoanRepaymentSchedule.SETRANGE("Repayment Date", LastRepaymentDate, ExpectedRepaymentDate);
                 LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
                 if AmountPaid2 < ROUND(ExpectedAmount, 0.01, '=') then
                     NoofDefaultedInstallments := LoanRepaymentSchedule.COUNT
                 else
                     NoofDefaultedInstallments := 0;
                 EXIT(NoofDefaultedInstallments);
            end;
        end;
    end;
end;

 local procedure CalculateNoofDaysinArrears(LoanNo: Code[20]; PArrearsAmount: Decimal; IArrearsAmount: Decimal; PrepaymentAmount: Decimal;endDate: Date): Integer;
 var
     VendorLedgerEntry: Record 25;
     LoanRepaymentSchedule: Record "50008";
     LoanAmount: array[2] of Decimal;
 begin
     /*if PrepaymentAmount=0 then begin
         VendorLedgerEntry.RESET;
         VendorLedgerEntry.SETRANGE("Vendor No.",LoanNo);
         VendorLedgerEntry.SETFILTER("Posting Date",'%1..%2',0D,EndDate);
         VendorLedgerEntry.SETFILTER("Credit Amount",'<>%1',0);
         VendorLedgerEntry.SETRANGE(Reversed,FALSE);
         if VendorLedgerEntry.FINDSET then begin
            REPEAT
              VendorLedgerEntry.CALCFIELDS("Credit Amount (LCY)");
              LoanAmount[1]+=VendorLedgerEntry."Credit Amount (LCY)";
            UNTIL VendorLedgerEntry.NEXT=0;
        end;

         LoanRepaymentSchedule.RESET;
         LoanRepaymentSchedule.SETRANGE("Loan No.",LoanNo);
         if LoanRepaymentSchedule.FINDSET then begin
            REPEAT
              if LoanAmount[1]=LoanAmount[2] then
                 EXIT(EndDate-LoanRepaymentSchedule."Repayment Date");

              LoanAmount[2]+=LoanRepaymentSchedule."Monthly Repayment";

              if LoanAmount[1]<LoanAmount[2] then
                 EXIT(EndDate-LoanRepaymentSchedule."Repayment Date");
            UNTIL LoanRepaymentSchedule.NEXT=0;
        end;
    end else begin
         if PArrearsAmount=0 then begin
             VendorLedgerEntry.RESET;
             VendorLedgerEntry.SETRANGE("Vendor No.",LoanNo);
             VendorLedgerEntry.SETFILTER("Posting Date",'%1..%2',0D,EndDate);
             VendorLedgerEntry.SETRANGE("Transaction Type",VendorLedgerEntry."Transaction Type"::"Interest Paid");
             VendorLedgerEntry.SETRANGE(Reversed,FALSE);
             if VendorLedgerEntry.FINDSET then begin
                REPEAT
                  VendorLedgerEntry.CALCFIELDS("Credit Amount (LCY)");
                  LoanAmount[1]+=VendorLedgerEntry."Credit Amount (LCY)";
                UNTIL VendorLedgerEntry.NEXT=0;
            end;

             LoanRepaymentSchedule.RESET;
             LoanRepaymentSchedule.SETRANGE("Loan No.",LoanNo);
             if LoanRepaymentSchedule.FINDSET then begin
                REPEAT
                  if LoanAmount[1]=LoanAmount[2] then begin
                     EXIT(EndDate-LoanRepaymentSchedule."Repayment Date");
                 end;
                  LoanAmount[2]+=ROUND(LoanRepaymentSchedule."Monthly Interest",0.01,'>');

                  if LoanAmount[1]<LoanAmount[2] then begin
                     EXIT(EndDate-LoanRepaymentSchedule."Repayment Date");
                 end;
                UNTIL LoanRepaymentSchedule.NEXT=0;
            end;
        end else begin
             VendorLedgerEntry.RESET;
             VendorLedgerEntry.SETRANGE("Vendor No.",LoanNo);
             VendorLedgerEntry.SETFILTER("Posting Date",'%1..%2',0D,EndDate);
             VendorLedgerEntry.SETRANGE("Transaction Type",VendorLedgerEntry."Transaction Type"::Repayment);
             VendorLedgerEntry.SETRANGE(Reversed,FALSE);
             if VendorLedgerEntry.FINDSET then begin
                REPEAT
                  VendorLedgerEntry.CALCFIELDS("Credit Amount (LCY)");
                  LoanAmount[1]+=VendorLedgerEntry."Credit Amount (LCY)";
                UNTIL VendorLedgerEntry.NEXT=0;
            end;

             LoanRepaymentSchedule.RESET;
             LoanRepaymentSchedule.SETRANGE("Loan No.",LoanNo);
             if LoanRepaymentSchedule.FINDSET then begin
                REPEAT
                  if LoanAmount[1]=LoanAmount[2] then
                     EXIT(EndDate-LoanRepaymentSchedule."Repayment Date");

                  LoanAmount[2]+=ROUND(LoanRepaymentSchedule."Principal Repayment",0.01,'>');

                  if LoanAmount[1]<LoanAmount[2] then
                     EXIT(EndDate-LoanRepaymentSchedule."Repayment Date");

                UNTIL LoanRepaymentSchedule.NEXT=0;
            end;
        end;
    end;
     */
    /*     VendorLedgerEntry.RESET;
         VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
         VendorLedgerEntry.SETFILTER("Posting Date", '%1..%2', 0D,endDate);
         VendorLedgerEntry.SETRANGE("Transaction Type", VendorLedgerEntry."Transaction Type"::Repayment);
         VendorLedgerEntry.SETRANGE(Reversed, FALSE);
         if VendorLedgerEntry.FINDSET then begin
             REPEAT
                 VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
                 LoanAmount[1] += VendorLedgerEntry.Amount;
             UNTIL VendorLedgerEntry.NEXT = 0;
        end;

         LoanRepaymentSchedule.RESET;
         LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
         if LoanRepaymentSchedule.FINDSET then begin
             REPEAT
                 if LoanAmount[1] = LoanAmount[2] then
                     EXIT(EndDate - LoanRepaymentSchedule."Repayment Date");

                 LoanAmount[2] += ROUND(LoanRepaymentSchedule."Principal Repayment", 0.01, '>');

                 if LoanAmount[1] < LoanAmount[2] then
                     EXIT(EndDate - LoanRepaymentSchedule."Repayment Date");

             UNTIL LoanRepaymentSchedule.NEXT = 0;
        end;

    end;

     local procedure GetFirstLastDueDate(LoanNo: Code[20]; DateCode: Code[20]): Date;
     begin
         LoanRepaymentSchedule.RESET;
         LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
         if LoanRepaymentSchedule.FINDSET then begin
             if DateCode = 'F' then begin
                 if LoanRepaymentSchedule.FINDFIRST then
                     EXIT(LoanRepaymentSchedule."Repayment Date");
            end;
             if DateCode = 'L' then begin
                 if LoanRepaymentSchedule.FINDLAST then
                     EXIT(LoanRepaymentSchedule."Repayment Date");
            end;
        end;
    end;

     local procedure CalculateNoofMonths(StartDate: Date;endDate: Date): Integer;
     var
         Calender: Record "2000000007";
     begin
         Calender.RESET;
         Calender.SETRANGE("Period Start", StartDate,endDate);
         Calender.SETRANGE("Period Type", Calender."Period Type"::Month);
         EXIT(Calender.COUNT);
    end;

     local procedure GetClassificationCode(NoOfDays: Integer; ClassPar: Code[20]): Text;
     var
         LoanClassificationSetup: Record "Loan Classification Setup";
     begin
         LoanClassificationSetup.RESET;
         if LoanClassificationSetup.FINDSET then begin
             REPEAT
                 if ((NoOfDays >= LoanClassificationSetup."Minimum Defaulted Days") AND (NoOfDays <= LoanClassificationSetup."Maximum Defaulted Days")) then begin
                     if ClassPar = 'CC' then
                         EXIT(LoanClassificationSetup.Description);
                     if ClassPar = 'PP' then
                         EXIT(FORMAT(LoanClassificationSetup."Required Provision"));
                end;
             UNTIL LoanClassificationSetup.NEXT = 0;
        end;
    end;*/

    procedure GetExpectedRepaymentAmount(LoanNo: Code[20]; RepaymentDate: Date; RepaymentCode: Code[20]) RepaymentAmount: Decimal;
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        MCLoanApplication: Record "Loan Application";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        CASE RepaymentCode OF
            'I':
                begin
                    RepaymentAmount := 0;
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
                    VendorLedgerEntry.SETRANGE("Posting Date", 0D, RepaymentDate);
                    //    VendorLedgerEntry.SETFILTER("Transaction Type", '%1|%2', VendorLedgerEntry."Transaction Type"::"Interest Due", VendorLedgerEntry."Transaction Type"::"Interest Paid");
                    if VendorLedgerEntry.FINDSET then begin
                        REPEAT
                            VendorLedgerEntry.CALCFIELDS(Amount);
                            RepaymentAmount += VendorLedgerEntry.Amount;
                        UNTIL VendorLedgerEntry.NEXT = 0;
                    end;
                end;
            'P':
                begin
                    RepaymentAmount := 0;
                    if LoanRepaymentSchedule.GET(LoanNo, RepaymentDate) then begin
                        RepaymentAmount := LoanRepaymentSchedule."Principal Installment";
                    end;
                    LoanRepaymentSchedule.RESET;
                    LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
                    LoanRepaymentSchedule.SETRANGE("Repayment Date", RepaymentDate);
                    if LoanRepaymentSchedule.FINDFIRST then
                        RepaymentAmount := LoanRepaymentSchedule."Principal Installment"
                end;
        end;
        if RepaymentAmount > 0 then
            EXIT(ROUND(RepaymentAmount, 0.01, '<'))
        else
            EXIT(0);

    end;

    /*    procedure PostLoanRecovery(MCLoanApplication: Record "Loan Application");
        var
         RecRef: RecordRef;
         ArrearsAmount: array[4] of Decimal;
         AmountDue: array[4] of Decimal;
         GenJournalLine: Record "81";
         AmountToRecover: array[4] of Decimal;
         RemainingAmount: Decimal;
         Text000: Label 'Amount of KES';
         Text001: Label 'will be recovered from your account';
         AccountTypes: Record "50046";
         AvailableAmount: Decimal;
         rec: Integer;
         RecoveryDate: Date;
        begin
         WITH MCLoanApplication DO begin
             i := 0;
             CLEAR(RecRef);
             CLEAR(AmountDue);
             CLEAR(ArrearsAmount);
             CLEAR(AmountToRecover);
             CLEAR(RemArrearsAmount);
             CLEAR(RemDueAmount);
             RecRef.GETTABLE(MCLoanApplication);
             MicroCreditSetup.GET;
             if MicroCreditMember.GET("Member No.");;
             if GetRecoveryDate("Group No.") <> 0D then
                 RecoveryDate := GetRecoveryDate("Group No.");

             if CalculateLoanArrearsAndOverpayment("No.", TODAY, 'I') >= 0 then
                 ArrearsAmount[1] := CalculateLoanArrearsAndOverpayment("No.", RecoveryDate, 'I')
             else
                 ArrearsAmount[1] := 0;

             if CalculateLoanArrearsAndOverpayment("No.", TODAY, 'P') >= 0 then
                 ArrearsAmount[2] := CalculateLoanArrearsAndOverpayment("No.", RecoveryDate, 'P')
             else
                 ArrearsAmount[2] := 0;

             AmountDue[1] := GetExpectedRepaymentAmount("No.", RecoveryDate, 'I');
             AmountDue[2] := GetExpectedRepaymentAmount("No.", RecoveryDate, 'P');

             if AmountDue[2] = 0 then begin
                 AmountDue[1] := 0;
            end;

             AmountToRecover[1] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];
             if AmountToRecover[1] <> 0 then begin
                 Vendor.RESET;
                 Vendor.SETRANGE("Owner Member No", "Member No.");
                 Vendor.SETRANGE("Savings Account", TRUE);
                 if Vendor.FINDSET then begin
                     REPEAT
                         Vendor.CALCFIELDS("Balance (LCY)");
                         AmountToRecover[2] := 0;
                         if Vendor."Balance (LCY)" > 0 then begin
                             AvailableAmount := 0;
                             if AccountTypes.GET(Vendor."Account Type") then begin
                                 AvailableAmount := Vendor."Balance (LCY)" - AccountTypes."Minimum Balance";
                                 if AvailableAmount > 0 then begin
                                     i += 1;

                                     if i = 1 then begin

                                         if AmountToRecover[1] <= AvailableAmount then
                                             AmountToRecover[2] := AmountToRecover[1]
                                         else
                                             AmountToRecover[2] := AvailableAmount;

                                         RemArrearsAmount[3] := ArrearsAmount[1];
                                         RemArrearsAmount[4] := ArrearsAmount[2];

                                         RemDueAmount[3] := AmountDue[1];
                                         RemDueAmount[4] := AmountDue[2]

                                    end else begin
                                         AmountToRecover[1] := RemArrearsAmount[1] + RemArrearsAmount[2] + RemDueAmount[1] + RemDueAmount[2];
                                         if AmountToRecover[1] > 0 then begin
                                             if AmountToRecover[1] <= AvailableAmount then
                                                 AmountToRecover[2] := AmountToRecover[1]
                                             else
                                                 AmountToRecover[2] := AvailableAmount;

                                             RemArrearsAmount[3] := RemArrearsAmount[1];
                                             RemArrearsAmount[4] := RemArrearsAmount[2];

                                             RemDueAmount[3] := RemDueAmount[1];
                                             RemDueAmount[4] := RemDueAmount[2];
                                        end else begin
                                             AmountToRecover[2] := 0;
                                        end;
                                    end;

                                     RemainingAmount := AvailableAmount;
                                     SplitLoanRepayment(RecRef, 1, AmountToRecover[2], RemArrearsAmount[3], RemArrearsAmount[4], RemDueAmount[3], RemDueAmount[4], RemainingAmount);
                                     GlobalManagement.CreateJournal(MicroCreditSetup."Loan Recovery Template Name", MicroCreditSetup."Loan Recovery Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                   Vendor."No.", Text002 + "No.", AmountToRecover[2], 0, GetBranchCode(MicroCreditMember."No."));

                                end;
                            end;
                        end;
                     // AddSMS(Vendor."Mobile Phone No",(Text000+' '+FORMAT(AmountToRecover[2])+' '+Text001+' ('+Vendor."No."+'-'+Vendor.Name+')'),'LOANRECOVERY');
                     UNTIL Vendor.NEXT = 0;
                end;
            end;
        end;
       end;

        local procedure GetRecoveryDate(GroupNo: Code[20]): Date;
        var
         MicroCreditMember: Record 50006;
         DayofWeek: Text;
         WeekNo: Integer;
        begin
         MicroCreditMember.GET(GroupNo);
         if MicroCreditMember."Group Meeting Week" <> 0 then begin
             WeekNo := DATE2DWY(TODAY, 2);
             DayofWeek := FORMAT(TODAY, 0, '<Weekday Text>');
             if ((MicroCreditMember."Group Meeting Week" = WeekNo) AND (DayofWeek = FORMAT(MicroCreditMember."Group Meeting Day"))) then
                 EXIT(DMY2DATE(MicroCreditMember."Group Meeting Day", WeekNo, DATE2DMY(TODAY, 3)))
        end else
             EXIT(TODAY);
       end;

        procedure PostFundTransfer(var FundTransfer: Record "52040");
        var
         LoanGuarantorLine: Record "52041";
         OriginalPostingGroup: Code[20];
         MCLoanApplication: Record "Loan Application";
         RecRef: RecordRef;
         ArrearsAmount: array[4] of Decimal;
         AmountDue: array[4] of Decimal;
         GenJournalLine: Record "81";
         RemainingAmount: array[4] of Decimal;
         AmountToTransfer: array[4] of Decimal;
         AmountToDeduct: array[4] of Decimal;
         Text000: Label '-Principal Overpayment';
         Text001: Label '" Loan OverRecovery"';
         Text002: Label 'Loan Arrears Recovery';
         AccountTypes: Record "50046";
         AccountBalance: Decimal;
        begin
         WITH FundTransfer DO begin
             ValidateDocumentNo("No.");
             CLEAR(RecRef);
             RecRef.GETTABLE(FundTransfer);
             MicroCreditSetup.GET;
             if MicroCreditMember.GET("Member No.");;
             ClearJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name");

             if NOT Posted then begin
                 if "Pay from Member" AND NOT "Pay from Guarantors" then
                     AmountToTransfer[1] := "Amount to Transfer";

                 if "Pay from Member" AND "Pay from Guarantors" then
                     AmountToTransfer[1] := "Amount to Transfer" + "Amount to Pay from Guarantors";

                 if NOT "Pay from Member" AND "Pay from Guarantors" then
                     AmountToTransfer[1] := "Amount to Pay from Guarantors";
                 if "Source Account Type" = "Source Account Type"::"From Savings" then begin
                     if "Destination Account Type" = "Destination Account Type"::"To Other Account" then begin
                         //Check if Source Member Has Loan
                         if CalculateLoanArrearsAndOverpayment("Source Loan No.", TODAY, 'I') > 0 then
                             ArrearsAmount[1] := CalculateLoanArrearsAndOverpayment("Source Loan No.", TODAY, 'I')
                         else
                             ArrearsAmount[1] := 0;

                         if CalculateLoanArrearsAndOverpayment("Source Loan No.", TODAY, 'P') > 0 then
                             ArrearsAmount[2] := CalculateLoanArrearsAndOverpayment("Source Loan No.", TODAY, 'P')
                         else
                             ArrearsAmount[2] := 0;

                         AmountDue[1] := GetExpectedRepaymentAmount("Source Loan No.", TODAY, 'I');
                         AmountDue[2] := GetExpectedRepaymentAmount("Source Loan No.", TODAY, 'P');

                         if AmountDue[2] = 0 then begin
                             AmountDue[1] := 0;
                        end;

                         AmountToDeduct[1] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];
                         AmountToTransfer[2] := AmountToTransfer[1];

                         SplitLoanRepayment(RecRef, 1, AmountToDeduct[2], ArrearsAmount[1], ArrearsAmount[2], AmountDue[1], AmountDue[2], AmountToTransfer[2]);
                         RemainingAmount[1] := AmountToTransfer[2];

                         if RemainingAmount[1] = 0 then begin
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Source Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Source Account No.", Description, AmountToTransfer[1], 0, GetBranchCode("Member No."));
                        end;
                         if RemainingAmount[1] > 0 then begin
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Destination Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Destination Account No.", Description, -RemainingAmount[1], 0, GetBranchCode("Destination Member No."));
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Source Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Source Account No.", Description, AmountToTransfer[1], 0, GetBranchCode("Member No."));
                        end;
                         if "Pay from Guarantors" then begin
                             LoanGuarantorLine.RESET;
                             LoanGuarantorLine.SETRANGE("Document No.", "No.");
                             if LoanGuarantorLine.FINDSET then begin
                                 REPEAT
                                     GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                   LoanGuarantorLine."Account No.", Text002 + "No.", LoanGuarantorLine."Amount to Recover", '', GetBranchCode(MicroCreditMember."No."));
                                 UNTIL LoanGuarantorLine.NEXT = 0;
                            end;
                        end;
                    end;
                     if "Destination Account Type" = "Destination Account Type"::"To Loan" then begin
                         //Check if Source Member Has Loan
                         if CalculateLoanArrearsAndOverpayment("Destination Account No.", TODAY, 'I') > 0 then
                             ArrearsAmount[1] := CalculateLoanArrearsAndOverpayment("Destination Account No.", TODAY, 'I')
                         else
                             ArrearsAmount[1] := 0;

                         if CalculateLoanArrearsAndOverpayment("Destination Account No.", TODAY, 'P') > 0 then
                             ArrearsAmount[2] := CalculateLoanArrearsAndOverpayment("Destination Account No.", TODAY, 'P')
                         else
                             ArrearsAmount[2] := 0;

                         AmountDue[1] := GetExpectedRepaymentAmount("Destination Account No.", TODAY, 'I');
                         AmountDue[2] := GetExpectedRepaymentAmount("Destination Account No.", TODAY, 'P');

                         AmountToDeduct[1] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];

                         AmountToTransfer[2] := AmountToTransfer[1];
                         if AmountToTransfer[2] >= AmountToDeduct[1] then
                             AmountToDeduct[2] := AmountToDeduct[1]
                         else
                             AmountToDeduct[2] := AmountToTransfer[2];

                         SplitLoanRepayment(RecRef, '', AmountToDeduct[2], ArrearsAmount[1], ArrearsAmount[2], AmountDue[1], AmountDue[2], AmountToTransfer[2]);
                         RemainingAmount[1] := AmountToTransfer[2];

                         if RemainingAmount[1] = 0 then begin
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Source Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Source Account No.", Description, AmountToTransfer[1], 0, GetBranchCode("Member No."));
                        end;
                         if RemainingAmount[1] > 0 then begin
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Destination Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Destination Account No.", Description + Text000, -RemainingAmount[1], '', GetBranchCode("Destination Member No."));
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Source Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Source Account No.", Description, AmountToTransfer[1], 0, GetBranchCode("Member No."));
                        end;

                         if "Pay from Guarantors" then begin
                             LoanGuarantorLine.RESET;
                             LoanGuarantorLine.SETRANGE("Document No.", "No.");
                             if LoanGuarantorLine.FINDSET then begin
                                 REPEAT
                                     GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                   LoanGuarantorLine."Account No.", Text002 + "No.", LoanGuarantorLine."Amount to Recover", '', GetBranchCode(MicroCreditMember."No."));
                                 UNTIL LoanGuarantorLine.NEXT = 0;
                            end;
                        end;
                    end;
                end else begin
                     GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Destination Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      "Destination Account No.", Description + Text001, -"Amount to Transfer", 0, GetBranchCode("Destination Member No."));
                     GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Source Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      "Source Account No.", Description + Text001, "Amount to Transfer", '', GetBranchCode("Member No."));
                end;
                 CLEARLASTERROR;
                 if GlobalManagement.PostJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name") then begin
                     Posted := TRUE;
                     "Amount Transferred" := RemainingAmount[1];
                     modify;

                     if "Destination Account Type" = "Destination Account Type"::"To Loan" then begin
                         if Vendor.GET("Destination Account No.") then begin
                             UpdateArrears("Destination Account No.");
                        end;
                    end;

                     CLEAR(RecRef);
                     RecRef.GETTABLE(FundTransfer);
                     CreateSMS(RecRef, 1);
                end else begin
                     if GETLASTERRORTEXT <> '' then
                         ERROR(GETLASTERRORTEXT);
                end;
            end;//End NOT Posted

             if Posted then begin
                 if Vendor.GET("Destination Account No.") then begin
                     if AccountTypes.GET(Vendor."Account Type") then;
                     if AccountTypes."Savings Account" = TRUE then begin
                         if "Destination Member No." <> "Member No." then begin
                             //if CONFIRM(Text013,TRUE,"Destination Member No.","Destination Member Name") then begin
                             //Check if Destination Member has LOAN
                             if CalculateLoanArrearsAndOverpayment("Destination Loan No.", TODAY, 'I') > 0 then
                                 ArrearsAmount[1] := CalculateLoanArrearsAndOverpayment("Destination Loan No.", TODAY, 'I')
                             else
                                 ArrearsAmount[1] := 0;

                             if CalculateLoanArrearsAndOverpayment("Destination Loan No.", TODAY, 'P') > 0 then
                                 ArrearsAmount[2] := CalculateLoanArrearsAndOverpayment("Destination Loan No.", TODAY, 'P')
                             else
                                 ArrearsAmount[2] := 0;

                             AmountDue[1] := GetExpectedRepaymentAmount("Destination Loan No.", TODAY, 'I');
                             AmountDue[2] := GetExpectedRepaymentAmount("Destination Loan No.", TODAY, 'P');

                             AmountToDeduct[1] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];
                             AccountBalance := 0;
                             if Vendor.GET("Destination Account No.") then begin
                                 Vendor.CALCFIELDS("Balance (LCY)");
                                 AccountBalance := Vendor."Balance (LCY)" - AccountTypes."Minimum Balance";
                            end;

                             if AccountBalance < 0 then
                                 AccountBalance += "Amount Transferred";

                             if "Amount Transferred" < AccountBalance then begin
                                 AmountToTransfer[1] := "Amount Transferred";
                            end else
                                 AmountToTransfer[1] := AccountBalance;

                             if AmountToTransfer[1] >= AmountToDeduct[1] then
                                 AmountToDeduct[2] := AmountToDeduct[1]
                             else
                                 AmountToDeduct[2] := AmountToTransfer[1];


                             SplitLoanRepayment(RecRef, 2, AmountToDeduct[2], ArrearsAmount[1], ArrearsAmount[2], AmountDue[1], AmountDue[2], AmountToTransfer[1]);
                             GlobalManagement.CreateJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name", "No.", "Destination Account No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           "Destination Account No.", Text002, AmountToDeduct[2], 0, GetBranchCode("Destination Member No."));

                             CLEARLASTERROR;
                             if GlobalManagement.PostJournal(MicroCreditSetup."Fund Transfer Template Name", MicroCreditSetup."Fund Transfer Batch Name") then begin
                                 EXIT;
                            end else begin
                                 if GETLASTERRORTEXT <> '' then
                                     ERROR(GETLASTERRORTEXT);
                            end;
                        end;
                    end;
                end;
            end;
             //END else
             // EXIT;
        end;
       end;

        procedure PostStandingOrder(var StandingOrder: Record "52050");
        var
         GenJournalLine: Record "81";
         OriginalPostingGroup: Code[20];
         MCLoanApplication: Record "Loan Application";
         StandingOrderLine: Record "52051";
         RecRef: RecordRef;
         ArrearsAmount: array[4] of Decimal;
         AmountDue: array[4] of Decimal;
         AmountToDeduct: array[10] of Decimal;
         AvailableAmount: Decimal;
         TotalAmountToDeduct: Decimal;
         Text000: Label '-Principal Overpayment';
        begin
         WITH StandingOrder DO begin
             ValidateDocumentNo("No.");
             AmountToDeduct[2] := 0;
             ArrearsAmount[1] := 0;
             ArrearsAmount[2] := 0;
             AmountDue[1] := 0;
             AmountDue[2] := 0;
             TotalAmountToDeduct := 0;
             MicroCreditSetup.GET;
             if MicroCreditMember.GET("Member No.");;
             if GetAccountBalance("Source Account No.") >= "Amount to Deduct" then
                 AmountToDeduct[1] := "Amount to Deduct"
             else
                 AmountToDeduct[1] := GetAccountBalance("Source Account No.");

             StandingOrderLine.RESET;
             StandingOrderLine.SETCURRENTKEY("Document No.", Priority);
             StandingOrderLine.SETRANGE("Document No.", "No.");
             if StandingOrderLine.FINDSET then begin
                 REPEAT
                     StandingOrderLine.TESTFIELD("Account No.");
                     if Vendor.GET(StandingOrderLine."Account No.") then;
                     CLEAR(RecRef);
                     RecRef.GETTABLE(StandingOrderLine);
                     if StandingOrderLine.Priority = 1 then begin
                         if Vendor."Account Type" = 'LOAN' then begin
                             if CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'I') >= 0 then
                                 ArrearsAmount[1] := CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'I')
                             else
                                 ArrearsAmount[1] := 0;

                             if CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'P') >= 0 then
                                 ArrearsAmount[2] := CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'P')
                             else
                                 ArrearsAmount[2] := 0;

                             AmountDue[1] := GetExpectedRepaymentAmount(StandingOrderLine."Account No.", TODAY, 'I');
                             AmountDue[2] := GetExpectedRepaymentAmount(StandingOrderLine."Account No.", TODAY, 'P');

                             if AmountToDeduct[1] >= StandingOrderLine."Allocation Amount" then
                                 AmountToDeduct[3] := StandingOrderLine."Allocation Amount"
                             else
                                 AmountToDeduct[3] := AmountToDeduct[1];

                             AmountToDeduct[2] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];
                             if AmountToDeduct[3] >= AmountToDeduct[2] then
                                 AmountToDeduct[4] := AmountToDeduct[2]
                             else
                                 AmountToDeduct[4] := AmountToDeduct[3];

                             RemainingAmount[1] := AmountToDeduct[3] - AmountToDeduct[2];
                             TotalAmountToDeduct += AmountToDeduct[4];

                             SplitLoanRepayment(RecRef, 1, AmountToDeduct[4], ArrearsAmount[1], ArrearsAmount[2], AmountDue[1], AmountDue[2], AmountToDeduct[1]);
                             RemainingAmount[2] := AmountToDeduct[1];

                             if RemainingAmount[1] > 0 then begin
                                 GlobalManagement.CreateJournal(MicroCreditSetup."Standing Order Template Name", MicroCreditSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                               GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description + Text000, -RemainingAmount[1], '', GetBranchCode(StandingOrderLine."Member No."));
                                 TotalAmountToDeduct += RemainingAmount[1];
                            end;
                        end else begin
                             if AmountToDeduct[1] >= StandingOrderLine."Allocation Amount" then
                                 AmountToDeduct[3] := StandingOrderLine."Allocation Amount"
                             else
                                 AmountToDeduct[3] := AmountToDeduct[1];

                             GlobalManagement.CreateJournal(MicroCreditSetup."Standing Order Template Name", MicroCreditSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                           GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AmountToDeduct[3], 0, GetBranchCode(StandingOrderLine."Member No."));
                             TotalAmountToDeduct += AmountToDeduct[3];
                             AmountToDeduct[1] -= AmountToDeduct[3];
                             RemainingAmount[2] := AmountToDeduct[1];

                        end;
                    end;
                     if StandingOrderLine.Priority > 1 then begin
                         if Vendor."Account Type" = 'LOAN' then begin
                             RemainingAmount[3] := RemainingAmount[2];

                             if CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'I') >= 0 then
                                 ArrearsAmount[1] := CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'I')
                             else
                                 ArrearsAmount[1] := 0;

                             if CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'P') >= 0 then
                                 ArrearsAmount[2] := CalculateLoanArrearsAndOverpayment(StandingOrderLine."Account No.", TODAY, 'P')
                             else
                                 ArrearsAmount[2] := 0;

                             AmountDue[1] := GetExpectedRepaymentAmount(StandingOrderLine."Account No.", TODAY, 'I');
                             AmountDue[2] := GetExpectedRepaymentAmount(StandingOrderLine."Account No.", TODAY, 'P');

                             AmountToDeduct[5] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];

                             if RemainingAmount[3] >= StandingOrderLine."Allocation Amount" then
                                 AmountToDeduct[6] := StandingOrderLine."Allocation Amount"
                             else
                                 AmountToDeduct[6] := RemainingAmount[3];

                             if AmountToDeduct[6] >= AmountToDeduct[5] then
                                 AmountToDeduct[7] := AmountToDeduct[5]
                             else
                                 AmountToDeduct[7] := AmountToDeduct[6];

                             TotalAmountToDeduct += AmountToDeduct[7];
                             RemainingAmount[4] := AmountToDeduct[6] - AmountToDeduct[5];

                             SplitLoanRepayment(RecRef, 1, AmountToDeduct[7], ArrearsAmount[1], ArrearsAmount[2], AmountDue[1], AmountDue[2], RemainingAmount[3]);
                             RemainingAmount[3] := RemainingAmount[3];
                             if RemainingAmount[4] > 0 then begin
                                 GlobalManagement.CreateJournal(MicroCreditSetup."Standing Order Template Name", MicroCreditSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                               GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description + Text000, -RemainingAmount[4], '', GetBranchCode(StandingOrderLine."Member No."));
                                 TotalAmountToDeduct += RemainingAmount[4];
                            end;
                        end else begin
                             RemainingAmount[3] := RemainingAmount[2];
                             if RemainingAmount[3] >= StandingOrderLine."Allocation Amount" then
                                 AmountToDeduct[8] := StandingOrderLine."Allocation Amount"
                             else
                                 AmountToDeduct[8] := RemainingAmount[3];

                             GlobalManagement.CreateJournal(MicroCreditSetup."Standing Order Template Name", MicroCreditSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                           GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AmountToDeduct[8], 0, GetBranchCode(StandingOrderLine."Member No."));
                             TotalAmountToDeduct += AmountToDeduct[8];
                             RemainingAmount[3] -= AmountToDeduct[8];
                        end;
                    end;
                 UNTIL StandingOrderLine.NEXT = 0;
                 GlobalManagement.CreateJournal(MicroCreditSetup."Standing Order Template Name", MicroCreditSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                               GenJournalLine."Account Type"::Vendor, "Source Account No.", Description, TotalAmountToDeduct, 0, GetBranchCode("Group No."),0,'');
            end;
        end;
       end;

        procedure GetAccountBalance(AccountNo: Code[20]): Decimal;
        var
         AccountTypes: Record "50046";
        begin
         if Vendor.GET(AccountNo) then begin
             Vendor.CALCFIELDS("Balance (LCY)");
             if AccountTypes.GET(Vendor."Account Type") then;
             EXIT(ABS(Vendor."Balance (LCY)") - AccountTypes."Minimum Balance");
        end;
       end;

        procedure PostRefund(MemberRefundMembershipHeader: Record "52032");
        var
         MemberRefundMembershipLine: Record "52033";
         GenJournalLine: Record "81";
         RefundAmount: Decimal;
         ApprovalsMgmt: Codeunit "1535";
         RefundAllocation: Record "52034";
        begin
         WITH MemberRefundMembershipHeader DO begin
             MicroCreditSetup.GET;
             if MicroCreditMember.GET("Member No.");;
             ClearJournal(MicroCreditSetup."Exit Refund Template Name", MicroCreditSetup."Exit Refund Batch Name");
             RefundAmount := 0;
             MemberRefundMembershipLine.RESET;
             MemberRefundMembershipLine.SETRANGE("Document No.", "No.");
             MemberRefundMembershipLine.SETRANGE("Account Ownership", MemberRefundMembershipLine."Account Ownership"::Self);
             MemberRefundMembershipLine.SETFILTER("Account Balance", '>0');
             if MemberRefundMembershipLine.FINDSET then begin
                 REPEAT
                     GlobalManagement.CreateJournal(MicroCreditSetup."Exit Refund Template Name", MicroCreditSetup."Exit Refund Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                   MemberRefundMembershipLine."Account No.", Text003 + "No.", MemberRefundMembershipLine."Account Balance", 0, GetBranchCode(MicroCreditMember."No."));
                     RefundAmount += MemberRefundMembershipLine."Account Balance";

                     RefundAllocation.RESET;
                     RefundAllocation.SETRANGE("Document No.", MemberRefundMembershipLine."Document No.");
                     RefundAllocation.SETRANGE("Source Account No.", MemberRefundMembershipLine."Account No.");
                     if RefundAllocation.FINDSET then begin
                         REPEAT
                             RefundAllocation.TESTFIELD("Account No.");
                             GlobalManagement.CreateJournal(MicroCreditSetup."Exit Refund Template Name", MicroCreditSetup."Exit Refund Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                           RefundAllocation."Account No.", Text003 + "No.", -RefundAllocation."Allocation Amount", 0, GetBranchCode(MicroCreditMember."No."));
                         UNTIL RefundAllocation.NEXT = 0;
                    end;
                 UNTIL MemberRefundMembershipLine.NEXT = 0;
            end;

             CLEARLASTERROR;
             if GlobalManagement.PostJournal(MicroCreditSetup."Exit Refund Template Name", MicroCreditSetup."Exit Refund Batch Name") then begin
                 Posted := TRUE;
                 modify;
                 if Posted then begin
                     MicroCreditMember."Exit Status" := MicroCreditMember."Exit Status"::"Pending Accounts Closure";
                     MicroCreditMember.modify;
                end;
            end else begin
                 if GETLASTERRORTEXT <> '' then
                     ERROR(GETLASTERRORTEXT);
            end;
        end;
       end;

        procedure CloseMemberAccounts(var MemberRefundMembershipHeader: Record "52032");
        var
         MemberRefundMembershipLine: Record "52033";
         Vendor: Record "23";
        begin
         WITH MemberRefundMembershipHeader DO begin
             TESTFIELD("Action Type", "Action Type"::Refund);
             MemberRefundMembershipLine.RESET;
             MemberRefundMembershipLine.SETRANGE("Document No.", "No.");
             MemberRefundMembershipLine.SETRANGE("Account Ownership", MemberRefundMembershipLine."Account Ownership"::Self);
             if MemberRefundMembershipLine.FINDSET then begin
                 REPEAT
                     if Vendor.GET(MemberRefundMembershipLine."Account No.") then begin
                         Vendor."Account Remarks" := "Reason for Exit";
                         Vendor.Status := Vendor.Status::Closed;
                         Vendor.modify;
                    end;
                 UNTIL MemberRefundMembershipLine.NEXT = 0;
            end;
             if MicroCreditMember.GET("Member No."); begin
                 MicroCreditMember."Exit Status" := MicroCreditMember."Exit Status"::"Accounts Closed";
                 MicroCreditMember.Status := MicroCreditMember.Status::Withdrawn;
                 if MicroCreditMember.modify then
                     MESSAGE(Text004, "Member No.", "Member Name");
            end;
        end;
       end;

        procedure CheckForExistingLoan("MemberNo.": Code[20]): Boolean;
        var
         Vendor: Record "23";
        begin
         Vendor.RESET;
         Vendor.SETRANGE("Owner Member No", "MemberNo.");
         Vendor.SETRANGE("Account Type", 'LOAN');
         Vendor.SETRANGE(Status, Vendor.Status::Active);
         Vendor.SETFILTER("Balance (LCY)", '<>%1', 0);
         if Vendor.FINDFIRST then
             EXIT(TRUE)
         else
             EXIT(FALSE);
       end;*/

    procedure GetLoanScore("LoanNo.": Code[20]): Decimal;
    var
        LoanRepaySchedule: Record "Loan Repayment Schedule";
        VendorLedgerEntry: Record 25;
        Installments: array[5] of Integer;
        AmountPaid: Decimal;
        MonthlyInstallment: Decimal;
        LoanClassificationEntry: Record "Loan Classification Entry";
        ExpectedAmount: Decimal;
        MeetingFrequency: Text;
        InstallmentDate: Date;
        Amount: array[2] of Decimal;
        MCLoanApplication: Record "Loan Application";
    begin
        CLEAR(Installments);
        LoanRepaySchedule.RESET;
        LoanRepaySchedule.SETRANGE("Loan No.", "LoanNo.");
        Installments[2] := LoanRepaySchedule.COUNT;

        LoanRepaySchedule.RESET;
        LoanRepaySchedule.SETRANGE("Loan No.", "LoanNo.");
        LoanRepaySchedule.SETFILTER("Repayment Date", '<=%1', TODAY);
        if LoanRepaySchedule.FINDSET then begin
            REPEAT
                InstallmentDate := CALCDATE('1D', LoanRepaySchedule."Repayment Date");
                if MCLoanApplication.GET("LoanNo.") then begin
                    //     GenerateLoanClassification(MCLoanApplication, LoanRepaySchedule."Repayment Date");
                    //     GenerateLoanClassification(MCLoanApplication, InstallmentDate);
                end;
                LoanClassificationEntry.RESET;
                LoanClassificationEntry.SETRANGE("Loan No.", "LoanNo.");
                LoanClassificationEntry.SETRANGE("Classification Date", InstallmentDate);
                if LoanClassificationEntry.FINDFIRST then begin
                    if LoanClassificationEntry."Total Arrears" = 0 then begin
                        Installments[1] += 1;
                    end;
                end;
            UNTIL LoanRepaySchedule.NEXT = 0;
            if Installments[1] = 0 then
                EXIT(0)
            else
                EXIT((Installments[1] / Installments[2]) * 100);
        end else begin
            EXIT(0);
        end;
    end;
    /*
        procedure ShowApprovalEntries(var Variant: Variant; Status: Integer);
        var
         RecRef: RecordRef;
         MCMemberApplication: Record 50000;
         GroupAllocationHeader: Record "52018";
         MemberExitHeader: Record "52028";
         MCLoanApplication: Record "Loan Application";
         MemberRefundMembershipHeader: Record "52032";
         LoanRescheduling: Record "52026";
         LoanWriteOffHeader: Record "52037";
         FundTransfer: Record "52040";
         PortfolioTransfer: Record "52008";
         StandingOrder: Record "52050";
         GuarantorSubstitutionHeader: Record "52053";
         ApprovalEntry: Record "454";
         UserSetup: Record "91";
         Found: Boolean;
        begin
         RecRef.GETTABLE(Variant);
         CASE RecRef.NUMBER OF
             DATABASE::"MC Member Application":
                 begin
                     RecRef.SETTABLE(MCMemberApplication);
                     MCMemberApplication.RESET;
                     MCMemberApplication.SETRANGE(Status, Status);
                     if MCMemberApplication.FINDSET then begin
                         REPEAT
                             if (CheckSenderApprovalEntryExist(MCMemberApplication."No.") OR CheckApproverApprovalEntryExist(MCMemberApplication."No.") OR
                                 CheckIfSubstituteApprover(MCMemberApplication."Created By"))
                             then
                                 MCMemberApplication.MARK(TRUE);
                         UNTIL MCMemberApplication.NEXT = 0;
                    end;
                     MCMemberApplication.MARKEDONLY(TRUE);
                     MCMemberApplication.COPY(MCMemberApplication);
                     Variant := MCMemberApplication;
                end;
             DATABASE::"Group Allocation Header":
                 begin
                     RecRef.SETTABLE(GroupAllocationHeader);
                     GroupAllocationHeader.RESET;
                     GroupAllocationHeader.SETRANGE(Status, Status);
                     if GroupAllocationHeader.FINDSET then begin
                         REPEAT
                             if (CheckSenderApprovalEntryExist(GroupAllocationHeader."No.") OR CheckApproverApprovalEntryExist(GroupAllocationHeader."No.") OR
                                 CheckIfSubstituteApprover(GroupAllocationHeader."Created By"))
                             then
                                 GroupAllocationHeader.MARK(TRUE);
                         UNTIL GroupAllocationHeader.NEXT = 0;
                    end;
                     GroupAllocationHeader.MARKEDONLY(TRUE);
                     GroupAllocationHeader.COPY(GroupAllocationHeader);
                     Variant := GroupAllocationHeader;
                end;
             DATABASE::"Member Exit Header":
                 begin
                     RecRef.SETTABLE(MemberExitHeader);
                     MemberExitHeader.RESET;
                     MemberExitHeader.SETRANGE(Status, Status);
                     if MemberExitHeader.FINDSET then begin
                         REPEAT
                             if (CheckSenderApprovalEntryExist(MemberExitHeader."No.") OR CheckApproverApprovalEntryExist(MemberExitHeader."No.") OR
                                CheckIfSubstituteApprover(MemberExitHeader."Created By"))
                             then
                                 MemberExitHeader.MARK(TRUE);
                         UNTIL MemberExitHeader.NEXT = 0;
                    end;
                     MemberExitHeader.MARKEDONLY(TRUE);
                     MemberExitHeader.COPY(MemberExitHeader);
                     Variant := MemberExitHeader;
                end;
             DATABASE::"MC Loan Application":
                 begin
                     RecRef.SETTABLE(MCLoanApplication);
                     MCLoanApplication.RESET;
                     MCLoanApplication.SETRANGE(Status, Status);
                     if MCLoanApplication.FINDSET then begin
                         REPEAT
                             /* if (CheckSenderApprovalEntryExist(MCLoanApplication."No.") OR CheckApproverApprovalEntryExist(MCLoanApplication."No.") OR
                                CheckIfSubstituteApprover(MCLoanApplication."Created By"))
                              then*/
    /*         if UserSetup.GET(USERID) then begin
                 if (UserSetup."Credit Manager") OR CheckSenderApprovalEntryExist(MCLoanApplication."No.") then begin
                     if MCLoanApplication."Global Dimension 1 Code" = UserSetup."Global Dimension 1 Code" then begin
                         MCLoanApplication.MARK(TRUE);
                    end;
                end;
            end;
         UNTIL MCLoanApplication.NEXT = 0;
    end;
     MCLoanApplication.MARKEDONLY(TRUE);
     MCLoanApplication.COPY(MCLoanApplication);
     Variant := MCLoanApplication;
end;
DATABASE::"Loan Rescheduling":
 begin
     RecRef.SETTABLE(LoanRescheduling);
     LoanRescheduling.RESET;
     LoanRescheduling.SETRANGE(Status, Status);
     if LoanRescheduling.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(LoanRescheduling."No.") OR CheckApproverApprovalEntryExist(LoanRescheduling."No.") OR
                CheckIfSubstituteApprover(LoanRescheduling."Created By"))
             then
                 LoanRescheduling.MARK(TRUE);
         UNTIL LoanRescheduling.NEXT = 0;
    end;
     LoanRescheduling.MARKEDONLY(TRUE);
     LoanRescheduling.COPY(LoanRescheduling);
     Variant := LoanRescheduling;
end;
DATABASE::"Member Refund/Mem. Header":
 begin
     RecRef.SETTABLE(MemberRefundMembershipHeader);
     MemberRefundMembershipHeader.RESET;
     MemberRefundMembershipHeader.SETRANGE(Status, Status);
     if MemberRefundMembershipHeader.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(MemberRefundMembershipHeader."No.") OR CheckApproverApprovalEntryExist(MemberRefundMembershipHeader."No.") OR
                 CheckIfSubstituteApprover(MemberRefundMembershipHeader."Created By"))
             then
                 MemberRefundMembershipHeader.MARK(TRUE);
         UNTIL MemberRefundMembershipHeader.NEXT = 0;
    end;
     MemberRefundMembershipHeader.MARKEDONLY(TRUE);
     MemberRefundMembershipHeader.COPY(MemberRefundMembershipHeader);
     Variant := MemberRefundMembershipHeader;
end;
DATABASE::"Loan WriteOff Header":
 begin
     RecRef.SETTABLE(LoanWriteOffHeader);
     LoanWriteOffHeader.RESET;
     LoanWriteOffHeader.SETRANGE(Status, Status);
     if LoanWriteOffHeader.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(LoanWriteOffHeader."No.") OR CheckApproverApprovalEntryExist(LoanWriteOffHeader."No.") OR
                 CheckIfSubstituteApprover(LoanWriteOffHeader."Created By"))
             then
                 LoanWriteOffHeader.MARK(TRUE);
         UNTIL LoanWriteOffHeader.NEXT = 0;
    end;
     LoanWriteOffHeader.MARKEDONLY(TRUE);
     LoanWriteOffHeader.COPY(LoanWriteOffHeader);
     Variant := LoanWriteOffHeader;
end;
DATABASE::"Fund Transfer":
 begin
     RecRef.SETTABLE(FundTransfer);
     FundTransfer.RESET;
     FundTransfer.SETRANGE(Status, Status);
     if FundTransfer.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(FundTransfer."No.") OR CheckApproverApprovalEntryExist(FundTransfer."No.") OR
                 CheckIfSubstituteApprover(FundTransfer."Created By"))
             then
                 FundTransfer.MARK(TRUE);
         UNTIL FundTransfer.NEXT = 0;
    end;
     FundTransfer.MARKEDONLY(TRUE);
     FundTransfer.COPY(FundTransfer);
     Variant := FundTransfer;
end;
DATABASE::"Portfolio Transfer":
 begin
     RecRef.SETTABLE(PortfolioTransfer);
     PortfolioTransfer.RESET;
     PortfolioTransfer.SETRANGE(Status, Status);
     if PortfolioTransfer.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(PortfolioTransfer."No.") OR CheckApproverApprovalEntryExist(PortfolioTransfer."No.") OR
                 CheckIfSubstituteApprover(PortfolioTransfer."Created By"))
             then
                 PortfolioTransfer.MARK(TRUE);
         UNTIL PortfolioTransfer.NEXT = 0;
    end;
     PortfolioTransfer.MARKEDONLY(TRUE);
     PortfolioTransfer.COPY(PortfolioTransfer);
     Variant := PortfolioTransfer;
end;
DATABASE::"Standing Order":
 begin
     RecRef.SETTABLE(StandingOrder);
     StandingOrder.RESET;
     StandingOrder.SETRANGE(Status, Status);
     if StandingOrder.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(StandingOrder."No.") OR CheckApproverApprovalEntryExist(StandingOrder."No.") OR
                CheckIfSubstituteApprover(StandingOrder."Created By"))
             then
                 StandingOrder.MARK(TRUE);
         UNTIL StandingOrder.NEXT = 0;
    end;
     StandingOrder.MARKEDONLY(TRUE);
     StandingOrder.COPY(StandingOrder);
     Variant := StandingOrder;
end;
DATABASE::"Guarantor Substitution Header":
 begin
     RecRef.SETTABLE(GuarantorSubstitutionHeader);
     GuarantorSubstitutionHeader.RESET;
     GuarantorSubstitutionHeader.SETRANGE(Status, Status);
     if GuarantorSubstitutionHeader.FINDSET then begin
         REPEAT
             if (CheckSenderApprovalEntryExist(GuarantorSubstitutionHeader."No.") OR CheckApproverApprovalEntryExist(GuarantorSubstitutionHeader."No.") OR
                 CheckIfSubstituteApprover(GuarantorSubstitutionHeader."Created By"))
             then
                 GuarantorSubstitutionHeader.MARK(TRUE);
         UNTIL GuarantorSubstitutionHeader.NEXT = 0;
    end;
     GuarantorSubstitutionHeader.MARKEDONLY(TRUE);
     GuarantorSubstitutionHeader.COPY(GuarantorSubstitutionHeader);
     Variant := GuarantorSubstitutionHeader;
end;
END;

end;

procedure CheckSenderApprovalEntryExist(DocumentNo: Code[20]): Boolean;
var
ApprovalEntry: Record "454";
UserSetup: Record "91";
begin
ApprovalEntry.RESET;
if UserSetup.GET(USERID) then begin
ApprovalEntry.SETRANGE("Sender ID", USERID);
ApprovalEntry.SETRANGE("Document No.", DocumentNo);
END;
EXIT(ApprovalEntry.FINDFIRST);
end;

procedure CheckApproverApprovalEntryExist(DocumentNo: Code[20]): Boolean;
var
ApprovalEntry: Record "454";
UserSetup: Record "91";
begin
ApprovalEntry.RESET;
if UserSetup.GET(USERID) then begin
if NOT UserSetup."Approval Administrator" then
 ApprovalEntry.SETRANGE("Approver ID", USERID)
END;
ApprovalEntry.SETRANGE("Document No.", DocumentNo);
EXIT(ApprovalEntry.FINDFIRST);
end;

local procedure CheckIfSubstituteApprover(SenderID: Code[20]): Boolean;
var
UserSetup: Record "91";
begin
UserSetup.RESET;
UserSetup.SETRANGE("User ID", SenderID);
UserSetup.SETRANGE(Substitute, USERID);
EXIT(UserSetup.FINDFIRST);
end;

[EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterGetDatabaseTableTriggerSetup', '', false, false)]
local procedure OnAfterGetDatabaseTableTriggerSetup(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabasemodify: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseRename: Boolean);
var
TableField: Record "52048";
begin
if COMPANYNAME = '' then
EXIT;

TableSetup.SETRANGE("Table No.", TableId);
if TableSetup.FINDFIRST then begin
OnDatabaseInsert := TRUE;
OnDatabasemodify := TRUE;
OnDatabaseDelete := TRUE;
OnDatabaseRename := TRUE;
END else begin
OnDatabaseInsert := FALSE;
OnDatabasemodify := FALSE;
OnDatabaseDelete := FALSE;
OnDatabaseRename := FALSE;
END;
end;

[EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterOnDatabaseDelete', '', false, false)]
local procedure OnAfterOnDatabaseDelete(RecRef: RecordRef);
var
TableField: Record "52048";
begin
if RecRef.ISTEMPORARY then
EXIT;

if TableSetup.GET(RecRef.NUMBER) then begin
if TableSetup."Activate Log" then begin
 TableField.RESET;
 TableField.SETRANGE("Table No.", TableSetup."Table No.");
 if TableField.FINDSET then begin
     REPEAT
         if NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") then
             ERROR(Error012);
         if TableField."On Delete" then
             CreateAuditLogEntry(2, RecRef, RecRef, TableField."Field No.");
     UNTIL TableField.NEXT = 0;
end;
END;
END;
end;

[EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterOnDatabaseInsert', '', false, false)]
local procedure OnAfterOnDatabaseInsert(RecRef: RecordRef);
var
FldRef: FieldRef;
TableField: Record "52048";
begin
if RecRef.ISTEMPORARY then
EXIT;

if TableSetup.GET(RecRef.NUMBER) then begin
if TableSetup."Activate Log" then begin
 TableField.RESET;
 TableField.SETRANGE("Table No.", TableSetup."Table No.");
 if TableField.FINDSET then begin
     REPEAT
         FldRef := RecRef.FIELD(TableField."Field No.");
         if FORMAT(FldRef.TYPE) <> 'Option' then begin
             if FORMAT(FldRef.VALUE) <> '' then begin
                 if NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") then
                     ERROR(Error011);
                 if TableField."On Insert" then
                     CreateAuditLogEntry(0, RecRef, RecRef, TableField."Field No.");
            end;
        end;
     UNTIL TableField.NEXT = 0;
end;
END;
END;
end;

[EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterOnDatabasemodify', '', false, false)]
local procedure OnAfterOnDatabasemodify(RecRef: RecordRef);
var
xRecRef: RecordRef;
FldRef: FieldRef;
xFldRef: FieldRef;
Text000: Label '%1 field cannot be modified directly.It requires approval';
TableField: Record "52048";
begin
if RecRef.ISTEMPORARY then
EXIT;

if NOT xRecRef.GET(RecRef.RECORDID) then
EXIT;

if TableSetup.GET(RecRef.NUMBER) then begin
if TableSetup."Activate Log" then begin
 TableField.RESET;
 TableField.SETRANGE("Table No.", TableSetup."Table No.");
 if TableField.FINDSET then begin
     REPEAT
         FldRef := RecRef.FIELD(TableField."Field No.");
         xFldRef := xRecRef.FIELD(TableField."Field No.");
         if FORMAT(FldRef.VALUE) <> FORMAT(xFldRef.VALUE) then begin
             if NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") then
                 ERROR(Error010, TableField."Field Name");
             if TableField."On modify" then
                 CreateAuditLogEntry(1, RecRef, xRecRef, TableField."Field No.");
        end;
     UNTIL TableField.NEXT = 0;
end;
END;
END;
end;

[EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterOnGlobalRename', '', false, false)]
local procedure OnAfterOnGlobalRename(RecRef: RecordRef; xRecRef: RecordRef);
var
FldRef: FieldRef;
xFldRef: FieldRef;
TableField: Record "52048";
begin
if RecRef.ISTEMPORARY then
EXIT;

if TableSetup.GET(RecRef.NUMBER) then begin
if TableSetup."Activate Log" then begin
 TableField.RESET;
 TableField.SETRANGE("Table No.", TableSetup."Table No.");
 if TableField.FINDSET then begin
     REPEAT
         FldRef := RecRef.FIELD(TableField."Field No.");
         xFldRef := xRecRef.FIELD(TableField."Field No.");
         if FORMAT(FldRef.VALUE) <> FORMAT(xFldRef.VALUE) then begin
             if NOT HasFieldAccess(RecRef.NUMBER, TableField."Field No.") then
                 ERROR(Error010, TableField."Field Name");
             CreateAuditLogEntry(1, RecRef, RecRef, TableField."Field No.");
        end;
     UNTIL TableField.NEXT = 0;
end;
END;
END;
end;

local procedure HasFieldAccess(TableNo: Integer; FieldNo: Integer): Boolean;
begin
FieldUserAccess.SETRANGE("Table No.", TableNo);
FieldUserAccess.SETRANGE("Field No.", FieldNo);
FieldUserAccess.SETRANGE("User ID", USERID);
FieldUserAccess.SETRANGE(Allow, TRUE);
EXIT(FieldUserAccess.FINDFIRST);
end;

local procedure CreateAuditLogEntry("Action": Integer; var RecRef: RecordRef; var XRecRef: RecordRef; FieldNo: Integer);
var
AuditLogEntry: Record "52045";
AuditLogEntry2: Record "52045";
EntryNo: Integer;
FldRef: FieldRef;
xFldRef: FieldRef;
"Field": Record "2000000041";
TableField: Record "52048";
begin
AuditLogEntry.INIT;
if AuditLogEntry2.FINDLAST then
EntryNo := AuditLogEntry2."Entry No."
else
EntryNo := 0;
AuditLogEntry."Entry No." := EntryNo + 1;
;
AuditLogEntry.Action := Action;
FldRef := RecRef.FIELD(FieldNo);
xFldRef := XRecRef.FIELD(FieldNo);
AuditLogEntry."Table ID" := RecRef.NUMBER;
AuditLogEntry."Table Name" := RecRef.NAME;
AuditLogEntry."Field No." := FldRef.NUMBER;
AuditLogEntry."Field Name" := FldRef.NAME;
AuditLogEntry."Old Value" := FORMAT(xFldRef.VALUE);
AuditLogEntry."New Value" := FORMAT(FldRef.VALUE);
AuditLogEntry."Record ID" := RecRef.RECORDID;
AuditLogEntry."Record ID Key" := FORMAT(RecRef.RECORDID);
AuditLogEntry."Action Date" := TODAY;
AuditLogEntry."Action Time" := TIME;
AuditLogEntry."User ID" := USERID;
AuditLogEntry.INSERT;
end;

procedure GetFileSize(FileName: Text[1024]) FileSize: Integer;
var
MyFile: File;
begin
begin
MyFile.OPEN(FileName);
FileSize := MyFile.LEN;
MyFile.CLOSE;
END;
EXIT(ROUND(FileSize / 1000, 1, '>'));
end;

procedure AddAttachment(RecordID: Text[50]; DocumentNo: Code[20]; FileName: Text[200]);
var
MCAttachment2: Record "52049";
MCAttachment: Record "52049";
EntryNo: Integer;
begin
MCAttachment.INIT;
if MCAttachment2.FINDLAST then
EntryNo := MCAttachment2."Entry No."
else
EntryNo := 0;
MCAttachment."Entry No." := EntryNo + 1;
MCAttachment.RecordID := RecordID;
MCAttachment."Document No." := DocumentNo;
MCAttachment."File Name" := FileName;
MCAttachment.Attachment.IMPORT(FileName);
MCAttachment.INSERT;
end;

local procedure GetCurrentLoanOfficer(MemberNo: Code[20]): Code[100];
var
MicroCreditMember: Record 50006;
begin
if MicroCreditMember.GET(MemberNo) then
EXIT(MicroCreditMember."Loan Officer ID");
end;*/

    procedure GetNextMeetingDate(GroupNo: Code[20]) NextMeetingDate: Date;
    var
        MicroCreditMember: Record 50006;
        MeetingDate: Date;
        Found: Boolean;
        DayofWeek: Text;
        WeekNo: Integer;
    begin
        if MicroCreditMember.GET(GroupNo) then begin
            MeetingDate := MicroCreditMember."Last Meeting Date";
            WHILE MeetingDate <= TODAY DO begin
                /*if MicroCreditMember."Group Meeting Week" <> 0 then begin
                    WeekNo := DATE2DWY(TODAY, 2);
                    DayofWeek := FORMAT(TODAY, 0, '<Weekday Text>');
                    if ((MicroCreditMember."Group Meeting Week" = WeekNo) AND (DayofWeek = FORMAT(MicroCreditMember."Group Meeting Day"))) then
                        MeetingDate := DMY2DATE(MicroCreditMember."Group Meeting Week", DATE2DMY(TODAY, 2), DATE2DMY(TODAY, 3))
                    else
                        MeetingDate := CALCDATE(MicroCreditMember."Group Meeting Frequency", MeetingDate);
               end else*/
                MeetingDate := CALCDATE(MicroCreditMember."Group Meeting Frequency", MeetingDate);
            end;
        end;
        NextMeetingDate := MeetingDate;
        EXIT(NextMeetingDate);
    end;

    procedure GetLastAttendanceDate(GroupNo: Code[20]): Date;
    var
        MCGroupAttendanceHeader: Record "Group Attendance Header";
    begin
        MCGroupAttendanceHeader.RESET;
        MCGroupAttendanceHeader.SETRANGE("Group No.", GroupNo);
        MCGroupAttendanceHeader.SETRANGE(Status, MCGroupAttendanceHeader.Status::Validated);
        if MCGroupAttendanceHeader.FINDLAST then begin
            EXIT(MCGroupAttendanceHeader."Actual Meeting Date");
        end else begin
            if MicroCreditMember.GET(GroupNo) then
                EXIT(MicroCreditMember."Last Meeting Date");
        end;
    end;
    /*
    procedure LoanCalculator(LoanCalculator: Record "52021");
    var
    NoOfInstallments: Integer;
    PrincipalAmount: Decimal;
    InterestAmount: Decimal;
    ApprovedLoanAmount: Decimal;
    ConstantAmount: Decimal;
    LastRepaymentDate: Date;
    LoanRepaymentSchedule: Record "50008";
    RepaymentDate: array[4] of Date;
    LoanCalculatorLine: Record "52030";
    begin
    WITH LoanCalculator DO begin
    i := 1;
    LastRepaymentDate := "Expectedend Date";
    RepaymentDate[1] := TODAY;
    NoOfInstallments := GetLoanCalculatorNoofInstallments(LoanCalculator);
    ApprovedLoanAmount := "Requested Amount";
    if "Repayment Method" = "Repayment Method"::"Straight Line" then begin
     PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
     InterestAmount := ApprovedLoanAmount * ("Interest Rate" / 12 * "Repayment Period" / 100);
     FOR i := 1 TO NoOfInstallments DO begin
         CreateLoanCalculatorLine(LoanCalculator, RepaymentDate[1], ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
         ApprovedLoanAmount -= PrincipalAmount;
         RepaymentDate[1] := CALCDATE(LoanCalculator."Group Meeting Frequency", RepaymentDate[1]);
    end;
   end;

    if "Repayment Method" = "Repayment Method"::"Reducing Balance" then begin
     PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
     FOR i := 1 TO NoOfInstallments DO begin
         InterestAmount := ApprovedLoanAmount * ("Interest Rate" / 12 * "Repayment Period" / 100);
         CreateLoanCalculatorLine(LoanCalculator, RepaymentDate[1], ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
         ApprovedLoanAmount -= PrincipalAmount;
         RepaymentDate[1] := CALCDATE("Group Meeting Frequency", RepaymentDate[1]);
    end;
   end;

    if "Repayment Method" = "Repayment Method"::Amortization then begin
     ConstantAmount := ApprovedLoanAmount *
                     (("Interest Rate" / NoOfInstallments / 100) *
                     (POWER(1 + ("Interest Rate" / NoOfInstallments / 100), NoOfInstallments))) /
                     (POWER(1 + ("Interest Rate" / NoOfInstallments) / 100, NoOfInstallments) - 1);
     FOR i := 1 TO NoOfInstallments DO begin
         InterestAmount := (ApprovedLoanAmount) * ("Interest Rate" / 12 * "Repayment Period" / 100);
         PrincipalAmount := ConstantAmount - InterestAmount;
         CreateLoanCalculatorLine(LoanCalculator, RepaymentDate[1], ApprovedLoanAmount, PrincipalAmount, InterestAmount, i);
         ApprovedLoanAmount -= PrincipalAmount;
         RepaymentDate[1] := CALCDATE("Group Meeting Frequency", RepaymentDate[1]);
    end;
   end;
   end;
   end;

    local procedure GetLoanCalculatorNoofInstallments(LoanCalculator: Record "52021"): Integer;
    var
    MCLoanApplication: Record "Loan Application";
    j: Integer;
    LastRepaymentDate: Date;
    begin
    WITH LoanCalculator DO begin
    j := 0;
    LastRepaymentDate := "Expectedend Date";
    RepaymentDate[1] := TODAY;
    WHILE RepaymentDate[1] <= LastRepaymentDate DO begin
     RepaymentDate[1] := CALCDATE("Group Meeting Frequency", RepaymentDate[1]);
     j += 1;
   end;
    EXIT(j - 1);
   end;
   end;

    local procedure CreateLoanCalculatorLine(LoanCalculator: Record "52021"; RepaymentDate: Date; LoanBalance: Decimal; PrincipalAmount: Decimal; InterestAmount: Decimal; InstallmentNo: Integer);
    var
    LoanCalculatorLine: Record "52030";
    LoanCalculatorLine2: Record "52030" temporary;
    ReqNo: Integer;
    LineNo: Integer;
    begin
    LoanCalculatorLine.INIT;
    LoanCalculatorLine."Request No." := LoanCalculator."No.";
    LoanCalculatorLine."Installment No." := InstallmentNo;
    LoanCalculatorLine."Repayment Date" := RepaymentDate;
    LoanCalculatorLine."Loan Amount" := LoanBalance;
    LoanCalculatorLine."Principal Installment" := PrincipalAmount;
    LoanCalculatorLine."Interest Installment" := InterestAmount;
    LoanCalculatorLine."Total Installment" := PrincipalAmount + InterestAmount;
    LoanCalculatorLine.INSERT;
   end;

    procedure CreateSMS(var RecRef: RecordRef; SequenceNo: Integer);
    var
    FldRef: FieldRef;
    FldRef2: FieldRef;
    MicroCreditMember: Record 50006;
    MicroCreditMember2: Record 50006;
    MCLoanApplication: Record "Loan Application";
    GroupMemberAllocation: Record "52017";
    LoanGuarantorLine: Record "52041";
    Vendor: Record "23";
    FundTransfer: Record "52040";
    StandingOrder: Record "52050";
    MCMemberApplication: Record 50000;
    LoanRescheduling: Record "52026";
    PortfolioTransfer: Record "52008";
    MemberExitHeader: Record "52028";
    LoanWriteOffHeader: Record "52037";
    GuarantorSubstitutionHeader: Record "52053";
    GuarantorSubstitutionLine: Record "52054";
    GuarantorSubstitutionAllocation: Record "52055";
    MemberRefundMembershipHeader: Record "52032";
    RefundAllocation: Record "52034";
    LoanOfficerSetup: Record "52001";
    LoanOfficerSetup2: Record "52001";
    MemberList: array[4] of Text[250];
    GLPhoneNo: array[4] of Code[20];
    LoanWriteOffLine: Record "52038";
    begin
    MicroCreditSetup.GET;
    CASE RecRef.NUMBER OF
    DATABASE::"MicroCredit Member":
     begin
         RecRef.SETTABLE(MicroCreditMember);
         FldRef := RecRef.FIELD(1);
         if MicroCreditSetup."Notify on Member Application" then begin
             if MicroCreditMember.Category = MicroCreditMember.Category::Client then begin
                 if MicroCreditMember2.GET(MicroCreditMember."Group Link No.") then;
                 AddSMS(MicroCreditMember."Phone No.", ('Ýou have been registered successfully to group ' + MicroCreditMember2."Group Name" +
                        '.Your Membership No. is ' + MicroCreditMember."No."), 'MEMBERAPPLICATION');
            end;

             if MicroCreditMember.Category = MicroCreditMember.Category::Group then begin
                 GLPhoneNo[1] := GetGroupLeaderPhoneNo(MicroCreditMember."Application No.", 0);
                 AddSMS(GLPhoneNo[1], ('Group ' + MicroCreditMember."Group Name" + ' has been registered successfuly.The Group No. is ' + MicroCreditMember."No."), 'MEMBERAPPLICATION');
            end;
        end;
    end;
    DATABASE::"Member Exit Header":
     begin
         RecRef.SETTABLE(MemberExitHeader);
         FldRef := RecRef.FIELD(2);
         if MicroCreditSetup."Notify on Exit from Group" then begin
             if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
                 AddSMS(MicroCreditMember."Phone No.", 'You have successfully exited from Group ' + MemberExitHeader."Group Name", 'MEMBEREXIT');
            end;

             GLPhoneNo[1] := GetGroupLeaderPhoneNo(MicroCreditMember."Group Link No.", 1);
             if GLPhoneNo[1] <> '' then begin
                 AddSMS(GLPhoneNo[1], 'Member No. ' + MemberExitHeader."Member No." + '-' + MemberExitHeader."Member Name" + ' has successfully exited from Group ' + MemberExitHeader."Group Name", 'MEMBEREXIT');
            end;
        end;
    end;
    DATABASE::"Member Refund/Mem. Header":
     begin
         RecRef.SETTABLE(MemberRefundMembershipHeader);
         FldRef := RecRef.FIELD(2);
         if MemberRefundMembershipHeader."Action Type" = MemberRefundMembershipHeader."Action Type"::Refund then begin
             if MicroCreditSetup."Notify on Exit Refund" then begin
                 //Notify Member
                 if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
                     AddSMS(MicroCreditMember."Phone No.", 'Your Refund request ' + MemberRefundMembershipHeader."No." + ' has been processed successfully', 'EXITREFUND');
                end;

                 //Notify Beneciaries
                 RefundAllocation.RESET;
                 RefundAllocation.SETRANGE("Document No.", MemberRefundMembershipHeader."No.");
                 if RefundAllocation.FINDSET then begin
                     REPEAT
                         if MicroCreditMember.GET(RefundAllocation."Member No.") then;
                         AddSMS(MicroCreditMember."Phone No.", 'Refund request ' + MemberRefundMembershipHeader."No." + ' for Member No. ' + FORMAT(FldRef.VALUE) + '-' +
                               MemberRefundMembershipHeader."Member Name" + ' has been processed successfully', 'EXITREFUND');
                     UNTIL RefundAllocation.NEXT = 0;
                end;
            end;
        end;
         if MemberRefundMembershipHeader."Action Type" = MemberRefundMembershipHeader."Action Type"::Membership then begin
             if MicroCreditSetup."Notify on Exit Membership" then begin
                 if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
                     AddSMS(MicroCreditMember."Phone No.", 'Your Membership request ' + MemberRefundMembershipHeader."No." + ' has been processed successfully', 'EXITMEMBERSHIP');
                end;
            end;
        end;
    end;
    DATABASE::"Group Member Allocation":
     begin
         RecRef.SETTABLE(GroupMemberAllocation);
         FldRef := RecRef.FIELD(4);
         if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
             if MicroCreditSetup."Notify on Group Allocation" then begin
                 AddSMS(MicroCreditMember."Phone No.", ('Amount of KES ' + FORMAT(GroupMemberAllocation."Allocation Amount") + ' has been credited to your account (' + GroupMemberAllocation."Account No." + '-' +
                        GroupMemberAllocation."Account Name" + ')'), 'GROUPALLOCATION');
            end;
        end;
    end;
    DATABASE::"MC Loan Application":
     begin
         RecRef.SETTABLE(MCLoanApplication);
         FldRef := RecRef.FIELD(23);
         if SequenceNo = 1 then begin
             if MicroCreditSetup."Notify on Loan Disbursal" then begin
                 if Vendor.GET(GetSavingsAccount(MCLoanApplication."Member No.")) then;
                 MicroCreditMember.RESET;
                 if MicroCreditMember.GET(MCLoanApplication."Member No.") then begin
                     AddSMS(MicroCreditMember."Phone No.", ('Loan Amount of KES ' + FORMAT(MCLoanApplication."Approved Amount") + ' has been credited to your account (' +
                            GetSavingsAccount(MCLoanApplication."Member No.") + '-' + Vendor.Name + ')'), 'LOANAPPLICATION');
                end;
            end;

             GLPhoneNo[1] := GetGroupLeaderPhoneNo(FORMAT(FldRef.VALUE), 1);
             if GLPhoneNo[1] <> '' then begin
                 AddSMS(GLPhoneNo[1], ('Loan Amount of KES ' + FORMAT(MCLoanApplication."Approved Amount") + ' has been disbursed to ' + MCLoanApplication."Member Name" + ' (' +
                        MCLoanApplication."No." + '-' + MCLoanApplication.Description + ')'), 'LOANAPPLICATION');
            end;
        end;
         if SequenceNo = 2 then
             EXIT;
    end;
    DATABASE::"Fund Transfer":
     begin
         RecRef.SETTABLE(FundTransfer);
         FldRef := RecRef.FIELD(2);

         if MicroCreditSetup."Notify on Fund Transfer" then begin
             if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
                 AddSMS(MicroCreditMember."Phone No.", ('Amount of KES ' + FORMAT(FundTransfer."Amount to Transfer") + ' has been debited from your account (' + FundTransfer."Source Account No." + '-' +
                         FundTransfer."Source Account Name" + ')'), 'FUNDTRANSFER');
            end;

             LoanGuarantorLine.RESET;
             LoanGuarantorLine.SETRANGE("Document No.", FundTransfer."No.");
             if LoanGuarantorLine.FINDSET then begin
                 REPEAT
                     FldRef2 := RecRef.FIELD(2);
                     if MicroCreditMember.GET(FORMAT(FldRef2.VALUE)) then begin
                         AddSMS(MicroCreditMember."Phone No.", ('Amount of KES ' + FORMAT(LoanGuarantorLine."Amount to Recover") + ' will be recovered from your account (' + LoanGuarantorLine."Account No." + '-' +
                                 LoanGuarantorLine."Account Name" + ')'), 'FUNDTRANSFER');
                    end;
                 UNTIL LoanGuarantorLine.NEXT = 0;
            end;
        end;
    end;
    DATABASE::"Standing Order":
     begin
         RecRef.SETTABLE(StandingOrder);
         FldRef := RecRef.FIELD(3);
         if MicroCreditSetup."Notify on Standing Order" then begin
             if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
                 AddSMS(MicroCreditMember."Phone No.", ('Amount of KES ' + FORMAT(StandingOrder."Amount to Deduct") + ' has been debited from your account (' + StandingOrder."Source Account No." + '-' +
                        StandingOrder."Source Account Name" + ')'), 'STANDINGORDER');
            end;
        end;
    end;
    DATABASE::"Loan Rescheduling":
     begin
         RecRef.SETTABLE(LoanRescheduling);
         FldRef := RecRef.FIELD(2);
         if MicroCreditSetup."Notify on Loan Rescheduling" then begin
             if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then begin
                 AddSMS(MicroCreditMember."Phone No.", ('Your Loan No. ' + LoanRescheduling."Loan No." + '-' + LoanRescheduling.Description + ' has been rescheduled to ' + FORMAT(LoanRescheduling."New Repayment Period") + ' months'), 'LOANRESCHEDULING');
            end;
        end;
    end;
    DATABASE::"Guarantor Substitution Header":
     begin
         RecRef.SETTABLE(GuarantorSubstitutionHeader);
         FldRef := RecRef.FIELD(3);
         if MicroCreditMember.GET(FORMAT(FldRef.VALUE)) then;
         if MicroCreditSetup."Notify on Guar. Substitution" then begin
             GuarantorSubstitutionLine.RESET;
             GuarantorSubstitutionLine.SETRANGE("Document No.", GuarantorSubstitutionHeader."No.");
             GuarantorSubstitutionLine.SETRANGE(Substitute, TRUE);
             if GuarantorSubstitutionLine.FINDSET then begin
                 REPEAT
                     GuarantorSubstitutionAllocation.RESET;
                     GuarantorSubstitutionAllocation.SETRANGE("Document No.", GuarantorSubstitutionLine."Document No.");
                     GuarantorSubstitutionAllocation.SETRANGE("Guarantor Member No.", GuarantorSubstitutionLine."Member No.");
                     if GuarantorSubstitutionAllocation.FINDSET then begin
                         REPEAT
                             MemberList[1] += GuarantorSubstitutionAllocation."Member Name" + '|';
                         UNTIL GuarantorSubstitutionAllocation.NEXT = 0;
                    end;
                     EVALUATE(MemberList[2], COPYSTR(MemberList[1], 1, STRLEN(MemberList[1]) - 1));
                     if MicroCreditMember2.GET(FORMAT(GuarantorSubstitutionLine."Member No.")) then begin
                         AddSMS(MicroCreditMember."Phone No.", ('Guarantor ' + GuarantorSubstitutionLine."Member Name" + ' for Loan ' + GuarantorSubstitutionHeader."Loan No." + '-' +
                         GuarantorSubstitutionHeader.Description + ' has been substituted by ' + MemberList[2]), 'GUARANTORSUBSTITUTION');
                    end;
                 UNTIL GuarantorSubstitutionLine.NEXT = 0;
            end;
        end;
    end;
    DATABASE::"Portfolio Transfer":
     begin
         RecRef.SETTABLE(PortfolioTransfer);
         //FldRef := RecRef.FIELD(2);
         if LoanOfficerSetup.GET(PortfolioTransfer."Source Loan Officer ID") then;
         if LoanOfficerSetup2.GET(PortfolioTransfer."Destination Loan Officer ID") then;

         if MicroCreditSetup."Notify on Fund Transfer" then begin
             if PortfolioTransfer."Transfer Type" = PortfolioTransfer."Transfer Type"::"Client Transfer" then begin
                 if PortfolioTransfer.Category = PortfolioTransfer.Category::"Intra-branch" then begin
                     //Notify Member
                     if MicroCreditMember.GET(PortfolioTransfer."Member No.") then begin
                         AddSMS(MicroCreditMember."Phone No.", 'You have been successfully transferred to Group ' + PortfolioTransfer."Destination Group Name" +
                                 ' belonging to Loan Officer ID ' + PortfolioTransfer."Destination Loan Officer ID", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Source Group Leader
                     GLPhoneNo[1] := GetGroupLeaderPhoneNo(PortfolioTransfer."Source Group No.", 1);
                     if GLPhoneNo[1] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                                PortfolioTransfer."Destination Group Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Destination Group Leader
                     GLPhoneNo[2] := GetGroupLeaderPhoneNo(PortfolioTransfer."Destination Group No.", 1);
                     if GLPhoneNo[2] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                                PortfolioTransfer."Destination Group Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Source Loan Officer ID
                     AddSMS(LoanOfficerSetup."Phone No.", 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                            PortfolioTransfer."Destination Group Name", 'PORTFOLIOTRANSFER');
                     //Notify Destination Loan Officer ID
                     AddSMS(LoanOfficerSetup2."Phone No.", 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                            PortfolioTransfer."Destination Group Name", 'PORTFOLIOTRANSFER');
                end;
                 if PortfolioTransfer.Category = PortfolioTransfer.Category::"Inter-branch" then begin
                     //Notify Member
                     if MicroCreditMember.GET(PortfolioTransfer."Member No.") then begin
                         AddSMS(MicroCreditMember."Phone No.", 'You have been successfully transferred to Group ' + PortfolioTransfer."Destination Group Name" +
                                 ' belonging to Loan Officer ID ' + PortfolioTransfer."Destination Loan Officer ID" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Source Group Leader
                     GLPhoneNo[1] := GetGroupLeaderPhoneNo(PortfolioTransfer."Source Group No.", 1);
                     if GLPhoneNo[1] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                                PortfolioTransfer."Destination Group Name" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Destination Group Leader
                     GLPhoneNo[2] := GetGroupLeaderPhoneNo(PortfolioTransfer."Destination Group No.", 1);
                     if GLPhoneNo[2] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                                PortfolioTransfer."Destination Group Name" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Source Loan Officer ID
                     AddSMS(LoanOfficerSetup."Phone No.", 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                            PortfolioTransfer."Destination Group Name" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                     //Notify Destination Loan Officer ID
                     AddSMS(LoanOfficerSetup2."Phone No.", 'Member No. ' + PortfolioTransfer."Member No." + '-' + PortfolioTransfer."Member Name" + ' has successfully been transferred to Group ' +
                            PortfolioTransfer."Destination Group Name" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                end;
            end;
             if PortfolioTransfer."Transfer Type" = PortfolioTransfer."Transfer Type"::"Group Transfer" then begin
                 if PortfolioTransfer.Category = PortfolioTransfer.Category::"Intra-branch" then begin
                     //Notify Source Group Leader
                     GLPhoneNo[1] := GetGroupLeaderPhoneNo(PortfolioTransfer."Source Group No.", 1);
                     if GLPhoneNo[1] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to Loan Officer ID ' +
                                PortfolioTransfer."Destination Loan Officer ID", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Destination Group Leader
                     GLPhoneNo[2] := GetGroupLeaderPhoneNo(PortfolioTransfer."Destination Group No.", 1);
                     if GLPhoneNo[2] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to Loan Officer ID ' +
                                PortfolioTransfer."Destination Loan Officer ID", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Source Loan Officer ID
                     AddSMS(LoanOfficerSetup."Phone No.", 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to Loan Officer ID ' +
                            PortfolioTransfer."Destination Loan Officer ID", 'PORTFOLIOTRANSFER');

                     //Notify Destination Loan Officer ID
                     AddSMS(LoanOfficerSetup2."Phone No.", 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to you'
                            , 'PORTFOLIOTRANSFER');
                end;
                 if PortfolioTransfer.Category = PortfolioTransfer.Category::"Inter-branch" then begin
                     //Notify Source Group Leader
                     GLPhoneNo[1] := GetGroupLeaderPhoneNo(PortfolioTransfer."Source Group No.", 1);
                     if GLPhoneNo[1] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to Loan Officer ID ' +
                                PortfolioTransfer."Destination Loan Officer ID" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Destination Group Leader
                     GLPhoneNo[2] := GetGroupLeaderPhoneNo(PortfolioTransfer."Destination Group No.", 1);
                     if GLPhoneNo[2] <> '' then begin
                         AddSMS(GLPhoneNo[1], 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to Loan Officer ID ' +
                                PortfolioTransfer."Destination Loan Officer ID" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                    end;

                     //Notify Source Loan Officer ID
                     AddSMS(LoanOfficerSetup."Phone No.", 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to Loan Officer ID ' +
                            PortfolioTransfer."Destination Loan Officer ID" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');

                     //Notify Destination Loan Officer ID
                     AddSMS(LoanOfficerSetup2."Phone No.", 'Group No. ' + PortfolioTransfer."Source Group No." + '-' + PortfolioTransfer."Source Group Name" + ' has successfully been transferred to you'
                            , 'PORTFOLIOTRANSFER');
                end;
            end;
             if PortfolioTransfer."Transfer Type" = PortfolioTransfer."Transfer Type"::"Loan Officer Transfer" then begin
                 if PortfolioTransfer.Category = PortfolioTransfer.Category::"Intra-branch" then begin
                     AddSMS(LoanOfficerSetup."Phone No.", 'You have been successfully transferred to Group ' + PortfolioTransfer."Destination Group Name", 'PORTFOLIOTRANSFER');
                     AddSMS(LoanOfficerSetup2."Phone No.", 'Portfolio belonging to ' + PortfolioTransfer."Source Loan Officer ID" + ' have been handed over to you', 'PORTFOLIOTRANSFER');
                end;
                 if PortfolioTransfer.Category = PortfolioTransfer.Category::"Inter-branch" then begin
                     AddSMS(LoanOfficerSetup."Phone No.", 'You have been successfully transferred to Group ' + PortfolioTransfer."Destination Group Name" + ' in Branch ' + PortfolioTransfer."Destination Branch Name", 'PORTFOLIOTRANSFER');
                     AddSMS(LoanOfficerSetup2."Phone No.", 'Portfolio belonging to ' + PortfolioTransfer."Source Loan Officer ID" + ' have been handed over to you', 'PORTFOLIOTRANSFER');
                end;

                 //Notify Group Leaders
                 MicroCreditMember.RESET;
                 MicroCreditMember.SETRANGE(Category, MicroCreditMember.Category::Group);
                 MicroCreditMember.SETRANGE("Loan Officer ID", PortfolioTransfer."Source Loan Officer ID");
                 if MicroCreditMember.FINDSET then begin
                     REPEAT
                         GLPhoneNo[1] := GetGroupLeaderPhoneNo(MicroCreditMember."No.", 1);
                         if GLPhoneNo[1] <> '' then begin
                             AddSMS(GLPhoneNo[1], 'Your new Loan Officer is ' + PortfolioTransfer."Destination Loan Officer ID", 'PORTFOLIOTRANSFER');
                        end;
                     UNTIL MicroCreditMember.NEXT = 0;
                end;

                 if MicroCreditMember.GET(PortfolioTransfer."Destination Group No.") then begin
                     GLPhoneNo[2] := GetGroupLeaderPhoneNo(MicroCreditMember."No.", 1);
                     if GLPhoneNo[2] <> '' then begin
                         AddSMS(GLPhoneNo[2], 'Your new Loan Officer is ' + PortfolioTransfer."Source Loan Officer ID", 'PORTFOLIOTRANSFER');
                    end;
                end;
            end;
        end;
    end;
    DATABASE::"Loan WriteOff Header":
     begin
         RecRef.SETTABLE(LoanWriteOffHeader);
         FldRef := RecRef.FIELD(1);
         if MicroCreditSetup."Notify on Loan WriteOff" then begin
             LoanWriteOffLine.RESET;
             LoanWriteOffLine.SETRANGE("Document No.", FORMAT(FldRef.VALUE));
             if LoanWriteOffLine.FINDSET then begin
                 REPEAT
                     if MicroCreditMember.GET(LoanWriteOffLine."Member No.") then;
                     AddSMS(MicroCreditMember."Phone No.", 'Your Loan No. ' + LoanWriteOffLine."Loan No." + '-' + LoanWriteOffLine.Description + ' of KES ' +
                            FORMAT(LoanWriteOffLine."Defaulted Amount") + ' has been written off', 'LOANWRITEOFF');
                 UNTIL LoanWriteOffLine.NEXT = 0;
            end;
        end;
    end;
   end;
   end;

    procedure AddSMS(PhoneNo: Code[20]; MessageText: Text[250]; SourceCode: Code[30]);
    var
    SmsProcessing: Record "50143";
    begin
    SmsProcessing.INIT;
    SmsProcessing."Phone No" := PhoneNo;
    SmsProcessing.Message := MessageText;
    SmsProcessing."Created Date" := TODAY;
    SmsProcessing."Created Time" := TIME;
    SmsProcessing."Source Code" := SourceCode;
    SmsProcessing.INSERT;
   end;

    local procedure GetGroupLeaderPhoneNo(GroupLinkNo: Code[20]; Source: Integer): Code[20];
    var
    MCMemberApplication: Record 50000;
    MicroCreditMember: Record 50006;
    begin
    CASE Source OF
    0:
     begin
         MCMemberApplication.RESET;
         MCMemberApplication.SETRANGE("Group Link No.", GroupLinkNo);
         MCMemberApplication.SETRANGE("Is Group Official", TRUE);
         MCMemberApplication.SETRANGE("Group Official Position", MicroCreditMember."Group Official Position"::"Chair Person");
         if MCMemberApplication.FINDFIRST then
             EXIT(MCMemberApplication."Phone No.")
    end;
    1:
     begin
         MicroCreditMember.RESET;
         MicroCreditMember.SETRANGE("Group Link No.", GroupLinkNo);
         MicroCreditMember.SETRANGE("Is Group Official", TRUE);
         MicroCreditMember.SETRANGE("Group Official Position", MicroCreditMember."Group Official Position"::"Chair Person");
         if MicroCreditMember.FINDFIRST then
             EXIT(MicroCreditMember."Phone No.")
    end;
   end;
   end;*/

    local procedure ValidateDocumentNo(DocumentNo: Code[20]);
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Document No.", DocumentNo);
        if VendorLedgerEntry.FINDFIRST then
            ERROR(Text015, DocumentNo);
    end;
    /*
    procedure ValidateApprovalEntries(DocumentNo: Code[20]; ApproverID: Code[50]);
    var
    ApprovalEntry: Record "454";
    begin
    ApprovalEntry.RESET;
    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
    //ApprovalEntry.SETRANGE("Approver ID",ApproverID);
    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
    if ApprovalEntry.FINDFIRST then begin
    ApprovalEntry.Status := ApprovalEntry.Status::Open;
    ApprovalEntry.modify;
   end;
   end;

    procedure GetPrincipalOverpaymentAmount(LoanNo: Code[20]): Decimal;
    var
    VendorLedgerEntry: Record 25;
    LoanRepaymentSchedule: Record "50008";
    Amount: array[4] of Decimal;
    begin
    LoanRepaymentSchedule.RESET;
    LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
    LoanRepaymentSchedule.SETFILTER("Repayment Date", '<=%1', TODAY);
    if LoanRepaymentSchedule.FINDSET then begin
    REPEAT
     Amount[1] += LoanRepaymentSchedule."Principal Repayment";
    UNTIL LoanRepaymentSchedule.NEXT = 0;
   end;

    VendorLedgerEntry.RESET;
    VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
    VendorLedgerEntry.SETRANGE(Reversed, FALSE);
    VendorLedgerEntry.SETRANGE("Transaction Type", VendorLedgerEntry."Transaction Type"::Repayment);
    if VendorLedgerEntry.FINDSET then begin
    REPEAT
     VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
     Amount[2] += ABS(VendorLedgerEntry.Amount);
    UNTIL VendorLedgerEntry.NEXT = 0;
   end;
    if Amount[2] > Amount[1] then
    EXIT(Amount[2] - Amount[1])
    else
    EXIT(0);
   end;

    procedure GetInterestOverpaymentAmount(LoanNo: Code[20]): Decimal;
    var
    VendorLedgerEntry: Record 25;
    LoanRepaymentSchedule: Record "50008";
    Amount: array[4] of Decimal;
    begin
    LoanRepaymentSchedule.RESET;
    LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
    LoanRepaymentSchedule.SETFILTER("Repayment Date", '<=%1', TODAY);
    if LoanRepaymentSchedule.FINDSET then begin
    REPEAT
     Amount[1] += LoanRepaymentSchedule."Monthly Interest";
    UNTIL LoanRepaymentSchedule.NEXT = 0;
   end;

    VendorLedgerEntry.RESET;
    VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
    VendorLedgerEntry.SETRANGE(Reversed, FALSE);
    VendorLedgerEntry.SETRANGE("Transaction Type", VendorLedgerEntry."Transaction Type"::"Interest Paid");
    if VendorLedgerEntry.FINDSET then begin
    REPEAT
     VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
     Amount[2] += ABS(VendorLedgerEntry.Amount);
    UNTIL VendorLedgerEntry.NEXT = 0;
   end;
    if Amount[2] > Amount[1] then
    EXIT(Amount[2] - Amount[1])
    else
    EXIT(0);
   end;

    procedure RecoverLoanOverPayment(var MCLoanClassificationEntry: Record "52012");
    var
    GenJournalLine: Record "81";
    AmountToBeRecovered: Decimal;
    Text000: Label 'Recovery of Overpayment Amount';
    begin
    WITH MCLoanClassificationEntry DO begin
    AmountToBeRecovered := 0;
    if "Total Arrears" > "Prepayment Amount" then begin
     AmountToBeRecovered := "Prepayment Amount";
   end else begin
     AmountToBeRecovered := "Total Arrears";
   end;
    MicroCreditSetup.GET;
    ClearJournal(MicroCreditSetup."Loan Recovery Template Name", MicroCreditSetup."Loan Recovery Batch Name");
    if "Principal In Arrears" = 0 then begin
     GlobalManagement.CreateJournal(MicroCreditSetup."Loan Recovery Template Name", MicroCreditSetup."Loan Recovery Batch Name", "Loan No.", "Loan No.", TODAY, GenJournalLine."Account Type"::Vendor,
                "Loan No.", Text000, AmountToBeRecovered, GenJournalLine."Transaction Type"::Repayment, "Global Dimension 1 Code",0,'');
   end;
    if "Interest in Arrears" = 0 then begin
     GlobalManagement.CreateJournal(MicroCreditSetup."Loan Recovery Template Name", MicroCreditSetup."Loan Recovery Batch Name", "Loan No.", "Loan No.", TODAY, GenJournalLine."Account Type"::Vendor,
                "Loan No.", Text000, AmountToBeRecovered, GenJournalLine."Transaction Type"::"Interest Paid", "Global Dimension 1 Code",0,'');
   end;
    GlobalManagement.CreateJournal(MicroCreditSetup."Loan Recovery Template Name", MicroCreditSetup."Loan Recovery Batch Name", "Loan No.", "Loan No.", TODAY, GenJournalLine."Account Type"::Vendor,
               GetSavingsAccount("Member No."), Text000, -AmountToBeRecovered, GenJournalLine."Transaction Type"::Repayment, "Global Dimension 1 Code",0,'');
   end;
   end;

    procedure UpdateArrears("LoanNo.": Code[20]);
    var
    IArrears: array[2] of Decimal;
    PArrears: array[2] of Decimal;
    LoanAccount: Record "23";
    ArrearsOPCalculation: Report "55014";
    begin
    if LoanAccount.GET("LoanNo.") then begin
    if CalculateLoanArrearsAndOverpayment(LoanAccount."No.", TODAY, 'P') > 0 then
     IArrears[1] := CalculateLoanArrearsAndOverpayment(LoanAccount."No.", TODAY, 'P')
    else
     IArrears[2] := ABS(CalculateLoanArrearsAndOverpayment(LoanAccount."No.", TODAY, 'P'));

    if CalculateLoanArrearsAndOverpayment(LoanAccount."No.", TODAY, 'I') > 0 then
     PArrears[1] := CalculateLoanArrearsAndOverpayment(LoanAccount."No.", TODAY, 'I')
    else
     PArrears[2] := ABS(CalculateLoanArrearsAndOverpayment(LoanAccount."No.", TODAY, 'I'));

    LoanAccount."Loan Arrears" := ROUND(IArrears[1] + PArrears[1], 0.1, '<');
    LoanAccount."Overpayment Amount" := ROUND(IArrears[2] + PArrears[2], 0.1, '<');
    LoanAccount.modify;
   end;
   end;

    procedure ApproveChangeRequest(var MCChangeRequest: Record "52070");
    var
    MCLoanApplication: Record "Loan Application";
    begin
    WITH MCChangeRequest DO begin
    if MicroCreditMember.GET("Member No."); begin
     if "New Group Name" <> '' then
         MicroCreditMember."Group Name" := "New Group Name";
     MicroCreditMember."Group Meeting Day" := "New Group Meeting Day";
     if "New Group Meeting Frequency Op" <> "New Group Meeting Frequency Op"::" " then
         MicroCreditMember.VALIDATE("Group Meeting Frequency Option", "New Group Meeting Frequency Op");
     if "New Group Meeting Venue" <> '' then
         MicroCreditMember."Group Meeting Venue" := "New Group Meeting Venue";
     if "New Last Meeting Date" <> 0D then begin
         MicroCreditMember."Last Meeting Date" := "New Last Meeting Date";

         MCLoanApplication.RESET;
         MCLoanApplication.SETRANGE("Group No.", "Member No.");
         if MCLoanApplication.FINDSET then begin
             REPEAT

             UNTIL MCLoanApplication.NEXT = 0;
        end;

    end;
     MicroCreditMember.modify;
   end;
   end;
   end;*/
    procedure AddCollectionEntry(TransactionNo: Code[20]; TransactionDate: Date; TransactionTime: Time; Description: Text[50]; GroupPaybillCode: Code[20]; PhoneNo: Code[20]; SenderName: Text[50]; AmountDeposited: Decimal; SourceCode: Code[20]; DebitAccountCode: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: Text);
    var
        GroupCollectionEntry: record "Group Collection Entry";
    begin
        CLEAR(ResponseCode);
        CLEAR(ResponseMessage);
        CLEARLASTERROR;
        MicroCreditSetup.GET;
        GroupCollectionEntry.INIT;
        GroupCollectionEntry."Transaction No." := TransactionNo;
        GroupCollectionEntry."External Document No." := TransactionNo;
        GroupCollectionEntry."Transaction Date" := TransactionDate;
        GroupCollectionEntry."Transaction Time" := TransactionTime;
        GroupCollectionEntry.Description := Description;
        GroupCollectionEntry.VALIDATE("Phone No.", PhoneNo);
        GroupCollectionEntry.VALIDATE("Group Paybill Code", GroupPaybillCode);
        GroupCollectionEntry."Sender Name" := SenderName;
        GroupCollectionEntry."Deposited Amount" := AmountDeposited;
        GroupCollectionEntry."Remaining Amount" := AmountDeposited;
        GroupCollectionEntry."Source Code" := SourceCode;
        if SourceCode = 'Mobile Banking' then
            GroupCollectionEntry."Debit Account Code" := MicroCreditSetup."Group Collection Control A/c"
        else
            GroupCollectionEntry."Debit Account Code" := DebitAccountCode;
        if GroupCollectionEntry.INSERT then begin
            if SourceCode = 'Mobile Banking' then begin
                if PostGroupCollectionEntry(GroupCollectionEntry) then begin
                    ResponseCode := '00';
                    ResponseMessage := 'Success';
                    GroupCollectionEntry."Posting Status" := GroupCollectionEntry."Posting Status"::Success;
                    GroupCollectionEntry."Posting Message" := 'Success';
                    GroupCollectionEntry.modify;
                end else begin
                    ResponseCode := '01';
                    ResponseMessage := COPYSTR(GETLASTERRORTEXT, 1, 100);
                    ERROR(GETLASTERRORTEXT);
                    GroupCollectionEntry."Posting Status" := GroupCollectionEntry."Posting Status"::Fail;
                    GroupCollectionEntry."Posting Message" := COPYSTR(GETLASTERRORTEXT, 1, 100);
                    GroupCollectionEntry.modify;
                end;
            end;
        end;
    end;
}