table 51104 "Loan Collateral Substitution"
{
    // version TL2.0

    DrillDownPageID = 51209;
    LookupPageID = 51209;

    fields
    {
        field(1; "Document No."; Code[30])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Security Type Code"; Code[30])
        {
            TableRelation = "Security Type";

            trigger OnValidate()
            begin
                IF SecurityType.GET("Security Type Code") THEN BEGIN
                    // Description := SecurityType.Description;
                    "Security Factor" := SecurityType.Factor;

                END;
            end;
        }
        field(4; Description; Text[250])
        {
        }
        field(5; "Security Value"; Decimal)
        {

            trigger OnValidate()
            begin
                "Guaranteed Amount" := "Security Factor" * "Security Value";
            end;
        }
        field(6; "Guaranteed Amount"; Decimal)
        {
        }
        field(7; "Security Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                "Guaranteed Amount" := "Security Factor" * "Security Value";
            end;
        }
        field(8; "Security Register Code"; Code[20])
        {
            TableRelation = "Security Register" where("Security Type Code" = field("Security Type Code"));

            trigger OnValidate()
            begin
                if CollateralAlreadyUsed() then
                    Error(CollateralAlreadyUsedErr);
                IF SecurityRegister.GET("Security Register Code") THEN BEGIN
                    Description := SecurityRegister.Description;
                END;
            end;
        }
        field(9; "Guarantor Member No"; Code[40])
        {
            TableRelation = Member;
            trigger OnValidate()
            begin

            end;

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


    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    local procedure CollateralAlreadyUsed(): Boolean
    var

    begin

    end;

    var
        SecurityType: Record "Security Type";
        SecurityRegister: Record "Security Register";
        LoanApplication: Record "Loan Application";
        LoanCollateral: Record "Loan Collateral";
        CollateralAlreadyUsedErr: Label 'This collateral is already used to guarantee another loan';
        Member: Record Member;
}

