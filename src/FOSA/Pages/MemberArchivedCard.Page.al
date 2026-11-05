page 59011 "Member Archived Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Related,Accounts,Category 6,Category 7,Category 8';
    SourceTable = Member;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            field(Category; Category)
            {
                Visible = false;
                trigger OnValidate()
                begin
                    SetVisible;
                end;
            }
            group(Individual)
            {
                Caption = 'Individual';
                Visible = IsVisibleIndividual;
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                field(Surname; Surname)
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("Passport ID"; "Passport ID")
                {
                    ApplicationArea = All;
                }
                field("Age Classification"; "Age Classification")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = All;
                }
                field("Marital Status"; "Marital Status")
                {
                    ApplicationArea = All;
                }
                field(AccountCat; Category)
                {
                    Caption = 'Account Category';
                    ApplicationArea = All;
                }
                field("Sub Category"; "Sub Category")
                {
                    Caption = 'Account Sub Category';
                    ApplicationArea = All;
                }
                field(Occupation; Occupation)
                {
                    ApplicationArea = All;
                }
                group("GroupLink")
                {
                    Caption = '';
                    Visible = Category = 0;
                    field("Group Link Type"; "Group Link Type")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            "Group Link No." := '';
                        end;
                    }
                    group(GroupLinkNo)
                    {
                        Caption = '';
                        Visible = "Group Link Type" > 0;
                        field("Group Link No."; "Group Link No.")
                        {
                            ApplicationArea = All;
                        }
                    }

                }
                field("Introducer Member No."; "Introducer Member No.")
                {
                    ApplicationArea = All;
                }
                field("Introducer Member Name"; "Introducer Member Name")
                {
                    ApplicationArea = All;
                }
                field("PIN No."; "PIN No.")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Nationality)
                {
                    ApplicationArea = All;
                }
                field("Payroll No."; "Payroll No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }

                group(IsGroupOfficial)
                {
                    Caption = '';
                    Visible = "Group Link Type" > 0;
                    field("Is Group Official"; "Is Group Official")
                    {
                        ApplicationArea = All;
                    }
                }
                group(GroupOfficialPosition)
                {
                    Caption = '';
                    Visible = "Is Group Official" = true;
                    field("Group Official Position"; "Group Official Position")
                    {
                        ApplicationArea = All;
                    }
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            group("Group Details")
            {
                Caption = 'Group';
                Visible = IsVisibleGroup;
                field("Group Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Group Registration No."; "Registration No.")
                {
                    Caption = ' Registration No.';
                    ApplicationArea = All;
                }
                field("Group Date of Registration"; "Date of Registration")
                {
                    Caption = ' Date of Registration';
                    ApplicationArea = All;
                }

                // field("<Group Date of Renewal>"; "Date of Renewal")
                // {
                //     Caption = ' Date of Renewal';
                // }
                field("Group Meeting Day"; "Group Meeting Day")
                {
                    ApplicationArea = All;
                }
                field("Group Meeting Time"; "Group Meeting Time")
                {
                    ApplicationArea = All;
                }
                field("Group Meeting Frequency Option"; "Group Meeting Frequency Option")
                {
                    ApplicationArea = All;
                }
                field("Group Meeting Venue"; "Group Meeting Venue")
                {
                    ApplicationArea = All;
                }
                field("Last Meeting Date"; "Last Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Min. Contribution per Meeting"; "Min. Contribution per Meeting")
                {
                    ApplicationArea = All;
                }

                field("Office Location"; "Office Location")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("No. of Members"; "No. of Members")
                {
                    ApplicationArea = All;
                }
                field("Group Paybill Code"; "Group Paybill Code")
                {
                    ApplicationArea = All;
                }

                field("Group Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Group Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }

                field(GroupStatus; Status)
                {
                    ApplicationArea = All;
                }

            }
            group("Company Details")
            {
                Caption = 'Company';
                Visible = IsVisibleCompany;
                field("Company Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; "Registration No.")
                {
                    ApplicationArea = All;
                }

                field("Date of Registration"; "Date of Registration")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

                field("Company Activity"; Activity)
                {
                    Caption = 'Company Activity';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Company KRA PIN"; "PIN No.")
                {
                    Caption = ' KRA PIN';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

                field("Company Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(CompanyStatus; Status)
                {
                    ApplicationArea = All;
                }
            }
            group(Joint)
            {
                Caption = 'Joint';
                Visible = IsVisibleJoint;
                field("Joint Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Joint ID"; "National ID")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Joint Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(JointStatus; Status)
                {
                    ApplicationArea = All;
                }

            }
            group(Church)
            {
                field("Church District Code"; "Church District Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Church Section Code"; "Church Section Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Church Code"; "Church Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Pastor Name"; "Pastor Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Pastor Phone No."; "Pastor Phone No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                field("E-mail"; "E-mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Phone No. 2"; "Phone No. 2")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Postal Address"; "Postal Address")
                {
                    ApplicationArea = All;
                }
                field("Physical Address"; "Physical Address")
                {
                    ApplicationArea = All;
                }
                group("Residence")
                {
                    Caption = '';
                    Visible = Category = 0;
                    field("Current Residence"; "Current Residence")
                    {
                        ApplicationArea = All;
                    }
                    field("Home Ownership"; "Home Ownership")
                    {
                        ApplicationArea = All;
                    }
                    field("Home Village"; "Home Village")
                    {
                        ApplicationArea = All;
                    }
                    field("Nearest LandMark"; "Nearest LandMark")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Audit)
            {
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Page; 50041)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            part("Member Picture"; "Member Picture")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisiblePicture;
            }

            part("Member Front ID"; "Member Front ID")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleFrontID;
            }
            part("Member Back ID"; "Member Back ID")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleBackID;
            }
            part("Member Signature"; "Member Signature")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleSignature;
            }
            part("Member Reg. Certficate"; "Member Reg. Certficate")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleCR;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Bank Accounts")
            {
                ApplicationArea = All;
                Ellipsis = true;
                Image = BankAccount;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Member Bank Accounts List";
                RunPageLink = "Member No." = field("No.");
            }
            action("Member Nominees")
            {
                ApplicationArea = All;
                Ellipsis = true;
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;
                RunObject = page Nominees;
                RunPageLink = "Application No." = field("No.");
            }
            action("Next of Kin")
            {
                Ellipsis = true;
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;
                ApplicationArea = All;
                RunObject = page "Next of Kin";
                RunPageLink = "Application No." = field("Application No.");
            }
            action(Agencies)
            {
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;//IsVisibleIndividual;
                ApplicationArea = All;
                RunObject = page "Member Agencies";
                RunPageLink = "Application No." = field("No.");
            }
            action("Monthly Contributions")
            {
                Ellipsis = true;
                Image = ElectronicPayment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                RunObject = page "Member Contribution";
                RunPageLink = "Application No." = field("No.");
            }
            action("Group Members")
            {
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleGroup;
                ApplicationArea = All;
                RunObject = page "Group Member";
                RunPageLink = "Application No." = field("No.");

            }
            action("Group Trustees")
            {
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleGroup;
                ApplicationArea = All;
                RunObject = page "Group Trustee";
                RunPageLink = "Application No." = field("No.");

            }
            action("Company Signatories")
            {
                Image = Company;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleCompany;
                ApplicationArea = All;
                RunObject = page "Company Trustee";
                RunPageLink = "Application No." = field("No.");

            }

            action("Joint Members")
            {
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleJoint;
                ApplicationArea = All;
                // RunObject = page joint;

            }
            action("Savings/Deposit Accounts")
            {
                Image = MapAccounts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Member S/Dep. Account List";
                RunPageLink = "Member No." = field("No.");

            }
            action("Loan Accounts")
            {
                Image = SocialListening;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Member Loan Account List";
                RunPageLink = "Member No." = field("No.");

            }
            group(Reports)
            {

                action(Statement)
                {
                    Image = SocialListening;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Vendor.FILTERGROUP(10);
                        Vendor.SETRANGE("Member No.", Rec."No.");
                        Vendor.FILTERGROUP(0);
                        Report.RUN(50082, true, false, Vendor);
                    end;
                }

                action(LoanStatement)
                {
                    Caption = 'Loan Statement';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        LoanApplication.FILTERGROUP(10);
                        LoanApplication.SETRANGE("Member No.", Rec."No.");
                        LoanApplication.FILTERGROUP(0);
                        Report.RUN(50081, true, false, LoanApplication);
                    end;
                }
                action("Member Statement-Combined")
                {
                    Caption = 'Member Statement-Combined';
                    Image = BankAccountStatement;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;


                    trigger OnAction()
                    begin
                        Rec.FILTERGROUP(10);
                        Rec.SETRANGE("No.", Rec."No.");
                        Rec.SetRange("No.", Rec."No.");
                        Rec.FILTERGROUP(0);
                        Report.RUN(50087, true, false, Rec);
                    end;
                }

                action(LoanGuaranteed)
                {
                    Caption = 'Loans Guaranteed';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.SETRANGE("No.", Rec."No.");
                        Rec.SetRange("No.", Rec."No.");
                        Rec.FILTERGROUP(0);
                        Report.RUN(50006, true, false, Rec);
                    end;
                }

                action(LoanGuarantors)
                {
                    Caption = 'Loan Guarantors';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        LoanApplication.FILTERGROUP(10);
                        LoanApplication.SETRANGE("Member No.", Rec."No.");
                        LoanApplication.FILTERGROUP(0);
                        Report.RUN(50086, true, false, LoanApplication);
                    end;
                }
                action(Testing)
                {
                    Caption = 'Test';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        i := 0;
                        CustLedgerEntry.RESET;
                        CustLedgerEntry.SETRANGE(CustLedgerEntry."Customer No.", 'BLN10043');
                        CustLedgerEntry.SETASCENDING("Entry No.", FALSE);
                        //CustLedgerEntry.SETRANGE(Reversed, FALSE);
                        if CustLedgerEntry.findset then begin
                            Message('%1 for all ', CustLedgerEntry.Count);
                            repeat
                                i += 1;
                                Message('%1', CustLedgerEntry.Description);
                            until CustLedgerEntry.Next() = 0;
                            Message('in with %1', i);
                        end;
                    end;
                }

                action(CreateMissingAccount)
                {
                    Caption = 'CreateMissingAccount';
                    Image = Print;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        Length: Integer;
                        vendL: Record "Vendor Ledger Entry";
                        BoreshaAc: Code[20];
                        NextGenAc: code[20];
                    begin
                        Member.Reset();
                        if Member.FindSet then begin
                            repeat
                                BoreshaAc := '';
                                NextGenAc := '';

                                BoreshaAc := Member."No." + '06';
                                NextGenAc := Member."No." + '04';

                                vendL.Reset();
                                vendL.SetRange(vendL."Vendor No.", BoreshaAc);
                                if vendL.FindFirst then begin
                                    AccountType.RESET;
                                    AccountType.SETRANGE(AccountType.Code, '06');
                                    if AccountType.FindFirst then begin
                                        AccountNo := Member."No." + AccountType.Code;
                                        Vendor.INIT;
                                        Vendor."No." := AccountNo;
                                        Vendor.Name := AccountType.Description;
                                        Vendor."Vendor Posting Group" := AccountType."Posting Group";
                                        Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        Vendor."Phone No." := Member."Phone No.";
                                        Vendor."E-Mail" := Member."E-mail";
                                        Vendor."Account Type" := AccountType.Code;
                                        Vendor."Member No." := Member."No.";
                                        Vendor.Status := Vendor.Status::Active;
                                        Vendor."Member Name" := Member."Full Name";
                                        Vendor."Vendor Type" := Vendor."Vendor Type"::FOSA;
                                        Vendor.INSERT;
                                    end;
                                end;
                            until Member.Next = 0;
                        end;


                        /*Vendor.Reset;
                         Vendor.SetRange(Vendor."Member No.", "No.");
                         if Vendor.FindFirst = false then begin
                             Member.Reset;
                             Member.SetRange(Member."No.", "No.");
                             if Member.FindFirst then begin
                                 if Member.Category = Member.Category::Individual then begin
                                     AccountType.RESET;
                                     AccountType.SETRANGE("Open Automatically", TRUE);
                                     if AccountType.FindSet then begin
                                         repeat
                                             AccountNo := Member."No." + AccountType.Code;
                                             Vendor.INIT;
                                             Vendor."No." := AccountNo;
                                             Vendor.Name := AccountType.Description;
                                             Vendor."Vendor Posting Group" := AccountType."Posting Group";
                                             Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                             Vendor."Phone No." := "Phone No.";
                                             Vendor."E-Mail" := "E-mail";
                                             Vendor."Account Type" := AccountType.Code;
                                             Vendor."Member No." := "No.";
                                             Vendor.Status := Vendor.Status::Active;
                                             Vendor."Member Name" := "Full Name";
                                             Vendor."Vendor Type" := Vendor."Vendor Type"::FOSA;
                                             Vendor.INSERT;
                                         until AccountType.Next = 0;
                                     end;
                                 end;
                             end;
                         end;*/
                    end;
                }

            }
        }

        area(Processing)
        {
            action("Send SMS")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;


                trigger OnAction()
                begin

                end;
            }

        }

    }

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
        "Registration Date" := "Date of Registration";
        MODIFY;
        ApplicationN0 := '';

    end;

    var
        Text000: Label 'Are you sure you want to send member application %1 for approval?';
        Text001: Label 'Are you sure you want to cancel member application %1?';
        Text002: Label 'Member Application %1 has been submitted successfully';
        Text003: Label 'Member Application %1 has been cancelled successfully';
        [InDataSet]
        IsVisibleIndividual: Boolean;
        [InDataSet]
        IsVisibleGroup: Boolean;
        [InDataSet]
        IsVisibleCompany: Boolean;
        BeneficiaryType: Record "Beneficiary Type";
        IsVisibleApprovalRequest: Boolean;
        //ApprovalsMgmt: Codeunit "1535";
        Agency: Record "Member Agency";
        AccountType: Record "Account Type";
        Fosa: Codeunit "FOSA Management";
        Member: Record Member;
        AccountNo: code[20];
        MemberMonthlyContribution: Record "Member Contribution";
        IsVisibleJoint: Boolean;
        IsVisibleSignature: Boolean;
        [InDataSet]
        IsVisiblePicture: Boolean;
        [InDataSet]
        IsVisibleFrontID: Boolean;
        [InDataSet]
        IsVisibleBackID: Boolean;
        IsVisibleCR: Boolean;
        Vendor: Record "Vendor";
        ApplicationN0: Code[50];
        Customer: Record "Customer";
        LoanApplication: Record "Loan Application";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        i: Integer;
        TransactionType: Code[10];
        MiniTransactions: Text;

    local procedure SetVisible()
    begin
        IF (Category = Category::Individual) or (Category = Category::Junior) THEN BEGIN
            IsVisibleGroup := FALSE;
            IsVisibleCompany := FALSE;
            IsVisibleIndividual := TRUE;
            IsVisibleJoint := FALSE;
            IsVisiblePicture := TRUE;
            IsVisibleSignature := TRUE;
            IsVisibleBackID := TRUE;
            IsVisibleFrontID := TRUE;
            IsVisibleCR := FALSE;
        END ELSE
            IF Category = Category::Group THEN BEGIN
                IsVisibleIndividual := FALSE;
                IsVisibleCompany := FALSE;
                IsVisibleGroup := TRUE;
                IsVisibleJoint := FALSE;
                IsVisiblePicture := TRUE;
                IsVisibleSignature := FALSE;
                IsVisibleFrontID := FALSE;
                IsVisibleBackID := FALSE;
                IsVisibleCR := TRUE;
            END ELSE
                IF Category = Category::Company THEN BEGIN
                    IsVisibleIndividual := FALSE;
                    IsVisibleGroup := FALSE;
                    IsVisibleCompany := TRUE;
                    IsVisibleJoint := FALSE;
                    IsVisiblePicture := TRUE;
                    IsVisibleSignature := FALSE;
                    IsVisibleFrontID := FALSE;
                    IsVisibleBackID := FALSE;
                    IsVisibleCR := TRUE;
                END ELSE
                    IF Category = Category::Joint THEN BEGIN
                        IsVisibleGroup := FALSE;
                        IsVisibleCompany := FALSE;
                        IsVisibleIndividual := FALSE;
                        IsVisibleJoint := TRUE;
                        IsVisiblePicture := TRUE;
                        IsVisibleSignature := FALSE;
                        IsVisibleFrontID := FALSE;
                        IsVisibleBackID := FALSE;
                        IsVisibleCR := FALSE;
                    END;
        IF Status = Status::Active THEN
            IsVisibleApprovalRequest := TRUE
        ELSE
            IsVisibleApprovalRequest := FALSE
    end;

    local procedure SetEditable()
    begin
        IF Status = Status::Active THEN
            CurrPage.EDITABLE := TRUE;
        IF Status = Status::Dormant THEN
            CurrPage.EDITABLE := TRUE;
        IF Status = Status::Suspended THEN
            CurrPage.EDITABLE := FALSE;
    end;

    trigger OnClosePage()
    var

    begin
        CurrPage.Update(true);
    end;
}

