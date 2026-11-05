table 50078 "Bulk SMS Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[20]) { }
        field(3; "Short Code"; Code[20]) { }
        field(4; "API Key"; Text[50]) { }
        field(5; "Partner ID"; Code[20]) { }
        field(6; "User Name"; text[50]) { }
        field(7; Password; text[50]) { }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}