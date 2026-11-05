xmlport 59010 "MembersUpload"
{
    Caption = 'Upload Members';
    Direction = Import;
    //UseRequestPage = false;
    Format = VariableText;
    schema
    {
        textelement(Members)
        {
            tableelement(Member; Member)
            {
                XmlName = 'MobileBuffer';
                fieldelement(MemberNo; Member."No.")
                {

                }
                fieldelement(MemberName; Member."Full Name")
                {

                }
                fieldelement(RegDate; Member."Registration Date")
                {

                }
                fieldelement(DateOfBirth; Member."Date of Birth")
                {

                }
                fieldelement(MaritalStatus; Member."Marital Status")
                {

                }
                fieldelement(PhoneNo; Member."Phone No.")
                {

                }
                fieldelement(Gender; Member.Gender)
                {

                }
                fieldelement(Email; Member."E-mail")
                {

                }
                fieldelement(NationalID; Member."National ID")
                {

                }
                fieldelement(PhysicalAdd; Member."Physical Address")
                {

                }
                fieldelement(PostalAdd; Member."Postal Address")
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
