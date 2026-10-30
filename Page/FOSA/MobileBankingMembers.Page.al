page 50149 "Mobile Banking Members List"
{
    // version TL2.0

    Caption = 'Mobile Banking Members';
    CardPageID = "Mobile Banking Member Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,History,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Mobile Banking Member";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Service Type"; "Service Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(UploadMobileMembers)
            {
                ApplicationArea = All;
                Caption = 'Upload Mobile Members', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Image;
                trigger OnAction()
                var
                    MobileBuff: Record MobileBankingBuffer;
                    MobileMember: Record "Mobile Banking Member";
                    Memb: Record Member;
                    UploadMembersXML: XmlPort MobileMembersUpload;
                begin
                    Xmlport.Run(50010, false, true);
                end;
            }

        }
    }
}

