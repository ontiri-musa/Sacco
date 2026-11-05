table 50169 "FOSA Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[250])
        {

            DataClassification = ToBeClassified;
        }
        field(2; "Member-Active"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Member where(Status = FILTER(Active)));

        }

        field(3; "Member-Dormant"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Member where(Status = FILTER(Dormant)));

        }
        field(4; "Member-Suspended"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Member where(Status = FILTER(Suspended)));

        }
        field(5; "Member-Withdrawn"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Member where(Status = FILTER(Withdrawn)));

        }
        field(6; "MobileBankingMember-Active"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Mobile Banking Member" where(Status = FILTER(Active)));

        }
        field(7; "MobileBankingMember-Inactive"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Mobile Banking Member" where(Status = FILTER(Inactive)));

        }

        field(10; "ChequeBook-New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Cheque Book" where(Status = FILTER(New)));

        }
        field(11; "ChequeBook-Issued"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Cheque Book" where(Status = FILTER(Issued)));

        }
        field(20; "TotalOrdinarySavings"; Decimal)
        {


        }
        field(21; "TotalDeposits"; Decimal)
        {


        }
        field(22; "TotalLoans"; Decimal)
        {


        }

        field(23; "TotalShares"; Decimal)
        {


        }
        field(24; "TotalFixedDeposits"; Decimal)
        {


        }



    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}