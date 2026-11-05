page 55720 "Confirm Receipt of Files"
{
    // version CBS-TL,REG

    Editable = false;
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
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Requisiton By"; "Requisiton By")
                {
                    ApplicationArea = All;
                }
                field("Confirm Receipt"; "Confirm Receipt")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Received TimeStamp"; "Received TimeStamp")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Carried By"; "Carried By")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            part("Registry Files Subform"; 55716)
            {
                Caption = 'Registry Files Request List';
                Editable = false;
                SubPageLink = "Request ID" = FIELD("Request ID");
                SubPageView = WHERE("Registry Approval" = CONST(true));
                Visible = false;
            }
            part("Confirm Receipt of Files"; 55716)
            {
                Caption = 'Confirm Receipt of Files';
                Editable = false;
                SubPageLink = "Request ID" = FIELD("Request ID");
                SubPageView = WHERE("Registry Approval" = CONST(true));
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
                Visible = false;

                trigger OnAction();
                begin
                    /*IF CONFIRM ('Are you sure you want to release the file(s)?') THEN BEGIN
                      RegistryFilesLines.SETRANGE("Request ID","Request ID");
                      IF RegistryFilesLines.FINDSET THEN BEGIN
                        REPEAT
                         //MESSAGE('success');
                         RegistryFilesLines.Returned:=TRUE;
                         RegistryFilesLines.MODIFY;
                        UNTIL
                         RegistryFilesLines.NEXT=0;
                      END;
                      Returned:=TRUE;
                    
                        RegisterLines.RESET;
                        RegisterLines.SETRANGE("Request ID","Request ID");
                        IF RegisterLines.FINDSET THEN BEGIN
                           REPEAT
                              FileRegistry.RESET;
                              FileRegistry.SETRANGE("File No.",RegisterLines."File No.");
                              IF FileRegistry.FINDSET THEN BEGIN
                                  FileRegistry.Issued:=FALSE;
                                  FileRegistry.MODIFY;
                              END;
                           UNTIL RegisterLines.NEXT=0;
                        END;
                    
                    END;
                    */

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
                //RunPageLink = "Request ID" = FIELD("Request ID");


            }
            action("Request File Transfer")
            {
                Enabled = false;
                Image = Replan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeRequest;

                trigger OnAction();
                begin
                    /*IF CONFIRM('Are you sure you want to request?') THEN BEGIN
                      FileRequestsTrail.RESET;
                      FileRequestsTrail.INIT;
                      FileRequestsTrail."Request ID":="Request ID";
                      FileRequestsTrail.Requester:=USERID;
                      FileRequestsTrail."Request Date":=TODAY;
                      ThisRec.RESET;
                      ThisRec.SETRANGE("Request ID","Request ID");
                      IF ThisRec.FINDLAST THEN BEGIN
                        FileRequestsTrail."Request No.":=ThisRec."Request No."+1;
                      END;
                      IF NOT ThisRec.FINDLAST THEN BEGIN
                        FileRequestsTrail."Request No.":=1;
                      END;
                      FileRequestsTrail.INSERT;
                    END;
                    */

                end;
            }
            action("Receive File")
            {
                Caption = 'Receive File';
                Image = Receipt;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to confirm receipt of file(s)?') THEN BEGIN

                        RegisterLines.RESET;
                        RegisterLines.SETRANGE("Request ID", "Request ID");
                        IF RegisterLines.FINDSET THEN BEGIN
                            REPEAT
                                RegisterLines."Confirm Receipt" := TRUE;
                                RegisterLines."Received TimeStamp" := CURRENTDATETIME;
                                MODIFY;
                            UNTIL RegisterLines.NEXT = 0;
                        END;


                        //Copy Files received from registry to the transfer files table
                        RegisterLines.RESET;
                        RegisterLines.SETRANGE("Request ID", "Request ID");
                        RegisterLines.SETRANGE("Registry Approval", TRUE);
                        RegisterLines.SETRANGE(Received, TRUE);
                        IF RegisterLines.FINDSET THEN BEGIN
                            REPEAT
                                TransferFilesLines.INIT;
                                TransferFilesLines."File No" := RegisterLines."File No.";
                                TransferFilesLines."File Number" := RegisterLines."File Number";
                                TransferFilesLines."File Name" := RegisterLines."File Name";
                                TransferFilesLines."Member No" := RegisterLines."Member No.";
                                TransferFilesLines."ID No" := RegisterLines."ID No.";
                                TransferFilesLines."Payroll No" := RegisterLines."Payroll No.";
                                TransferFilesLines."Released From" := RegisterLines."Released From";
                                //TransferFilesLines."Released From":='Registry,'+USERID;
                                TransferFilesLines."Time Released" := "Issued Date";
                                TransferFilesLines."Released To" := RegisterLines."Requisition By";
                                TransferFilesLines."Received By" := RegisterLines."Requisition By";
                                TransferFilesLines."Time Received" := CURRENTDATETIME;
                                TransferFilesLines."File Type" := RegisterLines."File Type";
                                TransferFilesLines."Request ID" := RegisterLines."Request ID";
                                TransferFilesLines."Current User" := TRUE;
                                TransferFilesLines."Current User ID" := USERID;
                                TransferFilesLines."Transfer ID" := RegisterLines."Request ID";
                                TransferFilesLines."Request ID" := "Request ID";
                                TransferFilesLines."Due Date" := "Due Date";
                                TransferFilesLines.Returned := FALSE;
                                TransferFilesLines."File Volume" := RegisterLines.Volume;
                                TransferFilesLines."Carried By" := RegisterLines."Requisition By";
                                /* FileRegistry.RESET;
                                 FileRegistry.SETRANGE(FileRegistry."File No.",RegisterLines."File No.");
                                 IF FileRegistry.FIND('-') THEN BEGIN
                                   TransferFilesLines."File Volume":=RegisterLines.Volume;
                                 END;*/
                                TransferFilesLines.INSERT;
                            UNTIL
                              RegisterLines.NEXT = 0;
                        END ELSE BEGIN
                            ERROR('Please confirm receipt of the file');
                        END;

                        IF "Confirm Receipt" = FALSE THEN BEGIN
                            "Confirm Receipt" := TRUE;
                            "Received TimeStamp" := CURRENTDATETIME;
                            MODIFY;
                        END;


                        MESSAGE('You have confirmed receipt of files from registry.');


                        bddialog.OPEN('Sending email of file receipt confirmation');
                        User.RESET;
                        User.GET(USERID);
                        mailheader := 'CONFIRMATION OF RECEIVING FILES FROM REGISTRY';
                        mailbody := 'Dear ' + "Requisiton By" + ',<br><br>';
                        mailbody := mailbody + 'This is to notify that you have confirmed receipt of files under request ID: <b>' + "Request ID" + '</b><br><br>';
                        RegisterLines.RESET;
                        RegisterLines.SETRANGE("Request ID", "Request ID");
                        RegisterLines.SETRANGE("Registry Approval", TRUE);
                        IF RegisterLines.FINDSET THEN BEGIN
                            REPEAT
                                mailbody := mailbody + '<b> File No:' + RegisterLines."File Number" + '</b> Name:<b> ' + RegisterLines."File Name" + '</b> Member No: <b> ' + RegisterLines."Member No." + '</b> ID No <b> ' + RegisterLines."ID No." + '</b> <br><br>';
                            UNTIL
                             RegisterLines.NEXT = 0;
                        END;
                        mailbody := mailbody + 'Have a good day. <br><br>';
                        mailbody := mailbody + 'Kind Regards<br><br>';
                        mailbody := mailbody + '<i>Registry</i><bt><br>';
                        smtprec.RESET;
                        smtprec.GET;
                        smtpcu.CreateMessage('Registry', smtprec."User ID", User."E-Mail", mailheader, mailbody, TRUE);
                        RegistrySetUp.RESET;
                        RegistrySetUp.GET;
                        IF RegistrySetUp."Registry Email" <> '' THEN BEGIN
                            //smtpcu.AddCC(RegistrySetUp."Registry Email");
                        END;
                        //smtpcu.Send;

                        bddialog.CLOSE;
                        MESSAGE(FORMAT('Email sent.'));
                    END;
                    CurrPage.CLOSE;

                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        SETRANGE("Requisiton By", USERID);

        IF "Requisiton By" <> USERID THEN BEGIN
            SeeRequest := TRUE;
        END;

        IF USERID <> "Requisiton By" THEN BEGIN
            ERROR('You cannot receive this file');
        END;
        "Carried By" := "Requisiton By";
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
        TransferFilesLines: Record "Transfer Files Line";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        User: Record "User Setup";
        RegistrySetUp: Record "Registry SetUp";
}

