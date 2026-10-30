page 50315 "Dividend Subform"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Dividend Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("National ID"; "National ID")
                {

                }
                field("Phone No"; "Phone No")
                {

                }
                field("District"; "District ")
                {

                }
                field(Section; Section)
                {

                }
                field("Member Deposits Amount"; "Member Deposits Amount")
                {

                }
                field("Share Capital Amount"; "Share Capital Amount")
                {

                }
                field("Gross Earning Amount"; "Gross Earning Amount")
                {
                    ApplicationArea = All;
                }
                field("Excise Duty Amount"; "Excise Duty Amount")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Amount"; "Withholding Tax Amount")
                {
                    ApplicationArea = All;
                }

                field("Net Earning Amount"; "Net Earning Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Dividends")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    DividendHeader.GET("Document No.");
                    DividendHeader.TESTFIELD(Status, DividendHeader.Status::New);
                    CalculateDividends.SetDocumentNo("Document No.", DividendHeader."Calculation End Date");
                    CalculateDividends.RUN;
                end;
            }
            action("Send SMS")
            {
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    DividendHeader.GET("Document No.");
                    DividendHeader.TESTFIELD(Posted, TRUE);
                    DividendHeader.SETRECFILTER;
                    REPORT.RUN(REPORT::"Send Dividend Notice", TRUE, FALSE, DividendHeader)
                end;
            }
        }
    }



    var
        CalculateDividends: Report "Calculate Dividends";
        DividendHeader: Record "Dividend Header";
}

