page 50600 "Cash Management Setup"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Cash Management Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Primary Key"; "Primary Key")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Template Name"; "Payment Template Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Batch Name"; "Payment Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Receipt Template Name"; "Receipt Template Name")
                {
                    ApplicationArea = All;
                }
                field("Receipt Batch Name"; "Receipt Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Imprest Surr. Template Name"; "Imprest Surr. Template Name")
                {
                    ApplicationArea = All;
                }
                field("Imprest Surr. Batch Name"; "Imprest Surr. Batch Name")
                {
                    ApplicationArea = All;
                }
                field("PettyCash Template Name"; "PettyCash Template Name")
                {
                    ApplicationArea = All;
                }
                field("PettyCash Batch Name"; "PettyCash Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Checkoff Template Name"; "Checkoff Template Name")
                {
                    ApplicationArea = All;
                }
                field("Checkoff Batch Name"; "Checkoff Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery Template Name"; "Loan Recovery Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery Batch Name"; "Loan Recovery Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Voucher Nos."; "Payment Voucher Nos.")
                {
                    ApplicationArea = All;
                }
                field("Checkoff Receipt Voucher Nos."; "Checkoff Receipt Voucher Nos.")
                {
                    ApplicationArea = All;
                }
                field("Checkoff Nos."; "Checkoff Nos.")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery Nos."; "Loan Recovery Nos.")
                {
                    ApplicationArea = All;
                }
                field("Imprest Nos."; "Imprest Nos.")
                {
                    ApplicationArea = All;
                }


                field("Imprest Surrender Nos."; "Imprest Surrender Nos.")
                {
                    ApplicationArea = All;
                }
                field("Claim Nos."; "Claim Nos.")
                {
                    ApplicationArea = All;
                }
                field("PettyCash Nos."; "PettyCash Nos.")
                {
                    ApplicationArea = All;
                }
                field("Payroll NetPay Transfer Nos."; "Payroll NetPay Transfer Nos.")
                {
                    ApplicationArea = All;
                }
                field("Receipt Voucher Nos."; "Receipt Voucher Nos.")
                {
                    ApplicationArea = All;
                }
                field("Salary Advance"; "Salary Advance")
                {
                    ApplicationArea = All;
                }

                field("Imprest Path"; "Imprest Path")
                {
                    ApplicationArea = All;
                }
                field("PettyCash Bank"; "PettyCash Bank")
                {
                    ApplicationArea = All;
                }
                field("Budget Admin"; "Budget Admin")
                {
                    ApplicationArea = All;
                }
                field("Use Budget"; "Use Budget")
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
        CashManagementSetup.Reset();
        if not CashManagementSetup.FindFirst then begin
            if CashManagementSetup."Budget Admin" = '' then begin
                CashManagementSetup."Budget Admin" := UserId;
                CashManagementSetup.Insert();
                Message('Success!');
            end;
        end;
    end;

    var
        CashManagementSetup: Record "Cash Management Setup";
}

