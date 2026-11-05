report 50200 "Group Attendance"
{
    // version MC2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/Group Attendance.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Group Attendance Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(MeetingNo_MCGroupAttendanceHeader; "No.")
            {
            }
            column(GroupID_MCGroupAttendanceHeader; "Group No.")
            {
            }
            column(MeetingDate_MCGroupAttendanceHeader; "Current Meeting Date")
            {
            }
            column(MeetingPlace_MCGroupAttendanceHeader; "Meeting Venue")
            {
            }
            column(GroupOfficer_MCGroupAttendanceHeader; "Loan Officer ID")
            {
            }
            column(Remarks_MCGroupAttendanceHeader; Remarks)
            {
            }
            column(LastMeetingDate_MCGroupAttendanceHeader; "Last Meeting Date")
            {
            }
            column(MeetingTime_MCGroupAttendanceHeader; "Current Meeting Time")
            {
            }
            dataitem(DataItem2; "Group Attendance Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Member No.");
                column(GroupMemberNo_MCGroupAttendanceLine; "Member No.")
                {
                }
                column(GroupMemberName_MCGroupAttendanceLine; "Member Name")
                {
                }
                column(Present_MCGroupAttendanceLine; Present)
                {
                }
                column(MeetingNo_MCGroupAttendanceLine; "Document No.")
                {
                }
                column(headertext; headertext)
                {
                }
                column(SerialNo; SerialNo)
                {
                }
                column(ReportCode; ReportCode)
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(CompanyInformation_Address; CompanyInformation.Address)
                {
                }
                column(CompanyInformation_PostCode; CompanyInformation."Post Code")
                {
                }
                column(CompanyInformation_City; CompanyInformation.City)
                {
                }
                column(CompanyInformation_Picture; CompanyInformation.Picture)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    SerialNo += 1;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin

        /*  filtervalue := GETFILTER("No.");
            IF filtervalue = '' THEN BEGIN
                ERROR(Error000);
            END;*/

        MicroCreditSetup.GET;
        ReportCode := MicroCreditSetup."Group Attendance Report Code";

        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        headertext: Label 'Group Attendance Report';
        SerialNo: Integer;
        filtervalue: Text;
        Error000: Label 'Kindly specify the meeting no!';
        ReportCode: Code[10];
        MicroCreditSetup: Record "Microcredit Setup";
        CompanyInformation: Record "Company Information";
}

