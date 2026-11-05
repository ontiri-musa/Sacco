table 50703 "Sales Portfolio"
{

    fields
    {
        field(1; Code; Code[20])
        {
            TableRelation = "Loan Recovery Officer Setup";
            trigger OnValidate()
            begin
                if LoanOfficer.Get(Code) then begin
                    Name := LoanOfficer."Full Name";
                    "Member No." := LoanOfficer."Member No.";
                    "Branch Code" := LoanOfficer."Global Dimension 1 Code";
                end;

            end;
        }
        field(2; Name; Text[100])
        {
            Editable = false;
        }
        field(3; "Member No."; Code[20])
        {
            Editable = false;
        }
        field(4; "Recruited Members"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(Member where("Introducer Member No." = field("Member No.")));
        }
        field(5; "Assigned Stations"; Integer)
        {

        }
        field(6; "Branch Code"; Code[10])
        {

        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        LoanOfficer: Record "Loan Recovery Officer Setup";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}