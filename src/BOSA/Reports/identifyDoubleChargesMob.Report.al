report 51001 identifyOvercharge
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    RDLCLayout = 'Report/BOSA/identifyDouble.rdl';


    dataset
    {

        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where("Loan Product Type" = filter('MB'));
            column(No_; "No.")
            {

            }
            column(Approved_Amount; "Approved Amount")
            {

            }
            column(intCharged; intCharged)
            {

            }
            trigger OnAfterGetRecord()
            begin
                custLdg.Reset();
                custLdg.SetFilter(Reversed, '%1', false);
                custLdg.SetFilter("Transaction Type Code", 'INTDUE');
                custLdg.SetRange("Customer No.", "No.");
                if custLdg.Find('+') then begin

                end;
                if not custLdg.Find('+') then CurrReport.Skip();
                if custLdg."Posting Date" = "Disbursal Date" then CurrReport.Skip();





            end;
        }
    }

    /* requestpage
     {
         AboutTitle = 'Teaching tip title';
         AboutText = 'Teaching tip content';
         layout
         {
             area(Content)
             {
                 group(GroupName)
                 {
                     field(Name; SourceExpression)
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
                 action(LayoutName)
                 {
                     ApplicationArea = All;

                 }
             }
         }
     }*/



    var
        myInt: Integer;
        custLdg: Record "Cust. Ledger Entry";
        intCharged: Decimal;
}