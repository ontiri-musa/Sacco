page 51208 "Marketing RoleCenter Headline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline0; StrSubstNo(text000, UserId))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(390);
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
            field(Headline2; StrSubstNo(text002, RegisteredMembers()))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50012);
                end;
            }

        }

    }
    local procedure RegisteredMembers(): Integer
    begin
        Member.Reset();
        Member.SetRange("Approval Date", CalcDate('-CM', Today), Today);
        exit(Member.Count);
    end;

    var
        Text000: TextConst ENU = '<qualifier>Welcome</qualifier><payload>Welcome<emphasize> %1 </emphasize></payload>';
        Text001: TextConst ENU = '<qualifier>Members</qualifier><payload>There are a total of <emphasize> %1 </emphasize>members.</payload>';
        Text002: TextConst ENU = '<qualifier>Members</qualifier><payload><emphasize> %1 </emphasize>members have been registered this month.</payload>';
        Member: Record Member;
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        SpotcashMember: Record "Mobile Banking Member";
}