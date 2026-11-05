report 50018 "Fixed/Call Deposit Summary"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/FixedCallDepositSummary.rdl';

    dataset
    {
        dataitem("Fixed/Call Deposit Summary"; "Fixed/Call Deposit Summary")
        {
            RequestFilterFields = "FD Account No.";
            column(Member_Name; "Member Name")
            {

            }
            column(Description; Description)
            {

            }
            column(Account_Type; "Account Type")
            {

            }

            column(FD_Account_No_; "FD Account No.")
            {

            }
            column(Account_Opening_No_; "Account Opening No.")
            {

            }

            column(Start_Date; "Start Date")
            {

            }
            column(Fixed_Period; "Fixed Period")
            {

            }
            column(Fixed_Deposit_Amount; "Fixed Deposit Amount")
            {

            }
            column(Maturity_Date; "Maturity Date")
            {

            }
            column(Source_FOSA_Account; "Source FOSA Account")
            {

            }
            column(Maturity_FOSA_Account; "Maturity FOSA Account")
            {

            }
            column(Interest_Rate; "Interest Rate")
            {

            }
            column(Total_Interest_To_Earn; "Total Interest To Earn")
            {

            }
            column(Total_Amount_To_Earn; "Total Amount To Earn")
            {

            }
            column(Capitalization_Frequency; "Capitalization Frequency")
            {

            }
            column(Member_No_; "Member No.")
            {

            }
            column(Status; Status)
            {

            }


        }
    }

    /*  requestpage
     {
         layout
         {
             area(Content)
             {
                 group(Schedule)
                 {
                     field(Member_No_; "Fixed Deposit Schedule"."Member No.")
                     {
                         ApplicationArea = All;

                     }
                 }
             }
         }

         actions
         {
             area(processing)
             {
                 action(Process)
                 {
                     ApplicationArea = All;

                 }
             }
         }
     }
  */
    var
        myInt: Integer;
}