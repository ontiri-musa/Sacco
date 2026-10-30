page 50088 "Net Pay Transfer Card"
{
    Caption = 'Net Pay Transfer Card';
    PageType = Card;
    SourceTable = "Payroll Net Pay Transfer";
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field("Paying Bank"; Rec."Paying Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank field.';
                }
                field("Paying Bank Name"; Rec."Paying Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank Name field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Date field.';
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Time field.';
                }
            }
            part(NetPayTransferLines; NetPayTransferLines)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Creation)
        {
            group(Main)
            {
                action(Post)
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = Rec.Posted = false;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    var
                        PayrolPeriod: Record "Payroll Period";
                    begin
                        if Confirm(PostPaymentVoucherConfirmMsg, true, Rec."No.") then begin
                            PayrollSetup.Get(1);
                            JournalTemplateName := PayrollSetup."General Journal Template Name";
                            JournalBatchName := PayrollSetup."General Journal Batch Name";
                            GlobalManagement.ClearJournal(JournalTemplateName, JournalBatchName);

                            NetPayTransLines.Reset();
                            NetPayTransLines.SetRange("Document No.", Rec."No.");
                            if NetPayTransLines.FindSet() then begin
                                repeat
                                    NetPayTransLines.TestField("Cheque No");
                                    NetPayTransLines.TestField("Cheque Date");
                                    Employee.Get(NetPayTransLines."Employee No");
                                    PayrollProcessing.PayrollProcessNetPay(Employee, NetPayTransLines."Cheque Date", NetPayTransLines."Cheque No", Rec."Payroll Period", Rec."Paying Bank");
                                until NetPayTransLines.Next = 0;
                            end;

                            IF GlobalManagement.PostJournal(JournalTemplateName, JournalBatchName) then begin
                                Rec.Posted := true;
                                Rec."Posted By" := UserId;
                                Rec."Date Posted" := Today;
                                Rec."Posted Time" := Time;
                                Rec.Modify();
                                PayrolPeriod.Reset();
                                PayrolPeriod.SetRange("Starting Date", Rec."Payroll Period");
                                if PayrolPeriod.FindFirst() then begin
                                    PayrolPeriod."NetPay Transfered" := true;
                                    PayrolPeriod.Modify();
                                end;
                            end;
                        end else begin
                            exit;
                        end;
                    end;
                }
            }
        }
    }
    var
        GnLLineNumber: Integer;
        JournalTemplateName: Code[100];
        JournalBatchName: Code[150];
        GlobalManagement: Codeunit "Global Management";
        PayrollSetup: Record "Payroll Setup";
        PayrollProcessing: Codeunit "Payroll Processing";
        Employee: Record Employee;
        NetPayTransLines: Record "PayrollNetPayTrans Lines";
        PayrollEntry: Record "Payroll Entries";
        DeleteAllowed: Boolean;
        PostPaymentVoucherConfirmMsg: Label 'Do you want to post payment voucher %1?';

}
