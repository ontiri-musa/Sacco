report 50021 "Run Prepayment Recovery"
{
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Run Prepayment Recovery';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = Const(1));
            trigger OnPreDataItem()
            begin
                ProcessPrepayment.ProcessPrepayments(startDate, endDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Start Date"; startDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                }
                field(endDate; endDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
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
    var
        startDate: Date;
        endDate: date;
        ProcessPrepayment: Codeunit "Recover Loans From Prepayments";
}
