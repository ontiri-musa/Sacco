table 57040 "PayrollNetPayTrans Lines"
{

    fields
    {

        field(1; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Employee No"; Code[20])
        {

        }
        field(5; "Employee Name"; Text[250])
        {

        }
        field(6; "Net Pay"; Decimal)
        {

        }
        field(7; "Cheque No"; code[10])
        {

        }
        field(8; "Cheque Date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
    procedure DeleteRelatedLinks(DocNo: Code[20])
    var

    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document No.", DocNo);
        PaymentLine.DeleteAll();
    end;

    procedure PaymentLinesExist(DocNo: Code[20]): Boolean
    var

    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document No.", DocNo);
        exit(PaymentLine.FindFirst());
    end;





    var
        CashManagement: Codeunit "Cash Management";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        GlobalSetup: Record "Global Setup";
        PaymentHeader: Record "Payroll Net Pay Transfer";
        PaymentLine: Record "PayrollNetPayTrans Lines";
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Member: Record Member;



}

