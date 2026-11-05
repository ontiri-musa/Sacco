page 50349 "FOSA RoleCenter Headline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline0; StrSubstNo(text000, GetUser.GetUser()))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    //Page.Run(390);
                end;
            }
            field(Headline1; StrSubstNo(text001, Member.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50012);
                end;
            }
            field(Headline2; StrSubstNo(text002, SpotcashMember.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50149);
                end;
            }
            field(Headline3; StrSubstNo(text003, IssuedChequeBooksCount))
            {
                Visible = false;
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50169);
                end;
            }
        }
    }
    local procedure IssuedChequeBooksCount(): Integer
    var
        ChequeBook: Record "Cheque Book";
    begin
        ChequeBook.Reset();
        ChequeBook.SetRange(Status, ChequeBook.Status::Issued);
        exit(ChequeBook.Count)
    end;

    var
        text000: TextConst ENU = '<qualifier>Welcome</qualifier><payload>Welcome<emphasize> %1 </emphasize></payload>';
        text001: TextConst ENU = '<qualifier>Members</qualifier><payload>You have registered<emphasize> %1 </emphasize>members so far.</payload>';
        //'You have registered %1 members so far';
        text002: TextConst ENU = '<qualifier>Mobile Banking</qualifier><payload><emphasize> %1 </emphasize>members have been onboarded for Mobile Banking</payload>';
        text003: TextConst ENU = '<qualifier>CTS</qualifier><payload><emphasize> %1 </emphasize>members have been issued with Cheque Books</payload>';
        Member: Record Member;
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        SpotcashMember: Record "Mobile Banking Member";
        GetUser: Codeunit "Get User";


}