page 59300 "Loan Notification Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "Loan Notification Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field(PhoneNo; PhoneNo)
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Notification Sent"; SMSTemplate)
                {
                    ApplicationArea = All;
                }
                field("Notification Date"; "Notification Date")
                {
                    ApplicationArea = All;
                }
                field("Notification Time"; "Notification Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(Print)
            {
                Image = BankAccountStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //REPORT.RUN(REPORT::"Loan Classification Report",TRUE,FALSE);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        PhoneNo := '';
        SMSTemplate := GetSMSTemplate;
        Member.Get("Member No.");
        PhoneNo := Member."Phone No.";
    end;

    var
        SMSTemplate: Text;
        PhoneNo: Code[20];
        Member: Record Member;
}

