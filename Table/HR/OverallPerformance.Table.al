table 50205 "Overall Perfomance"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal Year"; Code[20])
        {

        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; Name; Code[150])
        {

        }
        field(5; Branch; Code[20])
        {

        }
        field(6; Department; Code[100])
        {

        }
        field(7; "Job Title"; Code[100])
        {

        }
        field(8; "Employment Date"; Date)
        {

        }
        field(9; "No. of Months"; Integer)
        {

        }
        field(10; "Basic Pay"; Decimal)
        {

        }
        field(11; "Period-1"; Decimal)
        {

        }
        field(12; "Period-2"; Decimal)
        {

        }
        field(13; "Period-3"; Decimal)
        {

        }
        field(14; "Period-4"; Decimal)
        {

        }
        field(15; Average; Decimal)
        {

        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


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