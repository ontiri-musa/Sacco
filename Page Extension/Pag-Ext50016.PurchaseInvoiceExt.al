pageextension 50016 PurchaseInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        modify("Invoice Details")
        {
            Visible = false;
        }

        modify("Shipping and Payment")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
    }
}
