page 55011 "Recovery Officer Setup"
{
    // version MC2.0

    PageType = List;
    SourceTable = "Loan  Officer Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Officer; Officer)
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("E-mail"; "E-mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Supervisor; Supervisor)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Role; Role)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

