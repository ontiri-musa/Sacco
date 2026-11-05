page 50010 "Global Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Global Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {




            }
            group(Numbering)
            {

            }
            group("Account Setup")
            {
                field("Excise Duty %"; "Excise Duty %")
                {
                    ApplicationArea = All;
                }
                field("Excise Duty G/L Account"; "Excise Duty G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax %"; "Withholding Tax %")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax G/L Account"; "Withholding Tax G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Stamp Duty %"; "Stamp Duty %")
                {
                    ApplicationArea = All;
                }
                field("Stamp Duty G/L Account"; "Stamp Duty G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Income Realization Method"; "Income Realization Method")
                {
                    ApplicationArea = All;
                }


            }
            group(Board)
            {
                Caption = 'Board Members Setups';
                field("Board Tax %"; "Board Tax %")
                {
                    ApplicationArea = All;
                }
                field("Board Tax G/L Account"; "Board Tax G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Sitting Allowance G/L"; "Sitting Allowance G/L")
                {
                    ApplicationArea = All;
                }
                field("Transport Reimbursement G/L"; "Transport Reimbursement G/L")
                {
                    ApplicationArea = All;
                }
                field("Board Hospitality G/L"; "Board Hospitality G/L")
                {
                    ApplicationArea = All;
                }
            }
            group("Loan Setups")
            {
                Caption = 'Loan Setups';
                field("Securities Path"; "Securities Path")
                {
                    ApplicationArea = All;
                }
                field("Loan Form Path"; "Loan Form Path")
                {
                    ApplicationArea = All;
                }
                field("Deposit %"; "Deposit %")
                {
                    ApplicationArea = All;
                }
                field("Deposit Figure"; "Deposit Figure")
                {
                    ApplicationArea = All;
                }
                field("Maximum Deposit Figure"; "Maximum Deposit Figure")
                {
                    ApplicationArea = All;
                }
                field("Share Capital Threshold"; "Share Capital Threshold")
                {
                    ApplicationArea = All;
                }
                field("Share Capital Threshold Period"; "Share Capital Threshold Period")
                {
                    ApplicationArea = All;
                }


            }
            group(Member)
            {
                field("Registration Fee"; "Registration Fee")
                {
                    ApplicationArea = All;
                }

                field("Unallocated Payments G/L"; "Unallocated Payments G/L")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee Limit Date"; "Registration Fee Limit Date")
                {
                    ApplicationArea = All;
                }
                field("Monthly deposit contribution"; "Monthly deposit contribution")
                {
                    ApplicationArea = All;
                }
                field("Minimum Share contribution"; "Minimum Share contribution")
                {
                    ApplicationArea = All;
                }
            }
            group(Images)
            {
                field("Image Path Local Directory"; "Image Path Local Directory")
                {
                    ApplicationArea = All;
                }
                field("Image Path IP Address"; "Image Path IP Address")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        //  Message('Huraaah, I have been published');
    end;
}

