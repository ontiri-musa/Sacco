pageextension 50012 PurchaseCreditMemoLinesExt extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
            ShowMandatory = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
            ShowMandatory = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
            ShowMandatory = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
            ShowMandatory = true;
        }
    }
}
