table 50702 "Key Perfomance Indicator Setup"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = ',Member,Account,ATM,MobileBanking,Deposits,Shares,Stations,Loans,Retainer,EntranceFee,Activation';
            OptionMembers = ,Member,Account,ATM,MobileBanking,Deposits,Shares,Stations,Loans,Retainer,EntranceFee,Activation;
        }
        field(4; "Account Type"; Code[10])
        {
            TableRelation = "Account Type";

            trigger OnValidate();
            begin
                IF AccountTypes.GET("Account Type") THEN BEGIN
                    "Account Name" := AccountTypes.Description;
                END;
            end;
        }
        field(5; "Account Name"; Text[100])
        {
        }
        field(6; "No. of Accounts"; Integer)
        {
        }
        field(7; "Minimum Amount"; Decimal)
        {
        }
        field(8; "Minimum Duration"; DateFormula)
        {
        }
        field(9; Frequency; DateFormula)
        {
        }
        field(10; "Entrance Fee"; Decimal)
        {
        }
        field(11; "Member Category"; Option)
        {
            OptionCaption = ',New,All';
            OptionMembers = ,New,All;
        }
        field(12; "Weighted Average"; Decimal)
        {
        }
        field(13; "Commission Value"; Decimal)
        {
        }
        field(14; "Calculation Mode"; Option)
        {
            OptionCaption = ',Flat Amount,Percentage';
            OptionMembers = ,"Flat Amount",Percentage;
        }
        field(15; "Monthly Target"; Decimal)
        {
        }
        field(16; Category; Option)
        {
            OptionCaption = ',MicroCredit Officer,Business Representative';
            OptionMembers = ,"MicroCredit Officer","Business Representative";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, Type)
        {
        }
    }

    var
        AccountTypes: Record "Account Type";
}

