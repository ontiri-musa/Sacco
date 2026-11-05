table 50025 "Payroll Net Pay Transfer"
{
    Caption = 'Payroll Net Pay Transfer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; Posted; Boolean)
        {
            Editable = false;
        }
        field(3; "Posted Time"; Time)
        {
            Editable = false;
        }
        field(4; "Date Posted"; Date)
        {
            Editable = false;
        }
        field(5; "Posted By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(6; "Created By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(7; "Created Date"; Date)
        {
            Editable = false;
        }
        field(8; "Created Time"; Time)
        {
            Editable = false;
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; "Payroll Period"; Date)
        {
            TableRelation = "Payroll Period" where("NetPay Transfered" = filter(false));
            trigger OnValidate()
            var

            begin
                NetPayTransLines.Reset();
                NetPayTransLines.SetRange("Document No.", "No.");
                if NetPayTransLines.FindSet() then
                    NetPayTransLines.DeleteAll();
                InsertPayPeriodNetPayLines("Payroll Period");
            end;
        }
        field(11; "Posting Date"; Date)
        {

        }
        field(12; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            trigger OnValidate()
            var
            begin
                Clear("Paying Bank");
                Clear("Paying Bank Name");
            end;
        }
        field(13; "Paying Bank"; Code[20])
        {
            TableRelation = IF ("Account Type" = filter("Bank Account")) "Bank Account";
            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
            begin
                If BankAccount.Get("Paying Bank") Then
                    "Paying Bank Name" := BankAccount.Name;
            end;

        }
        field(14; "Paying Bank Name"; Code[50])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert();
    var
    begin
        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        UserSetup.Get(UserId);

        CashMgtSetup.TESTFIELD("Payroll NetPay Transfer Nos.");
        NoSeriesMgt.InitSeries(CashMgtSetup."Payroll NetPay Transfer Nos.", xRec."No. Series", 0D, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := Today;
        "Created Time" := time;
        "Account Type" := "Account Type"::"Bank Account";
    end;

    procedure InsertPayPeriodNetPayLines(PayPeriod: Date)
    var
        EntryNo: Integer;
    begin
        Employee.Reset();
        if Employee.FindSet() then begin
            repeat
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Employee."No.");
                PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
                IF PayrollEntry.FINDFIRST THEN BEGIN
                    NetPayTransLines.Reset();
                    NetPayTransLines.SetRange("Document No.", "No.");
                    if NetPayTransLines.FindLast() then
                        EntryNo := NetPayTransLines."Line No." + 1
                    else
                        EntryNo := 1;
                    NetPayTransLines.Init();
                    NetPayTransLines."Document No." := Rec."No.";
                    NetPayTransLines."Line No." := EntryNo;
                    NetPayTransLines."Employee No" := Employee."No.";
                    NetPayTransLines."Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    NetPayTransLines."Net Pay" := (PayrollProcessing.GetGrossPay(Employee, PayrollEntry."Payroll Period") - PayrollProcessing.GetTotalDeductions(Employee, PayrollEntry."Payroll Period"));
                    NetPayTransLines.Insert();
                END;
            until Employee.Next = 0;
        end;
    end;

    var
        Employee: Record Employee;
        PayrollEntry: Record "Payroll Entries";
        PayrollProcessing: Codeunit "Payroll Processing";
        NetPayTransLines: Record "PayrollNetPayTrans Lines";
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashManagement: Codeunit "Cash Management";
        UserSetup: Record "User Setup";
}
