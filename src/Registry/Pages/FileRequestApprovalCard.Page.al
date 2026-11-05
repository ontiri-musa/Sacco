page 55715 "File Request Approval Card"
{
    // version CBS-TL,REG

    PageType = Card;
    SourceTable = "File Issuance";

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
                field("Required Date"; "Required Date")
                {
                    Editable = false;
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                    Editable = false;
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Requisiton By"; "Requisiton By")
                {
                }
                field(Reason; Reason)
                {
                    Editable = false;
                }
                field("Request Status"; "Request Status")
                {
                }
            }
            part("Registry Files Subform"; 55716)
            {
                Caption = 'Registry Files Request List';
                Editable = false;
                SubPageLink = "Request ID" = FIELD("Request ID");
            }
            group(Remarks)
            {
                field("Approval Comment"; "Approval Comment")
                {

                    trigger OnValidate();
                    begin
                        "Approver ID" := USERID;
                    end;
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send To Registry")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    User.GET(USERID);
                    TESTFIELD("Approval Comment");
                    IF User."User ID" <> '' THEN BEGIN
                        IF CONFIRM('Are you sure you want to approve this file request?') THEN BEGIN
                            ApprovedRequests := RequestsRec.COUNT;
                            ApprovedRequests := 0;
                            RequestsRec.SETRANGE("Request ID", "Request ID");
                            RequestsRec.SETFILTER("HOD Approval", 'True');
                            IF RequestsRec.FIND('-') THEN BEGIN
                                //MESSAGE('success');
                                REPEAT
                                    ApprovedRequests := ApprovedRequests + 1;
                                UNTIL
                                  RequestsRec.NEXT = 0;
                                // MESSAGE('%1',ApprovedRequests);
                            END;
                            IF ApprovedRequests > 0 THEN BEGIN
                                IF "Request Status" = "Request Status"::"Pending Approval" THEN
                                    "Request Status" := "Request Status"::Active;
                                "Approver ID" := USERID;
                                ApprovedDate := TODAY;
                                ApprovedTime := TIME;
                                "Approved Date" := CREATEDATETIME(ApprovedDate, ApprovedTime);
                                MESSAGE('Approved Requests have been sent to Registry for approval');
                            END ELSE BEGIN
                                ERROR('You have not approved any file request.');
                            END;

                            /*  RequestsRec.RESET;
                              RequestsRec.SETRANGE("Request ID","Request ID");
                              RequestsRec.SETFILTER("HOD Rejected",'True');
                              IF RequestsRec.FIND('-') THEN BEGIN
                               // MESSAGE('success');
                                REPEAT
                                  FileNo:=RequestsRec."File No.";
                                  FileName:=RequestsRec."File Name";
                                  Comment:=RequestsRec."HOD Comments";
                                UNTIL
                                  RequestsRec.NEXT=0;*/

                            //send mail to registry
                            bddialog.OPEN('Sending email to registry');
                            User.RESET;
                            User.GET("Requisiton By");
                            RegistrySetUp.RESET;
                            RegistrySetUp.GET;
                            mailheader := 'NOTIFICATION OF FILE REQUESTED';
                            mailbody := 'Dear Registry <br><br>';
                            mailbody := mailbody + 'Please Note that the following file(s) have been requested under request ID: <b>' + "Request ID" + ' by ' + "Requisiton By" + '</b> <br><br>';
                            RegisterLines.RESET;
                            RegisterLines.SETRANGE("Request ID", "Request ID");
                            RegisterLines.SETRANGE("HOD Approval", TRUE);
                            IF RegisterLines.FINDSET THEN BEGIN
                                REPEAT
                                    mailbody := mailbody + ' File No: <b>' + RegisterLines."File Number" + '</b> File Name <b> ' + RegisterLines."File Name" + '</b> Member No. <b>' + RegisterLines."Member No." + '</b> ID No. <b>' + RegisterLines."ID No." + '</b> <br><br>';
                                UNTIL
                                 RegisterLines.NEXT = 0;
                            END;
                            mailbody := mailbody + 'Please confirm the availability of the files <br><br>';
                            mailbody := mailbody + 'Kind Regards<br><br>';
                            mailbody := mailbody + '<i>Registry</i><bt><br>';
                            smtprec.RESET;
                            smtprec.GET;
                            //smtpcu.CreateMessage('Registry Request',smtprec."User ID",RegistrySetUp."Registry Email",mailheader,mailbody,TRUE);
                            //smtpcu.AddBCC(User."E-Mail");
                            //smtpcu.Send;

                            bddialog.CLOSE;
                            MESSAGE(FORMAT('Email sent.'));

                            /*//send email to Registry for the requested files
                                 bddialog.OPEN('Sending email to Registry');
                                 User.RESET;
                                 User.GET("Requisiton By");
                                 mailheader:='NOTIFICATION FOR FILES REQUESTED';
                                 mailbody:='Dear Registry,<br><br>';
                                 mailbody:=mailbody+'Please Note that the following file(s) have been requested for under request ID: <b>'+"Request ID"+'</b> by :<br><br>'+"Requisiton By";
                                     RequestsRec.RESET;
                                     RequestsRec.SETRANGE("Request ID","Request ID");
                                     RequestsRec.SETFILTER("HOD Approval",'True');
                                     IF RequestsRec.FIND('-') THEN BEGIN
                                      // MESSAGE('success');
                                       REPEAT
                                         mailbody:=mailbody+'File No: <b>'+"File No."+'  '+"File Name"+'</b> <br><br>';
                                       UNTIL
                                         RequestsRec.NEXT=0;
                                     END;
                                 //mailbody:=mailbody+'Reason <b>'+Comment+'</b> <br><br>';
                                 //mailbody:=mailbody+'Rejected By: <b>'+"Approver ID"+'</b> <br><br>';
                                 mailbody:=mailbody+'Kind Regards<br><br>';
                                 mailbody:=mailbody+'<i>Registry User</i><bt><br>';
                                 smtprec.RESET;
                                 smtprec.GET;
                                 RegistrySetUp.RESET;
                                 RegistrySetUp.GET;
                                 smtpcu.CreateMessage('Registry',smtprec."User ID",RegistrySetUp."Registry Email",mailheader,mailbody,TRUE);
                                 smtpcu.Send;

                             bddialog.CLOSE;
                             MESSAGE(FORMAT('Email sent.')); */

                            RequestsRec.RESET;
                            RequestsRec.SETRANGE("Request ID", "Request ID");
                            RequestsRec.SETFILTER("HOD Rejected", 'True');
                            IF RequestsRec.FIND('-') THEN BEGIN
                                //send email for the rejected file request
                                bddialog.OPEN('Sending email to the file requester');
                                User.RESET;
                                User.GET("Requisiton By");
                                mailheader := 'NOTIFICATION FOR A REJECTED FILE REQUEST';
                                mailbody := 'Dear ' + "Requisiton By" + ',<br><br>';
                                mailbody := mailbody + 'Please Note that the following file(s) that you requested for under request ID: <b>' + "Request ID" + '</b> has been rejected.<br><br>';
                                RequestsRec.RESET;
                                RequestsRec.SETRANGE("Request ID", "Request ID");
                                RequestsRec.SETFILTER("HOD Rejected", 'True');
                                IF RequestsRec.FIND('-') THEN BEGIN
                                    REPEAT
                                        mailbody := mailbody + ' File No: <b>' + RegisterLines."File Number" + '</b> File Name <b> ' + RegisterLines."File Name" + '</b> Member No. <b>' + RegisterLines."Member No." + '</b> ID No. <b>' + RegisterLines."ID No." + '</b> <br><br>';
                                        Comment := RequestsRec."HOD Comments";
                                    UNTIL
                                      RequestsRec.NEXT = 0;
                                END;
                                mailbody := mailbody + 'Reason <b>' + Comment + '</b> <br><br>';
                                mailbody := mailbody + 'Rejected By: <b>' + "Approver ID" + '</b> <br><br>';
                                mailbody := mailbody + 'Kind Regards<br><br>';
                                mailbody := mailbody + '<i>Registry</i><bt><br>';
                                smtprec.RESET;
                                smtprec.GET;
                                smtpcu.CreateMessage('Registry', smtprec."User ID", User."E-Mail", mailheader, mailbody, TRUE);
                                // smtpcu.AddBCC();
                                //smtpcu.Send;

                                bddialog.CLOSE;
                                MESSAGE(FORMAT('Email sent.'));
                            END;
                        END;
                        // END;

                        RegistryFilesLines.RESET;
                        RegistryFilesLines.SETRANGE("Request ID", Rec."Request ID");
                        IF RegistryFilesLines.FIND('-') THEN BEGIN
                            REPEAT
                                IF RegistryFilesLines.Status2 = RegistryFilesLines.Status2::"Pending Approval" THEN BEGIN
                                    RegistryFilesLines.Status2 := RegistryFilesLines.Status2::Active;
                                    RegistryFilesLines.Status2 := RegistryFilesLines.Status2::Active;
                                    RegistryFilesLines.MODIFY;
                                END;
                            UNTIL
                              RegistryFilesLines.NEXT = 0;
                        END;
                    END ELSE BEGIN
                        ERROR('You have not been set up as a HOD approver.');
                        EXIT;

                    END;
                    CurrPage.CLOSE;

                end;
            }
            action("Reject Request")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    User.GET(USERID);
                    TESTFIELD("Approval Comment");
                    IF User."User ID" <> '' THEN BEGIN
                        IF CONFIRM('Are you sure you want to reject this file request?') THEN BEGIN
                            ApprovedRequests := RequestsRec.COUNT;
                            ApprovedRequests := 0;
                            RequestsRec.SETRANGE("Request ID", "Request ID");
                            RequestsRec.SETFILTER("HOD Approval", 'false');
                            IF RequestsRec.FIND('-') THEN BEGIN
                                //MESSAGE('success');
                                REPEAT
                                    ApprovedRequests := ApprovedRequests + 1;
                                UNTIL
                                  RequestsRec.NEXT = 0;
                                // MESSAGE('%1',ApprovedRequests);
                            END ELSE BEGIN
                                ERROR('You have not approved any file request.');
                            END;
                            IF ApprovedRequests = 0 THEN BEGIN
                                IF "Request Status" = "Request Status"::"Pending Approval" THEN
                                    "Request Status" := "Request Status"::"Not Approved";
                                MESSAGE('Request Rejected');
                            END;

                            //send email for the rejected file request
                            bddialog.OPEN('Sending email to the file requester');
                            User.RESET;
                            User.GET("Requisiton By");
                            mailheader := 'NOTIFICATION FOR A REJECTED FILE REQUEST';
                            mailbody := 'Dear ' + "Requisiton By" + ',<br><br>';
                            mailbody := mailbody + 'Please Note that the following file(s) that you requested for under request ID: <b>' + "Request ID" + '</b> has been rejected.<br><br>';
                            RequestsRec.RESET;
                            RequestsRec.SETRANGE("Request ID", "Request ID");
                            RequestsRec.SETFILTER("HOD Rejected", 'True');
                            IF RequestsRec.FIND('-') THEN BEGIN
                                REPEAT
                                    mailbody := mailbody + 'File No: <b>' + "File No." + '  ' + "File Name" + '</b> <br><br>';
                                    Comment := RequestsRec."HOD Comments";
                                UNTIL
                                  RequestsRec.NEXT = 0;
                            END;
                            mailbody := mailbody + 'Reason <b>' + Comment + '</b> <br><br>';
                            mailbody := mailbody + 'Rejected By: <b>' + "Approver ID" + '</b> <br><br>';
                            mailbody := mailbody + 'Kind Regards<br><br>';
                            mailbody := mailbody + '<i>Registry</i><bt><br>';
                            smtprec.RESET;
                            smtprec.GET;
                            smtpcu.CreateMessage('Registry', smtprec."User ID", User."E-Mail", mailheader, mailbody, TRUE);
                            // smtpcu.AddBCC();
                            smtpcu.Send;

                            bddialog.CLOSE;
                            MESSAGE(FORMAT('Email sent.'));

                        END;


                        RegistryFilesLines.RESET;
                        RegistryFilesLines.SETRANGE("Request ID", Rec."Request ID");
                        IF RegistryFilesLines.FIND('-') THEN BEGIN
                            IF RegistryFilesLines.Status2 = RegistryFilesLines.Status2::"Pending Approval" THEN BEGIN
                                RegistryFilesLines.Status2 := RegistryFilesLines.Status2::"Not Approved";
                                RegistryFilesLines.Status2 := RegistryFilesLines.Status2::"Not Approved";
                                RegistryFilesLines.MODIFY;
                            END;
                        END;

                    END ELSE BEGIN
                        MESSAGE('You have not been set up as a registry approver.');
                        EXIT;

                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Approver ID" := USERID;
    end;

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        RequestsRec.Status2 := RequestsRec.Status2::"Pending Approval";
    end;

    var
        FileRegistry: Record "Registry SetUp";
        Simple: Boolean;
        User: Record "User Setup";
        ApprovedRequests: Integer;
        RequestsRec: Record "Registry Files Line";
        HODApproval: Boolean;
        FileNo: Code[10];
        FileName: Text;
        Comment: Text;
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistryFilesLines: Record "Registry Files Line";
        RegistrySetUp: Record "Registry File Status";
        RegisterLines: Record "Registry Files Line";
        ApprovedDate: Date;
        ApprovedTime: Time;
}

