report 50004 "Teller Transaction Receipt"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/TellerTransactionReceipt.rdl';

    dataset
    {
        dataitem("Teller Transaction Header"; "Teller Transaction Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = order(ascending);
            column(No_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Transaction_Date; "Transaction Date")
            {

            }
            column(Transaction_Time; "Transaction Time")
            {

            }
            column(Teller_User_ID; "Teller User ID")
            {

            }
            column(Total_Amount; "Total Line Amount")
            {

            }
            column(Picture; CompInfo.Picture)
            {

            }
            column(CompName; CompInfo.Name)
            {

            }
            column(AmountInWords; AmountInWords)
            {

            }

            dataitem("Teller Transaction Line"; "Teller Transaction Line")
            {
                DataItemLink = "Transaction No." = field("No.");
                DataItemTableView = order(ascending);

                column(Account_Type; "Account Type")
                {

                }
                column(Account_No_; "Account No.")
                {

                }
                column(Account_Name; "Account Name")
                {

                }
                column(Member_No_; "Member No.")
                {

                }
                column(Member_Name; "Member Name")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                CalcFields("Total Line Amount");
                AmountInWords := GlobalManagement.GetAmountInWords("Total Line Amount")
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
                    /*  field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    }  */
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
        myInt: Integer;
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture)
    end;

    var
        CompInfo: Record "Company Information";
        GlobalManagement: Codeunit "Global Management";
        AmountInWords: Text[300];
}