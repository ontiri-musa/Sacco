table 50104 "Loan Collateral"
{
    // version TL2.0

    DrillDownPageID = 50209;
    LookupPageID = 50209;

    fields
    {
        field(1; "Loan No."; Code[30])
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
    }

    keys
    {
        key(Key1; "Loan No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }


    trigger OnModify()
    begin
        LoanApplication.Get("Loan No.");
        LoanApplication.TestField(Status, LoanApplication.Status::New);
    end;

    trigger OnDelete()
    begin
        LoanApplication.Get("Loan No.");
        LoanApplication.TestField(Status, LoanApplication.Status::New);
    end;

    local procedure CollateralAlreadyUsed(): Boolean
    var

    begin
        LoanCollateral.Reset();
        LoanCollateral.SetRange("Security Register Code", "Security Register Code");
        LoanCollateral.SetFilter("Loan No.", '<>%1', "Loan No.");
        exit(LoanCollateral.FindFirst());
    end;

    var
        SecurityType: Record "Security Type";
        SecurityRegister: Record "Security Register";
        LoanApplication: Record "Loan Application";
        LoanCollateral: Record "Loan Collateral";
        CollateralAlreadyUsedErr: Label 'This collateral is already used to guarantee another loan';
}

