report 55016 "Group Report"
{


    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/Group Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; Member)
        {
            DataItemTableView = SORTING("No.");
            column(No_MicroCreditMember; "No.")
            {
            }
            column(FullName_MicroCreditMember; "Full Name")
            {
            }
            column(PhoneNo_MicroCreditMember; "Phone No.")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(GroupID; GroupID)
            {
            }
            column(GroupName; GroupName)
            {
            }
            column(GroupLeader; GroupLeader)
            {
            }
            column(GroupMembers; GroupMembers)
            {
            }
            column(Branch; Branch)
            {
            }
            column(LoanOfficer; LoanOfficer)
            {
            }
            column(Product; Product)
            {
            }
            column(OLB; OLB)
            {
            }
            column(ActualRepayDate; ActualRepayDate)
            {
            }
            column(ActualRepayAmount; ActualRepayAmount)
            {
            }
            column(ExpectedRepayDate; ExpectedRepayDate)
            {
            }
            column(ExpectedRepayAmount; ExpectedRepayAmount)
            {
            }
            column(NextRepayDate; NextRepayDate)
            {
            }
            column(NextRepayAmount; NextRepayAmount)
            {
            }
            column(InArrears; InArrears)
            {
            }
            column(PrePaid; PrePaid)
            {
            }
            column(NWDBalance; NWDBalance)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(NextWeekEndDate; NextWeekEndDate)
            {
            }
            column(LoanAmount; LoanAmount)
            {
            }
            column(ShareCapitalBalance; ShareCapitalBalance)
            {
            }
            column(GroupPayBillCode; GroupPayBillCode)
            {
            }
            column(MeetingFrequency; MeetingFrequency)
            {
            }
            column(MeetingVenue; MeetingVenue)
            {
            }
            dataitem(DataItem37; "Loan Classification Entry")
            {
                DataItemLink = "Member No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                column(Term; Term)
                {
                }
                column(RemainingTerm; RemainingTerm)
                {
                }
                column(LoanNo_MCLoanClassificationEntry; "Loan No.")
                {
                }
                column(Description_MCLoanClassificationEntry; Description)
                {
                }
                column(MemberNo_MCLoanClassificationEntry; "Member No.")
                {
                }
                column(MemberName_MCLoanClassificationEntry; "Member Name")
                {
                }
                column(ApprovedLoanAmount_MCLoanClassificationEntry; "Approved Amount")
                {
                }
                column(RepaymentPeriod_MCLoanClassificationEntry; "Repayment Period")
                {
                }
                column(RemainingPeriod_MCLoanClassificationEntry; "Remaining Period")
                {
                }
                column(OutstandingLoanBalance_MCLoanClassificationEntry; "Outstanding Balance")
                {
                }
                column(TotalInstallment_MCLoanClassificationEntry; "Total Installment")
                {
                }
                column(PrepaymentAmount_MCLoanClassificationEntry; "Total Overpayment")
                {
                }
                column(TotalArrearsAmount_MCLoanClassificationEntry; "Total Arrears")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF "Classification Date" <> TODAY THEN
                        CurrReport.SKIP;


                    LoanRepaymentSchedule.RESET;
                    LoanRepaymentSchedule.SETRANGE("Loan No.", "Loan No.");
                    IF LoanRepaymentSchedule.FINDLAST THEN BEGIN
                        Term := LoanRepaymentSchedule."Instalment No.";
                    END;
                    LoanRepaymentSchedule2.RESET;
                    LoanRepaymentSchedule2.SETRANGE("Loan No.", "Loan No.");
                    LoanRepaymentSchedule2.SETFILTER("Repayment Date", '<=%1', ExpectedRepayDate);
                    IF LoanRepaymentSchedule2.FINDLAST THEN BEGIN
                        RemainingTerm := Term - LoanRepaymentSchedule2."Instalment No.";
                    END;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF "Group Link No." <> GroupID THEN
                    CurrReport.SKIP;

                GetLoanDetails("No.");
                GetGroupDetails;
                GetGroupOfficial(GroupID);
                GetNWDBalance("No.");
                GetShareCapitalBalance("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(GroupID; GroupID)
                {
                    Caption = 'Group No.';
                    TableRelation = Member."No." WHERE(Category = FILTER(Group));
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record 79;
        GroupID: Code[20];
        GroupName: Text;
        MCGroups: Record Member;
        GroupLeader: Text;
        GroupMembers: Integer;
        Branch: Code[10];
        LoanOfficer: Code[20];
        Product: Text;
        Term: Integer;
        RemainingTerm: Integer;
        OLB: Decimal;
        ActualRepayDate: Date;
        ActualRepayAmount: Decimal;
        ExpectedRepayDate: Date;
        ExpectedRepayAmount: Decimal;
        NextRepayDate: Date;
        NextRepayAmount: Decimal;
        InArrears: Decimal;
        PrePaid: Decimal;
        NWDBalance: Decimal;
        AmountPaid: Decimal;
        AmountExpected: Decimal;
        StartDate: Date;
        EndDate: Date;
        NextWeekEndDate: Date;
        LoanAmount: Decimal;
        LoanApplication: Record "Loan Application";
        ShareCapitalBalance: Decimal;
        LoanClassificationEntry: Record "Loan Classification Entry";
        //     MCPortalManagement : Codeunit "55002";
        GroupPayBillCode: Code[10];
        MeetingFrequency: Text;
        MeetingVenue: Text;
        MicroCreditManagement: Codeunit "MicroCredit Management";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanRepaymentSchedule2: Record "Loan Repayment Schedule";

    local procedure GetGroupDetails();
    begin
        IF MCGroups.GET(GroupID) THEN BEGIN
            GroupName := MCGroups."Full Name";
            Branch := MCGroups."Global Dimension 1 Code";
            MCGroups.CALCFIELDS("No. of Members");
            GroupMembers := MCGroups."No. of Members";
            LoanOfficer := MCGroups."Loan Officer ID";
            StartDate := MicroCreditManagement.GetNextMeetingDate(GroupID);
            ExpectedRepayDate := CALCDATE(MCGroups."Group Meeting Frequency", MCGroups."Last Meeting Date");
            NextRepayDate := CALCDATE(MCGroups."Group Meeting Frequency", MicroCreditManagement.GetNextMeetingDate(GroupID));
            GroupPayBillCode := MCGroups."Group Paybill Code";
            MeetingFrequency := FORMAT(MCGroups."Group Meeting Frequency Option");
            MeetingVenue := MCGroups."Group Meeting Venue";
        END;
    end;

    local procedure GetLoanDetails(MemberNo: Code[20]);
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanRepaymentSchedule2: Record "Loan Repayment Schedule";
        LoanRepaymentSchedule3: Record "Loan Repayment Schedule";
        LoanRepaymentSchedule4: Record "Loan Repayment Schedule";
        Customer: Record Customer;
        AccountTypes: Record "Account Type";
        BOSAMgt: Codeunit "BOSA Management";
    begin
        AmountPaid := 0;
        AmountExpected := 0;
        ActualRepayAmount := 0;
        ExpectedRepayAmount := 0;
        NextRepayAmount := 0;
        OLB := 0;
        InArrears := 0;
        PrePaid := 0;
        LoanAmount := 0;
        Term := 0;
        RemainingTerm := 0;
        Product := '';

        Customer.RESET;
        Customer.SETRANGE("Member No.", MemberNo);
        Customer.SETRANGE(Status, Customer.Status::Active);
        IF Customer.FINDLAST THEN BEGIN

            IF LoanApplication.GET(Customer."No.") THEN;
            BOSAMgt.GenerateLoanClassification(LoanApplication, EndDate);
            LoanClassificationEntry.RESET;
            LoanClassificationEntry.SETRANGE("Loan No.", Customer."No.");
            IF LoanClassificationEntry.FINDLAST THEN BEGIN
                OLB := ABS(LoanClassificationEntry."Outstanding Balance");
                InArrears := LoanClassificationEntry."Total Arrears";
                ExpectedRepayAmount := LoanClassificationEntry."Principal Installment" + LoanClassificationEntry."Interest Installment";
                NextRepayAmount := LoanClassificationEntry."Principal Installment" + LoanClassificationEntry."Interest Installment";
                PrePaid := LoanClassificationEntry."Total Overpayment";
                LoanAmount := LoanClassificationEntry."Approved Amount";
            END;
            LoanRepaymentSchedule4.RESET;
            LoanRepaymentSchedule4.SETRANGE("Loan No.", Customer."No.");
            IF LoanRepaymentSchedule4.FINDLAST THEN BEGIN
                Term := LoanRepaymentSchedule4."Instalment No.";
            END;
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", Customer."No.");
            LoanRepaymentSchedule.SETRANGE("Repayment Date", ExpectedRepayDate);
            IF LoanRepaymentSchedule.FINDFIRST THEN BEGIN
                RemainingTerm := Term - LoanRepaymentSchedule."Instalment No.";
            END;
            Product := Customer.Name;

        END;
    end;

    local procedure GetNWDBalance(MemberNo: Code[20]);
    var
        AccountTypes: Record "Account Type";
        Vendor: Record 23;
        Amount: Decimal;
    begin
        NWDBalance := 0;
        AccountTypes.RESET;
        AccountTypes.SETRANGE(Type, AccountTypes.Type::"Member Deposit");
        IF AccountTypes.FINDSET THEN BEGIN
            REPEAT
                Vendor.RESET;
                Vendor.SETRANGE("Member No.", MemberNo);
                Vendor.SETRANGE("Account Type", AccountTypes.Code);
                IF Vendor.FINDFIRST THEN BEGIN
                    Vendor.CALCFIELDS("Balance (LCY)");
                    NWDBalance += Vendor."Balance (LCY)";
                END;
            UNTIL AccountTypes.NEXT = 0;
        END;
    end;

    local procedure GetShareCapitalBalance(MemberNo: Code[20]);
    var
        AccountTypes: Record "Account Type";
        Vendor: Record 23;
        Amount: Decimal;
    begin
        ShareCapitalBalance := 0;
        AccountTypes.RESET;
        //   AccountTypes.SETRANGE("Apply to MicroCredit",TRUE);
        //     AccountTypes.SETFILTER("MicroCredit Category",'%1|%2',AccountTypes."MicroCredit Category"::Client,AccountTypes."MicroCredit Category"::Both);
        AccountTypes.SETRANGE(Type, AccountTypes.Type::"Share Capital");
        IF AccountTypes.FINDFIRST THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", MemberNo);
            Vendor.SETRANGE("Account Type", AccountTypes.Code);
            IF Vendor.FINDFIRST THEN BEGIN
                Vendor.CALCFIELDS("Balance (LCY)");
                ShareCapitalBalance := Vendor."Balance (LCY)";
            END;
        END;
    end;

    local procedure GetGroupOfficial(GroupNo: Code[20]);
    var
        MCMember: Record Member;
    begin
        MCMember.RESET;
        MCMember.SETRANGE("Group Link No.", GroupNo);
        MCMember.SETRANGE("Is Group Official", TRUE);
        IF MCMember.FINDFIRST THEN
            GroupLeader := MCMember."Full Name";
    end;
}

