page 50784 "Open Tender App. Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Tender Pre-Opening,Tender Opening,Tender Evaluation,Evaluated Tender,LPO Stage';
    SourceTable = "Procurement Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Requisition No."; "Requisition No.")
                {
                    Editable = EditRequisitionNo;
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Procurement Plan No."; "Procurement Plan No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Advertisement Date"; "Advertisement Date")
                {
                    ApplicationArea = All;
                }
                field("Tender Fee"; "Tender Fee")
                {
                    ApplicationArea = All;
                }
                field("Tender Extension Period"; "Tender Extension Period")
                {
                    ApplicationArea = All;
                }
                field("Minimum Tender Submissions"; "Minimum Tender Submissions")
                {
                    ApplicationArea = All;
                }
                field("Category Code"; "Category Code")
                {
                    ApplicationArea = All;
                }
                field("Category Description"; "Category Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Process Status"; "Process Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Assigned User"; "Assigned User")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Forwarded to Opening"; "Forwarded to Opening")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Evaluation Complete"; "Evaluation Complete")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Contract Generated"; "Contract Generated")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Contract No."; "Contract No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("LPO Generated"; "LPO Generated")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("LPO No."; "LPO No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(page; "Procurement Request Line")
            {
                Editable = false;
                SubPageLink = "Request No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Document Attachments")
            {
                field("Attached Process Details"; "Attached Process Details")
                {
                    Caption = 'Attached Tender Document';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Tender Document Path"; "Process Detail path")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attached Opening Minutes"; "Attached Opening Minutes")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Opening Minutes Path"; "Opening Minutes Path")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attached Evaluation Minutes"; "Attached Evaluation Minutes")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Evaluation Minutes Path"; "Evaluation Minutes Path")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attached Professional Opinion"; "Attached Professional Opinion")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Professional Opinion Path"; "Professional Opinion Path")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attached Contract"; "Attached Contract")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Contract Path"; "Contract Path")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Process Dates")
            {
                Caption = 'Process Dates';
                field("Created On"; "Created On")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Closing Date"; "Closing Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Closing Time"; "Closing Time")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Date"; "Evaluation Date")
                {
                    ApplicationArea = All;
                }
                field("Notification of Award Date"; "Notification of Award Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Signing Date"; "Contract Signing Date")
                {
                    ApplicationArea = All;
                }
                field("Award Approval Date"; "Award Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Process Completion Date"; "Process Completion Date")
                {
                    ApplicationArea = All;
                }
                field("Opening Date"; "Opening Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attach Tender Document")
            {
                ApplicationArea = All;
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeNew;

                trigger OnAction();
                begin
                    ProcurementManagement.AttachSubmittedDocument(Rec, 5);
                end;
            }
            action("View Tender Document")
            {
                ApplicationArea = All;
                Enabled = SeeNew2;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 5);
                end;
            }
            action("Update Tender Application")
            {
                ApplicationArea = All;
                Caption = 'Update Tender Application';
                Image = CustomerRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                Visible = SeeNew;

                trigger OnAction();
                begin
                    ProcurementManagement.CheckMandatoryFields(Rec);
                    ProcurementManagement.UpdateTenderApplication(Rec);
                end;
            }
            action("Validate Tender Fee Payment")
            {
                ApplicationArea = All;
                Caption = 'Validate Tender Fee Payment';
                Image = CompareCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                Visible = SeeNew;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedSuppliers(Rec, 4);
                end;
            }
            action("View Selected Suppliers")
            {
                ApplicationArea = All;
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = false;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedSuppliers(Rec, 5);
                end;
            }
            action("Close Tender Submissions")
            {
                ApplicationArea = All;
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = false;
                Visible = SeeNew;

                trigger OnAction();
                begin
                    ProcurementManagement.CheckMandatoryFields(Rec);
                    ProcurementManagement.CloseTenderSubmission(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Select Opening Committee")
            {
                ApplicationArea = All;
                Image = SuggestCustomerBill;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = SeePendingOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.SelectOpeningCommittee(Rec, 1);
                    //CurrPage.CLOSE;
                end;
            }
            action("View Opening Members")
            {
                ApplicationArea = All;
                Image = SocialSecurity;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = false;
                Visible = SeeAllStages1;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedCommittee(Rec, 1);
                end;
            }
            action("Submit For Opening")
            {
                ApplicationArea = All;
                Image = UntrackedQuantity;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = false;
                PromotedOnly = false;
                Visible = SeePendingOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.ForwardForOpening(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Attach Opening Minutes")
            {
                ApplicationArea = All;
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Visible = SeeOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.AttachSubmittedDocument(Rec, 1);
                end;
            }
            action("View Opening Minutes")
            {
                ApplicationArea = All;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = false;
                Visible = SeeAllStages2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 1);
                end;
            }
            action("Select Evaluation Committee")
            {
                ApplicationArea = All;
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Visible = SeeOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.SelectOpeningCommittee(Rec, 2);
                end;
            }
            action("View Evaluation Members")
            {
                ApplicationArea = All;
                Image = SocialSecurity;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = false;
                Visible = SeeAllStages2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedCommittee(Rec, 2);
                end;
            }
            action("Submit For Evaluation")
            {
                ApplicationArea = All;
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Category5;
                Visible = SeeOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.ForwardProcessToNextStage(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Tender Evaluation")
            {
                ApplicationArea = All;
                Image = Troubleshoot;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeAllStages3;

                trigger OnAction();
                begin
                    ProcurementManagement.StartEvaluationProcess(Rec, 1);
                end;
            }
            action("Attach Evaluation Minutes")
            {
                ApplicationArea = All;
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    TESTFIELD("Evaluation Complete", TRUE);
                    ProcurementManagement.ValidateCommitteeMemberPosition(Rec, 1);
                    ProcurementManagement.AttachSubmittedDocument(Rec, 2);
                end;
            }
            action("View Evaluation Minutes")
            {
                ApplicationArea = All;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeAllStages3;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 2);
                end;
            }
            action("Forward To Procurement Manager")
            {
                ApplicationArea = All;
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    ProcurementManagement.CompleteEvaluation(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Return To Evaluation")
            {
                ApplicationArea = All;
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Category6;
                Visible = SeeEvaluated;

                trigger OnAction();
                begin
                    ProcurementManagement.CompleteEvaluation(Rec, 2);
                    CurrPage.CLOSE;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Enabled = SeeEvaluated2;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = SeeEvaluated;

                trigger OnAction();
                begin
                    IF ApprovalsMgmt.CheckProcurementProcessApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendProcurementProcessForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Enabled = SeeEvaluated3;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = SeeEvaluated;

                trigger OnAction();
                begin
                    ApprovalsMgmt.OnCancelProcurementProcurementProcessRequest(Rec);
                    CurrPage.CLOSE;
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
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

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
                Visible = SeeApprovals;

                trigger OnAction();
                var
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
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Category6;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            action("Attach Proffessional Opinion")
            {
                ApplicationArea = All;
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeCEO;

                trigger OnAction();
                begin
                    TESTFIELD("Evaluation Complete", TRUE);
                    ProcurementManagement.AttachSubmittedDocument(Rec, 3);
                end;
            }
            action("View Proffessional Opinion")
            {
                ApplicationArea = All;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = false;
                PromotedOnly = false;
                Visible = SeeAllStages4;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 3);
                end;
            }
            action("Select & Award Supplier")
            {
                ApplicationArea = All;
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeCEO;

                trigger OnAction();
                begin
                    TESTFIELD("Attached Professional Opinion", TRUE);
                    ProcurementManagement.StartEvaluationProcess(Rec, 2);
                end;
            }
            action("Generate Contract")
            {
                ApplicationArea = All;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeContract;

                trigger OnAction();
                begin
                    TESTFIELD("Contract No.", '');
                    TESTFIELD("LPO Generated", FALSE);
                    ProcurementManagement.GenerateContract(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("View Contract Generated")
            {
                ApplicationArea = All;
                Image = ContractPayment;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = false;
                PromotedOnly = false;
                Visible = SeeLPO2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewContractDocument(Rec);
                end;
            }
            action("View Signed Contract")
            {
                ApplicationArea = All;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = false;
                PromotedOnly = false;
                Visible = SeeLPO2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 6);
                end;
            }
            action("Generate Purchase Order")
            {
                ApplicationArea = All;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeLPO;

                trigger OnAction();
                begin
                    //TESTFIELD("Contract Generated", FALSE);
                    TESTFIELD("Attached Contract");
                    ProcurementManagement.GenerateLPO(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("View Posted LPO")
            {
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        ManageVisibility;
    end;

    trigger OnAfterGetRecord();
    begin
        ManageVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Procurement Option" := "Procurement Option"::"Open Tender";
        ProcurementMethod.RESET;
        ProcurementMethod.SETRANGE(Method, ProcurementMethod.Method::"Open Tender");
        IF ProcurementMethod.FINDFIRST THEN
            "Procurement Method" := ProcurementMethod.Code;
        ManageVisibility;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ManageVisibility;
    end;

    trigger OnOpenPage();
    begin
        ManageVisibility;
        CALCFIELDS("Process Summary");
        "Process Summary".CREATEINSTREAM(TenderInstr);
        TenderInstr.READ(TenderDescTxt);
    end;

    var
        ProcurementManagement: Codeunit "Procurement Management";
        RequisitionLines: Record "Requisition Line";
        SeeGenerate: Boolean;
        ProcurementMethod: Record "Procurement Method";
        SeeNew: Boolean;
        SeeNew2: Boolean;
        SeePendingOpening: Boolean;
        SeeOpening: Boolean;
        SeePendingEvaluation: Boolean;
        SeeEvaluation: Boolean;
        SeeAllStages: Boolean;
        SeeAfterEvaluation: Boolean;
        SeeAllStages1: Boolean;
        SeeAllStages2: Boolean;
        SeeAllStages3: Boolean;
        SeeAllStages4: Boolean;
        SeeAllStages5: Boolean;
        SeeAllStages6: Boolean;
        EditRequisitionNo: Boolean;
        SeeEvaluated: Boolean;
        SeeEvaluated2: Boolean;
        SeeLPO: Boolean;
        SeeEvaluated3: Boolean;
        SeeApprovals: Boolean;
        //ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        ApprovalsMgmt: Codeunit "Approvals Mgmt Proc";
        SeeCEO: Boolean;
        TenderDescTxt: Text;
        TenderInstr: InStream;
        TenderOutstr: OutStream;
        SeeSubmitted: Boolean;
        SeeProposal: Boolean;
        SeeProposal2: Boolean;
        ApprovalEntry: Record "Approval Entry";
        SeeLPO2: Boolean;
        SeeContract: Boolean;

    local procedure ManageVisibility();
    begin
        SeeNew := TRUE;
        SeeNew2 := TRUE;
        IF "Attached Process Details" = FALSE THEN
            SeeNew2 := FALSE;
        SeeAllStages := TRUE;
        EditRequisitionNo := TRUE;

        SeeEvaluated2 := FALSE;
        IF "Process Status" <> "Process Status"::New THEN BEGIN
            SeeNew := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF "Process Status" = "Process Status"::"Pending Opening" THEN BEGIN
            SeePendingOpening := TRUE;
            SeeAllStages1 := TRUE;
        END;

        IF "Process Status" = "Process Status"::Opening THEN BEGIN
            SeeOpening := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages2 := TRUE;
        END;
        IF "Process Status" = "Process Status"::Evaluation THEN BEGIN
            SeeEvaluation := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages2 := TRUE;
            SeeAllStages3 := TRUE;
        END;
        IF ("Process Status" = "Process Status"::"Procurement Manager") OR ("Process Status" = "Process Status"::CEO) THEN BEGIN
            SeeAllStages2 := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages3 := TRUE;
            SeeEvaluated := TRUE;
            SeeAllStages5 := TRUE;
            //SeeAllStages4 := TRUE;
            SeeEvaluated2 := TRUE;
            IF Status = Status::"Pending Approval" THEN BEGIN
                SeeEvaluated2 := FALSE;
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document No.", "No.");
                IF ApprovalEntry.FINDFIRST THEN BEGIN
                    IF ApprovalEntry."Sender ID" = USERID THEN BEGIN
                        SeeEvaluated3 := TRUE;
                        SeeEvaluated2 := FALSE;
                    END;
                END;
                SeeApprovals := true;
            END
            ELSE
                IF Status = Status::Released THEN BEGIN
                    SeeCEO := TRUE;
                    SeeAllStages4 := TRUE;
                    SeeEvaluated2 := FALSE;
                    SeeEvaluated3 := FALSE;
                    SeeEvaluated := FALSE;
                END;
        END;
        IF "Process Status" = "Process Status"::LPO THEN BEGIN
            SeeLPO := TRUE;
            SeeLPO2 := TRUE;
            SeeAllStages2 := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages3 := TRUE;
            SeeAllStages4 := TRUE;
            SeeAllStages6 := TRUE;
            SeeContract := TRUE;
            //SeeAllStages5 := TRUE;
            IF "LPO Generated" THEN BEGIN
                SeeLPO := FALSE;
                SeeLPO2 := TRUE;
            END;
            IF "Contract Generated" THEN
                SeeContract := FALSE;
        END;

        IF "Auto Generated" THEN
            EditRequisitionNo := FALSE;
    end;
}

