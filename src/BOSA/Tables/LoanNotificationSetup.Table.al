table 56153 "Loan Notification Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "First Notification Template"; Text[250])
        {
        }
        field(3; "Second Notification Template"; Text[250])
        {
        }
        field(4; "Third Notification Template"; Text[250])
        {
        }
        field(5; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(6; "Fourth Notification Template"; Text[250])
        {
        }
        field(7; "First Default Template"; Text[250])
        {
        }
        field(8; "Second Default Template"; Text[250])
        {
        }
        field(9; "Third Default Template"; Text[250])
        {
        }
        field(10; "Fourth Default Template"; Text[250])
        {
        }
        field(15; "Default SMS Nos"; Code[250])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetDemandLetterTemplate(var NewDemandLetterTemplate: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
    begin
        //CLEAR("Demand Letter Template");
        IF NewDemandLetterTemplate = '' THEN
            EXIT;
        //"Demand Letter Template".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewDemandLetterTemplate);
        MODIFY;
    end;

    procedure GetDemandLetterTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        SMSText: Text;
        IStream: InStream;
    begin
        // CALCFIELDS("Demand Letter Template");
        // IF NOT "Demand Letter Template".HASVALUE THEN
        //  EXIT('');
        //"Demand Letter Template".CREATEinSTREAM(IStream);
        IStream.READ(SMSText);
        exit(SMSText);
    end;
}

