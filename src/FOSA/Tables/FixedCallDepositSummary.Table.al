table 50186 "Fixed/Call Deposit Summary"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Entry No."; Integer)
        {

        }
        field(2; "FD Account No."; Code[20])
        {

        }
        field(3; "Fixed Deposit Amount"; Decimal)
        {

        }
        field(4; "Interest Rate"; Decimal)
        {

        }
        field(5; "Maturity Date"; Date)
        {

        }
        field(6; "Start Date"; Date)
        {

        }
        field(7; "Source FOSA Account"; Code[20])
        {
            TableRelation = Vendor;

        }
        field(8; "Maturity FOSA Account"; Code[20])
        {
            TableRelation = Vendor;

        }
        field(9; "Fixed Period"; DateFormula)
        {


        }
        field(10; "Capitalization Frequency"; Option)
        {
            OptionCaption = 'Monthly,Fortnightly,Weekly,Daily';
            OptionMembers = Monthly,Fortnightly,Weekly,Daily;

        }
        field(11; "Total Interest To Earn"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Fixed/Call Deposit Schedule"."Interest To Earn" where("FD Account No." = field("FD Account No.")));

        }
        field(12; "Account Opening No."; Code[20])
        {

        }
        field(13; "Total Amount To Earn"; Decimal)
        {

        }
        field(14; Posted; Boolean)
        {

        }
        field(15; "Posted Date"; Date)
        {

        }
        field(16; "Posted By"; Code[20])
        {

        }
        field(17; "Member No."; Code[20])
        {

        }
        field(18; "Member Name"; Text[50])
        {

        }
        field(20; "Status"; Option)
        {
            OptionMembers = "Pending Maturity",Matured,Revoked;

        }
        field(21; "Account Type"; Code[20])
        {

        }
        field(23; Description; Text[50])
        {

        }


    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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