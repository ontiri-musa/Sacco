table 50153 "Loan Defaulter Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "First Notice Template"; Text[250])
        {
        }
        field(3; "Second Notice Template-Member"; Text[250])
        {
        }
        field(4; "Third Notice-Member"; Text[250])
        {
        }
        field(5; "Third Notice-Guarantor"; Text[250])
        {
        }
        field(6; "Attach on"; Option)
        {
            OptionCaption = 'First Notice,Second Notice,Third Notice';
            OptionMembers = "First Notice","Second Notice","Third Notice";
        }
        field(7; "Grace Period"; DateFormula)
        {
        }
        field(8; "Demand Letter Template"; BLOB)
        {
        }
        field(9; "Second Notice-Guarantor"; Text[250])
        {
        }
        field(10; "Notify Guarantor"; Boolean)
        {
        }
        field(11; "Notify Member"; Boolean)
        {
        }
        field(12; "Notification Channel"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(16; "Loan Defaulter Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(17; "Loan Defaulter Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Defaulter Template Name"));
        }
        field(30; "Defaulter Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(31; "Defaulter Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Defaulter Template Name"));
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
        CLEAR("Demand Letter Template");
        IF NewDemandLetterTemplate = '' THEN
            EXIT;
        "Demand Letter Template".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewDemandLetterTemplate);
        MODIFY;
    end;

    procedure GetDemandLetterTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        SMSText: Text;
        IStream: InStream;
    begin
        CALCFIELDS("Demand Letter Template");
        IF NOT "Demand Letter Template".HASVALUE THEN
            EXIT('');
        "Demand Letter Template".CREATEinSTREAM(IStream);
        IStream.READ(SMSText);
        exit(SMSText);
    end;
}

