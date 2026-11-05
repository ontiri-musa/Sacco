table 50024 "Priority Posting"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {

        }
        field(3; "Priority Type"; Option)
        {
            OptionMembers = " ",Loan,"Standing Order",Deposit,Charge;
            OptionCaption = ' ,Loan,Standing Order,Deposit,Charge';

            trigger OnValidate()
            var
            begin
                ClearFields();
            end;

        }
        field(4; Priority; Integer)
        {

        }
        field(5; "Calculation Type"; Option)
        {
            OptionMembers = "Flat Amount",Percentage;
            OptionCaption = 'Flat Amount,Percentage';
        }
        field(6; Amount; Decimal)
        {

        }
        field(7; "Deduction Type"; Option)
        {
            OptionMembers = " ","Principal Installment","Interest Installment","Principal Arrears","Interest Arrears";
            trigger OnValidate()
            var
                myInt: Integer;
            begin

            end;
        }
        field(8; "Overdraw Savings"; Boolean)
        {

        }
        field(9; "Priority Code"; Code[20])
        {
            TableRelation = IF ("Priority Type" = FILTER(Loan)) "Loan Product Type"
            ELSE
            IF ("Priority Type" = FILTER(Charge)) Charge
            ELSE
            IF ("Priority Type" = FILTER(Deposit)) "Account Type";

            trigger OnValidate()
            var

            begin
                if "Priority Type" = "Priority Type"::Loan then begin
                    LoanProductType.Get("Priority Code");
                    Description := LoanProductType.Description;
                end;
                if "Priority Type" = "Priority Type"::Charge then begin
                    Charge.Get("Priority Code");
                    Description := Charge.Description;
                end;
                if "Priority Type" = "Priority Type"::Deposit then begin
                    AccountType.Get("Priority Code");
                    Description := AccountType.Description;
                end;
            end;
        }
        field(10; Description; Text[50])
        {

        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Document No.", Priority)
        {
            Unique = true;
        }
    }

    var
        LoanProductType: record "Loan Product Type";
        Charge: Record Charge;
        AccountType: Record "Account Type";

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

    local procedure ClearFields()
    var
        myInt: Integer;
    begin
        Clear("Priority Code");
        Clear(Description);
        Clear("Deduction Type");
        Clear("Calculation Type");
        Clear(Amount);
        Clear(Priority);
    end;

}