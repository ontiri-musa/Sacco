page 50202 "Member Loan Account List"
{
    // version TL2.0

    Caption = 'Member Loan Accounts';
    CardPageID = "Member Loan Account Card";
    PageType = List;
    SourceTable = Customer;
    SourceTableView = WHERE("Member No." = FILTER(<> ''));
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            group(Reports)
            {


                action(LoanStatement)
                {
                    Caption = 'Loan Statement';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        LoanApplication.FILTERGROUP(10);
                        LoanApplication.SETRANGE("Member No.", Rec."Member No.");
                        LoanApplication.SetRange("No.", Rec."No.");
                        LoanApplication.FILTERGROUP(0);
                        Report.RUN(50081, true, false, LoanApplication);
                    end;
                }
                action(LoanRecon)
                {
                    Caption = 'Loan Recon';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = codeunit "Process Loan Reconciliation";
                }
            }

        }
    }
    var
        LoanApplication: Record "Loan Application";
}

