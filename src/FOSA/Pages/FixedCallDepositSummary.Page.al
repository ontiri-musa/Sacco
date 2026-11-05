page 50392 "Fixed/Call Deposit Summary"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Fixed/Call Deposit Summary";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD Account No."; "FD Account No.")
                {
                    ApplicationArea = All;

                }
                field("Account Opening No."; "Account Opening No.")
                {
                    ApplicationArea = All;

                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
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


                field("Fixed Deposit Amount"; "Fixed Deposit Amount")
                {
                    ApplicationArea = All;

                }

                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;

                }

                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;

                }

                field("Fixed Period"; "Fixed Period")
                {
                    ApplicationArea = All;

                }

                field("Maturity Date"; "Maturity Date")
                {
                    ApplicationArea = All;

                }

                field("Capitalization Frequency"; "Capitalization Frequency")
                {
                    ApplicationArea = All;

                }

                field("Source FOSA Account"; "Source FOSA Account")
                {
                    ApplicationArea = All;

                }

                field("Maturity FOSA Account"; "Maturity FOSA Account")
                {
                    ApplicationArea = All;

                }

                field("Total Interest To Earn"; "Total Interest To Earn")
                {
                    ApplicationArea = All;

                }

                field("Total Amount To Earn"; "Total Amount To Earn")
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;

                }


                field(Posted; Posted)
                {
                    ApplicationArea = All;

                }

                field("Posted Date"; "Posted Date")
                {
                    ApplicationArea = All;

                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = All;

                }

            }

        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Navigation)
        {
            action("Fixed Deposit Schedule")
            {
                ApplicationArea = All;
                Image = Relationship;
                RunObject = page "Fixed/Call Deposit Schedule";
                RunPageLink = "FD Account No." = field("FD Account No.");
            }
        }
        area(Processing)
        {
            action("Mature Fixed/Call Deposit")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ContactPerson;
                trigger OnAction()
                begin
                    if Confirm(MatureFDCallDepositConfirmMsg, true, "FD Account No.") then
                        FOSAManagement.MatureFixedCallDeposit(Rec);
                end;
            }
            action("Revoke Fixed/Call Deposit")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ContactPerson;
                trigger OnAction()
                begin
                    if Confirm(RevokeFDCallDepositConfirmMsg, true, "FD Account No.") then
                        FOSAManagement.RevokeFixedCallDeposit(Rec);
                end;
            }
        }
        area(Reporting)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Relationship;
                RunObject = report "Fixed/Call Deposit Summary";
            }

        }



    }

    local procedure CalculateTotalAmountToEarn()
    var

    begin
        CalcFields("Total Interest To Earn");
        "Total Amount To Earn" := "Fixed Deposit Amount" + "Total Interest To Earn";
    end;

    trigger OnAfterGetRecord()
    var

    begin
        CalculateTotalAmountToEarn();
    end;

    var
        Vendor: Record Vendor;
        MatureFDCallDepositConfirmMsg: Label 'Do you want to Mature Fixed/Call Deposit %1?';
        RevokeFDCallDepositConfirmMsg: Label 'Do you want to Revoke Fixed/Call Deposit %1?';
        FOSAManagement: Codeunit "FOSA Management";
}