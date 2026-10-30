page 50492 "Separation Card"
{
    Caption = 'Separation Form';
    PageType = Card;
    SourceTable = Separation;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Separation Date"; "Separation Date")
                {
                    ApplicationArea = All;
                }
                field("Separation Type"; "Separation Type")
                {
                    ApplicationArea = All;
                }
                field("Notification Start Date"; "Notification Start Date")
                {
                    ApplicationArea = All;
                }
                field("Notice Period"; "Notice Period")
                {
                    ApplicationArea = All;
                }
                field("Notification End Date"; "Notification End Date")
                {
                    ApplicationArea = All;
                }
                field("Last Working Date"; "Last Working Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Accrual End Date"; "Leave Accrual End Date")
                {
                    ApplicationArea = All;
                }
                field("Days In Lieu of Notice"; "Days In Lieu of Notice")
                {
                    ApplicationArea = All;
                }
                field("Reason for Separation"; "Reason for Separation")
                {
                    ApplicationArea = All;
                }
                field("Separation Status"; "Separation Status")
                {
                    ApplicationArea = All;
                }
            }
            group("Leave Days")
            {
                Caption = 'Leave Days';
                Visible = SeeTerminalDues;
                field("Leave Balance"; "Leave Days Earned to Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Days in Notice"; "Leave Days in Notice")
                {
                    ApplicationArea = All;
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                    ApplicationArea = All;
                }
                field("Leave End Date"; "Leave End Date")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Leave Days"; "Outstanding Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Pay for Outstanding Leave Days"; "Pay for Outstanding Leave Days")
                {
                    ApplicationArea = All;
                }
            }
            group(Salary)
            {
                Caption = 'Salary';
                Visible = SeeTerminalDues;
                field("Basic Salary"; "Basic Salary")
                {
                    ApplicationArea = All;
                }
                field("No. Of Months Salary"; "No. Of Months Salary")
                {
                    ApplicationArea = All;
                }
                field("No. Full Months Worked"; "Salary For Full Month")
                {
                    ApplicationArea = All;
                }
                field("Extra Days Worked"; "Salary For Extra Days")
                {
                    ApplicationArea = All;
                }
                field("Part Salary Start Date"; "Part Salary Start Date")
                {
                    ApplicationArea = All;
                }
                field("Part Salary End Date"; "Part Salary End Date")
                {
                    ApplicationArea = All;
                }
                field("Part Salary to be paid"; "Part Salary to be paid")
                {
                    ApplicationArea = All;
                }
            }
            group(Allowances)
            {
                Caption = 'Allowances';
                Visible = SeeTerminalDues;
                field("Golden Handshake"; "Golden Handshake")
                {
                    ApplicationArea = All;
                }
                field("Transport Allowance"; "Transport Allowance")
                {
                    ApplicationArea = All;
                }
                field("No of Years Worked"; "No of Years Worked")
                {
                    ApplicationArea = All;
                }
                field("Severence Pay"; "Severence Pay")
                {
                    ApplicationArea = All;
                }
                field("Pay Leave Allowance"; "Pay Leave Allowance")
                {
                    ApplicationArea = All;
                }
                field("Leave Allowance Paid"; "Leave Allowance Paid")
                {
                    ApplicationArea = All;
                }
                field("Pay Car Allowance"; "Pay Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("No of Months Car Allowance"; "No of Months Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("Car Allowance(Months)"; "Car Allowance(Months)")
                {
                    ApplicationArea = All;
                }
                field("No of Days for Car Allowance"; "No of Days for Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("Car Allowance"; "Car Allowance")
                {
                    ApplicationArea = All;
                }
            }
            group(Totals)
            {
                Caption = 'Totals';
                Visible = SeeTerminalDues;
                field(Total; Total)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(PAYE)
            {
                Caption = 'PAYE';
                Visible = SeeTerminalDues;
                field("PAYE Due"; "PAYE Due")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total after PAYE"; "Total after PAYE")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Offset Leave Days"; "Offset Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Amount In Lieu of Notice"; "Amount In Lieu of Notice")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Payable)
            {
                Caption = 'Payable';
                Visible = SeeTerminalDues;
                field("Total Deductions"; "Total Deductions")
                {
                    ApplicationArea = All;
                }
                field("Amount Payable"; "Amount Payable")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

        }
    }

    actions
    {
        area(processing)
        {
            action("Employee Termination Report")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    REPORT.RUN(50280, TRUE, TRUE, Rec);

                end;
            }
            action("Move to Processing")
            {
                ApplicationArea = All;
                Image = MoveUp;
                Visible = SeeSend;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    if Confirm(Text000) then begin
                        "Separation Status" := "Separation Status"::Processing;
                        Modify(true);
                        Message(Text001);
                        CurrPage.Close();
                    end;

                end;
            }

            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                RunObject = page "Document Attachment Details";
                RunPageLink = "No." = field("Separation No");

            }
            action("Mark As Processed")
            {
                Image = Save;
                Visible = SeeTerminalDues;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    HRManagement.UpdateSeparationInfo(Rec);
                end;
            }
        }
    }

    var
        HRManagement: Codeunit "HR Management";
        SeeTerminalDues: Boolean;
        SeeSend: Boolean;
        Text000: Label 'Are you sure you want to move this request to processing?';
        Text001: Label 'Moved to processing successfully!';

    trigger OnOpenPage()
    begin
        if "Separation Status" = "Separation Status"::New then begin
            SeeTerminalDues := false;
            SeeSend := true;
        end;
        if "Separation Status" = "Separation Status"::Processed then
            CurrPage.Editable(false);
        if "Separation Status" = "Separation Status"::Processing then
            SeeTerminalDues := true;
    end;

}

