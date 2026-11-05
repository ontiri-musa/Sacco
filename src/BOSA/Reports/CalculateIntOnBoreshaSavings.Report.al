report 59059 "Calculate Boresha Int"
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
            trigger OnAfterGetRecord()
            var
                Lclass: Record "Loan Classification Entry";
                Defaulter: Boolean;
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "No.");
                    ProgressWindow.UPDATE(2, "Full Name");
                    BOSAManagement.CalculateDividends(Member, DividendType, DocumentNo, CalcEndDate);
                    ProgressWindow.UPDATE(5, (i / TotalMember * 10000) DIV 1);
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
                DividendType := DividendType::Boresha;
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

                /*field(DividendType; DividendType)
                {
                    Caption = 'Dividend Type';
                    ApplicationArea = All;
                }*/
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
        Text000: Label 'Int On Boresha Savings Processing\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ArrearsAmount: array[4] of Decimal;
        DocumentNo: Code[20];
        CalcEndDate: Date;
        DividendLine: Record "Dividend Line";
        DividendType: Option Both,Dividend,Interest,Boresha;
        FosaM: Codeunit "FOSA Management";
        Vendor: record Vendor;
        AccountType: Record "Account Type";
        GlobalManagement: Codeunit "Global Management";

        AccountTypeEnum: Enum "Gen. Journal Account Type";

    procedure SetDocumentNo(var DocNo: Code[20]; CalcDate: Date)
    begin
        DocumentNo := DocNo;
        CalcEndDate := CalcDate;
    end;
}

