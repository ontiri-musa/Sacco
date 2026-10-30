page 50810 "Procurement RoleCenterHeadline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline2; StrSubstNo(text001, PurchaseReq.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50722);
                end;
            }
            field(Headline3; StrSubstNo(text002, StoreReq.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50727);
                end;
            }
            field(Headline4; StrSubstNo(text005, StoreRet.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50735);
                end;
            }
            field(Headline5; StrSubstNo(text004, ProcurementRequest.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50898);
                end;
            }
            field(Headline1; StrSubstNo(text003, UserId))
            {
                ApplicationArea = All;
            }
        }
    }

    var

        text001: TextConst ENU = '<qualifier>Purchase Requisitions</qualifier><payload>You have <emphasize> %1 </emphasize>approved purchase requisitions</payload>';
        //'You have registered %1 members so far';
        text002: TextConst ENU = '<qualifier>Store Requisitions</qualifier><payload>You have <emphasize> %1 </emphasize>approved Store requisitions</payload>';
        text005: TextConst ENU = '<qualifier>Store Return</qualifier><payload>You have <emphasize> %1 </emphasize>approved Store returns</payload>';
        //        text002: TextConst ENU = '<qualifier>Loans</qualifier><payload>You have disbursed<emphasize> %1 </emphasize>loans so far.</payload>';
        //'%1 loans have been disbursed so far';
        text003: TextConst ENU = 'Welcome %1';
        text004: TextConst ENU = '<qualifier>Procurement Requests</qualifier><payload>You have <emphasize> %1 </emphasize>Procurement Requests</payload>';
        PurchaseReq: Record "Requisition Header";
        StoreReq: Record "Requisition Header";
        StoreRet: Record "Requisition Header";
        ProcurementRequest: Record "Procurement Request";

    trigger OnOpenPage();
    begin
        PurchaseReq.Reset();
        PurchaseReq.SetRange("Requisition Type", PurchaseReq."Requisition Type"::"Purchase Requisition");
        PurchaseReq.SetRange(Status, PurchaseReq.Status::Released);

        StoreReq.Reset();
        StoreReq.SetRange("Requisition Type", StoreReq."Requisition Type"::"Store Requisition");
        StoreReq.SetRange(Status, StoreReq.Status::Released);

        StoreRet.Reset();
        StoreRet.SetRange("Requisition Type", StoreRet."Requisition Type"::"Store Return");
        StoreRet.SetRange(Status, StoreRet.Status::Released);

    end;
}