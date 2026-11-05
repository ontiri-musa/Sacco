xmlport 50025 "Import  Recovery File"
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
                textelement(AcctNo)
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
                    RecovLine.INIT;
                    IF i > 1 THEN BEGIN
                        WITH RecovLine DO BEGIN
                            "Document No." := DocumentNo;
                            "Line No." := GetLastLineNo(DocumentNo) + 10000;
                            validate("Member No.", MemberNo);
                            Validate("Account  No.", AcctNo);
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
        RecovLine2.reset;
        RecovLine2.SetRange("Document No.", DocumentNo);
        RecovLine2.DeleteAll();
    end;

    trigger OnPostXmlPort()
    begin
        RecovLine.RESET;
        IF RecovLine.GET(DocumentNo, 0) THEN
            RecovLine.DELETE;
    end;

    var
        i: Integer;
        Text000: Label 'Loan Recovery Entries imported successfully.';
        RecovLine: Record "Recovery Line";
        RecovLine2: Record "Recovery Line";

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
        RecovLine2.RESET;
        RecovLine2.SETRANGE("Document No.", DocumentNo);
        IF RecovLine2.FINDLAST THEN
            EXIT(RecovLine2."Line No.")
        ELSE
            EXIT(0);
    end;


}

