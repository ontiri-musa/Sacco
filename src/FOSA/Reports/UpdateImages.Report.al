report 50049 "Update Images"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; Member)
        {
            trigger OnAfterGetRecord()
            begin
                FileName := 'C:\Program Files\Microsoft Dynamics 365 Business Central\150\Web Client\Pics\';
                FilePath := 'http://192.168.0.121/Microsoft%20Dynamics%20365%20Business%20Central%20Web%20Client/WebClient/Pics/';
                if FileCU.ClientFileExists(FileName + "No." + 'PIC.jpg') then begin
                    "Picture Path" := FilePath + "No." + 'PIC.jpg';
                    Modify();
                end else begin
                    if Picture.HASVALUE then begin
                        Picture.EXPORTFILE(FileName + "No." + 'PIC.jpg');
                        "Picture Path" := FilePath + "No." + 'PIC.jpg';
                        Modify();
                    end
                end;

                if FileCU.ClientFileExists(FileName + "No." + 'FID.jpg') then begin
                    "Front ID Path" := FilePath + "No." + 'FID.jpg';
                    Modify();
                end else begin
                    if "Front ID".HASVALUE then begin
                        "Front ID".EXPORTFILE(FileName + "No." + 'FID.jpg');
                        "Front ID Path" := FilePath + "No." + 'FID.jpg';
                        Modify();
                    end
                end;

                if FileCU.ClientFileExists(FileName + "No." + 'BID.jpg') then begin
                    "Back ID Path" := FilePath + "No." + 'BID.jpg';
                    Modify();
                end else begin
                    if "Back ID".HASVALUE then begin
                        "Back ID".EXPORTFILE(FileName + "No." + 'BID.jpg');
                        "Back ID Path" := FilePath + "No." + 'BID.jpg';
                        Modify();
                    end
                end;

                if FileCU.ClientFileExists(FileName + "No." + 'SIG.jpg') then begin
                    "Signature Path" := FilePath + "No." + 'SIG.jpg';
                    Modify();
                end else begin
                    if Signature.HASVALUE then begin
                        Signature.EXPORTFILE(FileName + "No." + 'SIG.jpg');
                        "Signature Path" := FilePath + "No." + 'SIG.jpg';
                        Modify();
                    end
                end;
            end;

        }

    }



    var
        Current: Integer;
        Total: Integer;
        Progress: Dialog;
        FileCU: Codeunit "File Management";
        FileName: Text;
        FilePath: Text;
        Member2: Record Member;
}