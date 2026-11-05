page 50176 "Loan Prepayment Recovery List"
{
    Caption = 'Loan Prepayment Recovery List';
    PageType = List;
    SourceTable = "Loan Prepayment Recovery";

    layout
    {
        area(content)
        {
            repeater(General)
            {

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
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Name field.';
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field("Prepayment Amount"; Rec."Prepayment Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prepayment Amount field.';
                }
                field("Principal Recovered"; Rec."Principal Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Principal Recovered field.';
                }
                field("Interest Recovered"; Rec."Interest Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Penalty Recovered field.';
                }
                field("Penalty Recovered"; Rec."Penalty Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Penalty Recovered field.';
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

                field(Posted; Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }

                field("Recovered By"; Rec."Recovered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recovered By field.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(postRecoveries)
            {
                ApplicationArea = Suite;
                Caption = 'Post Recoveries';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PrepaymentRecovery: Record "Loan Prepayment Recovery";
                    PrepaymentCU: Codeunit "Recover Loans From Prepayments";
                    GlobalManagement: Codeunit "Global Management";
                    LoanApplicationSetup: Record "Loan Application Setup";
                begin
                    if confirm('Do you want to post the recoveries??') then begin
                        LoanApplicationSetup.Get();
                        LoanApplicationSetup.TestField("Loan Interest Template Name");
                        LoanApplicationSetup.TestField("Loan Interest Batch Name");

                        GlobalManagement.ClearJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");

                        PrepaymentRecovery.Reset();
                        PrepaymentRecovery.SetRange(Posted, false);
                        if PrepaymentRecovery.FindSet() then begin
                            repeat
                            // PrepaymentCU.ProcessRecovery(PrepaymentRecovery, PrepaymentRecovery."Prepayment Amount", PrepaymentRecovery."Posting Date");
                            until PrepaymentRecovery.Next() = 0;
                        end;
                        GlobalManagement.PostJournal(LoanApplicationSetup."Loan Interest Template Name", LoanApplicationSetup."Loan Interest Batch Name");
                        Message('Process Complete');
                    end;
                end;
            }
        }

    }
}
