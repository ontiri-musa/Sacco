page 50206 "Loan Appl. List-Pending Dbsl"
{
    // version TL2.0

    Caption = 'Loans Pending Disbursal';
    CardPageID = "Loan Application Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Batch Posting,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = FILTER(Approved),
                            Posted = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = All;
    /* Editable = false;
    DeleteAllowed = false;
    
    ModifyAllowed = false; */

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
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
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Shares Amount"; "Total Shares Amount")
                {
                    ApplicationArea = All;
                }
                field("Top-up"; "Top-up")
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
            action("Post Batch Loans")
            {
                ApplicationArea = All;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Post Batch Loans';
                RunObject = report "Post Batch Loans";
            }

        }
    }

    trigger OnOpenPage()
    begin
        SetActionVisible;
        CurrPage.Editable(false);
    end;

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanCollateral: Record "Loan Collateral";
        //LoanOffset: Record "50106";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        PostBatchLoansConfirmMsg: Label 'Do you want to post batch loans?';

    local procedure SetActionVisible()
    begin
    end;
}

