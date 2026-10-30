report 50091 "Yield Analysis"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Yield Analysis1.rdl';

    dataset
    {
        /* dataitem(DataItem1; "Dimension Value")
         {
             DataItemTableView = SORTING("Dimension Code", Code)
                                  WHERE("Global Dimension No." = FILTER(1));
             RequestFilterFields = Code;
             column(Code_DimensionValue; Code)
             {
             }
             column(Name_DimensionValue; UPPERCASE(Name))
             {
             }
             column(Picture; CompanyInfo.Picture)
             {

             }
             column(Name; CompanyInfo.Name)
             {
             }
             dataitem(DataItem15; "Loan Product Type")
             {
                 column(Code_LoanProductType; Code)
                 {
                 }
                 column(Description_LoanProductType; Description)
                 {
                 }
                 column(RSum_1; RSum[1])
                 {
                 }
                 column(RSum_2; RSum[2])
                 {
                 }

                 trigger OnAfterGetRecord()
                 begin
                     RSum[1] := 0;
                     RSum[2] := 0;
                     RSum[3] := 0;

                     LoanApplication.RESET;
                     LoanApplication.SETRANGE("Loan Product Type", Code);
                     IF LoanApplication.FINDSET THEN BEGIN
                         REPEAT
                             GetSummary(LoanApplication."No.");
                         UNTIL LoanApplication.NEXT = 0;
                     END;
                 end;
             }
         }*/
        dataitem("Loan Product Type"; "Loan Product Type")
        {
            RequestFilterFields = Code;
            column(Product_Type; Code)
            {

            }
            column(expectedInt; expectedInt)
            {

            }
            column(actualInt; actualInt)
            {

            }
            column(expectedPen; expectedPen)
            {

            }
            column(actualPen; actualPen)
            {

            }
            column(Picture; CompanyInfo.Picture)
            {

            }
            column(Name; CompanyInfo.Name)
            {
            }
            trigger OnAfterGetRecord()
            begin
                expectedInt := 0;
                actualInt := 0;
                expectedPen := 0;
                actualPen := 0;


                LoanApplication.Reset();
                LoanApplication.SetFilter("Outstanding Balance", '>%1', 0);
                LoanApplication.SetRange("Loan Product Type", Code);
                if LoanApplication.FindSet() then begin
                    repeat
                        LoanApplication.CalcFields("Expected Int", "Actual Int", "Expected Pen", "Actual Pen");
                        expectedInt += LoanApplication."Expected Int";
                        actualInt += LoanApplication."Actual Int" * -1;
                        expectedPen += LoanApplication."Expected Pen";
                        actualPen += LoanApplication."Actual Pen" * -1;
                    until LoanApplication.Next() = 0;
                end;

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
        ReportTitle = 'Yield Analysis';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        SourceCodeSetup.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        RCount: array[4] of Integer;
        RSum: array[10] of Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        expectedInt: Decimal;
        actualInt: Decimal;
        expectedPen: Decimal;
        actualPen: Decimal;

    /* local procedure GetSummary(LoanNo: Code[20])
     begin
         CustLedgerEntry.RESET;
         CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
         CustLedgerEntry.SETRANGE("Global Dimension 1 Code", DataItem1.Code);
         IF CustLedgerEntry.FINDSET THEN BEGIN
             REPEAT
                 CustLedgerEntry.CALCFIELDS(Amount);
                 IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                     RSum[1] += ABS(CustLedgerEntry.Amount);
                 IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                     RSum[2] += ABS(CustLedgerEntry.Amount);
             UNTIL CustLedgerEntry.NEXT = 0;
         END;
     end;*/
}

