table 55751 "File Requests Trail"
{
    // version CBS-TL,REG


    fields
    {
        field(1; "Request ID"; Code[30])
        {
            TableRelation = "Issued Registry File";
        }
        field(2; "Request No."; Integer)
        {
        }
        field(3; Requester; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(4; "Request Date"; Date)
        {
        }
        field(5; "Approval Date"; Date)
        {
        }
        field(6; "Approver ID"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(7; "File Transferred"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Request ID", "Request No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        //ThisRec.RESET;
        ThisRec.RESET;
        ThisRec.SETRANGE("Request ID", "Request ID");
        IF ThisRec.FINDLAST THEN BEGIN
            "Request No." := ThisRec."Request No." + 1;
        END;
        IF NOT ThisRec.FINDLAST THEN BEGIN
            "Request No." := 1;
        END;

        IssuedFileRc.RESET;
        IssuedFileRc.SETRANGE("Request ID", "Request ID");
        IF IssuedFileRc.FINDSET THEN BEGIN
            "Approver ID" := IssuedFileRc."Requisiton By";
        END;

        Requester := GetUser.Getuser();
        "Request Date" := TODAY;
    end;

    var
        ThisRec: Record "File Requests Trail";
        GetUser: Codeunit "Get User";
        IssuedFileRc: Record "Issued Registry File";
}

