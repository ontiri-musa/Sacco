table 50039 "Remittance Agent Setup"
{
    // version TL2.0


    fields
    {

        field(1; Code; Code[20])
        {
            TableRelation = IF (Type = filter(Employee)) Employee
            ELSE
            IF (Type = filter(Factory)) Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                Employee.Get(Code);
                Name := Employee.FullName();
            end;
        }
        field(2; Name; Text[50])
        {

            trigger OnValidate()
            begin
                Name := UPPERCASE(Name);
            end;
        }
        field(3; Type; Option)
        {
            OptionMembers = Employee,Factory;
        }
        field(6; "Account Type"; Enum "Gen. Journal Account Type")
        {

            trigger OnValidate()
            var

            begin
                if "Account Type" in ["Account Type"::"Fixed Asset", "Account Type"::"IC Partner"] then
                    Error(AccountTypeNotAllowed, "Account Type");
            end;
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = filter(Customer)) Customer where("Customer Type" = filter(Normal))
            ELSE
            IF ("Account Type" = filter(Vendor)) Vendor where("Vendor Type" = filter(Checkoff))
            ELSE
            IF ("Account Type" = filter("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = filter("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = filter("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin

            end;
        }
        field(8; "Controll Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
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
        AccountTypeNotAllowed: Label '%1 is not allowed';
        Vendor: Record Vendor;
        Customer: Record Customer;
}

