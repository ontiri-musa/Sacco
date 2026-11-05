table 50164 "Loan Writeoff Line"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application" WHERE(Posted = FILTER(true), "Member No." = field("Member No."), "Outstanding Balance" = filter(> 0));

            trigger OnValidate()
            begin
                IF LoanApplication.GET("Loan No.") THEN BEGIN
                    LoanApplication.CALCFIELDS("Outstanding Balance");
                    Description := LoanApplication.Description;
                    "Outstanding Balance" := LoanApplication."Outstanding Balance";
                    GlobalManagement.CalculateLoanArrearsAndOverpayment("Loan No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4],
                                                                        OverpaymentAmount[1], OverpaymentAmount[2]);
                    "Total Arrears" := ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4];
                    BOSAManagement.CalculateDaysAndInstallmentsInArrearsDefaulter("Loan No.", ArrearsAmount[1] + ArrearsAmount[2], NoofDaysInArrears, NoofInstallmentInArrears, Today);
                    "No. of Days in Arrears" := NoofDaysInArrears;
                    "No. of Installment Defaulted" := NoofInstallmentInArrears;
                END;
            end;
        }
        field(4; Description; Text[50])
        {
            Editable = false;
        }
        field(5; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            var
                Memb: Record Member;
            begin
                If Memb.Get("Member No.") then
                    "Member Name" := Memb."Full Name";
            end;
        }
        field(6; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Total Arrears"; Decimal)
        {
            Editable = false;
        }
        field(8; "No. of Days in Arrears"; Integer)
        {
            Editable = false;
        }
        field(9; "No. of Installment Defaulted"; Integer)
        {
            Editable = false;
        }
        field(10; "Outstanding Balance"; Decimal)
        {
            Editable = false;
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
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

    var
        LoanApplication: Record "Loan Application";
        BOSAManagement: Codeunit "BOSA Management";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        GlobalManagement: Codeunit "Global Management";
}

