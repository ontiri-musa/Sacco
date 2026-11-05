pageextension 50001 "Source Code Setup Ext" extends "Source Code Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Cost Accounting")

        {
            group(Finance)

            {
                field("Payment Voucher"; "Payment Voucher")
                {
                    ApplicationArea = All;
                }
                field("Receipt Voucher"; "Receipt Voucher")
                {
                    ApplicationArea = All;
                }
                field("PettyCash Voucher"; "PettyCash Voucher")
                {
                    ApplicationArea = All;
                }
                field(Imprest; Imprest)
                {
                    ApplicationArea = All;
                }
                field("Imprest Surrender"; "Imprest Surrender")
                {
                    ApplicationArea = All;
                }
                field("Salary Advance"; "Salary Advance")
                {
                    ApplicationArea = All;
                }
                field(Checkoff; Checkoff)
                {
                    ApplicationArea = All;
                }
            }
            group(FOSA)

            {
                field("Member Application"; "Member Application")
                {
                    ApplicationArea = All;
                }
                field("Account Opening"; "Account Opening")
                {
                    ApplicationArea = All;
                }
                field("Fixed Deposit"; "Fixed Deposit")
                {
                    ApplicationArea = All;
                }
                field(Spotcash; Spotcash)
                {
                    ApplicationArea = All;
                }
                field(ATM; ATM)
                {
                    ApplicationArea = All;
                }
                field(Teller; Teller)
                {
                    ApplicationArea = All;
                }
                field(Treasury; Treasury)
                {
                    ApplicationArea = All;
                }
                field(CTS; CTS)
                {
                    ApplicationArea = All;
                }
                field(Agency; Agency)
                {
                    ApplicationArea = All;
                }
                field(Dormancy; Dormancy)
                {
                    ApplicationArea = All;
                }
            }
            group(BOSA)

            {
                // control with underlying datasource

                field(Loan; Loan)
                {
                    ApplicationArea = All;
                }

                field("Standing Order"; "Standing Order")
                {
                    ApplicationArea = All;
                }

                field("Fund Transfer"; "Fund Transfer")
                {
                    ApplicationArea = All;
                }
                field("Guarantor Substitution"; "Guarantor Substitution")
                {
                    ApplicationArea = All;
                }
                field("Loan Rescheduling"; "Loan Rescheduling")
                {
                    ApplicationArea = All;
                }
                field("Loan Restructuring"; "Loan Restructuring")
                {
                    ApplicationArea = All;
                }
                field(Payout; Payout)
                {
                    ApplicationArea = All;
                }
                field("Member Exit"; "Member Exit")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery"; "Loan Recovery")
                {
                    ApplicationArea = All;
                }
                field("Loan Selloff"; "Loan Selloff")
                {
                    ApplicationArea = All;
                }
                field("Loan Writeoff"; "Loan Writeoff")
                {
                    ApplicationArea = All;
                }
                field("Opening Balance"; "Opening Balance")
                {
                    ApplicationArea = All;
                }
                field(Remittance; Remittance)
                {
                    ApplicationArea = All;
                }
                field(Refund; Refund)
                {
                    ApplicationArea = All;
                }
                field(Defaulter; Defaulter)
                {
                    ApplicationArea = All;
                }
                field("Loan Overpayment"; "Loan Overpayment")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}