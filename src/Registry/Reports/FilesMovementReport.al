report 55700 "Files Movement Report"
{
    // version CBS-TL,REG

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\FilesMovementReport.rdlc';
    Caption = 'Branch File Intertransfer Report';

    dataset
    {
        dataitem("File Movement"; "File Movement")
        {
            DataItemTableView = WHERE(Status = CONST(Received));
            RequestFilterFields = "File No.", "File Name", "Member No", "Date Filter";
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(PostCode_CompanyInformation; CompanyInformation."Post Code")
            {
            }
            column(City_CompanyInformation; CompanyInformation.City)
            {
            }
            column(Pic_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(FileMovementID_FileMovement; "File Movement"."File Movement ID")
            {
            }
            column(FileNo_FileMovement; "File Movement"."File No.")
            {
            }
            column(FileName_FileMovement; "File Movement"."File Name")
            {
            }
            column(ReasonCode_FileMovement; "File Movement"."Reason Code")
            {
            }
            column(CabinetNo_FileMovement; "File Movement"."Cabinet No.")
            {
            }
            column(Volume_FileMovement; "File Movement".Volume)
            {
            }
            column(FromLocation_FileMovement; "File Movement"."From Location")
            {
            }
            column(ToLocation_FileMovement; "File Movement"."To Location")
            {
            }
            column(Remarks_FileMovement; "File Movement"."Request Remarks")
            {
            }
            column(ReleasedBy_FileMovement; "File Movement"."Released By")
            {
            }
            column(ReleasedTo_FileMovement; "File Movement"."Released To")
            {
            }
            column(CarriedBy_FileMovement; "File Movement"."Carried By")
            {
            }
            column(MemberNo_FileMovement; "File Movement"."Member No")
            {
            }
            column(IDNo_FileMovement; "File Movement"."ID No")
            {
            }
            column(PayrollNo_FileMovement; "File Movement"."Payroll No")
            {
            }
            column(DateReleased_FileMovement; "File Movement"."Date Released")
            {
            }

            trigger OnAfterGetRecord();
            begin
                RequestDate1 := DT2DATE("File Movement"."Request Date");
                RequestDate2 := DT2DATE("File Movement"."Request Date");
                IF DateFilterString <> '' THEN BEGIN
                    IF RequestDate1 < Date1 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                    IF RequestDate2 > Date2 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                END;
            end;

            trigger OnPreDataItem();
            begin
                DateFilterString := "File Movement".GETFILTER("File Movement"."Date Filter");
                IF STRPOS(DateFilterString, '..') <> 0 THEN BEGIN
                    Date1String := COPYSTR(DateFilterString, 1, STRPOS(DateFilterString, '..') - 1);
                    Date2String := COPYSTR(DateFilterString, STRPOS(DateFilterString, '..') + 2);
                    EVALUATE(Date1, Date1String);
                    EVALUATE(Date2, Date2String);
                END;
                IF STRPOS(DateFilterString, '..') = 0 THEN BEGIN
                    Date1String := DateFilterString;
                    Date2String := Date1String;
                    EVALUATE(Date1, Date1String);
                    EVALUATE(Date2, Date2String);
                END;
            end;
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
        CompanyInformation.GET();
    end;

    var
        CompanyInformation: Record "Company Information";
        Date1: Date;
        Date2: Date;
        Date1String: Text;
        Date2String: Text;
        DateFilterString: Text;
        RequestDate1: Date;
        RequestDate2: Date;
}

