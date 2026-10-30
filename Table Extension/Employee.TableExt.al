tableextension 50308 "Employee Ext" extends Employee
{
    fields

    {
        field(50000; "Basic Pay"; Decimal)
        {
        }
        field(50001; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(50002; "Pay Tax"; Boolean)
        {
        }
        field(50003; Pensonable; Boolean)
        {
        }
        field(50004; "PIN Number"; Code[20])
        {
        }
        field(50005; "Taxable Income"; Decimal)
        {
        }
        field(50006; "National ID"; Code[20])
        {
        }
        field(50007; NSSF; Code[20])
        {
        }
        field(50008; NHIF; Code[20])
        {
        }
        field(50009; "Department Name"; Code[50])
        {
        }
        field(50010; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;

            trigger OnValidate();
            begin

            end;
        }
        field(50011; Age; Text[40])
        {
        }
        field(50012; Citizenship; Code[10])
        {
        }
        field(50013; "Passport Number"; Text[20])
        {

            trigger OnValidate();
            begin

            end;
        }
        field(50015; "HELB No."; Text[20])
        {
        }
        field(50016; "Succesion Date"; Date)
        {
        }
        field(50017; "Blood Type"; Code[10])
        {
        }
        field(50018; Disability; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
        }
        field(50019; "County Code"; Code[20])
        {
        }
        field(50020; "Supervisor ID"; Code[20])
        {
            TableRelation = Employee;
        }
        field(50021; "Supervisor Name"; Text[20])
        {
        }
        field(50022; "Probation End Date"; Date)
        {
        }
        field(50023; Signature; Media)
        {
        }
        field(50024; Documents; BLOB)
        {
            Compressed = false;
            SubType = Bitmap;
        }
        field(50025; "FOSA Account"; Code[20])
        {
            TableRelation = Vendor."No." where("Member No." = field("Member No."));
        }
        field(50026; "Front Side ID"; Media)
        {

        }
        field(50027; "Back Side ID"; Media)
        {

        }
        field(50028; "PIN Attachment"; Media)
        {

        }
        field(50029; "NSSF Attachment"; Media)
        {

        }
        field(50030; "NHIF Attachment"; Media)
        {

        }
        field(50031; "Annual Leave Earned"; Decimal)
        {
        }
        field(50032; "Annual Leave Taken"; Decimal)
        {
        }
        field(50033; "Annual Leave Balance"; Decimal)
        {
            Editable = false;
        }
        field(50034; "Lost Days"; Decimal)
        {
            Editable = false;
        }
        field(50035; "Professional Membership"; Text[28])
        {
        }
        field(50036; "Type of housing"; Option)
        {
            OptionMembers = "Benefit not given","Employer's owned house","agriculture farm","House to non full time service director";
        }
        field(50037; "Employee Relation"; Option)
        {
            OptionCaption = ',Next of Kin,Dependants,Emergency Contacts';
            OptionMembers = ,"Next of Kin",Dependants,"Emergency Contacts";
        }
        field(50038; "Branch Name"; Code[40])
        {
        }
        field(50039; "Employee Type"; Option)
        {
            OptionCaption = ',Permanent,Contract,Intern,Business Representative';
            OptionMembers = ,Permanent,Contract,Intern,"Business Representative";

            trigger OnValidate();
            begin
                IF "Employee Type" = "Employee Type"::Permanent THEN BEGIN
                    HumanResSetup.GET;
                    "Probation Period" := HumanResSetup."Permanent Probation";
                    "Employee Status" := "Employee Status"::Probation;
                    "Probation End Date" := CALCDATE("Probation Period", "Employment Date");
                END;
                IF "Employee Type" = "Employee Type"::Contract THEN BEGIN
                    HumanResSetup.GET;
                    "Probation Period" := HumanResSetup."Contract Probation";
                    "Employee Status" := "Employee Status"::Active;
                    "Probation End Date" := CALCDATE("Probation Period", "Employment Date");
                END;
                IF "Employee Type" = "Employee Type"::Intern THEN BEGIN
                    HumanResSetup.GET;
                    "Probation Period" := HumanResSetup."Intern Probation";
                    "Employee Status" := "Employee Status"::Active;
                    "Probation End Date" := CALCDATE("Probation Period", "Employment Date");
                END;
                IF "Employee Type" = "Employee Type"::"Business Representative" THEN BEGIN
                    HumanResSetup.GET;
                    "Probation Period" := HumanResSetup."Contract Probation";
                    "Employee Status" := "Employee Status"::Active;
                    "Probation End Date" := CALCDATE("Probation Period", "Employment Date");
                END;
            end;
        }
        field(50040; "Probation Period"; DateFormula)
        {
        }
        field(50041; "Confirmation/Dismissal Date"; Date)
        {
        }
        field(50042; "Confirmation Status"; Option)
        {
            OptionCaption = ',Confirm,Dismiss';
            OptionMembers = ,Confirm,Dismiss;
        }
        field(50044; "Certificate No."; Code[20])
        {
        }
        field(50045; "Reference No."; Code[20])
        {
        }
        field(50046; "Date of Certificate"; Date)
        {
        }
        field(50047; Grade; Code[10])
        {
            TableRelation = Grade;
        }
        field(50048; "Defer Confirmation"; Boolean)
        {
        }
        field(50049; "Extension Duration"; DateFormula)
        {
        }
        /*   modify(Status)
          {            
              OptionCaption = 'Active,Inactive,Terminated,Probation,Confirmed,Suspended,Separated';
          } */
        field(50050; "Reason For Extension"; Text[250])
        {
        }
        field(50051; Remarks; Text[250])
        {
        }
        field(50052; "Employee Status"; Option)
        {
            OptionMembers = Active,Inactive,Terminated,Probation,Confirmed,Suspended,Separated;

        }

        field(50053; Department; Code[50])
        {
            TableRelation = "Dimension Value".code where("Dimension Code" = filter('DEPARTMENT'));
        }
        field(50054; "Staff Category"; code[50])
        {

        }
        field(50055; "Resident(Estate)"; Code[50])
        { }
        field(50056; "House No."; Code[20])
        { }
        field(50057; "Street Address/Court"; Code[20])
        { }
        field(50058; "Drivers License No."; Code[20])
        { }
        field(50059; Religion; Code[50])
        {
        }
        field(50060; Tribe; Code[50])
        {
        }
        field(50061; "Defer Start Date"; Date)
        {
            trigger OnValidate();
            begin
                TestField("Extension Duration");
                "Probation End Date" := CALCDATE("Extension Duration", "Probation End Date");
            end;
        }
        field(50062; "Defer End Date"; Date)
        {
            trigger OnValidate();
            begin
                "Probation End Date" := CALCDATE("Extension Duration", "Probation End Date");
            end;
        }
        field(50063; "Pension Non Contributor"; Boolean)
        {
            Caption = 'Pension Non Contributor';
        }

    }
    trigger OnInsert();
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Employee Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;


    end;

    trigger OnModify();
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;

        IF FORMAT(xRec) = FORMAT(Rec) THEN BEGIN
            HRManagement.CreateAuditTrail(xRec);
        END;
    end;

    var
        NoSeriesMgt: Codeunit 396;
        HRManagement: Codeunit 50050;
        HumanResSetup: Record 5218;

}