table 50605 "Smart Teller No Series"
{

    fields
    {
        field(1; Code; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(2; Deposit; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(3; Withdrawal; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4; "Cheque Deposit"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(5; "Request From Treasury"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6; "Inter Teller"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(7; "Return To Treasury"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(8; "ATM Request"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(9; Imprest; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(10; InterAccount; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(11; MemberApplication; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12; "Issue To Teller"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(13; "Receive From Bank"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(14; "Return To Bank"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(15; "Spotcash Request"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; Code)
        {
        }
    }

    fieldgroups
    {
    }
}

