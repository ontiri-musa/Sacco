page 50028 "Transaction Type Code Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Transaction Type Code Setup";

    layout
    {
        area(Content)
        {
            group(FOSA)
            {
                field("Monthly Contribution"; "Monthly Contribution")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee"; "Registration Fee")
                {
                    ApplicationArea = All;
                }
            }
            group(BOSA)
            {
                field("Opening Balance"; "Opening Balance")
                {
                    ApplicationArea = All;

                }
                field("New Loan"; "New Loan")
                {
                    ApplicationArea = All;

                }
                field("Principal Paid"; "Principal Paid")
                {
                    ApplicationArea = All;

                }
                field("Interest Paid"; "Interest Paid")
                {
                    ApplicationArea = All;

                }
                field("Interest Due"; "Interest Due")
                {
                    ApplicationArea = All;

                }
                field("Ledger Fee Due"; "Ledger Fee Due")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Paid"; "Ledger Fee Paid")
                {
                    ApplicationArea = All;

                }
                field("Penalty Due"; "Penalty Due")
                {
                    ApplicationArea = All;

                }
                field("Penalty Paid"; "Penalty Paid")
                {
                    ApplicationArea = All;
                }
                field("Loan Prepayment"; "Loan Prepayment")
                {
                    ApplicationArea = All;
                }
                field("Processing Fee"; "Processing Fee")
                {
                }
                field("Insurance Fee"; "Insurance Fee")
                {
                    ApplicationArea = All;
                }



                field("Refinancing Fee"; "Refinancing Fee")
                {
                    ApplicationArea = All;

                }



            }
        }
    }

    actions
    {
        area(Processing)
        {
            /*  action(ActionName)
             {
                 ApplicationArea = All;

                 trigger OnAction()
                 begin

                 end;
             } */
        }
    }

    var
        myInt: Integer;
}