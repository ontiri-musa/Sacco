pageextension 50503 "Accountant Role Center Ext" extends "Accountant Role Center"
{
    layout
    {

    }
    actions
    {
        addafter("Cost Accounting")
        {
            group(CashSetup)
            {
                Caption = 'Cash Management Setup';
                action(Cashmngetsetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Management Setup';
                    Image = CashFlowSetup;
                    RunObject = Page "Cash Management Setup";
                    ToolTip = 'Set up All Parameters for Cash Management Module';
                }


            }


        }

    }

}