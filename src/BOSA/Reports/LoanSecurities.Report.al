report 50075 "Loan Securities"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Loan Securities.rdl';
    ApplicationArea = All;
    dataset
    {

        dataitem("Loan Collateral"; "Loan Collateral")
        {

            column(LoanNo_LoanCollateral; "Loan No.")
            {
            }
            column(LineNo_LoanCollateral; "Line No.")
            {
            }
            column(Security_Type_Code; "Security Type Code")
            {
            }
            column(Description_LoanCollateral; Description)
            {
            }
            column(SecurityValue_LoanCollateral; "Security Value")
            {
            }
            column(GuaranteedAmount_LoanCollateral; "Guaranteed Amount")
            {
            }
            column(SecurityFactor_LoanCollateral; "Security Factor")
            {
            }
            column(DataText_1; DataText[1])
            {
            }
            column(DataText_2; DataText[2])
            {
            }
            column(DataText_3; DataText[3])
            {
            }
            column(DataText_4; DataText[4])
            {

            }
            Column(DataText_5; DataText[5])
            {

            }
            column(DataText_6; DataText[6])
            {

            }
            Column(DataText_7; DataText[7])
            {

            }
            Column(DataText_8; DataText[8])
            {

            }
            Column(DataText_9; DataText[9])
            {

            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }


            trigger OnAfterGetRecord()
            begin

                IF LoanApplication.GET("Loan No.") THEN BEGIN
                    LoanApplication.CalcFields("Outstanding Balance");
                    Member.Get(LoanApplication."Member No.");
                    DataText[1] := LoanApplication.Description;
                    DataText[2] := LoanApplication."Member No.";
                    DataText[3] := LoanApplication."Member Name";
                    DataText[4] := Format(LoanApplication."Approved Amount");
                    DataText[5] := Format(LoanApplication."Disbursal Date");
                    DataText[6] := Format(LoanApplication."Outstanding Balance");
                    DataText[8] := Format(LoanApplication."Date of Completion");
                    DataText[9] := LoanApplication.Classification;
                    DataText[7] := Member."Phone No.";


                END ELSE
                    CurrReport.SKIP;
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
        ReportTitle = 'Loan Securities';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        DataText: array[10] of Text;
        LoanApplication: Record "Loan Application";
        Member: REcord Member;
}

