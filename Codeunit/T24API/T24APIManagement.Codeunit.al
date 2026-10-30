codeunit 51170 "NCBAAPI Management"
{
    trigger OnRun()
    begin

    end;

    var
        GlobalSetup: Record "Global Setup";
        CTSSetup: Record "CTS Setup";
        Member: Record Member;
        FOSASetup: Record "Global Setup";
    //NoSeriesMgt: Codeunit NoSeriesManagement;

    //procedure CustomerCreation(CustomerName: Code[100]; CustomerIdNumber: Code[50]; CustomerEmail: Code[50]; CustomerMsisdn: Code[50]; VAR ResponseCode: Code[10]; VAR ResponseMessage: Text[250]; VAR T24CustomerNumber: Code[50])



    /*FOSASetup.GET;
    FOSASetup.TESTFIELD("MA Individual Nos.");
    Member.INIT;
    MemberNo:=NoSeriesMgt.GetNextNo(FOSASetup."MA Individual Nos.",TODAY,TRUE);
    Member."No.":=MemberNo;
    Member."Identification No.":=CustomerIdNumber
    Member."E-Mail":=CustomerEmail
    Member.Name:=CustomerName;
    //Member.pa:=CustomerMsisdn;
    Member.INSERT;
    ResponseCode:='00';
    ResponseMessage:='Customer Successfully Created';
    T24CustomerNumber:=FORMAT(MemberNo);*/





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