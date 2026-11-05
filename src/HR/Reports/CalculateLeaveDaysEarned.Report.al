report 50253 "Calculate Leave Days Earned"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; "Leave Type")
        {
            DataItemTableView = where(Code = filter('ANNUAL'));
            RequestFilterFields = Code;

            trigger OnAfterGetRecord()
            begin

                Employee.Reset();
                Employee.SetFilter("Employee Status", '%1|%2', Employee."Employee Status"::Confirmed, Employee."Employee Status"::Probation);
                if Employee.FindSet() then begin
                    repeat
                        LedgerEntry.Init();
                        LedgerEntry."Document No" := 'Leave-' + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 3));
                        LedgerEntry."Leave Period" := Format(Date2DMY(Today, 3));
                        LedgerEntry."Leave Code" := Code;
                        LedgerEntry.Description := 'Earned Days ' + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 3));
                        LedgerEntry."Employee No." := Employee."No.";
                        LedgerEntry."Employee Name" := Employee.FullName();
                        LedgerEntry.Days := "Days Earned Per Month";
                        LedgerEntry."Entry Type" := LedgerEntry."Entry Type"::Positive;
                        LedgerEntry."Earned Leave Days" := true;
                        LedgerEntry."Posting Date" := Today;
                        LedgerEntry.Insert(true);
                    until Employee.Next() = 0;
                end;
            end;
        }

    }
    var
        LedgerEntry: Record "Leave Ledger Entry";
        Employee: Record Employee;

}