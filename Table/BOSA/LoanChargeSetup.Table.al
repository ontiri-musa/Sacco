table 50109 "Loan Charge Setup"
{
    // version TL2.0

    DrillDownPageID = 50216;
    LookupPageID = 50216;

    fields
    {
        field(1; Code; Code[20])
        {

        }
        field(2; Description; Text[50])
        {

        }
        field(3; Type; Option)
        {
            OptionMembers = "Processing Fee","Ledger Fee","Insurance Fee";
        }


        field(7; "Income G/L Account"; Code[50])
        {
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false), "Direct Posting" = CONST(true));
            //ELSE
            // IF ("Account Type" = CONST(Member)) Code;
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
        fieldgroup(dropDown; Code, Description, Type)
        {

        }
    }
}

