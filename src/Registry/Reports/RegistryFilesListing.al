report 55703 "Registry Files Listing"
{
    // version CBS-TL,REG

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\RegistryFilesListing.rdlc';
    Caption = 'Registry Member Files Inventory';

    dataset
    {
        dataitem("Registry File"; "Registry File")
        {
            DataItemTableView = WHERE("Created" = CONST(true));
            RequestFilterFields = "File Number", "File Type", "Member No.", "Date Filter";
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
            column(FileType_RegistryFiles; "Registry File"."File Type")
            {
            }
            column(FileNo_RegistryFiles; "Registry File"."File No.")
            {
            }
            column(FileName_RegistryFiles; "Registry File"."File Name")
            {
            }
            column(Type_RegistryFiles; "Registry File".Type)
            {
            }
            column(Status_RegistryFiles; "Registry File".Status)
            {
            }
            column(Location_RegistryFiles; "Registry File".Location)
            {
            }
            column(CabinetRackNo_RegistryFiles; "Registry File"."Cabinet/Rack No.")
            {
            }
            column(RowNo_RegistryFiles; "Registry File"."Row No.")
            {
            }
            column(ColumnNo_RegistryFiles; "Registry File"."Column No.")
            {
            }
            column(PocketNo_RegistryFiles; "Registry File"."Pocket No.")
            {
            }
            column(Remarks_RegistryFiles; "Registry File".Remarks)
            {
            }
            column(DateFileClosed_RegistryFiles; "Registry File"."Date File Closed")
            {
            }
            column(NoSeries_RegistryFiles; "Registry File"."No. Series")
            {
            }
            column(Issued_RegistryFiles; "Registry File".Issued)
            {
            }
            column(CreatedBy_RegistryFiles; "Registry File"."Created By")
            {
            }
            column(Created_RegistryFiles; "Registry File".Created)
            {
            }
            column(DateCreated_RegistryFiles; "Registry File"."Date Created")
            {
            }
            column(FileNumber_RegistryFiles; "Registry File"."File Number")
            {
            }
            column(Volume_RegistryFiles; "Registry File".Volume)
            {
            }
            column(RegFileStatus_RegistryFiles; "Registry File"."RegFile Status")
            {
            }
            column(File_status; RegistryStatus)
            {
            }
            column(FileRequestStatus_RegistryFiles; "Registry File"."File Request Status")
            {
            }
            column(StatusRequest; StatusRequest)
            {
            }
            column(deptName; deptName)
            {
            }
            column(IssuedTo; IssuedTo)
            {
            }
            column(BranchName; BranchName)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CreatedDate1 := DT2DATE("Registry File"."Date Created");
                CreatedDate2 := DT2DATE("Registry File"."Date Created");
                IF datefilterstring <> '' THEN BEGIN
                    IF CreatedDate1 < date1 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                    IF CreatedDate2 > date2 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                END;

                RegistryFiles2.RESET;
                RegistryFiles2.SETRANGE("File Request Status", "Registry File"."File Request Status"::"Issued Out");
                RegistryFiles2.SETRANGE(Issued, TRUE);
                IF RegistryFiles2.FIND('-') THEN BEGIN
                    IssuedRegistryFiles.RESET;
                    IssuedRegistryFiles.SETRANGE("Request ID", "Registry File"."Request ID");
                    IssuedRegistryFiles.SETRANGE(Issued, TRUE);
                    IF IssuedRegistryFiles.FIND('-') THEN BEGIN
                        IssuedTo := IssuedRegistryFiles."Requisiton By";
                        User.SETFILTER("User ID", IssuedTo);
                        IF User.FIND('-') THEN BEGIN
                            //dept:=User."Department Code";
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Global Dimension No.", 2);
                            DimensionValue.SETRANGE(Code, dept);
                            IF DimensionValue.FIND('-') THEN BEGIN
                                deptName := DimensionValue.Name;
                            END;
                        END;
                    END;
                END;

                DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                DimensionValue.SETRANGE(Code, "Registry File".Location);
                IF DimensionValue.FIND('-') THEN BEGIN
                    BranchName := DimensionValue.Name;
                END;



                RegistryFiles.RESET;
                RegistryFiles.SETRANGE("Status Code", "Registry File"."RegFile Status");
                IF RegistryFiles.FIND('-') THEN BEGIN
                    RegistryStatus := RegistryFiles.Description;
                END;
            end;

            trigger OnPreDataItem();
            begin
                datefilterstring := "Registry File".GETFILTER("Registry File"."Date Filter");
                IF STRPOS(datefilterstring, '..') <> 0 THEN BEGIN
                    IF datefilterstring <> '' THEN BEGIN
                        date1string := COPYSTR(datefilterstring, 1, STRPOS(datefilterstring, '..') - 1);
                        date2string := COPYSTR(datefilterstring, STRPOS(datefilterstring, '..') + 2);
                        EVALUATE(date1, date1string);
                        EVALUATE(date2, date2string);
                    END;
                END;
                IF STRPOS(datefilterstring, '..') = 0 THEN BEGIN
                    IF datefilterstring <> '' THEN BEGIN
                        date1string := datefilterstring;
                        date2string := date1string;
                        EVALUATE(date1, date1string);
                        EVALUATE(date2, date2string);
                    END;
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
        date1: Date;
        date2: Date;
        datefilterstring: Text;
        date1string: Text;
        date2string: Text;
        CreatedDate1: Date;
        CreatedDate2: Date;
        RegistryStatus: Text;
        RegistryFiles: Record "Registry File Status";
        StatusRequest: Text;
        RegistryFiles2: Record "Registry File";
        IssuedRegistryFiles: Record "Issued Registry File";
        IssuedTo: Code[100];
        dept: Code[10];
        DimensionValue: Record "Dimension Value";
        User: Record "User Setup";
        deptName: Text;
        BranchName: Text[20];
}

