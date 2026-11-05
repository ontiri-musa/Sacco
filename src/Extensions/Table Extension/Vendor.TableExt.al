tableextension 50000 VendorExt extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Member No."; Code[200])
        {
            TableRelation = Member;
        }
        field(50001; "Member Name"; Text[50])
        {

        }
        field(50002; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";

        }

        field(50004; "Vendor Type"; Option)
        {
            OptionCaption = 'Normal,FOSA,Checkoff,Staff';
            OptionMembers = Normal,FOSA,Checkoff,Staff;

        }
        field(50005; Status; Option)
        {
            OptionCaption = 'Active,Blocked,Dormant,Frozen,Closed';
            OptionMembers = Active,Blocked,Dormant,Frozen,Closed;

        }
        field(50007; "Source Code"; Code[20])
        {
        }


        //Proc added
        field(50011; "Bank Account"; Code[20])
        {
            //TableRelation b
        }


        field(50016; "Pre-Qualified"; Boolean)
        {

        }
        field(50017; "Prequalified Category Code"; Code[20])
        {

        }
        field(50018; "Prequalified Category Desc"; Text[250])
        {

        }
        field(50019; "Payment Receipt"; Option)
        {
            OptionMembers = ,Payment,Receipt,Normal;
        }
        field(50020; "Old Vendor No.s"; code[50])
        {

        }
    }
    fieldgroups
    {
        //addlast(DropDown; "Balance (LCY)") { }


    }

    var
        myInt: Integer;
}