table 59370 "Recovery Header"

{
    //LookupPageId = "Checkoff List-Posted-Reversed";
    //DrillDownPageId = "Checkoff List-Posted-Reversed";
    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "Posted Time"; Time)
        {
        }
        field(14; "Posted Date"; Date)
        {
        }
        field(15; "Posted By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(17; Description; Text[100])
        {
        }
        field(20; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(27; "Destination Account Type"; Option)
        {
            OptionCaption = ' ,G/l,Vendor';
            OptionMembers = " ","G/L",Vendor;
            trigger OnValidate()
            begin


            end;
        }
        field(21; "Destination G/L"; Code[50])
        {
            TableRelation = if ("Destination Account Type" = const("G/l")) "G/L Account";

        }

        field(22; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(23; "Created Date"; Date)
        {
            Editable = false;
        }
        field(24; "Created Time"; Time)
        {
            Editable = false;
        }
        field(25; "No. Series"; Code[20])
        {
        }
        field(26; "Total Recovery Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recovery Line"."Recovery Amount" where("Document No." = field("No.")));
            Editable = false;
        }


        field(29; Reversed; Boolean)
        {

            Editable = false;
        }
        field(38; "Reversed Time"; Time)
        {
        }
        field(39; "Reversed Date"; Date)
        {
        }
        field(40; "Reversed By"; Code[50])
        {
            TableRelation = "User Setup";
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

    trigger OnDelete();
    begin
        TestField(Status, Status::New);
    end;

    trigger OnInsert();
    begin

        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");

        CashMgtSetup.TESTFIELD("Checkoff Nos.");
        NoSeriesMgt.InitSeries(CashMgtSetup."Loan Recovery Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        "Created By" := USERID;
        "Created Date" := Today;
        "Posting Date" := Today;
        "Created Time" := time;
    end;

    var
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashManagement: Codeunit "Cash Management";
        LoanRecovLine: Record "Loan Recovery Line";
        GlobalManagement: Codeunit "Global Management";
        UserSetup: Record "User Setup";
        Vendor: Record Vendor;
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        AccountTypeEnum: Enum "Gen. Journal Account Type";

    procedure CheckoffLinesExist(): Boolean;
    begin
        LoanRecovLine.RESET;
        LoanRecovLine.SETRANGE("Document No.", "No.");
        EXIT(LoanRecovLine.FINDFIRST);
    end;
}