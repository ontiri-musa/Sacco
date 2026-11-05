tableextension 50169 "Bank Ext" extends "Bank Account"
{
    fields
    {
        field(50000; "Account Type"; Option)
        {
            OptionCaption = 'Bank Account,Till Account,Treasury Account';
            OptionMembers = "Bank Account","Till Account","Treasury Account";
        }
        field(50001; "Paybill Bank"; Boolean)
        {

        }
        field(50002; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            var

            begin
                Member.Get("Member No.");
                "Member Name" := Member."Full Name";
            end;
        }
        field(50003; "Member Name"; Text[50])
        {
            Editable = false;
        }


    }

    var
        Member: Record Member;
}