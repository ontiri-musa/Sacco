report 50897 convertJuniorToAdult
{
    Caption = 'Junior To Adult';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem(Member; Member)
        {

            column(No_; "No.")
            {

            }
            trigger OnPreDataItem()
            begin
                SetFilter(Category, '%1', Member.Category::Junior);
                setrange("No.", '000003-0031');
            end;

            trigger OnAfterGetRecord()
            begin
                if Member."Date of Birth" <> 0D then begin



                    MemberApplicationSetup.Get();

                    age1 := (Today - Member."Date of Birth");

                    if age1 >= 6570 then
                        MemberNo := NoSeriesManagement.GetNextNo(MemberApplicationSetup."Member Nos.", TODAY, TRUE);



                    tempMember.TransferFields(Member, true);
                    tempMember."No." := MemberNo;
                    tempMember."E-mail" := '';
                    tempMember.Category := tempMember.Category::Individual;

                    tempMember."Sub Category" := tempMember."Sub Category"::" ";
                    tempMember."Age Classification" := tempMember."Age Classification"::Adult;
                    tempMember."Junior Account Number" := Member."No.";
                    if tempMember.Insert(true) then
                        tempMember.Category := tempMember.Category::Individual;
                end;
                Commit();
                vendor.SetRange("Member No.", Member."No.");
                if vendor.FindSet() then begin
                    repeat
                        case vendor."Account Type" of

                            '01':
                                begin

                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + '01';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';



                                end;
                            '02':
                                begin


                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + '02';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            '03':
                                begin


                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + '03';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            '04':
                                begin


                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + '04';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            '05':
                                begin

                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + '05';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            '06':
                                begin

                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + '06';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            'BM':
                                begin

                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + 'BM';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            'CD':
                                begin

                                    Commit();
                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + 'CD';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;
                            'FD':
                                begin

                                    tempvendor.TransferFields(vendor);
                                    tempvendor."Old Vendor No.s" := vendor."No.";
                                    tempvendor."No." := tempMember."No." + 'FD';
                                    tempvendor."Member No." := tempMember."No.";
                                    if tempvendor.Insert() then
                                        tempvendor."No." := tempMember."No." + '01';

                                end;

                        end;
                        Commit();

                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetRange("Vendor No.", tempvendor."Old Vendor No.s");
                        if vendorLedgerEntry.FindSet() then begin
                            repeat
                                vendorLedgerEntry."Vendor No." := tempvendor."No.";
                                vendorLedgerEntry.Modify();
                            until vendorLedgerEntry.Next() = 0;
                        end;
                        Commit();
                        DetailedVendorLedgerEntry.Reset();
                        DetailedVendorLedgerEntry.SetRange("Vendor No.", tempvendor."Old Vendor No.s");
                        if DetailedVendorLedgerEntry.FindSet() then begin
                            repeat
                                DetailedVendorLedgerEntry."Vendor No." := tempvendor."No.";
                                DetailedVendorLedgerEntry.Modify();
                            until DetailedVendorLedgerEntry.Next() = 0;

                        end;

                    until vendor.Next() = 0;

                end;


            end;
        }
    }





    var
        myInt: Integer;
        MemberApplicationSetup: Record "Member Application Setup";
        age1: Integer;
        MemberNo: Code[59];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        tempMember: record Member;
        memb: Record Member;
        vendor: Record Vendor;
        vendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        tempvendor: Record Vendor;
        virtmember: Record Member;
}