page 50533 "Appraiser's Review List"
{
    // version TL2.0

    CardPageID = "Performance Review Card";
    PageType = List;
    SourceTable = 50286;
    SourceTableView = WHERE("Released to Appraiser" = FILTER('Yes'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Period; Period)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                
                field("Full Name";"Full Name")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        UserSetup.GET(USERID);
        //  SETRANGE("Appraiser Employee No.", UserSetup."Employee No.");
        FILTERGROUP(0);
    end;

    var
        UserSetup: Record 91;
}

