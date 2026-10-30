page 55716 "Registry Files Subform2"
{
    // version CBS-TL,REG

    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Registry Files Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("File No."; "File No.")
                {
                    LookupPageID = "Registry File List";
                    Visible = false;
                }
                field("File Number"; "File Number")
                {
                    Editable = false;
                }
                field("File Type"; "File Type")
                {
                    Editable = false;
                }
                field("File Name"; "File Name")
                {
                }
                field("Member No."; "Member No.")
                {
                }
                field("ID No."; "ID No.")
                {
                }
                field("Payroll No."; "Payroll No.")
                {
                }
                field("Member Status"; "Member Status")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Type)
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                    Visible = false;
                }
                field(Volume; Volume)
                {
                }
                field(Location; Location)
                {
                    Visible = false;
                }
                field(Status2; Status2)
                {
                    Visible = false;
                }
                field("Other User"; "Other User")
                {
                    Visible = false;
                }
                field("HOD Approval"; "HOD Approval")
                {
                    Editable = false;
                    Visible = HODApproval;
                }
                field("HOD Rejected"; "HOD Rejected")
                {
                    Visible = HODApproval;
                }
                field("HOD Comments"; "HOD Comments")
                {
                    Visible = false;
                }
                field("Registry Approval"; "Registry Approval")
                {
                    Editable = false;
                    Visible = RegistryApproval;
                }
                field("Registry Rejected"; "Registry Rejected")
                {
                    Visible = RegistryApproval;
                }
                field("Registry Comment"; "Registry Comment")
                {
                    Visible = false;
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
                Caption = 'HOD Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = HODApproval;

                trigger OnAction();
                begin
                    IF Status2 <> Status2::"Pending Approval" THEN
                        ERROR('You cannot approve the request at this stage.');
                    IF CONFIRM('Are you sure you want to approve?') THEN BEGIN
                        "HOD Approval" := TRUE;
                        "Approved/Rejection Time" := CURRENTDATETIME;
                        //MESSAGE('Kindly Fill in your Approval Comment.');
                        "Request Status" := "Request Status"::"HOD Approved";
                        MESSAGE('Approved');
                    END;
                end;
            }
            action("Reject (HOD)")
            {
                Caption = 'HOD Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = HODApproval;

                trigger OnAction();
                begin
                    IF Status2 <> Status2::"Pending Approval" THEN
                        ERROR('You cannot reject the request at this stage.');
                    IF CONFIRM('Are you sure you want to reject?') THEN BEGIN
                        "HOD Rejected" := TRUE;
                        "Approved/Rejection Time" := CURRENTDATETIME;
                        "Request Status" := "Request Status"::"HOD Rejected";
                        MESSAGE('Rejected');
                    END;
                end;
            }
            action("Approve(Registry)")
            {
                Caption = 'Registry Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                begin
                    IF Status2 <> Status2::Active THEN
                        ERROR('You cannot approve the request at this stage.');
                    IF CONFIRM('Are you sure you want to approve?') THEN BEGIN
                        "Registry Approval" := TRUE;
                        "Approved/Rejection Time" := CURRENTDATETIME;
                        "Request Status" := "Request Status"::"Registry Approved";
                        MESSAGE('Approved');
                    END;
                end;
            }
            action("Reject(Registry)")
            {
                Caption = 'Registry Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                begin
                    IF Status2 <> Status2::Active THEN
                        ERROR('You cannot reject the request at this stage.');
                    IF CONFIRM('Are you sure you want to reject?') THEN BEGIN
                        "Registry Rejected" := TRUE;
                        "Approved/Rejection Time" := CURRENTDATETIME;
                        "Request Status" := "Request Status"::"Registry Rejected";
                        MESSAGE('Rejected');
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        User.GET(USERID);

        IF User."User ID" <> '' THEN BEGIN
            HODApproval := TRUE;
        END;

        IF User."User ID" <> '' THEN BEGIN
            RegistryApproval := TRUE;
        END;
    end;

    var
        FilesRegistry: Record "Registry Files Line";
        UserRequestCount: Integer;
        UserRec: Record "Registry Files Line";
        HODApproval: Boolean;
        RegistryApproval: Boolean;
        User: Record "User Setup";
        FileIssuance: Record "File Issuance";
        RegistryApprovals: Record "Registry Requests Approval";
}

