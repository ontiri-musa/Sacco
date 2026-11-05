page 55707 "File Queue2"
{
    // version CBS-TL,REG

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Transfer Files Line";
    //SourceTableView = WHERE(Returned= CONST(No),
    // "SentRet Note"=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transfer ID"; "Transfer ID")
                {
                    Visible = false;
                }
                field("File Number"; "File Number")
                {
                }
                field("File Name"; "File Name")
                {
                    StyleExpr = StyleText;
                }
                field("Member No"; "Member No")
                {
                }
                field("ID No"; "ID No")
                {
                }
                field("Payroll No"; "Payroll No")
                {
                }
                field("File Volume"; "File Volume")
                {
                }
                field("Time Received"; "Time Received")
                {
                }
                field("Due Date"; "Due Date")
                {
                    StyleExpr = StyleText;
                }
                field(sentreturnnote; sentreturnnote)
                {
                    Caption = 'sentreturnnote';
                }
                field("SentRet Note"; "SentRet Note")
                {
                }
                field("File No"; "File No")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Return Note")
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    User.GET(USERID);
                    CurrPage.SETSELECTIONFILTER(Rec);
                    IF "SentRet Note" = TRUE THEN
                        ERROR('The file return note has already been sent');
                    IF CONFIRM('Are you sure you want to return this file?') THEN BEGIN
                        FileReturn.INIT;
                        FileReturn."Return ID" := '';
                        NoSetup.GET();
                        NoSetup.TESTFIELD("Return ID");
                        NoSeriesMgt.InitSeries(NoSetup."Return ID", FileReturn."No. Series", 0D, FileReturn."Return ID", FileReturn."No. Series");
                        FileReturn."Return Date" := CURRENTDATETIME;
                        FileReturn."Staff Name" := USERID;
                        FileReturn.Remarks := 'File Return';
                        FileReturn."File Return Status" := FileReturn."File Return Status"::"Pending Acceptance";
                        FileReturn."Branch Code" := User."Global Dimension 1 Code";
                        FileReturn.Posted := TRUE;
                        FileReturn."Request ID" := "Request ID";
                        FileReturn.INSERT;
                        FileReturn.VALIDATE("Return ID");

                        TransferFilesLines.RESET;
                        TransferFilesLines.SETFILTER("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FINDFIRST THEN BEGIN //ERROR('%1',"Transfer ID");
                            TransferFilesLines."SentRet Note" := TRUE;
                            TransferFilesLines.MODIFY;
                            COMMIT;
                        END;

                        TransferFilesLines2.INIT;
                        TransferFilesLines2."Transfer ID" := FileReturn."Return ID";
                        TransferFilesLines2."File No" := "File No";
                        TransferFilesLines2."File Number" := "File Number";
                        TransferFilesLines2."Member No" := "Member No";
                        TransferFilesLines2."File Name" := "File Name";
                        TransferFilesLines2."Member No" := "Member No";
                        TransferFilesLines2."ID No" := "ID No";
                        TransferFilesLines2."Payroll No" := "Payroll No";
                        TransferFilesLines2."File Volume" := "File Volume";
                        TransferFilesLines2."Released From" := USERID;
                        TransferFilesLines2."Time Released" := CURRENTDATETIME;
                        TransferFilesLines2."Request ID" := "Request ID";
                        TransferFilesLines2."SentRet Note" := TRUE;
                        TransferFilesLines2."Carried By" := "Received By";//
                        TransferFilesLines2."Due Date" := "Due Date";
                        TransferFilesLines2."File Type" := "File Type";
                        TransferFilesLines2.INSERT;

                        // MESSAGE('%1,%2',FileReturn."Return ID","File Name");

                        MESSAGE('File Return Note has been sent to registry under file return ID: %1,', FileReturn."Return ID");

                    END;
                end;
            }
            action("Transfer File")
            {
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to transfer this file?') THEN BEGIN

                        //TransferRegistryFiles.RESET;
                        TransferRegistryFiles.INIT;
                        TransferRegistryFiles."Transfer ID" := '';
                        NoSetup.GET();
                        NoSetup.TESTFIELD("Transfer ID");
                        NoSeriesMgt.InitSeries(NoSetup."Transfer ID", TransferRegistryFiles."No. Series", 0D, TransferRegistryFiles."Transfer ID", TransferRegistryFiles."No. Series");
                        MESSAGE('%1', TransferRegistryFiles."Transfer ID");
                        TransferRegistryFiles."Released From" := USERID;
                        TransferRegistryFiles."Time Released" := CURRENTDATETIME;
                        TransferRegistryFiles.Status := TransferRegistryFiles.Status::New;
                        TransferRegistryFiles.INSERT;
                        TransferRegistryFiles.VALIDATE("Transfer ID");


                        //TransferFilesLines.RESET;
                        TransferFilesLines.INIT;
                        TransferFilesLines."Transfer ID" := TransferRegistryFiles."Transfer ID";
                        TransferFilesLines."File No" := "File No";
                        TransferFilesLines."File Number" := "File Number";
                        TransferFilesLines."Member No" := "Member No";
                        TransferFilesLines."File Name" := "File Name";
                        TransferFilesLines."Member No" := "Member No";
                        TransferFilesLines."ID No" := "ID No";
                        TransferFilesLines."Payroll No" := "Payroll No";
                        TransferFilesLines."File Volume" := "File Volume";
                        TransferFilesLines."Released From" := USERID;
                        TransferFilesLines."Time Released" := CURRENTDATETIME;
                        TransferFilesLines."Request ID" := "Request ID";
                        TransferFilesLines.INSERT;
                        PAGE.RUN(74046, TransferRegistryFiles);
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF CURRENTDATETIME > "Due Date" THEN BEGIN
            StyleText := 'Unfavorable';
            // Overdue:=TRUE;
        END;
    end;

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        FILTERGROUP(2);
        SETRANGE("Received By", USERID);
        SETRANGE("SentRet Note", FALSE);
        FILTERGROUP(0);
        //SETRANGE("Released To",USERID);
        //SETRANGE("Time Received",0T);
    end;

    var
        User: Record "User Setup";
        Overdue: Boolean;
        StyleText: Text[20];
        FileReturn: Record "File Return";
        TransferFilesLines: Record "Transfer Files Line";
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        sentreturnnote: Boolean;
        TransferRegistryFiles: Record "Transfer Registry File";
        TransferFilesLines2: Record "Transfer Files Line";
}

