report 50010 "SMS Processing"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("SMS Entry"; "SMS Entry")
        {
            DataItemTableView = where(sent = filter(false));
            column(Created_Date; "Created Date")
            {

            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                SMSManagement.SendGETSMSRequest("SMS Entry");
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    Message('Completed');
            end;
        }
    }




    requestpage
    {
        layout
        {
            area(Content)
            {
                group(SMS)
                {

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


    var
        SMSManagement: Codeunit "Mobile Banking";
}