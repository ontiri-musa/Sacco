page 50381 "Teller Member Statistics"
{

    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Member Statistic";
    RefreshOnActivate = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(TellerMemberStatistic)
            {

                Caption = '';
                field("Member No."; "Member No.")
                {

                    ApplicationArea = All;

                }

                field(Description; Description)
                {

                    ApplicationArea = All;

                }
                field(Amount; Amount)
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

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin


    end;

    procedure SetLoanData(var LoanName2: Text[50])
    var

    begin
        LoanName[1] := LoanName2;
        Message(LoanName2);
    end;


    var

        LoanNo: array[10] of Code[20];
        LoanName: array[10] of Text[50];
        BalanceLCY: array[10] of Decimal;



}