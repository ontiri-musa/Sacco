report 50059 "Calculate Dividends"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)

        {
            RequestFilterFields = Status;
            //   DataItemTableView = SORTING("No.") WHERE(Status = FILTER(Active|Dormant|Reinstated| Withdrawn));

            trigger OnAfterGetRecord()
            var
                Lclass: Record "Loan Classification Entry";
                Defaulter: Boolean;
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    Defaulter := false;
                    FosaM.CreateDefaultAccount(Member);
                    /*Lclass.Reset();
                    Lclass.SetRange(Lclass."Member No.", Member."No.");
                    if Lclass.FindSet() then begin
                        repeat
                            if (Lclass."Classification Code" = 'DOUBTFUL') or (Lclass."Classification Code" = 'LOSS') then
                                Defaulter := true;
                        until Lclass.Next = 0;
                    end;*/
                    If Defaulter = false then begin
                        ProgressWindow.UPDATE(1, "No.");
                        ProgressWindow.UPDATE(2, "Full Name");
                        BOSAManagement.CalculateDividends(Member, DividendType, DocumentNo, CalcEndDate);
                        ProgressWindow.UPDATE(5, (i / TotalMember * 10000) DIV 1);
                    end;
                END;
                SLEEP(50);
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                DividendLine.RESET;
                DividendLine.SETRANGE("Document No.", DocumentNo);
                DividendLine.DELETEALL;

                i := 0;
                TotalMember := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003);
            end;
        }
    }

    requestpage
    {

        layout
        {

            area(content)
            {

                field(DividendType; DividendType)
                {
                    Caption = 'Dividend Type';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        i: Integer;
        TotalMember: Integer;
        Text000: Label 'Dividend Processing\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ArrearsAmount: array[4] of Decimal;
        DocumentNo: Code[20];
        CalcEndDate: Date;
        DividendLine: Record "Dividend Line";
        DividendType: Option Both,Dividend,Interest;
        FosaM: Codeunit "FOSA Management";


    procedure SetDocumentNo(var DocNo: Code[20]; CalcDate: Date)
    begin
        DocumentNo := DocNo;
        CalcEndDate := CalcDate;
    end;
}

