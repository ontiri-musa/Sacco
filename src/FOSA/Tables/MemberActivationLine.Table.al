table 50008 "Member Activation Line"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(4; "Account No."; Code[30])
        {
            TableRelation = IF ("Account Type" = FILTER(Vendor)) Vendor
            ELSE
            IF ("Account Type" = FILTER(Customer)) Customer;

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    Customer.GET("Account No.");
                    "Account Name" := Customer.Name;
                    "Current Account Status" := Customer.Status;
                END;
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.GET("Account No.");
                    "Account Name" := Vendor.Name;
                    "Current Account Status" := Vendor.Status;
                END;
            end;
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(5; "Account Name"; Text[50])
        {
        }
        field(6; "Current Account Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }

    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Customer: Record Customer;
        Vendor: Record Vendor;
}

