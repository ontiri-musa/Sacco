table 50606 "Transaction Line"
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
        field(3; "Member No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF Customer.GET("Member No.") THEN
                    "Member Name" := Customer.Name;
            end;
        }
        field(4; "Account No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF Vendor.GET("Account No.") THEN
                    "Account Name" := Vendor.Name;

            end;
        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Line Amount"; Decimal)
        {
        }
        field(7; "Member Name"; Text[50])
        {
            Editable = false;
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
        Customer: Record Customer;
        Vendor: Record Vendor;
}

