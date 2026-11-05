page 51207 "Key Perfomance Indicator-BR"
{
    PageType = List;
    SourceTable = "Key Perfomance Indicator Setup";
    SourceTableView = where(Category = filter('Business Representative'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field(Type; Type)
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account Name"; "Account Name")
                {
                }
                field("No. of Accounts"; "No. of Accounts")
                {
                }
                field("Minimum Amount"; "Minimum Amount")
                {
                }
                field("Monthly Target"; "Monthly Target")
                {
                }
                field("Minimum Duration"; "Minimum Duration")
                {
                }
                field(Frequency; Frequency)
                {
                }
                field("Entrance Fee"; "Entrance Fee")
                {
                }
                field("Member Category"; "Member Category")
                {
                }
                field("Weighted Average"; "Weighted Average")
                {
                }
                field("Calculation Mode"; "Calculation Mode")
                {
                }
                field("Commission Value"; "Commission Value")
                {
                }
                field(Category; Category)
                {

                }
            }
        }
    }

    actions
    {
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Category := Category::"Business Representative";
    end;
}

