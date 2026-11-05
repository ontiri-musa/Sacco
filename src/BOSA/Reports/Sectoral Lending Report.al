report 51116 "Sectoral Lending Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\BOSA\Sectoral Lending Report.rdl';
    Caption = 'Sectoral Lending Loan Return';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Economic Sector SubCategory"; "Economic Sector Sub-Category")
        {

            column(EcomomicSector_EconomicSectorSubCategory; "Economic Sector SubCategory"."Economic Sector")
            {
            }
            column(EconomicSectorCategory_EconomicSectorSubCategory; "Economic Sector SubCategory"."Economic Sector Category")
            {
            }
            column(Code_EconomicSectorSubCategory; "Economic Sector SubCategory".Code)
            {
            }
            column(Description_EconomicSectorSubCategory; "Economic Sector SubCategory".Description)
            {
            }
            column(EconomicSectorTxt; EconomicSectorTxt)
            {
            }
            column(EconomicCategoryTxt; EconomicCategoryTxt)
            {
            }
            column(TitleCaption1; TitleCaption1)
            {
            }
            column(TitleCaption2; TitleCaption2)
            {
            }
            column(TitleCaption3; TitleCaption3)
            {
            }
            column(SaccoNameCaptionLbl; SaccoNameCaptionLbl)
            {
            }
            column(AppendixCaptionLbl; AppendixCaptionLbl)
            {
            }
            column(TotalCaptionLbl; TotalCaptionLbl)
            {
            }
            column(KshCaptionLbl; KshCaptionLbl)
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(Loans_AdvancesTxt; Loans_AdvancesTxt)
            {
            }
            column(TotalLoanAmount; TotalLoanAmount)
            {
            }
            column(FinancialYear; FinancialYear)
            {
            }
            column(StartDate; Dates[1])
            {
            }
            column(EndDate; Dates[2])
            {
            }
            column(FinancialYearCaptionLbl; FinancialYearCaptionLbl)
            {
            }
            column(StartDateCaptionLbl; StartDateCaptionLbl)
            {
            }
            column(EndDateCaptionLbl; EndDateCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if "Economic Sector SubCategory".Code = '' then
                    "Economic Sector SubCategory".Delete();

                EconomicSectorTxt := '';
                EconomicCategoryTxt := '';

                if EconomicSectorCategory.GET("Economic Sector SubCategory"."Economic Sector Category") then begin
                    EconomicCategoryTxt := EconomicSectorCategory.Description;
                end;

                if EconomicSector.GET("Economic Sector SubCategory"."Economic Sector") then begin
                    EconomicSectorTxt := EconomicSector.Description;
                end;

                TotalLoanAmount := 0;

                LoanApplications.RESET;
                LoanApplications.SETRANGE("Economic Sector Sub-Category", "Economic Sector SubCategory".Code);
                LoanApplications.SetFilter("Disbursal Date", Dfilter);
                LoanApplications.SETRANGE(Posted, TRUE);
                if LoanApplications.FINDSET then begin
                    repeat
                        LoanApplications.CalcFields("Total Refinanced Amount");
                        if LoanApplications."Top-up" = false then
                            TotalLoanAmount += LoanApplications."Approved Amount"
                        else
                            TotalLoanAmount += (LoanApplications."Approved Amount" - LoanApplications."Total Refinanced Amount");
                    until LoanApplications.NEXT = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if Dates[2] = 0D then
                    Dates[2] := Today;

                Dfilter := Format(Dates[1]) + '..' + Format(Dates[2]);
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
                    field(AsAt; AsAt)
                    {
                        Visible = false;
                        ApplicationArea = All;
                        Caption = 'As At Date';
                    }
                    field(DatesFrom; Dates[1])
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(DatesTo; Dates[2])
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
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
    }

    trigger OnInitReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        TitleCaption1: Label 'FORM 9: SECTORAL CLASSIFICATION OF CREDIT FINANCING BY DT-SACCOS';
        TitleCaption2: Label 'Code';
        TitleCaption3: Label 'ECONOMIC SECTORS';
        SaccoNameCaptionLbl: Label 'Name of the Sacco Society:';
        AppendixCaptionLbl: Label 'APPENDIX III';
        TotalCaptionLbl: Label 'Total';
        KshCaptionLbl: Label '(Ksh''000)';
        EconomicSectorTxt: Text;
        EconomicCategoryTxt: Text;
        EconomicSector: Record "Economic Sector";
        EconomicSectorCategory: Record "Economic Sector Category";
        EconomicSectorSubCategory: Record "Economic Sector Sub-Category";
        Loans_AdvancesTxt: Label 'AMOUNT OF LOANS & ADVANCES';
        TotalLoanAmount: Decimal;
        LoanApplications: Record "Loan Application";
        FinancialYearCaptionLbl: Label 'Financial Year';
        StartDateCaptionLbl: Label 'Start Date';
        EndDateCaptionLbl: Label 'End Date';
        AccountingPeriod: Record "Accounting Period";
        FinancialYear: Text;
        AsAt: Date;
        Dfilter: text;
        Dates: array[5] of Date;
}

