page 50389 "Fixed/Call Deposit Schedule"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Fixed/Call Deposit Schedule";
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
                field("Member No."; "Member No.")
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

                field("Next Due Date"; "Next Due Date")
                {
                    ApplicationArea = All;

                }

                field("Interest To Earn"; "Interest To Earn")
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
        area(Reporting)
        {
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }

    }




    var
        myInt: Integer;
}