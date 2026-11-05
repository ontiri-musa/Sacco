report 50013 "Board Member Payment Report"
{
    ApplicationArea = All;
    Caption = 'Board Member Payment Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report\Finance\Board Member Payment Report.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = where("Sub Category" = filter("Board Member"));
            column(No; "No.")
            {
            }
            column(FullName; "Full Name")
            {
            }
            column(SittingAll; SittingAll)
            { }
            column(TaxSittingAll; TaxSittingAll)
            { }
            column(Hospitality; Hospitality)
            { }
            column(Transport; Transport)
            { }
            column(Gpay; Gpay)
            { }
            column(NetPay; NetPay)
            { }
            column(Picture; CompanyInfo.Picture)
            { }
            column(Name; CompanyInfo.Name)
            { }
            column(FromDate; FromDate)
            { }
            column(ToDate; ToDate)
            { }
            trigger OnAfterGetRecord()
            begin
                BoardAccN := '';
                GetMemberBoardAcc(Member, BoardAccN);
                SittingAll := 0;
                TaxSittingAll := 0;
                Hospitality := 0;
                Transport := 0;
                Gpay := 0;
                NetPay := 0;

                BoardPH.Reset();
                BoardPH.SetRange(Posted, true);
                BoardPH.SetRange("Posting Date", FromDate, ToDate);
                If BoardPH.FindSet() then begin
                    repeat
                        BoardPVLines.Reset();
                        BoardPVLines.SetRange("Document No.", BoardPH."No.");
                        BoardPVLines.SetRange("Account Type", BoardPVLines."Account Type"::Vendor);
                        BoardPVLines.SetRange("Account No.", BoardAccN);
                        if BoardPVLines.FindFirst() then begin
                            SittingAll += BoardPVLines."Sitting Allowance";
                            TaxSittingAll += BoardPVLines."Sitting Allowance Tax";
                            Hospitality += BoardPVLines.Hospitality;
                            Transport += BoardPVLines."Transport Allowance";
                            Gpay += BoardPVLines."Gross Pay";
                            NetPay += BoardPVLines."Net Pay";
                        end;
                    until BoardPH.Next = 0;
                end;
                if Gpay = 0 then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if FromDate = 0D then
                    Error('Kindly Indicate Start Date');
                if ToDate = 0D then
                    Error('Kindly Indicate End Date');
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(FromDate; FromDate)
                {
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field(ToDate; ToDate)
                {
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

    }
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    procedure GetMemberBoardAcc(Memb: Record Member; Var AccNo: Code[20])
    var
        AccType: Record "Account Type";
        Vend: Record Vendor;
        Fosa: Codeunit "FOSA Management";
    begin
        AccType.Reset();
        AccType.SetRange(Type, AccType.Type::Board);
        If AccType.FindFirst() then begin
            Vend.Reset();
            Vend.SetRange("Member No.", Memb."No.");
            Vend.SetRange("Account Type", AccType.Code);
            if Vend.FindFirst() then begin
                AccNo := Vend."No.";
            end;
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        SittingAll: Decimal;
        TaxSittingAll: Decimal;
        Transport: Decimal;
        Hospitality: Decimal;
        Gpay: Decimal;
        NetPay: Decimal;
        BoardAccN: Code[50];
        BoardPH: Record "Board Payment Header";
        BoardPVLines: Record "Board Members Payment Line";
        FromDate: Date;
        ToDate: Date;

}
