report 50015 "Fixed/Call Deposit Schedule"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/FixedCallDepositSchedule.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";

            dataitem("Fixed/Call Deposit Schedule"; "Fixed/Call Deposit Schedule")
            {
                DataItemLink = "FD Account No." = field("No.");
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
                column(Interest_To_Earn; "Interest To Earn")
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