report 50440 "Receipt Voucher"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report\Finance\ReceiptVoucher.rdl';
    dataset
    {
        dataitem("Receipt Header"; "Receipt Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Bank_Account_No_; "Bank Account No.")
            {

            }
            column(Payee_Name; "Payee Name")
            {

            }
            column(Payment_Mode; "Payment Method")
            {

            }
            column(Bank_Account_Name; "Bank Account Name")
            {

            }
            column(Total_Line_Amount; "Total Line Amount")
            {

            }
            column(Created_Date; "Created Date")
            {

            }
            column(Created_By; "Created By")
            {

            }
            column(AmountInWords; AmountInWords)
            {

            }
            column(Picture; CompanyInfo.Picture)
            {

            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {

            }
            dataitem("Receipt Line"; "Receipt Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {

                }
                column(Account_Type; "Account Type")
                {

                }
                column(Account_No_; "Account No.")
                {

                }
                column(Account_Name; "Account Name")
                {

                }
                column(Description2; Description)
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }

            }


            trigger OnAfterGetRecord()
            var

            begin
                CalcFields("Total Line Amount");
                AmountInWords := GlobalManagement.GetAmountInWords("Total Line Amount");
            end;
        }
    }

    requestpage
    {
        layout
        {
            /*             area(Content)
                        {
                            group(GroupName)
                            {
                                field(Name; SourceExpression)
                                {
                                    ApplicationArea = All;

                                }
                            }
                        } */
        }

        actions
        {
            area(processing)
            {
                /*    action(ActionName)
                   {
                       ApplicationArea = All;

                   } */
            }
        }
    }
    trigger OnPreReport()
    var

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        GlobalManagement: Codeunit "Global Management";
        AmountInWords: Text;
}