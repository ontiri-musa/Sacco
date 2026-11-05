report 50012 "Loan Voucher"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/LoanVoucher.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            //  DataItemTableView = where(Posted = filter(true));

            column(CompPicture; CompInfo.Picture)
            {

            }
            column(CompName; CompInfo.Name)
            {

            }
            column(No_; "No.")
            {

            }
            column(Member_No_; "Member No.")
            {

            }
            column(Member_Name; "Member Name")
            {

            }
            column(Loan_Product_Type; "Loan Product Type")
            {

            }
            column(Description; Description)
            {

            }
            column(Approved_Amount; "Approved Amount")
            {

            }
            column(Created_By; "Created By")
            {

            }
            column(Created_Date; "Created Date")
            {

            }
            column(Appraised_By; "Appraised By")
            {

            }
            column(Appraisal_Date; "Appraisal Date")
            {

            }
            column(Approved_By; "Approved By")
            {

            }
            column(Approved_Date; "Approved Date")
            {

            }
            column(Disbursed_By; "Disbursed By")
            {

            }
            column(Disbursal_Date; "Disbursal Date")
            {

            }
            column(AmountInWords; AmountInWords)
            {

            }
            trigger OnAfterGetRecord()
            var

            begin
                AmountInWords := GlobalManagement.GetAmountInWords("Approved Amount")
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /*  field(NO)
                     {
                         ApplicationArea = All;

                     } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    var

    begin
        CompInfo.get();
        CompInfo.CalcFields(Picture);
    end;

    var
        LoanProductTpe: Record "Loan Product Type";
        CompInfo: Record "Company Information";
        GlobalManagement: Codeunit "Global Management";
        AmountInWords: Text[250];
}