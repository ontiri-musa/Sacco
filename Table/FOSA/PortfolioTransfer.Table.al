table 52008 "Portfolio Transfer"
{
    // version MC2.0

    DataCaptionFields = "No.";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; Category; Option)
        {
            OptionCaption = 'Inter-branch,Intra-branch';
            OptionMembers = "Inter-branch","Intra-branch";

            trigger OnValidate()
            begin
                ValidateCategory;
            end;
        }
        field(3; "Source Branch Code"; Code[10])
        {
            TableRelation = IF (Category = FILTER("Inter-branch")) "Dimension Value".Code WHERE("Global Dimension No." = FILTER(1))
            ELSE
            IF (Category = FILTER("Intra-branch")) "Dimension Value".Code WHERE("Global Dimension No." = FILTER(1));

            trigger OnValidate()
            begin
                ValidateBranch;
                IF DimensionValue.GET('BRANCH', "Source Branch Code") THEN
                    "Source Branch Name" := DimensionValue.Name;

                IF Category = Category::"Intra-branch" THEN BEGIN
                    "Destination Branch Code" := "Source Branch Code";
                    VALIDATE("Destination Branch Code");
                END;
            end;
        }
        field(4; "Source Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Source Loan Officer ID"; Code[20])
        {
            TableRelation = "Loan Recovery Officer Setup" WHERE("Global Dimension 1 Code" = FIELD("Source Branch Code"));

            trigger OnValidate()
            begin
                GetLoanBalances('');
            end;
        }
        field(6; "Source Group No."; Code[20])
        {
            TableRelation = "Member" WHERE("Loan Officer ID" = FIELD("Source Loan Officer ID"),
                                                        Category = FILTER(Group));

            trigger OnValidate()
            begin
                Member.GET("Source Group No.");
                "Source Group Name" := Member."Full Name";


                IF "Transfer Type" = "Transfer Type"::"Group Transfer" THEN BEGIN
                    GetLoanBalances("Source Group No.");
                END;
            end;
        }
        field(7; "Source Group Name"; Text[100])
        {
            Editable = false;
        }
        field(8; "Destination Branch Code";
        Code[10])
        {
            TableRelation = IF (Category = FILTER("Inter-branch")) "Dimension Value".Code WHERE("Global Dimension No." = FILTER(1))
            ELSE
            IF (Category = FILTER("Intra-branch")) "Dimension Value".Code WHERE("Global Dimension No." = FILTER(1));

            trigger OnValidate()
            begin
                IF Category = Category::"Inter-branch" THEN BEGIN
                    IF "Destination Branch Code" = "Source Branch Code" THEN;
                    ERROR(Error000);
                END;

                IF DimensionValue.GET('BRANCH', "Destination Branch Code") THEN
                    "Destination Branch Name" := DimensionValue.Name;
            end;
        }
        field(9; "Destination Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(10; "Created By"; Code[30])
        {
        }
        field(11; "Created Date"; Date)
        {
        }
        field(12; "Created Time"; Time)
        {
        }
        field(13; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(14; "Approved By"; Code[30])
        {
        }
        field(15; "Approved Date"; Date)
        {
        }
        field(16; "Approved Time"; Time)
        {
        }
        field(17; "No. of Members"; Integer)
        {
            Editable = false;
        }
        field(18; "No. of Loans"; Integer)
        {
            Editable = false;
        }
        field(19; "Outstanding Loan Amount"; Decimal)
        {
            Editable = false;
        }
        field(20; "Destination Loan Officer ID"; Code[20])
        {
            TableRelation = IF (Category = FILTER("Inter-branch"),
                                "Transfer Type" = FILTER(<> "Loan Officer Transfer")) "Loan Recovery Officer Setup" WHERE("Global Dimension 1 Code" = FIELD("Destination Branch Code"))
            ELSE
            IF (Category = FILTER("Intra-branch"),
                                         "Transfer Type" = FILTER(<> "Loan Officer Transfer")) "Loan Recovery Officer Setup" WHERE("Global Dimension 1 Code" = FIELD("Source Branch Code"))
            ELSE
            IF ("Transfer Type" = FILTER("Loan Officer Transfer")) "Loan Recovery Officer Setup" WHERE("Global Dimension 1 Code" = FIELD("Source Branch Code"));

            trigger OnValidate()
            begin
                IF "Transfer Type" <> "Transfer Type"::"Client Transfer" THEN BEGIN
                    IF "Source Loan Officer ID" = "Destination Loan Officer ID" THEN;
                    //    ERROR(Error001);
                END;
            end;
        }
        field(21; "Transfer Type"; Option)
        {
            OptionCaption = 'Group Transfer,Client Transfer,Loan Officer Transfer';
            OptionMembers = "Group Transfer","Client Transfer","Loan Officer Transfer";

            trigger OnValidate()
            begin
                ValidateTransferType;
            end;
        }
        field(22; "Member No."; Code[20])
        {
            TableRelation = "Member" WHERE(Category = FILTER('Individual'),
                                                        "Group Link No." = FIELD("Source Group No."));

            trigger OnValidate()
            begin
                Member.GET("Member No.");
                "Member Name" := Member."Full Name";
                GetLoanBalances("Member No.");
            end;
        }
        field(23; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(24; "Destination Group No."; Code[20])
        {
            TableRelation = IF ("Transfer Type" = FILTER("Client Transfer")) "Member" WHERE(Category = FILTER(Group), "Loan Officer ID" = FIELD("Destination Loan Officer ID"));

            trigger OnValidate()
            begin
                Member.GET("Destination Group No.");
                "Destination Group Name" := Member."Full Name";
            end;
        }
        field(25; "Destination Group Name"; Text[100])
        {
            Editable = false;
        }
        field(26; "No. of Groups"; Integer)
        {
            Editable = false;
        }

        field(27; "No. Series"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        MicrocreditSetup.GET;
        IF "No." = '' THEN
            NoSeriesMgt.InitSeries(MicrocreditSetup."Portfolio Transfer Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    var
        MicrocreditSetup: Record "Microcredit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimensionValue: Record "Dimension Value";
        Member: Record Member;
        Error000: Label 'Destination branch cannot be the same as the source branch!';
        Error001: Label 'Destination Loan Officer cannot be the same as Source Loan Officer';

    local procedure GetLoanBalances("MemberNo.": Code[20])
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Loans: Integer;
        LoanAmount: Decimal;
    begin
        LoanAmount := 0;
        Loans := 0;
        "No. of Loans" := 0;
        "No. of Groups" := 0;
        "No. of Members" := 0;
        "Outstanding Loan Amount" := 0;
        IF "Transfer Type" = "Transfer Type"::"Client Transfer" THEN BEGIN
            Customer.Reset();
            Customer.SetRange("Member No.", "MemberNo.");
            Customer.SetRange(Status, Customer.Status::Active);
            Customer.SetFilter("Balance (LCY)", '<>%1', 0);
            if Customer.FindFirst() then begin
                "No. of Loans" := 1;
                Customer.CALCFIELDS("Balance (LCY)");
                "Outstanding Loan Amount" := ABS(Customer."Balance (LCY)");
            END;
        END ELSE BEGIN
            IF "Transfer Type" = "Transfer Type"::"Group Transfer" THEN BEGIN
                Member.RESET;
                Member.SETRANGE("Group Link No.", "MemberNo.");
                IF Member.FINDSET THEN BEGIN
                    REPEAT
                        Customer.Reset();
                        Customer.SetRange("Member No.", "MemberNo.");
                        Customer.SetRange(Status, Customer.Status::Active);
                        Customer.SetFilter("Balance (LCY)", '<>%1', 0);
                        if Customer.FindFirst() then begin
                            Loans := 1;
                            Customer.CALCFIELDS("Balance (LCY)");
                            LoanAmount := ABS(Customer."Balance (LCY)");
                        END;
                        "No. of Members" += 1;
                    UNTIL Member.NEXT = 0;
                END;
                "No. of Loans" := Loans;
                "Outstanding Loan Amount" := LoanAmount;
            END ELSE BEGIN
                IF "Transfer Type" = "Transfer Type"::"Loan Officer Transfer" THEN BEGIN
                    Member.RESET;
                    Member.SETRANGE("Loan Officer ID", "Source Loan Officer ID");
                    IF Member.FINDSET THEN BEGIN
                        REPEAT
                            Customer.Reset();
                            Customer.SetRange("Member No.", "MemberNo.");
                            Customer.SetRange(Status, Customer.Status::Active);
                            Customer.SetFilter("Balance (LCY)", '<>%1', 0);
                            if Customer.FindFirst() then begin
                                Loans := 1;
                                Customer.CALCFIELDS("Balance (LCY)");
                                LoanAmount := ABS(Customer."Balance (LCY)");
                            END;
                            IF Member.Category = Member.Category::Individual THEN BEGIN
                                "No. of Members" += 1;
                            END ELSE BEGIN
                                "No. of Groups" += 1;
                            END;
                        UNTIL Member.NEXT = 0;
                    END;
                    "No. of Loans" := Loans;
                    "Outstanding Loan Amount" := LoanAmount;
                END;
            END;
        END;
    end;

    local procedure ValidateTransferType()
    begin
        "Source Branch Code" := '';
        "Source Branch Name" := '';
        "Source Loan Officer ID" := '';
        "Destination Branch Code" := '';
        "Destination Branch Name" := '';
        "Destination Loan Officer ID" := '';
        "Source Group No." := '';
        "No. of Groups" := 0;
        "Source Group Name" := '';
        "No. of Loans" := 0;
        "No. of Members" := 0;
        "Outstanding Loan Amount" := 0;
        "Member Name" := '';
        "Member No." := '';
    end;

    local procedure ValidateCategory()
    begin
        "Source Branch Code" := '';
        "Source Branch Name" := '';
        "Source Loan Officer ID" := '';
        "Destination Branch Code" := '';
        "Destination Branch Name" := '';
        "Destination Loan Officer ID" := '';
        "Source Group No." := '';
        "No. of Groups" := 0;
        "Source Group Name" := '';
        "No. of Loans" := 0;
        "No. of Members" := 0;
        "Outstanding Loan Amount" := 0;
        "Member Name" := '';
        "Member No." := '';
    end;

    local procedure ValidateBranch()
    begin
        "Source Loan Officer ID" := '';
        "Destination Branch Code" := '';
        "Destination Branch Name" := '';
        "Destination Loan Officer ID" := '';
        "Source Group No." := '';
        "No. of Groups" := 0;
        "Source Group Name" := '';
        "No. of Loans" := 0;
        "No. of Members" := 0;
        "Outstanding Loan Amount" := 0;
        "Member Name" := '';
        "Member No." := '';
    end;
}

