page 50271 "Guarantor Substitution Subform"
{
    // version TL2.0

    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Guarantor Substitution Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Guaranteed Amount"; "Guaranteed Amount")
                {
                    Caption = 'Current Guaranteed Amount';
                    ApplicationArea = All;
                }
                field("No. of Guarantors"; "No. of Guarantors")
                {
                    ApplicationArea = All;
                }
                field("Substitution Amount"; "Substitution Amount")
                {
                    ApplicationArea = All;
                }
                field("Substitution Amount Collateral"; "Substitution Amount Collateral")
                {
                    ApplicationArea = All;
                }
                field(Substitute; Substitute)
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
            action(SubstituteAction)
            {
                Caption = 'Substitute Member';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TESTFIELD(Substitute, TRUE);
                    GuarantorSubstitutionHeader.GET("Document No.");
                    GuarantorSubstitutionHeader.TESTFIELD(Status, GuarantorSubstitutionHeader.Status::New);

                    GuarantorSubAllocation.FILTERGROUP(10);
                    GuarantorSubAllocation.SETRANGE("Document No.", Rec."Document No.");
                    GuarantorSubAllocation.SETRANGE("Guarantor Member No.", Rec."Member No.");
                    GuarantorSubAllocation.FILTERGROUP(0);
                    PAGE.RUN(50277, GuarantorSubAllocation);
                end;
            }
            action(SubstituteCollateral)
            {
                Caption = 'Substitute With Collateral';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TESTFIELD(Substitute, TRUE);
                    GuarantorSubstitutionHeader.GET("Document No.");
                    GuarantorSubstitutionHeader.TESTFIELD(Status, GuarantorSubstitutionHeader.Status::New);

                    collateralSubAllocation.FILTERGROUP(10);
                    collateralSubAllocation.SETRANGE("Document No.", Rec."Document No.");
                    collateralSubAllocation.FILTERGROUP(0);
                    PAGE.RUN(51209, collateralSubAllocation);
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
                ToolTip = 'Send notification to guarantors';
                trigger OnAction()
                begin
                    GuarantorSubstitutionHeader.Get("Document No.");
                    if Confirm(NotifyGuarantorsConfirmMsg, true, GuarantorSubstitutionHeader."Loan No.") then begin
                        RecRef.GetTable(GuarantorSubstitutionHeader);
                        BOSAManagement.SendNotification(RecRef);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageVisibility;
    end;

    var
        GuarantorSubAllocation: Record "Guarantor Allocation";
        IsVisibleSubstituteGuarantor: Boolean;
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        RecRef: RecordRef;
        NotifyGuarantorsConfirmMsg: Label 'Do you want to notify guarantors for loan %1?';
        BOSAManagement: Codeunit "BOSA Management";
        collateralSubAllocation: Record "Loan Collateral Substitution";

    local procedure PageVisibility()
    var
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
    begin
        IF GuarantorSubstitutionHeader.GET("Document No.") THEN BEGIN
            IF GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::New THEN
                IsVisibleSubstituteGuarantor := TRUE
            ELSE
                IsVisibleSubstituteGuarantor := FALSE;
        END;
    end;
}

