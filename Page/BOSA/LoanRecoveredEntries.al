page 50054 "Loan Recovered Entries"
{
    ApplicationArea = All;
    Caption = 'Loan Recovered Entries';
    PageType = List;
    SourceTable = "Loans Recovered From Deposits";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field("Loan No"; Rec."Loan No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan No field.';
                }
                field("Loan Product"; Rec."Loan Product")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Product field.';
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Name field.';
                }
                field("Deposits Balance"; Rec."Deposits Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deposits Balance field.';
                }
                field("Amount Recovered"; Rec."Amount Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Recovered field.';
                }
                field("Date Recovered"; Rec."Date Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Recovered field.';
                }
                field("Recovered By"; Rec."Recovered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recovered By field.';
                }
            }
        }
    }
}
