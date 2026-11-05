table 50137 "Guarantor Substitution Header"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Loan No."; Code[20])
        {
            TableRelation = Customer where("Member No." = field("Member No."), "Customer Type" = filter(1), Balance = filter(> 0));
            trigger OnValidate()
            begin
                DeleteGuarantorLines("No.");
                IF LoanApplication.GET("Loan No.") THEN BEGIN
                    "Member No." := LoanApplication."Member No.";
                    "Member Name" := LoanApplication."Member Name";
                    Description := LoanApplication.Description;
                    GetGuarantors("Loan No.", LoanApplication);
                END;
            end;
        }
        field(3; "Member No."; Code[20])
        {
            // Editable = false;
            TableRelation = Member;
            trigger OnValidate()
            var
            begin
                Member.Get("Member No.");
                "Member Name" := Member."Full Name";
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Created Date"; Date)
        {
            Editable = false;
        }
        field(8; "Created Time"; Time)
        {
            Editable = false;
        }
        field(9; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(10; Description; Text[50])
        {
            Editable = false;
        }
        field(11; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Guaranteed Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Guarantor Substitution Line"."Guaranteed Amount" WHERE("Document No." = FIELD("No."),
                                                                                       Substitute = FILTER(true)));
            Editable = false;

        }
        field(14; "Substituted Amount"; Decimal)
        {
            CalcFormula = Sum("Guarantor Allocation"."Amount To Guarantee" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Substitution Amount Collateral"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Loan Collateral Substitution"."Guaranteed Amount" WHERE("Document No." = FIELD("No.")
                                                                                 ));
            Editable = false;

        }
        field(22; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(23; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(24; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(29; "Substitution Type"; Option)
        {
            OptionCaption = ' ,Guarantor,Collateral';
            OptionMembers = "",Guarantor,Collateral;
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
        GuarantorSubstitutionSetup.GET;
        GuarantorSubstitutionSetup.TestField("Guarantor Substitution Nos.");
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(GuarantorSubstitutionSetup."Guarantor Substitution Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        GuarantorSubstitutionSetup: Record "Guarantor Substitution Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LoanApplication: Record "Loan Application";
        Member: Record Member;

    local procedure DeleteGuarantorLines(DocumentNo: Code[20])
    var
        GuarantorSubstitutionLine: Record "Guarantor Substitution Line";
    begin
        GuarantorSubstitutionLine.RESET;
        GuarantorSubstitutionLine.SETRANGE("Document No.", DocumentNo);
        GuarantorSubstitutionLine.DELETEALL;
    end;

    local procedure GetGuarantors(LoanNo: Code[20]; LoanApp: Record "Loan Application")
    var
        LoanGuarantor: Record "Loan Guarantor";
        GuarantorSubstitutionLine: Record "Guarantor Substitution Line";
        GuarantorSubstitutionLine2: Record "Guarantor Substitution Line";
        LineNo: Integer;
    begin
        LoanApp.CalcFields("Outstanding Balance");
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", LoanNo);
        IF LoanGuarantor.FINDSET THEN BEGIN
            REPEAT
                GuarantorSubstitutionLine.INIT;
                GuarantorSubstitutionLine."Document No." := "No.";
                GuarantorSubstitutionLine2.RESET;
                GuarantorSubstitutionLine2.SETRANGE("Document No.", "No.");
                IF GuarantorSubstitutionLine2.FINDLAST THEN
                    LineNo := GuarantorSubstitutionLine2."Line No."
                ELSE
                    LineNo := 0;
                GuarantorSubstitutionLine."Line No." := LineNo + 10000;
                GuarantorSubstitutionLine.VALIDATE("Member No.", LoanGuarantor."Member No.");
                GuarantorSubstitutionLine.VALIDATE("Account No.", LoanGuarantor."Account No.");
                GuarantorSubstitutionLine."Guaranteed Amount" := Round((LoanGuarantor."Amount To Guarantee" / LoanApp."Approved Amount") * LoanApp."Outstanding Balance");
                if GuarantorSubstitutionLine."Guaranteed Amount" > LoanGuarantor."Amount To Guarantee" then
                    GuarantorSubstitutionLine."Guaranteed Amount" := LoanGuarantor."Amount To Guarantee" else
                    GuarantorSubstitutionLine."Guaranteed Amount" := GuarantorSubstitutionLine."Guaranteed Amount";
                GuarantorSubstitutionLine.INSERT;
            UNTIL LoanGuarantor.NEXT = 0;
        END;
    end;

    procedure GuarantorsLineExist(): Boolean
    var
        GuarantorSubstitutionLine: Record "Guarantor Substitution Line";
    begin
        GuarantorSubstitutionLine.RESET;
        GuarantorSubstitutionLine.SETRANGE("Document No.", "No.");
        EXIT(GuarantorSubstitutionLine.FINDFIRST);
    end;
}

