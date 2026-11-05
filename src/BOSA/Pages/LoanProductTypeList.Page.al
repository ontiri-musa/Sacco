page 50213 "Loan Product Type List"
{
    // version TL2.0

    Caption = 'Loan Product Types';
    CardPageID = "Loan Product Type Card";
    PageType = List;
    SourceTable = "Loan Product Type";
    UsageCategory = Lists;
    ApplicationArea = All;
    DeleteAllowed = false;
    ModifyAllowed = true;
    InsertAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Grace Period"; "Grace Period")
                {
                    ApplicationArea = All;
                }
                field("Rounding Precision"; "Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field(Consolidation; Consolidation)
                {
                    ApplicationArea = All;
                }
                field("Min. Loan Amount"; "Min. Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Max. Loan Amount"; "Max. Loan Amount")
                {
                    ApplicationArea = All;
                }
                field(Category; Category)
                {
                    ApplicationArea = All;
                }

                field("Loan Posting Group"; "Loan Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Loan Prepayment Posting Group"; "Loan Prepayment Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Interest Due Posting Group"; "Interest Due Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Interest Paid Posting Group"; "Interest Paid Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Penalty Due Posting Group"; "Penalty Due Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Penalty Paid Posting Group"; "Penalty Paid Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Due Posting Group"; "Ledger Fee Due Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Paid Posting Group"; "Ledger Fee Paid Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Min. Membership period"; "Min. Membership period")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("E-Loan"; "E-Loan")
                {
                    ApplicationArea = All;
                }
                field("No. of Guarantors"; "No. of Guarantors")
                {
                    ApplicationArea = All;
                }
                field("Recovery Method"; "Recovery Method")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }


                field("Security Type"; "Security Type")
                {
                    ApplicationArea = All;
                }
                field("Apply Graduation Schedule"; "Apply Graduation Schedule")
                {
                    ApplicationArea = All;
                }
                field("Allow Refinancing"; "Allow Refinancing")
                {
                    ApplicationArea = All;
                }
                field("Refinancing Mode"; "Refinancing Mode")
                {
                    ApplicationArea = All;
                }

                field("Apply 1/3 Rule"; "Apply 1/3 Rule")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
}

