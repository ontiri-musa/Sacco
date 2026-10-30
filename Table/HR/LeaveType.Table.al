table 50208 "Leave Type"
{
    // version TL2.0


    fields
    {
        field(1; Code; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
        }
        field(3; Days; Decimal)
        {
        }
        field(4; "Acrue Days"; Boolean)
        {
        }
        field(5; "Days Earned Per Month"; Decimal)
        {
        }
        field(6; Gender; Option)
        {
            OptionCaption = 'Both,Male,Female';
            OptionMembers = Both,Male,Female;
        }
        field(7; Balance; Option)
        {
            OptionCaption = 'Ignore,Carry Forward,Convert to Cash';
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(8; "Calendar Days"; Boolean)
        {

            trigger OnValidate();
            begin
                IF "Calendar Days" THEN BEGIN
                    IF Weekdays THEN BEGIN
                        ERROR(Error000);
                    END;
                END;
            end;
        }
        field(9; Weekdays; Boolean)
        {

            trigger OnValidate();
            begin
                IF Weekdays THEN BEGIN
                    IF "Calendar Days" THEN BEGIN
                        ERROR(Error000);
                    END;
                END;
            end;
        }
        field(10; "Max Carry Forward Days"; Decimal)
        {

            trigger OnValidate();
            begin
                IF Balance <> Balance::"Carry Forward" THEN
                    "Max Carry Forward Days" := 0;
            end;
        }
        field(11; "Annual Leave"; Boolean)
        {
        }
        field(12; Status; Option)
        {
            OptionMembers = Active,Inactive;
        }
        field(13; "Eligible Staff"; Option)
        {
            OptionCaption = 'All,Permanent,Contact';
            OptionMembers = All,Permanent,Contract;
        }
        field(14; "Notice Period"; Decimal)
        {
        }
        field(15; "Minimum Days Allowed"; Decimal)
        {
        }
        field(16; "Maximum Days Allowed"; Decimal)
        {
        }
        field(17; "Employment Status"; Option)
        {
            OptionCaption = 'All,Confirmed,Probation';
            OptionMembers = All,Confirmed,Probation;
        }
        field(18; "Minimum Balance Allowed"; Decimal)
        {
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

    var
        Error000: Label 'Only one option is allowed! Either Calendar Days or Weekdays!';
}

