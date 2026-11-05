table 50234 "Training Request"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Request Date"; Date)
        {
        }
        field(3; "Training Description"; Text[100])
        {
        }
        field(4; "Course/Seminar Name"; Text[100])
        {
        }
        field(5; "Training Institution"; Text[100])
        {
        }
        field(6; Venue; Text[100])
        {
        }
        field(7; Duration; Decimal)
        {
        }
        field(8; "Duration Units"; Option)
        {
            OptionCaption = ' ,Hours,Days,Weeks,Months,Years';
            OptionMembers = " ",Hours,Days,Weeks,Months,Years;
        }
        field(9; "Start Date"; Date)
        {
        }
        field(10; "End Date"; Date)
        {
        }
        field(11; Location; Option)
        {
            OptionCaption = ' ,Town,City';
            OptionMembers = " ",Town,City;
        }
        field(12; "Cost of Training"; Decimal)
        {
        }
        field(13; "Total Cost of Training"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Training Request Line"."Total Cost" WHERE("Training Request No." = FIELD("No.")));
            Editable = false;

        }
        field(14; "Request Time"; Time)
        {
        }
        field(15; "Requested By"; Code[50])
        {
        }
        field(16; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Released,Rejected';
            OptionMembers = New,"Pending Approval",Released,Rejected;
        }
        field(17; "HOD Approved"; Boolean)
        {
        }
        field(18; "CEO Approved"; Boolean)
        {
        }
        field(19; "Added To Calendar"; Boolean)
        {
        }
        field(20; "Submitted To HR"; Boolean)
        {
        }
        field(21; "Reason for Request"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Training Description", "Course/Seminar Name")
        {
        }
    }

    trigger OnInsert();
    begin
        HRSetup.GET;
        "No." := NoSeriesMgt.GetNextNo(HRSetup."Training Nos.", 0D, TRUE);
        "Request Date" := TODAY;
        "Request Time" := TIME;
        "Requested By" := GetUser();
    end;

    trigger OnDelete();
    begin
        if Status = Status::Released then
            Error(Error000);
    end;

    var
        Error000: Label 'You cannot delete this record!';
        Error001: Label 'You cannot modify this record!';
        NoSeriesMgt: Codeunit 396;
        HRSetup: Record 5218;

    local procedure GetUser(): Code[100];
    var
        ActiveSession: Record "Active Session";
    begin
        ActiveSession.Reset();
        ActiveSession.SetRange("Session ID", SessionId());
        if ActiveSession.FindFirst() then
            exit(ActiveSession."User ID");
    end;

}

