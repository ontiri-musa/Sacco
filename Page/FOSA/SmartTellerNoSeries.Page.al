page 50007 "SmartTeller No Series"
{
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "Smart Teller No Series";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Deposit; Deposit)
                {
                    ApplicationArea = All;
                }
                field(Withdrawal; Withdrawal)
                {
                    ApplicationArea = All;
                }
                field("Cheque Deposit"; "Cheque Deposit")
                {
                    ApplicationArea = All;
                }
                field("Request From Treasury"; "Request From Treasury")
                {
                    ApplicationArea = All;
                }
                field("Return To Treasury"; "Return To Treasury")
                {
                    ApplicationArea = All;
                }
                field("Inter Teller"; "Inter Teller")
                {
                    ApplicationArea = All;
                }
                field(InterAccount; InterAccount)
                {
                    ApplicationArea = All;
                }
                field("Receive From Bank"; "Receive From Bank")
                {
                    ApplicationArea = All;
                }
                field("Return To Bank"; "Return To Bank")
                {
                    ApplicationArea = All;
                }
                field("ATM Request"; "ATM Request")
                {
                    ApplicationArea = All;
                }
                field(Imprest; Imprest)
                {
                    ApplicationArea = All;
                }
                field(MemberApplication; MemberApplication)
                {
                    ApplicationArea = All;
                }
                field("Issue To Teller"; "Issue To Teller")
                {
                    ApplicationArea = All;
                }
                field("Spotcash Request"; "Spotcash Request")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}