page 59386 "Default Notification Lines"
{
    PageType = CardPart;
    SourceTable = "Default Notification Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Member No"; "Member No")
                {
                    Editable = false;
                }
                field("Member Name"; "Member Name")
                {
                    Editable = false;
                }
                field("Member Phone No"; "Member Phone No")
                {
                    Editable = false;
                }
                field(Select; Select)
                {
                }
                field("Recovery Amount"; "Recovery Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                Image = Setup;
                action("Select All")
                {
                    Image = SelectLineToApply;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        BulkSMSLine.RESET;
                        BulkSMSLine.SETRANGE(BulkSMSLine."Document No", "Document No");
                        if BulkSMSLine.FINDSET then begin
                            repeat
                                BulkSMSLine.Select := true;
                                BulkSMSLine.MODIFY;
                            until BulkSMSLine.NEXT = 0;
                        end;
                    end;
                }
                action("Un Select All")
                {
                    Image = SelectLineToApply;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        BulkSMSLine.RESET;
                        BulkSMSLine.SETRANGE(BulkSMSLine."Document No", "Document No");
                        if BulkSMSLine.FINDSET then begin
                            repeat
                                BulkSMSLine.Select := false;
                                BulkSMSLine.MODIFY;
                            until BulkSMSLine.NEXT = 0;
                        end;
                    end;
                }
            }
        }
    }

    var
        BulkSMSLine: Record "Default Notification Line";
}

