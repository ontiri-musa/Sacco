page 50148 "Mobile Banking Member Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,History,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Mobile Banking Member";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
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
            group(Audit)
            {
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(UpdateList)
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    MobileBuff: Record MobileBankingBuffer;
                    MobileMember: Record "Mobile Banking Member";
                    Memb: Record Member;
                begin
                    MobileBuff.Reset();
                    if MobileBuff.FindSet() then begin
                        repeat
                            Memb.Reset();
                            Memb.SetRange("Phone No.", MobileBuff."Phone No");
                            if Memb.FindFirst() then begin
                                MobileBuff."Member No" := Memb."No.";
                                MobileBuff.Modify();

                                MobileMember.Reset();
                                MobileMember.SetRange("Phone No.", MobileBuff."Phone No");
                                MobileMember.SetRange("Member No.", MobileBuff."Member No");
                                if not MobileMember.FindFirst() then begin
                                    MobileMember.Init();
                                    MobileMember."Member No." := MobileBuff."Member No";
                                    MobileMember."Member Name" := MobileBuff."Member Name";
                                    MobileMember."Phone No." := MobileBuff."Phone No";
                                    MobileMember.Status := MobileMember.Status::Active;
                                    MobileMember."Service Type" := MobileMember."Service Type"::"Mobile Banking";
                                    MobileMember.Insert();
                                end;
                            end;
                        until MobileBuff.Next = 0;
                    end;
                end;

            }
            action("Ledger Entries")
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Mobile Banking Ledger Entries";
                //RunPageLink = "Member No."=FIELD(Member n);MobileBanking
            }
        }
    }
}

