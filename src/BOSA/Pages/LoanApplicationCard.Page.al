page 50203 "Loan Application Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Approval,Posting,Reversal,Refinancing,Notification';
    RefreshOnActivate = true;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Member Category"; "Member Category")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Borrower Type"; "Borrower Type")
                {
                    ApplicationArea = All;
                }

                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;

                    trigger OnValidate()
                    begin
                        ValidateLoanProduct;
                    end;

                }
                group("Insurance Cost1")
                {
                    Caption = '';
                    Visible = insurranceQutationVisible;
                    field("Insurance Cost"; "Insurance Cost")
                    {

                        ApplicationArea = all;
                        trigger OnValidate()
                        var
                            LoanRep: Record "Loan Repayment Schedule";
                        begin
                            Clear(Rec."Monthly Installments");

                            CurrPage.Update();
                            BosaManagement.CreateRepaymentSchedule(Rec."No.", Rec."Approved Amount");
                            LoanRep.Reset();
                            LoanRep.SetRange("Loan No.", Rec."No.");
                            if LoanRep.FindFirst() then begin
                                Rec."Monthly Installments" := LoanRep."Total Installment";
                                Rec.Modify();
                            end;
                        end;

                    }
                }
                group("interestOnIPF")
                {
                    Caption = '';
                    Visible = insurranceQutationVisible;
                    field("Interest Charged On IPF"; "Interest Charged On IPF")
                    {

                        ApplicationArea = all;

                    }
                }
                group("processingOnIPF")
                {
                    Caption = '';
                    Visible = insurranceQutationVisible;
                    field("Processing Fee On IPF"; "Processing Fee On IPF")
                    {

                        ApplicationArea = all;

                    }
                }
                group("insurranceOnIPF")
                {
                    Caption = '';
                    Visible = insurranceQutationVisible;
                    field("Insurrance On IPF"; "Insurrance On IPF")
                    {

                        ApplicationArea = all;

                    }
                }
                group("installmentsOnIPF")
                {
                    Caption = '';
                    Visible = insurranceQutationVisible;
                    field("Monthly installments"; "Monthly installments")
                    {
                        Caption = 'monthly Installments On IPF';
                        ApplicationArea = all;

                    }
                }
                field("Guarantorship Mode"; "Guarantorship Mode")
                {
                    ApplicationArea = all;
                }
                group(Refinance)
                {
                    Caption = '';
                    Editable = "Status" = 0;
                    field("Top-up"; "Top-up")
                    {
                        ApplicationArea = All;

                    }
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;
                    trigger OnValidate()
                    var
                        LoanRep: Record "Loan Repayment Schedule";
                    begin
                        Clear(Rec."Monthly Installments");

                        CurrPage.Update();
                        BosaManagement.CreateRepaymentSchedule(Rec."No.", Rec."Approved Amount");
                        LoanRep.Reset();
                        LoanRep.SetRange("Loan No.", Rec."No.");
                        if LoanRep.FindFirst() then begin
                            Rec."Monthly Installments" := LoanRep."Total Installment";
                            Rec.Modify();
                        end;
                    end;
                }
                field("Apply Special Repayment Rates"; "Apply Special Repayment Rates")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;
                }
                /*   field("External Loan"; "External Loan")
                  {
                      ApplicationArea = All;
                      Editable = Status = 0;
                  }
                  group(ExternalLoan)
                  {
                      Caption = '';
                      Visible = "External Loan" = TRUE;

                      field("Institution Name"; "Institution Name")
                      {
                          ApplicationArea = All;
                      }
                      field("Institution Branch Name"; "Institution Branch Name")
                      {
                          ApplicationArea = All;
                      }

                  } */
                group(Savings)
                {
                    Caption = '';
                    Visible = IsSavingsVisible;
                    field("Total Savings Amount"; "Total Savings Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Loan Savings Ratio"; "Loan Savings Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Max. Eligible Amount-Savings"; "Max. Eligible Amount-Savings")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Shares)
                {
                    Caption = '';
                    Visible = IsSharesVisible;
                    field("Total Shares Amount"; "Total Shares Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Loan Shares Ratio"; "Loan Shares Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Max. Eligible Amount-Shares"; "Max. Eligible Amount-Shares")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Deposits)
                {
                    Caption = '';
                    Visible = IsDepositsVisible;
                    field("Total Deposits Amount"; "Total Deposits Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Loan Deposits Ratio"; "Loan Deposits Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Max. Eligible Amount-Deposit"; "Max. Eligible Amount-Deposit")
                    {
                        ApplicationArea = All;
                    }
                }

                field("Total Outstanding Loans"; "Total Outstanding Loans")
                {
                    ApplicationArea = All;
                }
                group(ReqAmount)
                {
                    Caption = '';
                    Enabled = Consolidation = false;
                    field("Requested Amount"; "Requested Amount")
                    {
                        Editable = Status = 0;
                        ApplicationArea = All;
                    }
                }

                group(DisbursalDetails)
                {
                    Caption = '';
                    Visible = Status = 2;
                    Group(DisbDetails)
                    {
                        Caption = '';
                        Visible = Consolidation = false;
                        field("Mode of Disbursement"; "Mode of Disbursement")
                        {
                            ApplicationArea = All;
                        }
                        field("Disbursal Account No."; "Disbursal Account No.")
                        {
                            ApplicationArea = All;
                        }
                        field("Disbursal Account Name"; "Disbursal Account Name")
                        {
                            ApplicationArea = All;
                        }
                        field("External Document No."; "External Document No.")
                        {
                            ApplicationArea = All;
                        }
                        field("Loan Approved Amount"; "Approved Amount")
                        {
                            //Visible = Posted;
                            ApplicationArea = All;
                        }
                        field("Mobile Loan Transaction Charges"; "Mobile Loan Transaction Charges")
                        {
                            Visible = MBVisible;
                            ApplicationArea = All;
                        }
                    }
                    field("Disbursal Date"; "Disbursal Date")
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                }
                field("Economic Sector"; "Economic Sector")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;

                }
                field("Economic Sector Category"; "Economic Sector Category")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;
                }
                field("Economic Sector Sub-Category"; "Economic Sector Sub-Category")
                {
                    ApplicationArea = All;
                    Editable = Status = 0;
                }
                group(BankDetails)
                {
                    Caption = '';
                    Visible = Status = 2;
                    Group(BankDisbDetails)
                    {
                        Caption = '';
                        Visible = Consolidation = false;
                        field("Bank Code"; "Bank Code")
                        {
                            ApplicationArea = All;
                        }
                        field("Bank Name"; "Bank Name")
                        {
                            ApplicationArea = All;
                        }
                        field("Bank Branch Code"; "Bank Branch Code")
                        {
                            ApplicationArea = All;
                        }
                        field("Bank Branch Name"; "Bank Branch Name")
                        {
                            ApplicationArea = All;
                        }
                        field("Bank Account No."; "Bank Account No.")
                        {
                            ApplicationArea = All;
                        }
                    }
                }

                /*  group(FOSAAccount)
                 {
                     Caption = '';
                     Visible = "Mode of Disbursement" = 0;


                 }
                 group(MobileBanking)
                 {
                     Caption = '';
                     Visible = "Mode of Disbursement" = 1;
                     field(Disbursal Account No.; Disbursal Account No.)
                     {
                         ApplicationArea = All;
                     }
                 }
                 group(RTGS)
                 {
                     Caption = '';
                     Visible = "Mode of Disbursement" = 2;
                     field("Reference Account No."; Disbursal Account No.)
                     {
                         ApplicationArea = All;
                     }
                 } */

                field("No. of Guarantors"; "No. of Guarantors")
                {
                    ApplicationArea = All;
                }
                field("Total Guaranteed Amount"; "Total Guaranteed Amount")
                {
                    ApplicationArea = All;
                }
                field("No. of Collaterals"; "No. of Collaterals")
                {
                    ApplicationArea = All;
                }
                field("Total Collateral Amount"; "Total Collateral Amount")
                {
                    ApplicationArea = All;
                }
                group(Approved)
                {
                    Caption = '';
                    Visible = "Status" = 1;
                    field("Approved Amount"; "Approved Amount")
                    {
                        ApplicationArea = All;
                    }
                    field(Remarks; Remarks)
                    {
                        ApplicationArea = All;
                    }
                }

                group(RefinanceInfo)
                {
                    Caption = '';
                    Visible = "Top-up" = TRUE;
                    field("No. of Loans Refinanced"; "No. of Loans Refinanced")
                    {
                        ApplicationArea = All;
                    }
                    field("Total Refinanced Amount"; "Total Refinanced Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                group(ConsolidationInfo)
                {
                    Caption = '';
                    Visible = Consolidation = TRUE;
                    field("No. of Loans Consolidated"; "No. of Loans Consolidated")
                    {
                        ApplicationArea = All;
                    }
                    field("Total Consolidated Amount"; "Total Consolidated Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Next Due Date"; "Next Due Date")
                {
                    ApplicationArea = All;
                }
                field("Date of Completion"; "Date of Completion")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            group("Salary Analysis")
            {
                Caption = 'Salary Analysis';
                Visible = IsSalaryAnalysisVisible;
                field("Basic Salary"; "Basic Salary")
                {
                    ApplicationArea = All;
                }
                field("Total Deduction Amount"; "Total Deduction Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; "Net Amount")
                {
                    ApplicationArea = All;
                }
                group(Payroll)
                {
                    Caption = '';
                    Visible = "Member Category" = 0;
                    field("Payroll No."; "Payroll No.")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Company Name"; "Company Name")
                {
                    ApplicationArea = All;
                }
            }
            group("Payout Analysis")
            {
                Caption = 'Payout Analysis';
                Visible = IsPayoutAnalysisVisible;
                field("No. of KG"; "No. of KG")
                {
                    ApplicationArea = All;
                }
                field("Rate per KG"; "Rate per KG")
                {
                    ApplicationArea = All;
                }
                field("View Payout History"; "View Payout History")
                {
                    ApplicationArea = All;
                }
                field("Total Payout Amount"; "Total Payout Amount")
                {
                    ApplicationArea = All;
                }
            }
            group(CreatedBy)
            {
                Caption = 'Created By';
                Visible = "Status" = 0;
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
            group(AppraisedBy)
            {
                Caption = 'Appraised By';
                Visible = "Status" = 1;
                field("Appraised By"; "Appraised By")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Date"; "Appraisal Date")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Time"; "Appraisal Time")
                {
                    ApplicationArea = All;
                }
                field("Appraised By Host Name"; "Appraised By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Appraised By Host IP"; "Appraised By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Appraised By Host MAC"; "Appraised By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
            group(ApprovedBy)
            {
                Caption = 'Approved By';
                Visible = "Status" = 2;
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; "Approved Time")
                {
                    ApplicationArea = All;
                }
                field("Approved By Host Name"; "Approved By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Approved By Host IP"; "Approved By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Approved By Host MAC"; "Approved By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
            group(Adjustment)
            {
                Caption = 'Repayment Adjustment';
                Visible = "Posted" = TRUE;
                field("Repayment Adjustment Amount"; "Repayment Adjustment Amount")
                {
                    ApplicationArea = All;
                }
                field("Repayment Adjustment"; "Repayment Adjustment")
                {
                    ApplicationArea = All;
                }
            }
            group(DebtCollection)
            {
                Caption = 'Loan Debt Collection';
                Visible = "Posted" = TRUE;

                field("Place Loan Under Debt Collection"; "Place Loan Under Debt Collection")
                { }
                field("Debt Recovery Officer ID"; "Debt Recovery Officer ID")
                {
                    ApplicationArea = All;
                    Editable = "Place Loan Under Debt Collection";
                }
                field("Debt Recovery Officer Name"; "Debt Recovery Officer Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Under Debt Collection By"; "Loan Under Debt Collection By")
                {
                    Caption = 'Loan Under Debt Collection By';
                    ApplicationArea = All;
                }
                field("Loan Under Debt Collection Date"; "Loan Under Debt Collection Date")
                {
                    Caption = 'Loan Under Debt Collection Date';
                    ApplicationArea = All;
                }
                field("Loan Under Debt Collection Time"; "Loan Under Debt Collection Time")
                {
                    Caption = 'Loan Under Debt Collection Time';
                    ApplicationArea = All;
                }
                field("Loan Under Debt Collection By Host IP"; "Loan Under Debt Collection By Host IP")
                {
                    Caption = 'Loan Under Debt Collection By Host IP';
                    ApplicationArea = All;
                }
                field("Loan Under Debt Collection By Host MAC"; "Loan Under Debt Collection By Host MAC")
                {
                    Caption = 'Loan Under Debt Collection By Host MAC';
                    ApplicationArea = All;
                }
                field("Loan Under Debt Collection By Host Name"; "Loan Under Debt Collection By Host Name")
                {
                    Caption = 'Loan Under Debt Collection By Host Name';
                    ApplicationArea = All;
                }
            }
            group(Pause)
            {
                Caption = 'Pause Loan Recivables';
                Visible = "Posted" = TRUE;
                group(PauseInt)
                {
                    Caption = 'Pause Interest';
                    field("Pause Loan Interest"; "Pause Loan Interest")
                    { }
                    field("Int Paused By"; "Int Paused By")
                    {
                        Caption = 'Interest Paused By';
                    }
                    field("Int Paused Date"; "Int Paused Date")
                    {
                        Caption = 'Interest Paused Date';
                    }
                    field("Int Paused Time"; "Int Paused Time")
                    {
                        Caption = 'Interest Paused Time';
                    }
                    field("Int Paused By Host IP"; "Int Paused By Host IP")
                    {
                        Caption = 'Interest Paused By Host IP';
                    }
                    field("Int Paused By Host MAC"; "Int Paused By Host MAC")
                    {
                        Caption = 'Interest Paused By Host MAC';
                    }
                    field("Int Paused By Host Name"; "Int Paused By Host Name")
                    {
                        Caption = 'Interest Paused By Host Name';
                    }
                }
                group(PausePen)
                {
                    Caption = 'Pause Penalty';
                    field("Pause Loan Penalty"; "Pause Loan Penalty")
                    { }
                    field("Pen Paused By"; "Pen Paused By")
                    {
                        Caption = 'Penalty Paused By';
                    }
                    field("Pen Paused Date"; "Pen Paused Date")
                    {
                        Caption = 'Penalty Paused Date';
                    }
                    field("Pen Paused Time"; "Pen Paused Time")
                    {
                        Caption = 'Penalty Paused Time';
                    }
                    field("Pen Paused By Host IP"; "Pen Paused By Host IP")
                    {
                        Caption = 'Penalty Paused By Host IP';
                    }
                    field("Pen Paused By Host MAC"; "Pen Paused By Host MAC")
                    {
                        Caption = 'Penalty Paused By Host MAC';
                    }
                    field("Pen Paused By Host Name"; "Pen Paused By Host Name")
                    {
                        Caption = 'Penalty Paused By Host Name';
                    }
                }
            }

            group(DisbursedBy)
            {
                Caption = 'Disbursed By';
                Visible = "Posted" = TRUE;
                field("Disbursed By"; "Disbursed By")
                {
                    ApplicationArea = All;
                }
                field("Disbursal Time"; "Disbursal Time")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By Host Name"; "Disbursed By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By Host IP"; "Disbursed By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By Host MAC"; "Disbursed By Host MAC")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = All;
                    Importance = Additional;

                }
            }
        }
        area(factboxes)
        {
            part(Page; "Loan Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");

            }
            part(AttachmentFactBox; "Attachement FactBox")
            {
                Caption = 'Attachment';
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Loan Guarantors")
            {
                ApplicationArea = All;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    LoanGuarantor.FILTERGROUP(10);
                    LoanGuarantor.SETRANGE("Loan No.", Rec."No.");
                    LoanGuarantor.FILTERGROUP(0);
                    PAGE.RUN(50210, LoanGuarantor);
                end;
            }
            action("Debtors")
            {
                ApplicationArea = All;
                Image = DepositSlip;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    debtCollection.FILTERGROUP(10);
                    debtCollection.SETRANGE("Loan No.", Rec."No.");
                    debtCollection.FILTERGROUP(0);
                    PAGE.RUN(51099, debtCollection);
                end;
            }
            action("Loan Collaterals")
            {
                ApplicationArea = All;
                Image = Lock;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    LoanCollateral.FILTERGROUP(10);
                    LoanCollateral.SETRANGE("Loan No.", Rec."No.");
                    LoanCollateral.FILTERGROUP(0);
                    PAGE.RUN(50209, LoanCollateral);
                end;
            }
            action("LoanRefinancingEntry")
            {
                Caption = 'Loans to Refinance';
                ApplicationArea = All;
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = "Top-up";

                trigger OnAction()
                var
                begin
                    LoanRefinancingEntry.FILTERGROUP(10);
                    LoanRefinancingEntry.SETRANGE("Loan No.", Rec."No.");
                    LoanRefinancingEntry.FILTERGROUP(0);
                    PAGE.RUN(50211, LoanRefinancingEntry);
                end;
            }
            action("LoanConsolidationEntry")
            {
                Caption = 'Loans to Consolidate';
                ApplicationArea = All;
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Consolidation;

                trigger OnAction()
                var
                begin
                    LoanConsolidationEntry.FILTERGROUP(10);
                    LoanConsolidationEntry.SETRANGE("Loan No.", Rec."No.");
                    LoanConsolidationEntry.FILTERGROUP(0);
                    PAGE.RUN(59211, LoanConsolidationEntry);
                end;
            }
        }
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = IsVisibleSendApprovalRequest;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    If not Consolidation then begin
                        TESTFIELD("Requested Amount");
                        If "Guarantors Notified" = false then
                            Error('Guarantors have to be notified first');
                        // ValidateAttachment;

                        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
                            IF ((LoanProductType."Security Type" = LoanProductType."Security Type"::"Guarantors Only") OR
                               (LoanProductType."Security Type" = LoanProductType."Security Type"::Both)) THEN BEGIN
                                IF NOT GetGuarantors THEN
                                    ERROR(Error000)
                                ELSE BEGIN
                                    CALCFIELDS("No. of Guarantors");
                                    IF "No. of Guarantors" < CheckMinimumGuarantors THEN
                                        ERROR(Error001, CheckMinimumGuarantors);
                                    IF GetTotalSecurityAmount + "Max. Eligible Amount-Deposit" < "Requested Amount" THEN
                                        ERROR(Error004, "No.");
                                END;
                            END;
                            IF ((LoanProductType."Security Type" = LoanProductType."Security Type"::"Collaterals Only") OR
                               (LoanProductType."Security Type" = LoanProductType."Security Type"::Both)) THEN BEGIN
                                IF NOT GetSecurities THEN
                                    ERROR(Error005);
                            END;
                            IF LoanProductType."Security Type" = LoanProductType."Security Type"::Either THEN BEGIN
                                IF GetTotalSecurityAmount + "Max. Eligible Amount-Deposit" < "Requested Amount" THEN
                                    ERROR(Error004, "No.");
                            END;

                            IF "Top-up" THEN BEGIN
                                CALCFIELDS("No. of Loans Refinanced", "Total Refinanced Amount");
                                TESTFIELD("No. of Loans Refinanced");
                                TESTFIELD("Total Refinanced Amount");
                                if "Total Refinanced Amount" > "Requested Amount" then
                                    Error(RefinancedAmountExceedsReqAmountErr, FieldCaption("Total Refinanced Amount"), FieldCaption("Requested Amount"));
                            END;
                        END;
                    end else begin
                        IF Consolidation THEN BEGIN
                            CALCFIELDS("No. of Loans Consolidated", "Total Consolidated Amount");
                            TESTFIELD("No. of Loans Consolidated");
                            TESTFIELD("Total Consolidated Amount");
                            "Requested Amount" := "Total Consolidated Amount";
                            "Approved Amount" := "Total Consolidated Amount";
                            Modify();
                        END;
                    end;
                    IF ApprovalsMgmt.CheckLoanApplicationApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendLoanApplicationForApproval(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                Visible = IsVisibleCancelApprovalRequest;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    ApprovalsMgmt.OnCancelLoanApplicationApprovalRequest(Rec);
                    WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = IsApproveVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    If Consolidation = true then begin
                        CalcFields("Total Consolidated Amount");
                        "Requested Amount" := "Total Consolidated Amount";
                        "Approved Amount" := "Total Consolidated Amount";
                        Modify();
                    end;
                    TESTFIELD("Approved Amount");
                    TESTFIELD(Remarks);
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    ApprovalEntry.SetRange("Approver ID", UserId);
                    IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                        error('You dont have permission to approve this document');
                    END;

                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    ApprovalEntry.SetRange("Approver ID", UserId);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;
                    END;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';
                Visible = IsRejectVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin

                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);

                    CurrPage.CLOSE;
                end;
            }

            action(Return)
            {
                ApplicationArea = All;
                Caption = 'ReOpen Document';
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Return to the initial approval stage.';
                Visible = ReOpenVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if Status = Status::"Pending Approval" then
                        Status := Status::New;
                    if Status = Status::Approved then
                        Status := Status::New;
                    modify();
                    CurrPage.Close();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = IsDelegateVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    TESTFIELD("Approved Amount");
                    TESTFIELD(Remarks);

                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPostVisible;
                ApplicationArea = All;
                ToolTip = 'Post loan and create new loan account';

                trigger OnAction()
                var
                    MobileLedgerEntries: Record "Mobile Banking Ledger Entry";
                begin
                    If Rec."Loan Product Type" <> 'MB' then begin
                        If Consolidation = False then
                            TESTFIELD("Disbursal Account No.");
                        TestField("Disbursal Date");
                    end;
                    IF CONFIRM(Text000, TRUE) THEN BEGIN
                        If Rec."Loan Product Type" <> 'MB' then begin
                            BOSAManagement.PostLoan(Rec);
                        end else begin
                            MobileLedgerEntries.Reset();
                            MobileLedgerEntries.SetRange("Account No.", Rec."No.");
                            MobileLedgerEntries.SetRange("Service ID", 730);
                            if MobileLedgerEntries.FindFirst() then
                                BOSAManagement.DisburseELoanToMpesa(Rec, MobileLedgerEntries."Transaction No.", Rec."Mobile Loan Transaction Charges");
                        end;
                    END ELSE
                        EXIT;
                end;
            }
            action(Reverse)
            {
                ApplicationArea = All;
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Category8;
                Visible = Posted = true;
                ToolTip = 'Reverse posted loan';
                trigger OnAction();
                var

                begin
                    if Confirm(ReverseLoanConfirmMsg, true, "No.") then
                        BOSAManagement.ReverseLoan(Rec);
                end;
            }

            action("Notify Guarantors")
            {
                ApplicationArea = All;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                Visible = "No. of Guarantors" > 0;
                ToolTip = 'Send notification to guarantors and Loanee';
                trigger OnAction()
                begin
                    if Confirm(NotifyGuarantorsConfirmMsg, true, "No.") then begin
                        RecRef.GetTable(Rec);
                        BOSAManagement.SendNotification(RecRef);
                        "Guarantors Notified" := true;
                        Modify();
                        Message('SMS to guarantors and Loanee sent succesfully!');
                    end;
                end;
            }


        }
        area(Reporting)
        {
            action("Preview Schedule")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                ToolTip = 'Preview loan repayment schedule';
                trigger OnAction()
                begin

                    IF not Posted THEN BEGIN
                        TESTFIELD("Requested Amount");
                        BOSAManagement.CreateRepaymentSchedule("No.", "Requested Amount");
                        COMMIT;
                    END else begin
                        BOSAManagement.CreateRepaymentSchedule("No.", "Approved Amount");
                        COMMIT;
                        //if "Loan Restructured" = true then
                        //BOSAManagement.CreateRepaymentScheduleRestructure("No.", "Approved Amount");
                    END;

                    LoanApplication.GET("No.");
                    LoanApplication.SETRECFILTER;
                    REPORT.RUN(REPORT::"Loan Repament Schedule", TRUE, FALSE, LoanApplication);
                end;
            }
            action("Loan Appraisal Report")
            {
                Image = Voucher;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = Status = 0;
                ToolTip = 'Preview loan appraisal report';
                trigger OnAction()
                begin
                    TestField("Repayment Period");
                    TestField("Requested Amount");
                    If "Guarantors Notified" = false then
                        Error('Guarantors have to be notified first before appraisal stage');

                    BOSAManagement.CreateRepaymentSchedule("No.", "Requested Amount");

                    COMMIT;
                    LoanApplication.GET("No.");
                    LoanApplication.SETRECFILTER;
                    REPORT.RUN(REPORT::"Loan Appraisal Report", TRUE, FALSE, LoanApplication);
                end;
            }
            action("Loan Voucher")
            {
                Image = Voucher;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = Posted = true;
                ToolTip = 'Preview loan voucher';
                trigger OnAction()
                begin

                    LoanApplication.GET("No.");
                    LoanApplication.SETRECFILTER;
                    REPORT.RUN(REPORT::"Loan Voucher", TRUE, FALSE, LoanApplication);
                end;
            }
            action(LoanStatement)
            {
                Caption = 'Loan Statement';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Preview loan statement';
                trigger OnAction()
                begin
                    LoanApplication.FILTERGROUP(10);
                    LoanApplication.SETRANGE("Member No.", Rec."Member No.");
                    LoanApplication.SetRange("No.", Rec."No.");
                    LoanApplication.FILTERGROUP(0);
                    Report.RUN(50081, true, false, LoanApplication);
                end;
            }
            action("First Demand Letter")
            {
                Image = Voucher;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = Posted = true;
                ToolTip = 'First Demand Letter';
                trigger OnAction()
                begin
                    LoanApplication.GET("No.");
                    LoanApplication.SETRECFILTER;
                    REPORT.RUN(REPORT::"First Demand Letter", TRUE, FALSE, LoanApplication);
                end;
            }
            action("Final Demand Letter")
            {
                Image = Voucher;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = Posted = true;
                ToolTip = 'Final Demand Letter';
                trigger OnAction()
                begin
                    LoanApplication.GET("No.");
                    LoanApplication.SETRECFILTER;
                    REPORT.RUN(REPORT::"Final Demand Letter", TRUE, FALSE, LoanApplication);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.AttachmentFactBox.PAGE.SetParameter(Rec.RECORDID, Rec."No.");
    end;

    trigger OnOpenPage()
    var
        GlobalM: Codeunit "Global Management";
    begin
        PageVisibility;
        /// PageEditable;
        ValidateLoanProduct;
        //CalcFields("Outstanding Balance");
        //if "Outstanding Balance" > 0 then begin
        //GlobalM.CalculateLoanArrearsAndOverpayment("No.", 0D, Today, ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2]);
        // Message(' ArrearsAmount[1] %1, ArrearsAmount[2] %2, ArrearsAmount[3] %3, ArrearsAmount[4] %4, OverpaymentAmount[1] %5, OverpaymentAmount[2] %6', ArrearsAmount[1], ArrearsAmount[2], ArrearsAmount[3], ArrearsAmount[4], OverpaymentAmount[1], OverpaymentAmount[2]);
        /* "Principal Arrears" := ArrearsAmount[1];
         "Interest Arrears" := ArrearsAmount[2];
         "Ledger Fee Arrears" := ArrearsAmount[3];
         "Penalty Arrears" := ArrearsAmount[4];
         "Principal Overpayment" := OverpaymentAmount[1];
         "Interest Overpayment" := OverpaymentAmount[2];
         "Total Arrears" := ArrearsAmount[1] + ArrearsAmount[2] + ArrearsAmount[3] + ArrearsAmount[4];
         Modify();*/
        // end;
    end;


    local procedure PageVisibility()
    begin
        IF Status = Status::New THEN BEGIN
            IsVisibleSendApprovalRequest := TRUE;
            IsVisibleCancelApprovalRequest := TRUE;
        END ELSE BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := FALSE;
        END;

        IF Status = Status::"Pending Approval" THEN BEGIN
            IsApproveVisible := TRUE;
            IsRejectVisible := TRUE;
            IsDelegateVisible := TRUE;
        END ELSE BEGIN
            IsApproveVisible := FALSE;
            IsRejectVisible := FALSE;
            IsDelegateVisible := FALSE;
        END;

        IF Status = Status::Approved THEN
            IsPostVisible := TRUE
        ELSE
            IsPostVisible := FALSE;

        IF Posted THEN
            IsPostVisible := FALSE;

        IF Posted THEN
            ReOpenVisible := FALSE
        Else
            ReOpenVisible := true;
        If "Loan Product Type" <> 'MB' then
            MBVisible := False
        else
            MBVisible := True;
    end;

    local procedure PageEditable()
    begin
        IF Status = Status::Approved THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;
    end;

    local procedure ValidateLoanProduct()
    begin
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF LoanProductType."Based on Savings" THEN
                IsSavingsVisible := TRUE
            ELSE
                IsSavingsVisible := FALSE;

            IF LoanProductType."Based on Shares" THEN
                IsSharesVisible := TRUE
            ELSE
                IsSharesVisible := FALSE;

            IF LoanProductType."Based on Deposits" THEN
                IsDepositsVisible := TRUE
            ELSE
                IsDepositsVisible := FALSE;

            // IF LoanProductType."Mode of Disbursement" = LoanProductType."Mode of Disbursement"::"FOSA Account" THEN
            //     IsFOSAVisible := TRUE
            // ELSE
            //     IsFOSAVisible := FALSE;

            // IF LoanProductType."Mode of Disbursement" = LoanProductType."Mode of Disbursement"::"Mobile Banking" THEN
            //     IsMobileVisible := TRUE
            // ELSE
            //     IsMobileVisible := FALSE;
            if LoanProductType.Code = 'IPF' then
                insurranceQutationVisible := true
            else
                insurranceQutationVisible := false;


        END;
    end;

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanCollateral: Record "Loan Collateral";
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
        LoanConsolidationEntry: Record "Loan Consolidation Entry";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        Error000: Label 'Guarantors are required';
        Error001: Label 'You must have at least %1 guarantors';
        Error002: Label 'Total guaranteed amount cannot be zero!';
        Error003: Label 'Total security amount cannot be zero!';
        Error004: Label 'Loan No. %1 is not fully guaranteed.';
        Error005: Label 'Collaterals are required';
        LoanProductType: Record "Loan Product Type";
        IsSavingsVisible: Boolean;
        IsSharesVisible: Boolean;
        IsDepositsVisible: Boolean;
        BOSAManagement: Codeunit "BOSA Management";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        IsApproveVisible: Boolean;
        IsRejectVisible: Boolean;
        IsDelegateVisible: Boolean;
        IsPostVisible: Boolean;
        IsMobileVisible: Boolean;
        IsFOSAVisible: Boolean;
        Text000: Label 'Do you want to disburse this Loan?';
        IsSalaryAnalysisVisible: Boolean;
        IsPayoutAnalysisVisible: Boolean;
        LoanApplication: Record "Loan Application";
        ReverseLoanConfirmMsg: Label 'Do you want to reverse loan %1?';
        FieldEditable: Boolean;
        NotifyGuarantorsConfirmMsg: Label 'Do you want to notify guarantors for loan %1?';
        RecRef: RecordRef;
        RefinancedAmountExceedsReqAmountErr: Label '%1 exceeds the %2';
        ReOpenVisible: Boolean;
        insurranceQutationVisible: Boolean;
        debtCollection: Record "debtors";
        MBVisible: Boolean;

}

