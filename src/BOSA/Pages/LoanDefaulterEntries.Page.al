page 50302 "Loan Defaulter Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Notification,Attach Guarantor,Reversal,Related Information';
    RefreshOnActivate = true;
    SourceTable = "Loan Defaulter Entry";
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Loan Start Date"; "Loan Start Date")
                { }
                field("Expected Completion Date"; "Expected Completion Date")
                { }
                field("Church District Code"; "Church District Code")
                {
                    Caption = 'District';
                }
                field("Church Section Code"; "Church Section Code")
                {
                    Caption = 'Section';
                }
                field("Phone No"; "Phone No")
                { }
                field("Deposit Balance"; "Deposit Balance" * -1)
                { }
                field("Remaining Period"; "Remaining Period")
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("Remaining Principal Amount"; "Remaining Principal Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining Interest Amount"; "Remaining Interest Amount")
                {
                    ApplicationArea = All;
                }
                field("Principal Installment"; "Principal Installment")
                {
                    ApplicationArea = All;
                }
                field("Interest Installment"; "Interest Installment")
                {
                    ApplicationArea = All;
                }
                field("Total Installment"; "Total Installment")
                {
                    ApplicationArea = All;
                }
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
                field("Classification Class"; "Class Description")
                {
                    ApplicationArea = All;
                }
                field("No. of Days in Arrears"; "No. of Days in Arrears")
                {
                    ApplicationArea = All;
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                    ApplicationArea = All;
                }
                field("No. of Defaulted Installment"; "No. of Defaulted Installment")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Recovery Officer"; "Recovery Officer")
                {
                    ApplicationArea = All;
                }
                field("Place Loan Under Debt Collection"; "Place Loan Under Debt Collection")
                {
                    ApplicationArea = All;
                }

                field("Notice Category"; "Notice Category")
                {
                    ApplicationArea = All;
                }
                field("Notice Date"; "Notice Date")
                {
                    ApplicationArea = All;
                }
                field("Notice Due Date"; "Notice Due Date")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Attached Guarantors")
            {
                ApplicationArea = All;
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = page "Attached Guarantor Entries";
                RunPageLink = "Loan No." = field("Loan No.");

            }

        }
        area(Processing)
        {
            action("Send Defaulter Notice")
            {
                ApplicationArea = All;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Send notices to defaulters';
                trigger OnAction()
                begin
                    if Confirm(SendDefaulterNoticeConfirmMsg, true, "Loan No.", Description) then begin
                        BOSAManagement.SendDefaulterNotice(Rec);
                    end;
                end;

            }
            action("Attach Loan")
            {
                ApplicationArea = All;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Attach Guarantors';
                trigger OnAction()
                begin
                    if Confirm(AttachLoanGuarantorsConfirmMsg, true, "Loan No.", Description) then begin
                        BOSAManagement.AttachLoanToGuarantor(Rec);
                    end;
                end;
            }
            action("Reverse Attached Loan")
            {
                ApplicationArea = All;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ToolTip = 'Reverse Attached Loan';
                trigger OnAction()
                begin

                    if Confirm(ReverseAttachedLoanConfirmMsg, true, "Loan No.", Description) then begin
                        BOSAManagement.ReverseAttachedLoan(Rec);
                    end;
                end;
            }
        }
    }


    var
        SendDefaulterNoticeConfirmMsg: Label 'Do you want to send defaulter notice for loan %1 %2?';
        AttachLoanGuarantorsConfirmMsg: Label 'Do you want to attach guarantors to loan %1 %2?';
        ReverseAttachedLoanConfirmMsg: Label 'Do you want to reverse attached guarantors for loan %1 %2?';
        BOSAManagement: Codeunit "BOSA Management";
        DepositsBal: Decimal;
}

