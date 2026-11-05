report 56800 "Payroll Summary Report"
{
    Caption = 'Payroll Summary Report';
    RDLCLayout = 'Report\Finance\Payroll Summary.rdl';
    dataset
    {
        dataitem(Emp; Employee)
        {
            column(No_; "No.")
            { }
            column(First_Name; "First Name")
            { }
            column(Middle_Name; "Middle Name")
            { }
            column(Last_Name; "Last Name")
            { }
            column(Basic_Pay; "Basic Pay")
            { }
            column(TotalBasicPay; TotalBasicPay)
            { }
            column(NetPay; NetPay)
            { }
            column(TotalNet; TotalNet)
            { }
            column(GrossPay; GrossPay)
            { }
            column(TGrossPay; TGrossPay)
            { }
            column(PayPeriod; TitleReport + '' + UPPERCASE(FORMAT(PayPeriod, 0, '<month text> <year4>')))
            { }
            column(Name; CompInfo.Name)
            {
            }
            column(Address; CompInfo.Address)
            {
            }
            column(Address_2; CompInfo."Address 2")
            {
            }
            column(Picture; CompInfo.Picture)
            {
            }
            dataitem("Payroll Entries"; "Payroll Entries")
            {
                DataItemLink = "Employee No" = field("No.");
                DataItemTableView = where("Tax Relief" = filter(false));
                column(Description; Description)
                { }
                column(Amount; Amount)
                { }
                column(Earning_Deduction_Type; "Earning/Deduction Type")
                { }
                trigger OnAfterGetRecord()
                begin
                    if "Payroll Period" <> PayPeriod then CurrReport.Skip();
                end;
            }
            trigger OnPreDataItem()
            begin
                TotalBasicPay := 0;
                TotalNet := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                if "Employee Status" <> "Employee Status"::Active then CurrReport.Skip();
                NetPay := 0;

                TotalEarning := PayrollManagement.GetGrossPay(Emp, PayPeriod);
                TotalDeductions := PayrollManagement.GetTotalDeductions(Emp, PayPeriod);
                NetPay := TotalEarning - TotalDeductions;
                GrossPay := TotalEarning;
                TGrossPay += GrossPay;
                TotalBasicPay += "Basic Pay";
                TotalNet += NetPay;
            end;

        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("Pay Period"; PayPeriod)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Period";
                }
            }
        }

        actions
        {
        }
    }
    trigger OnPreReport();
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then begin
                Error('You do not have permission to view this page');
            end;
        end;
        IF PayPeriod = 0D THEN BEGIN
            ERROR('Please Provide Payroll Month!');
        END;
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        PayPeriod: Date;
        PayrollManagement: Codeunit "Payroll Processing";
        TotalEarning: Decimal;
        TotalDeductions: Decimal;
        TotalNet: Decimal;
        TLPayrollEntries: Record "Payroll Entries";
        EmployeeName: Text;
        CompInfo: Record "Company Information";
        TitleReport: Label '"PAYROLL SUMMARY REPORT FOR PAY PERIOD: "';
        GrossPay: Decimal;
        TGrossPay: Decimal;
        i: Integer;
        NetPay: Decimal;
        TotalBasicPay: Decimal;

}
