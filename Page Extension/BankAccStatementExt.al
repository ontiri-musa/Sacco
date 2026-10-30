pageextension 50005 "Bank Acc StatementExt" extends "Bank Account Statement"
{
    layout
    {
        addafter("Statement Ending Balance")
        {
            field("Total Unreconciled"; "Total Unreconciled")
            {
                Caption = 'Total Unreconciled';
                ToolTip = 'Specifies the total unreconciled amount.';
            }
            field("Total Reconciled"; "Total Reconciled")
            {
                Caption = 'Total Reconciled';
                ToolTip = 'Specifies the total reconciled amount.';
            }
            field("Cash Book Balance"; "Cash Book Balance")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total Cash Book Balance as at when reconciliation posting was done.';
            }
        }
    }
    actions
    {
        addbefore("St&atement")
        {
            group(Main)
            {
                action(PostedStmnt)
                {
                    Caption = 'Posted Reconciliation';
                    Image = Report;
                    Visible = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction()
                    var
                        BankAccStamnet: Record "Bank Account Statement";
                    begin
                        BankAccStamnet.Reset();
                        BankAccStamnet.SetRange(BankAccStamnet."Bank Account No.", "Bank Account No.");
                        BankAccStamnet.SetRange(BankAccStamnet."Statement No.", "Statement No.");
                        if BankAccStamnet.FindFirst() then begin
                            Report.Run(50008, TRUE, FALSE, BankAccStamnet);
                        end;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.CalcFields("Total Reconciled", "Total Unreconciled");
        If Rec."Cash Book Balance" <> (Rec."Balance Last Statement" + Rec."Total Reconciled" + Rec."Total Unreconciled") then begin
            Rec."Cash Book Balance" := (Rec."Balance Last Statement" + Rec."Total Reconciled" + Rec."Total Unreconciled");
            Rec.Modify();
        end;
    end;
}
