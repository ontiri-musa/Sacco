page 50486 HRCuePage
{
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(content)
        {
            cuegroup(Employees)
            {
                //  CuegroupLayout = Wide;

                field("Active Employees"; "Active Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Active Employees';
                    DrillDownPageId = "Employee List";
                }
                field("Employees on Probation"; "Employees on Probation")
                {
                    ApplicationArea = All;
                    Caption = 'Employees on Probation';
                    DrillDownPageId = "Employees On Probation";
                }
                field("Total Employees"; "Total Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Total Employees';
                    DrillDownPageId = "Employee List";
                }
            }
            cuegroup("Leave Applications")
            {
                // CuegroupLayout = Wide;
                field("New Leave Applications"; "New Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'New Leave Applications';
                    DrillDownPageId = "Leave Application List";
                }
                field("Leave Appl. Pending Approval"; "Leave Appl. Pending Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Applications Pending Approval';
                    DrillDownPageId = "Leave App. Pending Approval";
                }
                field("Approved Leave Applications"; "Approved Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Approved Leave Applications';
                    DrillDownPageId = "Approved Leave Application";
                }
            }

            cuegroup("Training Requests")
            {
                field("New Training Request"; "New Training Request")
                {
                    ApplicationArea = All;
                    Caption = 'New Training Request';
                    DrillDownPageId = "Training Request List";
                }
                field("Training Req. Pending Approval"; "Training Req. Pending Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Training Request Pending Approval';
                    DrillDownPageId = "Training Req. Pending Approval";
                }

                field("Approved Training Request"; "Approved Training Request")
                {
                    ApplicationArea = All;
                    Caption = 'Approved Training Request';
                    DrillDownPageId = "Approved Training Requests";
                }
            }


        }
    }



    trigger OnOpenPage();
    begin
        RESET;
        if not get then begin
            INIT;
            INSERT;
        end;
    end;
}