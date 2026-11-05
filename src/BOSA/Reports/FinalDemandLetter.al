report 50024 "Final Demand Letter"
{
    ApplicationArea = All;
    Caption = 'Final Demand Letter';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Final Demand Letter.rdl';

    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MemberName; "Member Name")
            {
            }
            column(PrincArrears; AmountInArrears[1])
            { }
            column(IntArrears; AmountInArrears[2])
            { }
            column(PenArrears; AmountInArrears[3])
            { }
            column(LedgArrears; AmountInArrears[4])
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            dataitem("Loan Guarantor"; "Loan Guarantor")
            {
                DataItemLink = "Loan No." = field("No.");
                column(Member_No_; "Member No.")
                {

                }
                column(Member_Name; "Member Name")
                {

                }
            }
            trigger OnAfterGetRecord()
            var
                GlobalM: Codeunit "Global Management";
            begin
                GlobalM.CalculateLoanArrearsAndOverpayment(LoanApplication."No.", 0D, Today, AmountInArrears[1], AmountInArrears[2], AmountInArrears[3], AmountInArrears[4], AmountInOverpayment[1], AmountInOverpayment[2]);
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        AmountInArrears: array[5] of Decimal;
        AmountInOverpayment: array[5] of Decimal;
}
