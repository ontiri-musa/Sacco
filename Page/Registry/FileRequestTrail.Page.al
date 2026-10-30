page 55721 "File Request Trail"
{
    // version CBS-TL,REG

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "File Requests Trail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request ID"; "Request ID")
                {
                }
                field("Request No."; "Request No.")
                {
                }
                field(Requester; Requester)
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Approval Date"; "Approval Date")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeApprovals;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to approve?') THEN BEGIN
                        "Approver ID" := USERID;
                        "Approval Date" := TODAY;
                        IssuedRegistryFiles.RESET;
                        IssuedRegistryFiles.SETRANGE("Request ID", "Request ID");
                        IF IssuedRegistryFiles.FINDSET THEN BEGIN
                            RegistryFilesLines.RESET;
                            RegistryFilesLines.SETRANGE("Request ID", IssuedRegistryFiles."Request ID");
                            IF RegistryFilesLines.FINDSET THEN BEGIN
                                REPEAT
                                    RegistryFilesLines."Other User" := Requester;
                                    RegistryFilesLines.MODIFY;
                                    "File Transferred" := TRUE;
                                    MODIFY;
                                UNTIL RegistryFilesLines.NEXT = 0;
                            END;
                        END;
                        MESSAGE('Approval Successful');
                    END;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeApprovals;
            }
        }
    }

    trigger OnOpenPage();
    begin
        IssuedRegistryFiles.RESET;
        IssuedRegistryFiles.SETRANGE("Request ID", "Request ID");
        IF IssuedRegistryFiles.FINDSET THEN BEGIN
            IF IssuedRegistryFiles."Request ID" <> '' THEN BEGIN
                SeeApprovals := TRUE;
            END;
        END;
    end;

    var
        SeeApprovals: Boolean;
        IssuedRegistryFiles: Record "Issued Registry File";
        RegistryFilesLines: Record "Registry Files Line";
}

