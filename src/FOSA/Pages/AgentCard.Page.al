page 50375 "Agent Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Agent;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Category5,Category6,Category7,Category8';
    Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Agent Type"; "Agent Type")
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
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;

                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                }
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Device Phone No."; "Device Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Device Serial No."; "Device Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Business Name"; "Business Name")
                {
                    ApplicationArea = All;
                }
                field("Allow Withdrawal"; "Allow Withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Allow Desposit"; "Allow Deposit")
                {
                    ApplicationArea = All;
                }
                field("Allow Balance Inquiry"; "Allow Balance Inquiry")
                {
                    ApplicationArea = All;
                }
                field("Allow Ministatement"; "Allow Ministatement")
                {
                    ApplicationArea = All;
                }
                field("Allow Airtime"; "Allow Airtime")
                {
                    ApplicationArea = All;
                }
                field("Allow Utility Services"; "Allow Utility Services")
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
            }
        }

    }



    trigger OnOpenPage()
    begin

    end;

    var





}

