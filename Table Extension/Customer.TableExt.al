tableextension 50001 CustomerExt extends Customer
{

    fields
    {
        // Add changes to table fields here
        field(50000; "Member No."; Code[20])
        {
            TableRelation = Member;

        }
        field(50001; "Member Name"; Text[50])
        {


        }

        field(50003; Status; Option)
        {
            OptionMembers = Active,Blocked,Dormant;
            OptionCaption = 'Active,Blocked,Dormant';

        }
        field(50004; "Customer Type"; Option)
        {
            OptionMembers = Normal,Loan;
            OptionCaption = 'Normal,Loan';

        }
        field(50005; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type";
        }

    }
    fieldgroups
    {
        addlast(DropDown; Balance)
        {

        }
    }

    var
        myInt: Integer;
}