report 50073 "Classification Summary"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Classification Summary.rdl';

    dataset
    {
        dataitem(DataItem1; "Loan Classification Setup")
        {
            RequestFilterFields = Code;
            column(Code_DimensionValue; Code)
            {
            }
            column(Name_DimensionValue; Description)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(RCount_1; RCount[1])
            {
            }
            column(RSum_1; RSum[1])
            {
            }
            trigger OnPreDataItem()
            begin
                // if EndDate = 0D then
                // Error('As At Date cannot be blank');
                //UpdateClassification();
            end;

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RCount[2] := 0;
                RSum[1] := 0;
                LoanClassificationEntry.RESET;
                LoanClassificationEntry.SETRANGE("Classification Code", Code);
                LoanClassificationEntry.SetFilter("Outstanding Balance", '>%1', 0);
                IF LoanClassificationEntry.FINDSET THEN BEGIN
                    LoanClassificationEntry.CALCSUMS("Outstanding Balance");
                    RCount[1] := LoanClassificationEntry.COUNT;
                    RSum[1] := LoanClassificationEntry."Outstanding Balance";
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(EndDate; EndDate)
                    {
                        Visible = false;
                        ApplicationArea = All;
                        Caption = 'As At Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'Classification Summary';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    local procedure UpdateClassification()
    var
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        Text000: Label 'Generating Loan Classification\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name      #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        LoanApp: Record "Loan Application";
    begin
        LoanClassificationEntry.Reset();
        if LoanClassificationEntry.FindSet() then
            LoanClassificationEntry.DELETEALL;

        LoanApp.Reset();
        LoanApp.SetRange(Posted, true);
        LoanApp.SetFilter("Date Filter", '<=%1', EndDate);
        if LoanApp.FindSet() then begin
            TotalLoan := LoanApp.COUNT;
            IF GUIALLOWED THEN
                ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
            repeat
                IF GUIALLOWED THEN BEGIN
                    i += 1;
                    ProgressWindow.UPDATE(1, LoanApp."Member No.");
                    ProgressWindow.UPDATE(2, LoanApp."Member Name");
                    ProgressWindow.UPDATE(3, LoanApp."No.");
                    ProgressWindow.UPDATE(4, LoanApp.Description);
                    LoanApp.CalcFields("Outstanding Balance");
                    if LoanApp."Outstanding Balance" > 0 then begin
                        BOSAManagement.GenerateLoanClassification(LoanApp, EndDate);
                    end;
                    ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
                END;
                SLEEP(50);
            until LoanApp.Next = 0;
            ProgressWindow.CLOSE;
        end;

    end;

    var
        EndDate: Date;
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RCount: array[4] of Integer;
        RSum: array[10] of Decimal;
        LoanClassificationEntry: Record "Loan Classification Entry";
}

