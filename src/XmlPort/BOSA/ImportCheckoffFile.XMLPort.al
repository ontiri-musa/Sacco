xmlport 50004 "Import Checkoff File"
{
    // version CTS2.0

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
                textelement(AccountType)
                {
                    Width = 20;
                }
                textelement(ReferenceCode)
                {
                    Width = 20;
                }
                textelement(Amount)
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
                    CheckoffLine.INIT;
                    IF i > 1 THEN BEGIN
                        WITH CheckoffLine DO BEGIN
                            "Document No." := DocumentNo;
                            "Line No." := GetLastLineNo(DocumentNo) + 10000;
                            validate("Member No.", MemberNo);
                            if AccountType in ['DEPOSIT', 'SHARECAPITAL'] then begin
                                "Account Type" := "Account Type"::Vendor;
                            end;
                            if AccountType = 'LOAN' then begin
                                "Account Type" := "Account Type"::Customer;
                            end;
                            "Reference Code" := ReferenceCode;
                            evaluate("Line Amount", Amount);
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
        //Message(DocumentNo);
        CheckoffLine2.reset;
        CheckoffLine2.SetRange("Document No.", DocumentNo);
        CheckoffLine2.DeleteAll();
    end;

    trigger OnPostXmlPort()
    begin
        CheckoffLine.RESET;
        IF CheckoffLine.GET(DocumentNo, 0) THEN
            CheckoffLine.DELETE;

    end;

    var
        i: Integer;
        Text000: Label 'Checkoff Entries imported successfully.';
        CheckoffLine: Record "Checkoff Line";
        CheckoffLine2: Record "Checkoff Line";

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
    var
        CheckoffLine2: Record "Checkoff Line";
    begin
        CheckoffLine2.RESET;
        CheckoffLine2.SETRANGE("Document No.", DocumentNo);
        IF CheckoffLine2.FINDLAST THEN
            EXIT(CheckoffLine2."Line No.")
        ELSE
            EXIT(0);
    end;


}

