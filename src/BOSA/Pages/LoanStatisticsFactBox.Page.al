page 50196 "Loan Statistics FactBox"
{
    // version TL2.0

    Caption = 'Loan Statistics';
    PageType = CardPart;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
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
            field(Prepayment; Prepayment)
            {
                ApplicationArea = All;
            }
            field("Outstanding Balance"; "Outstanding Balance")
            {
                ApplicationArea = All;
            }
            field("Approved Amount"; "Approved Amount")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}

