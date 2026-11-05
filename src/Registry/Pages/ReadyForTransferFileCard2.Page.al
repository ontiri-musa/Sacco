page 55700 "Ready For Transfer File Card2"
{
    // version CBS-TL,REG

    PageType = Card;
    SourceTable = "File Movement";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("File Movement ID"; "File Movement ID")
                {
                    ApplicationArea = All;
                }
                field("File No."; "File No.")
                {
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member No"; "Member No")
                {
                    ApplicationArea = All;
                }
                field("ID No"; "ID No")
                {
                    ApplicationArea = All;
                }
                field("Payroll No"; "Payroll No")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Cabinet No."; "Cabinet No.")
                {
                    ApplicationArea = All;
                }
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                }
                field("From Location"; "From Location")
                {
                    Caption = 'From Branch';
                    ApplicationArea = All;
                }
                field("To Location"; "To Location")
                {
                    Caption = 'To Branch';
                    ApplicationArea = All;
                }
                field("Request Remarks"; "Request Remarks")
                {
                    ApplicationArea = All;
                }
                field("Approval/Rejection Remarks"; "Approval/Rejection Remarks")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                }
                field("Released By"; "Released By")
                {
                    Editable = false;
                }
                field("Released To"; "Released To")
                {
                    ApplicationArea = All;
                }
                field("Carried By"; "Carried By")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Date Released"; "Date Released")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Dispatch File")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    User.GET(USERID);
                    TESTFIELD("Released To");
                    IF CONFIRM('Are you sure you want to Dispatch File') THEN BEGIN
                        IF Status = Status::"Ready For Transfer" THEN
                            Status := Status::Dispatched;
                        MESSAGE('File Dispatched');

                        "Released By" := USERID;
                        "Date Released" := CURRENTDATETIME;

                        //send mail to file requester
                        bddialog.OPEN('Sending email to file requester');
                        User.GET("Requested By");
                        RegistrySetUp.RESET;
                        RegistrySetUp.GET;
                        mailheader := 'NOTIFICATION OF FILE MOVEMENT APPROVED AND DISPATCHED';
                        mailbody := 'Dear' + "Requested By" + ' <br><br>';
                        mailbody := mailbody + 'Please Note that the following file(s) have been requested for transfer under request ID: <b>' + "File Movement ID" + '</b>have been approved and dipatched. <br><br>';
                        mailbody := mailbody + '<b> File No:' + "File Number" + ' ' + "File Name" + '</b> <br><br>';
                        mailbody := mailbody + 'Released by:' + "Released By" + ' <br><br>';
                        mailbody := mailbody + 'Carried by:' + "Carried By" + ' <br><br>';
                        mailbody := mailbody + 'Please confirm the receipt of the files <br><br>';
                        mailbody := mailbody + 'Kind Regards<br><br>';
                        mailbody := mailbody + '<i>Registry</i><bt><br>';
                        smtprec.RESET;
                        smtprec.GET;
                        smtpcu.CreateMessage('Registry Request', smtprec."User ID", User."E-Mail", mailheader, mailbody, TRUE);
                        //smtpcu.AddBCC('evawaithera4@gmail.com');
                        IF RegistrySetUp."Registry Email" <> '' THEN BEGIN
                            //smtpcu.AddCC(RegistrySetUp."Registry Email");
                        END;
                        smtpcu.Send;

                        bddialog.CLOSE;
                        MESSAGE('Email Sent');
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        "Released By" := USERID;
        "Date Released" := CURRENTDATETIME;
        //"Released To":="Requested By";
    end;

    var
        User: Record "User Setup";
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegisterLines: Record "Registry Files Line";
        RegistrySetUp: Record "Registry SetUp";
}

