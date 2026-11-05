page 50300 "Loan Classification Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "Loan Classification Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Classification Date"; "Classification Date")
                {
                    ApplicationArea = All;
                }
                field("Classification Time"; "Classification Time")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Loan Product Type 2"; "Loan Product Type 2")
                {
                    Caption = 'Loan Product Type';
                    ApplicationArea = All;
                }
                field(Description; Description)
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
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Date Of Birth"; "Date Of Birth")
                {
                    ApplicationArea = All;
                }
                field("Deposit Balance"; "Deposit Balance" * -1)
                { }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Loan Start Date"; "Loan Start Date")
                { }

                field("Expected Completion Date"; "Expected Completion Date")
                {

                }
                field("Church District Code"; "Church District Code")
                { }
                field("Church Section Code"; "Church Section Code")
                { }

                field("Remaining Period"; "Remaining Period")
                {
                    ApplicationArea = All;
                }
                field("Remaining Principal Amount"; "Remaining Principal Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining Interest Amount"; "Remaining Interest Amount")
                {
                    ApplicationArea = All;
                }
                field("Principal Installment"; "Principal Installment")
                {
                    ApplicationArea = All;
                }
                field("Interest Installment"; "Interest Installment")
                {
                    ApplicationArea = All;
                }
                field("Total Installment"; "Total Installment")
                {
                    ApplicationArea = All;
                }
                field("Principal Overpayment"; "Principal Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Interest Overpayment"; "Interest Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Overpayment"; "Ledger Fee Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Penalty Overpayment"; "Penalty Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Principal Arrears"; "Principal Arrears")
                {
                    ApplicationArea = All;
                }
                field("Interest Arrears"; "Interest Arrears")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Arrears"; "Ledger Fee Arrears")
                {
                    ApplicationArea = All;
                }
                field("Penalty Arrears"; "Penalty Arrears")
                {
                    ApplicationArea = All;
                }
                field("Total Arrears"; "Total Arrears")
                {
                    ApplicationArea = All;
                }
                field("Principal Balance"; "Principal Balance")
                {
                    ApplicationArea = All;
                }
                field("Loan Prepayment"; "Loan Prepayment")
                {
                    ApplicationArea = All;
                }

                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Provisioning Amount"; "Provisioning Amount")
                {
                    ApplicationArea = All;
                }
                field("Classification Code"; "Classification Code")
                {
                    ApplicationArea = All;
                }
                field("Class Description"; "Class Description")
                {
                    ApplicationArea = All;
                }
                field("No. of Days in Arrears"; "No. of Days in Arrears")
                {
                    ApplicationArea = All;
                }
                field("No. of Defaulted Installment"; "No. of Defaulted Installment")
                {
                    ApplicationArea = All;
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(Print)
            {
                Image = BankAccountStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //REPORT.RUN(REPORT::"Loan Classification Report",TRUE,FALSE);
                end;
            }
        }
    }
    var
        Member: Record Member;
}

