xmlport 50024 "Import Loan Recovery File"
{
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                SourceTableView = WHERE(Number = CONST(1));
                textelement(MemberNo)
                {
                    Width = 20;
                }
                textelement(MemberName)
                {
                    Width = 200;
                }
                textelement(LoanNo)
                {
                    Width = 20;
                }
                textelement(RecovAmount)
                {
                    Width = 20;
                }
                trigger OnAfterGetRecord()
                begin
                    Integer.SETRANGE(Number, 1, 1);
                end;

                trigger OnAfterInsertRecord()
                begin
                    i += 1;
                    LoanRecovLine.INIT;
                    IF i > 1 THEN BEGIN
                        WITH LoanRecovLine DO BEGIN
                            "Document No." := DocumentNo;
                            "Line No." := GetLastLineNo(DocumentNo) + 10000;
                            validate("Member No.", MemberNo);
                            Validate("Loan No.", LoanNo);
                            evaluate("Recovery Amount", RecovAmount);
                            INSERT(TRUE);
                        END;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        LoanRecovLine2.reset;
        LoanRecovLine2.SetRange("Document No.", DocumentNo);
        LoanRecovLine2.DeleteAll();
    end;

    trigger OnPostXmlPort()
    begin
        LoanRecovLine.RESET;
        IF LoanRecovLine.GET(DocumentNo, 0) THEN
            LoanRecovLine.DELETE;
    end;

    var
        i: Integer;
        Text000: Label 'Loan Recovery Entries imported successfully.';
        LoanRecovLine: Record "Loan Recovery Line";
        LoanRecovLine2: Record "Loan Recovery Line";

        DocumentNo: Code[20];
        Member: Record Member;
        LineNo: Integer;
        Customer: Record Customer;
        Vendor: Record Vendor;

    procedure SetDocumentNo(var DocNo: Code[20])
    begin
        DocumentNo := DocNo;
    end;

    local procedure GetLastLineNo(DocumentNo: Code[20]): Integer
    begin
        LoanRecovLine2.RESET;
        LoanRecovLine2.SETRANGE("Document No.", DocumentNo);
        IF LoanRecovLine2.FINDLAST THEN
            EXIT(LoanRecovLine2."Line No.")
        ELSE
            EXIT(0);
    end;


}

