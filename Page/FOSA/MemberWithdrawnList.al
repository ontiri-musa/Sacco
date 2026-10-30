page 59539 MemberListWithdrawn
{
    // version TL2.0

    Caption = 'Members';
    CardPageID = "Member Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Category 6,Category 7,Category 8';
    SourceTableView = SORTING("No.") ORDER(Ascending) WHERE(Status = filter(Withdrawn));
    SourceTable = Member;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }

                /*  field(Surname; Surname)
                 {
                     ApplicationArea = All;
                 }
                 field("First Name"; "First Name")
                 {
                     ApplicationArea = All;
                 }
                 field("Last Name"; "Last Name")
                 {
                     ApplicationArea = All;
                 } */
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field(Category; Category)
                {
                    ApplicationArea = All;
                }
                field("Application No."; "Application No.")
                {
                    ApplicationArea = All;
                }
                field("Age Classification"; "Age Classification")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Church District Code"; "Church District Code")
                {
                    ApplicationArea = All;
                    Caption = 'District';
                }
                field("Church Code"; "Church Code")
                {
                    ApplicationArea = All;
                    Caption = 'Church';
                }
                field("Church Section Code"; "Church Section Code")
                {
                    ApplicationArea = All;
                    Caption = 'Section Code';
                }
                field("Section Name"; "Section Name")
                {
                    ApplicationArea = All;
                    Caption = 'Section Name';
                }
                field("Date of Registration"; "Date of Registration")
                {
                    ApplicationArea = All;
                }
                field("Phone No. 2"; "Phone No. 2")
                {
                    ApplicationArea = All;
                }
                field("E-mail"; "E-mail")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }

                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Old Member Status"; "Old Member Status")
                {
                    ApplicationArea = All;
                    Visible = false;
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
        }
    }

    actions
    {
        area(navigation)
        {
            action("Member Nominees")
            {
                Ellipsis = true;
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::Nominee);
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50005, BeneficiaryType);
                end;
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

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Next of Kin");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50006, BeneficiaryType);
                end;
            }
            action(Agencies)
            {
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;

                trigger OnAction()
                begin
                    Agency.FILTERGROUP(10);
                    Agency.SETRANGE("Member No.", Rec."No.");
                    Agency.FILTERGROUP(0);
                    PAGE.RUN(50052, Agency);
                end;
            }
            action("Monthly Contributions")
            {
                Ellipsis = true;
                Image = ElectronicPayment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    MemberMonthlyContribution.FILTERGROUP(10);
                    MemberMonthlyContribution.SETRANGE("Application No.", Rec."Application No.");
                    Agency.FILTERGROUP(0);
                    PAGE.RUN(50053, MemberMonthlyContribution);
                end;
            }
            action("Group Members")
            {
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleGroup;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Group Member");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50057, BeneficiaryType);
                end;
            }
            action("Group Trustees")
            {
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleGroup;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Group Trustee");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50059, BeneficiaryType);
                end;
            }
            action("Company Signatories")
            {
                Image = Company;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleCompany;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Company Signatory");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50056, BeneficiaryType);
                end;
            }
            action("Company Trustees")
            {
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleCompany;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Company Trustee");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50058, BeneficiaryType);
                end;
            }
            action("Joint Members")
            {
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleJoint;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Joint Member");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50071, BeneficiaryType);
                end;
            }
            action("Savings/Deposit Accounts")
            {
                Image = MapAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Vendor.FILTERGROUP(10);
                    Vendor.SETRANGE("Member No.", Rec."No.");
                    Vendor.FILTERGROUP(0);
                    PAGE.RUN(50033, Vendor);
                end;
            }
            action("Loan Accounts")
            {
                Image = SocialListening;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Customer.FILTERGROUP(10);
                    Customer.SETRANGE("Member No.", Rec."No.");
                    Customer.FILTERGROUP(0);
                    PAGE.RUN(50202, Customer);
                end;
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
                    var
                        Member: Record Member;
                    begin
                        Member.FILTERGROUP(10);
                        Member.SETRANGE("No.", Rec."No.");
                        Member.FILTERGROUP(0);
                        Report.RUN(50087, true, false, Member);
                    end;
                }
                action("UpdateStatus")
                {
                    Caption = 'Update Member Status';
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = true;


                    trigger OnAction()
                    var
                        Member: Record Member;
                        Vend: Record Vendor;
                        DVend: Record "Detailed Vendor Ledg. Entry";
                    begin
                        Member.Reset();
                        if Member.FindSet() then begin
                            repeat
                                /*if (Member."Old Member Status" = Member."Old Member Status"::Active) then
                                    Member.Status := Member.Status::Active;
                                if (Member."Old Member Status" = Member."Old Member Status"::Blocked) then
                                    Member.Status := Member.Status::Blocked;
                                if (Member."Old Member Status" = Member."Old Member Status"::Deceased) then
                                    Member.Status := Member.Status::Deceased;
                                if (Member."Old Member Status" = Member."Old Member Status"::Withdrawal) then
                                    Member.Status := Member.Status::Withdrawn;
                                Member.Modify;*/
                                if (Member.Status = Member.Status::Active) or (Member.Status = Member.Status::Dormant) then begin
                                    Vend.Reset();
                                    Vend.SetRange(Vend."Member No.", Member."No.");
                                    Vend.SetRange(Vend."Account Type", '02');
                                    if Vend.FindFirst() then begin
                                        DVend.Reset();
                                        DVend.SetRange(DVend."Vendor No.", Vend."No.");
                                        If DVend.FindLast() then begin
                                            if CalcDate('-3M', Today) >= DVend."Posting Date" then
                                                Member.Status := Member.Status::Dormant
                                            else
                                                Member.Status := Member.Status::Active;
                                        end;
                                    end;
                                    Member.Modify;
                                end;
                            until Member.Next = 0;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetVisible;
        SetEditable;
    end;

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
        /*Member.Reset();
         Member.SetRange(Member."Section Name", '');
         if Member.FindSet() then begin
             repeat
                 ChurchSection := '';

                 ChrchSect.Reset();
                 ChrchSect.SetRange(ChrchSect.Code, Member."Church Section Code");

                 if ChrchSect.FindFirst() then begin
                     // Member."Section Name" := ChrchSect.Name;
                     // Member.Modify();
                 end;
             until Member.Next = 0;
         end;*/
    end;



    var
        BeneficiaryType: Record "Beneficiary Type";
        ChurchSection: text[150];
        ChrchSect: Record "Church Section";
        //ApprovalsMgmt: Codeunit "1535";
        [InDataSet]
        IsVisibleIndividual: Boolean;
        [InDataSet]
        IsVisibleGroup: Boolean;
        [InDataSet]
        IsVisibleCompany: Boolean;
        Member: Record Member;
        IsVisibleApprovalRequest: Boolean;
        Agency: Record "Member Agency";
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
        Customer: Record "Customer";
        LoanApplication: Record "Loan Application";

    local procedure SetVisible()
    begin
        IF Category = Category::Individual THEN BEGIN
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
            CurrPage.EDITABLE := FALSE;
        IF Status = Status::Suspended THEN
            CurrPage.EDITABLE := FALSE;
    end;

}
