table 50006 Member
{
    // version TL2.0

    DataCaptionFields = "No.", "Full Name";
    DrillDownPageID = 50039;
    LookupPageID = 50039;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; Surname; Text[50])
        {
            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + Surname;
            end;
        }
        field(3; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + Surname;
            end;
        }
        field(4; "Last Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + Surname;
            end;
        }
        field(5; "National ID"; Code[20])
        {

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
            OptionCaption = 'Active,Dormant,Suspended,Withdrawn,Deceased,Reinstated,Blocked';
            //OptionCaption = 'Active,Dormant,Suspended,Withdrawn,Deceased,Reinstated,Blocked';
            OptionMembers = Active,Dormant,Suspended,Withdrawn,Deceased,Reinstated,Blocked;
        }

        field(22; "Introducer Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(23; "Introducer Member Name"; Text[50])
        {
        }
        field(24; "PIN No."; Code[20])
        {
        }
        field(25; Nationality; Option)
        {
            OptionCaption = 'Kenya,Uganda,Tanzania';
            OptionMembers = Kenya,Uganda,Tanzania;
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
        }
        field(29; "Physical Address"; Text[50])
        {
        }
        field(30; "Mobile Banking Member"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Mobile Banking Member" where("Phone No." = field("Phone No."), Status = filter(Active)));
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
        field(34; "Approval Date"; Date)
        {
            Editable = false;
        }
        field(36; "Application No."; Code[20])
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
        field(54; "Registration Certificate"; Media)
        {
        }

        field(58; "Member Classification"; Option)
        {
            OptionCaption = ',Staff,Board';
            OptionMembers = ,Staff,Board;
        }
        field(59; "Branch Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Full Name"; Text[250])
        {
        }
        field(64; "Agent Code"; Code[20])
        {
            TableRelation = "Remittance Agent Setup";
        }
        field(65; "Registration Date"; Date)
        {
        }
        field(66; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                //  ValidateShortcutDimCode(1, "Global Dimension 1 Code",0,'');
            end;
        }
        field(67; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(68; "Loan Officer ID"; Code[30])
        {
            TableRelation = "Loan Recovery Officer Setup";
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
        field(79; "Group Registration Date"; Date)
        {
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
                IF "Last Meeting Date" > TODAY THEN;
                // ERROR(Error005, FIELDCAPTION("Last Meeting Date"));
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
        field(91; "Current Residence"; Code[90])
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
        field(97; "Registration Fee Paid"; Decimal)
        {
        }
        field(98; "Registration Fee Receipt No."; Code[30])
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
        field(101; "Church District Code"; Code[150])
        {
            TableRelation = "Church District";

        }
        field(102; "Church Section Code"; Code[150])
        {
            TableRelation = "Church Section" where("Church District Code" = field("Church District Code"));
            trigger OnValidate()
            var
                ChrchSect: Record "Church Section";
            begin
                if ChrchSect.Get(Rec."Church Section Code") then begin
                    Rec."Section Name" := ChrchSect.Name;
                end;
            end;
        }
        field(103; "Church Code"; Code[150])
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
        field(106; "Old Member Status"; Option)
        {
            OptionCaption = 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Applicant,Rejected,New';
            OptionMembers = Active,"Non-Active",Blocked,Dormant,"Re-instated",Deceased,Withdrawal,Retired,Termination,Resigned,"Ex-Company",Casuals,"Family Member",Defaulter,Applicant,Rejected,New;
        }
        field(107; "Updated On Portal"; Boolean)
        {
        }
        field(108; "Section Name"; Text[100])
        {

        }
        field(109; "Sub Category"; Option)
        {
            OptionCaption = ' ,Staff,Board Member,Pastor';
            OptionMembers = " ",Staff,"Board Member",Pastor;
        }

        field(110; "Loan Outstanding Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No.")));
            Editable = false;
        }
        field(111; "Loan Outstanding Principal"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Transaction Type Code" = filter('PPAID|NEWLOAN')));
            Editable = false;
        }
        field(112; "Loan Outstanding Interest"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Transaction Type Code" = filter('INTPAID|INTDUE')));
            Editable = false;
        }
        field(113; "Dormancy Status"; Option)
        {
            OptionCaption = 'Active,Blocked,Dormant,Frozen,Closed';
            OptionMembers = Active,Blocked,Dormant,Frozen,Closed;
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
        field(118; "Junior Account Number"; Code[80])
        {
        }
        field(120; "Category1"; Integer)
        {
        }

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
        GlobalSetup.GET;

    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
        Error(DeleteNotAllowedMsg);
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GlobalSetup: Record "Global Setup";
        MemberApplication: Record "Member Application";
        // CBSManagement: Codeunit "50000";
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;
        DimMgt: Codeunit DimensionManagement;
        Member: Record Member;
        DeleteNotAllowedMsg: Label 'Delete not allowed.';
        i: Integer;
        Text002: Label 'Phone Number has been used before for %1.Kindly check your No.';
        NotContainCharErr: Label 'Phone No. cannot contain characters.';
        ExceedCharErr: Label 'Phone No. cannot exceed %1 characters.';
        NotLessThanCharErr: Label 'Phone No. cannot be less than %1 characters.';
        MemberApplicationSetup: Record "Member Application Setup";
        InvalidEmailErr: Label 'Email Address is not valid.';
        MemberNotOver18Err: Label 'Member must be 18 years and above.';
        GlobalManagement: Codeunit "Global Management";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;
}

