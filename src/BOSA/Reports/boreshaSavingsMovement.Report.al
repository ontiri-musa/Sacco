report 51042 "Boresha Movements Reports"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/DepositMovement.rdl';
    Caption = 'Boresha Movements';
    dataset
    {
        dataitem(Vendor; Vendor)
        {



            column(MemberName; "Member Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Name; Name)
            {
            }

            column(Balance; Balance)
            {
            }
            column(DDate; DDate)
            {

            }
            column(PhoneNo; PhoneNo)
            { }
            Column(OpenBal; OpenBal)
            {

            }
            column(Period; Period)
            {

            }
            Column(JanCont; JanCont)
            {

            }
            Column(FebCont; FebCont)
            {

            }
            column(MarchCont; MarchCont)
            {

            }
            Column(AprilCont; AprilCont)
            {

            }
            Column(MayCont; MayCont)
            {

            }
            Column(JuneCont; JuneCont)
            {

            }
            Column(JulyCont; JulyCont)
            {

            }
            Column(AugCont; AugCont)
            {

            }
            Column(SepCont; SepCont)
            {

            }
            Column(OctCont; OctCont)
            {

            }
            Column(NovCont; NovCont)
            {

            }
            Column(AsAt; AsAt)
            {

            }
            Column(totals; totals)
            {

            }
            Column(DecCont; DecCont)
            {

            }
            column(Deposits; Deposits)
            {

            }
            column(employer; employer)
            {

            }
            trigger OnPreDataItem()
            begin
                IF AsAt = 0D THEN
                    AsAt := TODAY;


                FirstDateOfTheYear := CALCDATE('-CY', AsAt);
                JanText := 'Jan ';
                FebText := 'Feb ';
                MarchText := 'March ';
                AprilText := 'April ';
                MayText := 'May ';
                JuneText := 'June ';
                JulyText := 'July ';
                AugText := 'Aug ';
                SepText := 'Sep ';
                OctText := 'Oct ';
                NovText := 'Nov ';
                DecText := 'Dec ';

                Period := DATE2DMY(FirstDateOfTheYear, 3);

                SetFilter("Account Type", '%1', '03');
            end;

            trigger OnAfterGetRecord()
            begin
                Deposits := 0;
                IF Memb.GET(Vendor."Member No.") THEN
                    PhoneNo := Memb."Phone No.";

                IF (Memb."No." = 'MB996') OR (Memb."No." = 'MB997') THEN
                    CurrReport.SKIP;
                /*IF Company <> '' THEN
                    IF Memb."Company Code" <> Company THEN
                        CurrReport.SKIP;*/

                employer := fnGetEmployer(Vendor."Member No.");


                JanCont := 0;
                FebCont := 0;
                MarchCont := 0;
                AprilCont := 0;
                MayCont := 0;
                JuneCont := 0;
                JulyCont := 0;
                AugCont := 0;
                SepCont := 0;
                OctCont := 0;
                NovCont := 0;
                DecCont := 0;
                OpenBal := 0;
                totals := 0;


                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", '<=%1', FirstDateOfTheYear);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    OpenBal := Dvend.Amount * -1;
                END;


                DFilter := FORMAT(FirstDateOfTheYear) + '..' + FORMAT(CALCDATE('CM', FirstDateOfTheYear));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    JanCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('1M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('1M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    FebCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('2M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('2M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    MarchCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('3M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('3M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    AprilCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('4M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('4M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    MayCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('5M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('5M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    JuneCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('6M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('6M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    JulyCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('7M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('7M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    AugCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('8M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('8M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    SepCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('9M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('9M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    OctCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('10M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('10M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    NovCont := Dvend.Amount * -1;
                END;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('11M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('11M', FirstDateOfTheYear))));
                Dvend.RESET;
                Dvend.SETRANGE(Dvend."Vendor No.", Vendor."No.");
                Dvend.SETFILTER(Dvend."Posting Date", DFilter);
                //Dvend.SETFILTER(Dvend."Credit Amount",'>%1',0);
                IF Dvend.FINDSET THEN BEGIN
                    Dvend.CALCSUMS(Amount);
                    DecCont := Dvend.Amount * -1;
                END;

                totals := (JanCont + FebCont + MarchCont + AprilCont + MayCont + JuneCont + JulyCont + AugCont + SepCont + OctCont + NovCont + DecCont);

                //DDate := LoanApp."Disbursal Date";


            end;



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

                    field(AsAt; AsAt)
                    {
                        Caption = 'AsAt';
                        ApplicationArea = All;
                    }
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
    local procedure fnGetEmployer(memberNo: Code[55]) empCode: Code[65];
    begin
        member.Reset();
        member.SetRange("No.", memberNo);
        if member.Find('-') then
            empCode := member."Church District Code";
        exit(empCode);
    end;

    var
        AsAt: Date;
        FirstDateOfTheYear: Date;
        OpenBal: Decimal;
        DDate: Date;
        Dvend: Record "Detailed Vendor Ledg. Entry";
        CompanyInfo: Record "Company Information";
        Memb: Record Member;
        LoanApp: Record "Loan Application";
        DFilter: Text;
        Period: Integer;
        JanCont: Decimal;
        JanText: Text;
        FebCont: Decimal;
        FebText: Text;
        MarchCont: Decimal;
        MarchText: Text;
        AprilCont: Decimal;
        AprilText: Text;
        MayCont: Decimal;
        MayText: Text;
        JuneCont: Decimal;
        JuneText: Text;
        JulyCont: Decimal;
        JulyText: Text;
        AugCont: Decimal;
        AugText: Text;
        SepCont: Decimal;
        SepText: Text;
        OctCont: Decimal;
        OctText: Text;
        NovCont: Decimal;
        NovText: Text;
        DecCont: Decimal;
        DecText: Text;
        PhoneNo: Code[50];
        Company: Code[80];
        Deposits: Decimal;
        employer: Code[120];
        member: Record Member;
        totals: Decimal;


}
