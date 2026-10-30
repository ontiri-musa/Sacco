page 50102 "LoanLookUpDrillDown List"
{
    // version TL2.0

    Caption = 'Posted Loans';
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = FILTER(Approved), Posted = FILTER(true));
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Date of Completion"; "Date of Completion")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {


        }
    }
    trigger OnOpenPage()
    var

    begin
        CurrPage.Editable(false);
    end;

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanCollateral: Record "Loan Collateral";
        LoanApp: Record "Loan Application";
        DateForm: DateFormula;
        LoanUpd: Record LoansUpdate;
        LoanProd: Record "Loan Product Type";
        LoanClass: Record "Loan Classification Entry";
        LClassCode: Code[100];
        ArrearsAmount: Decimal;
        LastPDate: Date;
        Dcust: Record "Detailed Cust. Ledg. Entry";
        PhoneNo: Code[50];
        Memb: Record Member;
    //LoanOffset: Record "50106";
}

