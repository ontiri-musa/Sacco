pageextension 50020 BankAccStamntLineExt extends "Bank Account Statement Lines"
{
    layout
    {
        modify("Document No.")
        {
            Visible = true;
        }
        modify(Type)
        {
            Visible = false;
        }
        modify(Control16)
        {
            Visible = false;
        }
        modify("Applied Amount")
        {
            Visible = false;
        }
        modify(Difference)
        {
            Visible = false;
        }
    }
}
