report 50402 "Processing Payroll"
{

    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ApplicationArea = All;
    dataset
    {
        dataitem(Employee; Employee)
        {

            RequestFilterFields = "No.", "Employee Status";
            trigger OnAfterGetRecord();
            begin
                // Employee.TestField("Member No.");
                // Employee.TestField("FOSA Account");
                if ("Employee Status" = "Employee Status"::Inactive) or ("Employee Status" = "Employee Status"::Separated) or ("Employee Status" = "Employee Status"::Suspended) or
                ("Employee Status" = "Employee Status"::Terminated) then
                    CurrReport.Skip();
                Window.UPDATE(1, Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name");
                CurrentRec += 1;
                Window.UPDATE(2, ((CurrentRec / Records) * 10000) DIV 1);
                PayrollProcessing.ProcessingPayroll(Employee);
            end;

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
                MESSAGE('Payroll Processing Successfull!');
            end;

            trigger OnPreDataItem();
            begin
                Window.OPEN('Processing Payroll For: #1### Progress @2@@@@');
                Records := 0;
                CurrentRec := 0;
                Records := Employee.COUNT;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Window: Dialog;
        Records: Integer;
        CurrentRec: Integer;
        PayrollPeriods: Record "Payroll Period";
        DateSpecified: Date;
        LastMonth: Date;
        Month: Date;
        PayrollProcessing: Codeunit "Payroll Processing";
}

