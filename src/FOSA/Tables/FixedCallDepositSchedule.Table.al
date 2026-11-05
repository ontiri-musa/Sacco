table 50185 "Fixed/Call Deposit Schedule"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "FD Account No."; Code[20])
        {

        }
        field(2; "Line No."; Integer)
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
        field(11; "Interest To Earn"; Decimal)
        {


        }
        field(12; "Account Opening No."; Code[20])
        {

        }
        field(13; "Next Due Date"; Date)
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
        field(20; "Status"; Option)
        {
            OptionMembers = "To Earn",Earned,Revoked;

        }


    }

    keys
    {
        key(Key1; "FD Account No.", "Line No.")
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