page 50387 "Default Notification List"
{
    CardPageID = "Default Notification";
    PageType = List;
    SourceTable = "Default Notification Header";
    //  SourceTableView = WHERE("SMS Sent" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; No)
                {
                }
                field("SMS Date"; "SMS Date")
                {
                }
                field(SMSText; SMSText)
                {
                    Caption = 'SMS Text';
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin

        SMSText := GetSMSTemplate();
    end;

    var
        SMSText: Text;
}

