table 52088 "Loan  Officer Setup"
{
    // version MC2.0

    DrillDownPageID = "Recovery Officer Setup";
    LookupPageID = "Recovery Officer Setup";

    fields
    {
        field(1; "Officer"; Code[30])
        {

        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Member;
            trigger OnValidate()
            begin
                Member.GET("Member No.");
                "First Name" := Member."First Name";
                "Last Name" := Member."Last Name";
                "Full Name" := Member."Full Name";
                "National ID" := Member."National ID";
                "Phone No." := Member."Phone No.";
                "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                "E-mail" := Member."E-mail";
                "Payroll No." := Member."Payroll No.";
            end;
        }
        field(3; "First Name"; Code[50])
        {
        }
        field(4; "Last Name"; Code[50])
        {
        }
        field(5; "Full Name"; Code[50])
        {
        }
        field(6; "National ID"; Code[20])
        {
        }
        field(7; "Phone No."; Code[20])
        {
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Branch Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "E-mail"; Text[20])
        {
        }
        field(10; "Payroll No."; Code[20])
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(12; Supervisor; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(13; Role; Option)
        {
            OptionCaption = 'MicroCredit Officer,Business Representative';
            OptionMembers = "MicroCredit Officer","Business Representative";
        }

    }

    keys
    {
        key(Key1; Officer)
        {
        }
    }

    var
        Member: Record Member;


}

