report 55006 "Group Collection Sheet"
{

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/Group Collection Sheet.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem2; Member)
        {
            DataItemTableView = SORTING("No.") WHERE(Category = FILTER(Group));
            RequestFilterFields = "No.";
            column(GlobalDimension1Code_MicroCreditMember; BranchName)
            {
            }
            column(NoofMembers_MicroCreditMember; "No. of Members")
            {
            }
            column(No_MicroCreditMember; "No.")
            {
            }
            column(LoanOfficerID_MicroCreditMember; "Loan Officer ID")
            {
            }
            column(GroupName_MicroCreditMember; "Full Name")
            {
            }
            column(GroupMeetingDay_MicroCreditMember; "Group Meeting Day")
            {
            }
            column(GroupMeetingTime_MicroCreditMember; "Group Meeting Time")
            {
            }
            column(GroupMeetingFrequency_MicroCreditMember; "Group Meeting Frequency Option")
            {
            }
            column(GroupMeetingVenue_MicroCreditMember; "Group Meeting Venue")
            {
            }
            column(GroupPaybillCode_MicroCreditMember; "Group Paybill Code")
            {
            }
            dataitem("Group Members"; Member)
            {
                DataItemLink = "Group Link No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                column(HeaderTxt; HeaderTxt)
                {
                }
                column(GroupOfficial; TextVariable[1])
                {
                }
                column(MeetingDate; DateVariable[1])
                {
                }
                column(NextMeetingDate; DateVariable[2])
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
                column(CompanyInformation_Picture; Picture)
                {
                }
                column(No_GroupMembers; "No.")
                {
                }
                column(SurName_GroupMembers; "SurName")
                {
                }
                column(FirstName_GroupMembers; "First Name")
                {
                }
                column(LastName_GroupMembers; "Last Name")
                {
                }
                column(NationalIDPassportNo_GroupMembers; "National ID")
                {
                }
                column(PhoneNo_GroupMembers; "Phone No.")
                {
                }
                column(i; i)
                {
                }
                column(ProductType; TextVariable[2])
                {
                }
                column(LoanAmount; AmountVariable[1])
                {
                }
                column(LoanBalance; AmountVariable[2])
                {
                }
                column(SavingsContribution; SavingsContribution)
                {
                }
                column(ReportCode; ReportCode)
                {
                }
                column(InstallmentAmount; AmountVariable[3])
                {
                }
                column(PrepaymentArrears; AmountVariable[4])
                {
                }
                column(AmountDue; AmountVariable[5])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    i += 1;
                    GetRepaymentDetails("No.");
                end;
            }
            dataitem(DataItem20; "Account Type")
            {
                DataItemTableView = SORTING(Code);
                column(Description_AccountTypes; Description)
                {
                }
                column(Code_AccountTypes; Code)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                TextVariable[1] := GetGroupOfficial("No.");
                DateVariable[1] := CALCDATE("Group Meeting Frequency", "Last Meeting Date");
                DateVariable[2] := CALCDATE("Group Meeting Frequency", DateVariable[1]);


                DimensionValue.RESET;
                DimensionValue.SETRANGE("Dimension Code", 'BRANCH');
                DimensionValue.SETRANGE(Code, "Global Dimension 1 Code");
                IF DimensionValue.FINDFIRST THEN
                    BranchName := DimensionValue.Name;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
        MicroCreditSetup.GET;
        ReportCode := MicroCreditSetup."Group Collection Report Code";
    end;

    var
        MicroCreditMember: Record Member;
        Vari: array[10] of Text[50];
        i: Integer;
        MemberNo: Code[20];
        HeaderTxt: Label 'GROUP COLLECTION SHEET';
        MCMemberApplication: Record "Member Application";
        TextVariable: array[10] of Text;
        DateVariable: array[5] of Date;
        AccountTypes: Record "Account Type";
        AmountVariable: array[10] of Decimal;
        CompanyInformation: Record "Company Information";
        SavingsContribution: Decimal;
        ReportCode: Code[10];
        MicroCreditSetup: Record "Microcredit Setup";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        MemberAccount: Record Vendor;
        MCLoanApplication: Record "Loan Application";
        DimensionValue: Record "Dimension Value";
        BranchName: Code[30];
        MCLoanClassificationEntry: Record "Loan Classification Entry";
        MicroCreditManagement: Codeunit "MicroCredit Management";
        BOSAMgt: Codeunit "BOSA Management";
        EndDate: Date;

    local procedure GetGroupOfficial(GroupID: Code[20]): Text;
    begin
        MicroCreditMember.RESET;
        MicroCreditMember.SETRANGE(Category, MicroCreditMember.Category::Individual);
        MicroCreditMember.SETRANGE("Is Group Official", TRUE);
        MicroCreditMember.SETRANGE("Group Official Position", MicroCreditMember."Group Official Position"::ChairPerson);
        MicroCreditMember.SETRANGE("Group Link No.", GroupID);
        IF MicroCreditMember.FINDFIRST THEN
            EXIT(FORMAT(MicroCreditMember."Full Name"));
    end;

    local procedure GetRepaymentDetails("MemberNo.": Code[20]);
    var
        VendorLedgerEntry: Record 25;
        Customer: Record Customer;
        LoanApplication: Record "Loan Application";
    begin
        CLEAR(AmountVariable);
        Customer.RESET;
        Customer.SETRANGE("Member No.", "MemberNo.");
        Customer.SETRANGE(Status, Customer.Status::Active);
        Customer.SETFILTER("Balance (LCY)", '<%1', 0);
        IF Customer.FINDLAST THEN BEGIN
            if LoanApplication.get(Customer."No.") then
                BOSAMgt.GenerateLoanClassification(LoanApplication, EndDate);
            MCLoanClassificationEntry.RESET;
            MCLoanClassificationEntry.SETRANGE("Loan No.", MemberAccount."No.");
            MCLoanClassificationEntry.SETRANGE("Classification Date", TODAY);
            IF MCLoanClassificationEntry.FINDLAST THEN BEGIN
                AmountVariable[1] := MCLoanClassificationEntry."Approved Amount";
                AmountVariable[2] := ABS(MCLoanClassificationEntry."Outstanding Balance");
                AmountVariable[3] := MCLoanClassificationEntry."Total Installment";
                //  AmountVariable[7]:=MCLoanClassificationEntry."Total Amount Paid";
                AmountVariable[4] := MCLoanClassificationEntry."Total Arrears" - MCLoanClassificationEntry."Total Overpayment";
                AmountVariable[5] := MCLoanClassificationEntry."Total Installment" + AmountVariable[4];
                IF AmountVariable[5] < 0 THEN
                    AmountVariable[5] := 0;
            END;
        END;
    end;
}

