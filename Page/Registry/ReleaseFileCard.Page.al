page 55719 "Release File Card"
{
    // version CBS-TL,REG

    PageType = Card;
    SourceTable = "Issued Registry File";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request ID"; "Request ID")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Requisiton By"; "Requisiton By")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field(Overdue; Overdue)
                {
                }
            }
            part("Registry Files Subform"; 55716)
            {
                Caption = 'Registry Files Request List';
                SubPageLink = "Request ID" = FIELD("Request ID");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Release File")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to release the file(s)?') THEN BEGIN
                        RegistryFilesLines.SETRANGE("Request ID", "Request ID");
                        RegistryFilesLines.SETRANGE("Registry Approval", TRUE);
                        IF RegistryFilesLines.FINDSET THEN BEGIN
                            REPEAT
                                //MESSAGE('success');
                                RegistryFilesLines.Returned := TRUE;
                                RegistryFilesLines.MODIFY;
                            UNTIL
                             RegistryFilesLines.NEXT = 0;
                        END;
                        Returned := TRUE;

                        RegisterLines.RESET;
                        RegisterLines.SETRANGE("Request ID", "Request ID");
                        IF RegisterLines.FINDSET THEN BEGIN
                            REPEAT
                                FileRegistry.RESET;
                                // FileRegistry.SETRANGE("File No.",RegisterLines."File No.");
                                FileRegistry.SETRANGE("File Number", RegisterLines."File Number");
                                IF FileRegistry.FINDSET THEN BEGIN
                                    FileRegistry.Issued := FALSE;
                                    FileRegistry."File Request Status" := FileRegistry."File Request Status"::"In Registry";
                                    FileRegistry."Current User" := '';
                                    FileRegistry.MODIFY;
                                END;
                            UNTIL RegisterLines.NEXT = 0;
                        END;

                    END;
                    MESSAGE('File Released Successfully!');
                end;
            }
            action("Transfer Request")
            {
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 55721;
                // RunPageLink = "Request ID" = FIELD("Request ID");

                Visible = false;
            }
            action("Request File Transfer")
            {
                Image = Replan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to request?') THEN BEGIN
                        FileRequestsTrail.RESET;
                        FileRequestsTrail.INIT;
                        FileRequestsTrail."Request ID" := "Request ID";
                        FileRequestsTrail.Requester := USERID;
                        FileRequestsTrail."Request Date" := TODAY;
                        ThisRec.RESET;
                        ThisRec.SETRANGE("Request ID", "Request ID");
                        IF ThisRec.FINDLAST THEN BEGIN
                            FileRequestsTrail."Request No." := ThisRec."Request No." + 1;
                        END;
                        IF NOT ThisRec.FINDLAST THEN BEGIN
                            FileRequestsTrail."Request No." := 1;
                        END;
                        FileRequestsTrail.INSERT;
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        IF "Requisiton By" <> USERID THEN BEGIN
            SeeRequest := TRUE;
        END;

        //Overdue := Overdue::" ";
        IF FormatField(Rec) THEN
            Overdue := TRUE;

        IF "Due Date" < CURRENTDATETIME THEN
            Overdue := TRUE;
    end;

    var
        FileRegistry: Record "Registry File";
        Simple: Boolean;
        IssuedFiles: Record "Issued Registry File";
        RequestFiles: Record "File Issuance";
        RegistryFilesLines: Record "Registry Files Line";
        FileRequestsTrail: Record "File Requests Trail";
        SeeRequest: Boolean;
        ThisRec: Record "File Requests Trail";
        RegisterLines: Record "Registry Files Line";
        Overdue: Boolean;

    local procedure FormatField(Files: Record "Issued Registry File"): Boolean;
    begin
        IF "Due Date" < CURRENTDATETIME THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure FileIsOverdue(): Boolean;
    begin
    end;
}

