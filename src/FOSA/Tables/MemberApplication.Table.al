table 50000 "Member Application"
{
    // version TL2.0

    DataCaptionFields = "No.", "Full Name";
    DrillDownPageId = "Member Application List-New";
    LookupPageId = "Member Application List-New";

    fields
    {
        field(1; "No."; Code[10])
        {
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; Surname; Text[40])
        {

            trigger OnValidate()
            begin
                Surname := UpperCase(Surname);
                "Full Name" := GetFullName;
            end;
        }
        field(3; "First Name"; Text[40])
        {

            trigger OnValidate()
            begin
                "First Name" := UpperCase("First Name");
                "Full Name" := GetFullName;
            end;
        }
        field(4; "Last Name"; Text[40])
        {

            trigger OnValidate()
            begin
                "Last Name" := UpperCase("Last Name");
                "Full Name" := GetFullName;
            end;
        }
        field(5; "National ID"; Code[10])
        {

            trigger OnValidate()
            begin
                IF "National ID" <> '' THEN BEGIN
                    IF Rec."National ID" <> '' THEN BEGIN
                        IF GlobalManagement.IsNumeric("National ID") > 0 THEN
                            ERROR(NotContainCharErr);
                    END;
                    Member.RESET;
                    Member.SETRANGE(Member."National ID", "National ID");
                    IF Member.FINDSET THEN BEGIN
                        REPEAT
                            ERROR(Text001, Member."Full Name");
                        UNTIL Member.NEXT = 0
                    END;
                END;
            end;
        }
        field(6; "Passport ID"; Code[10])
        {
        }
        field(7; "Registration No."; Code[20])
        {
        }
        field(8; Gender; Option)
        {
            OptionCaption = ' ,Male,Female,Other';
            OptionMembers = " ",Male,Female,Other;
        }
        field(9; "Date of Birth"; Date)
        {
            trigger OnValidate()
            var
                Year: array[4] of Integer;
            begin
                TestField(Category, Category::Individual);
                TestField("Age Classification");
                MemberApplicationSetup.Get();
                if MemberApplicationSetup."Enforce 18 Years and Above" then begin
                    if "Age Classification" = "Age Classification"::Adult then begin
                        IF NOT IsMemberOver18("Date of Birth") THEN
                            ERROR(MemberNotOver18Err);
                    end;
                end;
            end;
        }
        field(10; "Date of Registration"; Date)
        {
        }
        field(11; "Date of Renewal"; Date)
        {
        }
        field(12; "Phone No."; Code[30])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                IF Rec."Phone No." <> '' THEN BEGIN
                    IF GlobalManagement.IsNumeric(Rec."Phone No.") > 0 THEN
                        ERROR(NotContainCharErr);
                    MemberApplicationSetup.Get;
                    if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"07XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No.") > 10 THEN
                            ERROR(ExceedCharErr, 10);

                        IF STRLEN(Rec."Phone No.") < 10 THEN
                            ERROR(NotLessThanCharErr, 10);
                    end;
                    if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"2547XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No.") > 12 THEN
                            ERROR(ExceedCharErr, 12);

                        IF STRLEN(Rec."Phone No.") < 12 THEN
                            ERROR(NotLessThanCharErr, 12);
                    end;
                    if (Category = Category::Individual) and ("Age Classification" = "Age Classification"::Adult) then begin
                        Member.RESET;
                        Member.SETRANGE(Member."Phone No.", "Phone No.");
                        IF Member.FINDSET THEN BEGIN
                            REPEAT
                                ERROR(Text002, Member."Full Name");
                            UNTIL Member.NEXT = 0
                        END;
                    END;
                end;
            end;
        }
        field(21; "Phone No. 2"; Code[30])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                IF Rec."Phone No. 2" <> '' THEN BEGIN
                    IF GlobalManagement.IsNumeric(Rec."Phone No. 2") > 0 THEN
                        ERROR(NotContainCharErr);
                    MemberApplicationSetup.Get;
                    /* if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"07XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No. 2") > 10 THEN
                            ERROR(ExceedCharErr, 10);

                        IF STRLEN(Rec."Phone No. 2") < 10 THEN
                            ERROR(NotLessThanCharErr, 10);
                    end;
                    if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"2547XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No. 2") > 12 THEN
                            ERROR(ExceedCharErr, 12);

                        IF STRLEN(Rec."Phone No. 2") < 12 THEN
                            ERROR(NotLessThanCharErr, 12);
                    end; */
                END;
            end;
        }
        field(13; "Marital Status"; Option)
        {
            OptionCaption = 'Single,Married,Divorced,Widowed,Others';
            OptionMembers = Single,Married,Divorced,Widowed,Others;
        }
        field(14; Category; Option)
        {
            OptionCaption = 'Individual,Group,Company,Joint,Junior';
            OptionMembers = Individual,Group,Company,Joint,Junior;
        }
        field(15; Picture; Media)
        {
        }
        field(16; Signature; Media)
        {
        }
        field(17; "Front ID"; Media)
        {
        }
        field(18; "Back ID"; Media)
        {
        }
        field(19; Occupation; Code[20])
        {
        }
        field(20; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }

        field(22; "Introducer Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                Member.GET("Introducer Member No.");
                "Introducer Member Name" := Member."Full Name";
            end;
        }
        field(23; "Introducer Member Name"; Text[50])
        {
        }
        field(24; "PIN No."; Code[20])
        {
        }
        field(25; Nationality; Option)
        {
            InitValue = Kenya;
            OptionCaption = 'Nigeria,Ethiopia,Egypt,Democratic Republic of the Congo,South Africa,Tanzania,Kenya,Algeria,Uganda,Sudan,Morocco,Ghana,Mozambique,Ivory Coast,Madagascar,Angola,Cameroon,Niger,Burkina Faso,Mali,Malawi,Zambia,Senegal,Zimbabwe,Chad,Guinea,Tunisia,Rwanda,South Sudan,Benin,Somalia,Burundi,Togo,Libya,Sierra Leone,Central African Republic,Eritrea,Republic of the Congo,Liberia,Mauritania,Gabon,Namibia,Botswana,Lesotho,Equatorial Guinea,Gambia,Guinea-Bissau,Mauritius,Swaziland,Djibouti,Reunion (France),Comoros,Western Sahara,Cape Verde,Mayotte (France),Sao Tome and Principe,Seychelles';
            OptionMembers = Nigeria,Ethiopia,Egypt,"Democratic Republic of the Congo","South Africa",Tanzania,Kenya,Algeria,Uganda,Sudan,Morocco,Ghana,Mozambique,"Ivory Coast",Madagascar,Angola,Cameroon,Niger,"Burkina Faso",Mali,Malawi,Zambia,Senegal,Zimbabwe,Chad,Guinea,Tunisia,Rwanda,"South Sudan",Benin,Somalia,Burundi,Togo,Libya,"Sierra Leone","Central African Republic",Eritrea,"Republic of the Congo",Liberia,Mauritania,Gabon,Namibia,Botswana,Lesotho,"Equatorial Guinea",Gambia,"Guinea-Bissau",Mauritius,Swaziland,Djibouti,"Reunion (France)",Comoros,"Western Sahara","Cape Verde","Mayotte (France)","Sao Tome and Principe","Seychelles";
        }
        field(26; "Payroll No."; Code[10])
        {
        }
        field(27; "E-mail"; Text[30])
        {
            ExtendedDatatype = EMail;
            trigger OnValidate()
            var

            begin
                IF "E-mail" <> '' THEN BEGIN
                    IF NOT GlobalManagement.IsValidEmail(Rec."E-mail") THEN
                        ERROR(InvalidEmailErr);
                END;
            end;
        }
        field(28; "Postal Address"; Text[50])
        {
            TableRelation = "Post Code";
            trigger OnValidate()
            var
                Pcode: Record "Post Code";
            begin
                /*Pcode.Reset();
                Pcode.SetRange(Code, "Postal Address");
                if Pcode.FindFirst() then begin
                    "Physical Address" := Pcode.City;
                end;*/
            end;
        }
        field(29; "Physical Address"; Text[50])
        {

        }

        field(31; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(32; "Created Date"; Date)
        {
            Editable = false;
        }
        field(33; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(34; "Approved Date"; Date)
        {
            Editable = false;
        }

        field(37; "Created Time"; Time)
        {
            Editable = false;
        }
        field(38; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(39; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(40; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(41; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(42; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(43; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(44; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(45; "Last Modified By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(46; "Last Modified By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(47; "Last Modified By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(48; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(49; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(50; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(51; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(52; "Office Location"; Text[30])
        {
        }
        field(53; Activity; Code[30])
        {
        }
        field(55; County; Code[20])
        {
            TableRelation = County;
        }
        field(54; "Registration Certificate"; Media)
        {
        }


        field(59; "Branch Name"; Text[50])
        {

            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Full Name"; Text[150])
        {
            trigger OnValidate()
            var

            begin
                "Full Name" := UpperCase("Full Name");
            end;

        }

        field(64; "Agent Code"; Code[20])
        {
            TableRelation = "Remittance Agent Setup"
            ;
        }
        field(65; "Registration Date"; Date)
        {
        }
        field(66; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Editable = false;
        }
        field(67; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;
        }
        field(68; "Loan Officer ID"; Code[30])
        {
            TableRelation = "Loan Recovery Officer Setup";
            trigger OnValidate()
            var
                LoanOfficerSetup: Record "Loan Recovery Officer Setup";
            begin
                LoanOfficerSetup.Get("Loan Officer ID");
                LoanOfficerSetup.TestField("Global Dimension 1 Code");
                "Global Dimension 1 Code" := LoanOfficerSetup."Global Dimension 1 Code";
            end;

        }
        field(69; "Group Meeting Frequency"; DateFormula)
        {

        }
        field(70; "Group Paybill Code"; Code[20])
        {

        }
        field(71; "Social Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Social Name" := UPPERCASE("Social Name");
            end;
        }
        field(72; "Home Village"; Code[70])
        {
        }
        field(73; "Nearest LandMark"; Code[100])
        {
        }
        field(74; "Group Link No."; Code[20])
        {
            TableRelation = IF ("Group Link Type" = FILTER("Link to New Group")) "Member Application" WHERE(Status = FILTER(New),
                                                                                                          Category = FILTER(Group))
            ELSE
            IF ("Group Link Type" = FILTER("Link to Existing Group")) "Member" WHERE(Category = FILTER(Group));
        }
        field(75; "Group Registration No."; Code[30])
        {

            trigger OnValidate()
            begin
                /*  IF CheckFieldExist("Group Registration No.", 14) THEN
                     ERROR(Error001, FIELDCAPTION("Group Registration No.")); */
            end;
        }

        field(76; "Group Meeting Day"; Option)
        {
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(77; "Group Meeting Time"; Time)
        {
        }

        field(78; "Group Meeting Venue"; Code[30])
        {
        }
        field(79; "Date of Registration GR"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                // IF "Date of Registration" > TODAY THEN
                //  ERROR(FutureDateErr, FieldCaption("Date of Registration"));
            end;
        }
        field(80; "Min. Contribution per Meeting"; Decimal)
        {
        }
        field(81; "No. of Subgroups"; Integer)
        {
        }
        field(82; "Group Certificate"; Media)
        {
        }
        field(83; "Group Meeting Frequency Option"; Option)
        {
            Caption = 'Group Meeting Frequency';
            OptionCaption = ' ,Weekly,Fortnightly,Monthly';
            OptionMembers = " ",Weekly,Fortnightly,Monthly;

            trigger OnValidate()
            begin
                IF "Group Meeting Frequency Option" = "Group Meeting Frequency Option"::Weekly THEN
                    EVALUATE("Group Meeting Frequency", '1W');
                IF "Group Meeting Frequency Option" = "Group Meeting Frequency Option"::Fortnightly THEN
                    EVALUATE("Group Meeting Frequency", '2W');
                IF "Group Meeting Frequency Option" = "Group Meeting Frequency Option"::Monthly THEN
                    EVALUATE("Group Meeting Frequency", '1M');
            end;
        }

        field(85; "Is Group Official"; Boolean)
        {
        }
        field(86; "Group Official Position"; Option)
        {
            OptionCaption = ' ,ChairPerson,Secretary,Treasurer';
            OptionMembers = " ",ChairPerson,Secretary,Treasurer;
        }
        field(87; "Last Meeting Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "Last Meeting Date" > TODAY THEN
                    ERROR(FutureDateErr, FIELDCAPTION("Last Meeting Date"));
            end;
        }
        field(88; "Group Link Type"; Option)
        {
            OptionCaption = ' ,Link to New Group,Link to Existing Group';
            OptionMembers = " ","Link to New Group","Link to Existing Group";
        }
        field(89; "No. of Members"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE("Group Link No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Huduma No."; Code[20])
        {

        }
        field(91; "Current Residence"; Code[20])
        {

        }
        field(92; "Home Ownership"; Option)
        {
            OptionCaption = 'Rented,Self';
            OptionMembers = Rented,Self;
        }
        field(93; "Picture Path"; Text[250])
        {
        }
        field(94; "Front ID Path"; Text[250])
        {
        }
        field(95; "Back ID Path"; Text[250])
        {
        }
        field(96; "Signature Path"; Text[250])
        {
        }
        field(100; "Age Classification"; Option)
        {
            OptionMembers = " ",Adult,Junior;
            OptionCaption = ' ,Adult,Junior';

            trigger OnValidate()
            var

            begin
                TestField(Category, Category::Individual);
            end;
        }
        field(101; "Church District Code"; Code[20])
        {
            TableRelation = "Church District";
        }
        field(102; "Church Section Code"; Code[20])
        {
            TableRelation = "Church Section" where("Church District Code" = field("Church District Code"));
        }
        field(103; "Church Code"; Code[30])
        {
            TableRelation = Church;
        }
        field(104; "Pastor Name"; Text[50])
        {
            trigger OnValidate()
            var

            begin
                "Pastor Name" := UpperCase("Pastor Name");
            end;
        }
        field(105; "Pastor Phone No."; Code[20])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                IF Rec."Phone No." <> '' THEN BEGIN
                    IF GlobalManagement.IsNumeric(Rec."Phone No.") > 0 THEN
                        ERROR(NotContainCharErr);
                    MemberApplicationSetup.Get;
                    if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"07XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No.") > 10 THEN
                            ERROR(ExceedCharErr, 10);

                        IF STRLEN(Rec."Phone No.") < 10 THEN
                            ERROR(NotLessThanCharErr, 10);
                    end;
                    if MemberApplicationSetup."Phone No. Format" = MemberApplicationSetup."Phone No. Format"::"2547XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No.") > 12 THEN
                            ERROR(ExceedCharErr, 12);

                        IF STRLEN(Rec."Phone No.") < 12 THEN
                            ERROR(NotLessThanCharErr, 12);
                    end;
                END;
            end;
        }
        field(109; "Sub Category"; Option)
        {
            OptionCaption = ' ,Staff,Board Member,Pastor';
            OptionMembers = " ",Staff,"Board Member",Pastor;
        }
        field(114; "Group Sub Category"; Option)
        {
            OptionCaption = ' ,Self Help,Church';
            OptionMembers = " ","Self Help",Church;
        }
        field(115; "Parent Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                Member.GET("Parent Member No.");
                "Parent Member Name" := Member."Full Name";
                "Parent Phone No." := Member."Phone No.";
            end;
        }
        field(116; "Parent Member Name"; Text[50])
        {
        }
        field(117; "Parent Phone No."; Code[30])
        { }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Full Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Full Name", "Global Dimension 1 Code")
        {
        }
    }

    trigger OnInsert()
    begin
        MemberApplicationSetup.GET;
        CASE Category OF
            Category::Individual:
                BEGIN
                    MemberApplicationSetup.TestField("MA Individual Nos.");
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(MemberApplicationSetup."MA Individual Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
            Category::Group:
                BEGIN
                    MemberApplicationSetup.TestField("MA Group Nos.");
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(MemberApplicationSetup."MA Group Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
            Category::Company:
                BEGIN
                    MemberApplicationSetup.TestField("MA Company Nos.");
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(MemberApplicationSetup."MA Company Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
            Category::Joint:
                BEGIN
                    MemberApplicationSetup.TestField("MA Joint Nos.");
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(MemberApplicationSetup."MA Joint Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
        END;
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Created By" := USERID;
        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Registration Date" := Today;

        "Created Time" := TIME;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        // "Loan Officer ID" := UserId;
    end;

    trigger OnModify()
    begin
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        "Last Modified By Host IP" := HostIP;
        "Last Modified By Host MAC" := HostMac;
        "Last Modified By Host Name" := HostName;
        "Last Modified Date" := TODAY;
        "Last Modified Time" := TIME;
        "Last Modified By" := USERID;
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::New);
    end;

    var
        Member: Record Member;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalSetup: Record "Global Setup";
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;

        Text001: Label 'Identification Number has been used before for %1.Kindly check your No.';
        Text002: Label 'Phone Number has been used before for %1.Kindly check your No.';

    procedure AddNewGroupMember()
    var
        MemberApplication: Record "Member Application";

    begin
        MemberApplicationSetup.GET;
        MemberApplication.INIT;
        MemberApplication."No." := NoSeriesManagement.GetNextNo(MemberApplicationSetup."MA Individual Nos.", TODAY, TRUE);
        MemberApplication."Group Link Type" := MemberApplication."Group Link Type"::"Link to New Group";
        MemberApplication."Group Link No." := "No.";
        MemberApplication.Category := MemberApplication.Category::Individual;
        MemberApplication."Created By" := USERID;
        MemberApplication."Created Date" := TODAY;
        MemberApplication."Created Time" := TIME;
        MemberApplication."Loan Officer ID" := USERID;
        MemberApplication.VALIDATE("Loan Officer ID");
        MemberApplication."Created Date" := TODAY;
        MemberApplication."Created Time" := TIME;
        GlobalManagement.GetHostInfo(HostName, HostIP, HostMac);
        MemberApplication."Created By Host IP" := HostIP;
        MemberApplication."Created By Host MAC" := HostMac;
        MemberApplication."Created By Host Name" := HostName;
        MemberApplication.INSERT;
        MemberApplication.GET(MemberApplication."No.");
        PAGE.RUN(50000, MemberApplication);
    end;

    procedure ValidateFields()
    begin
        CASE Category OF
            Category::Individual:
                BEGIN
                    //TESTFIELD(Surname);
                    TESTFIELD("First Name");
                    //TESTFIELD("Last Name");
                    if "Age Classification" = "Age Classification"::Adult then begin
                        TESTFIELD("National ID");
                        TESTFIELD("Phone No.");
                    end;
                    TESTFIELD("Date of Birth");
                    TESTFIELD("Age Classification");
                    //TESTFIELD("Global Dimension 1 Code");
                    //TESTFIELD(Occupation);
                    // TESTFIELD("PIN No.");

                    // TESTFIELD(Picture);
                    //TESTFIELD(Signature);
                    //TESTFIELD("Front ID");
                    //TESTFIELD("Back ID");
                    if "Age Classification" = "Age Classification"::Junior then begin
                        TestField("Parent Member No.");
                        TestField("Parent Member No.");
                    end;
                    TestField("Church District Code");
                    TestField("Church Section Code");
                    TestField("Church Code");
                END;
            Category::Group:
                BEGIN
                    TESTFIELD("Full Name");
                    TESTFIELD(Activity);
                    TESTFIELD("Date of Registration GR");
                    // TESTFIELD("Registration No.");
                    //TESTFIELD("Office Location");
                    //TESTFIELD(Picture);
                    //TESTFIELD("Registration Certificate");
                    //TESTFIELD("Phone No.");
                    TestField("Church District Code");
                    TestField("Church Section Code");
                    TestField("Church Code");
                END;
            Category::Company:
                BEGIN
                    TESTFIELD("Full Name");
                    TESTFIELD(Activity);
                    // TESTFIELD("Date of Registration");
                    TESTFIELD("PIN No.");
                    TESTFIELD("Office Location");
                    //TESTFIELD(Picture);
                    //TESTFIELD("Registration Certificate");
                    TESTFIELD("Phone No.");
                    TestField("Church District Code");
                    TestField("Church Section Code");
                    TestField("Church Code");
                END;
            Category::Joint:
                BEGIN
                    TESTFIELD("Full Name");
                    TESTFIELD(Activity);
                    TESTFIELD("National ID");
                    TESTFIELD("PIN No.");
                    TESTFIELD(Picture);
                    TESTFIELD("Phone No.");
                    TestField("Church District Code");
                    TestField("Church Section Code");
                    TestField("Church Code");

                END;
        END;
    end;

    procedure HasNextofKin(): Boolean
    var
        BeneficiaryType: Record "Beneficiary Type";
    begin
        BeneficiaryType.Reset();
        BeneficiaryType.SetRange("Application No.", "No.");
        BeneficiaryType.SetRange(Type, BeneficiaryType.Type::"Next of Kin");
        exit(BeneficiaryType.FindFirst())
    end;

    local procedure GetFullName(): Text[100]
    begin
        EXIT(UpperCase("First Name") + ' ' + UpperCase("Last Name") + ' ' + UpperCase(Surname));
    end;



    local procedure IsMemberOver18(Variant: Date): Boolean
    var
        Year: array[4] of Integer;
    begin
        Year[1] := DATE2DMY(Variant, 3);
        Year[2] := DATE2DMY(TODAY, 3);
        IF (Year[2] - Year[1]) >= 18 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    var
        i: Integer;
        NotContainCharErr: Label 'Phone No. cannot contain characters.';
        ExceedCharErr: Label 'Phone No. cannot exceed %1 characters.';
        NotLessThanCharErr: Label 'Phone No. cannot be less than %1 characters.';
        MemberApplicationSetup: Record "Member Application Setup";
        InvalidEmailErr: Label 'Email Address is not valid';
        MemberNotOver18Err: Label 'Member must be 18 years and above.';
        FutureDateErr: Label '%1 cannot be future date';
        GlobalManagement: Codeunit "Global Management";
        UserSetup: Record "User Setup";

}

