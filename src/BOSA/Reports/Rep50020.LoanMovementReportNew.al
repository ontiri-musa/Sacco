report 50020 "Loan Movement Report New"
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Movement Report New.rdl';

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = CONST(true));
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(MemberNo_LoanApplication; "Loan Application"."Member No.")
            {
            }
            column(MemberName_LoanApplication; "Loan Application"."Member Name")
            {
            }
            column(Description_LoanApplication; "Loan Application".Description)
            {
            }
            column(Date_of_Completion; "Date of Completion")
            {
            }
            column(OutstandingBalance_LoanApplication; "Loan Application"."Outstanding Balance")
            {
            }
            column(DisbursalDate_LoanApplication; DDate)
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(OpenBal; OpenBal)
            {
            }
            column(Period; Period)
            {
            }
            column(JanCont; JanCont)
            {
            }
            column(FebCont; FebCont)
            {
            }
            column(MarchCont; MarchCont)
            {
            }
            column(AprilCont; AprilCont)
            {
            }
            column(MayCont; MayCont)
            {
            }
            column(JuneCont; JuneCont)
            {
            }
            column(JulyCont; JulyCont)
            {
            }
            column(AugCont; AugCont)
            {
            }
            column(SepCont; SepCont)
            {
            }
            column(OctCont; OctCont)
            {
            }
            column(NovCont; NovCont)
            {
            }
            column(DecCont; DecCont)
            {
            }
            column(Deposits; Deposits)
            {
            }

            trigger OnAfterGetRecord();
            var
                AccType: Record "Account Type";
            begin
                Deposits := 0;

                if "Loan Application"."Disbursal Date" <> 0D then
                    DDate := "Loan Application"."Disbursal Date"
                else
                    DDate := CALCDATE('-1M', "Loan Application"."Next Due Date");

                if Memb.GET("Loan Application"."Member No.") then
                    PhoneNo := Memb."Phone No.";

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


                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", '<=%1', FirstDateOfTheYear);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS(Amount);
                    OpenBal := Dcust.Amount;
                    if OpenBal = 0 then
                        CurrReport.SKIP;
                end else begin
                    OpenBal := "Loan Application"."Approved Amount";
                end;


                DFilter := FORMAT(FirstDateOfTheYear) + '..' + FORMAT(CALCDATE('CM', FirstDateOfTheYear));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    JanCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('1M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('1M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    FebCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('2M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('2M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    MarchCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('3M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('3M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    AprilCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('4M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('4M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    MayCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('5M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('5M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    JuneCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('6M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('6M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    JulyCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('7M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('7M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    AugCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('8M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('8M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    SepCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('9M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('9M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    OctCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('10M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('10M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    NovCont := Dcust."Credit Amount";
                end;

                DFilter := FORMAT(CALCDATE('-CM', CALCDATE('11M', FirstDateOfTheYear))) + '..' + FORMAT((CALCDATE('CM', CALCDATE('11M', FirstDateOfTheYear))));
                Dcust.RESET;
                Dcust.SETRANGE(Dcust."Customer No.", "Loan Application"."No.");
                Dcust.SETFILTER(Dcust."Posting Date", DFilter);
                Dcust.SETFILTER(Dcust."Credit Amount", '>%1', 0);
                if Dcust.FINDSET then begin
                    Dcust.CALCSUMS("Credit Amount");
                    DecCont := Dcust."Credit Amount";
                end;
            end;

            trigger OnPreDataItem();
            begin
                if AsAt = 0D then
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

                //MESSAGE('Year %1',Period);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("As At"; AsAt)
                {
                    Caption = 'As At';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
    end;

    trigger OnPreReport();
    begin

        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        AsAt: Date;
        FirstDateOfTheYear: Date;
        OpenBal: Decimal;
        DDate: Date;
        Dcust: Record "Detailed Cust. Ledg. Entry";
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
        Memb: Record Member;
        Company: Code[80];
        Deposits: Decimal;
        Vendor: Record Vendor;
}

