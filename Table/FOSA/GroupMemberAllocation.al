table 52017 "Group Member Allocation"
{
    // version MC2.0

    DrillDownPageID = "Group Member Allocation";
    LookupPageID = "Group Member Allocation";

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Transaction No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Member No."; Code[20])
        {

            trigger OnLookup()
            begin
                IF GroupAllocationHeader.GET("Document No.") THEN BEGIN
                    Member.GET(GroupAllocationHeader."Group No.");
                    Member2.RESET;
                    Member2.SETRANGE("Group Link No.", Member."No.");
                    // Member2.SETRANGE(Category, Member2.Category::Client);
                    Member2.SETRANGE(Status, Member2.Status::Active);
                    //Member2.SETRANGE("Exit Status", Member2."Exit Status"::" ");
                    IF PAGE.RUNMODAL(50012, Member2) = ACTION::LookupOK THEN BEGIN
                        "Member No." := Member2."No.";
                        "Member Name" := Member2."Full Name";
                    END;
                END;
            end;
        }
        field(5; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Amount Due"; Decimal)
        {
            Editable = false;

        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = if ("Loan Account" = filter('no')) Vendor WHERE("Member No." = FIELD("Member No."))
            else
            if ("Loan Account" = filter('yes')) Customer where("Member No." = field("Member No."));

            trigger OnValidate()
            begin
                IF GroupAllocationHeader.GET("Document No.") THEN;
                IF Vendor.GET("Account No.") THEN BEGIN
                    "Account Name" := Vendor.Name;
                    IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                        IF AccountType.Type = AccountType.Type::Savings THEN BEGIN
                            Member.GET(GroupAllocationHeader."Group No.");
                            "Amount Due" := Member."Min. Contribution per Meeting";
                        END;
                    END;
                END;
                if Customer.get("Account No.") then begin
                    //  DueAmount[1]---Principal
                    //  DueAmount[2]---Interest
                    //  ArrearsAmount[1]---PrincipalArrears
                    //  ArrearsAmount[2]---InterestArrears
                    //  ArrearsAmount[3]---PrincipalOP
                    //  ArrearsAmount[4]---InterestOP
                    GlobalManagement.CalculateInstallmentDue("Account No.", GroupAllocationHeader."Current Meeting Date", DueAmount[1], DueAmount[2]);
                    GlobalManagement.CalculateLoanArrearsAndOverpayment("Account No.", 0D, GroupAllocationHeader."Current Meeting Date", ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4],
                                                                        ArrearsAmount[3], ArrearsAmount[4]);
                    "Amount Due" := DueAmount[1] + DueAmount[2];
                    "Amount in Arrears" := ArrearsAmount[1] + ArrearsAmount[2];
                    "Overpayment Amount" := ArrearsAmount[4] + ArrearsAmount[3];
                end;
            end;
        }
        field(8; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(9; "Allocation Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Account No.");
                GroupAllocationLine.RESET;
                GroupAllocationLine.LOCKTABLE;
                IF GroupAllocationLine.GET("Document No.", "Transaction No.") THEN BEGIN
                    GroupAllocationLine.CALCFIELDS("Allocated Amount");
                    NetAllocatedAmount[1] := (Rec."Allocation Amount" - xRec."Allocation Amount");
                    NetAllocatedAmount[2] := GroupAllocationLine."Allocated Amount" + NetAllocatedAmount[1];
                    IF NetAllocatedAmount[2] > GroupAllocationLine."Amount to Allocate" THEN
                        ERROR(Error000, NetAllocatedAmount[2], GroupAllocationLine."Amount to Allocate");
                END;
            end;
        }
        field(10; "Amount in Arrears"; Decimal)
        {
            Editable = false;
        }
        field(11; "Overpayment Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "Loan Account"; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "Document No.", "Transaction No.", "Line No.")
        {
        }
        key(Key2; "Document No.", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        OnDeleteAllocationLine;
    end;

    trigger OnInsert()
    begin
        "Line No." := GetLastAllocationLine + 10000;
        UpdateRemainingAmount;
    end;

    trigger OnModify()
    begin
        UpdateRemainingAmount;
    end;

    var
        Member: Record Member;
        Member2: Record Member;
        Vendor: Record Vendor;
        Customer: Record Customer;
        BOSAMgt: Codeunit "BOSA Management";
        GroupAllocationLine: Record "Group Allocation Line";
        Error000: Label 'Amount Allocated (%1) exceeds the Amount to Allocate (%2)';
        NetAllocatedAmount: array[2] of Decimal;
        DueAmount: array[2] of Decimal;
        GroupCollectionEntry: Record "Group Collection Entry";
        // MicroCreditManagement: Codeunit "55001";
        GroupAllocationHeader: Record "Group Allocation Header";
        AccountType: Record "Account Type";
        ArrearsAmount: array[10] of Decimal;
        GlobalManagement: Codeunit "Global Management";

    local procedure GetLastAllocationLine(): Integer
    var
        GroupMemberAllocation: Record "Group Member Allocation";
    begin
        GroupMemberAllocation.RESET;
        GroupMemberAllocation.SETRANGE("Document No.", Rec."Document No.");
        GroupMemberAllocation.SETRANGE("Transaction No.", Rec."Transaction No.");
        IF GroupMemberAllocation.FINDLAST THEN
            EXIT(GroupMemberAllocation."Line No.")
        ELSE
            EXIT(0);
    end;

    local procedure OnDeleteAllocationLine()
    begin
        IF GroupAllocationLine.GET("Document No.", "Transaction No.") THEN BEGIN
            GroupAllocationLine."Remaining Amount" += "Allocation Amount";
            GroupAllocationLine.MODIFY;
        END;
    end;

    procedure UpdateRemainingAmount(): Decimal
    begin
        IF GroupAllocationLine.GET("Document No.", "Transaction No.") THEN BEGIN
            GroupAllocationLine."Remaining Amount" -= "Allocation Amount";
            GroupAllocationLine.MODIFY;
        END;
        IF GroupCollectionEntry.GET("Transaction No.") THEN BEGIN
            GroupCollectionEntry."Remaining Amount" -= "Allocation Amount";
            GroupCollectionEntry.MODIFY;
        END;
    end;
}

