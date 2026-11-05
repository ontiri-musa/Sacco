codeunit 50139 "Junior To  Adult"
{
    trigger OnRun()
    Begin
        /* Member.Get();

         Member.Reset();
         Member.SetRange("Age Classification", Member."Age Classification"::Junior);
         if Member.FindSet() then begin
             repeat
                 if Member."Date of Birth" <> 0D then
                     Age := Today - Member."Date of Birth";
                 if Age >= 6570 then begin
                     //.........................................................................
                     with MemberApplication do begin
                         if MicrocreditSetup.GET then;
                         MemberApplicationSetup.Get();
                         If MemberApplicationSetup."Member No. Format" = MemberApplicationSetup."Member No. Format"::"No. Series Only" then
                             MemberNo := NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);
                         If MemberApplicationSetup."Member No. Format" = MemberApplicationSetup."Member No. Format"::"Branch Code+No. Series" then
                             MemberNo := "Global Dimension 1 Code" + NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);

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
                          Member."Signature Path" := GlobalSetup."Image Path IP Address" + MemberNo + 'SIG.jpg'; 

                         Member."Application No." := MemberApplication."No.";
                         Member."Approval Date" := Today;
                         Member."Approved Time" := Time;
                         Member."Approved By" := UserId;
                         Member.Status := Member.Status::Active;
                         If Member.INSERT then
                             CreateDefaultAccount(Member);

                         RecRef.GetTable(Member);
                         // SendNotification(RecRef);

                         // CapitalizeRegistrationFee(Member);
                     end;
                 end;
             //.........................................................................

             until Member.Next = 0;

         end;*/
        /* member.SetFilter(Category, '%1', member.Category::Junior);

         if Member.FindSet() then begin
             repeat
                 MemberApplicationSetup.Get();
                 if Today - Member."Date of Birth" >= 6570 then
                     MemberNo := NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);
                 Member."Junior Account Number" := Member."No.";
                 Member."No." := MemberNo;
                 Member.Modify();
                 Commit();
                 vendor.SetRange("Member No.", Member."Junior Account Number");
                 if vendor.FindSet() then begin
                     repeat
                         case vendor."Account Type" of

                             '01':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + '01';
                                     vendor.Modify();
                                 end;
                             '02':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + '02';
                                     vendor.Modify();
                                 end;
                             '03':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + '03';
                                     vendor.Modify();
                                 end;
                             '04':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + '04';
                                     vendor.Modify();
                                 end;
                             '05':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + '05';
                                     vendor.Modify();
                                 end;
                             '06':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + '06';
                                     vendor.Modify();
                                 end;
                             'BM':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + 'BM';
                                     vendor.Modify();
                                 end;
                             'CD':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + 'CD';
                                     vendor.Modify();
                                 end;
                             'FD':
                                 begin
                                     vendor."Old Vendor No.s" := vendor."No.";
                                     vendor."No." := MemberNo + 'FD';
                                     vendor.Modify();
                                 end;

                         end;
                         Commit();
                         vendor."Member No." := MemberNo;
                         vendor.Modify();
                         Commit();
                         vendorLedgerEntry.Reset();
                         vendorLedgerEntry.SetRange("Vendor No.", vendor."Old Vendor No.s");
                         if vendorLedgerEntry.FindSet() then begin
                             repeat
                                 vendorLedgerEntry."Vendor No." := vendor."No.";
                                 vendorLedgerEntry.Modify();
                             until vendorLedgerEntry.Next() = 0;
                         end;
                         Commit();
                         DetailedVendorLedgerEntry.Reset();
                         DetailedVendorLedgerEntry.SetRange("Vendor No.", vendor."Old Vendor No.s");
                         if DetailedVendorLedgerEntry.FindSet() then begin
                             repeat
                                 DetailedVendorLedgerEntry."Vendor No." := vendor."No.";
                                 DetailedVendorLedgerEntry.Modify();
                             until DetailedVendorLedgerEntry.Next() = 0;

                         end;

                     until vendor.Next() = 0;
                 end;




             until member.Next() = 0;
         end;*/
        member.SetFilter(Category, '%1', member.Category::Junior);

        if Member.FindSet() then begin
            repeat
                if Member."Date of Birth" <> 0D then begin


                    MemberApplicationSetup.Get();
                    age1 := (Today - Member."Date of Birth");
                    if age1 >= 6570 then
                        MemberNo := NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);
                    tempMember."No." := MemberNo;
                    tempMember."E-mail" := '';
                    tempMember.TransferFields(Member);
                end;


            until member.Next() = 0;
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
                UNTIL AccountType.NEXT = 0;
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



    var
        Member: Record "Member";
        Age: Integer;
        MemberApp: Record "Member Application";
        MemberNo: Code[10];
        Member2: record Member;
        MemberApplicationSetup: Record "Member Application Setup";
        RecRef: RecordRef;
        MemberApplication: Record "Member Application";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        MicrocreditSetup: Record "Microcredit Setup";
        SourceCodeSetup: Record "Source Code Setup";
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        GlobalSetup: Record "Global Setup";
        GlobalManagement: Codeunit "Global Management";
        AccountTypeEnum: Enum "Gen. Journal Account Type";
        BalAccountTypeEnum: Enum "Gen. Journal Account Type";
        AppliesToDocTypeEnum: Enum "Gen. Journal Document Type";
        vendor: Record Vendor;
        vendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        tempMember: record Member;
        age1: Integer;



}
