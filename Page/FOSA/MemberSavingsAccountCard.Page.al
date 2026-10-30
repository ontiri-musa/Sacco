page 50032 "Member S/Dep. Account Card"
{
    // version TL2.0

    Caption = 'Member Saving/Deposit Card';
    PageType = Card;
    SourceTable = Vendor;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Vendor Type"; "Vendor Type")
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
        area(Processing)
        {
            action("Account Signatories")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ContactPerson;
                RunObject = page "Account Signatory";
                RunPageLink = "Account No." = field("No."), "Member No." = field("Member No.");
            }

            action("Close Account")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = CloseDocument;
                trigger OnAction()
                begin
                    if Confirm(CloseAccountConfirmMsg, true, "No.", Name) then
                        FosaManagement.CloseAccount(Rec);
                end;
            }
        }
        area(Reporting)
        {
            group(Reports)
            {

                action(Statement)
                {
                    Image = SocialListening;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Vendor.FILTERGROUP(10);
                        Vendor.SETRANGE("Member No.", Rec."Member No.");
                        Vendor.SetRange("No.", Rec."No.");
                        Vendor.FILTERGROUP(0);
                        Report.RUN(50082, true, false, Vendor);
                    end;
                }
                action(FixedDepositSchedule)
                {
                    Caption = 'Fixed Deposit Schedule';
                    Image = SocialListening;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Vendor.FILTERGROUP(10);
                        Vendor.SETRANGE("Member No.", Rec."Member No.");
                        Vendor.SetRange("No.", Rec."No.");
                        Vendor.FILTERGROUP(0);
                        Report.RUN(50015, true, false, Vendor);
                    end;
                }


            }

        }
    }

    trigger OnOpenPage()
    begin

    end;

    var
        AvailableBalance: Decimal;
        Vendor: Record "Vendor";
        FosaManagement: Codeunit "FOSA Management";
        CloseAccountConfirmMsg: Label 'Do you want to close account %1 %2?';
}

