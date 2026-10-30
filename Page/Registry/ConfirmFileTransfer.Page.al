page 55706 "Confirm File Transfer"
{
    // version CBS-TL,REG

    CardPageID = "Transfer Files Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Transfer Registry File";
    SourceTableView = WHERE(Status = CONST("Pending Receipt"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transfer ID"; "Transfer ID")
                {
                }
                field("Time Released"; "Time Released")
                {
                }
                field("Released From"; "Released From")
                {
                }
                field("Released To"; "Released To")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        FILTERGROUP(2);
        SETRANGE("Released To", USERID);
        FILTERGROUP(0);
        CurrPage.EDITABLE(FALSE);
    end;

    var
        User: Record "User Setup";
}

