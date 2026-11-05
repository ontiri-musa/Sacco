page 55101 "MC Cue"
{
    PageType = CardPart;
    SourceTable = "MicroCredit Cue";

    layout
    {
        area(content)
        {
            cuegroup(Loans)
            {
                CuegroupLayout = Wide;
                field("Outstanding Loan Balance"; "Outstanding Loan Balance")
                {
                    DrillDownPageId = "Loan Applications List-Posted";
                }
                field("Unallocated Group Collections"; "Unallocated Group Collections")
                {
                    DrillDownPageId = "Group Collection Entries";
                }
                field("Total Deposits"; "Total Deposits")
                {
                    DrillDownPageId = "Member S/Dep. Account List";
                }
                field("Total Share Capital"; "Total Share Capital")
                {
                    DrillDownPageId = "Member S/Dep. Account List";
                }
            }
            cuegroup(Members)
            {
                //  CuegroupLayout = Wide;

                field("New Member Applications"; "New Member Applications")
                {
                    DrillDownPageId = "Member Application List-New";
                    ApplicationArea = All;
                }
                field("Member App. Pending Approval"; "Member App. Pending Approval")
                {
                    Caption = 'Member Application Pending Approval';
                    DrillDownPageId = "Member Appl. List-Pending";
                    ApplicationArea = All;
                }
                field("Approved Member Applications"; "Approved Member Applications")
                {
                    DrillDownPageId = "Member Appl. List-Approved";
                    ApplicationArea = All;
                }
                field("No. of Groups"; "No. of Groups")
                {
                    DrillDownPageId = "Member List";
                    ApplicationArea = All;
                }
            }
            cuegroup("Loan Applications")
            {
                // CuegroupLayout = Wide;
                field("New Loan Applications"; "New Loan Applications")
                {
                    DrillDownPageId = "Loan Application List-New";
                    ApplicationArea = All;
                }
                field("Loan App. Pending Appraisal"; "Loan App. Pending Appraisal")
                {
                    Caption = 'Loan Applications Pending Appraisal';
                    DrillDownPageId = "Loan Appl. List-Pending Apprsl";
                }
                field("Loan App. Pending Disbursal"; "Loan App. Pending Disbursal")
                {
                    Caption = 'Loan Applications Pending Disbursal';
                    DrillDownPageId = "Loan Appl. List-Pending Dbsl";
                }
            }

        }
    }
    trigger OnOpenPage();
    begin
        RESET;
        if not get then begin
            INIT;
            "Loan Officer" := GetUser.GetUser();
            INSERT;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        Validate("Total Deposits");
        Validate("Total Share Capital");
    end;

    var
        GetUser: Codeunit "Get User";

}