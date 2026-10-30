pageextension 50011 ChartOfAccountExtension extends "Chart of Accounts"
{
    layout
    {

    }
    actions
    {
        addafter("Trial Balance")
        {
            action("Trial Balance Custom")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance Custom';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Trial Balance Custom";
                ToolTip = 'View the chart of accounts that have balances without net changes.';
            }
        }
    }
}
