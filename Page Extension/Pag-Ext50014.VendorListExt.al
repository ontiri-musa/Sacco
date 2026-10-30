pageextension 50014 VendorListExt extends "Vendor List"
{
    layout
    {
        addafter("Search Name")
        {
            field(Balance; Balance)
            {

            }
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
    }
}
