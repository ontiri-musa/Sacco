table 59106 "Loan Consolidation Entry"
{
    // version TL2.0

    DrillDownPageID = 59211;
    LookupPageID = 59211;

    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; "Loan To Consolidate"; Code[30])
        {
            TableRelation = "Loan Application" where(Posted = filter(true), "Member No." = field("Member No."), "Outstanding Balance" = filter(> 0));
            trigger OnValidate()
            begin
                IF LoanApplication.GET("Loan To Consolidate") THEN BEGIN
                    LoanApplication.CalcFields("Outstanding Balance");
                    "Outstanding Balance" := LoanApplication."Outstanding Balance";
                    Description := LoanApplication.Description;
                END;
            end;
        }
        field(3; Description; Text[50])
        {
            Editable = false;
        }
        field(4; "Outstanding Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; Select; Boolean)
        {
        }
        field(6; "Line No."; Integer)
        {
        }
        field(7; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            var
                Memb: Record Member;
            begin
                Memb.Get("Member No.");
                "Member Name" := Memb."Full Name";
            end;
        }
        field(8; "Member Name"; Text[300])
        {
            Editable = false;
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
    trigger OnInsert()
    begin
        LoanCon.Reset();
        LoanCon.SETCURRENTKEY("Line No.");
        LoanCon.ASCENDING();
        If LoanCon.FindLast() then
            "Line No." := LoanCon."Line No." + 1
        else
            "Line No." := 1;
    end;

    var
        LoanCon: Record "Loan Consolidation Entry";
        Member: Record Member;
        LoanApplication: Record "Loan Application";
}

