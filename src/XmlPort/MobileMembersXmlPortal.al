xmlport 50010 "MobileMembersUpload"
{
    Caption = 'Upload Mobile Members';
    Direction = Import;
    //UseRequestPage = false;
    Format = VariableText;
    schema
    {
        textelement(MobileMembers)
        {
            tableelement(MobileBankingBuffer; MobileBankingBuffer)
            {
                XmlName = 'MobileBuffer';
                fieldelement(PhoneNo; MobileBankingBuffer."Phone No")
                {

                }
                fieldelement(MemberNo; MobileBankingBuffer."Member No")
                {

                }
                fieldelement(MemberName; MobileBankingBuffer."Member Name")
                {

                }
                trigger OnAfterInsertRecord()
                var
                    MobileBankingApp: Record "Mobile Banking Application";
                    MobileMember: Record "Mobile Banking Member";
                    MobileMember2: Record "Mobile Banking Member";
                    MemberRec: Record Member;
                    MobileBankingSetup: Record "Mobile Banking Setup";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                begin
                    MobileBankingApp.Init();
                    MobileBankingSetup.GET;
                    NoSeriesManagement.InitSeries(MobileBankingSetup."Mobile Banking Appl. Nos.", MobileBankingApp."No. Series",
                        TODAY, MobileBankingApp."No.", MobileBankingApp."No. Series");
                    MobileBankingApp."Phone No." := MobileBankingBuffer."Phone No";
                    MobileBankingApp."Member No." := MobileBankingBuffer."Member No";
                    MobileBankingApp."Member Name" := MobileBankingBuffer."Member Name";
                    MobileBankingApp."Service Type" := MobileBankingApp."Service Type"::"Mobile Banking";
                    MobileBankingApp."SMS Alert on" := MobileBankingApp."SMS Alert on"::Both;
                    MobileBankingApp."E-Mail Alert on" := MobileBankingApp."E-Mail Alert on"::Both;
                    MobileBankingApp."Uploaded from Excel" := true;
                    MobileBankingApp."Created By" := UserId;
                    MobileBankingApp."Created Date" := Today;
                    MobileBankingApp."Created Time" := time;
                    MobileBankingApp.Status := MobileBankingApp.Status::"Pending Approval";
                    MemberRec.Reset();
                    MemberRec.SetRange("Phone No.", MobileBankingBuffer."Phone No");
                    if MemberRec.FindFirst() then begin
                        MobileBankingApp."Approved By" := UserId;
                        MobileBankingApp."Approved Date" := Today;
                        MobileBankingApp."Approved Time" := time;
                        MobileBankingApp.Status := MobileBankingApp.Status::Approved;
                        MobileBankingApp."Member No." := MemberRec."No.";
                        MobileBankingApp."Member Name" := MemberRec."Full Name";
                    end;
                    if MobileBankingApp.Insert() then begin
                        if MobileBankingApp.Status = MobileBankingApp.Status::Approved then begin
                            MemberRec.Reset();
                            MemberRec.SetRange("Phone No.", MobileBankingBuffer."Phone No");
                            if MemberRec.FindFirst() then begin
                                MobileMember.Reset();
                                MobileMember.SetRange("Phone No.", MobileBankingBuffer."Phone No");
                                if not MobileMember.FindFirst() then begin
                                    MobileMember2.init;
                                    MobileMember2."Phone No." := MobileBankingBuffer."Phone No";
                                    MobileMember2."Member Name" := MemberRec."Full Name";
                                    MobileMember2."Member No." := MemberRec."No.";
                                    MobileMember2.Status := MobileMember2.Status::Active;
                                    MobileMember2.Insert();
                                end;
                            end;
                        end;
                    end else begin

                    end;
                end;

            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
