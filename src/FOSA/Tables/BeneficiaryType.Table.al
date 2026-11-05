table 50004 "Beneficiary Type"
{
    // version TL2.0


    fields
    {
        field(1; "Application No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {

        }
        field(3; Name; Text[50])
        {
            trigger OnValidate()
            begin
                Name := UpperCase(Name);
            end;
        }
        field(4; "National ID"; Integer)
        {
        }
        field(5; "Allocation (%)"; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = 'Next of Kin,Nominee,Group Member,Group Trustee,Company Signatory,Company Trustee,Joint Member,Deposit Cover Dependant,Other';
            OptionMembers = "Next of Kin",Nominee,"Group Member","Group Trustee","Company Signatory","Company Trustee","Joint Member","Deposit Cover Dependant",Other;
        }
        field(8; Signature; Media)
        {
            ExtendedDatatype = Person;

        }
        field(9; "Front ID"; Media)
        {
            ExtendedDatatype = Person;
        }
        field(10; "Back ID"; Media)
        {
            ExtendedDatatype = Person;
        }
        field(11; Picture; Media)
        {
            ExtendedDatatype = Person;
        }
        field(12; Relationship; Option)
        {
            OptionCaption = 'Father,Mother,Brother,Sister,Son,Daughter,Wife,Husband,Uncle,Aunt,Cousin,Other';
            OptionMembers = Father,Mother,Brother,Sister,Son,Daughter,Wife,Husband,Uncle,Aunt,Cousin,Other;
        }
        field(13; "Phone No."; Code[30])
        {
        }
        field(14; "Witness Name"; Text[30])
        {
        }
        field(15; "Witness National ID"; Text[30])
        {
        }
        field(16; "Witness Mobile No."; Text[30])
        {
        }
        field(17; "Witness Postal Address"; Text[30])
        {
        }
        field(19; Position; Option)
        {
            OptionCaption = 'Chairperson,Vice Chairperson,Treasurer,Secretary,Member';
            OptionMembers = Chairperson,"Vice Chairperson",Treasurer,Secretary,Member;

            trigger OnValidate()
            begin

            end;
        }
        Field(20; "Date of Birth"; Date)
        {

        }
        Field(25; Description; Text[50])
        {

        }
        field(26; "Old Relationship"; Code[100])
        {

        }
    }

    keys
    {
        key(Key1; Type, "Application No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()

    begin
        if "Application No." <> '' then begin
            GroupM.Reset();
            GroupM.SetCurrentKey("Application No.", "Line No.");
            GroupM.Ascending();
            GroupM.SetRange(GroupM."Application No.", "Application No.");
            if GroupM.FindLast() then begin
                GroupM2.Reset();
                GroupM2.SetRange(GroupM2."Application No.", GroupM."Application No.");
                GroupM2.SetRange(GroupM2."Line No.", (GroupM."Line No." + 10000));
                if GroupM2.FindFirst() then
                    Rec."Line No." := GroupM2."Line No." + 10000
                else
                    Rec."Line No." := GroupM."Line No." + 10000;
            end;
        end;
    end;

    var
        GroupM: Record "Beneficiary Type";
        GroupM2: Record "Beneficiary Type";
        Trustee: Record "Beneficiary Type";
        LineNo: Integer;
}

