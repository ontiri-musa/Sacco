pageextension 50010 PurchaseLineExt extends "Purch. Invoice Subform"
{
    layout
    {
        addbefore("VAT Prod. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ShowMandatory = true;
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
            }
        }
        addafter("Line Amount")
        {

        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
            ShowMandatory = true;
        }

    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        VATsetup: Record "VAT Posting Setup";
    begin

        VATsetup.Reset();
        VATsetup.SetFilter("VAT Bus. Posting Group", '<>%1', '');
        If VATsetup.FindFirst() then begin
            //Rec."VAT Bus. Posting Group" := VATsetup."VAT Bus. Posting Group";
            //Rec."VAT Prod. Posting Group" := VATsetup."VAT Prod. Posting Group";
        end;
    end;
}
