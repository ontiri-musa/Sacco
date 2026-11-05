report 50567 MyReportTest
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\TestReport.rdl';

    dataset
    {

        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", Description;
            DataItemTableView = sorting("No.");
            column(No_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Qty__on_Sales_Return; "Qty. on Sales Return")
            {

            }
        }
    }

    requestpage
    {
        /*  layout
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
      */
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

    var
        myInt: Integer;
}