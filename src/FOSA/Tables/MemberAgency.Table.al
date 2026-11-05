table 50037 "Member Agency"
{
    // version TL2.0


    fields
    {
        field(1; "Agent Code"; Code[10])
        {
            TableRelation = "Remittance Agent Setup";
            ;

            trigger OnValidate()
            begin
                RemittanceAgentSetup.GET("Agent Code");
                "Agent Name" := RemittanceAgentSetup.Name;
            end;
        }
        field(2; "Member Agency No."; Code[20])
        {
        }
        field(3; "Payroll No."; Code[50])
        {
        }
        field(4; "Agent Name"; Code[100])
        {
        }
        field(5; "Member No."; Code[30])
        {
            TableRelation = Member;
        }
        field(6; "Pay To Account No."; Code[10])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));
        }
        field(7; "Application No."; Code[20])
        {

        }
        field(8; "Line No."; Integer)
        {

        }
    }

    keys
    {
        key(Key1; "Application No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RemittanceAgentSetup: Record "Remittance Agent Setup";
}

